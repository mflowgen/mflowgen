#=========================================================================
# ProcFL_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl        import *
from test.harness import *
from ProcFL       import ProcFL
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

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_j( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

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
def test_jal( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

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
def test_jr( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

