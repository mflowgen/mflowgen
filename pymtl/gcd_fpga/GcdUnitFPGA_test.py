#=========================================================================
# GcdUnitFPGA_test
#=========================================================================

import pytest

from pymtl                   import *
from pclib.test              import run_sim
from examples.gcd.GcdUnitRTL import GcdUnitRTL
from fpga                    import FpgaDut, SwShim

# Reuse tests from FL model

from examples.gcd.GcdUnitFL_test import TestHarness
from examples.gcd.GcdUnitFL_test import basic_msgs, random_msgs, test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):

  asynch_bitwidth = 8

  dut             = GcdUnitRTL()
  hwshim_and_dut  = FpgaDut( dut, asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth )

  run_sim( TestHarness( swshim,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ) )

