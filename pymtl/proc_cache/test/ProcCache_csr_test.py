#=========================================================================
# ProcCache_csr_test.py
#=========================================================================

import pytest
import random

from pymtl     import *
from harnesses import asm_test

from proc_cache.ProcCache import ProcCache

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores = 1

  from harnesses import run_test as run

  run( ProcCache(), test, num_cores,
       dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# csr
#-------------------------------------------------------------------------

from proc.test import inst_csr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_csr.gen_basic_test      ),
  asm_test( inst_csr.gen_bypass_test     ),
  asm_test( inst_csr.gen_value_test      ),
  asm_test( inst_csr.gen_random_test     ),
  asm_test( inst_csr.gen_core_stats_test ),
])
def test_csr( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_csr_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_csr.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3)
