#=========================================================================
# construct.py
#=========================================================================
# Dummy graph for testing graph construction with Subgraphs. Contains
# Passthough subgraph that fans out input to 2 passthrough nodes to test
# Subgraph input fanout.
#
# Author : Alex Carsello
# Date   : Oct. 4, 2023
#

import os

from mflowgen.components import Graph, Step, Subgraph

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

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # Custom steps

  dummy_input  = Step( this_dir + '/../dummy/dummy_input'  )
  dummy_output = Step( this_dir + '/../dummy/dummy_output' )

  # Subgraphs

  passthrough_subgraph = Subgraph( this_dir + '/../double_passthrough', 'double_passthrough' )

  # Default steps

  info    = Step( 'info',                 default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info                 )
  g.add_step( dummy_input          )
  g.add_step( passthrough_subgraph )
  g.add_step( dummy_output         )

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

