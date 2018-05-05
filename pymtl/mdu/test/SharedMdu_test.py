#=========================================================================
# SharedMdu_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl              import *
from pclib.test         import mk_test_case_table, run_sim
from pclib.test         import TestSource, TestSink, TestNetSink

from mdu.SharedMdu  import SharedMdu
from ifcs import MduReqMsg, MduRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, nreqs, nbits, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = [ TestSource( MduReqMsg(nbits, 8), src_msgs[i],  src_delay ) \
                for i in xrange(nreqs) ] 
    s.mdu  = SharedMdu( nreqs, nbits, 8 )

    # Here since SharedMdu cannot wipe the opaque field easily, and we don't
    # care about the opaque field at sink side, I just make it check only
    # the result field at the sink

    s.sink = [ TestNetSink( nbits, [ x.result for x in sink_msgs[i] ], sink_delay ) \
                for i in xrange(nreqs) ]

    # Dump VCD

    if dump_vcd:
      s.mdu.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.mdu = TranslationTool( s.mdu, verilator_xinit=test_verilog )

    # Connect

    for i in xrange(nreqs):
      s.connect( s.src[i].out,  s.mdu.reqs[i]  )
      s.connect( s.mdu.resps[i].val, s.sink[i].in_.val )
      s.connect( s.mdu.resps[i].rdy, s.sink[i].in_.rdy )
      # discard opaque field
      s.connect( s.mdu.resps[i].msg.result, s.sink[i].in_.msg )

  def done( s ):
    return all([ x.done for x in s.src ]) and all([ x.done for x in s.sink ])

  def line_trace( s ):
    return "|".join( [ x.line_trace() for x in s.src ] )  + " > " + \
           s.mdu.line_trace()  + " > " + \
           "|".join( [ x.line_trace() for x in s.sink ] )


# Reuse test cases!
from IntMulVarLat_test import mix_lists as imul_mix_lists
from IntDivRem4_test   import mix_lists as idiv_mix_lists

# mix
mix_lists = imul_mix_lists + idiv_mix_lists
random.shuffle( mix_lists )

def split( msg_lists, n ):
  bins = [ [] for _ in xrange(n) ]
  for i in xrange(len(msg_lists)):
    bins[ i % n ].append( msg_lists[i] )

  src_msgs  = []
  sink_msgs = []
  for i in xrange(n):
    tmp = reduce( lambda x,y:x+y, bins[i] )
    src_msgs.append( tmp[::2] )
    sink_msgs.append( tmp[1::2] )
  return ( src_msgs, sink_msgs )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                        "nreqs msgs                 src_delay sink_delay"),
  [ "mix_split_2reqs",      2,    split(mix_lists, 2), 0,        0          ],
  [ "mix_split_2reqs_3x14", 2,    split(mix_lists, 2), 3,        14         ],
  [ "mix_split_4reqs",      4,    split(mix_lists, 4), 0,        0          ],
  [ "mix_split_4reqs_3x14", 4,    split(mix_lists, 4), 3,        14         ],
  [ "mix_split_8reqs",      8,    split(mix_lists, 8), 0,        0          ],
  [ "mix_split_8reqs_3x14", 8,    split(mix_lists, 8), 3,        14         ],

  # [ "mix_all_2reqs",        4,    direct_mix_msgs,   0,        0          ],
  # [ "mix_all_2reqs_3x14",   4,    direct_mix_msgs,   3,        14          ],
  # [ "mix_all_4reqs",        4,    direct_mix_msgs,   0,        0          ],
  # [ "mix_all_4reqs_3x14",   4,    direct_mix_msgs,   3,        14          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( test_params.nreqs, 32,
                        test_params.msgs[0], test_params.msgs[1],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )
