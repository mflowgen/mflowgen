#=========================================================================
# Chansey_asm_fpu_test.py
#=========================================================================

import pytest
import random

from pymtl               import *
from Chansey_harness     import asm_test

from CompChansey.Chansey import Chansey

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Chansey_run_test    import run_test

#-------------------------------------------------------------------------
# Making py.test pretty :3
#-------------------------------------------------------------------------

from Chansey_harness     import synthesize_testtable

#-------------------------------------------------------------------------
# fmv
#-------------------------------------------------------------------------

from proc.test import inst_fmv

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fmv.gen_basic_test           , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmv.gen_fmv_w_x_src_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmv.gen_fmv_bypass_dep_test  , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmv.gen_fmv_x_w_dest_dep_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmv.gen_random_test          , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmv.gen_random_test          , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fmv( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fadd.s
#-------------------------------------------------------------------------

from proc.test import inst_fadds

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fadds.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fadds.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fadds( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fsub.s
#-------------------------------------------------------------------------

from proc.test import inst_fsubs

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fsubs.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fsubs.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fsubs( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fmul.s
#-------------------------------------------------------------------------

from proc.test import inst_fmuls

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fmuls.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmuls.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fmuls( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fdiv.s
#-------------------------------------------------------------------------

from proc.test import inst_fdivs

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fdivs.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fdivs.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fdivs( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fmin.s
#-------------------------------------------------------------------------

from proc.test import inst_fmins

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fmins.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmins.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fmins( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fmax.s
#-------------------------------------------------------------------------

from proc.test import inst_fmaxs

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fmaxs.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fmaxs.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fmaxs( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# feq.s
#-------------------------------------------------------------------------

from proc.test import inst_feqs

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_feqs.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_feqs.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_feqs( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# flt.s
#-------------------------------------------------------------------------

from proc.test import inst_flts

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_flts.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_flts.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_flts( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fle.s
#-------------------------------------------------------------------------

from proc.test import inst_fles

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fles.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_src0_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_src1_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_srcs_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_srcs_dest_test, 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fles.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fles( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fcvt.w.s
#-------------------------------------------------------------------------

from proc.test import inst_fcvt_w_s

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fcvt_w_s.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_w_s.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_w_s.gen_src_dep_test  , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_w_s.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_w_s.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_w_s.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fcvt_w_s( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )

#-------------------------------------------------------------------------
# fcvt.s.w
#-------------------------------------------------------------------------

from proc.test import inst_fcvt_s_w

@pytest.mark.parametrize(
      "name, test,                           src_delay, sink_delay, mem_stall_prob, mem_latency",
  **synthesize_testtable(
    [
      asm_test( inst_fcvt_s_w.gen_basic_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_s_w.gen_dest_dep_test , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_s_w.gen_src_dep_test  , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_s_w.gen_value_test    , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_s_w.gen_random_test   , 0        , 0         , 0             , 0           ) ,
      asm_test( inst_fcvt_s_w.gen_random_test   , 3        , 5         , 0.5           , 3           ) ,
    ]
  )
)
def test_fcvt_s_w( name, test, src_delay, sink_delay, mem_stall_prob,
              mem_latency, dump_vcd, test_verilog ):

  #               ctrlreg_msg    asm_testcase   mdu_msgs icache_msgs  dcache
  test_vector = [ "asm",         test,          [],      [],          [] ]

  run_test( test_vector, dump_vcd, test_verilog,
            src_delay      = src_delay     , sink_delay  = sink_delay ,
            mem_stall_prob = mem_stall_prob, mem_latency =mem_latency )






