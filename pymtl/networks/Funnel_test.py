#=========================================================================
# Funnel_test.py
#=========================================================================

from pymtl        import *
from Funnel       import Funnel

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs         import MemMsg

#------------------------------------------------------------------------------
# test_basic_2x1
#------------------------------------------------------------------------------
# Test driver for the Funnel model with two inputs
def test_basic_2x1( dump_vcd, test_verilog ):

  # Instantiate and elaborate the model
  model          = Funnel( 2, MemMsg( 8, 32, 32 ).req )

  if dump_vcd:
    model.vcd_file = dump_vcd

  if test_verilog:
    model = TranslationTool( model )

  model.elaborate()

  # Create and rest the simulator
  sim = SimulationTool( model )
  sim.reset()
  print ""

  # Helper function
  def t( in_, out ):

    # Write the input value to the input ports
    model.in_[0].val.value = in_[0]
    model.in_[0].msg.value = in_[1]
    model.in_[1].val.value = in_[2]
    model.in_[1].msg.value = in_[3]
    model.out.rdy.value    = in_[4]

    # Ensure that all combinational concurrent blocks are called

    sim.eval_combinational()

    # Display line trace

    sim.print_line_trace()

    # Verify reference output port
    assert model.in_[0].rdy == out[0] or out[0] == 'x'
    assert model.in_[1].rdy == out[1] or out[1] == 'x'
    assert model.out.val    == out[2] or out[2] == 'x'
    assert model.out.msg    == out[3] or out[3] == 'x'

    # Tick simulator by one cycle

    sim.cycle()

  # Helper function to make messages
  def msg( type_, opaque, addr, len_, data ):
    return MemMsg( 8, 32, 32 ).req.mk_msg( type_, opaque, addr, len_, data )

  # Cycle-by-cycle tests
  #  in_[0]          in_[0] in_[1]          in_[1] out   in_[0] in_[1] out             out
  #    .val            .msg   .val            .msg rdy     .rdy   .rdy val             msg
  t([     1, msg(0,0,1,0,4),     0, msg(0,0,2,0,8),  1], [    1,     0,  1, msg(0,0,1,0,4)] )
  t([     1, msg(0,0,1,0,5),     1, msg(0,0,2,0,8),  1], [    0,     1,  1, msg(0,1,2,0,8)] )
  t([     1, msg(0,0,1,0,5),     1, msg(0,0,2,0,8),  0], [    0,     0,  1, 'x'] )
  t([     1, msg(0,0,1,0,5),     1, msg(0,0,2,0,8),  1], [    1,     0,  1, msg(0,0,1,0,5)] )
  t([     1, msg(0,0,1,0,6),     0, msg(0,0,2,0,8),  1], [    1,     0,  1, msg(0,0,1,0,6)] )

  sim.cycle()
  sim.cycle()
  sim.cycle()
