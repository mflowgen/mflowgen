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
from Xcel         import Xcel

#-------------------------------------------------------------------------
# beq
#-------------------------------------------------------------------------

from test import inst_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_beq.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_beq.gen_src0_byp_taken_test    ),
  asm_test( inst_beq.gen_src0_byp_nottaken_test ),
  asm_test( inst_beq.gen_src1_byp_taken_test    ),
  asm_test( inst_beq.gen_src1_byp_nottaken_test ),
  asm_test( inst_beq.gen_srcs_byp_taken_test    ),
  asm_test( inst_beq.gen_srcs_byp_nottaken_test ),
  asm_test( inst_beq.gen_src0_eq_src1_test      ),
  asm_test( inst_beq.gen_value_test             ),
  asm_test( inst_beq.gen_random_test            ),
  asm_test( inst_beq.gen_back_to_back_test      ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_beq( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_beq_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_beq.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bgez
#-------------------------------------------------------------------------

from test import inst_bgez

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgez.gen_basic_test            ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bgez.gen_src_byp_taken_test    ),
  asm_test( inst_bgez.gen_src_byp_nottaken_test ),
  asm_test( inst_bgez.gen_value_test            ),
  asm_test( inst_bgez.gen_random_test           ),
  asm_test( inst_bgez.gen_back_to_back_test     ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bgez( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bgez_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_bgez.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bgtz
#-------------------------------------------------------------------------

from test import inst_bgtz

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgtz.gen_basic_test            ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bgtz.gen_src_byp_taken_test    ),
  asm_test( inst_bgtz.gen_src_byp_nottaken_test ),
  asm_test( inst_bgtz.gen_value_test            ),
  asm_test( inst_bgtz.gen_random_test           ),
  asm_test( inst_bgtz.gen_back_to_back_test     ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bgtz( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog  )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bgtz_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_bgtz.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# blez
#-------------------------------------------------------------------------

from test import inst_blez

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_blez.gen_basic_test            ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_blez.gen_src_byp_taken_test    ),
  asm_test( inst_blez.gen_src_byp_nottaken_test ),
  asm_test( inst_blez.gen_value_test            ),
  asm_test( inst_blez.gen_random_test           ),
  asm_test( inst_blez.gen_back_to_back_test     ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_blez( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_blez_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_blez.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bltz
#-------------------------------------------------------------------------

from test import inst_bltz

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bltz.gen_basic_test            ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bltz.gen_src_byp_taken_test    ),
  asm_test( inst_bltz.gen_src_byp_nottaken_test ),
  asm_test( inst_bltz.gen_value_test            ),
  asm_test( inst_bltz.gen_random_test           ),
  asm_test( inst_bltz.gen_back_to_back_test     ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bltz( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bltz_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_bltz.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bne
#-------------------------------------------------------------------------

from test import inst_bne

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bne.gen_basic_test             ),
  asm_test( inst_bne.gen_src0_byp_taken_test    ),
  asm_test( inst_bne.gen_src0_byp_nottaken_test ),
  asm_test( inst_bne.gen_src1_byp_taken_test    ),
  asm_test( inst_bne.gen_src1_byp_nottaken_test ),
  asm_test( inst_bne.gen_srcs_byp_taken_test    ),
  asm_test( inst_bne.gen_srcs_byp_nottaken_test ),
  asm_test( inst_bne.gen_src0_eq_src1_test      ),
  asm_test( inst_bne.gen_value_test             ),
  asm_test( inst_bne.gen_random_test            ),
  asm_test( inst_bne.gen_back_to_back_test      ),
])
def test_bne( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

def test_bne_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_bne.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

