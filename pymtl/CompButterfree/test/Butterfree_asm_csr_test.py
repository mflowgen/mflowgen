#=========================================================================
# Butterfree_asm_csr_test.py
#=========================================================================
# In this test we pick representative instruction from each instrucion
# categories

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
# csr
#-------------------------------------------------------------------------

from proc.test import inst_csr

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_csr.gen_basic_test      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_csr.gen_bypass_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_csr.gen_value_test      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_csr.gen_random_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_csr.gen_core_stats_test , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_csr( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

