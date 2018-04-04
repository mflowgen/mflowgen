#=========================================================================
# Bram2rwWrapperWithShims_test
#=========================================================================

import pytest

from pymtl      import *
from pclib.test import run_sim

from Bram2rwWrapper import Bram2rwWrapper

from fpga         import FpgaDut, SwShim
from fpga.drivers import ZedDriver

# Reuse tests

from Bram2rwWrapper_test import TestHarness
from Bram2rwWrapper_test import test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):


  dut            = Bram2rwWrapper( 32, 256 )
  hwshim_and_dut = FpgaDut( dut )
  swshim         = SwShim( dut, hwshim_and_dut ) # RTL version

#  zed            = ZedDriver()
#  swshim         = SwShim( dut, zed )            # FPGA version

  #th = TestHarness( swshim, test_params.msgs, test_params.msgs,
  #                  test_params.src_delay, test_params.sink_delay,
  #                  dump_vcd, test_verilog )
  #run_sim( th )

  base_addr = 0x0
  num_msgs  = 50
  msgs = test_params.msg_func( base_addr, num_msgs )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.src, test_params.sink,
                         swshim, dump_vcd, test_verilog )
  # Run the test
  # Setting max cycles higher so the test can finish
  run_sim( harness, dump_vcd, max_cycles=10000 )

#  swshim.dut.close()

