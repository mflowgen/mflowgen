#=========================================================================
# Bram2rwWrapper_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct

from pymtl       import *
from pclib.ifcs  import MemReqMsg, MemRespMsg
from pclib.test  import mk_test_case_table, run_sim
from pclib.test  import TestSource, TestSink

from Bram2rwWrapper import Bram2rwWrapper

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs, sink_msgs, src_delay, sink_delay, BramModel,
                dump_vcd = False, test_verilog = False ):

    # Instantiate models

    s.src_a  = TestSource( MemReqMsg( 8, 32, 32 ),  src_msgs,  src_delay  )
    s.src_b  = TestSource( MemReqMsg( 8, 32, 32 ),  src_msgs,  src_delay  )
    s.bram   = BramModel
    s.sink_a = TestSink  ( MemRespMsg( 8, 32 ), sink_msgs, sink_delay )
    s.sink_b = TestSink  ( MemRespMsg( 8, 32 ), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.bram.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.bram = TranslationTool( s.bram, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src_a.out,  s.bram.memreqa  )
    s.connect( s.sink_a.in_, s.bram.memrespa )

    s.connect( s.src_b.out,  s.bram.memreqb  )
    s.connect( s.sink_b.in_, s.bram.memrespb )

  def done( s ):
    return s.src_a.done and s.sink_a.done and s.src_b.done and s.sink_b.done

  def line_trace( s ):
    return s.src_a.line_trace() + " " + s.bram.line_trace() + " " + s.sink_a.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, opaque, addr, len, data ):
  msg = MemReqMsg( 8, 32, 32 )

  if   type_ == 'rd': msg.type_ = MemReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemReqMsg.TYPE_WRITE

  msg.addr   = addr
  msg.opaque = opaque
  msg.len    = len
  msg.data   = data
  return msg

def resp( type_, opaque, len, data ):
  msg = MemRespMsg( 8, 32 )

  if   type_ == 'rd': msg.type_ = MemRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemRespMsg.TYPE_WRITE

  msg.opaque = opaque
  msg.len    = len
  msg.test   = 0
  msg.data   = data
  return msg

#----------------------------------------------------------------------
# Test Case: random
#----------------------------------------------------------------------

def random_msgs( base_addr = 0x0, num_msgs = 20 ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  vmem = [ rgen.randint(0,0xffffffff) for _ in range(num_msgs) ]
  msgs = []

  for i in range(num_msgs):
    msgs.extend([
      req( 'wr', i, base_addr+4*i, 0, vmem[i] ), resp( 'wr', i, 0, 0 ),
    ])

  for i in range(num_msgs):
    idx = rgen.randint(0,num_msgs-1)

    if rgen.randint(0,1):

      correct_data = vmem[idx]
      msgs.extend([
        req( 'rd', i, base_addr+4*idx, 0, 0 ), resp( 'rd', i, 0, correct_data ),
      ])

    else:

      new_data = rgen.randint(0,0xffffffff)
      vmem[idx] = new_data
      msgs.extend([
        req( 'wr', i, base_addr+4*idx, 0, new_data ), resp( 'wr', i, 0, 0 ),
      ])

  return msgs

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (               "msg_func     src sink"),
  [ "random",      random_msgs, 0,  0    ],
  [ "random_0_3",  random_msgs, 0,  3    ],
  [ "random_3_0",  random_msgs, 3,  0    ],
  [ "random_3_3",  random_msgs, 3,  3    ],
])

@pytest.mark.parametrize( **test_case_table )
def test_generic( test_params, dump_vcd, test_verilog ):
  base_addr = 0x0
  num_msgs  = 50
  msgs = test_params.msg_func( base_addr, num_msgs )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.src, test_params.sink,
                         Bram2rwWrapper( 32, 256 ), dump_vcd, test_verilog )
  # Run the test
  # Setting max cycles higher so the test can finish
  run_sim( harness, dump_vcd, max_cycles=10000 )

