#=========================================================================
# ProcAltRTL_fpu_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl         import *
from harness       import *
from proc.ProcRTL  import ProcRTL

#-------------------------------------------------------------------------
# fmv
#-------------------------------------------------------------------------

import inst_fmv

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fmv.gen_basic_test            ),
  asm_test( inst_fmv.gen_fmv_w_x_src_dep_test  ),
  asm_test( inst_fmv.gen_fmv_bypass_dep_test   ),
  asm_test( inst_fmv.gen_fmv_x_w_dest_dep_test ),
  asm_test( inst_fmv.gen_random_test           ),
])
def test_fmv( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fmv_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fmv.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fadd.s
#-------------------------------------------------------------------------

import inst_fadds

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fadds.gen_basic_test            ),
  asm_test( inst_fadds.gen_dest_dep_test         ),
  asm_test( inst_fadds.gen_src0_dep_test         ),
  asm_test( inst_fadds.gen_src1_dep_test         ),
  asm_test( inst_fadds.gen_srcs_dep_test         ),
  asm_test( inst_fadds.gen_srcs_dest_test        ),
  asm_test( inst_fadds.gen_value_test            ),
  asm_test( inst_fadds.gen_random_test           ),
])
def test_fadds( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fadds_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fadds.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fsub.s
#-------------------------------------------------------------------------

import inst_fsubs

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fsubs.gen_basic_test            ),
  asm_test( inst_fsubs.gen_dest_dep_test         ),
  asm_test( inst_fsubs.gen_src0_dep_test         ),
  asm_test( inst_fsubs.gen_src1_dep_test         ),
  asm_test( inst_fsubs.gen_srcs_dep_test         ),
  asm_test( inst_fsubs.gen_srcs_dest_test        ),
  asm_test( inst_fsubs.gen_value_test            ),
  asm_test( inst_fsubs.gen_random_test           ),
])
def test_fsubs( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fsubs_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fsubs.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fmul.s
#-------------------------------------------------------------------------

import inst_fmuls

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fmuls.gen_basic_test            ),
  asm_test( inst_fmuls.gen_dest_dep_test         ),
  asm_test( inst_fmuls.gen_src0_dep_test         ),
  asm_test( inst_fmuls.gen_src1_dep_test         ),
  asm_test( inst_fmuls.gen_srcs_dep_test         ),
  asm_test( inst_fmuls.gen_srcs_dest_test        ),
  asm_test( inst_fmuls.gen_value_test            ),
  asm_test( inst_fmuls.gen_random_test           ),
])
def test_fmuls( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fmuls_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fmuls.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fdiv.s
#-------------------------------------------------------------------------

import inst_fdivs

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fdivs.gen_basic_test            ),
  asm_test( inst_fdivs.gen_dest_dep_test         ),
  asm_test( inst_fdivs.gen_src0_dep_test         ),
  asm_test( inst_fdivs.gen_src1_dep_test         ),
  asm_test( inst_fdivs.gen_srcs_dep_test         ),
  asm_test( inst_fdivs.gen_srcs_dest_test        ),
  asm_test( inst_fdivs.gen_value_test            ),
  asm_test( inst_fdivs.gen_random_test           ),
])
def test_fdivs( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fdivs_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fdivs.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fmin.s
#-------------------------------------------------------------------------

import inst_fmins

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fmins.gen_basic_test            ),
  asm_test( inst_fmins.gen_dest_dep_test         ),
  asm_test( inst_fmins.gen_src0_dep_test         ),
  asm_test( inst_fmins.gen_src1_dep_test         ),
  asm_test( inst_fmins.gen_srcs_dep_test         ),
  asm_test( inst_fmins.gen_srcs_dest_test        ),
  asm_test( inst_fmins.gen_value_test            ),
  asm_test( inst_fmins.gen_random_test           ),
])
def test_fmins( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fmins_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fmins.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fmax.s
#-------------------------------------------------------------------------

import inst_fmaxs

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fmaxs.gen_basic_test            ),
  asm_test( inst_fmaxs.gen_dest_dep_test         ),
  asm_test( inst_fmaxs.gen_src0_dep_test         ),
  asm_test( inst_fmaxs.gen_src1_dep_test         ),
  asm_test( inst_fmaxs.gen_srcs_dep_test         ),
  asm_test( inst_fmaxs.gen_srcs_dest_test        ),
  asm_test( inst_fmaxs.gen_value_test            ),
  asm_test( inst_fmaxs.gen_random_test           ),
])
def test_fmaxs( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fmaxs_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fmaxs.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# feq.s
#-------------------------------------------------------------------------

import inst_feqs

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_feqs.gen_basic_test            ),
  asm_test( inst_feqs.gen_dest_dep_test         ),
  asm_test( inst_feqs.gen_src0_dep_test         ),
  asm_test( inst_feqs.gen_src1_dep_test         ),
  asm_test( inst_feqs.gen_srcs_dep_test         ),
  asm_test( inst_feqs.gen_srcs_dest_test        ),
  asm_test( inst_feqs.gen_value_test            ),
  asm_test( inst_feqs.gen_random_test           ),
])
def test_feqs( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_feqs_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_feqs.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# flt.s
#-------------------------------------------------------------------------

import inst_flts

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_flts.gen_basic_test            ),
  asm_test( inst_flts.gen_dest_dep_test         ),
  asm_test( inst_flts.gen_src0_dep_test         ),
  asm_test( inst_flts.gen_src1_dep_test         ),
  asm_test( inst_flts.gen_srcs_dep_test         ),
  asm_test( inst_flts.gen_srcs_dest_test        ),
  asm_test( inst_flts.gen_value_test            ),
  asm_test( inst_flts.gen_random_test           ),
])
def test_flts( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_flts_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_flts.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fle.s
#-------------------------------------------------------------------------

import inst_fles

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fles.gen_basic_test            ),
  asm_test( inst_fles.gen_dest_dep_test         ),
  asm_test( inst_fles.gen_src0_dep_test         ),
  asm_test( inst_fles.gen_src1_dep_test         ),
  asm_test( inst_fles.gen_srcs_dep_test         ),
  asm_test( inst_fles.gen_srcs_dest_test        ),
  asm_test( inst_fles.gen_value_test            ),
  asm_test( inst_fles.gen_random_test           ),
])
def test_fles( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fles_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fles.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fcvt.w.s
#-------------------------------------------------------------------------

import inst_fcvt_w_s

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fcvt_w_s.gen_basic_test            ),
  asm_test( inst_fcvt_w_s.gen_dest_dep_test         ),
  asm_test( inst_fcvt_w_s.gen_src_dep_test          ),
  asm_test( inst_fcvt_w_s.gen_value_test            ),
  asm_test( inst_fcvt_w_s.gen_random_test           ),
])
def test_fcvt_w_s( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fcvt_w_s_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fcvt_w_s.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fcvt.s.w
#-------------------------------------------------------------------------

import inst_fcvt_s_w

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fcvt_s_w.gen_basic_test            ),
  asm_test( inst_fcvt_s_w.gen_dest_dep_test         ),
  asm_test( inst_fcvt_s_w.gen_src_dep_test          ),
  asm_test( inst_fcvt_s_w.gen_value_test            ),
  asm_test( inst_fcvt_s_w.gen_random_test           ),
])
def test_fcvt_s_w( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fcvt_s_w_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fcvt_s_w.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# flw
#-------------------------------------------------------------------------

import inst_flw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_flw.gen_basic_test            ),
  asm_test( inst_flw.gen_dest_dep_test         ),
  asm_test( inst_flw.gen_base_dep_test         ),
  asm_test( inst_flw.gen_srcs_dest_test        ),
  asm_test( inst_flw.gen_value_test            ),
  asm_test( inst_flw.gen_random_test           ),
])
def test_flw( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_flw_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_flw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# fsw
#-------------------------------------------------------------------------

import inst_fsw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_fsw.gen_basic_test            ),
  asm_test( inst_fsw.gen_dest_dep_test         ),
  asm_test( inst_fsw.gen_base_dep_test         ),
  asm_test( inst_fsw.gen_src_dep_test          ),
  asm_test( inst_fsw.gen_srcs_dep_test         ),
  asm_test( inst_fsw.gen_value_test            ),
  asm_test( inst_fsw.gen_random_test           ),
])
def test_fsw( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_fsw_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_fsw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

