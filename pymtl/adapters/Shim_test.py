#=========================================================================
# ValRdyToReqAck_test
#=========================================================================

import pytest
import random

from pymtl          import *
from pclib.test     import mk_test_case_table, run_sim
from pclib.test     import TestSource, TestSink

from ValRdyMerge        import ValRdyMerge
from ValRdySerializer   import ValRdySerializer
from ValRdyToReqAck     import ValRdyToReqAck
from ReqAckToValRdy     import ReqAckToValRdy
from ValRdyDeserializer import ValRdyDeserializer
from ValRdySplit        import ValRdySplit

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, dtype, msgs0, msgs1, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    dwidth = dtype + 2

    s.src0  = TestSource         ( dtype,    msgs0    )
    s.src1  = TestSource         ( dtype,    msgs1    )
    s.merge = ValRdyMerge        ( 2,        dtype    )
    s.ser   = ValRdySerializer   ( dwidth,   dwidth/4 )
    s.vr2ra = ValRdyToReqAck     ( dwidth/4           )
    s.ra2vr = ReqAckToValRdy     ( dwidth/4           )
    s.des   = ValRdyDeserializer ( dwidth/4, dwidth   )
    s.split = ValRdySplit        ( 2,        dtype    )
    s.sink0 = TestSink           ( dtype,    msgs0    )
    s.sink1 = TestSink           ( dtype,    msgs1    )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.dut = TranslationTool( s.dut )

    # Connect test sources and sinks

    s.connect( s.src0.out,     s.merge.in_[0] )
    s.connect( s.src1.out,     s.merge.in_[1] )
    s.connect( s.merge.out,    s.ser.in_      )
    s.connect( s.ser.out,      s.vr2ra.in_    )
    s.connect( s.vr2ra.out,    s.ra2vr.in_    )
    s.connect( s.ra2vr.out,    s.des.in_      )
    s.connect( s.des.out,      s.split.in_    )
    s.connect( s.split.out[0], s.sink0.in_    )
    s.connect( s.split.out[1], s.sink1.in_    )


  def done( s ):

    return s.src0.done and s.src1.done and s.sink0.done and s.sink1.done

  def line_trace( s ):

    return s.src0.line_trace()  + " | " + \
           s.src1.line_trace()  + " > " + \
           s.merge.line_trace() + " > " + \
           s.ser.line_trace()   + " > " + \
           s.vr2ra.line_trace() + " " + \
           s.vr2ra.out.to_str() + " " + \
           s.ra2vr.line_trace() + " > " + \
           s.des.line_trace()   + " > " + \
           s.split.line_trace() + " > " + \
           s.sink0.line_trace() + " | " + \
           s.sink1.line_trace()

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs0 = [
  Bits( 32, 0x12345678 ),
  Bits( 32, 0xdeadbeef ),
  Bits( 32, 0xcafebabe ),
  Bits( 32, 0x1eaf1e55 ),
]

basic_msgs1 = [
  Bits( 32, 0xba5eba11 ),
  Bits( 32, 0x000ff1ce ),
  Bits( 32, 0xbaadf00d ),
  Bits( 32, 0xcafed00d ),
]

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (            "dtype msgs0        msgs1        src_delay sink_delay"),
  [ "basic" ,   32,   basic_msgs0, basic_msgs1, 1,        0          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  th = TestHarness( test_params.dtype, test_params.msgs0, test_params.msgs1,
                    test_params.src_delay, test_params.sink_delay,
                    False )
  run_sim( th )
