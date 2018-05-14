#=========================================================================
# HostChansey_Ibufferdisable_run_test.py
#=========================================================================

import pytest

from pymtl                   import *
from fpga                    import SwShim

from Chansey_harness         import run_test as run

# Import designs
from CompChansey.Chansey     import Chansey
from CompChansey.HostChansey import HostChansey

#-------------------------------------------------------------------------
# Redefining run_test for Hosted version
#-------------------------------------------------------------------------

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  asynch_bitwidth = 8

  dut             = Chansey()
  hwshim_and_dut  = HostChansey( asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth,
                                 dump_vcd, test_verilog )

  # Set explicit name
  swshim.explicit_modulename = swshim.__class__.__name__

  num_cores       = 4
  cacheline_nbits = 128

  # If this is an assembly test, change the request type to enable the
  # memory coalescer

  if "asm" in test[0]:
    test[0] = "asm_ibufferdisable"
    print test[0],

  run( swshim, test, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay,
       mem_stall_prob, mem_latency )
