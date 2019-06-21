#! /usr/bin/env python
#=========================================================================
# fix-def.py
#=========================================================================
# Fix the generated .def to be usable with klayout.
# Example: \in.q.msg[0]\ will be turned into \in.q.msg[0]
#
#
#  -h --help     Display this message
#  --def-file    Specify the name of the .def file
#
# Author : Peitian Pan
# Date   : June 20, 2019

import argparse
import os
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
  def valid_def(string):
    assert string[-4:] == ".def" and os.path.isfile(string) and \
           os.path.exists(string), "the given path is not a .def file!"
    return string
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-h", "--help", action="store_true" )
  p.add_argument( "--def-file", type=valid_def )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  def_file = opts.def_file
  tmp_def_file = opts.def_file + ".tmp"

  tmp_list = []

  # Read the lines
  with open( def_file, "r" ) as fd:
    lines = fd.readlines()

  # Scan through all lines and try to find lines:
  # 1) whose last character is '\'
  # 2) the first character of the next line is '+'
  # If this line is found, we will strip off the last '\' in the current line
  for idx, line in enumerate(lines):
    _line = line.split()
    _tmp = line
    if len(line) > 1 and idx != (len(lines)-1):
      if (line[-2] == '\\') and (lines[idx+1][0] == "+"):
        _tmp = line[:-2] + "\n"
    tmp_list.append( _tmp )

  # Dump to the temporary file
  with open( tmp_def_file, "w" ) as fd:
    fd.write( "".join( tmp_list ) )

  # Rename the temporary file to the .def file
  os.rename( tmp_def_file, def_file )


main()

