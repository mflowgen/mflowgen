#=========================================================================
# ProcFL_mngr_test.py
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
# mngr
#-------------------------------------------------------------------------

from test import inst_mngr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mngr.gen_basic_test  ),
  asm_test( inst_mngr.gen_bypass_test ),
  asm_test( inst_mngr.gen_value_test  ),
  asm_test( inst_mngr.gen_random_test ),
])
def test_mngr( name, test, dump_vcd ):
  run_test( ProcFL, Xcel, test, dump_vcd )

