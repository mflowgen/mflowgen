#=========================================================================
# GcdXcelFL_test
#=========================================================================

import pytest
import random

from copy       import deepcopy
from fractions  import gcd

from pymtl       import *
from pclib.test  import mk_test_case_table, run_sim
from pclib.test  import TestSource, TestSink

from xcel.XcelMsg import XcelReqMsg, XcelRespMsg
from GcdXcelFL    import GcdXcelFL

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, xcel, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource ( XcelReqMsg(),  src_msgs,  src_delay  )
    s.xcel = xcel
    s.sink = TestSink   ( XcelRespMsg(), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.xcel.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.xcel = TranslationTool( s.xcel )

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

def req( opaque, type_, raddr, data, id ):
  msg = XcelReqMsg()

  msg.opaque = opaque

  if   type_ == 'rd': msg.type_ = XcelReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = XcelReqMsg.TYPE_WRITE

  msg.raddr = raddr
  msg.data  = data
  msg.id    = id
  return msg

def resp( opaque, type_, data, id ):
  msg = XcelRespMsg()

  msg.opaque = opaque

  if   type_ == 'rd': msg.type_ = XcelRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = XcelRespMsg.TYPE_WRITE

  msg.data  = data
  msg.id    = id
  return msg

#-------------------------------------------------------------------------
# Xcel Protocol
#-------------------------------------------------------------------------
# These are the source sink messages we need to configure the accelerator
# and wait for it to finish. We use the same messages in all of our
# tests. The difference between the tests is the data to be sorted in the
# test memory.

def gen_xcel_protocol_msgs( msg ):
  return [
    req( 124, 'wr', 1, msg[0], 0 ), resp( 124, 'wr', 0,      0 ),
    req(   0, 'wr', 2, msg[1], 0 ), resp(   0, 'wr', 0,      0 ),
    req(  24, 'rd', 0, 0     , 0 ), resp(  24, 'rd', msg[2], 0 ),
  ]

#-------------------------------------------------------------------------
# Test Messages: basic
#-------------------------------------------------------------------------

basic_msgs = [
              [15,  5,  5],
              [ 9,  3,  3],
              [ 0,  0,  0],
              [27, 15,  3],
              [21, 49,  7],
              [25, 30,  5],
              [19, 27,  1],
              [40, 40, 40],
             ]

#-------------------------------------------------------------------------
# Test Messages: random
#-------------------------------------------------------------------------

random.seed(0xdeadbeef)
random_msgs = []
for i in xrange(20):
  a = random.randint(0,0xffff)
  b = random.randint(0,0xffff)
  c = gcd( a, b )
  random_msgs.extend([[ a, b , c ]])

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
                         #             delays
                         #             --------
  (                      "msgs         src sink"),
  [ "basic0x0",           basic_msgs,  0,  0    ],
  [ "basic0x5",           basic_msgs,  0,  5    ],
  [ "basic3x0",           basic_msgs,  3,  0    ],
  [ "basic2x1",           basic_msgs,  2,  1    ],
  [ "random0x0",          random_msgs, 0,  0    ],
])

#-------------------------------------------------------------------------
# run_test
#-------------------------------------------------------------------------

def run_test( xcel, test_params, dump_vcd, test_verilog=False ):

  # Protocol messages

  xreqs  = list()
  xresps = list()
  for i in xrange( len(test_params.msgs) ):
    xcel_protocol_msgs = gen_xcel_protocol_msgs( test_params.msgs[i] )
    xreqs  += xcel_protocol_msgs[::2]
    xresps += xcel_protocol_msgs[1::2]

  # Create test harness with protocol messagse

  th = TestHarness( xcel, xreqs, xresps,
                    test_params.src, test_params.sink,
                    dump_vcd, test_verilog )

  # Run the test

  run_sim( th, dump_vcd, max_cycles=20000 )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  run_test( GcdXcelFL(), test_params, dump_vcd )

