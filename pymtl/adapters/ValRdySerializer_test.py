#=========================================================================
# ValRdySerializer_test
#=========================================================================

import pytest
import random

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource, TestSink

from ValRdySerializer import ValRdySerializer

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, ValRdySerializer, dtype_in, dtype_out,
                src_msgs, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Generate Sink Messages

    p_nmsgs = dtype_in / dtype_out
    if( dtype_in > p_nmsgs * dtype_out ):
      p_nmsgs += 1

    p_regwidth = p_nmsgs * dtype_out

    sink_msgs = []

    for src_msg in src_msgs:
      if p_regwidth > dtype_in : msg = concat( Bits( p_regwidth - dtype_in, 0 ), src_msg )
      else                     : msg = src_msg
      for _ in range( p_nmsgs ):
        sink_msgs.append( msg[ _*dtype_out:(_+1)*dtype_out ] )

    # Instantiate models

    s.src  = TestSource      ( dtype_in, src_msgs, src_delay    )
    s.dut  = ValRdySerializer( dtype_in, dtype_out              )
    s.sink = TestSink        ( dtype_out, sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.dut = TranslationTool( s.dut, verilator_xinit=test_verilog )

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
  (                 "dtype_in  dtype_out msgs             src_delay sink_delay"),
  [ "32-to-1" ,      32,       1,        basic_msgs[0:1], 0,        0          ],
  [ "32-to-8" ,      32,       8,        basic_msgs,      0,        0          ],
  [ "32-to-10",      32,       10,       basic_msgs,      0,        0          ],
  [ "32-to-60",      32,       60,       basic_msgs,      0,        0          ],
  [ "32-to-64",      32,       64,       basic_msgs,      0,        0          ],
  [ "32-to-1x",      32,       1,        basic_msgs[0:1], 1,        0          ],
  [ "32-to-8x" ,     32,       8,        basic_msgs,      1,        0          ],
  [ "32-to-10x",     32,       10,       basic_msgs,      0,        2          ],
  [ "32-to-60x",     32,       60,       basic_msgs,      1,        0          ],
  [ "32-to-64x",     32,       64,       basic_msgs,      0,        4          ],
  [ "32-to-1_3x14",  32,       1,        basic_msgs[0:1], 3,        14         ],
  [ "32-to-8_3x14" , 32,       8,        basic_msgs,      3,        14         ],
  [ "32-to-10_3x14", 32,       10,       basic_msgs,      3,        14         ],
  [ "32-to-60_3x14", 32,       60,       basic_msgs,      3,        14         ],
  [ "32-to-64_3x14", 32,       64,       basic_msgs,      3,        14         ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  th = TestHarness( ValRdySerializer, test_params.dtype_in, test_params.dtype_out,
                    test_params.msgs, test_params.src_delay, test_params.sink_delay,
                    dump_vcd, test_verilog )
  run_sim( th )
