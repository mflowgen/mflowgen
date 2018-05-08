#=========================================================================
# Butterfree_test.py
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

from Butterfree_harness import synthesize_testtable

#-------------------------------------------------------------------------
# add
#-------------------------------------------------------------------------

from proc.test import inst_add

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_add.gen_basic_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_dest_dep_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_src0_dep_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_src1_dep_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_srcs_dep_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_srcs_dest_test, 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_value_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_random_test   , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_add( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# mul
#-------------------------------------------------------------------------

from proc.test import inst_mul

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mul.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_mul.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_mul( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# andi
#-------------------------------------------------------------------------

from proc.test import inst_andi

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_andi.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_src_dep_test  , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_andi.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_andi( name, test, src_delay, sink_delay, mem_stall_prob,
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
      "name, test,                                   src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_bne.gen_basic_test            , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_dep_taken_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_dep_nottaken_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src1_dep_taken_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src1_dep_nottaken_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_srcs_dep_taken_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_srcs_dep_nottaken_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_src0_eq_src1_test     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_value_test            , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_random_test           , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_bne.gen_random_test           , 3        , 5         , 0.5           , 3           ) ,
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
# csr
#-------------------------------------------------------------------------

from proc.test import inst_csr

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_csr.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_csr.gen_bypass_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_csr.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_csr.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_csr.gen_multicore_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_csr.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
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


#-------------------------------------------------------------------------
# jal
#-------------------------------------------------------------------------

from proc.test import inst_jal

@pytest.mark.parametrize(
      "name, test,                              src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_jal.gen_basic_test       , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_link_dep_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_jump_test        , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_back_to_back_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_value_test_0     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_value_test_1     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_value_test_2     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_value_test_3     , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_jal_stall_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_jal.gen_jump_test        , 3        , 5         , 0.5           , 3           ) ,
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
# lw
#-------------------------------------------------------------------------

from proc.test import inst_lw

@pytest.mark.parametrize(
      "name, test,                          src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lw.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_base_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lw.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_lw( name, test, src_delay, sink_delay, mem_stall_prob,
             mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )


#-------------------------------------------------------------------------
# sw
#-------------------------------------------------------------------------

from proc.test import inst_sw

@pytest.mark.parametrize(
      "name, test,                              src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sw.gen_sameline_deps_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_sw.gen_twoline_deps_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_sw.gen_diffline_deps_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_sw.gen_diffline_deps_test, 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_sw( name, test, src_delay, sink_delay, mem_stall_prob,
             mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

