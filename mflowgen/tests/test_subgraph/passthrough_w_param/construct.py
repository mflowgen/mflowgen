#=========================================================================
# construct.py
#=========================================================================
# Dummy subgraph that contains a passthrough node.
#
# Author : Alex Carsello
# Date   : Sept. 8, 2023
#

import os

from mflowgen.components import Graph, Step, Subgraph

def construct(test_param='foo', test_param_2='bar'):

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
    'test_param'     : test_param
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # Custom steps

  passthrough = Step( this_dir + '/passthrough' )

  # Default steps

  info    = Step( 'info',                 default=True )

  # Subgraph Inputs

  g.add_input( 'foo', passthrough.i( 'i' ) )

  # Subgraph Outputs

  g.add_output( 'bar', passthrough.o( 'o' ) )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info        )
  g.add_step( passthrough )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()

