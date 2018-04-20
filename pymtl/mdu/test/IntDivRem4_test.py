#=========================================================================
# IntDivRem4_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl          import *
from pclib.test     import mk_test_case_table, run_sim
from pclib.test     import TestSource, TestSink
from mdu.IntDivRem4 import IntDivRem4

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
    s.idiv = IntDivRem4 ( nbits, 8 )
    s.sink = TestSink   ( MduRespMsg(nbits), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.idiv.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.idiv = TranslationTool( s.idiv )

    # Connect

    s.connect( s.src.out,  s.idiv.req  )
    s.connect( s.idiv.resp, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.idiv.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# mk_req_msg
#-------------------------------------------------------------------------

# req typ:
# 4 - div
# 5 - divu
# 6 - rem
# 7 - remu

req_type  = MduReqMsg( 32, 8 )
resp_type = MduRespMsg( 32 )

def req( typ, a, b, nbits=32 ):
  return req_type.mk_msg( typ, 2, Bits( nbits, a, trunc=True ), Bits( nbits, b, trunc=True ) )

def resp( a, nbits=32 ):
  return resp_type.mk_msg( 2, Bits( nbits, a, trunc=True ) )

# direct test cases
# https://github.com/riscv/riscv-tests/blob/master/isa/rv32um/div*.S

direct_div_msgs  = []
direct_divu_msgs = []
direct_rem_msgs  = []
direct_remu_msgs = []
direct_mix_msgs  = []

# generate direct messages
direct_idiv_cases = [
#   a        b     div      divu        rem      remu
  ( 20,      6,    3,       3,          2,       2      ),
  ( -20,     6,    -3,      715827879,  -2,      2      ),
  ( 20,      -6 ,  -3,      0,          2,       20     ),
  ( -20,     -6,   3,       0,          -2,      -20    ),
  ( -1<<31,  1,    -1<<31,  -1<<31,     0,       0      ),
  ( -1<<31,  -1,   -1<<31,  0,          0,       -1<<31 ),
  ( -1<<31,  0,    -1,      -1,         -1<<31,  -1<<31 ),
  ( 1,       0,    -1,      -1,         1,       1      ),
  ( 0,       0,    -1,      -1,         0,       0      ),
]

# div
for a, b, res, _, _, _ in direct_idiv_cases:
  direct_div_msgs.extend( [ req( req_type.TYPE_DIV, a, b ), resp( res ) ] )

# divu
for a, b, _, res, _, _ in direct_idiv_cases:
  direct_divu_msgs.extend( [ req( req_type.TYPE_DIVU, a, b ), resp( res ) ] )

# rem
for a, b, _, _, res, _ in direct_idiv_cases:
  direct_rem_msgs.extend( [ req( req_type.TYPE_REM, a, b ), resp( res ) ] )

# remu
for a, b, _, _, _, res in direct_idiv_cases:
  direct_remu_msgs.extend( [ req( req_type.TYPE_REMU, a, b ), resp( res ) ] )

# mix
mix_lists = [] 
for a, b, w, x, y, z in direct_idiv_cases:
  mix_lists.append( [ req( req_type.TYPE_DIV,  a, b ), resp( w ) ] )
  mix_lists.append( [ req( req_type.TYPE_DIVU, a, b ), resp( x ) ] )
  mix_lists.append( [ req( req_type.TYPE_REM,  a, b ), resp( y ) ] )
  mix_lists.append( [ req( req_type.TYPE_REMU, a, b ), resp( z ) ] )
random.shuffle( mix_lists )

direct_mix_msgs = reduce( lambda x,y:x+y, mix_lists )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                     "msgs             src_delay sink_delay"),
  [ "direct_div",       direct_div_msgs,  0,        0          ],
  [ "direct_divu",      direct_divu_msgs, 0,        0          ],
  [ "direct_rem",       direct_rem_msgs,  0,        0          ],
  [ "direct_remu",      direct_remu_msgs, 0,        0          ],
  [ "direct_mix",       direct_mix_msgs,  0,        0          ],
  [ "direct_div_3x14",  direct_div_msgs,  3,        14         ],
  [ "direct_divu_3x14", direct_divu_msgs, 3,        14         ],
  [ "direct_rem_3x14",  direct_rem_msgs,  3,        14         ],
  [ "direct_remu_3x14", direct_remu_msgs, 3,        14         ],
  [ "direct_mix_3x14",  direct_mix_msgs,  3,        14          ],
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

# def gen_msgs( nbits ):
  # src_msgs  = []
  # sink_msgs = []

  # for i in xrange(10):
    # x = random.randint(2, 2**nbits-1)
    # y = random.randint(1, min(x, 2**(nbits/3*2)))
    # z = Bits(nbits*2,0)
    # z[0:nbits]  = x
    # z[nbits:nbits*2] = y
    # src_msgs.append( z )
    # sink_msgs.append( Bits(nbits*2, ((x / y) << nbits) | (x % y) ) )

  # return src_msgs, sink_msgs

# def test_14( dump_vcd, test_verilog ):
  # src_msgs, sink_msgs = gen_msgs( 14 )
  # run_sim( TestHarness( 14,
                        # src_msgs, sink_msgs, 0, 0,
                        # dump_vcd, test_verilog ) )

# def test_32_delay( dump_vcd, test_verilog ):
  # src_msgs, sink_msgs = gen_msgs( 32 )
  # run_sim( TestHarness( 32,
                        # src_msgs, sink_msgs, 3, 14,
                        # dump_vcd, test_verilog ) )

# def test_64_delay( dump_vcd, test_verilog ):
  # src_msgs, sink_msgs = gen_msgs( 64 )
  # run_sim( TestHarness( 64,
                        # src_msgs, sink_msgs, 3, 14,
                        # dump_vcd, test_verilog ) )

# def test_128( dump_vcd, test_verilog ):
  # src_msgs, sink_msgs = gen_msgs( 128 )
  # run_sim( TestHarness( 128,
                        # src_msgs, sink_msgs, 0, 0,
                        # dump_vcd, test_verilog ) )
