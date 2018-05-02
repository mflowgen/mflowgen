#=========================================================================
# BloomFilter_test.py
#=========================================================================

import pytest

from pymtl import *
from pclib.test import mk_test_case_table, run_sim, TestSource, TestSink
from bloom.BloomFilter import BloomFilterMsg, BloomFilterParallel

class TestHarness( Model ):

  def __init__( s, num_bits_exponent, num_hash_funs, nbits,
                src_msgs, sink_msgs, src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    msg_type = BloomFilterMsg( nbits )
    s.src   = TestSource( msg_type, src_msgs, src_delay )
    s.bloom = BloomFilterParallel( num_bits_exponent, num_hash_funs, msg_type )
    s.sink  = TestSink( 1, sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.bloom.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.bloom = TranslationTool( s.bloom )

    # Connect

    s.connect( s.src.out, s.bloom.in_ )
    s.connect( s.bloom.check_out, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done


  def line_trace( s ):
    return s.src.line_trace() + " > " + \
           s.bloom.line_trace() + " > " + \
           s.sink.line_trace()

req_type = BloomFilterMsg( 32 )

def clear():
  return req_type.mk_msg( BloomFilterMsg.TYPE_CLEAR, 0 )

def insert( word ):
  return req_type.mk_msg( BloomFilterMsg.TYPE_INSERT, word )

def check( word ):
  return req_type.mk_msg( BloomFilterMsg.TYPE_CHECK, word )

direct_in_msgs = [ clear(),
                   insert( 0x00000f00 ),
                   insert( 0xcafebeef ),
                   insert( 0xcafebeef ),
                   insert( 0xbeefbabe ),
                   insert( 0x12340123 ),
                   insert( 0xf00d1234 ),
                   insert( 0x40012034 ),
                   check(  0x12340123 ), # 1
                   check(  0x23523523 ), # 0
                   check(  0xbeefbabe ), # 1
                   check(  0xbfffbabe ), # 0
                   check(  0x01234567 ), # 0
                   check(  0xf00d1234 ), # 1
                   insert( 0xbfffbabe ),
                   check(  0xbfffbabe ), # 1
                   check(  0x01234567 ), # 0
                   clear(),
                   check(  0x12340123 ), # 0
                   check(  0x23523523 ), # 0
                   check(  0xbeefbabe ), # 0
                   check(  0xbfffbabe ), # 0
                   check(  0x01234567 ), # 0
                   check(  0xf00d1234 ), # 0
                   insert( 0xbfffbabe ),
                   check(  0xbfffbabe ), # 1
                   check(  0x01234567 ), # 0
                  ]

direct_out_msgs = [ Bits( 1, 1 ),
                    Bits( 1, 0 ),
                    Bits( 1, 1 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 1 ),
                    Bits( 1, 1 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 0 ),
                    Bits( 1, 1 ),
                    Bits( 1, 0 ),]

test_case_table = mk_test_case_table([
  (           "in_msgs        out_msgs         num_bits_exponent num_hash_funs src_delay sink_delay"),
  [ "direct", direct_in_msgs, direct_out_msgs, 8,                3,            0,        0          ],
  [ "direct", direct_in_msgs, direct_out_msgs, 8,                3,            7,        3          ],
])

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( test_params.num_bits_exponent,
                        test_params.num_hash_funs,
                        32,
                        test_params.in_msgs,
                        test_params.out_msgs,
                        test_params.src_delay,
                        test_params.sink_delay,
                        dump_vcd, test_verilog ) )
