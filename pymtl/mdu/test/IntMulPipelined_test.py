#=========================================================================
# IntMulPipelined_test
#=========================================================================

import pytest

from pymtl            import *
from pclib.test       import run_sim

from mdu.IntMulPipelined import IntMulPipelined

# Reuse test cases!
from IntMulVarLat_test import TestHarness, test_case_table

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test_2stage( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( IntMulPipelined( 32, 8, 2 ), 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )

@pytest.mark.parametrize( **test_case_table )
def test_4stage( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( IntMulPipelined( 32, 8, 4 ), 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog )
            )

@pytest.mark.parametrize( **test_case_table )
def test_8stage( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( IntMulPipelined( 32, 8, 8 ), 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog )
            )

@pytest.mark.parametrize( **test_case_table )
def test_16stage( test_params, dump_vcd, test_verilog ):
  run_sim( TestHarness( IntMulPipelined( 32, 8, 16 ), 32,
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog ),
            )
