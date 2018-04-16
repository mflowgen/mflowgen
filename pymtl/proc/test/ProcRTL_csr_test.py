#=========================================================================
# ProcRTL_csr_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from harness import *
from proc.ProcRTL import ProcRTL

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
def test_csr( name, test, dump_vcd, test_verilog ):
  run_test( ProcRTL, test, dump_vcd, test_verilog )

def test_csr_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcRTL, inst_csr.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3)

