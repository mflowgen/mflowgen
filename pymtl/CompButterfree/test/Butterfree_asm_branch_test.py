#=========================================================================
# Butterfree_asm_branch_test.py
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
# beq
#-------------------------------------------------------------------------

from proc.test import inst_beq

@pytest.mark.parametrize(
      "name, test,                                    src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_beq.gen_basic_test             , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_value_test             , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_beq.gen_random_test            , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_beq( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# bne
#-------------------------------------------------------------------------

from proc.test import inst_bne

@pytest.mark.parametrize(
      "name, test,                                    src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bne.gen_basic_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_value_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_random_test            , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_bne( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# bge
#-------------------------------------------------------------------------

from proc.test import inst_bge

@pytest.mark.parametrize(
      "name, test,                                    src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bge.gen_basic_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_value_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bge.gen_random_test            , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_bge( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# bgeu
#-------------------------------------------------------------------------

from proc.test import inst_bgeu

@pytest.mark.parametrize(
      "name, test,                                     src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bgeu.gen_basic_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_value_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bgeu.gen_random_test            , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_bgeu( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# blt
#-------------------------------------------------------------------------

from proc.test import inst_blt

@pytest.mark.parametrize(
      "name, test,                                    src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_blt.gen_basic_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_value_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_blt.gen_random_test            , 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_blt( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# bltu
#-------------------------------------------------------------------------

from proc.test import inst_bltu

@pytest.mark.parametrize(
      "name, test,                                     src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bltu.gen_basic_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_src0_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_src0_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_src1_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_src1_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_srcs_dep_taken_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_srcs_dep_nottaken_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_src0_eq_src1_test      , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_value_test             , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bltu.gen_random_test            , 0        , 0         , 0             , 0           ) ,
    ]
  )
)

def test_bltu( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )
