#=========================================================================
# InstBuffer_test.py
#=========================================================================

import pytest
import random
import struct

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg, MemReqMsg, MemRespMsg

from cache.test.TestCacheSink   import TestCacheSink

from instbuffer.InstBuffer import InstBuffer

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs, sink_msgs, stall_prob, latency,
                src_delay, sink_delay, model, num_entries, line_nbytes, check_test,
                dump_vcd, test_verilog=False ):

    # Messge type

    buff_msgs = MemMsg(8,32,32)
    mem_msgs  = MemMsg(8,32,line_nbytes*8)

    # Instantiate models

    s.src   = TestSource   ( buff_msgs.req,  src_msgs,  src_delay  )
    s.model = model        ( num_entries, line_nbytes )
    s.mem   = TestMemory   ( mem_msgs, 1, stall_prob, latency )
    s.sink  = TestCacheSink( buff_msgs.resp, sink_msgs, sink_delay, check_test )

    # Dump VCD

    if dump_vcd:
      s.model.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.model = TranslationTool( s.model )

    # Connect

    s.connect( s.src.out,      s.model.buffreq  )
    s.connect( s.sink.in_,     s.model.buffresp )

    s.connect( s.model.memreq,  s.mem.reqs[0]     )
    s.connect( s.model.memresp, s.mem.resps[0]    )

  def load( s, addrs, data_ints ):
    for addr, data_int in zip( addrs, data_ints ):
      data_bytes_a = bytearray()
      data_bytes_a.extend( struct.pack("<I",data_int) )
      s.mem.write_mem( addr, data_bytes_a )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace() + " " + s.model.line_trace() + " " \
         + s.mem.line_trace() + " " + s.sink.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

req_msg  = MemReqMsg(8,32,32)
resp_msg = MemRespMsg(8,32)

def req( type_, opaque, addr, len, data ):
  msg = req_msg()

  if   type_ == 'rd' : msg.type_ = MemReqMsg.TYPE_READ

  msg.addr   = addr
  msg.opaque = opaque
  msg.len    = len
  msg.data   = data
  return msg

def resp( type_, opaque, test, len, data ):
  msg = resp_msg()

  if   type_ == 'rd' : msg.type_ = MemRespMsg.TYPE_READ

  msg.opaque = opaque
  msg.len    = len
  msg.test   = test
  msg.data   = data
  return msg

#----------------------------------------------------------------------
# Test Case: read miss and hit path, many requests
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT
# Capacity is 16 cache lines, so cause capacity misses by streaming 20

def read_capacity( base_addr ):
  array = []
  #                    type  opq  addr          len data
  for i in xrange(20):
    array.append(req(  'rd', 0x1, base_addr+16*i, 0, 0 ))
  #                    type  opq  test          len data
    array.append(resp( 'rd', 0x1, 0,              0, i ))

  return array

# Data to be loaded into memory before running the test
# 16 bytes in each cache line
def read_capacity_mem( base_addr ):
  mem = []
  for i in xrange(20):
    # addr
    mem.append(16*i)
    #data (in int)
    mem.append(i)
  return mem

#-------------------------------------------------------------------------
# Test Case: read miss path
#-------------------------------------------------------------------------

def read_miss_1word_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'rd', 0x00, 0x00000000, 0, 0          ), resp('rd', 0x00, 0, 0, 0xdeadbeef ), # read word  0x00000000
    req( 'rd', 0x01, 0x00000004, 0, 0          ), resp('rd', 0x01, 1, 0, 0x00c0ffee ), # read word  0x00000004
  ]

# Data to be loaded into memory before running the test

def read_miss_1word_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee,
  ]

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table_generic = mk_test_case_table([
  (                         "msg_func               mem_data_func         stall lat src sink"),
  [ "read_capacity",         read_capacity,         read_capacity_mem,    0.0,  0,  0,  0    ],
  [ "read_miss_1word",       read_miss_1word_msg,   read_miss_1word_mem,  0.0,  0,  0,  0    ],

])

@pytest.mark.parametrize( **test_case_table_generic )
def test_instbuffer( test_params, dump_vcd, test_verilog ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem = test_params.mem_data_func( 0 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         InstBuffer, 2, 32, False, dump_vcd, test_verilog )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )

