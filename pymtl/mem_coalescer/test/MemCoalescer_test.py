#=========================================================================
# FunnelRouter_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct
import math

random.seed(0xa4e28cc2)

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource
from pclib.test import TestSink
from pclib.test import TestMemory

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg,    MemReqMsg,    MemRespMsg
from ifcs import MemMsg4B,  MemReqMsg4B,  MemRespMsg4B
from ifcs import MemMsg16B, MemReqMsg16B, MemRespMsg16B

from mem_coalescer.MemCoalescer import MemCoalescer

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, nports, coalescing_en, src_msgs, sink_msgs,
                stall_prob, latency,
                src_delay, sink_delay,
                dump_vcd, test_verilog = False ):

    # Number of requesting ports

    s.nports = nports

    # Messge type

    mem_msgs   = MemMsg4B()

    # Instantiate models
    s.srcs          = [ TestSource ( mem_msgs.req, src_msgs[i::nports], src_delay + i ) \
                          for i in range( nports ) ]
    s.mem_coalescer = MemCoalescer ( nports, mem_msgs.req, mem_msgs.resp )
    s.mem           = TestMemory( mem_msgs, 1, stall_prob, latency )
    s.sinks         = [ TestSink ( mem_msgs.resp, sink_msgs[i::nports], sink_delay ) \
                          for i in range( nports ) ]

    s.mem_coalescer.coalescing_en = coalescing_en

    # Dump VCD

    if dump_vcd:
      s.mem_coalescer.vcd_file = dump_vcd

    # verilog translation
    if test_verilog:
      s.mem_coalescer = TranslationTool( s.mem_coalescer, verilator_xinit = test_verilog )

    # Connect

    for i in range( nports ):
      s.connect( s.srcs[i].out,            s.mem_coalescer.reqs[i] )
      s.connect( s.mem_coalescer.resps[i], s.sinks[i].in_          )

    s.connect( s.mem_coalescer.memreq, s.mem.reqs[0]           )
    s.connect( s.mem.resps[0],         s.mem_coalescer.memresp )

  def load( s, addrs, data_ints ):
    for addr, data_int in zip( addrs, data_ints ):
      data_bytes_a = bytearray()
      data_bytes_a.extend( struct.pack("<I",data_int) )
      s.mem.write_mem( addr, data_bytes_a )

  def done( s ):
    done = True
    for i in range( s.nports ):
      done = done and s.srcs[i].done and s.sinks[i].done
    return done

  def line_trace( s ):
    trace = ''

    # srcs
    for i in range( s.nports ):
      trace = trace + s.srcs[i].line_trace() + ' : '
    trace = trace + ' '

    # mem_coalescer
    trace = trace + s.mem_coalescer.line_trace() + ' : '

#    # mem
#    trace = trace + s.mem.line_trace() + " "

    # sinks
    for i in range( s.nports ):
      trace = trace + s.sinks[i].line_trace() + ' : '

    return trace

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, opaque, addr, len_, data ):
  return MemMsg( 8, 32, 32 ).req.mk_msg( MemReqMsg.TYPE_READ, opaque, addr, len_, data )

def resp( type_, opaque, len_, data ):
  return MemMsg( 8, 32, 32 ).resp.mk_msg( MemRespMsg.TYPE_READ, opaque, len_, data )

#-------------------------------------------------------------------------
# Test cases
#
#   Test case format for n ports
#
#     Port 0:   req0, resp0,
#     Port 1:   req0, resp0,
#     Port i:   ...
#     Port n-1: req0, resp0,
#
#     Port 0:   req1, resp1,
#     Port 1:   req1, resp1,
#     Port i:   ...
#     Port n-1: req1, resp1,
#     ...
#
#-------------------------------------------------------------------------

def basic_2_ports_1_msg_no_coal( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000004, 0, 0    ), resp('rd', 0x01,  0, 0x00c0ffee ),
  ]

def basic_2_ports_1_msg_coal( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000000, 0, 0    ), resp('rd', 0x01,  0, 0xdeadbeef ),
  ]

def basic_4_ports_1_msg_no_coal( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000004, 0, 0    ), resp('rd', 0x01,  0, 0x00c0ffee ),
    req( 'rd', 0x02, 0x00000008, 0, 0    ), resp('rd', 0x02,  0, 0xdeadbee0 ),
    req( 'rd', 0x03, 0x0000000c, 0, 0    ), resp('rd', 0x03,  0, 0xdeadbee1 ),
  ]

def basic_4_ports_4_msg_no_coal( base_addr ):

  test_list = []
  for _ in range(4):
    test_list = test_list + [
      #    type  opq   addr      len  data         type  opq   len  data
      req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
      req( 'rd', 0x01, 0x00000004, 0, 0    ), resp('rd', 0x01,  0, 0x00c0ffee ),
      req( 'rd', 0x02, 0x00000008, 0, 0    ), resp('rd', 0x02,  0, 0xdeadbee0 ),
      req( 'rd', 0x03, 0x0000000c, 0, 0    ), resp('rd', 0x03,  0, 0xdeadbee1 ),
    ]

  return test_list

def basic_4_ports_1_msg_coal_all( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000000, 0, 0    ), resp('rd', 0x01,  0, 0xdeadbeef ),
    req( 'rd', 0x02, 0x00000000, 0, 0    ), resp('rd', 0x02,  0, 0xdeadbeef ),
    req( 'rd', 0x03, 0x00000000, 0, 0    ), resp('rd', 0x03,  0, 0xdeadbeef ),
  ]

def basic_4_ports_1_msg_coal_02( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000004, 0, 0    ), resp('rd', 0x01,  0, 0x00c0ffee ),
    req( 'rd', 0x02, 0x00000000, 0, 0    ), resp('rd', 0x02,  0, 0xdeadbeef ),
    req( 'rd', 0x03, 0x00000008, 0, 0    ), resp('rd', 0x03,  0, 0xdeadbee0 ),
  ]

def basic_4_ports_1_msg_coal_02_13( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000004, 0, 0    ), resp('rd', 0x01,  0, 0x00c0ffee ),
    req( 'rd', 0x02, 0x00000000, 0, 0    ), resp('rd', 0x02,  0, 0xdeadbeef ),
    req( 'rd', 0x03, 0x00000004, 0, 0    ), resp('rd', 0x03,  0, 0x00c0ffee ),
  ]

def basic_4_ports_1_msg_coal_01_23( base_addr ):

  return [
    #    type  opq   addr      len  data         type  opq   len  data
    req( 'rd', 0x00, 0x00000000, 0, 0    ), resp('rd', 0x00,  0, 0xdeadbeef ),
    req( 'rd', 0x01, 0x00000000, 0, 0    ), resp('rd', 0x01,  0, 0xdeadbeef ),
    req( 'rd', 0x02, 0x00000004, 0, 0    ), resp('rd', 0x02,  0, 0x00c0ffee ),
    req( 'rd', 0x03, 0x00000004, 0, 0    ), resp('rd', 0x03,  0, 0x00c0ffee ),
  ]

def basic_4_ports_rand( base_addr ):

  test_list = []

  ref_data  = mem_data(0)

  for i in range(256):
    rand_idx = random.randint(0, 3)
    test_list = test_list + [ req( 'rd', i, ref_data[rand_idx * 2], 0, 0 ), resp('rd', i, 0, ref_data[rand_idx * 2 + 1] ) ]

  return test_list

def basic_4_ports_1_addr( base_addr ):

  test_list = []

  ref_data  = mem_data(0)

  for i in range(256):
    test_list = test_list + [ req( 'rd', i, ref_data[0], 0, 0 ), resp('rd', i, 0, ref_data[1] ) ]

  return test_list

# Data to be loaded into memory before running the test

def mem_data( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee,
    0x00000008, 0xdeadbee0,
    0x0000000c, 0xdeadbee1,
  ]

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table_generic = mk_test_case_table([
  (                                         "msg_func                       mem_data_func   nports coalescing_en stall lat src sink"),

# disable coalescing logic

  [ "nocoal_2_ports_1_msg_no_coal",          basic_2_ports_1_msg_no_coal,    mem_data,       2,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_2_ports_1_msg_coal",             basic_2_ports_1_msg_coal,       mem_data,       2,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_2_ports_1_msg_no_coal_memd",     basic_2_ports_1_msg_no_coal,    mem_data,       2,     0,            0.0,  1,  0,  0    ],
  [ "nocoal_2_ports_1_msg_coal_memd",        basic_2_ports_1_msg_coal,       mem_data,       2,     0,            0.0,  1,  0,  0    ],

  [ "nocoal_4_ports_1_msg_no_coal",          basic_4_ports_1_msg_no_coal,    mem_data,       4,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_4_ports_1_msg_coal_all",         basic_4_ports_1_msg_coal_all,   mem_data,       4,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_4_ports_1_msg_coal_02",          basic_4_ports_1_msg_coal_02,    mem_data,       4,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_4_ports_1_msg_coal_02_13",       basic_4_ports_1_msg_coal_02_13, mem_data,       4,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_4_ports_1_msg_coal_01_23",       basic_4_ports_1_msg_coal_01_23, mem_data,       4,     0,            0.0,  0,  0,  0    ],

  [ "nocoal_4_ports_4_msg_no_coal",          basic_4_ports_4_msg_no_coal,    mem_data,       4,     0,            0.0,  4,  0,  0    ],
  [ "nocoal_4_ports_4_msg_no_coal_d",        basic_4_ports_4_msg_no_coal,    mem_data,       4,     0,            0.2,  3,  2,  4    ],

  [ "nocoal_4_ports_rand",                   basic_4_ports_rand,             mem_data,       4,     0,            0.0,  0,  0,  0    ],
  [ "nocoal_4_ports_rand_d",                 basic_4_ports_rand,             mem_data,       4,     0,            0.4,  2,  4,  10   ],
  [ "nocoal_4_ports_1_addr",                 basic_4_ports_1_addr,           mem_data,       4,     0,            0.4,  6,  4,  10   ],

# enable coalescing logic

  [ "coal_2_ports_1_msg_no_coal",            basic_2_ports_1_msg_no_coal,    mem_data,       2,     1,            0.0,  0,  0,  0    ],
  [ "coal_2_ports_1_msg_coal",               basic_2_ports_1_msg_coal,       mem_data,       2,     1,            0.0,  0,  0,  0    ],
  [ "coal_2_ports_1_msg_no_coal_memd",       basic_2_ports_1_msg_no_coal,    mem_data,       2,     1,            0.0,  1,  0,  0    ],
  [ "coal_2_ports_1_msg_coal_memd",          basic_2_ports_1_msg_coal,       mem_data,       2,     1,            0.0,  1,  0,  0    ],

  [ "coal_4_ports_1_msg_no_coal",            basic_4_ports_1_msg_no_coal,    mem_data,       4,     1,            0.0,  0,  0,  0    ],
  [ "coal_4_ports_1_msg_coal_all",           basic_4_ports_1_msg_coal_all,   mem_data,       4,     1,            0.0,  0,  0,  0    ],
  [ "coal_4_ports_1_msg_coal_02",            basic_4_ports_1_msg_coal_02,    mem_data,       4,     1,            0.0,  0,  0,  0    ],
  [ "coal_4_ports_1_msg_coal_02_13",         basic_4_ports_1_msg_coal_02_13, mem_data,       4,     1,            0.0,  0,  0,  0    ],
  [ "coal_4_ports_1_msg_coal_01_23",         basic_4_ports_1_msg_coal_01_23, mem_data,       4,     1,            0.0,  0,  0,  0    ],

  [ "coal_4_ports_4_msg_no_coal",            basic_4_ports_4_msg_no_coal,    mem_data,       4,     1,            0.0,  4,  0,  0    ],
  [ "coal_4_ports_4_msg_no_coal_d",          basic_4_ports_4_msg_no_coal,    mem_data,       4,     1,            0.2,  3,  2,  4    ],

  [ "coal_4_ports_rand",                     basic_4_ports_rand,             mem_data,       4,     1,            0.0,  0,  0,  0    ],
  [ "coal_4_ports_rand_d",                   basic_4_ports_rand,             mem_data,       4,     1,            0.4,  2,  4,  10   ],
  [ "coal_4_ports_1_addr",                   basic_4_ports_1_addr,           mem_data,       4,     1,            0.4,  6,  4,  10   ],
])

@pytest.mark.parametrize( **test_case_table_generic )
def test_generic( test_params, dump_vcd, test_verilog ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem = test_params.mem_data_func( 0 )

  # Instantiate testharness
  harness = TestHarness( test_params.nports,
                         test_params.coalescing_en,
                         msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         dump_vcd, test_verilog )

  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )

  # Run the test
  run_sim( harness, dump_vcd )
