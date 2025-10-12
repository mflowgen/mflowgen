#! /usr/bin/env python
#=========================================================================
# combine_opts.py
#=========================================================================
# Combines YAML from:
#
# - inputs/opts.yml
# - extra-opts.yml
# - os.environ['extra_opts']
#
# and then produces an output YAML.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -o --out      Output YAML
#
# Author : Christopher Torng
# Date   : January 20, 2025
#

import argparse
import os
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
  p.add_argument( "-o", "--out",     default="opts.yml"  )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  input_yaml = 'inputs/opts.yml'
  node_yaml  = './extra-opts.yml'

  extra_opts = os.environ['extra_opts']
  extra_opts = extra_opts.split(',') if extra_opts != 'None' else []

  out_yaml   = opts.out

  # Read the input YAML

  with open( input_yaml ) as f:
    data_A = yaml.load( f, Loader=yaml.FullLoader )

  # Read the node YAML

  with open( node_yaml ) as f:
    data_B = yaml.load( f, Loader=yaml.FullLoader )

  # Grab data from "extra_opts" parameter

  data_C = extra_opts
  print( 'Info: Adding extra opts:', data_C )

  # Combine all the data by concatenating the lists

  data = data_A + data_B + data_C

  # Dump the data into an output YAML

  with open( out_yaml, 'w' ) as f:
    yaml.dump( data, f, default_flow_style=False )

main()

