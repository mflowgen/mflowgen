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

