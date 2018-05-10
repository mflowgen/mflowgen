#=========================================================================
# Router_test.py
#=========================================================================

from pymtl      import *
from Router     import Router

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs       import MemMsg

#------------------------------------------------------------------------------
# test_basic_1x2
#------------------------------------------------------------------------------
# Test driver for the Router model with two inputs
def test_basic_1x2( dump_vcd, test_verilog ):

  # Instantiate and elaborate the model
  model          = Router( 2, MemMsg( 8, 32, 32 ).resp )

  if dump_vcd:
    model.vcd_file = dump_vcd

  if test_verilog:
    model = TranslationTool( model, verilator_xinit=test_verilog )

  model.elaborate()

  # Create and rest the simulator
  sim = SimulationTool( model )
  sim.reset()
  print ""

  # Helper function
  def t( in_, out ):

    # Write the input value to the input ports
    model.in_.val.value    = in_[0]
    model.in_.msg.value    = in_[1]
    model.out[0].rdy.value = in_[2]
    model.out[1].rdy.value = in_[3]

    # Ensure that all combinational concurrent blocks are called

    sim.eval_combinational()

    # Display line trace

    sim.print_line_trace()

    # Verify reference output port
    assert model.in_.rdy    == out[0]
    assert model.out[0].val == out[1]
    assert model.out[0].msg == out[2]
    assert model.out[1].val == out[3]
    assert model.out[1].msg == out[4]

    # Tick simulator by one cycle

    sim.cycle()

  # Helper function to make messages
  def msg( type_, opaque, len_, data ):
    return MemMsg( 8, 32, 32 ).resp.mk_msg( type_, opaque, len_, data )

  # Cycle-by-cycle tests
  #   in_           in_ out[0] out[1]    in_ out[0]       out[0] out[1]       out[1]
  #  .val          .msg   .rdy    rdy   .rdy   .val         .msg   .val         .msg
  t([   1, msg(0,0,0,4),     1,    1], [   1,    1, msg(0,0,0,4),    0, msg(0,0,0,0)] )
  t([   1, msg(0,1,0,5),     1,    1], [   1,    0, msg(0,0,0,0),    1, msg(0,1,0,5)] )
  t([   0, msg(0,1,0,5),     1,    1], [   1,    0, msg(0,0,0,0),    0, msg(0,0,0,0)] )
  t([   1, msg(0,1,0,6),     1,    1], [   1,    0, msg(0,0,0,0),    1, msg(0,1,0,6)] )
  t([   1, msg(0,0,0,6),     0,    1], [   0,    1, msg(0,0,0,6),    0, msg(0,0,0,0)] )

  sim.cycle()
  sim.cycle()
  sim.cycle()
