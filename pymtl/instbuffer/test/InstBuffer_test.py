#=========================================================================
# DirectMappedInstBuffer_test.py
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
                src_delay, sink_delay, model, num_entries, line_nbytes, host_off,
                dump_vcd, test_verilog=False ):

    # Messge type

    buff_msgs = MemMsg(8,32,32)
    mem_msgs  = MemMsg(8,32,line_nbytes*8)

    # Instantiate models

    s.src   = TestSource   ( buff_msgs.req,  src_msgs,  src_delay  )
    s.model = model        ( num_entries, line_nbytes )
    s.mem   = TestMemory   ( mem_msgs, 1, stall_prob, latency )
    s.sink  = TestCacheSink( buff_msgs.resp, sink_msgs, sink_delay, not host_off )

    # Dump VCD

    if dump_vcd:
      s.model.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.model = TranslationTool( s.model )

    # Connect

    s.connect( s.model.host_off, host_off )

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

#-------------------------------------------------------------------------
# Test Case: simple
#-------------------------------------------------------------------------

def simple_msgs( base_addr, num_entries, line_nbytes ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'rd', 0x00, 0x00000000, 0, 0          ), resp('rd', 0x00, 0, 0, 0xdeadbeef ), # read word  0x00000000
    req( 'rd', 0x01, 0x00000004, 0, 0          ), resp('rd', 0x01, 1, 0, 0x00c0ffee ), # read word  0x00000004
  ]

# Data to be loaded into memory before running the test

def simple_mem( base_addr, num_entries, line_nbytes ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee,
  ]

#----------------------------------------------------------------------
# Test Case: read miss and hit path, many requests
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT
# If I increment the address by half the line size, every other request
# starting from the first one, will be miss, and the one after each is a
# hit

def stream_msgs( base_addr, num_entries, line_nbytes ):
  array = []
  #                    type  opq  addr          len data
  for i in xrange(100):
    array.append(req(  'rd', 0x1, base_addr+line_nbytes/2*i, 0, 0 ))
  #                    type  opq  test          len data
    array.append(resp( 'rd', 0x1, i%2,              0, i ))

  return array

def stream_mem( base_addr, num_entries, line_nbytes ):
  mem = []
  for i in xrange(100):
    # addr
    mem.append(line_nbytes/2*i)
    #data (in int)
    mem.append(i)
  return mem

#----------------------------------------------------------------------
# Test Case: read miss and hit path, many requests
#----------------------------------------------------------------------
# Under directed mapped scheme, these are all conflict misses

def fully_assoc_msgs( base_addr, num_entries, line_nbytes ):
  array = []
  #                    type  opq  addr                               len data      type  opq  test len data
  array.extend( [ req( 'rd', 0x0, base_addr,                         0, 0 ), resp( 'rd', 0x0, 0,   0,  1 ) ] )
  array.extend( [ req( 'rd', 0x0, base_addr+num_entries*line_nbytes, 0, 0 ), resp( 'rd', 0x0, 0,   0,  2 ) ] )
  array.extend( [ req( 'rd', 0x0, base_addr,                         0, 0 ), resp( 'rd', 0x0, 0,   0,  1 ) ] )
  array.extend( [ req( 'rd', 0x0, base_addr+num_entries*line_nbytes, 0, 0 ), resp( 'rd', 0x0, 0,   0,  2 ) ] )

  return array

def fully_assoc_mem( base_addr, num_entries, line_nbytes ):
  mem = [
    base_addr,                         1,
    base_addr+num_entries*line_nbytes, 2,
  ]
  return mem

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table_generic = mk_test_case_table([
  (                   "msg_func          mem_data_func    off stall lat src sink"),
  [ "stream_on",       stream_msgs,      stream_mem,      0,  0.0,  0,  0,  0    ],
  [ "stream_on_lat",   stream_msgs,      stream_mem,      0,  0.5,  4,  3,  14   ],
  [ "stream_off_lat",  stream_msgs,      stream_mem,      1,  0.0,  0,  0,  0    ],
  [ "stream_off_lat",  stream_msgs,      stream_mem,      1,  0.5,  4,  3,  14   ],
])

@pytest.mark.parametrize( **test_case_table_generic )
def test_instbuffer_2entries_32byte( test_params, dump_vcd, test_verilog ):
  msgs = test_params.msg_func( 0, 2, 32 )
  if test_params.mem_data_func != None:
    mem = test_params.mem_data_func( 0, 2, 32 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         InstBuffer, 2, 32, test_params.off, dump_vcd, test_verilog )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )

