#=========================================================================
# SramWrapperFPGA_test
#=========================================================================

import pytest

from pymtl      import *
from pclib.test import run_sim

from sram       import SramWrapper

from fpga         import FpgaDut, SwShim
from fpga.drivers import ZedDriver

# Reuse tests

from sram.SramWrapper_test import TestHarness
from sram.SramWrapper_test import test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):

  asynch_bitwidth = 8

  dut             = SramWrapper(32,2048,2) # Ex. 32b word size * 6144 words = 24KB
  hwshim_and_dut  = FpgaDut( dut, asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth ) # RTL version

#  zed             = ZedDriver()
#  swshim          = SwShim( dut, zed, asynch_bitwidth ) # FPGA version

  base_addr = 0x0
  max_addr  = 0x2000 # 0x8000 is 32KB, 0x4000 is 16KB, 0x2000 is 8KB
  num_msgs  = 50 # 256 msgs max, because msg num goes into opaque field
  msgs_A = test_params.msg_func_A( base_addr, max_addr, num_msgs )
  msgs_B = test_params.msg_func_B( base_addr, max_addr, num_msgs )

  # Instantiate testharness

  harness = TestHarness( msgs_A[::2], msgs_A[1::2],
                         msgs_B[::2], msgs_B[1::2],
                         test_params.src, test_params.sink,
                         swshim, dump_vcd, test_verilog )

  # Run the test
  # Setting max cycles higher so the test can finish

  run_sim( harness, dump_vcd, max_cycles=100000 )

#  swshim.dut.close()

