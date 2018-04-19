#=========================================================================
# MultiCoreRTL_test.py
#=========================================================================
# In this test we pick representative instruction from each instrucion
# categories
#
# rr:     add, mul
# rimm:   andi
# branch: bne
# csr:    all with multi-core-id test
# jump:   jal
# mem:    lw, sw (multi-core version)

import pytest
import random

from pymtl     import *
from harnesses import asm_test

from proc_cache.CompMcoreArbiterCache import CompMcoreArbiterCache

# 4 core, with 2 memory ports, each with 16B data bitwidth

def run_test( test, dump_vcd,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores = 4

  from harnesses import run_test as run

  run( CompMcoreArbiterCache( num_cores ), test, num_cores,
       dump_vcd, src_delay, sink_delay, mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# add
#-------------------------------------------------------------------------

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
def test_add( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_add_rand_delays( dump_vcd ):
  run_test( inst_add.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# mul
#-------------------------------------------------------------------------

import inst_mul

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul.gen_basic_test     ) ,
  asm_test( inst_mul.gen_dest_dep_test  ) ,
  asm_test( inst_mul.gen_src0_dep_test  ) ,
  asm_test( inst_mul.gen_src1_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dest_test ) ,
  asm_test( inst_mul.gen_value_test     ) ,
  asm_test( inst_mul.gen_random_test    ) ,
])
def test_mul( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_mul_rand_delays( dump_vcd ):
  run_test( inst_mul.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# andi
#-------------------------------------------------------------------------

from proc.test import inst_andi

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_andi.gen_basic_test     ) ,
  asm_test( inst_andi.gen_dest_dep_test  ) ,
  asm_test( inst_andi.gen_src_dep_test   ) ,
  asm_test( inst_andi.gen_srcs_dest_test ) ,
  asm_test( inst_andi.gen_value_test     ) ,
  asm_test( inst_andi.gen_random_test    ) ,
])
def test_andi( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_andi_rand_delays( dump_vcd ):
  run_test( inst_andi.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# bne
#-------------------------------------------------------------------------

from proc.test import inst_bne

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bne.gen_basic_test             ),
  asm_test( inst_bne.gen_src0_dep_taken_test    ),
  asm_test( inst_bne.gen_src0_dep_nottaken_test ),
  asm_test( inst_bne.gen_src1_dep_taken_test    ),
  asm_test( inst_bne.gen_src1_dep_nottaken_test ),
  asm_test( inst_bne.gen_srcs_dep_taken_test    ),
  asm_test( inst_bne.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bne.gen_src0_eq_src1_test      ),
  asm_test( inst_bne.gen_value_test             ),
  asm_test( inst_bne.gen_random_test            ),
])
def test_bne( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_bne_rand_delays( dump_vcd ):
  run_test( inst_bne.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3)

#-------------------------------------------------------------------------
# csr
#-------------------------------------------------------------------------

import inst_csr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_csr.gen_basic_test     ),
  asm_test( inst_csr.gen_bypass_test    ),
  asm_test( inst_csr.gen_value_test     ),
  asm_test( inst_csr.gen_random_test    ),
  asm_test( inst_csr.gen_multicore_test )
])
def test_csr( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_csr_rand_delays( dump_vcd ):
  run_test( inst_csr.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=10,
            mem_stall_prob=0.5, mem_latency=3)

#-------------------------------------------------------------------------
# jal
#-------------------------------------------------------------------------

import inst_jal

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal.gen_basic_test        ) ,
  asm_test( inst_jal.gen_link_dep_test     ) ,
  asm_test( inst_jal.gen_jump_test         ) ,
  asm_test( inst_jal.gen_back_to_back_test ) ,
  asm_test( inst_jal.gen_value_test_0      ) ,
  asm_test( inst_jal.gen_value_test_1      ) ,
  asm_test( inst_jal.gen_value_test_2      ) ,
  asm_test( inst_jal.gen_value_test_3      ) ,
  asm_test( inst_jal.gen_jal_stall_test    ) ,
])

def test_jal( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_jal_rand_delays(dump_vcd):
  run_test( inst_jal.gen_jump_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=.5, mem_latency=3 )

#-------------------------------------------------------------------------
# lw
#-------------------------------------------------------------------------

from proc.test import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ) ,
  asm_test( inst_lw.gen_dest_dep_test  ) ,
  asm_test( inst_lw.gen_base_dep_test  ) ,
  asm_test( inst_lw.gen_srcs_dest_test ) ,
  asm_test( inst_lw.gen_value_test     ) ,
  asm_test( inst_lw.gen_random_test    ) ,
])
def test_lw( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_lw_rand_delays( dump_vcd ):
  run_test( inst_lw.gen_random_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sw
#-------------------------------------------------------------------------

import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_sameline_deps_test ),
  asm_test( inst_sw.gen_twoline_deps_test  ),
  asm_test( inst_sw.gen_diffline_deps_test ),
])
def test_sw( name, test, dump_vcd ):
  run_test( test, dump_vcd )

def test_sw_rand_delays( dump_vcd ):
  run_test( inst_sw.gen_diffline_deps_test, dump_vcd,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3 )

