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
# lw
#-------------------------------------------------------------------------

from test import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ),
  asm_test( inst_lw.gen_dest_byp_test  ),
  asm_test( inst_lw.gen_base_byp_test   ),
  asm_test( inst_lw.gen_srcs_dest_test ),
  asm_test( inst_lw.gen_value_test     ),
  asm_test( inst_lw.gen_random_test    ),
])
def test_lw( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

def test_lw_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_lw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sw
#-------------------------------------------------------------------------

from test import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sw.gen_dest_byp_test  ),
  asm_test( inst_sw.gen_base_byp_test  ),
  asm_test( inst_sw.gen_src_byp_test   ),
  asm_test( inst_sw.gen_srcs_byp_test  ),
  asm_test( inst_sw.gen_srcs_dest_test ),
  asm_test( inst_sw.gen_value_test     ),
  asm_test( inst_sw.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sw( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sw_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
