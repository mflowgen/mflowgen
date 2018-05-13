#=========================================================================
# Butterfree_asm_rr_test.py
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
# add
#-------------------------------------------------------------------------

from proc.test import inst_add

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_add.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_add.gen_random_test    , 0        , 0         , 0             , 0           )    ,
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
# sub
#-------------------------------------------------------------------------

from proc.test import inst_sub

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sub.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sub.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_sub( name, test, src_delay, sink_delay, mem_stall_prob,
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
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mul.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mul.gen_random_test    , 0        , 0         , 0             , 0           )    ,
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
# mulh
#-------------------------------------------------------------------------

from proc.test import inst_mulh

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mulh.gen_basic_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulh.gen_value_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulh.gen_random_test   , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_mulh( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# mulhsu
#-------------------------------------------------------------------------

from proc.test import inst_mulhsu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mulhsu.gen_basic_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulhsu.gen_value_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulhsu.gen_random_test , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_mulhsu( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# mulhu
#-------------------------------------------------------------------------

from proc.test import inst_mulhu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_mulhu.gen_basic_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulhu.gen_value_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_mulhu.gen_random_test  , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_mulhu( name, test, src_delay, sink_delay, mem_stall_prob,
                mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# div
#-------------------------------------------------------------------------

from proc.test import inst_div

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_div.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_div.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_div.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_div( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# divu
#-------------------------------------------------------------------------

from proc.test import inst_divu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_divu.gen_basic_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_divu.gen_value_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_divu.gen_random_test   , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_divu( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# rem
#-------------------------------------------------------------------------

from proc.test import inst_rem

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_rem.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_rem.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_rem.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_rem( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# remu
#-------------------------------------------------------------------------

from proc.test import inst_remu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_remu.gen_basic_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_remu.gen_value_test    , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_remu.gen_random_test   , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_remu( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# and
#-------------------------------------------------------------------------

from proc.test import inst_and

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_and.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_and.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_and( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# or
#-------------------------------------------------------------------------

from proc.test import inst_or

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_or.gen_basic_test      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_dest_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_src0_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_src1_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_srcs_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_srcs_dest_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_value_test      , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_or.gen_random_test     , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_or( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# xor
#-------------------------------------------------------------------------

from proc.test import inst_xor

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_xor.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xor.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_xor( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# slt
#-------------------------------------------------------------------------

from proc.test import inst_slt

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_slt.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slt.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_slt( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# sltu
#-------------------------------------------------------------------------

from proc.test import inst_sltu

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sltu.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltu.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_sltu( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# sra
#-------------------------------------------------------------------------

from proc.test import inst_sra

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sra.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sra.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_sra( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# srl
#-------------------------------------------------------------------------

from proc.test import inst_srl

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_srl.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srl.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_srl( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# sll
#-------------------------------------------------------------------------

from proc.test import inst_sll

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sll.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_src0_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_src1_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_srcs_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sll.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_sll( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

