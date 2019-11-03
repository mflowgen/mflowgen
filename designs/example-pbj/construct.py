#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Example for creating a graph for a peanut and butter jelly sandwich
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os
import sys

from mflow.components import Graph, Step

def construct():

  # Four steps to make a peanut butter and jelly sandwich

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  bread         = Step( this_dir + '/extra-steps/bread' )
  peanut_butter = Step( this_dir + '/extra-steps/peanut_butter' )
  jelly         = Step( this_dir + '/extra-steps/jelly' )
  sandwich      = Step( this_dir + '/extra-steps/sandwich' )

  # Create the graph
  #
  #             +-------+
  #             | bread |
  #             +-------+
  #               /   \
  #      slice 1 /     \ slice 2
  #             /       \
  #     +-------+       +---------------+
  #     | jelly |       | peanut butter |
  #     +-------+       +---------------+
  #             \       /
  #       jelly  \     /  peanut butter
  #       slice   \   /   slice
  #                \ /
  #            +----------+
  #            | sandwich |
  #            +----------+
  #

  g = Graph()

  g.add_step( bread )
  g.add_step( peanut_butter )
  g.add_step( jelly )
  g.add_step( sandwich )

  # Add edges -- bread slice 1 -> jelly

  g.connect(
    bread.o( 'slice1.txt' ),
    jelly.i( 'slice_of_bread.txt' ),
  )

  # Add edges -- bread slice 2 -> peanut butter

  g.connect(
    bread.o( 'slice2.txt' ),
    peanut_butter.i( 'slice_of_bread.txt' ),
  )

  # Add edges -- jelly slice -> sandwich

  g.connect(
    jelly.o( 'jelly_on_bread.txt' ),
    sandwich.i( 'half_1.txt' ),
  )

  # Add edges -- peanut butter slice -> sandwich

  g.connect(
    peanut_butter.o( 'peanut_butter_on_bread.txt' ),
    sandwich.i( 'half_2.txt' ),
  )

  return g

if __name__ == '__main__':
  construct()

