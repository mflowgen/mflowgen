#=========================================================================
# Aerodactyl_mdu_test.py
#=========================================================================

import pytest

from pymtl              import *

from Aerodactyl_harness import asm_test
from Aerodactyl_harness import TestHarness
from Aerodactyl_harness import run_test as run

from CompAerodactyl.Aerodactyl import Aerodactyl

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Aerodactyl_run_test       import run_test

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
