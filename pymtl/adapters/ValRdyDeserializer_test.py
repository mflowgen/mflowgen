#=========================================================================
# ValRdySerializer_test
#=========================================================================

import pytest
import random

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource, TestSink

from ValRdyDeserializer import ValRdyDeserializer

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, ValRdyDeserializer, dtype_in, dtype_out,
                src_msgs, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Generate Sink Messages

    p_nmsgs = dtype_out / dtype_in
    if( dtype_out > p_nmsgs * dtype_in ):
      p_nmsgs += 1

    p_regwidth = p_nmsgs * dtype_in

    sink_msgs = []

    idx = 0
    while ( idx < len( src_msgs ) ):
      sink_msg = src_msgs[ idx ]
      for offset in range( p_nmsgs-1 ):
        sink_msg = concat( src_msgs[ idx + offset + 1], sink_msg )
      sink_msgs.append( sink_msg[ 0:dtype_out ] )
      idx += p_nmsgs


    # Instantiate models

    s.src  = TestSource      ( dtype_in, src_msgs, src_delay    )
    s.dut  = ValRdyDeserializer( dtype_in, dtype_out              )
    s.sink = TestSink        ( dtype_out, sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.dut = TranslationTool( s.dut )

    # Connect test sources and sinks

    s.connect( s.src.out, s.dut.in_  )
    s.connect( s.dut.out, s.sink.in_ )


  def done( s ):

    return s.src.done and s.sink.done

  def line_trace( s ):

    return s.src.line_trace() + " > " + \
           s.dut.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = [
  Bits( 8, 0xef ),
  Bits( 8, 0xbe ),
  Bits( 8, 0xad ),
  Bits( 8, 0xde ),
  Bits( 8, 0xbe ),
  Bits( 8, 0xba ),
  Bits( 8, 0xfe ),
  Bits( 8, 0xca ),
]

long_msgs = [
  Bits( 32, 0xdeadbeef ),
  Bits( 32, 0xcafebabe ),
  Bits( 32, 0xba5eba11 ),
  Bits( 32, 0xbaddf00d ),
  Bits( 32, 0xdad12549 ),
  Bits( 32, 0xbeac4e55 ),
  Bits( 32, 0xfaceface ),
  Bits( 32, 0xfa11ba11 ),
]


#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (            "dtype_in  dtype_out msgs        src_delay sink_delay"),
  [ "8-to-16" , 8,        16,       basic_msgs, 0,        0          ],
  [ "8-to-30" , 8,        15,       basic_msgs, 0,        0          ],
  [ "8-to-32" , 8,        32,       basic_msgs, 0,        0          ],
  [ "32-to-8" , 32,       8,        long_msgs,  0,        0          ],
  [ "32-to-8" , 32,       16,       long_msgs,  0,        0          ],
  [ "32-to-8" , 32,       30,       long_msgs,  0,        0          ],
  [ "32-to-8" , 32,       32,       long_msgs,  0,        0          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  th = TestHarness( ValRdyDeserializer, test_params.dtype_in, test_params.dtype_out,
                    test_params.msgs, test_params.src_delay, test_params.sink_delay,
                    dump_vcd, test_verilog )
  run_sim( th )
