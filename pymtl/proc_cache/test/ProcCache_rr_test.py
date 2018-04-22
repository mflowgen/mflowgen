#=========================================================================
# ProcCache_rr_test.py
#=========================================================================

import pytest
import random

from pymtl     import *
from harnesses import asm_test

from proc_cache.ProcCache import ProcCache

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores = 1

  from harnesses import run_test as run

  run( ProcCache(), test, num_cores,
       dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob, mem_latency )

from proc.test import inst_add

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_add.gen_basic_test     ) ,
  asm_test( inst_add.gen_dest_dep_test  ) ,
  asm_test( inst_add.gen_src0_dep_test  ) ,
  asm_test( inst_add.gen_src1_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dest_test ) ,
  asm_test( inst_add.gen_value_test     ) ,
  asm_test( inst_add.gen_random_test    ) ,
])
def test_add( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_add_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_add.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sub
#-------------------------------------------------------------------------

from proc.test import inst_sub

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sub.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sub.gen_dest_dep_test  ) ,
  asm_test( inst_sub.gen_src0_dep_test  ) ,
  asm_test( inst_sub.gen_src1_dep_test  ) ,
  asm_test( inst_sub.gen_srcs_dep_test  ) ,
  asm_test( inst_sub.gen_srcs_dest_test ) ,
  asm_test( inst_sub.gen_value_test     ) ,
  asm_test( inst_sub.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sub( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sub_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sub.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# mul
#-------------------------------------------------------------------------

from proc.test import inst_mul

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_mul.gen_dest_dep_test  ) ,
  asm_test( inst_mul.gen_src0_dep_test  ) ,
  asm_test( inst_mul.gen_src1_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dest_test ) ,
  asm_test( inst_mul.gen_value_test     ) ,
  asm_test( inst_mul.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_mul( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_mul_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mul.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# mulh
#-------------------------------------------------------------------------

from proc.test import inst_mulh

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulh.gen_basic_test     ) ,
  asm_test( inst_mulh.gen_value_test     ) ,
  asm_test( inst_mulh.gen_random_test    ) ,
])
def test_mulh( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulh_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulh.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# mulhsu
#-------------------------------------------------------------------------

from proc.test import inst_mulhsu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulhsu.gen_basic_test     ) ,
  asm_test( inst_mulhsu.gen_value_test     ) ,
  asm_test( inst_mulhsu.gen_random_test    ) ,
])
def test_mulhsu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulhsu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulhsu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# mulhu
#-------------------------------------------------------------------------

from proc.test import inst_mulhu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulhu.gen_basic_test     ) ,
  asm_test( inst_mulhu.gen_value_test     ) ,
  asm_test( inst_mulhu.gen_random_test    ) ,
])
def test_mulhu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulhu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulhu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# div
#-------------------------------------------------------------------------

from proc.test import inst_div

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_div.gen_basic_test     ) ,
  asm_test( inst_div.gen_value_test     ) ,
  asm_test( inst_div.gen_random_test    ) ,
])
def test_div( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_div_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_div.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# divu
#-------------------------------------------------------------------------

from proc.test import inst_divu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_divu.gen_basic_test     ) ,
  asm_test( inst_divu.gen_value_test     ) ,
  asm_test( inst_divu.gen_random_test    ) ,
])
def test_divu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_divu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_divu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# rem
#-------------------------------------------------------------------------

from proc.test import inst_rem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_rem.gen_basic_test     ) ,
  asm_test( inst_rem.gen_value_test     ) ,
  asm_test( inst_rem.gen_random_test    ) ,
])
def test_rem( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_rem_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_rem.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# remu
#-------------------------------------------------------------------------

from proc.test import inst_remu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_remu.gen_basic_test     ) ,
  asm_test( inst_remu.gen_value_test     ) ,
  asm_test( inst_remu.gen_random_test    ) ,
])
def test_remu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_remu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_remu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# and
#-------------------------------------------------------------------------

from proc.test import inst_and

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_and.gen_basic_test     ) ,
  asm_test( inst_and.gen_dest_dep_test  ) ,
  asm_test( inst_and.gen_src0_dep_test  ) ,
  asm_test( inst_and.gen_src1_dep_test  ) ,
  asm_test( inst_and.gen_srcs_dep_test  ) ,
  asm_test( inst_and.gen_srcs_dest_test ) ,
  asm_test( inst_and.gen_value_test     ) ,
  asm_test( inst_and.gen_random_test    ) ,
])
def test_and( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_and_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_and.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# or
#-------------------------------------------------------------------------

from proc.test import inst_or

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_or.gen_basic_test     ) ,
  asm_test( inst_or.gen_dest_dep_test  ) ,
  asm_test( inst_or.gen_src0_dep_test  ) ,
  asm_test( inst_or.gen_src1_dep_test  ) ,
  asm_test( inst_or.gen_srcs_dep_test  ) ,
  asm_test( inst_or.gen_srcs_dest_test ) ,
  asm_test( inst_or.gen_value_test     ) ,
  asm_test( inst_or.gen_random_test    ) ,
])
def test_or( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_or_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_or.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# xor
#-------------------------------------------------------------------------

from proc.test import inst_xor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xor.gen_basic_test     ) ,
  asm_test( inst_xor.gen_dest_dep_test  ) ,
  asm_test( inst_xor.gen_src0_dep_test  ) ,
  asm_test( inst_xor.gen_src1_dep_test  ) ,
  asm_test( inst_xor.gen_srcs_dep_test  ) ,
  asm_test( inst_xor.gen_srcs_dest_test ) ,
  asm_test( inst_xor.gen_value_test     ) ,
  asm_test( inst_xor.gen_random_test    ) ,
])
def test_xor( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_xor_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_xor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# slt
#-------------------------------------------------------------------------

from proc.test import inst_slt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slt.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slt.gen_dest_dep_test  ) ,
  asm_test( inst_slt.gen_src0_dep_test  ) ,
  asm_test( inst_slt.gen_src1_dep_test  ) ,
  asm_test( inst_slt.gen_srcs_dep_test  ) ,
  asm_test( inst_slt.gen_srcs_dest_test ) ,
  asm_test( inst_slt.gen_value_test     ) ,
  asm_test( inst_slt.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slt( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slt_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_slt.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sltu
#-------------------------------------------------------------------------

from proc.test import inst_sltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltu.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sltu.gen_dest_dep_test  ) ,
  asm_test( inst_sltu.gen_src0_dep_test  ) ,
  asm_test( inst_sltu.gen_src1_dep_test  ) ,
  asm_test( inst_sltu.gen_srcs_dep_test  ) ,
  asm_test( inst_sltu.gen_srcs_dest_test ) ,
  asm_test( inst_sltu.gen_value_test     ) ,
  asm_test( inst_sltu.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sltu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sltu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sltu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sra
#-------------------------------------------------------------------------

from proc.test import inst_sra

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sra.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sra.gen_dest_dep_test  ) ,
  asm_test( inst_sra.gen_src0_dep_test  ) ,
  asm_test( inst_sra.gen_src1_dep_test  ) ,
  asm_test( inst_sra.gen_srcs_dep_test  ) ,
  asm_test( inst_sra.gen_srcs_dest_test ) ,
  asm_test( inst_sra.gen_value_test     ) ,
  asm_test( inst_sra.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sra( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sra_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sra.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# srl
#-------------------------------------------------------------------------

from proc.test import inst_srl

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srl.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srl.gen_dest_dep_test  ) ,
  asm_test( inst_srl.gen_src0_dep_test  ) ,
  asm_test( inst_srl.gen_src1_dep_test  ) ,
  asm_test( inst_srl.gen_srcs_dep_test  ) ,
  asm_test( inst_srl.gen_srcs_dest_test ) ,
  asm_test( inst_srl.gen_value_test     ) ,
  asm_test( inst_srl.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srl( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srl_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_srl.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sll
#-------------------------------------------------------------------------

from proc.test import inst_sll

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sll.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sll.gen_dest_dep_test  ) ,
  asm_test( inst_sll.gen_src0_dep_test  ) ,
  asm_test( inst_sll.gen_src1_dep_test  ) ,
  asm_test( inst_sll.gen_srcs_dep_test  ) ,
  asm_test( inst_sll.gen_srcs_dest_test ) ,
  asm_test( inst_sll.gen_value_test     ) ,
  asm_test( inst_sll.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sll( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sll_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sll.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

