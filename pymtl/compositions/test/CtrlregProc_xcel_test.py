#=========================================================================
# ProcAltRTL_xcel_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl         import *
from CtrlregProc_harness import *
from compositions.CtrlregProc import CtrlregProc

#-------------------------------------------------------------------------
# xcel
#-------------------------------------------------------------------------

from proc.test import inst_xcel

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xcel.gen_basic_test  ),
  asm_test( inst_xcel.gen_bypass_test ),
  asm_test( inst_xcel.gen_random_test ),
])
def test_xcel( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_xcel_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_xcel.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

