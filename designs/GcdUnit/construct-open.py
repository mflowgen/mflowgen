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
  adk_view = 'view-tiny'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'gcd',
    'orfs_platform'  : 'nangate45',
    'clock_period'   : 2.0,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
    # Pick an image from Docker Hub "mflowgen/openroad-flow-scripts-base"
    # - https://hub.docker.com/repository/docker/mflowgen/openroad-flow-scripts-base/general
    'orfs_image'     : 'mflowgen/openroad-flow-scripts-base:2024-0621-f0caba6',
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK node

#  g.set_adk( adk_name )
#  adk = g.get_adk_node()

  # Custom nodes

  design = Node( this_dir + '/orfs-design' )

  # Default nodes

  info   = Node( 'info',                    default=True )
  docker = Node( 'orfs-docker-setup',       default=True)
  synth  = Node( 'orfs-yosys-synthesis',    default=True)
  fplan  = Node( 'orfs-openroad-floorplan', default=True)
  place  = Node( 'orfs-openroad-place',     default=True)
  cts    = Node( 'orfs-openroad-cts',       default=True)
  route  = Node( 'orfs-openroad-route',     default=True)
  finish = Node( 'orfs-openroad-finish',    default=True)

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_node( info     )
  g.add_node( design   )
  g.add_node( docker   )
  g.add_node( synth    )
  g.add_node( fplan    )
  g.add_node( place    )
  g.add_node( cts      )
  g.add_node( route    )
  g.add_node( finish   )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  g.connect_by_name( design,  synth  )

  g.connect_by_name( docker,  synth  )
  g.connect_by_name( docker,  fplan  )
  g.connect_by_name( docker,  place  )
  g.connect_by_name( docker,  cts    )
  g.connect_by_name( docker,  route  )
  g.connect_by_name( docker,  finish )

  g.connect_by_name( synth,   fplan  )
  g.connect_by_name( fplan,   place  )
  g.connect_by_name( place,   cts    )
  g.connect_by_name( cts,     route  )
  g.connect_by_name( route,   finish )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g


if __name__ == '__main__':
  g = construct()
#  g.plot()


