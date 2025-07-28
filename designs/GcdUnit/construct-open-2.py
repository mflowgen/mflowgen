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

  # adk_name = 'freepdk-45nm'
  adk_name = 'nangate45'
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

  # ADK step

#  g.set_adk( adk_name )
#  adk = g.get_adk_step()

  # Custom steps

  design = Step( this_dir + '/orfs-design' )
  custom1 = Step( this_dir + '/orfs-custom1')
  custom2 = Step( this_dir + '/orfs-custom2')

  # Default steps

  info   = Step( 'info',                    default=True )
  docker = Step( 'orfs-docker-setup',       default=True)
  # parser = Step( 'orfs-parser',             default=True)
  synth  = Step( 'orfs-yosys-synthesis',    default=True)
  fplan  = Step( 'orfs-openroad-floorplan', default=True)
  power  = Step( 'orfs-openroad-power', default=True)
  place  = Step( 'orfs-openroad-place',     default=True)
  cts    = Step( 'orfs-openroad-cts',       default=True)
  route  = Step( 'orfs-openroad-route',     default=True)
  finish = Step( 'orfs-openroad-finish',    default=True)

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info     )
  g.add_step( design   )
  # g.add_step( parser   )
  g.add_step( docker   )
  g.add_step( synth    )
  g.add_step( fplan    )
  g.add_step( power    )
  g.add_step( place    )
  g.add_step( cts      )
  g.add_step( route    )
  g.add_step( finish   )

  g.add_step( custom1  )
  g.add_step( custom2  )
  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  g.connect_by_name( design,  synth  )

  g.connect_by_name( docker,  synth  )
  g.connect_by_name( docker,  fplan  )
  g.connect_by_name( docker,  power  )
  g.connect_by_name( docker,  place  )
  g.connect_by_name( docker,  cts    )
  g.connect_by_name( docker,  route  )
  g.connect_by_name( docker,  finish )

  # g.connect_by_name( parser,  synth  )
  # g.connect_by_name( parser,  fplan  )
  # g.connect_by_name( parser,  power  )
  # g.connect_by_name( parser,  place  )
  # g.connect_by_name( parser,  cts    )
  # g.connect_by_name( parser,  route  )
  # g.connect_by_name( parser, custom1 )
  # g.connect_by_name( parser, custom2 )

  g.connect_by_name( synth,   fplan  )
  g.connect_by_name( fplan,   custom1)
  g.connect_by_name( custom1, power  )
  g.connect_by_name( power,   place  )
  g.connect_by_name( place,   cts    )
  g.connect_by_name( cts,     custom2)
  g.connect_by_name( custom2, route  )
  g.connect_by_name( route,   finish )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g


if __name__ == '__main__':
  g = construct()
#  g.plot()


