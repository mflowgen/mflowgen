#! /usr/bin/env python
#=========================================================================
# setup_graph.py
#=========================================================================
# Set up script of CksumUnit
#
# Author : Christopher Torng
# Date   : June 2, 2019
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

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  adk_name = 'freepdk-45nm'
  adk_view = 'stdview'

  parameters = {
    'design_name'  : 'ChecksumRTL',
    'clock_period' : 2.0,
    'adk'          : adk_name,
    'adk_view'     : adk_view,
  }

  #-----------------------------------------------------------------------
  # ADK
  #-----------------------------------------------------------------------

  g.set_adk( adk_name )

  #-----------------------------------------------------------------------
  # Import steps
  #-----------------------------------------------------------------------

  # ADK as a step

  adk = g.get_adk_step()

  # Custom steps
  #
  # - rtl
  #

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  rtl = Step( this_dir + '/rtl' )

  # Default steps
  #
  # - info
  # - synthesis
  # - place
  #

  info    = Step( 'info',                 default=True )
  yosys   = Step( 'open-yosys-synthesis', default=True )
  # replace = Step( 'open-replace-place',   default=True )
  graywolf = Step( 'open-graywolf-place', default=True )
  qrouter  = Step( 'open-qrouter-route',  default=True )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  adk.update_params( parameters )
  yosys.update_params( parameters )
  info.update_params( parameters )
  # replace.update_params( parameters )
  graywolf.update_params( parameters )
  qrouter.update_params( parameters )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info    )
  g.add_step( rtl     )
  g.add_step( yosys   )
  # g.add_step( replace )
  g.add_step( graywolf )
  g.add_step( qrouter  )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  g.connect_by_name( rtl, yosys )
  g.connect_by_name( adk, yosys )

  # g.connect_by_name( yosys, replace )
  # g.connect_by_name( adk,   replace )
  g.connect_by_name( adk,   graywolf )
  g.connect_by_name( yosys, graywolf )

  g.connect_by_name( adk,      qrouter )
#  g.connect_by_name( replace,  qrouter )
  g.connect_by_name( graywolf, qrouter )

  return g


if __name__ == '__main__':
  g = setup_graph()
#  g.plot()

