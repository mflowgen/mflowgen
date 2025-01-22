#! /usr/bin/env python
#=========================================================================
# yml2str.py
#=========================================================================
# Converts a flat list within a YAML file into a space-separated string
# and then dumps it to a file to be passed into downstream tools.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#
# Author : Christopher Torng
# Date   : January 20, 2025
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
  p.add_argument( "-v", "--verbose", action="store_true"       )
  p.add_argument( "-h", "--help",    action="store_true"       )
  p.add_argument(       "--infile",  default="inputs/opts.yml" )
  p.add_argument(       "--outfile", required=True             )
  p.add_argument(       "--append",  action="store_true"       )
  p.add_argument(       "--line",    action="store_true"       )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  # Read the input YAML

  with open( opts.infile ) as f:
    data = yaml.load( f, Loader=yaml.FullLoader )

  # Convert 1D list to space- or newline-separated string

  if opts.line:
    data_str = '\n'.join( data ) + '\n'
  else:
    data_str = ' '.join( data ) + ' '

  # Dump to file

  mode = 'w' if not opts.append else 'a'

  with open( opts.outfile, mode ) as f:
    f.write( data_str )

main()


