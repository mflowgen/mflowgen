#=========================================================================
# GcdTop_test
#=========================================================================

import pytest

from pymtl                   import *
from pclib.test              import run_sim
from fpga                    import SwShim

from examples.gcd.GcdUnitRTL import GcdUnitRTL
from HostGcdUnit             import HostGcdUnit

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
  hwshim_and_dut  = HostGcdUnit( asynch_bitwidth )
  swshim          = SwShim( dut, hwshim_and_dut, asynch_bitwidth,
                                 dump_vcd      , test_verilog    )

  with open("HostGcdUnit_testcase_init.v", "w") as f:
    f.write( "  th_src_max_delay  = {};\n".format( test_params.src_delay ) )
    f.write( "  th_sink_max_delay = {};\n".format( test_params.sink_delay ) )
    for x in test_params.msgs[::2]:
      f.write( "  load_src0( 32'h%s );\n" % Bits(32,x) );
    for x in test_params.msgs[1::2]:
      f.write( "  load_sink0( 16'h%s );\n" % Bits(16,x) );

  run_sim( TestHarness( swshim,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ) )

