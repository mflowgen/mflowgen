#! /usr/bin/env python
#=========================================================================
# setup_graph.py
#=========================================================================
# Example for creating a graph for ( a*b + c*d ) sum of products
#
# Author : Christopher Torng
# Date   : June 6, 2019
#

import os
import sys

if __name__ == '__main__':
  sys.path.append( '../..' )

from mflow.components import Graph, Step

#-------------------------------------------------------------------------
# setup_graph
#-------------------------------------------------------------------------

def setup_graph():

  # Four steps to make a peanut butter and jelly sandwich

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  ab   = Step( this_dir + '/extra-steps/a_times_b' )
  cd   = Step( this_dir + '/extra-steps/c_times_d' )
  sum_ = Step( this_dir + '/extra-steps/sum' )

  # Create the graph
  #
  #     +-----------+   +-----------+
  #     | a_times_b |   | c_times_d |
  #     +-----------+   +-----------+
  #             \        /
  #      ab.txt  \      /  cd.txt
  #               \    /
  #             +--------+
  #             |  sum   |
  #             +--------+
  #                 |
  #                 v
  #
  #              sum.txt
  #

  g = Graph()

  # Add steps

  g.add_step( ab )
  g.add_step( cd )
  g.add_step( sum_ )

  # Add edges

  g.connect_by_name( ab, sum_ )
  g.connect_by_name( cd, sum_ )

  return g

if __name__ == '__main__':
  setup_graph()

