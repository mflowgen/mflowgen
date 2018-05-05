#=========================================================================
# NullXcelRTL_test
#=========================================================================

import pytest
import random
import struct

random.seed(0xdeadbeef)

from pymtl            import *
from pclib.test       import mk_test_case_table, run_sim
from pclib.test       import TestSource, TestSink

from proc.XcelMsg     import XcelReqMsg, XcelRespMsg
from proc.NullXcelRTL import NullXcelRTL

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, src_msgs, sink_msgs, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource  ( XcelReqMsg(),  src_msgs,  src_delay  )
    s.xcel = NullXcelRTL ()
    s.sink = TestSink    ( XcelRespMsg(), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.xcel.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.xcel = TranslationTool( s.xcel, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src.out,       s.xcel.xcelreq )
    s.connect( s.xcel.xcelresp, s.sink.in_     )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.xcel.line_trace() + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, raddr, data ):
  msg = XcelReqMsg()

  if   type_ == 'rd': msg.type_ = XcelReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = XcelReqMsg.TYPE_WRITE

  msg.raddr = raddr
  msg.data  = data
  return msg

def resp( type_, data ):
  msg = XcelRespMsg()

  if   type_ == 'rd': msg.type_ = XcelRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = XcelRespMsg.TYPE_WRITE

  msg.data  = data
  return msg

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = [
  req( 'wr', 0, 0xa  ), resp( 'wr', 0x0 ),
  req( 'rd', 0, 0x0  ), resp( 'rd', 0xa ),
]

#-------------------------------------------------------------------------
# Test Case: stream
#-------------------------------------------------------------------------

stream_msgs = [
  req( 'wr', 0, 0xa  ), resp( 'wr', 0x0 ),
  req( 'wr', 0, 0xb  ), resp( 'wr', 0x0 ),
  req( 'rd', 0, 0x0  ), resp( 'rd', 0xb ),
  req( 'wr', 0, 0xc  ), resp( 'wr', 0x0 ),
  req( 'wr', 0, 0xd  ), resp( 'wr', 0x0 ),
  req( 'rd', 0, 0x0  ), resp( 'rd', 0xd ),
]

#-------------------------------------------------------------------------
# Test Case: random
#-------------------------------------------------------------------------

random.seed(0xdeadbeef)
random_msgs = []
for i in xrange(20):
  data = random.randint(0,0xffffffff)
  random_msgs.extend([ req( 'wr', 0, data ), resp( 'wr', 0,   ) ])
  random_msgs.extend([ req( 'rd', 0, 0    ), resp( 'rd', data ) ])

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (              "msgs         src sink"),
  [ "basic_0x0",  basic_msgs,  0,  0,   ],
  [ "stream_0x0", stream_msgs, 0,  0,   ],
  [ "random_0x0", random_msgs, 0,  0,   ],
  [ "random_5x0", random_msgs, 5,  0,   ],
  [ "random_0x5", random_msgs, 0,  5,   ],
  [ "random_3x9", random_msgs, 3,  9,   ],
])

#-------------------------------------------------------------------------
# run_test
#-------------------------------------------------------------------------

def run_test( test_params, dump_vcd, test_verilog ):

  th = TestHarness( test_params.msgs[::2], test_params.msgs[1::2],
                    test_params.src, test_params.sink,
                    dump_vcd, test_verilog )

  run_sim( th, dump_vcd, max_cycles=20000 )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_test( test_params, dump_vcd, test_verilog )

