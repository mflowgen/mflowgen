#=========================================================================
# GcdUnitFL_test
#=========================================================================

import pytest
import random

from copy       import deepcopy
from fractions  import gcd

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource, TestSink

from GcdUnitFL  import GcdUnitFL
from GcdUnitMsg import GcdUnitReqMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, GcdUnit, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource ( GcdUnitReqMsg(), src_msgs,  src_delay  )
    s.gcd  = GcdUnit
    s.sink = TestSink   ( Bits(16),        sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.gcd.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      cls_name = s.gcd.__class__.__name__
      if ( cls_name != 'SwShim' ) and ( not hasattr( s.gcd, 'dut' ) ):
        s.gcd = TranslationTool( s.gcd, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src.out,  s.gcd.req  )
    s.connect( s.gcd.resp, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.gcd.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# mk_req_msg
#-------------------------------------------------------------------------

def mk_req_msg( a, b ):
  msg = GcdUnitReqMsg()
  msg.a = a
  msg.b = b
  return msg

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = [
  mk_req_msg( 15,     5      ), 5,
  mk_req_msg( 3,      9      ), 3,
  mk_req_msg( 0,      0      ), 0,
  mk_req_msg( 27,     15     ), 3,
  mk_req_msg( 21,     49     ), 7,
  mk_req_msg( 25,     30     ), 5,
  mk_req_msg( 19,     27     ), 1,
  mk_req_msg( 40,     40     ), 40,
  mk_req_msg( 250,    190    ), 10,
  mk_req_msg( 5,      250    ), 5,
  mk_req_msg( 0xffff, 0x00ff ), 0xff,
]

#-------------------------------------------------------------------------
# Test Case: random
#-------------------------------------------------------------------------

random.seed(0xdeadbeef)
random_msgs = []
for i in xrange(20):
  a = random.randint(0,0xffff)
  b = random.randint(0,0xffff)
  c = gcd( a, b )
  random_msgs.extend([ mk_req_msg( a, b ), c ])

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (               "msgs       src_delay sink_delay"),
  [ "basic_0x0",  basic_msgs, 0,        0          ],
  [ "basic_5x0",  basic_msgs, 5,        0          ],
  [ "basic_0x5",  basic_msgs, 0,        5          ],
  [ "basic_3x9",  basic_msgs, 3,        9          ],
  [ "random_3x9", basic_msgs, 3,        9          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  run_sim( TestHarness( GcdUnitFL(),
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay ),
           dump_vcd )

