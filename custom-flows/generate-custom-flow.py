#! /usr/bin/env python
#=========================================================================
# generate-custom-flow.py
#=========================================================================
# Generates a new custom flow using symlinks pointing to the default flow.
# This means that the new custom flow uses the default flow by default
# (via symlinks), but the user can replace the default symlinks with a
# different version wherever customization is needed.
#
# For example, to use the default flow but customize only the dc-synthesis
# constraints, we would just delete the generated symlink located at
# "plugins/dc-synthesis/constraints.tcl" and then we would create a new
# "constraints.tcl", while leaving all other default symlinks in place.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -n --name     Name of the custom flow to generate
#
# Author : Christopher Torng
# Date   : October 11, 2018

import argparse
import sys
import os

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
  p.add_argument( "-n", "--name",    required=True       )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  # Create the directory for the new flow

  os.mkdir( opts.name )
  os.chdir( opts.name )

  # Pull in the default setup Makefile fragments

  os.system( "cp -f ../../setup-flow.mk ." )
  os.system( "cp -f ../../setup-design.mk ." )
  os.system( "cp -f ../../setup-adk.mk ." )

  # Create plugins

  os.mkdir( "plugins" )
  os.chdir( "plugins" )

  # Set up symlinks to default plugins

  os.system( "for x in ../../../plugins/*; do mkdir $(basename $x); done" )
  os.system( "for x in *; do cd $x; ln -s ../../../../plugins/$x/* .; cd ..; done" )

main()


