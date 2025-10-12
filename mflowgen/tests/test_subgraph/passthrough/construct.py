#=========================================================================
# construct.py
#=========================================================================
# Dummy subgraph that contains a passthrough node.
#
# Author : Alex Carsello
# Date   : Sept. 8, 2023
#

import os

from mflowgen.components import Graph, Node, Subgraph

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  adk_name = 'freepdk-45nm'
  adk_view = 'view-tiny'

  parameters = {
    'construct_path' : __file__,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK node

  g.set_adk( adk_name )
  adk = g.get_adk_node()

  # Custom nodes

  passthrough = Node( this_dir + '/passthrough' )

  # Default nodes

  info    = Node( 'info',                 default=True )

  # Subgraph Inputs

  g.add_input( 'foo', passthrough.i( 'i' ) )

  # Subgraph Outputs

  g.add_output( 'bar', passthrough.o( 'o' ) )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_node( info        )
  g.add_node( passthrough )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()

