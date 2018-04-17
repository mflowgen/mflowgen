#=========================================================================
# ProcCache_test.py
#=========================================================================

import pytest
import random

from pymtl     import *
from harnesses import asm_test

from proc_cache.ProcCache import ProcCache

def run_test( test, dump_vcd,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores = 1

  from harnesses import run_test as run

  run( ProcCache(), test, num_cores,
       dump_vcd, src_delay, sink_delay, mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# jal
#-------------------------------------------------------------------------

from proc.test import inst_jal

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal.gen_basic_test        ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jal.gen_link_dep_test     ) ,
  asm_test( inst_jal.gen_jump_test         ) ,
  asm_test( inst_jal.gen_back_to_back_test ) ,
  asm_test( inst_jal.gen_value_test_0      ) ,
  asm_test( inst_jal.gen_value_test_1      ) ,
  asm_test( inst_jal.gen_value_test_2      ) ,
  asm_test( inst_jal.gen_value_test_3      ) ,
  asm_test( inst_jal.gen_jal_stall_test    ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])

def test_jal( name, test, dump_vcd ):
  run_test( test, dump_vcd )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
def test_jal_rand_delays(dump_vcd):
  run_test( inst_jal.gen_jump_test, dump_vcd,
            src_delay=3, sink_delay=5, mem_stall_prob=.5, mem_latency=3 )
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# jalr
#-------------------------------------------------------------------------

from proc.test import inst_jalr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jalr.gen_basic_test    ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jalr.gen_link_dep_test ) ,
  asm_test( inst_jalr.gen_jump_test     ) ,
  asm_test( inst_jalr.gen_lsb_test      ) ,
  asm_test( inst_jalr.gen_value_test_0      ) ,
  asm_test( inst_jalr.gen_value_test_1      ) ,
  asm_test( inst_jalr.gen_value_test_2      ) ,
  asm_test( inst_jalr.gen_value_test_3      ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])

def test_jalr( name, test, dump_vcd ):
  run_test( test, dump_vcd )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_jalr_rand_delays(dump_vcd):
  run_test( inst_jalr.gen_jump_test, dump_vcd,
            src_delay=3, sink_delay=5, mem_stall_prob=.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
