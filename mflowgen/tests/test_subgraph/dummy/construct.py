#=========================================================================
# construct.py
#=========================================================================
# Dummy graph for testing graph construction with Subgraphs
#
# Author : Alex Carsello
# Date   : Sept. 14, 2023
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

  dummy_input  = Node( this_dir + '/dummy_input'  )
  dummy_output = Node( this_dir + '/dummy_output' )

  # Subgraphs

  passthrough_subgraph = Subgraph( this_dir + '/../passthrough', 'passthrough' )

  # Default nodes

  info    = Node( 'info',                 default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_node( info                 )
  g.add_node( dummy_input          )
  g.add_node( passthrough_subgraph )
  g.add_node( dummy_output         )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  g.connect_by_name( dummy_input, passthrough_subgraph  )
  g.connect_by_name( passthrough_subgraph, dummy_output )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()

