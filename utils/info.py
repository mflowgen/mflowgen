#! /usr/bin/env python
#=========================================================================
# info.py
#=========================================================================
# Reads the configure.yml of an mflowgen step and pretty prints content.
#
# For example, the synthesis node might look like this:
#
#            |       |             |               |
#            v       v             v               v
#         +---------------------------------------------+
#         | adk | design.v | constraints.tcl | run.saif |
#         +---------------------------------------------+
#         |                                             |
#         |           synopsys-dc-synthesis             |
#         |                                             |
#         +---------------------------------------------+
#         |  design.v  |  design.sdc  | design.namemap  |
#         +---------------------------------------------+
#              |           |              |
#              v           v              v
#
#     Parameters
#
#     - clock_period   : 2.0
#     - design_name    : GcdUnit
#     - flatten_effort : 0
#     - nthreads       : 16
#     - topographical  : true
#
#     Flags
#
#     - sandbox : False
#
#     Source Directory
#
#     - /path/to/synopsys-dc-synthesis
#
# This output is meant to look like the graph.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -y --config   Path to the step configure.yml to parse
#
# Author : Christopher Torng
# Date   : March 5, 2020
#

from __future__ import print_function
import argparse
import functools
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
  p = ArgumentParserWithCustomError( add_help = False )
  p.add_argument( "-v", "--verbose", action="store_true" )
  p.add_argument( "-h", "--help",    action="store_true" )
  p.add_argument( "-y", "--config",  required=True       )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():

  opts = parse_cmdline()

  # Read the configure.yml

  with open( opts.config, 'r' ) as fd:
    try:
      data = yaml.load( fd, Loader=yaml.FullLoader )
    except AttributeError:
      # PyYAML for python2 does not have FullLoader
      data = yaml.load( fd )

  #-----------------------------------------------------------------------
  # Graph Visual
  #-----------------------------------------------------------------------

  name = data['name']

  # Grab the inputs and outputs

  try:
    inputs  = data['inputs']
  except KeyError:
    inputs = []

  try:
    outputs = data['outputs']
  except KeyError:
    outputs = []

  # Start drawing ASCII
  #
  # nchars is the length
  #
  #     inputs_str  --> '| adk | design.v | constraints.tcl | run.saif |'
  #     outputs_str --> '|  |'
  #
  #                      ^-----------------  n_chars  -----------------^

  inputs_str  = '| ' + ' | '.join( inputs  ) + ' |'
  outputs_str = '| ' + ' | '.join( outputs ) + ' |'
  name_str    = '| ' + name                  + ' |'

  n_chars = max( len(inputs_str), len(outputs_str), len(name_str) )

  # Recenter the shorter string so that this:
  #
  #     '| foo | bar |'
  #
  # becomes this based on the given length:
  #
  #     '|     foo     |     bar     |'
  #
  # The input string x _must_ have a non-whitespace char on both sides.

  def recenter( x, length ):
    tokens       = [ t.strip() for t in x.split() ]
    extra_space  = length - len( ''.join(tokens) )
    n_items      = len( tokens )
    space_per    = int( extra_space / ( n_items - 1 ) )
    space_left   = int( extra_space % ( n_items - 1 ) )
    spacer       = space_per * ' '
    spaced_str   = spacer.join( tokens )
    spaced_str_f = spaced_str[:-1] + ' '*space_left + spaced_str[-1:]
    return spaced_str_f

  inputs_str  = recenter( inputs_str,  n_chars )
  outputs_str = recenter( outputs_str, n_chars )
  name_str    = recenter( name_str,    n_chars )

  # Arrows
  #
  # Turn this:
  #
  #     '|     foo     |     bar     |'
  #
  # into this:
  #
  #     '       V             V       '
  #

  def arrowify( x ):
    # No arrows for an empty string "|      |"
    if x[1:-1].strip() == '':
      return ''
    # Create arrows
    tokens     = x.split('|')
    token_lens = [ len(t) for t in tokens ]
    templates  = [ '{:^' + str(t) + '}' if t else '' for t in token_lens ]
    arrows     = [ t.format('V') for t in templates ]
    arrows_str = ' '.join( arrows )
    return arrows_str

  input_arrows_1_str  = arrowify( inputs_str ).replace('V','|')
  input_arrows_2_str  = arrowify( inputs_str )
  output_arrows_1_str = arrowify( outputs_str ).replace('V','|')
  output_arrows_2_str = arrowify( outputs_str )

  # Lines
  #
  #     +---------------+    <-- dash_line_str
  #     |               |    <-- empty_line_str
  #

  dash_line_str       = '+' + '-'*(n_chars-2) + '+'
  empty_line_str      = '|' + ' '*(n_chars-2) + '|'
  center_template_str = '{:^' + str(n_chars) + '}'

  print()
  print( ' '*4 + input_arrows_1_str )
  print( ' '*4 + input_arrows_2_str )
  print( ' '*4 + dash_line_str  )
  print( ' '*4 + center_template_str.format( inputs_str ) )
  print( ' '*4 + dash_line_str  )
  print( ' '*4 + empty_line_str )
  print( ' '*4 + center_template_str.format( name_str ) )
  print( ' '*4 + empty_line_str )
  print( ' '*4 + dash_line_str  )
  print( ' '*4 + center_template_str.format( outputs_str ) )
  print( ' '*4 + dash_line_str  )
  print( ' '*4 + output_arrows_1_str )
  print( ' '*4 + output_arrows_2_str )
  print()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  def print_list( v ):
    for _ in v:
      print( '  - ' + _ )

  if 'parameters' in data.keys():

    p_width      = max( [ len(p) for p in data['parameters'] ] )
    template_str ='- {:' + str(p_width) + '} : {}'

    print( 'Parameters\n' )
    for k, v in data['parameters'].items():
      if type(v) == list:
        print( '- ' + k )
        print_list( v )
      else:
        print( template_str.format( k, v ) )
    print()

  #-----------------------------------------------------------------------
  # Flags
  #-----------------------------------------------------------------------

  flags = {}

  if 'sandbox' in data.keys():
    flags = { 'sandbox' : data['sandbox'] }

  if flags:

    p_width      = max( [ len(f) for f in flags ] )
    template_str ='- {:' + str(p_width) + '} : {}'

    print( 'Flags\n' )
    for k, v in flags.items():
      print( template_str.format( k, v ) )
    print()

  #-----------------------------------------------------------------------
  # Source Directory
  #-----------------------------------------------------------------------

  print( 'Source Directory\n' )
  print( '- ' + data['source'] )
  print()

main()




