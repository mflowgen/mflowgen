#=========================================================================
# IntMulDivUnit_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl              import *
from pclib.test         import mk_test_case_table, run_sim
from pclib.test         import TestSource, TestSink, TestNetSink

from mdu.IntMulDivUnit  import IntMulDivUnit
from ifcs import MduReqMsg, MduRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, nbits, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models
    

    s.src  = TestSource   ( MduReqMsg(nbits, 8), src_msgs,  src_delay  )
    s.imul = IntMulDivUnit( nbits, 8 )
    s.sink = TestNetSink     ( MduRespMsg(nbits), sink_msgs, sink_delay )

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


# Reuse test cases!
from IntMulVarLat_test import direct_mul_msgs, direct_mulh_msgs, \
                              direct_mulhsu_msgs, direct_mulhu_msgs, \
                              mix_lists as imul_mix_lists

from IntDivRem4_test import direct_div_msgs, direct_divu_msgs, \
                              direct_rem_msgs, direct_remu_msgs, \
                              mix_lists as idiv_mix_lists
# mix
mix_lists = imul_mix_lists + idiv_mix_lists
random.shuffle( mix_lists )

direct_mix_msgs = reduce( lambda x,y:x+y, mix_lists )

# dump to Verilog file

inp = [ x.uint() for x in direct_mix_msgs[::2] ]
oup = [ x.result().uint() for x in direct_mix_msgs[1::2] ]

with open( "mdu_test_cases.v", "w") as f:
  f.write("num_inputs = %d;\n" % len(inp))
  for i in xrange(len(inp)):

    x = hex(inp[i])[2:]
    if x[-1] == 'L':
      x = x[:-1]

    y = hex(oup[i])[2:]
    if y[-1] == 'L':
      y = y[:-1]

    f.write( "init( %d, %d'h%s, %d'h%s );\n" % (i,
                                                direct_mix_msgs[0].nbits, x,
                                                direct_mix_msgs[1].nbits, y) );


#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                       "msgs               src_delay sink_delay"),
  [ "direct_mul",         direct_mul_msgs,    0,        0          ],
  [ "direct_mulh",        direct_mulh_msgs,   0,        0          ],
  [ "direct_mulhsu",      direct_mulhsu_msgs, 0,        0          ],
  [ "direct_mulhu",       direct_mulhu_msgs,  0,        0          ],
  [ "direct_div",         direct_div_msgs,    0,        0          ],
  [ "direct_divu",        direct_divu_msgs,   0,        0          ],
  [ "direct_rem",         direct_rem_msgs,    0,        0          ],
  [ "direct_remu",        direct_remu_msgs,   0,        0          ],
  
  [ "direct_mul_3x14",    direct_mul_msgs,    3,        14         ],
  [ "direct_mulh_3x14",   direct_mulh_msgs,   3,        14         ],
  [ "direct_mulhsu_3x14", direct_mulhsu_msgs, 3,        14         ],
  [ "direct_mulhu_3x14",  direct_mulhu_msgs,  3,        14         ],
  [ "direct_div_3x14",    direct_div_msgs,    3,        14         ],
  [ "direct_divu_3x14",   direct_divu_msgs,   3,        14         ],
  [ "direct_rem_3x14",    direct_rem_msgs,    3,        14         ],
  [ "direct_remu_3x14",   direct_remu_msgs,   3,        14         ],

  [ "direct_mix",         direct_mix_msgs,    0,        0          ],
  [ "direct_mix_3x14",    direct_mix_msgs,    3,        14          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )
