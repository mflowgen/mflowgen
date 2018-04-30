#=========================================================================
# SramValRdyPRTL_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct

from pymtl         import *
from pclib.ifcs    import MemReqMsg, MemRespMsg
from pclib.test    import mk_test_case_table, run_sim
from pclib.test    import TestSource, TestSink

from SramValRdy.SramValRdyPRTL import SramValRdyPRTL

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs              import MemReqMsg, MemRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs, sink_msgs, src_delay, sink_delay, SramModel,
                dump_vcd = False, test_verilog = False, tech_node = 'generic' ):

    # Get sizes
    num_bits  = SramModel.num_bits
    num_words = SramModel.num_words

    # Instantiate models

    s.src_a  = TestSource( MemReqMsg ( 8, 32, num_bits ), src_msgs,  src_delay  )
    s.sram   = SramModel ( tech_node )
    s.sink_a = TestSink  ( MemRespMsg( 8    , num_bits ), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.sram.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.sram = TranslationTool( s.sram, enable_blackbox=True )

    # Connect

    s.connect( s.src_a.out,  s.sram.memreq  )
    s.connect( s.sink_a.in_, s.sram.memresp )

  def done( s ):
    return s.src_a.done and s.sink_a.done

  def line_trace( s ):
    return s.src_a.line_trace() + " " + s.sram.line_trace() + " " + s.sink_a.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, opaque, addr, len, data, num_bits = 64 ):
  msg = MemReqMsg( 8, 32, num_bits )

  if   type_ == 'rd': msg.type_ = MemReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemReqMsg.TYPE_WRITE

  msg.addr   = addr
  msg.opaque = opaque
  msg.len    = len
  msg.data   = data
  return msg

def resp( type_, opaque, len, data, num_bits ):
  msg = MemRespMsg( 8, num_bits )

  if   type_ == 'rd': msg.type_ = MemRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemRespMsg.TYPE_WRITE

  msg.opaque = opaque
  msg.len    = len
  msg.test   = 0
  msg.data   = data
  return msg

#----------------------------------------------------------------------
# Test Case: directed
#----------------------------------------------------------------------

def basic_single_msgs( base_addr = None , num_msgs  = None ,
                       num_bits  = 64   , num_words = 64   ):
  return [
    #    type  opq  addr   len data                                  type  opq  len data
    req( 'wr', 0x0, 0x0000, 0, 0xdeadbeefcafe0123, num_bits ), resp( 'wr', 0x0, 0,  0                 , num_bits ),
    req( 'rd', 0x1, 0x0000, 0, 0                 , num_bits ), resp( 'rd', 0x1, 0,  0xdeadbeefcafe0123, num_bits ),
  ]

def basic_multiple_msgs( base_addr = None , num_msgs = None ,
                         num_bits  = 64   , num_words = 64  ):
  return [
    #    type  opq  addr   len data                                  type  opq  len data
    req( 'wr', 0x0, 0x0000, 0, 0xdeadbeefcafe0123, num_bits ), resp( 'wr', 0x0, 0,  0                 , num_bits ),
    req( 'rd', 0x1, 0x0000, 0, 0                 , num_bits ), resp( 'rd', 0x1, 0,  0xdeadbeefcafe0123, num_bits ),
    req( 'wr', 0x2, 0x0008, 0, 0x0a0b0c0d0e0f0102, num_bits ), resp( 'wr', 0x2, 0,  0                 , num_bits ),
    req( 'rd', 0x3, 0x0008, 0, 0                 , num_bits ), resp( 'rd', 0x3, 0,  0x0a0b0c0d0e0f0102, num_bits ),
    req( 'wr', 0x4, 0x01f8, 0, 0x4213421342134213, num_bits ), resp( 'wr', 0x4, 0,  0                 , num_bits ),
    req( 'rd', 0x5, 0x01f8, 0, 0                 , num_bits ), resp( 'rd', 0x5, 0,  0x4213421342134213, num_bits ),
  ]

#----------------------------------------------------------------------
# Test Case: random
#----------------------------------------------------------------------

def random_msgs( base_addr = 0x0 , num_msgs  = 64 ,
                 num_bits  = 64  , num_words = 64 ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  vmem = [ rgen.randint(0,0xffffffffffffffff) for _ in range(num_words) ]
  msgs = []

  # Shift
  shft = 1 << clog2( num_bits / 8 )

  num_msgs = min( num_msgs, num_words )

  for i in range( num_words ):
    msgs.extend([
      req ( 'wr', i, base_addr + shft * i, 0, vmem[i], num_bits ),
      resp( 'wr', i, 0                   , 0,          num_bits ),
    ])

  for i in range(num_msgs):
    idx = rgen.randint( 0, num_msgs )

    if rgen.randint( 0, 1 ):

      correct_data = vmem[idx]
      msgs.extend([
        req ( 'rd', i, base_addr + shft * idx, 0           , 0, num_bits ),
        resp( 'rd', i, 0                     , correct_data,    num_bits ),
      ])

    else:

      new_data = rgen.randint(0, 0xffffffffffffffff)
      vmem[idx] = new_data
      msgs.extend([
        req ( 'wr', i, base_addr + shft * idx, 0, new_data, num_bits ),
        resp( 'wr', i, 0                     , 0,           num_bits ),
      ])

  return msgs

#-------------------------------------------------------------------------
# Test Case: all constant values
#-------------------------------------------------------------------------

def allN_msgs( num      = 0x0, base_addr = 0x0, num_msgs = 64,
               num_bits = 256, num_words = 64                ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  msgs = []

  # Shift
  shft = clog2( num_bits / 8 )

  num_msgs = min( num_msgs, num_words )

  # Force this to be 64 because there are 64 entries in the SRAM
  for i in range( num_msgs ):
    msgs.extend([
      req ( 'wr', i, base_addr + shft * i, 0, num, num_bits ),
      resp( 'wr', i, 0                   , 0,      num_bits ),
    ])

  for i in range(num_msgs):
    idx = rgen.randint(0, num_msgs)

    if rgen.randint(0,1):
      correct_data = num
      msgs.extend([
        req ( 'rd', i, base_addr + shft * idx, 0  , 0, num_bits ),
        resp( 'rd', i, 0                     , num,    num_bits ),
      ])
    else:
      msgs.extend([
        req ( 'wr', i, base_addr + shft * idx, 0, num, num_bits ),
        resp( 'wr', i, 0                     , 0,      num_bits ),
      ])

  return msgs

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                        "msg_func            src sink" ),
  [ "basic_single_msgs",   basic_single_msgs,   0,  0     ],
  [ "basic_multiple_msgs", basic_multiple_msgs, 0,  0     ],
  [ "random",              random_msgs,         0,  0     ],
  [ "random_0_3",          random_msgs,         0,  3     ],
  [ "random_3_0",          random_msgs,         3,  0     ],
  [ "random_3_3",          random_msgs,         3,  3     ],
])

@pytest.mark.parametrize( **test_case_table )
def test_generic( test_params, dump_vcd, test_verilog ):

  base_addr = 0x0
  num_msgs  = 64

  # Parameters
  num_bits  = SramValRdyPRTL.num_bits
  num_words = SramValRdyPRTL.num_words

  msgs = test_params.msg_func( base_addr, num_msgs, num_bits, num_words )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.src, test_params.sink,
                         SramValRdyPRTL, dump_vcd, test_verilog )
  # Run the test
  run_sim( harness, dump_vcd )

