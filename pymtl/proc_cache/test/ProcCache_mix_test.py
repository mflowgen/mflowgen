#=========================================================================
# ProcAltRTL_mix_test.py
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
# jal_beq
#-------------------------------------------------------------------------

from proc.test import inst_jal_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal_beq.gen_basic_test     ) ,
])
def test_jal_beq( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# mul_mem
#-------------------------------------------------------------------------

from proc.test import inst_mul_mem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul_mem.gen_basic_test     ) ,
  asm_test( inst_mul_mem.gen_more_test      ) ,
])
def test_mul_mem( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )


