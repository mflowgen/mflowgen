#=========================================================================
# ProcAltRTL_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl        import *
from test.harness import *
from ProcAltRTL   import ProcAltRTL
from Xcel     import Xcel

#-------------------------------------------------------------------------
# j
#-------------------------------------------------------------------------

from test import inst_j

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_j.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_j.gen_jump_test              ),
  asm_test( inst_j.gen_back_to_back_test      ),
  asm_test( inst_j.gen_j_after_branch_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_j( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_j_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_j.gen_jump_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# jal
#-------------------------------------------------------------------------

from test import inst_jal

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal.gen_basic_test    ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jal.gen_link_byp_test ),
  asm_test( inst_jal.gen_jump_test     ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_jal( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_jal_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_jal.gen_jump_test, dump_vcd,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# jr
#-------------------------------------------------------------------------

from test import inst_jr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jr.gen_basic_test   ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jr.gen_src_byp_test ),
  asm_test( inst_jr.gen_jump_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_jr( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_jr_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_jr.gen_jump_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

