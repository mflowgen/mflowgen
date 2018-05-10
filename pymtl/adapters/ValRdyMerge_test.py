#=========================================================================
# ValRdyMerge_test
#=========================================================================

import pytest
import random

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource, TestNetSink

from ValRdyMerge import ValRdyMerge

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, ValRdyMerge, p_nports, p_nbits,
                msgs, src_delays, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Sort Messages

    src_msgs = [ [] for _ in range( p_nports ) ]

    for msg in msgs:
      channel = clog2( msg[ p_nbits : p_nports+p_nbits ].uint() )
      src_msgs[ channel ].append( msg[ 0:p_nbits ] )

    # Instantiate models

    s.srcs = []

    for src in range( p_nports ):
      s.srcs.append( TestSource ( p_nbits, src_msgs[ src ], src_delays[ src%len(src_delays) ] ) )

    s.dut  = ValRdyMerge( p_nports, p_nbits         )
    s.sink = TestNetSink( p_nports+p_nbits, msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.dut = TranslationTool( s.dut, verilator_xinit=test_verilog )

    # Connect test sources and sinks

    for src in range( p_nports ):
      s.connect( s.srcs[ src ].out, s.dut.in_[ src ]  )

    s.connect( s.dut.out, s.sink.in_ )


  def done( s ):
    src_done = True

    for src in s.srcs:
      if not src.done:
        src_done = False

    return src_done and s.sink.done

  def line_trace( s ):

    src_line_trace = ""

    for src in s.srcs:
      src_line_trace += src.line_trace() + " "

    return src_line_trace + " > " + \
           s.dut.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# gen_msgs
#-------------------------------------------------------------------------

def gen_msgs( nports, nbits, src_data_pairs ):
  src  = 0
  data = 1

  msgs = [ nports, nbits, ]

  for pair in src_data_pairs:
    src_  = Bits( nports, pair[ src  ] )
    data_ = Bits( nbits,  pair[ data ] )
    msg = concat( src_, data_ )
    msgs.append( msg )

  return msgs

#-------------------------------------------------------------------------
# Test Case: basic
#-------------------------------------------------------------------------

basic_msgs = gen_msgs (
# nports nbits
  4,     16,   [
#   src  data
  ( 0x1, 0xdead ),
  ( 0x2, 0xcafe ),
  ( 0x4, 0xface ),
  ( 0x8, 0xbabe ),
  ( 0x1, 0xba5e ),
  ( 0x2, 0xfeed ),
  ( 0x4, 0xffff ),
  ( 0x8, 0x1111 ),
  ( 0x1, 0x0101 ),
])

#-------------------------------------------------------------------------
# Test Case: one_sender
#-------------------------------------------------------------------------

one_sender = gen_msgs (
# nports nbits
  2,     32,   [
#   src  data
  ( 0x1, 0x00000001 ),
  ( 0x1, 0x00000002 ),
  ( 0x1, 0x00000003 ),
  ( 0x1, 0x00000004 ),
  ( 0x1, 0x00000005 ),
  ( 0x1, 0x00000006 ),
  ( 0x1, 0x00000007 ),
  ( 0x1, 0x00000008 ),
  ( 0x1, 0x00000009 ),
])

#-------------------------------------------------------------------------
# Test Case: random
#-------------------------------------------------------------------------

random.seed()
rand_srcdata = []
rand_nports = random.randint( 2,10 )
for i in xrange( 20 ):
  src  = random.randint( 0,rand_nports-1 )
  data = random.randint( 0,0xFFFF )
  rand_srcdata.append( ( 1<<src, data ) )

random_msgs = gen_msgs( rand_nports, 16, rand_srcdata )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                   "msgs         src_delays sink_delay"),
  [ "basic"          , basic_msgs,  [0],       0          ],
  [ "one_sender"     , one_sender,  [0],       0          ],
  [ "basic_delays"   , basic_msgs,  [0,3],     1          ],
  [ "random"         , random_msgs, [0],       0          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  dut        = ValRdyMerge
  nports     = test_params.msgs[ 0  ]
  nbits      = test_params.msgs[ 1  ]
  msgs       = test_params.msgs[ 3: ]
  src_delays = test_params.src_delays
  sink_delay = test_params.sink_delay
  th = TestHarness( dut, nports, nbits, msgs,
                    src_delays, sink_delay,
                    dump_vcd, test_verilog )
  run_sim( th )

