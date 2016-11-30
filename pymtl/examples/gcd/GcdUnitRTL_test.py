#=========================================================================
# GcdUnitRTL_test
#=========================================================================

import pytest

from pymtl      import *
from pclib.test import run_sim
from GcdUnitRTL import GcdUnitRTL

# Reuse tests from FL model

from GcdUnitFL_test import TestHarness
from GcdUnitFL_test import basic_msgs, random_msgs, test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( GcdUnitRTL(),
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ) )

