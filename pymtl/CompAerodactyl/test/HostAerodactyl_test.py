#=========================================================================
# HostAerodactyl_test
#=========================================================================

import importlib

import pytest

from pymtl                         import *
from pclib.test                    import run_sim
from fpga                          import SwShim

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


#-------------------------------------------------------------------------
# Override old run_test
#-------------------------------------------------------------------------

import Aerodactyl_asm_test
import Aerodactyl_mdu_test

Aerodactyl_asm_test.run_test = run_test
Aerodactyl_mdu_test.run_test = run_test

#-------------------------------------------------------------------------
# Import everything inside Aerodactyl test infrastructure
#-------------------------------------------------------------------------
# Reuse tests from non-host version

from Aerodactyl_test import *

#for x in dir(Aerodactyl_test):
#  if not x in globals():
#    print x
#    globals()[x] = getattr(Aerodactyl_test, x) 
