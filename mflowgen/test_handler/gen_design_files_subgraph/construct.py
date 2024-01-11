#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Author :
# Date   :
#

import os
import sys

from mflowgen.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # Default steps
  gen_files = Step( 'cadence-innovus-gen-design-files', default=True )

  # Add graph inputs and outputs so this can be used in hierarchical flows

  # Inputs
  g.add_input( 'design.checkpoint', \
               gen_files.i( 'design.checkpoint' ) \
             )
  g.add_input( 'innovus-foundation-flow', \
               gen_files.i( 'innovus-foundation-flow' ) \
             )
  g.add_input( 'adk', \
               gen_files.i( 'adk' ) \
             )

  outputs = [
    'design.gds.gz',
    'design-merged.gds',
    'design.lvs.v',
    'design.vcs.v',
    'design.vcs.pg.v',
    'design.lef',
    'design.pt.sdc',
    'design.sdf',
    'design.virtuoso.v',
    'design.def.gz'
  ]

  for output in outputs:
    g.add_output( output, gen_files.o( output ) )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( gen_files )

  return g


if __name__ == '__main__':
  g = construct()

