#=========================================================================
# Butterfree_asm_mem_test.py
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
# lb
#-------------------------------------------------------------------------

from proc.test import inst_lb

@pytest.mark.parametrize(
      "name, test,                          src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lb.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_base_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lb.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_lb( name, test, src_delay, sink_delay, mem_stall_prob,
             mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# lh
#-------------------------------------------------------------------------

from proc.test import inst_lh

@pytest.mark.parametrize(
      "name, test,                          src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lh.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_base_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lh.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_lh( name, test, src_delay, sink_delay, mem_stall_prob,
             mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# lbu
#-------------------------------------------------------------------------

from proc.test import inst_lbu

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lbu.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_base_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lbu.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_lbu( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# lhu
#-------------------------------------------------------------------------

from proc.test import inst_lhu

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_lhu.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_base_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_lhu.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_lhu( name, test, src_delay, sink_delay, mem_stall_prob,
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

#-------------------------------------------------------------------------
# amoadd
#-------------------------------------------------------------------------

from proc.test import inst_amoadd

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amoadd.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoadd.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoadd.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amoadd( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amoand
#-------------------------------------------------------------------------

from proc.test import inst_amoand

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amoand.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoand.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoand.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amoand( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amoor
#-------------------------------------------------------------------------

from proc.test import inst_amoor

@pytest.mark.parametrize(
      "name, test,                          src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amoor.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoor.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoor.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amoor( name, test, src_delay, sink_delay, mem_stall_prob,
                mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amoswap
#-------------------------------------------------------------------------

from proc.test import inst_amoswap

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amoswap.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoswap.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoswap.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amoswap( name, test, src_delay, sink_delay, mem_stall_prob,
                  mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amomin
#-------------------------------------------------------------------------

from proc.test import inst_amomin

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amomin.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomin.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomin.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amomin( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amominu
#-------------------------------------------------------------------------

from proc.test import inst_amominu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amominu.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amominu.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amominu.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amominu( name, test, src_delay, sink_delay, mem_stall_prob,
                  mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amomax
#-------------------------------------------------------------------------

from proc.test import inst_amomax

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amomax.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomax.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomax.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amomax( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amomaxu
#-------------------------------------------------------------------------

from proc.test import inst_amomaxu

@pytest.mark.parametrize(
      "name, test,                            src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amomaxu.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomaxu.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amomaxu.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amomaxu( name, test, src_delay, sink_delay, mem_stall_prob,
                  mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# amoxor
#-------------------------------------------------------------------------

from proc.test import inst_amoxor

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_amoxor.gen_basic_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoxor.gen_value_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_amoxor.gen_random_test, 0        , 0         , 0             , 0           ) ,
    ]
  )
)
def test_amoxor( name, test, src_delay, sink_delay, mem_stall_prob,
                 mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

