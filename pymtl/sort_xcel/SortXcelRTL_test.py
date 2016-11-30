#=========================================================================
# SortXcelRTL_test
#=========================================================================

import pytest

from pymtl       import *
from pclib.test  import run_sim
from SortXcelRTL import SortXcelRTL

#-------------------------------------------------------------------------
# Reuse tests from FL model
#-------------------------------------------------------------------------

from SortXcelFL_test import TestHarness, test_case_table, run_test

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_test( SortXcelRTL(), test_params, dump_vcd, test_verilog )

