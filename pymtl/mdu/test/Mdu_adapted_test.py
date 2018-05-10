#=========================================================================
# Mdu_host_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl              import *
from pclib.test         import mk_test_case_table, run_sim
from pclib.test         import TestSource, TestSink, TestNetSink

from mdu.IntMulDivUnit    import IntMulDivUnit
from adapters.HostAdapter import HostAdapter
from ifcs import MduReqMsg, MduRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------
# This test harness instantiates two instruction sources, one from
# "host" and one from actual proc, selected by a single signal

class TestHarness (Model):

  def __init__( s, nbits, host_en, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.hsrc  = TestSource ( MduReqMsg(nbits, 8), src_msgs if host_en else [],  src_delay  )
    s.src   = TestSource ( MduReqMsg(nbits, 8), [] if host_en else src_msgs,  src_delay  )

    s.hsink = TestNetSink( MduRespMsg(nbits), sink_msgs if host_en else [], sink_delay )
    s.sink  = TestNetSink( MduRespMsg(nbits), [] if host_en else sink_msgs, sink_delay )

    s.mdu         = IntMulDivUnit(32,8)
    s.mdu_adapter = HostAdapter( req = s.mdu.req, resp = s.mdu.resp )

    # Connect

    s.connect( s.mdu_adapter.host_en, host_en!=0 )

    s.connect( s.hsrc.out,  s.mdu_adapter.hostreq  )
    s.connect( s.src.out,   s.mdu_adapter.realreq  )

    s.connect( s.mdu_adapter.req,  s.mdu.req )
    s.connect( s.mdu_adapter.resp, s.mdu.resp )

    s.connect( s.mdu_adapter.hostresp, s.hsink.in_ )
    s.connect( s.mdu_adapter.realresp, s.sink.in_ )

  def done( s ):
    return s.hsrc.done and s.src.done and s.hsink.done and s.sink.done

  def line_trace( s ):
    return "[H]" + s.hsrc.line_trace() + "[C]" + s.src.line_trace()  + " > " + \
           s.mdu_adapter.line_trace() + s.mdu.line_trace()  + " > " + \
           "[H]" + s.hsink.line_trace() + "[C]" + s.sink.line_trace()


# Reuse test cases!
from IntMulVarLat_test import mix_lists as imul_mix_lists

from IntDivRem4_test import mix_lists as idiv_mix_lists
# mix
mix_lists = imul_mix_lists + idiv_mix_lists
random.shuffle( mix_lists )

direct_mix_msgs = reduce( lambda x,y:x+y, mix_lists )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                          "msgs             host_en  src_delay sink_delay"),
  [ "direct_mix_core",       direct_mix_msgs,  0,        0,        0          ],
  [ "direct_mix_host",       direct_mix_msgs,  1,        0,        0          ],
  [ "direct_mix_core_3x14",  direct_mix_msgs,  0,        3,        14         ],
  [ "direct_mix_host_3x14",  direct_mix_msgs,  1,        3,        14         ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( 32, test_params.host_en, 
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )
