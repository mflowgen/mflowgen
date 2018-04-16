#=========================================================================
# ProcFL_xcel_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl         import *
from harness       import *
from proc.ProcFL   import ProcFL

#-------------------------------------------------------------------------
# xcel
#-------------------------------------------------------------------------

import inst_xcel

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xcel.gen_basic_test  ),
  asm_test( inst_xcel.gen_bypass_test ),
  asm_test( inst_xcel.gen_random_test ),
])
def test_xcel( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )

