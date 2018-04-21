#=========================================================================
# ProcFL_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from harness import *
from proc.ProcFL import ProcFL

#-------------------------------------------------------------------------
# lw
#-------------------------------------------------------------------------

import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ) ,
  asm_test( inst_lw.gen_dest_dep_test  ) ,
  asm_test( inst_lw.gen_base_dep_test  ) ,
  asm_test( inst_lw.gen_srcs_dest_test ) ,
  asm_test( inst_lw.gen_value_test     ) ,
  asm_test( inst_lw.gen_random_test    ) ,
])
def test_lw( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )

#-------------------------------------------------------------------------
# sw
#-------------------------------------------------------------------------

import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sw.gen_dest_dep_test  ),
  asm_test( inst_sw.gen_base_dep_test  ),
  asm_test( inst_sw.gen_src_dep_test   ),
  asm_test( inst_sw.gen_srcs_dep_test  ),
  asm_test( inst_sw.gen_srcs_dest_test ),
  asm_test( inst_sw.gen_value_test     ),
  asm_test( inst_sw.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sw( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )

#-------------------------------------------------------------------------
# AMOs
#-------------------------------------------------------------------------

import inst_amoadd

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoadd.gen_basic_test     ),
  asm_test( inst_amoadd.gen_value_test     ),
  asm_test( inst_amoadd.gen_random_test    ),
])
def test_amoadd( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )

