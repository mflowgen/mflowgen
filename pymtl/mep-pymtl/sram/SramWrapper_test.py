#=========================================================================
# SramWrapper_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct

from pymtl       import *
from pclib.ifcs  import MemReqMsg, MemRespMsg
from pclib.test  import mk_test_case_table, run_sim
from pclib.test  import TestSource, TestSink

from SramWrapper import SramWrapper

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs_A, sink_msgs_A, src_msgs_B, sink_msgs_B,
                src_delay, sink_delay, SramModel,
                dump_vcd = False, test_verilog = False ):

    # Instantiate models

    s.src_a  = TestSource( MemReqMsg( 8, 32, 32 ),  src_msgs_A,  src_delay  )
#    s.src_b  = TestSource( MemReqMsg( 8, 32, 32 ),  src_msgs_B,  src_delay  )
    s.sram   = SramModel
    s.sink_a = TestSink  ( MemRespMsg( 8, 32 ), sink_msgs_A, sink_delay )
#    s.sink_b = TestSink  ( MemRespMsg( 8, 32 ), sink_msgs_B, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.sram.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.sram = TranslationTool( s.sram, enable_blackbox=True, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src_a.out,  s.sram.memreqa  )
    s.connect( s.sink_a.in_, s.sram.memrespa )

#    s.connect( s.src_b.out,  s.sram.memreqb  )
#    s.connect( s.sink_b.in_, s.sram.memrespb )

  def done( s ):
    return s.src_a.done and s.sink_a.done# and s.src_b.done and s.sink_b.done

  def line_trace( s ):
    return s.src_a.line_trace() + ' > ' + s.sram.line_trace() + ' > ' + s.sink_a.line_trace()

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
# Message generation: random
#----------------------------------------------------------------------
# This function generates random-data messages starting from the base
# address and going up, word offset by 2 address bits. Note that this may
# mean that all requests go to the same SRAM sub-array.
#
# There are num_msgs write requests to initialize memory, followed by an
# additional num_msgs read/write requests to _any_ of the addresses.
#
# Note that max_addr doesn't do anything for random_msgs but is here to
# match arguments with random_addr_msgs
#
# Note that opaque_is_id sets the opaque field to the message id.
# Otherwise it sets it to 0.

def random_msgs( base_addr = 0x0, max_addr = 0x00d0, num_msgs = 20,
    opaque_is_id = True ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  vmem = [ rgen.randint(0,0xffffffff) for _ in range(num_msgs) ]
  msgs = []

  for i in range(num_msgs):
    opaque = i if opaque_is_id else 0
    msgs.extend([
      req( 'wr', opaque, base_addr+4*i, 0, vmem[i] ), resp( 'wr', opaque, 0, 0 ),
    ])

  for i in range(num_msgs):
    opaque = i if opaque_is_id else 0
    idx = rgen.randint(0,num_msgs-1)

    if rgen.randint(0,1):

      correct_data = vmem[idx]
      msgs.extend([
        req( 'rd', opaque, base_addr+4*idx, 0, 0 ), resp( 'rd', opaque, 0, correct_data ),
      ])

    else:

      new_data = rgen.randint(0,0xffffffff)
      vmem[idx] = new_data
      msgs.extend([
        req( 'wr', opaque, base_addr+4*idx, 0, new_data ), resp( 'wr', opaque, 0, 0 ),
      ])

  return msgs

#----------------------------------------------------------------------
# Message generation: random_addr_msgs
#----------------------------------------------------------------------
# Same as random_msgs except..
#
# This function generates random-data messages to random, unique addresses
# word offset by 2 address bits. The uniqueness makes it easier to track
# correct data.
#
# There are num_msgs write requests to initialize memory, followed by an
# additional num_msgs read/write requests to _any_ of the addresses.
#
# Note that opaque_is_id sets the opaque field to the message id.
# Otherwise it sets it to 0.

def random_addr_msgs( base_addr = 0x0, max_addr = 0x00d0, num_msgs = 20,
    opaque_is_id = True ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  vmem = [ rgen.randint(0,0xffffffff) for _ in range(num_msgs) ]
  msgs = []

  # Generate a unique random address within the address range for each
  # msg. Addresses are inclusive of base_addr and exclusive of max_addr.

  # Lower two bits are zero for offset.

  vaddr = set()
  count = 0
  while len( vaddr ) != num_msgs:
    vaddr.add( rgen.randint( base_addr, max_addr-1 ) & 0xfffffffc )

    # Stop trying if we cannot find num_msgs unique addresses

    count = count + 1
    assert count < num_msgs*10, \
        'Could not fit {:d} msgs into addr space 0x{:x} to 0x{:x}'.format(
            num_msgs, base_addr, max_addr )

  # Zero out the lower two bits for offset

  vaddr = [ addr & 0xfffffffc for addr in vaddr ]

  for i in range(num_msgs):
    opaque = i if opaque_is_id else 0
    msgs.extend([
      req( 'wr', opaque, vaddr[i], 0, vmem[i] ), resp( 'wr', opaque, 0, 0 ),
    ])

  for i in range(num_msgs):
    opaque = i if opaque_is_id else 0
    idx = rgen.randint(0,num_msgs-1)

    if rgen.randint(0,1):

      correct_data = vmem[idx]
      msgs.extend([
        req( 'rd', opaque, vaddr[idx], 0, 0 ), resp( 'rd', opaque, 0, correct_data ),
      ])

    else:

      new_data = rgen.randint(0,0xffffffff)
      vmem[idx] = new_data
      msgs.extend([
        req( 'wr', opaque, vaddr[idx], 0, new_data ), resp( 'wr', opaque, 0, 0 ),
      ])

  return msgs

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

  dut       = SramWrapper(32,2048,2) # Ex. 32b word size * 6144 words = 24KB

  base_addr = 0x0
  max_addr  = 0x2000 # 0x8000 is 32KB, 0x4000 is 16KB, 0x2000 is 8KB
  num_msgs  = 100 # 256 msgs max, because msg num goes into opaque field
  msgs_A = test_params.msg_func_A( base_addr, max_addr, num_msgs )
  msgs_B = test_params.msg_func_B( base_addr, max_addr, num_msgs )

  # Instantiate testharness

  harness = TestHarness( msgs_A[::2], msgs_A[1::2],
                         msgs_B[::2], msgs_B[1::2],
                         test_params.src, test_params.sink,
                         dut, dump_vcd, test_verilog )
  # Run the test

  run_sim( harness, dump_vcd )

