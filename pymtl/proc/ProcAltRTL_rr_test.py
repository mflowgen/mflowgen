#=========================================================================
# ProcAltRTL_rr_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl        import *
from test.harness import *
from ProcAltRTL   import ProcAltRTL
from Xcel         import Xcel

#-------------------------------------------------------------------------
# addu
#-------------------------------------------------------------------------

from test import inst_addu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addu.gen_basic_test     ),
  asm_test( inst_addu.gen_dest_byp_test  ),
  asm_test( inst_addu.gen_src0_byp_test  ),
  asm_test( inst_addu.gen_src1_byp_test  ),
  asm_test( inst_addu.gen_srcs_byp_test  ),
  asm_test( inst_addu.gen_srcs_dest_test ),
  asm_test( inst_addu.gen_value_test     ),
  asm_test( inst_addu.gen_random_test    ),
])
def test_addu( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

def test_addu_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_addu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# and
#-------------------------------------------------------------------------

from test import inst_and

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_and.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_and.gen_dest_byp_test  ),
  asm_test( inst_and.gen_src0_byp_test  ),
  asm_test( inst_and.gen_src1_byp_test  ),
  asm_test( inst_and.gen_srcs_byp_test  ),
  asm_test( inst_and.gen_srcs_dest_test ),
  asm_test( inst_and.gen_value_test     ),
  asm_test( inst_and.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_and( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_and_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_and.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# nor
#-------------------------------------------------------------------------

from test import inst_nor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_nor.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_nor.gen_dest_byp_test  ),
  asm_test( inst_nor.gen_src0_byp_test  ),
  asm_test( inst_nor.gen_src1_byp_test  ),
  asm_test( inst_nor.gen_srcs_byp_test  ),
  asm_test( inst_nor.gen_srcs_dest_test ),
  asm_test( inst_nor.gen_value_test     ),
  asm_test( inst_nor.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_nor( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )


# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_nor_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_nor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# or
#-------------------------------------------------------------------------

from test import inst_or

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_or.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_or.gen_dest_byp_test  ),
  asm_test( inst_or.gen_src0_byp_test  ),
  asm_test( inst_or.gen_src1_byp_test  ),
  asm_test( inst_or.gen_srcs_byp_test  ),
  asm_test( inst_or.gen_srcs_dest_test ),
  asm_test( inst_or.gen_value_test     ),
  asm_test( inst_or.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_or( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_or_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_or.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sllv
#-------------------------------------------------------------------------

from test import inst_sllv

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sllv.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sllv.gen_dest_byp_test  ),
  asm_test( inst_sllv.gen_src0_byp_test  ),
  asm_test( inst_sllv.gen_src1_byp_test  ),
  asm_test( inst_sllv.gen_srcs_byp_test  ),
  asm_test( inst_sllv.gen_srcs_dest_test ),
  asm_test( inst_sllv.gen_value_test     ),
  asm_test( inst_sllv.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sllv( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sllv_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sllv.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# slt
#-------------------------------------------------------------------------

from test import inst_slt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slt.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slt.gen_dest_byp_test  ),
  asm_test( inst_slt.gen_src0_byp_test  ),
  asm_test( inst_slt.gen_src1_byp_test  ),
  asm_test( inst_slt.gen_srcs_byp_test  ),
  asm_test( inst_slt.gen_srcs_dest_test ),
  asm_test( inst_slt.gen_value_test     ),
  asm_test( inst_slt.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slt( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slt_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_slt.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sltu
#-------------------------------------------------------------------------

from test import inst_sltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltu.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sltu.gen_dest_byp_test  ),
  asm_test( inst_sltu.gen_src0_byp_test  ),
  asm_test( inst_sltu.gen_src1_byp_test  ),
  asm_test( inst_sltu.gen_srcs_byp_test  ),
  asm_test( inst_sltu.gen_srcs_dest_test ),
  asm_test( inst_sltu.gen_value_test     ),
  asm_test( inst_sltu.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sltu( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sltu_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sltu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# srav
#-------------------------------------------------------------------------

from test import inst_srav

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srav.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srav.gen_dest_byp_test  ),
  asm_test( inst_srav.gen_src0_byp_test  ),
  asm_test( inst_srav.gen_src1_byp_test  ),
  asm_test( inst_srav.gen_srcs_byp_test  ),
  asm_test( inst_srav.gen_srcs_dest_test ),
  asm_test( inst_srav.gen_value_test     ),
  asm_test( inst_srav.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srav( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srav_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_srav.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# srlv
#-------------------------------------------------------------------------

from test import inst_srlv

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srlv.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srlv.gen_dest_byp_test  ),
  asm_test( inst_srlv.gen_src0_byp_test  ),
  asm_test( inst_srlv.gen_src1_byp_test  ),
  asm_test( inst_srlv.gen_srcs_byp_test  ),
  asm_test( inst_srlv.gen_srcs_dest_test ),
  asm_test( inst_srlv.gen_value_test     ),
  asm_test( inst_srlv.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srlv( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srlv_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_srlv.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# subu
#-------------------------------------------------------------------------

from test import inst_subu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_subu.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_subu.gen_dest_byp_test  ),
  asm_test( inst_subu.gen_src0_byp_test  ),
  asm_test( inst_subu.gen_src1_byp_test  ),
  asm_test( inst_subu.gen_srcs_byp_test  ),
  asm_test( inst_subu.gen_srcs_dest_test ),
  asm_test( inst_subu.gen_value_test     ),
  asm_test( inst_subu.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_subu( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_subu_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_subu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# xor
#-------------------------------------------------------------------------

from test import inst_xor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xor.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_xor.gen_dest_byp_test  ),
  asm_test( inst_xor.gen_src0_byp_test  ),
  asm_test( inst_xor.gen_src1_byp_test  ),
  asm_test( inst_xor.gen_srcs_byp_test  ),
  asm_test( inst_xor.gen_srcs_dest_test ),
  asm_test( inst_xor.gen_value_test     ),
  asm_test( inst_xor.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_xor( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_xor_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_xor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# mul
#-------------------------------------------------------------------------

from test import inst_mul

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_mul.gen_dest_byp_test  ),
  asm_test( inst_mul.gen_src0_byp_test  ),
  asm_test( inst_mul.gen_src1_byp_test  ),
  asm_test( inst_mul.gen_srcs_byp_test  ),
  asm_test( inst_mul.gen_srcs_dest_test ),
  asm_test( inst_mul.gen_value_test     ),
  asm_test( inst_mul.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_mul( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_mul_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_mul.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

