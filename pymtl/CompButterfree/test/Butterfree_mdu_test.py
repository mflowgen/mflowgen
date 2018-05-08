#=========================================================================
# Butterfree_mdu_test.py
#=========================================================================

import pytest

from pymtl              import *

from Butterfree_harness import asm_test
from Butterfree_harness import TestHarness
from Butterfree_harness import run_test as run

from CompButterfree.Butterfree import Butterfree

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Butterfree_run_test       import run_test

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

from mdu.test.IntMulDivUnit_test import test_case_table

@pytest.mark.parametrize( **test_case_table )
def test_mdu_isolation( test_params, dump_vcd, test_verilog ):
  run_test(

    # ctrlreg_msg    asm_testcase   mdu_msgs          icache_msgs  dcache
    [ "mdu",         None,          test_params.msgs, [],          [] ],

    dump_vcd, test_verilog,
    test_params.src_delay, test_params.sink_delay,
  )
