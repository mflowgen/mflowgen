#=========================================================================
# Butterfree_bloom_test.py
#=========================================================================

import pytest

from pymtl              import *

from Butterfree_harness import asm_test, synthesize_testtable

from CompButterfree.Butterfree import Butterfree

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Butterfree_run_test       import run_test

#-------------------------------------------------------------------------
# bloom
#-------------------------------------------------------------------------

from bloom.test import inst_bloom

@pytest.mark.parametrize(
      "name, test,                              src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bloom.gen_basic_test     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bloom.gen_bypass_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bloom.gen_bypass_test    , 3        , 5         , 0.5           , 3           ) ,
      asm_test( inst_bloom.gen_basic2_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bloom.gen_stream_test    , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_bloom( name, test, src_delay, sink_delay, mem_stall_prob,
                mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    assembly_image   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,            [],      [],          [] ]

  # Note: the bloom tests make use of one core only. This is because there
  # is an interaction with the memory port, so we don't want interaction
  # from other cores.
  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency,
            only_one_core=True )

