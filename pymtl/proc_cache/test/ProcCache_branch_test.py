#=========================================================================
# ProcAltRTL_branch_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from harnesses import asm_test

from proc_cache.ProcCache import ProcCache

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores = 1

  from harnesses import run_test as run

  run( ProcCache(), test, num_cores,
       dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# beq
#-------------------------------------------------------------------------

from proc.test import inst_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_beq.gen_basic_test ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_beq.gen_src0_dep_taken_test    ) ,
  asm_test( inst_beq.gen_src0_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_src1_dep_taken_test    ) ,
  asm_test( inst_beq.gen_src1_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_srcs_dep_taken_test    ) ,
  asm_test( inst_beq.gen_srcs_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_src0_eq_src1_test      ) ,
  asm_test( inst_beq.gen_value_test             ) ,
  asm_test( inst_beq.gen_random_test            ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_beq( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_beq_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_beq.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

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

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bne_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bne.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# bge
#-------------------------------------------------------------------------

from proc.test import inst_bge

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bge.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bge.gen_src0_dep_taken_test    ),
  asm_test( inst_bge.gen_src0_dep_nottaken_test ),
  asm_test( inst_bge.gen_src1_dep_taken_test    ),
  asm_test( inst_bge.gen_src1_dep_nottaken_test ),
  asm_test( inst_bge.gen_srcs_dep_taken_test    ),
  asm_test( inst_bge.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bge.gen_src0_eq_src1_test      ),
  asm_test( inst_bge.gen_value_test             ),
  asm_test( inst_bge.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bge( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bge_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bge.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bgeu
#-------------------------------------------------------------------------

from proc.test import inst_bgeu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgeu.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bgeu.gen_src0_dep_taken_test    ),
  asm_test( inst_bgeu.gen_src0_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_src1_dep_taken_test    ),
  asm_test( inst_bgeu.gen_src1_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_srcs_dep_taken_test    ),
  asm_test( inst_bgeu.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_src0_eq_src1_test      ),
  asm_test( inst_bgeu.gen_value_test             ),
  asm_test( inst_bgeu.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bgeu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bgeu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bgeu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# blt
#-------------------------------------------------------------------------

from proc.test import inst_blt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_blt.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_blt.gen_src0_dep_taken_test    ),
  asm_test( inst_blt.gen_src0_dep_nottaken_test ),
  asm_test( inst_blt.gen_src1_dep_taken_test    ),
  asm_test( inst_blt.gen_src1_dep_nottaken_test ),
  asm_test( inst_blt.gen_srcs_dep_taken_test    ),
  asm_test( inst_blt.gen_srcs_dep_nottaken_test ),
  asm_test( inst_blt.gen_src0_eq_src1_test      ),
  asm_test( inst_blt.gen_value_test             ),
  asm_test( inst_blt.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_blt( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_blt_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_blt.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bltu
#-------------------------------------------------------------------------

from proc.test import inst_bltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bltu.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bltu.gen_src0_dep_taken_test    ),
  asm_test( inst_bltu.gen_src0_dep_nottaken_test ),
  asm_test( inst_bltu.gen_src1_dep_taken_test    ),
  asm_test( inst_bltu.gen_src1_dep_nottaken_test ),
  asm_test( inst_bltu.gen_srcs_dep_taken_test    ),
  asm_test( inst_bltu.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bltu.gen_src0_eq_src1_test      ),
  asm_test( inst_bltu.gen_value_test             ),
  asm_test( inst_bltu.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bltu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bltu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bltu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
