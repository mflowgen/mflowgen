#=========================================================================
# construct.py
#=========================================================================
# Demo with 16-bit GcdUnit
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os

from mflowgen.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  adk_name = 'freepdk-45nm'
  adk_view = 'view-tiny'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'GcdUnit',
    'clock_period'   : 2.0,
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

  rtl = Step( this_dir + '/rtl' )

  # Default steps

  info    = Step( 'info',                 default=True )
  yosys   = Step( 'open-yosys-synthesis', default=True )
  #replace = Step( 'open-replace-place',   default=True )
  graywolf = Step( 'open-graywolf-place', default=True )
  qrouter  = Step( 'open-qrouter-route',  default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info     )
  g.add_step( rtl      )
  g.add_step( yosys    )
  #g.add_step( replace  )
  g.add_step( graywolf )
  g.add_step( qrouter  )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  g.connect_by_name( rtl, yosys )
  g.connect_by_name( adk, yosys )

  #g.connect_by_name( adk,   replace )
  #g.connect_by_name( yosys, replace )
  g.connect_by_name( adk,   graywolf )
  g.connect_by_name( yosys, graywolf )

  g.connect_by_name( adk,      qrouter )
  #g.connect_by_name( replace,  qrouter )
  g.connect_by_name( graywolf, qrouter )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g


if __name__ == '__main__':
  g = construct()
#  g.plot()

