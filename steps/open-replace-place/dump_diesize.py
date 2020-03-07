#! /usr/bin/env python
#=========================================================================
# dump_die_size.py
#=========================================================================
# Reads the yosys synthesis stats to get area estimate, and then
# determines the die size assuming an aspect ratio of 1.0 and a density
# target of 0.8.
#
# The dimensions are in units of the tech lef site size.
#
#  -h --help     Display this message
#  -v --verbose  Verbose mode
#
# Author : Christopher Torng
# Date   : June 19, 2019
#

import argparse
import math
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
  p.add_argument(       "--site",    required=True       )
  p.add_argument(       "--density", required=True       )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  #-----------------------------------------------------------------------
  # Read tech lef
  #-----------------------------------------------------------------------
  # We need to make sure our chosen die dimensions are a multiple of the
  # tech lef site sizes.
  #

  with open( 'inputs/adk/rtk-tech.lef' ) as fd:
    lines = fd.readlines()

  # Expecting a site declaration that looks like this:
  #
  #   SITE FreePDK45_38x28_10R_NP_162NW_34O
  #     SYMMETRY y ;
  #     CLASS core ;
  #     SIZE 0.19 BY 1.4 ;
  #   END FreePDK45_38x28_10R_NP_162NW_34O
  #

  site_lines = []

  for i, l in enumerate( lines ):
    if re.search( 'SITE ' + opts.site, l ):
      site_lines = lines[i:]
      break

  size_line = [ l for l in site_lines if 'SIZE' in l ][0]

  tech_lef_x_size = float( size_line.split()[1] )
  tech_lef_y_size = float( size_line.split()[3] )

  #-----------------------------------------------------------------------
  # Read yosys stats
  #-----------------------------------------------------------------------

  with open( 'inputs/synth.stats.txt' ) as fd:
    lines = fd.readlines()

  area_line = [ l for l in lines if 'Chip area for module' in l ][0]

  area = float( area_line.split()[-1] )

  #-----------------------------------------------------------------------
  # Choose dimensions
  #-----------------------------------------------------------------------

  # Target density

  target_area = area / float(opts.density)

  # Target a square aspect ratio

  x_dim = math.sqrt( target_area )
  y_dim = math.sqrt( target_area )

  # Snap to the tech lef sizes

  x_dim = int( x_dim / tech_lef_x_size ) * tech_lef_x_size
  y_dim = int( y_dim / tech_lef_y_size ) * tech_lef_y_size

  # Dump to file

  with open( 'design.diesize.sh', 'w' ) as fd:
    fd.write( 'export die_size_x='+ str(x_dim) + '\n' )
    fd.write( 'export die_size_y='+ str(y_dim) + '\n' )

main()

