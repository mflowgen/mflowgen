#=========================================================================
# IntMulScycle_test
#=========================================================================

import pytest

from pymtl            import *
from pclib.test       import run_sim

from mdu.IntMulScycle import IntMulScycle

# Reuse test cases!
from IntMulVarLat_test import TestHarness, test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( IntMulScycle( 32, 8 ), 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )
