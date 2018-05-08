#=========================================================================
# BlockingCacheWideAccessFL_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg,    MemReqMsg,    MemRespMsg
from ifcs import MemMsg4B,  MemReqMsg4B,  MemRespMsg4B
from ifcs import MemMsg16B, MemReqMsg16B, MemRespMsg16B

from TestCacheSink   import TestCacheSink
from cache_wa.BlockingCacheWideAccessFL import BlockingCacheWideAccessFL

# We define all test cases here. They will be used to test _both_ FL and
# RTL models.
#
# Notice the difference between the TestHarness instances in FL and RTL.
#
# class TestHarness( Model ):
#   def __init__( s, src_msgs, sink_msgs, stall_prob, latency,
#                 src_delay, sink_delay, CacheModel, check_test, dump_vcd )
#
# The last parameter of TestHarness, check_test is whether or not we
# check the test field in the cacheresp. In FL model we don't care about
# test field and we set cehck_test to be False because FL model is just
# passing through cachereq to mem, so all cachereq sent to the FL model
# will be misses, whereas in RTL model we must set cehck_test to be True
# so that the test sink will know if we hit the cache properly.

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs, sink_msgs, stall_prob, latency,
                src_delay, sink_delay, CacheModel, check_test, dump_vcd,
                test_verilog = False ):

    # Messge type

    cache_msgs = MemMsg16B()
    mem_msgs   = MemMsg16B()

    # Instantiate models

    s.src   = TestSource   ( cache_msgs.req,  src_msgs,  src_delay  )
    s.cache = CacheModel   ( )
    s.mem   = TestMemory   ( mem_msgs, 1, stall_prob, latency )
    s.sink  = TestCacheSink( cache_msgs.resp, sink_msgs, sink_delay, check_test )

    # Fix module name

    s.cache.explicit_modulename = s.cache.__class__.__name__

    # Dump VCD

    if dump_vcd:
      s.cache.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.cache = TranslationTool( s.cache, enable_blackbox=True, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src.out,       s.cache.cachereq  )
    s.connect( s.sink.in_,      s.cache.cacheresp )

    s.connect( s.cache.memreq,  s.mem.reqs[0]     )
    s.connect( s.cache.memresp, s.mem.resps[0]    )

  def load( s, addrs, data_ints ):
    for addr, data_int in zip( addrs, data_ints ):
      data_bytes_a = bytearray()
      data_bytes_a.extend( struct.pack("<I",data_int) )
      s.mem.write_mem( addr, data_bytes_a )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace() + " " + s.cache.line_trace() + " " \
         + s.mem.line_trace() + " " + s.sink.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, opaque, addr, len, data ):
  msg = MemReqMsg16B()

  if   type_ == 'rd' : msg.type_ = MemReqMsg.TYPE_READ
  elif type_ == 'wr' : msg.type_ = MemReqMsg.TYPE_WRITE
  elif type_ == 'in' : msg.type_ = MemReqMsg.TYPE_WRITE_INIT
  elif type_ == 'ad' : msg.type_ = MemReqMsg.TYPE_AMO_ADD
  elif type_ == 'an' : msg.type_ = MemReqMsg.TYPE_AMO_AND
  elif type_ == 'or' : msg.type_ = MemReqMsg.TYPE_AMO_OR
  elif type_ == 'sp' : msg.type_ = MemReqMsg.TYPE_AMO_SWAP
  elif type_ == 'mn' : msg.type_ = MemReqMsg.TYPE_AMO_MIN
  elif type_ == 'mnu': msg.type_ = MemReqMsg.TYPE_AMO_MINU
  elif type_ == 'mx' : msg.type_ = MemReqMsg.TYPE_AMO_MAX
  elif type_ == 'mxu': msg.type_ = MemReqMsg.TYPE_AMO_MAXU
  elif type_ == 'xr' : msg.type_ = MemReqMsg.TYPE_AMO_XOR

  # Address is assumed to be word aligned
  msg.addr   = addr
  msg.opaque = opaque
  msg.len    = len
  msg.data   = data
  return msg

def resp( type_, opaque, test, len, data ):
  msg = MemRespMsg16B()

  if   type_ == 'rd' : msg.type_ = MemRespMsg.TYPE_READ
  elif type_ == 'wr' : msg.type_ = MemRespMsg.TYPE_WRITE
  elif type_ == 'in' : msg.type_ = MemRespMsg.TYPE_WRITE_INIT
  elif type_ == 'ad' : msg.type_ = MemRespMsg.TYPE_AMO_ADD
  elif type_ == 'an' : msg.type_ = MemRespMsg.TYPE_AMO_AND
  elif type_ == 'or' : msg.type_ = MemRespMsg.TYPE_AMO_OR
  elif type_ == 'sp' : msg.type_ = MemRespMsg.TYPE_AMO_SWAP
  elif type_ == 'mn' : msg.type_ = MemRespMsg.TYPE_AMO_MIN
  elif type_ == 'mnu': msg.type_ = MemRespMsg.TYPE_AMO_MINU
  elif type_ == 'mx' : msg.type_ = MemRespMsg.TYPE_AMO_MAX
  elif type_ == 'mxu': msg.type_ = MemRespMsg.TYPE_AMO_MAXU
  elif type_ == 'xr' : msg.type_ = MemRespMsg.TYPE_AMO_XOR

  msg.opaque = opaque
  msg.len    = len
  msg.test   = test
  msg.data   = data
  return msg

#----------------------------------------------------------------------
# Test Case: read hit path
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

def read_hit_1word_clean( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data
    req( 'in', 0x0, base_addr, 0, 0xdeadbeef ), resp( 'in', 0x0, 0,   0,  0          ),
    req( 'rd', 0x1, base_addr, 0, 0          ), resp( 'rd', 0x1, 1,   0,  0xdeadbeef ),
  ]

#----------------------------------------------------------------------
# Test Case: read hit/miss path, many requests
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

def read_hit_many_clean( base_addr ):
  array = []
  for i in xrange(4):
    #                  type  opq  addr          len data

    array.append(req(  'in', 0x0, base_addr+32*i, 0, i ))
    #                  type  opq  test          len data
    array.append(resp( 'in', 0x0, 0,             0, 0 ))

  for i in xrange(4):
    array.append(req(  'rd', 0x1, base_addr+32*i, 0, 0 ))
    array.append(resp( 'rd', 0x1, 1,             0, i ))

  return array

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


#----------------------------------------------------------------------
# Test Case: read hit path -- for set-associative cache
#----------------------------------------------------------------------
# This set of tests designed only for alternative design
# The test field in the response message: 0 == MISS, 1 == HIT

def read_hit_asso( base_addr ):
  return [
    #    type  opq  addr       len data                type  opq  test len data
    req( 'wr', 0x0, 0x00000000, 0, 0xdeadbeef ), resp( 'wr', 0x0, 0,   0,  0          ),
    req( 'wr', 0x1, 0x00001000, 0, 0x00c0ffee ), resp( 'wr', 0x1, 0,   0,  0          ),
    req( 'rd', 0x2, 0x00000000, 0, 0          ), resp( 'rd', 0x2, 1,   0,  0xdeadbeef ),
    req( 'rd', 0x3, 0x00001000, 0, 0          ), resp( 'rd', 0x3, 1,   0,  0x00c0ffee ),
  ]

#----------------------------------------------------------------------
# Test Case: read hit path -- for direct-mapped cache
#----------------------------------------------------------------------
# This set of tests designed only for baseline design

def read_hit_dmap( base_addr ):
  return [
    #    type  opq  addr       len data                type  opq  test len data
    req( 'wr', 0x0, 0x00000000, 0, 0xdeadbeef ), resp( 'wr', 0x0, 0,   0,  0          ), # compulsory miss
    req( 'wr', 0x1, 0x00001000, 0, 0x00c0ffee ), resp( 'wr', 0x1, 0,   0,  0          ), # compulsory miss
    req( 'rd', 0x2, 0x00000000, 0, 0          ), resp( 'rd', 0x2, 0,   0,  0xdeadbeef ), # confilict miss
    req( 'rd', 0x3, 0x00001000, 0, 0          ), resp( 'rd', 0x3, 0,   0,  0x00c0ffee ), # confilict miss
  ]

#-------------------------------------------------------------------------
# Test Case: write hit path
#-------------------------------------------------------------------------

def write_hit_1word_clean( base_addr ):
  return [
    #    type  opq   addr      len data               type  opq   test len data
    req( 'in', 0x00, base_addr, 0, 0x0a0b0c0d ), resp('in', 0x00, 0,   0,  0          ), # write word  0x00000000
    req( 'wr', 0x01, base_addr, 0, 0xbeefbeeb ), resp('wr', 0x01, 1,   0,  0          ), # write word  0x00000000
    req( 'rd', 0x02, base_addr, 0, 0          ), resp('rd', 0x02, 1,   0,  0xbeefbeeb ), # read  word  0x00000000
  ]

#-------------------------------------------------------------------------
# Test Case: read miss path
#-------------------------------------------------------------------------

def read_miss_1word_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'rd', 0x00, 0x00000000, 0, 0          ), resp('rd', 0x00, 0, 0, 0x00c0ffeedeadbeef ), # read word  0x00000000
    req( 'rd', 0x01, 0x00000004, 4, 0          ), resp('rd', 0x01, 1, 4,         0x00c0ffee ), # read word  0x00000004
  ]

# Data to be loaded into memory before running the test

def read_miss_1word_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee,
  ]

#-------------------------------------------------------------------------
# Test cases: more on read-hit path
#-------------------------------------------------------------------------

def read_hit_1word_dirty( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data
    req( 'in', 0x0, base_addr, 4, 0xdeadbeef ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'wr', 0x1, base_addr, 4, 0xbabababa ), resp( 'wr', 0x1, 1,   4,  0          ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0xbabababa ),
  ]

def read_hit_1line_clean( base_addr ):
  return [
    req( 'in', 0x0, base_addr,    4, 0xdeadbeef ), resp( 'in', 0x0, 0, 4, 0          ),
    req( 'in', 0x1, base_addr+4,  4, 0xcafecafe ), resp( 'in', 0x1, 0, 4, 0          ),
    req( 'in', 0x2, base_addr+8,  4, 0xfafafafa ), resp( 'in', 0x2, 0, 4, 0          ),
    req( 'in', 0x3, base_addr+12, 4, 0xbabababa ), resp( 'in', 0x3, 0, 4, 0          ),
    req( 'rd', 0x4, base_addr,    4, 0          ), resp( 'rd', 0x4, 1, 4, 0xdeadbeef ),
    req( 'rd', 0x5, base_addr+4,  4, 0          ), resp( 'rd', 0x5, 1, 4, 0xcafecafe ),
    req( 'rd', 0x6, base_addr+8,  4, 0          ), resp( 'rd', 0x6, 1, 4, 0xfafafafa ),
    req( 'rd', 0x7, base_addr+12, 4, 0          ), resp( 'rd', 0x7, 1, 4, 0xbabababa ),
  ]

#-------------------------------------------------------------------------
# Test cases: more on write-hit path
#-------------------------------------------------------------------------

def write_hit_1word_dirty( base_addr ):
  return [
    #    type  opq   addr      len data               type  opq   test len data
    req( 'in', 0x00, base_addr, 4, 0x0a0b0c0d ), resp('in', 0x00, 0,   4,  0          ), # write word  0x00000000
    req( 'wr', 0x01, base_addr, 4, 0xbeefbeeb ), resp('wr', 0x01, 1,   4,  0          ), # write word  0x00000000
    req( 'wr', 0x02, base_addr, 4, 0xc0ffeebb ), resp('wr', 0x02, 1,   4,  0          ), # write word  0x00000000
    req( 'rd', 0x03, base_addr, 4, 0          ), resp('rd', 0x03, 1,   4,  0xc0ffeebb ), # read  word  0x00000000
  ]

#----------------------------------------------------------------------
# Test Case: amo hit path
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

def amo_hit_1word_clean( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data
    req( 'in', 0x0, base_addr, 4, 0xdeadbeef ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'ad', 0x1, base_addr, 4, 0x00000001 ), resp( 'ad', 0x1, 1,   4,  0xdeadbeef ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0xdeadbef0 ),
  ]

#-------------------------------------------------------------------------
# Test Case: amo miss path
#-------------------------------------------------------------------------

def amo_miss_1word_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'ad', 0x00, 0x00000000, 4, 0x00000001 ), resp('ad', 0x00, 0, 4, 0xdeadbeef ), # amo  word  0x00000000
    req( 'ad', 0x01, 0x00000004, 4, 0x00000001 ), resp('ad', 0x01, 1, 4, 0x00c0ffee ), # amo  word  0x00000004
    req( 'rd', 0x02, 0x00000000, 4, 0          ), resp('rd', 0x02, 1, 4, 0xdeadbef0 ), # read word  0x00000000
    req( 'rd', 0x03, 0x00000004, 4, 0          ), resp('rd', 0x03, 1, 4, 0x00c0ffef ), # read word  0x00000004
  ]

# Data to be loaded into memory before running the test

def amo_miss_1word_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee,
  ]

#----------------------------------------------------------------------
# Test Case: more amo hit path
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

def amo_hit_more_clean( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data

    # AMO add 1 repeatedly

    req( 'in', 0x0, base_addr, 4, 0xdeadbeef ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'ad', 0x1, base_addr, 4, 0x00000001 ), resp( 'ad', 0x1, 1,   4,  0xdeadbeef ),
    req( 'ad', 0x2, base_addr, 4, 0x00000001 ), resp( 'ad', 0x2, 1,   4,  0xdeadbef0 ),
    req( 'ad', 0x3, base_addr, 4, 0x00000001 ), resp( 'ad', 0x3, 1,   4,  0xdeadbef1 ),
    req( 'ad', 0x4, base_addr, 4, 0x00000001 ), resp( 'ad', 0x4, 1,   4,  0xdeadbef2 ),
    req( 'ad', 0x5, base_addr, 4, 0x00000001 ), resp( 'ad', 0x5, 1,   4,  0xdeadbef3 ),
    req( 'ad', 0x6, base_addr, 4, 0x00000001 ), resp( 'ad', 0x6, 1,   4,  0xdeadbef4 ),
    req( 'ad', 0x7, base_addr, 4, 0x00000001 ), resp( 'ad', 0x7, 1,   4,  0xdeadbef5 ),
    req( 'ad', 0x8, base_addr, 4, 0x00000001 ), resp( 'ad', 0x8, 1,   4,  0xdeadbef6 ),

    # AMO and with shifting 0

    req( 'in', 0x0, base_addr, 4, 0xffffffff ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'an', 0x1, base_addr, 4, 0xfffffff0 ), resp( 'an', 0x1, 1,   4,  0xffffffff ),
    req( 'an', 0x2, base_addr, 4, 0xffffff0f ), resp( 'an', 0x2, 1,   4,  0xfffffff0 ),
    req( 'an', 0x3, base_addr, 4, 0xfffff0ff ), resp( 'an', 0x3, 1,   4,  0xffffff00 ),
    req( 'an', 0x4, base_addr, 4, 0xffff0fff ), resp( 'an', 0x4, 1,   4,  0xfffff000 ),
    req( 'an', 0x5, base_addr, 4, 0xfff0ffff ), resp( 'an', 0x5, 1,   4,  0xffff0000 ),
    req( 'an', 0x6, base_addr, 4, 0xff0fffff ), resp( 'an', 0x6, 1,   4,  0xfff00000 ),
    req( 'an', 0x7, base_addr, 4, 0xf0ffffff ), resp( 'an', 0x7, 1,   4,  0xff000000 ),
    req( 'an', 0x8, base_addr, 4, 0x0fffffff ), resp( 'an', 0x8, 1,   4,  0xf0000000 ),

    # AMO or with shifting f

    req( 'in', 0x0, base_addr, 4, 0x00000000 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'or', 0x1, base_addr, 4, 0x0000000f ), resp( 'or', 0x1, 1,   4,  0x00000000 ),
    req( 'or', 0x2, base_addr, 4, 0x000000f0 ), resp( 'or', 0x2, 1,   4,  0x0000000f ),
    req( 'or', 0x3, base_addr, 4, 0x00000f00 ), resp( 'or', 0x3, 1,   4,  0x000000ff ),
    req( 'or', 0x4, base_addr, 4, 0x0000f000 ), resp( 'or', 0x4, 1,   4,  0x00000fff ),
    req( 'or', 0x5, base_addr, 4, 0x000f0000 ), resp( 'or', 0x5, 1,   4,  0x0000ffff ),
    req( 'or', 0x6, base_addr, 4, 0x00f00000 ), resp( 'or', 0x6, 1,   4,  0x000fffff ),
    req( 'or', 0x7, base_addr, 4, 0x0f000000 ), resp( 'or', 0x7, 1,   4,  0x00ffffff ),
    req( 'or', 0x8, base_addr, 4, 0xf0000000 ), resp( 'or', 0x8, 1,   4,  0x0fffffff ),

    # AMO swap ping-pong

    req( 'in', 0x0, base_addr, 4, 0xcafebabe ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'sp', 0x1, base_addr, 4, 0xffffffff ), resp( 'sp', 0x1, 1,   4,  0xcafebabe ),
    req( 'sp', 0x2, base_addr, 4, 0xcafebabe ), resp( 'sp', 0x2, 1,   4,  0xffffffff ),
    req( 'sp', 0x3, base_addr, 4, 0xffffffff ), resp( 'sp', 0x3, 1,   4,  0xcafebabe ),
    req( 'sp', 0x4, base_addr, 4, 0xcafebabe ), resp( 'sp', 0x4, 1,   4,  0xffffffff ),
    req( 'sp', 0x5, base_addr, 4, 0xffffffff ), resp( 'sp', 0x5, 1,   4,  0xcafebabe ),
    req( 'sp', 0x6, base_addr, 4, 0xcafebabe ), resp( 'sp', 0x6, 1,   4,  0xffffffff ),
    req( 'sp', 0x7, base_addr, 4, 0xffffffff ), resp( 'sp', 0x7, 1,   4,  0xcafebabe ),
    req( 'sp', 0x8, base_addr, 4, 0xcafebabe ), resp( 'sp', 0x8, 1,   4,  0xffffffff ),

    req( 'in', 0x0, base_addr, 4, 0x99999999 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'sp', 0x1, base_addr, 4, 0x88888888 ), resp( 'sp', 0x1, 1,   4,  0x99999999 ),
    req( 'sp', 0x2, base_addr, 4, 0x77777777 ), resp( 'sp', 0x2, 1,   4,  0x88888888 ),
    req( 'sp', 0x3, base_addr, 4, 0x66666666 ), resp( 'sp', 0x3, 1,   4,  0x77777777 ),
    req( 'sp', 0x4, base_addr, 4, 0x55555555 ), resp( 'sp', 0x4, 1,   4,  0x66666666 ),
    req( 'sp', 0x5, base_addr, 4, 0x44444444 ), resp( 'sp', 0x5, 1,   4,  0x55555555 ),
    req( 'sp', 0x6, base_addr, 4, 0x33333333 ), resp( 'sp', 0x6, 1,   4,  0x44444444 ),
    req( 'sp', 0x7, base_addr, 4, 0x22222222 ), resp( 'sp', 0x7, 1,   4,  0x33333333 ),
    req( 'sp', 0x8, base_addr, 4, 0x11111111 ), resp( 'sp', 0x8, 1,   4,  0x22222222 ),

    # AMO min

    req( 'in', 0x0, base_addr, 4, 0x55555555 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mn', 0x1, base_addr, 4, 0x77777777 ), resp( 'mn', 0x1, 1,   4,  0x55555555 ),
    req( 'mn', 0x2, base_addr, 4, 0x66666666 ), resp( 'mn', 0x2, 1,   4,  0x55555555 ),
    req( 'mn', 0x3, base_addr, 4, 0x55555555 ), resp( 'mn', 0x3, 1,   4,  0x55555555 ),
    req( 'mn', 0x4, base_addr, 4, 0x44444444 ), resp( 'mn', 0x4, 1,   4,  0x55555555 ),
    req( 'mn', 0x5, base_addr, 4, 0x33333333 ), resp( 'mn', 0x5, 1,   4,  0x44444444 ),
    req( 'mn', 0x6, base_addr, 4, 0x22222222 ), resp( 'mn', 0x6, 1,   4,  0x33333333 ),
    req( 'mn', 0x7, base_addr, 4, 0x11111111 ), resp( 'mn', 0x7, 1,   4,  0x22222222 ),

    # AMO min signedness tests

    req( 'in', 0x0, base_addr, 4, 0xffffffff ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mn', 0x1, base_addr, 4, 0x00000002 ), resp( 'mn', 0x1, 1,   4,  0xffffffff ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0xffffffff ),

    req( 'in', 0x0, base_addr, 4, 0x00000002 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mn', 0x1, base_addr, 4, 0xffffffff ), resp( 'mn', 0x1, 1,   4,  0x00000002 ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0xffffffff ),

    # AMO minu

    req( 'in',  0x0, base_addr, 4, 0x55555555 ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mnu', 0x1, base_addr, 4, 0x77777777 ), resp( 'mnu', 0x1, 1,   4,  0x55555555 ),
    req( 'mnu', 0x2, base_addr, 4, 0x66666666 ), resp( 'mnu', 0x2, 1,   4,  0x55555555 ),
    req( 'mnu', 0x3, base_addr, 4, 0x55555555 ), resp( 'mnu', 0x3, 1,   4,  0x55555555 ),
    req( 'mnu', 0x4, base_addr, 4, 0x44444444 ), resp( 'mnu', 0x4, 1,   4,  0x55555555 ),
    req( 'mnu', 0x5, base_addr, 4, 0x33333333 ), resp( 'mnu', 0x5, 1,   4,  0x44444444 ),
    req( 'mnu', 0x6, base_addr, 4, 0x22222222 ), resp( 'mnu', 0x6, 1,   4,  0x33333333 ),
    req( 'mnu', 0x7, base_addr, 4, 0x11111111 ), resp( 'mnu', 0x7, 1,   4,  0x22222222 ),

    # AMO minu signedness tests

    req( 'in',  0x0, base_addr, 4, 0xffffffff ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mnu', 0x1, base_addr, 4, 0x00000002 ), resp( 'mnu', 0x1, 1,   4,  0xffffffff ),
    req( 'rd',  0x2, base_addr, 4, 0          ), resp( 'rd',  0x2, 1,   4,  0x00000002 ),

    req( 'in',  0x0, base_addr, 4, 0x00000002 ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mnu', 0x1, base_addr, 4, 0xffffffff ), resp( 'mnu', 0x1, 1,   4,  0x00000002 ),
    req( 'rd',  0x2, base_addr, 4, 0          ), resp( 'rd',  0x2, 1,   4,  0x00000002 ),

    # AMO max

    req( 'in', 0x0, base_addr, 4, 0x55555555 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mx', 0x1, base_addr, 4, 0x22222222 ), resp( 'mx', 0x1, 1,   4,  0x55555555 ),
    req( 'mx', 0x2, base_addr, 4, 0x33333333 ), resp( 'mx', 0x2, 1,   4,  0x55555555 ),
    req( 'mx', 0x3, base_addr, 4, 0x44444444 ), resp( 'mx', 0x3, 1,   4,  0x55555555 ),
    req( 'mx', 0x4, base_addr, 4, 0x55555555 ), resp( 'mx', 0x4, 1,   4,  0x55555555 ),
    req( 'mx', 0x5, base_addr, 4, 0x66666666 ), resp( 'mx', 0x5, 1,   4,  0x55555555 ),
    req( 'mx', 0x6, base_addr, 4, 0x77777777 ), resp( 'mx', 0x6, 1,   4,  0x66666666 ),
    req( 'mx', 0x7, base_addr, 4, 0x88888888 ), resp( 'mx', 0x7, 1,   4,  0x77777777 ),

    # AMO max signedness tests

    req( 'in', 0x0, base_addr, 4, 0xffffffff ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mx', 0x1, base_addr, 4, 0x00000002 ), resp( 'mx', 0x1, 1,   4,  0xffffffff ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0x00000002 ),

    req( 'in', 0x0, base_addr, 4, 0x00000002 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'mx', 0x1, base_addr, 4, 0xffffffff ), resp( 'mx', 0x1, 1,   4,  0x00000002 ),
    req( 'rd', 0x2, base_addr, 4, 0          ), resp( 'rd', 0x2, 1,   4,  0x00000002 ),

    # AMO maxu

    req( 'in',  0x0, base_addr, 4, 0x55555555 ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mxu', 0x1, base_addr, 4, 0x22222222 ), resp( 'mxu', 0x1, 1,   4,  0x55555555 ),
    req( 'mxu', 0x2, base_addr, 4, 0x33333333 ), resp( 'mxu', 0x2, 1,   4,  0x55555555 ),
    req( 'mxu', 0x3, base_addr, 4, 0x44444444 ), resp( 'mxu', 0x3, 1,   4,  0x55555555 ),
    req( 'mxu', 0x4, base_addr, 4, 0x55555555 ), resp( 'mxu', 0x4, 1,   4,  0x55555555 ),
    req( 'mxu', 0x5, base_addr, 4, 0x66666666 ), resp( 'mxu', 0x5, 1,   4,  0x55555555 ),
    req( 'mxu', 0x6, base_addr, 4, 0x77777777 ), resp( 'mxu', 0x6, 1,   4,  0x66666666 ),
    req( 'mxu', 0x7, base_addr, 4, 0x88888888 ), resp( 'mxu', 0x7, 1,   4,  0x77777777 ),

    # AMO maxu signedness tests

    req( 'in',  0x0, base_addr, 4, 0xffffffff ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mxu', 0x1, base_addr, 4, 0x00000002 ), resp( 'mxu', 0x1, 1,   4,  0xffffffff ),
    req( 'rd',  0x2, base_addr, 4, 0          ), resp( 'rd',  0x2, 1,   4,  0xffffffff ),

    req( 'in',  0x0, base_addr, 4, 0x00000002 ), resp( 'in',  0x0, 0,   4,  0          ),
    req( 'mxu', 0x1, base_addr, 4, 0xffffffff ), resp( 'mxu', 0x1, 1,   4,  0x00000002 ),
    req( 'rd',  0x2, base_addr, 4, 0          ), resp( 'rd',  0x2, 1,   4,  0xffffffff ),

    # AMO xor with shifting f

    req( 'in', 0x0, base_addr, 4, 0xffff0000 ), resp( 'in', 0x0, 0,   4,  0          ),
    req( 'xr', 0x1, base_addr, 4, 0x0000000f ), resp( 'xr', 0x1, 1,   4,  0xffff0000 ),
    req( 'xr', 0x2, base_addr, 4, 0x000000f0 ), resp( 'xr', 0x2, 1,   4,  0xffff000f ),
    req( 'xr', 0x3, base_addr, 4, 0x00000f00 ), resp( 'xr', 0x3, 1,   4,  0xffff00ff ),
    req( 'xr', 0x4, base_addr, 4, 0x0000f000 ), resp( 'xr', 0x4, 1,   4,  0xffff0fff ),
    req( 'xr', 0x5, base_addr, 4, 0x000f0000 ), resp( 'xr', 0x5, 1,   4,  0xffffffff ),
    req( 'xr', 0x6, base_addr, 4, 0x00f00000 ), resp( 'xr', 0x6, 1,   4,  0xfff0ffff ),
    req( 'xr', 0x7, base_addr, 4, 0x0f000000 ), resp( 'xr', 0x7, 1,   4,  0xff00ffff ),
    req( 'xr', 0x8, base_addr, 4, 0xf0000000 ), resp( 'xr', 0x8, 1,   4,  0xf000ffff ),
  ]

#-------------------------------------------------------------------------
# Test Case: amo more miss path
#-------------------------------------------------------------------------

def amo_miss_more_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data

    # AMO add

    req( 'ad', 0x00, 0x00000000, 0, 0x00000002 ), resp('ad', 0x00, 0, 0, 0xdeadbeef ), # amo  word  0x00000000
    req( 'rd', 0x01, 0x00000000, 0, 0          ), resp('rd', 0x01, 1, 0, 0xdeadbef1 ), # read word  0x00000000

    # AMO and

    req( 'an', 0x00, 0x00000020, 0, 0x0000ffff ), resp('an', 0x00, 0, 0, 0x00c0ffee ), # amo  word  0x00000020
    req( 'rd', 0x01, 0x00000020, 0, 0          ), resp('rd', 0x01, 1, 0, 0x0000ffee ), # read word  0x00000020

    # AMO or

    req( 'or', 0x00, 0x00000040, 0, 0x0000ffff ), resp('or', 0x00, 0, 0, 0xcafebabe ), # amo  word  0x00000040
    req( 'rd', 0x01, 0x00000040, 0, 0          ), resp('rd', 0x01, 1, 0, 0xcafeffff ), # read word  0x00000040

    # AMO swap

    req( 'sp', 0x00, 0x00000060, 0, 0x0f0f0f0f ), resp('sp', 0x00, 0, 0, 0xffffffff ), # amo  word  0x00000060
    req( 'rd', 0x01, 0x00000060, 0, 0          ), resp('rd', 0x01, 1, 0, 0x0f0f0f0f ), # read word  0x00000060

    # AMO min

    req( 'mn', 0x00, 0x00000080, 0, 0xffffffff ), resp('mn', 0x00, 0, 0, 0x55555555 ), # amo  word  0x00000080
    req( 'rd', 0x01, 0x00000080, 0, 0          ), resp('rd', 0x01, 1, 0, 0xffffffff ), # read word  0x00000080

    # AMO minu

    req( 'mnu', 0x00, 0x000000a0, 0, 0xffffffff ), resp('mnu', 0x00, 0, 0, 0x55555555 ), # amo  word  0x000000a0
    req( 'rd',  0x01, 0x000000a0, 0, 0          ), resp('rd',  0x01, 1, 0, 0x55555555 ), # read word  0x000000a0

    # AMO max

    req( 'mx', 0x00, 0x000000c0, 0, 0xffffffff ), resp('mx', 0x00, 0, 0, 0x55555555 ), # amo  word  0x000000c0
    req( 'rd', 0x01, 0x000000c0, 0, 0          ), resp('rd', 0x01, 1, 0, 0x55555555 ), # read word  0x000000c0

    # AMO maxu

    req( 'mxu', 0x00, 0x000000e0, 0, 0xffffffff ), resp('mxu', 0x00, 0, 0, 0x55555555 ), # amo  word  0x000000e0
    req( 'rd',  0x01, 0x000000e0, 0, 0          ), resp('rd',  0x01, 1, 0, 0xffffffff ), # read word  0x000000e0

    # AMO xor

    req( 'xr', 0x00, 0x00000100, 0, 0xffffffff ), resp('xr', 0x00, 0, 0, 0x55555555 ), # amo  word  0x00000100
    req( 'rd', 0x01, 0x00000100, 0, 0          ), resp('rd', 0x01, 1, 0, 0xaaaaaaaa ), # read word  0x00000100

  ]

# Data to be loaded into memory before running the test

def amo_miss_more_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000020, 0x00c0ffee,
    0x00000040, 0xcafebabe,
    0x00000060, 0xffffffff,
    0x00000080, 0x55555555,
    0x000000a0, 0x55555555,
    0x000000c0, 0x55555555,
    0x000000e0, 0x55555555,
    0x00000100, 0x55555555,
  ]

#----------------------------------------------------------------------
# Test Case: random
#----------------------------------------------------------------------

def random_msgs( base_addr ):

  rgen = random.Random()
  rgen.seed(0xa4e28cc2)

  vmem = [ rgen.randint(0,0xffffffff) for _ in range(20) ]
  msgs = []

  for i in range(20):
    msgs.extend([
      req( 'wr', i, base_addr+4*i, 4, vmem[i] ), resp( 'wr', i, 2, 4, 0 ),
    ])

  for i in range(20):
    idx = rgen.randint(0,19)

    if rgen.randint(0,1):

      correct_data = vmem[idx]
      msgs.extend([
        req( 'rd', i, base_addr+4*idx, 4, 0 ), resp( 'rd', i, 2, 4, correct_data ),
      ])

    else:

      new_data = rgen.randint(0,0xffffffff)
      vmem[idx] = new_data
      msgs.extend([
        req( 'wr', i, base_addr+4*idx, 4, new_data ), resp( 'wr', i, 2, 4, 0 ),
      ])

  return msgs

#----------------------------------------------------------------------
# Test Case: stream
#----------------------------------------------------------------------

def stream_msgs( base_addr ):
  msgs = []
  for i in range(20):
    msgs.extend([
      req( 'wr', i, base_addr+4*i, 4, i ), resp( 'wr', i, 2, 4, 0 ),
      req( 'rd', i, base_addr+4*i, 4, 0 ), resp( 'rd', i, 2, 4, i ),
    ])

  return msgs

#-------------------------------------------------------------------------
# Test Case: write miss path
#-------------------------------------------------------------------------

def write_miss_1word_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'rd', 0x00, 0x00000000, 4, 0          ), resp('rd', 0x00, 0, 4, 0x0e5ca18d ), # read  word 0x00000000
    req( 'rd', 0x01, 0x00000000, 4, 0          ), resp('rd', 0x01, 1, 4, 0x0e5ca18d ), # read  word 0x00000000
    req( 'rd', 0x02, 0x00000004, 4, 0          ), resp('rd', 0x02, 1, 4, 0x00ba11ad ), # read  word 0x00000004
    req( 'wr', 0x03, 0x00000100, 4, 0x00e1de57 ), resp('wr', 0x03, 0, 4, 0          ), # write word 0x00000100
    req( 'rd', 0x04, 0x00000100, 4, 0          ), resp('rd', 0x04, 1, 4, 0x00e1de57 ), # read  word 0x00000100
  ]

# Data to be loaded into memory before running the test

def write_miss_1word_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0x0e5ca18d,
    0x00000004, 0x00ba11ad,
  ]

#-------------------------------------------------------------------------
# Test Case: force eviction
#-------------------------------------------------------------------------

def evict_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'wr', 0x00, 0x00000000, 4, 0x0a0b0c0d ), resp('wr', 0x00, 0, 4, 0          ), # write word  0x00000000
    req( 'wr', 0x01, 0x00000004, 4, 0x0e0f0102 ), resp('wr', 0x01, 1, 4, 0          ), # write word  0x00000004
    req( 'rd', 0x02, 0x00000000, 4, 0          ), resp('rd', 0x02, 1, 4, 0x0a0b0c0d ), # read  word  0x00000000
    req( 'rd', 0x03, 0x00000004, 4, 0          ), resp('rd', 0x03, 1, 4, 0x0e0f0102 ), # read  word  0x00000004

    # try forcing some conflict misses to force evictions

    req( 'wr', 0x04, 0x00004000, 4, 0xcafecafe ), resp('wr', 0x04, 0, 4, 0x0        ), # write word  0x00004000
    req( 'wr', 0x05, 0x00004004, 4, 0xebabefac ), resp('wr', 0x05, 1, 4, 0x0        ), # write word  0x00004004
    req( 'rd', 0x06, 0x00004000, 4, 0          ), resp('rd', 0x06, 1, 4, 0xcafecafe ), # read  word  0x00004000
    req( 'rd', 0x07, 0x00004004, 4, 0          ), resp('rd', 0x07, 1, 4, 0xebabefac ), # read  word  0x00004004

    req( 'wr', 0x00, 0x00008000, 4, 0xaaaeeaed ), resp('wr', 0x00, 0, 4, 0x0        ), # write word  0x00008000
    req( 'wr', 0x01, 0x00008004, 4, 0x0e0f0102 ), resp('wr', 0x01, 1, 4, 0x0        ), # write word  0x00008004
    req( 'rd', 0x03, 0x00008004, 4, 0          ), resp('rd', 0x03, 1, 4, 0x0e0f0102 ), # read  word  0x00008004
    req( 'rd', 0x02, 0x00008000, 4, 0          ), resp('rd', 0x02, 1, 4, 0xaaaeeaed ), # read  word  0x00008000

    req( 'wr', 0x04, 0x0000c000, 4, 0xcacafefe ), resp('wr', 0x04, 0, 4, 0x0        ), # write word  0x0000c000
    req( 'wr', 0x05, 0x0000c004, 4, 0xbeefbeef ), resp('wr', 0x05, 1, 4, 0x0        ), # write word  0x0000c004
    req( 'rd', 0x06, 0x0000c000, 4, 0          ), resp('rd', 0x06, 1, 4, 0xcacafefe ), # read  word  0x0000c000
    req( 'rd', 0x07, 0x0000c004, 4, 0          ), resp('rd', 0x07, 1, 4, 0xbeefbeef ), # read  word  0x0000c004

    req( 'wr', 0xf5, 0x0000c004, 4, 0xdeadbeef ), resp('wr', 0xf5, 1, 4, 0x0        ), # write word  0x0000c004
    req( 'wr', 0xd5, 0x0000d004, 4, 0xbeefbeef ), resp('wr', 0xd5, 0, 4, 0x0        ), # write word  0x0000d004
    req( 'wr', 0xe5, 0x0000e004, 4, 0xbeefbeef ), resp('wr', 0xe5, 0, 4, 0x0        ), # write word  0x0000e004
    req( 'wr', 0xc5, 0x0000f004, 4, 0xbeefbeef ), resp('wr', 0xc5, 0, 4, 0x0        ), # write word  0x0000f004

    # now refill those same cache lines to make sure we wrote to the
    # memory earlier and make sure we can read from memory

    req( 'rd', 0x06, 0x00004000, 4, 0          ), resp('rd', 0x06, 0, 4, 0xcafecafe ), # read  word  0x00004000
    req( 'rd', 0x07, 0x00004004, 4, 0          ), resp('rd', 0x07, 1, 4, 0xebabefac ), # read  word  0x00004004
    req( 'rd', 0x02, 0x00000000, 4, 0          ), resp('rd', 0x02, 0, 4, 0x0a0b0c0d ), # read  word  0x00000000
    req( 'rd', 0x03, 0x00000004, 4, 0          ), resp('rd', 0x03, 1, 4, 0x0e0f0102 ), # read  word  0x00000004
    req( 'rd', 0x03, 0x00008004, 4, 0          ), resp('rd', 0x03, 0, 4, 0x0e0f0102 ), # read  word  0x00008004
    req( 'rd', 0x02, 0x00008000, 4, 0          ), resp('rd', 0x02, 1, 4, 0xaaaeeaed ), # read  word  0x00008000
    req( 'rd', 0x06, 0x0000c000, 4, 0          ), resp('rd', 0x06, 0, 4, 0xcacafefe ), # read  word  0x0000c000
    req( 'rd', 0x07, 0x0000c004, 4, 0          ), resp('rd', 0x07, 1, 4, 0xdeadbeef ), # read  word  0x0000c004
    req( 'rd', 0x07, 0x0000d004, 4, 0          ), resp('rd', 0x07, 0, 4, 0xbeefbeef ), # read  word  0x0000d004
    req( 'rd', 0x08, 0x0000e004, 4, 0          ), resp('rd', 0x08, 0, 4, 0xbeefbeef ), # read  word  0x0000e004
    req( 'rd', 0x09, 0x0000f004, 4, 0          ), resp('rd', 0x09, 0, 4, 0xbeefbeef ), # read  word  0x0000f004
  ]

#-------------------------------------------------------------------------
# Test Case: test set associtivity
#-------------------------------------------------------------------------
# Test cases designed for two-way set-associative cache. We should set
# check_test to False if we use it to test set-associative cache.

def set_assoc_msg0( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    # Write to cacheline 0 way 0
    req( 'wr', 0x00, 0x00000000, 4, 0xffffff00), resp( 'wr', 0x00, 0, 4, 0          ),
    req( 'wr', 0x01, 0x00000004, 4, 0xffffff01), resp( 'wr', 0x01, 1, 4, 0          ),
    req( 'wr', 0x02, 0x00000008, 4, 0xffffff02), resp( 'wr', 0x02, 1, 4, 0          ),
    req( 'wr', 0x03, 0x0000000c, 4, 0xffffff03), resp( 'wr', 0x03, 1, 4, 0          ), # LRU:1
    # Write to cacheline 0 way 1
    req( 'wr', 0x04, 0x00001000, 4, 0xffffff04), resp( 'wr', 0x04, 0, 4, 0          ),
    req( 'wr', 0x05, 0x00001004, 4, 0xffffff05), resp( 'wr', 0x05, 1, 4, 0          ),
    req( 'wr', 0x06, 0x00001008, 4, 0xffffff06), resp( 'wr', 0x06, 1, 4, 0          ),
    req( 'wr', 0x07, 0x0000100c, 4, 0xffffff07), resp( 'wr', 0x07, 1, 4, 0          ), # LRU:0
    # Evict way 0
    req( 'rd', 0x08, 0x00002000, 4, 0         ), resp( 'rd', 0x08, 0, 4, 0x00facade ), # LRU:1
    # Read again from same cacheline to see if cache hit properly
    req( 'rd', 0x09, 0x00002004, 4, 0         ), resp( 'rd', 0x09, 1, 4, 0x05ca1ded ), # LRU:1
    # Read from cacheline 0 way 1 to see if cache hits properly,
    req( 'rd', 0x0a, 0x00001004, 4, 0         ), resp( 'rd', 0x0a, 1, 4, 0xffffff05 ), # LRU:0
    # Write to cacheline 0 way 1 to see if cache hits properly
    req( 'wr', 0x0b, 0x0000100c, 4, 0xffffff09), resp( 'wr', 0x0b, 1, 4, 0          ), # LRU:0
    # Read that back
    req( 'rd', 0x0c, 0x0000100c, 4, 0         ), resp( 'rd', 0x0c, 1, 4, 0xffffff09 ), # LRU:0
    # Evict way 0 again
    req( 'rd', 0x0d, 0x00000000, 4, 0         ), resp( 'rd', 0x0d, 0, 4, 0xffffff00 ), # LRU:1
    # Testing cacheline 7 now
    # Write to cacheline 7 way 0
    req( 'wr', 0x10, 0x00000070, 4, 0xffffff00), resp( 'wr', 0x10, 0, 4, 0          ),
    req( 'wr', 0x11, 0x00000074, 4, 0xffffff01), resp( 'wr', 0x11, 1, 4, 0          ),
    req( 'wr', 0x12, 0x00000078, 4, 0xffffff02), resp( 'wr', 0x12, 1, 4, 0          ),
    req( 'wr', 0x13, 0x0000007c, 4, 0xffffff03), resp( 'wr', 0x13, 1, 4, 0          ), # LRU:1
    # Write to cacheline 7 way 1
    req( 'wr', 0x14, 0x00001070, 4, 0xffffff04), resp( 'wr', 0x14, 0, 4, 0          ),
    req( 'wr', 0x15, 0x00001074, 4, 0xffffff05), resp( 'wr', 0x15, 1, 4, 0          ),
    req( 'wr', 0x16, 0x00001078, 4, 0xffffff06), resp( 'wr', 0x16, 1, 4, 0          ),
    req( 'wr', 0x17, 0x0000107c, 4, 0xffffff07), resp( 'wr', 0x17, 1, 4, 0          ), # LRU:0
    # Evict way 0
    req( 'rd', 0x18, 0x00002070, 4, 0         ), resp( 'rd', 0x18, 0, 4, 0x70facade ), # LRU:1
    # Read again from same cacheline to see if cache hits properly
    req( 'rd', 0x19, 0x00002074, 4, 0         ), resp( 'rd', 0x19, 1, 4, 0x75ca1ded ), # LRU:1
    # Read from cacheline 7 way 1 to see if cache hits properly
    req( 'rd', 0x1a, 0x00001074, 4, 0         ), resp( 'rd', 0x1a, 1, 4, 0xffffff05 ), # LRU:0
    # Write to cacheline 7 way 1 to see if cache hits properly
    req( 'wr', 0x1b, 0x0000107c, 4, 0xffffff09), resp( 'wr', 0x1b, 1, 4, 0          ), # LRU:0
    # Read that back
    req( 'rd', 0x1c, 0x0000107c, 4, 0         ), resp( 'rd', 0x1c, 1, 4, 0xffffff09 ), # LRU:0
    # Evict way 0 again
    req( 'rd', 0x1d, 0x00000070, 4, 0         ), resp( 'rd', 0x1d, 0, 4, 0xffffff00 ), # LRU:1
  ]

def set_assoc_mem0( base_addr ):
  return [
    # addr      # data (in int)
    0x00002000, 0x00facade,
    0x00002004, 0x05ca1ded,
    0x00002070, 0x70facade,
    0x00002074, 0x75ca1ded,
  ]

#-------------------------------------------------------------------------
# Test Case: test direct-mapped
#-------------------------------------------------------------------------
# Test cases designed for direct-mapped cache. We should set check_test
# to False if we use it to test set-associative cache.

def dir_mapped_long0_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    # Write to cacheline 0
    req( 'wr', 0x00, 0x00000000, 4, 0xffffff00), resp( 'wr', 0x00, 0, 4, 0          ),
    req( 'wr', 0x01, 0x00000004, 4, 0xffffff01), resp( 'wr', 0x01, 1, 4, 0          ),
    req( 'wr', 0x02, 0x00000008, 4, 0xffffff02), resp( 'wr', 0x02, 1, 4, 0          ),
    req( 'wr', 0x03, 0x0000000c, 4, 0xffffff03), resp( 'wr', 0x03, 1, 4, 0          ),
    # Write to cacheline 0
    req( 'wr', 0x04, 0x00001000, 4, 0xffffff04), resp( 'wr', 0x04, 0, 4, 0          ),
    req( 'wr', 0x05, 0x00001004, 4, 0xffffff05), resp( 'wr', 0x05, 1, 4, 0          ),
    req( 'wr', 0x06, 0x00001008, 4, 0xffffff06), resp( 'wr', 0x06, 1, 4, 0          ),
    req( 'wr', 0x07, 0x0000100c, 4, 0xffffff07), resp( 'wr', 0x07, 1, 4, 0          ),
    # Evict cache 0
    req( 'rd', 0x08, 0x00002000, 4, 0         ), resp( 'rd', 0x08, 0, 4, 0x00facade ),
    # Read again from same cacheline
    req( 'rd', 0x09, 0x00002004, 4, 0         ), resp( 'rd', 0x09, 1, 4, 0x05ca1ded ),
    # Read from cacheline 0
    req( 'rd', 0x0a, 0x00001004, 4, 0         ), resp( 'rd', 0x0a, 0, 4, 0xffffff05 ),
    # Write to cacheline 0
    req( 'wr', 0x0b, 0x0000100c, 4, 0xffffff09), resp( 'wr', 0x0b, 1, 4, 0          ),
    # Read that back
    req( 'rd', 0x0c, 0x0000100c, 4, 0         ), resp( 'rd', 0x0c, 1, 4, 0xffffff09 ),
    # Evict cache 0 again
    req( 'rd', 0x0d, 0x00000000, 4, 0         ), resp( 'rd', 0x0d, 0, 4, 0xffffff00 ),
    # Testing cacheline 7 now
    # Write to cacheline 7
    req( 'wr', 0x10, 0x00000070, 4, 0xffffff00), resp( 'wr', 0x10, 0, 4, 0          ),
    req( 'wr', 0x11, 0x00000074, 4, 0xffffff01), resp( 'wr', 0x11, 1, 4, 0          ),
    req( 'wr', 0x12, 0x00000078, 4, 0xffffff02), resp( 'wr', 0x12, 1, 4, 0          ),
    req( 'wr', 0x13, 0x0000007c, 4, 0xffffff03), resp( 'wr', 0x13, 1, 4, 0          ),
    # Write to cacheline 7
    req( 'wr', 0x14, 0x00001070, 4, 0xffffff04), resp( 'wr', 0x14, 0, 4, 0          ),
    req( 'wr', 0x15, 0x00001074, 4, 0xffffff05), resp( 'wr', 0x15, 1, 4, 0          ),
    req( 'wr', 0x16, 0x00001078, 4, 0xffffff06), resp( 'wr', 0x16, 1, 4, 0          ),
    req( 'wr', 0x17, 0x0000107c, 4, 0xffffff07), resp( 'wr', 0x17, 1, 4, 0          ),
    # Evict cacheline 7
    req( 'rd', 0x18, 0x00002070, 4, 0         ), resp( 'rd', 0x18, 0, 4, 0x70facade ),
    # Read again from same cacheline
    req( 'rd', 0x19, 0x00002074, 4, 0         ), resp( 'rd', 0x19, 1, 4, 0x75ca1ded ),
    # Read from cacheline 7
    req( 'rd', 0x1a, 0x00001074, 4, 0         ), resp( 'rd', 0x1a, 0, 4, 0xffffff05 ),
    # Write to cacheline 7 way 1 to see if cache hits properly
    req( 'wr', 0x1b, 0x0000107c, 4, 0xffffff09), resp( 'wr', 0x1b, 1, 4, 0          ),
    # Read that back
    req( 'rd', 0x1c, 0x0000107c, 4, 0         ), resp( 'rd', 0x1c, 1, 4, 0xffffff09 ),
    # Evict cacheline 0 again
    req( 'rd', 0x1d, 0x00000070, 4, 0         ), resp( 'rd', 0x1d, 0, 4, 0xffffff00 ),
  ]

def dir_mapped_long0_mem( base_addr ):
  return [
    # addr      # data (in int)
    0x00002000, 0x00facade,
    0x00002004, 0x05ca1ded,
    0x00002070, 0x70facade,
    0x00002074, 0x75ca1ded,
  ]

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table_generic = mk_test_case_table([
  (                         "msg_func               mem_data_func         stall lat src sink"),
  [ "read_hit_1word_clean",  read_hit_1word_clean,  None,                 0.0,  0,  0,  0    ],
  [ "read_miss_1word",       read_miss_1word_msg,   read_miss_1word_mem,  0.0,  0,  0,  0    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # LAB TASK: Add test cases to this table
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
  [ "read_hit_many_clean",   read_hit_many_clean,   None,                 0.0,  0,  0,  0    ],
  [ "read_capacity",         read_capacity,         read_capacity_mem,    0.0,  0,  0,  0    ],
  [ "read_hit_1word_dirty",  read_hit_1word_dirty,  None,                 0.0,  0,  0,  0    ],
#  [ "read_hit_1line_clean",  read_hit_1line_clean,  None,                 0.0,  0,  0,  0    ],
  [ "write_hit_1word_clean", write_hit_1word_clean, None,                 0.0,  0,  0,  0    ],
  [ "write_hit_1word_dirty", write_hit_1word_dirty, None,                 0.0,  0,  0,  0    ],
#  [ "amo_hit_1word_clean",   amo_hit_1word_clean,   None,                 0.0,  0,  0,  0    ],
#  [ "amo_miss_1word",        amo_miss_1word_msg,    amo_miss_1word_mem,   0.0,  0,  0,  0    ],
#  [ "amo_hit_more_clean",    amo_hit_more_clean,    None,                 0.0,  0,  0,  0    ],
#  [ "amo_miss_more",         amo_miss_more_msg,     amo_miss_more_mem,    0.0,  0,  0,  0    ],
  [ "random",                random_msgs,           None,                 0.0,  0,  0,  0    ],
  [ "random_stall0.5_lat0",  random_msgs,           None,                 0.5,  0,  0,  0    ],
  [ "random_stall0.0_lat4",  random_msgs,           None,                 0.0,  4,  0,  0    ],
  [ "random_stall0.5_lat4",  random_msgs,           None,                 0.5,  4,  0,  0    ],
  [ "stream",                stream_msgs,           None,                 0.0,  0,  0,  0    ],
  [ "stream_stall0.5_lat0",  stream_msgs,           None,                 0.5,  0,  0,  0    ],
  [ "stream_stall0.0_lat4",  stream_msgs,           None,                 0.0,  4,  0,  0    ],
  [ "stream_stall0.5_lat4",  stream_msgs,           None,                 0.5,  4,  0,  0    ],
  [ "write_miss_1word",      write_miss_1word_msg,  write_miss_1word_mem, 0.0,  0,  0,  0    ],
  [ "evict",                 evict_msg,             None,                 0.0,  0,  0,  0    ],
  [ "evict_stall0.5_lat0",   evict_msg,             None,                 0.5,  0,  0,  0    ],
  [ "evict_stall0.0_lat4",   evict_msg,             None,                 0.0,  4,  0,  0    ],
  [ "evict_stall0.5_lat4",   evict_msg,             None,                 0.5,  4,  0,  0    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

])

@pytest.mark.parametrize( **test_case_table_generic )
def test_generic( test_params, dump_vcd ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem = test_params.mem_data_func( 0 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         BlockingCacheWideAccessFL, False, dump_vcd )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )

#-------------------------------------------------------------------------
# Test table for set-associative cache (alternative design)
#-------------------------------------------------------------------------

test_case_table_set_assoc = mk_test_case_table([
  (                             "msg_func        mem_data_func    stall lat src sink"),
  [ "read_hit_asso",             read_hit_asso,  None,            0.0,  0,  0,  0    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # LAB TASK: Add test cases to this table
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  [ "set_assoc_test0",           set_assoc_msg0, set_assoc_mem0,  0.0,  0,  0,  0    ],
  [ "set_assoc_test0_lat4_3x14", set_assoc_msg0, set_assoc_mem0,  0.5,  4,  3,  14   ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

])

#@pytest.mark.parametrize( **test_case_table_set_assoc )
#def test_set_assoc( test_params, dump_vcd ):
#  msgs = test_params.msg_func( 0 )
#  if test_params.mem_data_func != None:
#    mem  = test_params.mem_data_func( 0 )
#  # Instantiate testharness
#  harness = TestHarness( msgs[::2], msgs[1::2],
#                         test_params.stall, test_params.lat,
#                         test_params.src, test_params.sink,
#                         BlockingCacheWideAccessFL, False, dump_vcd )
#  # Load memory before the test
#  if test_params.mem_data_func != None:
#    harness.load( mem[::2], mem[1::2] )
#  # Run the test
#  run_sim( harness, dump_vcd )
#
##-------------------------------------------------------------------------
## Test table for direct-mapped cache (baseline design)
##-------------------------------------------------------------------------
#
#test_case_table_dir_mapped = mk_test_case_table([
#  (                                  "msg_func              mem_data_func          stall lat src sink"),
#  [ "read_hit_dmap",                  read_hit_dmap,        None,                  0.0,  0,  0,  0    ],
#
#  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
#  # LAB TASK: Add test cases to this table
#  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
#
#  [ "dir_maped_test_long0",           dir_mapped_long0_msg, dir_mapped_long0_mem,  0.0,  0,  0,  0    ],
#  [ "dir_maped_test_long0_lat4_3x14", dir_mapped_long0_msg, dir_mapped_long0_mem,  0.5,  4,  3,  14   ],
#
#  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#
#])
#
#@pytest.mark.parametrize( **test_case_table_dir_mapped )
#def test_dir_mapped( test_params, dump_vcd ):
#  msgs = test_params.msg_func( 0 )
#  if test_params.mem_data_func != None:
#    mem  = test_params.mem_data_func( 0 )
#  # Instantiate testharness
#  harness = TestHarness( msgs[::2], msgs[1::2],
#                         test_params.stall, test_params.lat,
#                         test_params.src, test_params.sink,
#                         BlockingCacheWideAccessFL, False, dump_vcd )
#  # Load memory before the test
#  if test_params.mem_data_func != None:
#    harness.load( mem[::2], mem[1::2] )
#  # Run the test
#  run_sim( harness, dump_vcd )
#
