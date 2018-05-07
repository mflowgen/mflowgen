#!/usr/bin/env python
#===============================================================================
# convert_pytest_to_yaml.py
#===============================================================================
# This script converts a "py.test --collect-only" dump into a yaml file
# with tests. For example, the py.test output may look like this:
#
#     collected 5 items
#     <Module 'HostGcdUnit/HostGcdUnit_test.py'>
#       <Function 'test[basic_0x0]'>
#       <Function 'test[basic_5x0]'>
#       <Function 'test[basic_0x5]'>
#       <Function 'test[basic_3x9]'>
#       <Function 'test[random_3x9]'>
#
# The output YAML will look like this:
#
#     HostGcdUnit/HostGcdUnit_test.py:
#     - basic_0x0
#     - basic_5x0
#     - basic_0x5
#     - basic_3x9
#     - random_3x9
#
# This will then be used as the reference list for all runnable test cases
# at each level of testing in the asic flow.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -f --file     Name of a dump from "py.test --collect-only"
#     --out      Name of the output YAML file
#
# Author : Christopher Torng
# Date   : May 5, 2018
#

import argparse
import sys
import re
import yaml

#-------------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------------

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
  p.add_argument( "-v", "--verbose", action="store_true"   )
  p.add_argument( "-h", "--help",    action="store_true"   )
  p.add_argument( "-f", "--file"                           )
  p.add_argument(       "--out", default="test-cases.yaml" )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  # Read the list of tests (should come from py.test --collect-only)

  with open( opts.file, 'r' ) as fd:
    lines = fd.readlines()

  # Populate the dictionary of tests
  #
  # - "<Module...>"   : becomes the name of a test group
  # - "<Function...>" : becomes the name of a test case in a test group

  tests = {}
  current_test_group = ''

  for line in lines:
    line = line.strip()

    # Search for a test group and add it to the dictionary

    match = re.match( r"<Module '(.*)'>", line )
    if match:
      test_group          = match.group(1)
      tests[ test_group ] = []
      current_test_group  = test_group

    # Search for a test case and add it to the current test group

    match = re.match( r"<Function 'test\[(.*)\]'>", line )
    if match:
      test_case = match.group(1)
      tests[ current_test_group ].append( test_case )

  # Now we dump "tests" dictionary into the YAML file

  with open( opts.out, 'w' ) as fd:
    yaml.dump( tests, fd, default_flow_style=False )

main()

