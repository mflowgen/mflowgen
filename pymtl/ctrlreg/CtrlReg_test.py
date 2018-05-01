#=========================================================================
# CtrlReg_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random

from pymtl       import *
from pclib.test  import mk_test_case_table, run_sim
from pclib.test  import TestSource, TestSink

from CtrlReg     import CtrlReg
from ifcs        import CtrlRegReqMsg, CtrlRegRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, CtrlReg, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd = False, test_verilog = False ):

    # Instantiate models

    s.src  = TestSource( CtrlRegReqMsg(),  src_msgs,  src_delay  )
    s.dut  = CtrlReg( num_cores=1 )
    s.sink = TestSink  ( CtrlRegRespMsg(), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.dut = TranslationTool( s.dut, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src.out,  s.dut.req  )
    s.connect( s.sink.in_, s.dut.resp )

    # Tie counter bits to zero

    s.connect( s.dut.commit_inst, 0 )
    s.connect( s.dut.stats_en,    0 )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace() + ' > ' + s.dut.line_trace() + ' > ' + s.sink.line_trace()

#-------------------------------------------------------------------------
# Make messages
#-------------------------------------------------------------------------

def req( type_, addr, data ):
  msg = CtrlRegReqMsg()

  if   type_ == 'rd': msg.type_ = CtrlRegReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = CtrlRegReqMsg.TYPE_WRITE

  msg.addr   = addr
  msg.data   = data

  return msg

def resp( type_, data ):
  msg = CtrlRegRespMsg()

  if   type_ == 'rd': msg.type_ = CtrlRegRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = CtrlRegRespMsg.TYPE_WRITE

  msg.data   = data

  return msg

#----------------------------------------------------------------------
# Message generation: random
#----------------------------------------------------------------------

def random_msgs( num_regs, num_msgs = 20 ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  # Virtual regfile

  vmem = [ rgen.randint(0,0xffffffff) for _ in range(num_regs) ]
  msgs = []

  # Initialize registers

  for i in range(num_regs):
    msgs.extend([
      req( 'wr', i, vmem[i] ), resp( 'wr', 0 ),
    ])

  # Randomly read or write

  for i in range(num_msgs):
    addr = rgen.randint( 0, num_regs-1 )

    read = rgen.randint(0,1)

    if read:

      correct_data = vmem[addr]
      msgs.extend([
        req( 'rd', addr, 0 ), resp( 'rd', correct_data ),
      ])

    else:

      new_data = rgen.randint(0,0xffffffff)
      vmem[addr] = new_data
      msgs.extend([
        req( 'wr', addr, new_data ), resp( 'wr', 0 ),
      ])

  return msgs

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                           "msg_func    src sink"),
  [ "random",                 random_msgs,   0,   0  ],
  [ "random_0_3",             random_msgs,   0,   3  ],
  [ "random_3_0",             random_msgs,   3,   0  ],
  [ "random_3_3",             random_msgs,   3,   3  ],
])

@pytest.mark.parametrize( **test_case_table )
def test_generic( test_params, dump_vcd, test_verilog ):

  dut      = CtrlReg

  num_regs = 2 # Only two registers are writable right now
  num_msgs = 100
  msgs     = test_params.msg_func( num_regs, num_msgs )

  # Instantiate testharness

  harness = TestHarness( dut, msgs[::2], msgs[1::2],
                         test_params.src, test_params.sink,
                         dump_vcd, test_verilog )
  # Run the test

  run_sim( harness, dump_vcd )

