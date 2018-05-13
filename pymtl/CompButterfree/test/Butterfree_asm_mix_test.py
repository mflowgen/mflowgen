#=========================================================================
# Butterfree_asm_mix_test.py
#=========================================================================

import pytest
import random

from pymtl                     import *
from Butterfree_harness        import asm_test

from CompButterfree.Butterfree import Butterfree

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Butterfree_run_test       import run_test

#-------------------------------------------------------------------------
# Making py.test pretty :3
#-------------------------------------------------------------------------

from Butterfree_harness        import synthesize_testtable

#-------------------------------------------------------------------------
# jal_beq
#-------------------------------------------------------------------------

from proc.test import inst_jal_beq

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_jal_beq.gen_basic_test, 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_jal_beq( name, test, src_delay, sink_delay, mem_stall_prob,
                  mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# mul_mem
#-------------------------------------------------------------------------

from proc.test import inst_mul_mem

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mul_mem.gen_basic_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul_mem.gen_more_test , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_mul_mem( name, test, src_delay, sink_delay, mem_stall_prob,
                  mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

