#=========================================================================
# ProcAltRTL_mngr_test.py
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

from test import inst_mngr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mngr.gen_basic_test  ),
  asm_test( inst_mngr.gen_bypass_test ),
  asm_test( inst_mngr.gen_value_test  ),
  asm_test( inst_mngr.gen_random_test ),
])
def test_mngr( name, test, dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, test, dump_vcd, test_verilog )

def test_mngr_rand_delays( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, inst_mngr.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3 )

def gen_stats_en_test():
  return """
    nop
    nop
    addiu r2, r0, 1
    mtc0  r2, statsen
    nop
    nop
    mtc0  r0, statsen
    mtc0  r0, proc2mngr > 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

def test_stats_en( dump_vcd, test_verilog ):
  run_test( ProcAltRTL, Xcel, gen_stats_en_test, dump_vcd, test_verilog )
