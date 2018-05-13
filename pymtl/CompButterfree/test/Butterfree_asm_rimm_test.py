#=========================================================================
# Butterfree_asm_rimm_test.py
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
# addi
#-------------------------------------------------------------------------

from proc.test import inst_addi

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_addi.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_addi.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_addi.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_addi.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_addi.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_addi.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_addi( name, test, src_delay, sink_delay, mem_stall_prob,
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
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_andi.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_andi.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_andi.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_andi.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_andi.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_andi.gen_random_test    , 0        , 0         , 0             , 0           )    ,
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
# ori
#-------------------------------------------------------------------------

from proc.test import inst_ori

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_ori.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_ori.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_ori.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_ori.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_ori.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_ori.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_ori( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# xori
#-------------------------------------------------------------------------

from proc.test import inst_xori

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_xori.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xori.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xori.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xori.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xori.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_xori.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_xori( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# slti
#-------------------------------------------------------------------------

from proc.test import inst_slti

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_slti.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slti.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slti.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slti.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slti.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slti.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_slti( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# sltiu
#-------------------------------------------------------------------------

from proc.test import inst_sltiu

@pytest.mark.parametrize(
      "name, test,                              src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_sltiu.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltiu.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltiu.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltiu.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltiu.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_sltiu.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_sltiu( name, test, src_delay, sink_delay, mem_stall_prob,
                mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# srai
#-------------------------------------------------------------------------

from proc.test import inst_srai

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_srai.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srai.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srai.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srai.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srai.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srai.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_srai( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# srli
#-------------------------------------------------------------------------

from proc.test import inst_srli

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_srli.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srli.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srli.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srli.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srli.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_srli.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_srli( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# slli
#-------------------------------------------------------------------------

from proc.test import inst_slli

@pytest.mark.parametrize(
      "name, test,                             src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_slli.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slli.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slli.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slli.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slli.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_slli.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_slli( name, test, src_delay, sink_delay, mem_stall_prob,
               mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# lui
#-------------------------------------------------------------------------

from proc.test import inst_lui

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lui.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_lui.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_lui.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_lui.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_lui.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_lui.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_lui( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# auipc
#-------------------------------------------------------------------------

from proc.test import inst_auipc

@pytest.mark.parametrize(
      "name, test,                              src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_auipc.gen_basic_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_auipc.gen_dest_dep_test  , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_auipc.gen_src_dep_test   , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_auipc.gen_srcs_dest_test , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_auipc.gen_value_test     , 0        , 0         , 0             , 0           )    ,
      asm_test( inst_auipc.gen_random_test    , 0        , 0         , 0             , 0           )    ,
    ]
  )
)
def test_auipc( name, test, src_delay, sink_delay, mem_stall_prob,
                mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

