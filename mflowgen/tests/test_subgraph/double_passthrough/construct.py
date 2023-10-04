#=========================================================================
# construct.py
#=========================================================================
# Dummy Subgraph that fans input out to 2 passthrough nodes.
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

  passthrough = Step( this_dir + '/../passthrough/passthrough' )
  
  # Clone of passthrough
  passthrough_2 = passthrough.clone()
  passthrough_2.set_name( 'passthrough_2' )

  # Default steps

  info    = Step( 'info',                 default=True )

  # Subgraph Inputs

  g.add_input( 'foo', passthrough.i( 'i' ), passthrough_2.i( 'i' ) )
  
  # Subgraph Outputs

  g.add_output( 'bar', passthrough.o( 'o' ) )
  g.add_output( 'bar2', passthrough_2.o( 'o' ) )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info          )
  g.add_step( passthrough   )
  g.add_step( passthrough_2 )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()

