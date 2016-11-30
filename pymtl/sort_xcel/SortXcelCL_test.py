#=========================================================================
# SortXcelCL_test
#=========================================================================

import pytest

from pymtl      import *
from pclib.test import run_sim
from SortXcelCL import SortXcelCL

#-------------------------------------------------------------------------
# Reuse tests from FL model
#-------------------------------------------------------------------------

from SortXcelFL_test import TestHarness, test_case_table, run_test

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  run_test( SortXcelCL(), test_params, dump_vcd )

