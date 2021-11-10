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
  adk_view = 'view-standard'

  parameters = {
    'construct_path' : __file__,
    'design_name'    : 'GcdUnit',
    'clock_period'   : 2.0,
    'adk'            : adk_name,
    'adk_view'       : adk_view,
    'topographical'  : True,
    'saif_instance'  : 'GcdUnitTb/GcdUnit_inst'
  }

  #-----------------------------------------------------------------------
  # Create nodes
  #-----------------------------------------------------------------------

  this_dir = os.path.dirname( os.path.abspath( __file__ ) )

  # ADK step

  g.set_adk( adk_name )
  adk = g.get_adk_step()

  # Custom steps

  rtl       = Step( this_dir + '/rtl' )
  testbench = Step( this_dir + '/testbench')

  # Default steps

  info           = Step( 'info',                           default=True )
  constraints    = Step( 'constraints',                    default=True )
  dc             = Step( 'synopsys-dc-synthesis',          default=True )
  iflow          = Step( 'cadence-innovus-flowsetup',      default=True )
  init           = Step( 'cadence-innovus-init',           default=True )
  power          = Step( 'cadence-innovus-power',          default=True )
  place          = Step( 'cadence-innovus-place',          default=True )
  cts            = Step( 'cadence-innovus-cts',            default=True )
  postcts_hold   = Step( 'cadence-innovus-postcts_hold',   default=True )
  route          = Step( 'cadence-innovus-route',          default=True )
  postroute      = Step( 'cadence-innovus-postroute',      default=True )
  postroute_hold = Step( 'cadence-innovus-postroute_hold', default=True )
  signoff        = Step( 'cadence-innovus-signoff',        default=True )
  pt_signoff     = Step( 'synopsys-pt-timing-signoff',     default=True )
  genlibdb       = Step( 'synopsys-ptpx-genlibdb',         default=True )
  gdsmerge       = Step( 'mentor-calibre-gdsmerge',        default=True )
  drc            = Step( 'mentor-calibre-drc',             default=True )
  lvs            = Step( 'mentor-calibre-lvs',             default=True )
  debugcalibre   = Step( 'cadence-innovus-debug-calibre',  default=True )
  vcs_sim        = Step( 'synopsys-vcs-sim',               default=True )
  power_est      = Step( 'synopsys-pt-power',              default=True )
  formal_verif   = Step( 'synopsys-formality-verification', default=True )

  #-----------------------------------------------------------------------
  # Modify Nodes
  #-----------------------------------------------------------------------

  vcs_sim.extend_inputs(['test_vectors.txt'])
  vcs_sim.update_params(testbench.params())

  verif_post_synth = formal_verif.clone()
  verif_post_synth.set_name('verif_post_synth')
  verif_post_layout = formal_verif.clone()
  verif_post_layout.set_name('verif_post_layout')

  #-----------------------------------------------------------------------
  # Graph -- Add nodes
  #-----------------------------------------------------------------------

  g.add_step( info           )
  g.add_step( rtl            )
  g.add_step( constraints    )
  g.add_step( dc             )
  g.add_step( iflow          )
  g.add_step( init           )
  g.add_step( power          )
  g.add_step( place          )
  g.add_step( cts            )
  g.add_step( postcts_hold   )
  g.add_step( route          )
  g.add_step( postroute      )
  g.add_step( postroute_hold )
  g.add_step( signoff        )
  g.add_step( pt_signoff     )
  g.add_step( genlibdb       )
  g.add_step( gdsmerge       )
  g.add_step( drc            )
  g.add_step( lvs            )
  g.add_step( debugcalibre   )
  g.add_step( testbench      )
  g.add_step( vcs_sim        )
  g.add_step( power_est      )
  g.add_step( verif_post_synth )
  g.add_step( verif_post_layout )

  #-----------------------------------------------------------------------
  # Graph -- Add edges
  #-----------------------------------------------------------------------

  # Connect by name

  g.connect_by_name( adk,            dc             )
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
  g.connect_by_name( adk,            pt_signoff        )
  g.connect_by_name( adk,            gdsmerge       )
  g.connect_by_name( adk,            drc            )
  g.connect_by_name( adk,            lvs            )

  g.connect_by_name( rtl,            dc             )
  g.connect_by_name( constraints,    dc             )

  g.connect_by_name( dc,             iflow          )
  g.connect_by_name( dc,             init           )
  g.connect_by_name( dc,             power          )
  g.connect_by_name( dc,             place          )
  g.connect_by_name( dc,             cts            )

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
  g.connect_by_name( adk,            genlibdb       )

  g.connect_by_name( signoff,        gdsmerge       )

  g.connect_by_name( signoff,        drc            )
  g.connect_by_name( gdsmerge,       drc            )
  g.connect_by_name( signoff,        lvs            )
  g.connect_by_name( gdsmerge,       lvs            )

  g.connect_by_name( adk,            debugcalibre   )
  g.connect_by_name( dc,             debugcalibre   )
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
  g.connect_by_name( dc,             verif_post_synth )
  g.connect( rtl.o('design.v'), verif_post_synth.i('design.ref.v') )
  g.connect( dc.o('design.v'), verif_post_synth.i('design.impl.v') )

  g.connect_by_name( adk,            verif_post_layout )
  g.connect_by_name( dc,             verif_post_layout )
  g.connect( dc.o('design.v'), verif_post_layout.i('design.ref.v') )
  g.connect( signoff.o('design.lvs.v'), verif_post_layout.i('design.impl.v') )

  #-----------------------------------------------------------------------
  # Parameterize
  #-----------------------------------------------------------------------

  g.update_params( parameters )

  return g


if __name__ == '__main__':
  g = construct()
#  g.plot()

