#=========================================================================
# RegIncr_test
#=========================================================================

from pymtl   import *
from RegIncr import RegIncr

# In py.test, unit tests are simply functions that begin with a "test_"
# prefix. PyMTL is setup to simplify dumping VCD. Simply specify
# "dump_vcd" as an argument to your unit test, and then you can dump VCD
# with the --dump-vcd option to py.test.

def test_basic( dump_vcd ):

  # Elaborate the model

  model = RegIncr()
  model.vcd_file = dump_vcd
  model.elaborate()

  # Create and reset simulator

  sim = SimulationTool( model )
  sim.reset()
  print ""

  # Helper function

  def t( in_, out ):

    # Write input value to input port

    model.in_.value = in_

    # Ensure that all combinational concurrent blocks are called

    sim.eval_combinational()

    # Display a line trace

    sim.print_line_trace()

    # If reference output is not '?', verify value read from output port

    if ( out != '?' ):
      assert model.out == out

    # Tick simulator one cycle

    sim.cycle()

  # Cycle-by-cycle tests

  t( 0x00, '?'  )
  t( 0x13, 0x01 )
  t( 0x27, 0x14 )
  t( 0x00, 0x28 )
  t( 0x00, 0x01 )
  t( 0x00, 0x01 )

