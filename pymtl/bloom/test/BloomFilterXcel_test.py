#=========================================================================
# BloomFilterXcel_test
#=========================================================================

import pytest
import random
import struct

random.seed(0xdeadbeef)

from pymtl            import *
from pclib.test       import mk_test_case_table, run_sim
from pclib.test       import TestSource, TestSink
from pclib.test.TestSynchronizer import TestSynchronizer, TestSynchInfo

from proc.XcelMsg     import XcelReqMsg, XcelRespMsg
from ifcs.MemMsg import MemReqMsg4B
from bloom.BloomFilterXcel import BloomFilterXcel

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

#-------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------

SnoopMemMsg = MemReqMsg4B
# Initialize xcel just so that we can get the constants.
x = BloomFilterXcel()

CSR_BEGIN     = 0
CSR_STATUS    = CSR_BEGIN + x.CSR_OFFSET_STATUS
CSR_CHECK_VAL = CSR_BEGIN + x.CSR_OFFSET_CHECK_VAL
CSR_CHECK_RES = CSR_BEGIN + x.CSR_OFFSET_CHECK_RES
CSR_CLEAR     = CSR_BEGIN + x.CSR_OFFSET_CLEAR


#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, xcel_src_msgs, snoop_src_msgs, xcel_sink_msgs,
                xcel_src_delay, snoop_src_delay, xcel_sink_delay,
                synch_info,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.xcel_src  = TestSource( XcelReqMsg(),  xcel_src_msgs,  xcel_src_delay )
    s.xcel_src_synch = TestSynchronizer( XcelReqMsg(), 0, synch_info )
    s.snoop_src = TestSource( SnoopMemMsg(), snoop_src_msgs, snoop_src_delay )
    s.snoop_synch = TestSynchronizer( SnoopMemMsg(), 1, synch_info )
    s.xcel = BloomFilterXcel( snoop_mem_msg=SnoopMemMsg(), csr_begin=CSR_BEGIN )
    s.xcel_sink_synch = TestSynchronizer( XcelRespMsg(), 2, synch_info )
    s.xcel_sink = TestSink( XcelRespMsg(), xcel_sink_msgs, xcel_sink_delay )

    # Dump VCD

    if dump_vcd:
      s.xcel.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.xcel = TranslationTool( s.xcel )

    # Connect

    s.connect( s.xcel_src.out,    s.xcel_src_synch.in_ )
    s.connect( s.xcel_src_synch.out,  s.xcel.xcelreq   )
    s.connect( s.snoop_src.out,   s.snoop_synch.in_   )
    s.connect( s.snoop_synch.out, s.xcel.memreq_snoop )
    s.connect( s.xcel.xcelresp,    s.xcel_sink_synch.in_ )
    s.connect( s.xcel_sink_synch.out,  s.xcel_sink.in_   )

  def done( s ):
    return s.xcel_src.done and s.snoop_src.done and s.xcel_sink.done

  def line_trace( s ):
    return s.xcel_src.line_trace()  + " | " + \
           s.snoop_src.line_trace() + " > " + \
           s.xcel.line_trace() + " > " + \
           s.xcel_sink.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def xcel_req( type_, raddr, data ):
  msg = XcelReqMsg()

  if   type_ == 'r': msg.type_ = XcelReqMsg.TYPE_READ
  elif type_ == 'w': msg.type_ = XcelReqMsg.TYPE_WRITE

  msg.raddr = raddr
  msg.data  = data
  return msg

def xcel_resp( type_, data ):
  msg = XcelRespMsg()

  if   type_ == 'r': msg.type_ = XcelRespMsg.TYPE_READ
  elif type_ == 'w': msg.type_ = XcelRespMsg.TYPE_WRITE

  msg.data  = data
  return msg

def snoop_req( type_, addr ):
  msg = SnoopMemMsg()

  if   type_ == 'r': msg.type_ = SnoopMemMsg.TYPE_READ
  elif type_ == 'w': msg.type_ = SnoopMemMsg.TYPE_WRITE

  msg.addr  = addr
  return msg

class Synch:
  pass

def synch():
  return Synch()

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = [
  xcel_req( 'w', CSR_CLEAR,  x.CLEAR_REQUESTED  ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_STATUS, x.STATUS_ENABLED_R ), xcel_resp( 'w', 0 ),
  synch(),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'r', 0xcafe1111 ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  # XXX: a bit hacky, but the check_val can take some time to resolve. So
  # to pass time, read the status a couple of times.
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafef00d ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1111 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_R ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
]

#-------------------------------------------------------------------------
# Test Case: stream
#-------------------------------------------------------------------------

