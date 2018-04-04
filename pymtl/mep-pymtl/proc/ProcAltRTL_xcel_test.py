#=========================================================================
# ProcAltRTL_xcel_test.py
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
# xcel
#-------------------------------------------------------------------------

from test import inst_xcel

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xcel.gen_basic_sort_test  ),
  asm_test( inst_xcel.gen_random_sort_test ),
])
def test_xcel( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

from test import inst_mngr

def test_mngr_xcel_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_mngr.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

