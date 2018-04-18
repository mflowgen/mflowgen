#=========================================================================
# ValRdyToReqAck_test
#=========================================================================

import pytest
import random

from pymtl          import *
from pclib.test     import mk_test_case_table, run_sim
from pclib.test     import TestSource, TestSink

from ValRdyToReqAck import ValRdyToReqAck
from ReqAckToValRdy import ReqAckToValRdy

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, dtype, msgs, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src   = TestSource    ( dtype, msgs )
    s.dut1  = ValRdyToReqAck( dtype       )
    s.dut2  = ReqAckToValRdy( dtype       )
    s.sink  = TestSink      ( dtype, msgs )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.dut = TranslationTool( s.dut )

    # Connect test sources and sinks

    s.connect( s.src.out,  s.dut1.in_ )
    s.connect( s.dut1.out, s.dut2.in_ )
    s.connect( s.dut2.out, s.sink.in_ )


  def done( s ):

    return s.src.done and s.sink.done

  def line_trace( s ):

    return s.src.line_trace()  + " > " + \
           s.dut1.line_trace() + " > " + \
           s.dut1.out.to_str() + " > " + \
           s.dut2.line_trace() + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = [
  Bits( 32, 0x12345678 ),
  Bits( 32, 0xdeadbeef ),
  Bits( 32, 0xcafebabe ),
  Bits( 32, 0x1eaf1e55 ),
  Bits( 32, 0xba5eba11 ),
  Bits( 32, 0x000ff1ce ),
  Bits( 32, 0xbaadf00d ),
  Bits( 32, 0xcafed00d ),
]

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (            "dtype msgs        src_delay sink_delay"),
  [ "basic" ,   32,   basic_msgs, 1,        0          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  th = TestHarness( test_params.dtype, test_params.msgs,
                    test_params.src_delay, test_params.sink_delay,
                    False )
  run_sim( th )
