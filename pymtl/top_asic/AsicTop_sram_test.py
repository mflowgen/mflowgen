#=========================================================================
# AsicTop_sram_test.py
#=========================================================================
#
# Test sram without processor, basically this is only to load data to
# sram and read it back by the host.
#

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl                 import *
from pclib.test            import mk_test_case_table

# import from sram project
from sram.SramWrapper_test import random_msgs, random_addr_msgs
# import from fpga project
from fpga                  import SwShim
from fpga.drivers          import ZedDriver

# Import from proc project

from proc.test.harness import asm_test

# Import from top project

from top               import *
from top               import ProcSram

# Import from top_asic (this) project
from harness           import *
from AsicTop           import AsicTop
from AsicTop_test      import instantiate_dut

#=========================================================================
# run_test_sram
#=========================================================================

def run_test_sram( dut, msgs, src_delay, sink_delay, dump_vcd, test_verilog, max_cycles, gen_ref ):

  model = TestHarness( dut, src_delay, sink_delay, dump_vcd, test_verilog )
  model.elaborate()

  # use the same name as the vcd

  ref_name = gen_ref
  fhandle = None
  if ref_name:
    fhandle = open( ref_name, 'w' )

  # Load the MemMsgs into the model

  model.load_memory_msgs( msgs )

  # Create a simulator using the simulation tool

  sim = SimulationTool( model )

  # Run the simulation

  print()

  sim.reset()

  # custom line trace func, print line trace and dump reference file
  # for gate-level testing

  flag = True
  def print_line_trace_x():
    global flag
    sim.print_line_trace()
    if ref_name and (not test_verilog):
      if model.proc.dut.out.req and flag:
        fhandle.write( str(model.proc.dut.out.msg) + '\n' )
        flag = False
      elif ~model.proc.dut.out.req:
        flag = True

  # helper function to turn on/off go bit

  def go( b ):

    def tick():
      sim.eval_combinational()
      print_line_trace_x()
      sim.cycle()

    # Prepare request packet

    msg = CtrlRegReqMsg()
    msg.type_ = CtrlRegReqMsg.TYPE_WRITE
    msg.addr  = 0
    msg.data  = b

    model.ctrlreg_req.msg.value  = msg

    model.ctrlreg_req.val.value  = 1
    model.ctrlreg_resp.rdy.value = 1

    # Save this cycle's req rdy signal
    #
    # For some reason, if ctrlreg_req_rdy is set to model.ctrlreg_req.rdy,
    # even though the value is 0 if I print it right here, it keeps
    # getting set back to 1 if I print it after tick() is called. This
    # messes up the manual val/rdy signaling I'm doing.
    #
    # So I am now setting it to model.ctrlreg_req.rdy.uint(), which is an
    # integer and isn't affected by tick().

    ctrlreg_req_rdy = model.ctrlreg_req.rdy.uint()

    # Always tick at least one cycle with val high

    tick()

    # Continue ticking until we see that the transaction occurred in the
    # previous cycle

    while not ctrlreg_req_rdy:
      ctrlreg_req_rdy = model.ctrlreg_req.rdy.uint()
      tick()

    # Lower val the cycle after the transaction occurs

    model.ctrlreg_req.val.value  = 0

    tick()

  go( 0 )

  # now write instructions and data to the memory

  while ( not model.host_done() ) and sim.ncycles < max_cycles:
    print_line_trace_x()
    sim.cycle()

  # Force a test failure if we timed out

  assert sim.ncycles < max_cycles

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

#-------------------------------------------------------------------------
# test cases
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                           "msg_func"  ),
  [ "random",                 random_msgs ],
  [ "random_addr",       random_addr_msgs ],
])

@pytest.mark.parametrize( **test_case_table )
def test_top_sram( test_params, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)

  base_addr = 0x0
  max_addr  = 0x4000 # 0x8000 is 32KB, 0x4000 is 16KB, 0x2000 is 8KB
  num_msgs  = 100    # 256 msgs max, because msg num goes into opaque field
  msgs = test_params.msg_func( base_addr, max_addr, num_msgs, False )
  run_test_sram( dut, msgs, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
