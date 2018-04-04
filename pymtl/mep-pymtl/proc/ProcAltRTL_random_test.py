#=========================================================================
# ProcAltRTL_random_test.py
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
# mngr
#-------------------------------------------------------------------------

from test import inst_random

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_random.gen_random_asm_test  ),
])
def test_random( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

def test_random_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_random.gen_random_asm_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )
