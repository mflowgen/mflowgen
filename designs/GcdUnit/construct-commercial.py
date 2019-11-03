#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Demo with 16-bit GcdUnit
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os
import sys

from mflow.components import Graph, Step

def construct():

  g = Graph()

  #-----------------------------------------------------------------------
  # Parameters
  #-----------------------------------------------------------------------

  adk_name = 'freepdk-45nm'
  adk_view = 'view-standard'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'GcdUnit',
    'clock_period'   : 2.0,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
  }

  #-----------------------------------------------------------------------
  # ADK
  #-----------------------------------------------------------------------

  g.set_adk( adk_name )

  #-----------------------------------------------------------------------
  # Create steps
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  adk = g.get_adk_step()

  # Custom steps

  rtl = Step( this_dir + '/rtl' )

  # Default steps

  info        = Step( 'info',                        default=True )
  constraints = Step( 'constraints',                 default=True )
  dc          = Step( 'synopsys-dc-synthesis',       default=True )
  iflow       = Step( 'cadence-innovus-flowgen',     default=True )
  iplugins    = Step( 'cadence-innovus-plugins',     default=True )
  placeroute  = Step( 'cadence-innovus-place-route', default=True )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  adk.update_params( parameters )
  info.update_params( parameters )
  constraints.update_params (parameters )
  dc.update_params( parameters )
  iflow.update_params( parameters )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info        )
  g.add_step( rtl         )
  g.add_step( constraints )
  g.add_step( dc          )
  g.add_step( iflow       )
  g.add_step( iplugins    )
  g.add_step( placeroute  )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Connect by name

  g.connect_by_name( rtl,         dc )
  g.connect_by_name( adk,         dc )
  g.connect_by_name( constraints, dc )

  g.connect_by_name( adk,      iflow )
  g.connect_by_name( dc,       iflow )
  g.connect_by_name( iplugins, iflow )

  g.connect_by_name( adk,      placeroute )
  g.connect_by_name( dc,       placeroute )
  g.connect_by_name( iflow,    placeroute )
  g.connect_by_name( iplugins, placeroute )

  return g

if __name__ == '__main__':
  g = construct()
#  g.plot()

