#=========================================================================
# construct.py
#=========================================================================
# Demo with 16-bit GcdUnit
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os

from mflowgen.components import Graph, Node

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
    'topographical'  : True,
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK node

  g.set_adk( adk_name )
  adk = g.get_adk_node()

  # Custom nodes

  rtl = Node( this_dir + '/rtl' )

  # Default nodes

  info         = Node( 'info',                          default=True )
  constraints  = Node( 'constraints',                   default=True )
  dc           = Node( 'synopsys-dc-synthesis',         default=True )
  iflow        = Node( 'cadence-innovus-flowsetup',     default=True )
  placeroute   = Node( 'cadence-innovus-place-route',   default=True )
  genlibdb     = Node( 'synopsys-ptpx-genlibdb',        default=True )
  gdsmerge     = Node( 'mentor-calibre-gdsmerge',       default=True )
  drc          = Node( 'mentor-calibre-drc',            default=True )
  lvs          = Node( 'mentor-calibre-lvs',            default=True )
  debugcalibre = Node( 'cadence-innovus-debug-calibre', default=True )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_node( info         )
  g.add_node( rtl          )
  g.add_node( constraints  )
  g.add_node( dc           )
  g.add_node( iflow        )
  g.add_node( placeroute   )
  g.add_node( genlibdb     )
  g.add_node( gdsmerge     )
  g.add_node( drc          )
  g.add_node( lvs          )
  g.add_node( debugcalibre )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Connect by name

  g.connect_by_name( rtl,         dc           )
  g.connect_by_name( adk,         dc           )
  g.connect_by_name( constraints, dc           )

  g.connect_by_name( adk,         iflow        )
  g.connect_by_name( dc,          iflow        )

  g.connect_by_name( adk,         placeroute   )
  g.connect_by_name( dc,          placeroute   )
  g.connect_by_name( iflow,       placeroute   )

  g.connect_by_name( placeroute,  genlibdb     )
  g.connect_by_name( adk,         genlibdb     )

  g.connect_by_name( adk,         drc          )
  g.connect_by_name( placeroute,  drc          )

  g.connect_by_name( adk,         lvs          )
  g.connect_by_name( placeroute,  lvs          )

  g.connect_by_name( adk,         gdsmerge     )
  g.connect_by_name( placeroute,  gdsmerge     )

  g.connect_by_name( gdsmerge,    drc          )
  g.connect_by_name( gdsmerge,    lvs          )

  g.connect_by_name( adk,         debugcalibre )
  g.connect_by_name( dc,          debugcalibre )
  g.connect_by_name( iflow,       debugcalibre )
  g.connect_by_name( placeroute,  debugcalibre )
  g.connect_by_name( drc,         debugcalibre )
  g.connect_by_name( lvs,         debugcalibre )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g

if __name__ == '__main__':
  g = construct()
#  g.plot()

