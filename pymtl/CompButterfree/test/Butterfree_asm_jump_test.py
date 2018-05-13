#=========================================================================
# Butterfree_asm_jump_test.py
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
# jal
#-------------------------------------------------------------------------

from proc.test import inst_jal

@pytest.mark.parametrize(
      "name, test,                               src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_jal.gen_basic_test        , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_link_dep_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_jump_test         , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_back_to_back_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_value_test_0      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_value_test_1      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_value_test_2      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_value_test_3      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jal.gen_jal_stall_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_jal( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# jalr
#-------------------------------------------------------------------------

from proc.test import inst_jalr

@pytest.mark.parametrize(
      "name, test,                                src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_jalr.gen_basic_test        , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_link_dep_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_jump_test         , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_lsb_test          , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_value_test_0      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_value_test_1      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_value_test_2      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_jalr.gen_value_test_3      , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_jalr( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

