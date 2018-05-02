#=========================================================================
# HostCompCtrlregMcoreL0ArbiterMduCache_test
#=========================================================================

import pytest

from pymtl                   import *
from pclib.test              import run_sim
from fpga                    import SwShim

from compositions.CompCtrlregMcoreL0ArbiterMduCache     import CompCtrlregMcoreL0ArbiterMduCache
from compositions.HostCompCtrlregMcoreL0ArbiterMduCache import HostCompCtrlregMcoreL0ArbiterMduCache

# Reuse tests from non-host version

from compositions.test.harnesses import asm_test

from compositions.test.CompCtrlregMcoreL0ArbiterMduCache_harness import TestHarness
from compositions.test.CompCtrlregMcoreL0ArbiterMduCache_harness import run_test as run

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  asynch_bitwidth = 8

  dut             = CompCtrlregMcoreL0ArbiterMduCache()
  hwshim_and_dut  = HostCompCtrlregMcoreL0ArbiterMduCache( asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth )

  num_cores       = 4
  cacheline_nbits = 128

  run( swshim, test, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay,
       mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# add
#-------------------------------------------------------------------------

from proc.test import inst_add

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_add.gen_basic_test     ) ,
  asm_test( inst_add.gen_dest_dep_test  ) ,
  asm_test( inst_add.gen_src0_dep_test  ) ,
  asm_test( inst_add.gen_src1_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dest_test ) ,
  asm_test( inst_add.gen_value_test     ) ,
  asm_test( inst_add.gen_random_test    ) ,
])
def test_add( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_add_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_add.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5,
            mem_stall_prob=0.5, mem_latency=3 )

