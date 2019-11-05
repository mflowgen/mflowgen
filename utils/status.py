#! /usr/bin/env python
#=========================================================================
# status.py
#=========================================================================
# Print build status for each step
#
# The output should look something like this:
#
#     Status:
#
#      - done  ->  0 : info
#      - done  ->  1 : freepdk-45nm
#      - done  ->  2 : constraints
#      - build ->  3 : cadence-innovus-plugins
#      - build ->  4 : rtl
#      - build ->  5 : synopsys-dc-synthesis
#      - build ->  6 : cadence-innovus-flowsetup
#      - build ->  7 : cadence-innovus-place-route
#
# The status is generated from the dry run commands dumped by the build
# tool (e.g., make -n).
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#  -b --backend  Build tool (e.g., make)
#  -s --steps    Comma-separated list of ordered steps (e.g., "2-foo,1-bar")
#
# Author : Christopher Torng
# Date   : November 3, 2019
#

from __future__ import print_function
import argparse
import re
import subprocess
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
  p.add_argument( "-b", "--backend", default="make"      )
  p.add_argument( "-s", "--steps",   required=True       )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():

  opts = parse_cmdline()

  # Dump dry run commands from build tool

  if opts.backend == 'make':
    text  = subprocess.check_output([ 'make', '-n' ])
    # Convert ascii byte array to string.
    if type( text ) != str:
      text = ''.join( map( chr, text ) )
    lines = text.split('\n')
  else:
    assert False, 'Cannot get status from build tool ' + opts.backend

  # Identify steps that must be rebuilt (i.e., check if the dry run
  # commands show that the output stamps need to be updated)

  steps = opts.steps.split(',')

  echo_green   = '\033[92m'
  echo_red     = '\033[91m'
  echo_nocolor = '\033[0m'

  done_str  = echo_green + 'done ' + echo_nocolor
  build_str = echo_red   + 'build' + echo_nocolor

  status = { s: done_str for s in steps }

  for s in steps:
    if any([ re.match( r'touch ' + s + '/outputs/.*stamp', l ) for l in lines ]):
      status[s] = build_str

  # Get the upcoming build order (by filtering the dry run commands for
  # commands that touch output stamps)

  order = []

  for l in lines:
    m = re.match( 'touch ([^/]+)/outputs/.*stamp', l )
    if m:
      s = m.group(1)
      if s not in order:
        order.append( s )

  # Report build order

  print()
  print( 'Upcoming build order:' )
  print()

  for step in order:
    print( ' - ' + step )

  # Report status

  print()
  print( 'Status:' )
  print()

  template_str = ' - {status} -> {number:2} : {name}'

  for step, status in sorted( status.items(), # sort in numerical order
                              key=lambda x: int(x[0].split('-')[0]) ):
    tokens = step.split('-')
    d = {
      'status' : status,
      'number' : tokens[0],
      'name'   : '-'.join(tokens[1:]),
    }
    print( template_str.format( **d ) )

  print()

main()


