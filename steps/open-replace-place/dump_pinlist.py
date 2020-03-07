#! /usr/bin/env python
#=========================================================================
# dump_pinlist.py
#=========================================================================
# Bitblasts the ports of 'inputs/design.v' and dumps the list of ports to
# 'design.pinlist.txt'
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#
# Author : Christopher Torng
# Date   : June 19, 2019
#

import argparse
import re
import sys

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

  with open( 'inputs/design.v' ) as fd:
    lines = fd.readlines()

  # Get the ports
  #
  # - The netlist should be flattened, so we only expect one module
  #

  module_line = \
    [ l for l in lines if l.startswith('module') ][0]

  ports = re.search( r'\((.*)\)', module_line ).group(1).split(',')
  ports = [ p.strip() for p in ports ]

  # Get inputs

  ports_bitblasted = []

  for p in ports:

    # Grab input and output declarations in the netlist (there should only
    # be one of these)

    # Escape backslashes and dollar signs for RE engine
    _p = p.replace("\\", "\\\\").replace("$", r"\$")

    i_lines = [ l for l in lines if re.search( r' input .*'  + _p, l ) ]
    o_lines = [ l for l in lines if re.search( r' output .*' + _p, l ) ]

    port_declaration_lines = i_lines + o_lines
    assert len( port_declaration_lines ) == 1

    port_declaration = port_declaration_lines[0]
    tokens = port_declaration.split()

    # Remove leading backslash
    if p.startswith("\\"):
      _p = p[1:]
    else:
      _p = p

    # Check if this is an array. If it is, then bitblast and append each
    # port to the ports list.

    if tokens[1].startswith('[') and tokens[1].endswith(']'):
      indices = tokens[1].strip('[]').split(':')
      indices = sorted( indices )
      for i in range( int(indices[0]), int(indices[1])+1 ):
        ports_bitblasted.append( _p + '[' + str(i) + ']' )

    # If not, just put the port in the ports list

    ports_bitblasted.append( _p )

  # Dump the port list

  with open( 'design.pinlist.txt', 'w' ) as fd:
    fd.write( '\n'.join( ports_bitblasted ) )

main()

