#=========================================================================
# HostAerodactyl_run_test.py
#=========================================================================

import pytest

from pymtl                         import *
from fpga                          import SwShim

from Aerodactyl_harness            import run_test as run

# Import designs
from CompAerodactyl.Aerodactyl     import Aerodactyl
from CompAerodactyl.HostAerodactyl import HostAerodactyl

#-------------------------------------------------------------------------
# Redefining run_test for Hosted version
#-------------------------------------------------------------------------

def run_test( test, dump_vcd, test_verilog,
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

  run( swshim, test, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay,
       mem_stall_prob, mem_latency )