stream_msgs = [
  xcel_req( 'w', CSR_CLEAR,  x.CLEAR_REQUESTED   ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_STATUS, x.STATUS_ENABLED_RW ), xcel_resp( 'w', 0 ),
  synch(),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'r', 0xcafe1111 ),
  snoop_req( 'r', 0x1201abba ),
  snoop_req( 'w', 0xcafaf00d ),
  snoop_req( 'r', 0xc0fe1111 ),
  snoop_req( 'r', 0x100122ba ),
  snoop_req( 'w', 0xcafef222 ),
  snoop_req( 'r', 0xcafe1222 ),
  snoop_req( 'r', 0x1001a222 ),
  snoop_req( 'w', 0xcafe300d ),
  snoop_req( 'r', 0xca222111 ),
  snoop_req( 'r', 0x1101abba ),
  snoop_req( 'w', 0xc2fef00d ),
  snoop_req( 'r', 0xc22e1111 ),
  snoop_req( 'r', 0x1022abba ),
  snoop_req( 'w', 0xcaf2200d ),
  snoop_req( 'r', 0xcafe2211 ),
  snoop_req( 'r', 0x1001247a ),
  snoop_req( 'w', 0xcafef08d ),
  snoop_req( 'r', 0xcafe1181 ),
  snoop_req( 'r', 0x1001ab09 ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafa1111 ),
  snoop_req( 'r', 0x1aa1abba ),
  snoop_req( 'w', 0xcaaea00d ),
  snoop_req( 'r', 0xcafeaa11 ),
  snoop_req( 'r', 0x1001aaaa ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafe1171 ),
  snoop_req( 'r', 0x1001a8ba ),
  snoop_req( 'w', 0xcafef60d ),
  snoop_req( 'r', 0xca234221 ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafefeed ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1111 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafef09d ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1181 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe0000 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafa1111 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  # Clear and disable.
  xcel_req( 'w', CSR_CLEAR,  x.CLEAR_REQUESTED   ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_STATUS, x.STATUS_DISABLED   ), xcel_resp( 'w', 0 ),
  synch(),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'r', 0xcafe1111 ),
  snoop_req( 'r', 0x1201abba ),
  snoop_req( 'w', 0xcafaf00d ),
  snoop_req( 'r', 0xc0fe1111 ),
  snoop_req( 'r', 0x100122ba ),
  snoop_req( 'w', 0xcafef222 ),
  snoop_req( 'r', 0xcafe1222 ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafefeed ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1111 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_DISABLED ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  # Enable for writes.
  xcel_req( 'w', CSR_STATUS, x.STATUS_ENABLED_W  ), xcel_resp( 'w', 0 ),
  synch(),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'w', 0xcafe1111 ),
  snoop_req( 'r', 0x1201abba ),
  snoop_req( 'w', 0xcafaf00d ),
  snoop_req( 'r', 0xc0fe1111 ),
  snoop_req( 'r', 0x100122ba ),
  snoop_req( 'w', 0xcafef222 ),
  snoop_req( 'r', 0xcafe1222 ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_NO ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafef222 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  synch(),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1111 ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_W ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
]

#-------------------------------------------------------------------------
# Test Case: exception
#-------------------------------------------------------------------------

exception_msgs = [
  xcel_req( 'w', CSR_CLEAR,  x.CLEAR_REQUESTED   ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_STATUS, x.STATUS_ENABLED_RW ), xcel_resp( 'w', 0 ),
  synch(),
  # Send bunch of requests from the memory port and check vals which might
  # cause an exception when memory requests could not be accepted.
  xcel_req( 'w', CSR_CHECK_VAL, 0xf00df00d ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafe1000 ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001a222 ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_CHECK_VAL, 0xcafef09d ), xcel_resp( 'w', 0 ),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'r', 0xcafe1111 ),
  snoop_req( 'r', 0x1201abba ),
  snoop_req( 'w', 0xcafaf00d ),
  snoop_req( 'r', 0xc0fe1111 ),
  snoop_req( 'r', 0x100122ba ),
  snoop_req( 'w', 0xcafef222 ),
  snoop_req( 'r', 0xcafe1222 ),
  snoop_req( 'r', 0x1001a222 ),
  snoop_req( 'w', 0xcafe300d ),
  snoop_req( 'r', 0xca222111 ),
  snoop_req( 'r', 0x1101abba ),
  snoop_req( 'w', 0xc2fef00d ),
  snoop_req( 'r', 0xc22e1111 ),
  snoop_req( 'r', 0x1022abba ),
  snoop_req( 'w', 0xcaf2200d ),
  snoop_req( 'r', 0xcafe2211 ),
  snoop_req( 'r', 0x1001247a ),
  snoop_req( 'w', 0xcafef08d ),
  snoop_req( 'r', 0xcafe1181 ),
  snoop_req( 'r', 0x1001ab09 ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafa1111 ),
  snoop_req( 'r', 0x1aa1abba ),
  snoop_req( 'w', 0xcaaea00d ),
  snoop_req( 'r', 0xcafeaa11 ),
  snoop_req( 'r', 0x1001aaaa ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafe1171 ),
  snoop_req( 'r', 0x1001a8ba ),
  snoop_req( 'w', 0xcafef60d ),
  snoop_req( 'r', 0xca234221 ),
  synch(),
  # Exception expected.
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_EXCEPTION ),
  # Clear the exception.
  xcel_req( 'w', CSR_CLEAR,  x.CLEAR_REQUESTED   ), xcel_resp( 'w', 0 ),
  xcel_req( 'w', CSR_STATUS, x.STATUS_ENABLED_RW ), xcel_resp( 'w', 0 ),
  synch(),
  snoop_req( 'r', 0x1001abba ),
  snoop_req( 'w', 0xcafef00d ),
  snoop_req( 'r', 0xcafe1111 ),
  snoop_req( 'r', 0x1201abba ),
  snoop_req( 'w', 0xcafaf00d ),
  synch(),
  # One concurrent check val shouldn't cause an exception.
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'w', CSR_CHECK_VAL, 0x1001abba ), xcel_resp( 'w', 0 ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_STATUS, 0 ),             xcel_resp( 'r', x.STATUS_ENABLED_RW ),
  xcel_req( 'r', CSR_CHECK_RES, 0 ),          xcel_resp( 'r', x.CHECK_RESULT_YES ),
  snoop_req( 'r', 0xc0fe1111 ),
  snoop_req( 'r', 0x100122ba ),
  snoop_req( 'w', 0xcafef222 ),
  snoop_req( 'r', 0xcafe1222 ),
  snoop_req( 'r', 0x1001a222 ),
  snoop_req( 'w', 0xcafe300d ),
  snoop_req( 'r', 0xca222111 ),
  snoop_req( 'r', 0x1101abba ),
  snoop_req( 'w', 0xc2fef00d ),
  snoop_req( 'r', 0xc22e1111 ),
  snoop_req( 'r', 0x1022abba ),
  snoop_req( 'w', 0xcaf2200d ),
  snoop_req( 'r', 0xcafe2211 ),
  snoop_req( 'r', 0x1001247a ),
  snoop_req( 'w', 0xcafef08d ),
  snoop_req( 'r', 0xcafe1181 ),
  snoop_req( 'r', 0x1001ab09 ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafa1111 ),
  snoop_req( 'r', 0x1aa1abba ),
  snoop_req( 'w', 0xcaaea00d ),
  snoop_req( 'r', 0xcafeaa11 ),
  snoop_req( 'r', 0x1001aaaa ),
  snoop_req( 'w', 0xcafef09d ),
  snoop_req( 'r', 0xcafe1171 ),
  snoop_req( 'r', 0x1001a8ba ),
  snoop_req( 'w', 0xcafef60d ),
  snoop_req( 'r', 0xca234221 ),
]

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                "msgs        xcel_src_delay snoop_src_delay xcel_sink_delay"),
  [ "basic_0x0x0",  basic_msgs, 0,             0,              0   ],
  [ "basic_3x0x0",  basic_msgs, 3,             0,              0   ],
  [ "basic_0x3x0",  basic_msgs, 0,             3,              0   ],
  [ "basic_0x0x3",  basic_msgs, 0,             0,              3   ],
  [ "basic_3x3x3",  basic_msgs, 3,             3,              3   ],
  [ "stream_0x0x0", stream_msgs,0,             0,              0   ],
  [ "stream_3x3x3", stream_msgs,3,             3,              3   ],
  [ "exception_0x0x0", exception_msgs,0,       0,              0   ],
])

#-------------------------------------------------------------------------
# run_test
#-------------------------------------------------------------------------

def run_test( test_params, dump_vcd, test_verilog ):

  # Given messages jumbled up together, create a list of xcel src/sink
  # messages and snoop src messages. Also create the synch table.

  synch_table    = [ [ [0,0], [0,0], [0,0] ] ]
  xcel_src_msgs  = []
  xcel_sink_msgs = []
  snoop_src_msgs = []

  for msg in test_params.msgs:
    if isinstance( msg, Synch ):
      synch_table.append( [ [0,0], [0,0], [0,0] ] )
    elif msg.nbits == XcelReqMsg().nbits:
      xcel_src_msgs.append( msg )
      synch_table[-1][0][0] += 1
    elif msg.nbits == XcelRespMsg().nbits:
      xcel_sink_msgs.append( msg )
      synch_table[-1][2][0] += 1
    elif msg.nbits == SnoopMemMsg().nbits:
      snoop_src_msgs.append( msg )
      synch_table[-1][1][0] += 1
    else:
      assert False

  synch_info = TestSynchInfo( synch_table )

  th = TestHarness( xcel_src_msgs,  snoop_src_msgs,  xcel_sink_msgs,
                    test_params.xcel_src_delay,
                    test_params.snoop_src_delay,
                    test_params.xcel_sink_delay,
                    synch_info,
                    dump_vcd, test_verilog )

  run_sim( th, dump_vcd, max_cycles=20000 )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_test( test_params, dump_vcd, test_verilog )

