#=========================================================================
# HostAerodactyl_mdu_test
#=========================================================================

import pytest

from pymtl import *

# Reuse tests from non-host version

from Aerodactyl_harness import asm_test
from Aerodactyl_harness import TestHarness
from Aerodactyl_harness import run_test as run

# We wrap HostAerodactyle by SwShim generated from Aerodactyl

from fpga                          import SwShim
from CompAerodactyl.Aerodactyl     import Aerodactyl
from CompAerodactyl.HostAerodactyl import HostAerodactyl

def run_test( test_vector, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  asynch_bitwidth = 8

  dut             = Aerodactyl()
  hwshim_and_dut  = HostAerodactyl( asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth,
                                 dump_vcd, test_verilog )

  # Set explicit name
  swshim.explicit_modulename = swshim.__class__.__name__

  num_cores       = 4
  cacheline_nbits = 128

  run( swshim, test_vector, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay,
       mem_stall_prob, mem_latency )

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
