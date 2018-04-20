#=========================================================================
# IntMulVarLat_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl            import *
from pclib.test       import mk_test_case_table, run_sim
from pclib.test       import TestSource, TestSink
from mdu.IntMulVarLat import IntMulVarLat

from ifcs import MduReqMsg, MduRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, nbits, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource ( MduReqMsg(nbits, 8), src_msgs,  src_delay  )
    s.imul = IntMulVarLat( nbits, 8 )
    s.sink = TestSink   ( MduRespMsg(nbits), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.imul.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.imul = TranslationTool( s.imul )

    # Connect

    s.connect( s.src.out,  s.imul.req  )
    s.connect( s.imul.resp, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.imul.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# mk_req_msg
#-------------------------------------------------------------------------

# req typ:
# 0 - mul
# 1 - mulh
# 2 - mulhsu
# 3 - mulhu

req_type  = MduReqMsg( 32, 8 )
resp_type = MduRespMsg( 32 )

def req( typ, a, b, nbits=32 ):
  return req_type.mk_msg( typ, 2, Bits( nbits, a, trunc=True ), Bits( nbits, b, trunc=True ) )

def resp( a, nbits=32 ):
  return resp_type.mk_msg( 2, Bits( nbits, a, trunc=True ) )

# direct test cases
# https://github.com/riscv/riscv-tests/blob/master/isa/rv32um/mul*.S

direct_mul_msgs    = []
direct_mulh_msgs   = []
direct_mulhsu_msgs = []
direct_mulhu_msgs  = []
direct_mix_msgs    = []

# generate direct messages
direct_imul_cases = [
#  a           b           mul         mulh        mulhsu      mulhu
  (0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000),
  (0x00000001, 0x00000001, 0x00000001, 0x00000000, 0x00000000, 0x00000000),
  (0x00000003, 0x00000007, 0x00000015, 0x00000000, 0x00000000, 0x00000000),
  (0x00000000, 0xffff8000, 0x00000000, 0x00000000, 0x00000000, 0x00000000),
  (0x80000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000),
  (0x80000000, 0xffff8000, 0x00000000, 0x00004000, 0x80004000, 0x7fffc000),
  (0xaaaaaaab, 0x0002fe7d, 0x0000ff7f, 0xffff0081, 0xffff0081, 0x0001fefe),
  (0x0002fe7d, 0xaaaaaaab, 0x0000ff7f, 0xffff0081, 0x0001fefe, 0x0001fefe),
  (0xff000000, 0xff000000, 0x00000000, 0x00010000, 0xff010000, 0xfe010000),
  (0xffffffff, 0xffffffff, 0x00000001, 0x00000000, 0xffffffff, 0xfffffffe),
  (0xffffffff, 0x00000001, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000),
  (0x00000001, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000),
]

# mul
for a, b, res, _, _, _ in direct_imul_cases:
  direct_mul_msgs.extend( [ req( req_type.TYPE_MUL, a, b ), resp( res ) ] )

# mulh
for a, b, _, res, _, _ in direct_imul_cases:
  direct_mulh_msgs.extend( [ req( req_type.TYPE_MULH, a, b ), resp( res ) ] )

# mulhsu
for a, b, _, _, res, _ in direct_imul_cases:
  direct_mulhsu_msgs.extend( [ req( req_type.TYPE_MULHSU, a, b ), resp( res ) ] )

# mulhu
for a, b, _, _, _, res in direct_imul_cases:
  direct_mulhu_msgs.extend( [ req( req_type.TYPE_MULHU, a, b ), resp( res ) ] )

# mix
mix_lists = []
for a, b, w, x, y, z in direct_imul_cases:
  mix_lists.append( [ req( req_type.TYPE_MUL,    a, b ), resp( w ) ] )
  mix_lists.append( [ req( req_type.TYPE_MULH,   a, b ), resp( x ) ] )
  mix_lists.append( [ req( req_type.TYPE_MULHSU, a, b ), resp( y ) ] )
  mix_lists.append( [ req( req_type.TYPE_MULHU,  a, b ), resp( z ) ] )
random.shuffle( mix_lists )

direct_mix_msgs = reduce( lambda x,y:x+y, mix_lists )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                       "msgs               src_delay sink_delay"),
  [ "direct_mul",         direct_mul_msgs,    0,        0          ],
  [ "direct_mulh",        direct_mulh_msgs,   0,        0          ],
  [ "direct_mulhsu",      direct_mulhsu_msgs, 0,        0          ],
  [ "direct_mulhu",       direct_mulhu_msgs,  0,        0          ],
  [ "direct_mix",         direct_mix_msgs,    0,        0          ],
  [ "direct_mul_3x14",    direct_mul_msgs,    3,        14         ],
  [ "direct_mulh_3x14",   direct_mulh_msgs,   3,        14         ],
  [ "direct_mulhsu_3x14", direct_mulhsu_msgs, 3,        14         ],
  [ "direct_mulhu_3x14",  direct_mulhu_msgs,  3,        14         ],
  [ "direct_mix_3x14",    direct_mix_msgs,    3,        14         ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog )
            )
