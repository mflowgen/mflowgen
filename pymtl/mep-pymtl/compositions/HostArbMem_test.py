#=========================================================================
# HostArbMem_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct

from pymtl       import *
from pclib.ifcs  import MemReqMsg4B, MemRespMsg4B
from pclib.test  import mk_test_case_table, run_sim
from pclib.test  import TestSource, TestSink

from HostArbMem  import HostArbMem

# Test messages from SRAM-wrapper test

from sram.SramWrapper_test import random_msgs, random_addr_msgs

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs_A, sink_msgs_A, src_msgs_B, sink_msgs_B,
                src_delay, sink_delay, HostArbMemModel,
                dump_vcd = False, test_verilog = False ):

    # Instantiate models

    s.src_a  = TestSource( MemReqMsg4B,  src_msgs_A,  src_delay  )
    s.src_b  = TestSource( MemReqMsg4B,  src_msgs_B,  src_delay  )
    s.dut    = HostArbMemModel
    s.sink_a = TestSink  ( MemRespMsg4B, sink_msgs_A, sink_delay )
    s.sink_b = TestSink  ( MemRespMsg4B, sink_msgs_B, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.dut = TranslationTool( s.dut, enable_blackbox=True, verilator_xinit=test_verilog )

    # Zero the opaque field in the DUT's response messages. This allows us
    # to "ignore" the opaque field, which will have been dirtied by the
    # memory arbiter in the DUT.

    s.host_memrespa_msg = Wire( MemRespMsg4B )
    s.host_memrespb_msg = Wire( MemRespMsg4B )

    @s.combinational
    def hostmem_resp_modified():
      s.host_memrespa_msg.value = s.dut.host_memrespa.msg
      s.host_memrespb_msg.value = s.dut.host_memrespb.msg

      s.host_memrespa_msg.opaque.value = 0
      s.host_memrespb_msg.opaque.value = 0

    # Connect

    s.connect( s.src_a.out, s.dut.host_memreqa )
    s.connect_pairs(
        s.sink_a.in_.val, s.dut.host_memrespa.val,
        s.sink_a.in_.rdy, s.dut.host_memrespa.rdy,
        s.sink_a.in_.msg, s.host_memrespa_msg,
        )

    s.connect( s.src_b.out, s.dut.host_memreqb )
    s.connect_pairs(
        s.sink_b.in_.val, s.dut.host_memrespb.val,
        s.sink_b.in_.rdy, s.dut.host_memrespb.rdy,
        s.sink_b.in_.msg, s.host_memrespb_msg,
        )

  def done( s ):
    return s.src_a.done and s.sink_a.done and s.src_b.done and s.sink_b.done

  def line_trace( s ):
    return '{} | {} > {} > {} | {}'.format(
        s.src_a.line_trace(),
        s.src_b.line_trace(),
        s.dut.line_trace(),
        s.sink_a.line_trace(),
        s.sink_b.line_trace(),
        )

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                           "msg_func_A        msg_func_B  src sink"),
  [ "random",                 random_msgs,      random_msgs,   0,   0  ],
  [ "random_0_3",             random_msgs,      random_msgs,   0,   3  ],
  [ "random_3_0",             random_msgs,      random_msgs,   3,   0  ],
  [ "random_3_3",             random_msgs,      random_msgs,   3,   3  ],
  [ "random_addr",       random_addr_msgs, random_addr_msgs,   0,   0  ],
  [ "random_addr_0_3",   random_addr_msgs, random_addr_msgs,   0,   3  ],
  [ "random_addr_3_0",   random_addr_msgs, random_addr_msgs,   3,   0  ],
  [ "random_addr_3_3",   random_addr_msgs, random_addr_msgs,   3,   3  ],
])

@pytest.mark.parametrize( **test_case_table )
def test_generic( test_params, dump_vcd, test_verilog ):

  dut       = HostArbMem(32,2048,2) # Ex. 32b word size * 6144 words = 24KB

  base_addr = 0x0
  max_addr  = 0x2000 # 0x8000 is 32KB, 0x4000 is 16KB, 0x2000 is 8KB
  num_msgs  = 100 # 256 msgs max, because msg num goes into opaque field

  # The opaque field is used by the arbiter to route msgs. The memory msg
  # source/sink should not check the opaque field anymore, so we set
  # opaque_is_id to False. This makes the opaque field 0 for all messages.
  # Then we zero the opaque field coming out of the DUT before it goes
  # into the sink.

  msgs_A = test_params.msg_func_A( base_addr, max_addr,
                                   num_msgs,  opaque_is_id = False )
  msgs_B = test_params.msg_func_B( base_addr, max_addr,
                                   num_msgs,  opaque_is_id = False )

  # Instantiate testharness

  harness = TestHarness( msgs_A[::2], msgs_A[1::2],
                         msgs_B[::2], msgs_B[1::2],
                         test_params.src, test_params.sink,
                         dut, dump_vcd, test_verilog )

  # Run the test

  run_sim( harness, dump_vcd )

