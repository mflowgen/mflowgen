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
def test_lw( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

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
def test_sw( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

