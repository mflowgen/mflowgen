#=========================================================================
# ProcFL_csr_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from harness import *
from proc.ProcFL import ProcFL

#-------------------------------------------------------------------------
# csr
#-------------------------------------------------------------------------

import inst_csr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_csr.gen_basic_test      ),
  asm_test( inst_csr.gen_bypass_test     ),
  asm_test( inst_csr.gen_value_test      ),
  asm_test( inst_csr.gen_random_test     ),
  asm_test( inst_csr.gen_core_stats_test ),
])
def test_csr( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )
