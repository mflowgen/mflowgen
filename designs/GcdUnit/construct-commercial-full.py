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
    'construct_path'      : __file__,
    'design_name'         : 'GcdUnit',
    'clock_period'        : 2.0,
    'adk'                 : adk_name,
    'adk_view'            : adk_view,
    # Enable GUIs
    'enable_gui'          : True,
    # GLS Testbench
    'saif_instance'       : 'GcdUnitTb/GcdUnit_inst',
    # Synthesis
    # Flatten effort 0 is strict hierarchy, 3 is full flattening
    'flatten_effort'      : 0,
    'topographical'       : True,
    # Postroute timing target slack
    'setup_target_slack'  : 0.000,
    'hold_target_slack'   : 0.050,
    # Utilization target
    'core_density_target' : 0.70,
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK node

  g.set_adk( adk_name )
  adk = g.get_adk_node()

  # Custom nodes

  rtl            = Node( this_dir + '/rtl'         )
  testbench      = Node( this_dir + '/testbench'   )
  constraints    = Node( this_dir + '/constraints' )

  # Default nodes

  info           = Node( 'info',                            default=True )
  synth          = Node( 'synopsys-dc-synthesis',           default=True )
#  synth          = Node( 'cadence-genus-synthesis',         default=True )
  iflow          = Node( 'cadence-innovus-flowsetup',       default=True )
  init           = Node( 'cadence-innovus-init',            default=True )
  power          = Node( 'cadence-innovus-power',           default=True )
  place          = Node( 'cadence-innovus-place',           default=True )
  cts            = Node( 'cadence-innovus-cts',             default=True )
  postcts_hold   = Node( 'cadence-innovus-postcts_hold',    default=True )
  route          = Node( 'cadence-innovus-route',           default=True )
  postroute      = Node( 'cadence-innovus-postroute',       default=True )
  postroute_hold = Node( 'cadence-innovus-postroute_hold',  default=True )
  signoff        = Node( 'cadence-innovus-signoff',         default=True )
  pt_signoff     = Node( 'synopsys-pt-timing-signoff',      default=True )
  genlibdb       = Node( 'synopsys-ptpx-genlibdb',          default=True )
  gdsmerge       = Node( 'mentor-calibre-gdsmerge',         default=True )
  drc            = Node( 'mentor-calibre-drc',              default=True )
  lvs            = Node( 'mentor-calibre-lvs',              default=True )
  debugcalibre   = Node( 'cadence-innovus-debug-calibre',   default=True )
  vcs_sim        = Node( 'synopsys-vcs-sim-old',            default=True )
  power_est      = Node( 'synopsys-pt-power',               default=True )
  fm             = Node( 'synopsys-formality-verification', default=True )

  #-----------------------------------------------------------------------
  # Modify Nodes
  #-----------------------------------------------------------------------

  vcs_sim.extend_inputs( ['test_vectors.txt'] )
  vcs_sim.update_params( testbench.params() )

  verif_post_synth = fm.clone()
  verif_post_synth.set_name( 'verif_post_synth' )
  verif_post_layout = fm.clone()
  verif_post_layout.set_name( 'verif_post_layout' )

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_node( info              )
  g.add_node( rtl               )
  g.add_node( constraints       )
  g.add_node( synth             )
  g.add_node( iflow             )
  g.add_node( init              )
  g.add_node( power             )
  g.add_node( place             )
  g.add_node( cts               )
  g.add_node( postcts_hold      )
  g.add_node( route             )
  g.add_node( postroute         )
  g.add_node( postroute_hold    )
  g.add_node( signoff           )
  g.add_node( pt_signoff        )
  g.add_node( genlibdb          )
  g.add_node( gdsmerge          )
  g.add_node( drc               )
  g.add_node( lvs               )
  g.add_node( debugcalibre      )
  g.add_node( testbench         )
  g.add_node( vcs_sim           )
  g.add_node( power_est         )
  g.add_node( verif_post_synth  )
  g.add_node( verif_post_layout )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Connect by name

  g.connect_by_name( adk,            synth          )
  g.connect_by_name( adk,            iflow          )
  g.connect_by_name( adk,            init           )
  g.connect_by_name( adk,            power          )
  g.connect_by_name( adk,            place          )
  g.connect_by_name( adk,            cts            )
  g.connect_by_name( adk,            postcts_hold   )
  g.connect_by_name( adk,            route          )
  g.connect_by_name( adk,            postroute      )
  g.connect_by_name( adk,            postroute_hold )
  g.connect_by_name( adk,            signoff        )
  g.connect_by_name( adk,            pt_signoff     )
  g.connect_by_name( adk,            gdsmerge       )
  g.connect_by_name( adk,            drc            )
  g.connect_by_name( adk,            lvs            )
  g.connect_by_name( adk,            genlibdb       )

  g.connect_by_name( rtl,            synth          )
  g.connect_by_name( constraints,    synth          )

  g.connect_by_name( synth,          iflow          )
  g.connect_by_name( synth,          init           )
  g.connect_by_name( synth,          power          )
  g.connect_by_name( synth,          place          )
  g.connect_by_name( synth,          cts            )

  g.connect_by_name( iflow,          init           )
  g.connect_by_name( iflow,          power          )
  g.connect_by_name( iflow,          place          )
  g.connect_by_name( iflow,          cts            )
  g.connect_by_name( iflow,          postcts_hold   )
  g.connect_by_name( iflow,          route          )
  g.connect_by_name( iflow,          postroute      )
  g.connect_by_name( iflow,          postroute_hold )
  g.connect_by_name( iflow,          signoff        )

  g.connect_by_name( init,           power          )
  g.connect_by_name( power,          place          )
  g.connect_by_name( place,          cts            )
  g.connect_by_name( cts,            postcts_hold   )
  g.connect_by_name( postcts_hold,   route          )
  g.connect_by_name( route,          postroute      )
  g.connect_by_name( postroute,      postroute_hold )
  g.connect_by_name( postroute_hold, signoff        )

  g.connect_by_name( signoff,        pt_signoff     )
  g.connect_by_name( signoff,        genlibdb       )
  g.connect_by_name( signoff,        gdsmerge       )
  g.connect_by_name( signoff,        drc            )
  g.connect_by_name( signoff,        lvs            )

  g.connect_by_name( gdsmerge,       drc            )
  g.connect_by_name( gdsmerge,       lvs            )

  g.connect_by_name( adk,            debugcalibre   )
  g.connect_by_name( synth,          debugcalibre   )
  g.connect_by_name( iflow,          debugcalibre   )
  g.connect_by_name( signoff,        debugcalibre   )
  g.connect_by_name( drc,            debugcalibre   )
  g.connect_by_name( lvs,            debugcalibre   )

  g.connect_by_name( adk,            vcs_sim        )
  g.connect_by_name( signoff,        vcs_sim        )
  g.connect_by_name( testbench,      vcs_sim        )

  g.connect_by_name( adk,            power_est      )
  g.connect_by_name( signoff,        power_est      )
  g.connect_by_name( vcs_sim,        power_est      )

  g.connect_by_name( adk,            verif_post_synth )
  g.connect_by_name( synth,          verif_post_synth )
  g.connect( rtl.o('design.v'),      verif_post_synth.i('design.ref.v') )
  g.connect( synth.o('design.v'),    verif_post_synth.i('design.impl.v') )

  g.connect_by_name( adk,            verif_post_layout )
  g.connect_by_name( synth,          verif_post_layout )
  g.connect( synth.o('design.v'),    verif_post_layout.i('design.ref.v') )
  g.connect( signoff.o('design.lvs.v'), verif_post_layout.i('design.impl.v') )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g


if __name__ == '__main__':
  g = construct()
#  g.plot()

