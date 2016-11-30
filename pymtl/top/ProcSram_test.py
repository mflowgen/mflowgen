#=========================================================================
# ProcSram_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl             import *

# Import from proc

from proc.test.harness import asm_test

# Import from this directory

from harness           import *
from ProcSram          import ProcSram

#-------------------------------------------------------------------------
# Design
#-------------------------------------------------------------------------

def instantiate_dut():
  dut = ProcSram()
  return dut

#-------------------------------------------------------------------------
# rr test cases
#-------------------------------------------------------------------------

from proc.test import inst_addiu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addiu.gen_basic_test     ),
  asm_test( inst_addiu.gen_dest_byp_test  ),
  asm_test( inst_addiu.gen_src_byp_test   ),
  asm_test( inst_addiu.gen_srcs_dest_test ),
  asm_test( inst_addiu.gen_value_test     ),
  asm_test( inst_addiu.gen_random_test    ),

])
def test_addiu( name, test, dump_vcd, test_verilog ):
  dut = instantiate_dut()
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 5000 )

#-------------------------------------------------------------------------
# mem test cases
#-------------------------------------------------------------------------

from proc.test import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ),
  asm_test( inst_lw.gen_dest_byp_test  ),
  asm_test( inst_lw.gen_base_byp_test   ),
  asm_test( inst_lw.gen_srcs_dest_test ),
  asm_test( inst_lw.gen_value_test     ),
  asm_test( inst_lw.gen_random_test    ),
])
def test_lw( name, test, dump_vcd, test_verilog ):
  dut = instantiate_dut()
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 5000 )

from proc.test import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_basic_test     ),
  asm_test( inst_sw.gen_dest_byp_test  ),
  asm_test( inst_sw.gen_base_byp_test  ),
  asm_test( inst_sw.gen_src_byp_test   ),
  asm_test( inst_sw.gen_srcs_byp_test  ),
  asm_test( inst_sw.gen_srcs_dest_test ),
  asm_test( inst_sw.gen_value_test     ),
  asm_test( inst_sw.gen_random_test    ),
])
def test_sw( name, test, dump_vcd, test_verilog ):
  dut = instantiate_dut()
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 5000 )

from proc.test import inst_xcel

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xcel.gen_basic_sort_test  ),
  asm_test( inst_xcel.gen_random_sort_test ),
])
def test_xcel( name, test, dump_vcd, test_verilog ):
  dut = instantiate_dut()
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 10000 )
