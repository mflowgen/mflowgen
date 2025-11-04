#! /usr/bin/env python
#=========================================================================
# generate-synth.py
#=========================================================================
# Yosys does not read environment variables. This script generates the
# yosys synthesis script from a template to populate the variables.
#
# The variables are read from:
#
# - configure.yml
# - adk.tcl
#
# The ADK tcl specifies some of the cells we need (e.g., tie high / low).
#
# This script also dumps "constraints.tcl" for yosys to use with abc.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#
# Author : Christopher Torng
# Date   : June 18, 2019
#

import argparse
import sys
import yaml

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

class ArgumentParserWithCustomError(argparse.ArgumentParser):
  def error( self, msg = "" ):
    if ( msg ): print("\n ERROR: %s" % msg)
    print("")
    file = open( sys.argv[0] )
    for ( lineno, line ) in enumerate( file ):
      if ( line[0] != '#' ): sys.exit(msg != "")
      if ( (lineno == 2) or (lineno >= 4) ): print( line[1:].rstrip("\n") )

def parse_cmdline():
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-v", "--verbose", action="store_true" )
  p.add_argument( "-h", "--help",    action="store_true" )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  #-----------------------------------------------------------------------
  # Read the variables
  #-----------------------------------------------------------------------

  data = {}

  # Configure YAML

  with open( 'configure.yml' ) as fd:
    try:
      data_cfg = yaml.load( fd, Loader=yaml.FullLoader )['parameters']
    except AttributeError:
      # PyYAML for python2 does not have FullLoader
      data_cfg = yaml.load( fd )['parameters']

  data.update( data_cfg )

  data.update( {
    'clock_period_ps' : data_cfg['clock_period'] * 1000,
    'constraints_tcl' : 'constraints.tcl',
  } )

  # ADK tcl
  #
  # We need these variables:
  #
  # - ADK_TIE_HI_CELL -- name of the tie-high cell
  # - ADK_TIE_LO_CELL -- name of the tie-low cell
  # - ADK_TIE_HI_PORT -- name of the output port of the tie-high cell
  # - ADK_TIE_LO_PORT -- name of the output port of the tie-low cell
  #
  # - ADK_MIN_BUF_CELL   -- name of minimum-sized buffer cell
  # - ADK_MIN_BUF_PORT_I -- name of the input port for the min buf cell
  # - ADK_MIN_BUF_PORT_O -- name of the output port for the min buf cell
  #
  # - ADK_TYPICAL_ON_CHIP_LOAD -- typical on-chip load in lib units
  #

  with open( 'inputs/adk/adk.tcl' ) as fd:
    adk_lines = fd.readlines()

  tie_hi_cell_line = [ l for l in adk_lines if 'set ADK_TIE_HI_CELL ' in l ]
  tie_lo_cell_line = [ l for l in adk_lines if 'set ADK_TIE_LO_CELL ' in l ]
  tie_hi_port_line = [ l for l in adk_lines if 'set ADK_TIE_HI_PORT ' in l ]
  tie_lo_port_line = [ l for l in adk_lines if 'set ADK_TIE_LO_PORT ' in l ]

  min_buf_cell_line = [ l for l in adk_lines if 'set ADK_MIN_BUF_CELL ' in l ]
  min_buf_p_i_line  = [ l for l in adk_lines if 'set ADK_MIN_BUF_PORT_I ' in l ]
  min_buf_p_o_line  = [ l for l in adk_lines if 'set ADK_MIN_BUF_PORT_O ' in l ]

  on_chip_load_line = \
    [ l for l in adk_lines if 'set ADK_TYPICAL_ON_CHIP_LOAD ' in l ]

  assert len( tie_hi_cell_line ) == 1, \
    'Error: Did not find variable $ADK_TIE_HI_CELL in adk.tcl'

  assert len( tie_lo_cell_line ) == 1, \
    'Error: Did not find variable $ADK_TIE_LO_CELL in adk.tcl'

  assert len( tie_hi_port_line ) == 1, \
    'Error: Did not find variable $ADK_TIE_HI_PORT in adk.tcl'

  assert len( tie_lo_port_line ) == 1, \
    'Error: Did not find variable $ADK_TIE_LO_PORT in adk.tcl'

  assert len( min_buf_cell_line ) == 1, \
    'Error: Did not find variable $ADK_MIN_BUF_CELL in adk.tcl'

  assert len( min_buf_p_i_line ) == 1, \
    'Error: Did not find variable $ADK_MIN_BUF_PORT_I in adk.tcl'

  assert len( min_buf_p_o_line ) == 1, \
    'Error: Did not find variable $ADK_MIN_BUF_PORT_O in adk.tcl'

  assert len( on_chip_load_line ) == 1, \
    'Error: Did not find variable $ADK_TYPICAL_ON_CHIP_LOAD in adk.tcl'

  tie_hi_cell = tie_hi_cell_line[0].split()[-1].strip('"')
  tie_lo_cell = tie_lo_cell_line[0].split()[-1].strip('"')
  tie_hi_port = tie_hi_port_line[0].split()[-1].strip('"')
  tie_lo_port = tie_lo_port_line[0].split()[-1].strip('"')

  min_buf_cell   = min_buf_cell_line[0].split()[-1].strip('"')
  min_buf_port_i = min_buf_p_i_line[0].split()[-1].strip('"')
  min_buf_port_o = min_buf_p_o_line[0].split()[-1].strip('"')

  on_chip_load = on_chip_load_line[0].split()[-1].strip('"')

  data.update( {
    'tie_hi_cell'     : tie_hi_cell,
    'tie_lo_cell'     : tie_lo_cell,
    'tie_hi_port'     : tie_hi_port,
    'tie_lo_port'     : tie_lo_port,
    'min_buf_cell'    : min_buf_cell,
    'min_buf_port_i'  : min_buf_port_i,
    'min_buf_port_o'  : min_buf_port_o,
  })

  #-----------------------------------------------------------------------
  # Populate the synth script template
  #-----------------------------------------------------------------------

  with open( 'synth.ys.template' ) as fd:
    template = fd.read()

  with open( 'synth.ys', 'w' ) as fd:
    fd.write( template.format( **data ) )

  # Dump constraints.tcl for yosys to use with abc

  with open( 'constraints.tcl', 'w' ) as fd:
    fd.write( 'set_driving_cell ' + min_buf_cell + '\n' )
    fd.write( 'set_load ' + on_chip_load + '\n' )


main()

