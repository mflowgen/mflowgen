#=========================================================================
# Aerodactyl_mdu_test.py
#=========================================================================

import pytest

from pymtl              import *

from Aerodactyl_harness import asm_test
from Aerodactyl_harness import TestHarness
from Aerodactyl_harness import run_test as run

from CompAerodactyl.Aerodactyl import Aerodactyl

# 4 core, with 2 memory ports, each with 16B data bitwidth

def run_test( test_vector, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores       = 4
  cacheline_nbits = 128

  from Aerodactyl_harness import run_test as run

  run( Aerodactyl( num_cores ), test_vector, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob, mem_latency )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

from mdu.test.IntMulDivUnit_test import test_case_table

@pytest.mark.parametrize( **test_case_table )
def test_mdu_isolation( test_params, dump_vcd, test_verilog ):
  run_test(

    # ctrlreg_msg    assembly_image   mdu_msgs          icache_msgs  dcache
    [ "mdu",         None,            test_params.msgs, [],          [] ],

    dump_vcd, test_verilog,
    test_params.src_delay, test_params.sink_delay,
  )
