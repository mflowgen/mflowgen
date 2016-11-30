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
# addiu
#-------------------------------------------------------------------------

from test import inst_addiu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addiu.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_addiu.gen_dest_byp_test  ),
  asm_test( inst_addiu.gen_src_byp_test   ),
  asm_test( inst_addiu.gen_srcs_dest_test ),
  asm_test( inst_addiu.gen_value_test     ),
  asm_test( inst_addiu.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_addiu( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_addiu_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_addiu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# andi
#-------------------------------------------------------------------------

from test import inst_andi

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_andi.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_andi.gen_dest_byp_test  ),
  asm_test( inst_andi.gen_src_byp_test   ),
  asm_test( inst_andi.gen_srcs_dest_test ),
  asm_test( inst_andi.gen_value_test     ),
  asm_test( inst_andi.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

])
def test_andi( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_andi_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_andi.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# lui
#-------------------------------------------------------------------------

from test import inst_lui

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lui.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_lui.gen_dest_byp_test  ),
  asm_test( inst_lui.gen_value_test     ),
  asm_test( inst_lui.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_lui( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_lui_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_lui.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# ori
#-------------------------------------------------------------------------

from test import inst_ori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_ori.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_ori.gen_dest_byp_test  ),
  asm_test( inst_ori.gen_src_byp_test   ),
  asm_test( inst_ori.gen_srcs_dest_test ),
  asm_test( inst_ori.gen_value_test     ),
  asm_test( inst_ori.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_ori( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_ori_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_ori.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sll
#-------------------------------------------------------------------------

from test import inst_sll

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sll.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sll.gen_dest_byp_test  ),
  asm_test( inst_sll.gen_src_byp_test   ),
  asm_test( inst_sll.gen_srcs_dest_test ),
  asm_test( inst_sll.gen_value_test     ),
  asm_test( inst_sll.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sll( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sll_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sll.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# slti
#-------------------------------------------------------------------------

from test import inst_slti

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slti.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slti.gen_dest_byp_test  ),
  asm_test( inst_slti.gen_src_byp_test   ),
  asm_test( inst_slti.gen_srcs_dest_test ),
  asm_test( inst_slti.gen_value_test     ),
  asm_test( inst_slti.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slti( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slti_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_slti.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sltiu
#-------------------------------------------------------------------------

from test import inst_sltiu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltiu.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sltiu.gen_dest_byp_test  ),
  asm_test( inst_sltiu.gen_src_byp_test   ),
  asm_test( inst_sltiu.gen_srcs_dest_test ),
  asm_test( inst_sltiu.gen_value_test     ),
  asm_test( inst_sltiu.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sltiu( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sltiu_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sltiu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sra
#-------------------------------------------------------------------------

from test import inst_sra

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sra.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sra.gen_dest_byp_test  ),
  asm_test( inst_sra.gen_src_byp_test   ),
  asm_test( inst_sra.gen_srcs_dest_test ),
  asm_test( inst_sra.gen_value_test     ),
  asm_test( inst_sra.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sra( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sra_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_sra.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# srl
#-------------------------------------------------------------------------

from test import inst_srl

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srl.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srl.gen_dest_byp_test  ),
  asm_test( inst_srl.gen_src_byp_test   ),
  asm_test( inst_srl.gen_srcs_dest_test ),
  asm_test( inst_srl.gen_value_test     ),
  asm_test( inst_srl.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srl( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srl_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_srl.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# xori
#-------------------------------------------------------------------------

from test import inst_xori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xori.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_xori.gen_dest_byp_test  ),
  asm_test( inst_xori.gen_src_byp_test   ),
  asm_test( inst_xori.gen_srcs_dest_test ),
  asm_test( inst_xori.gen_value_test     ),
  asm_test( inst_xori.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_xori( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add random delay tests.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_xori_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_xori.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

