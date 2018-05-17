#=========================================================================
# Chansey_ctrlreg_test.py
#=========================================================================

import pytest

from pymtl               import *

from Chansey_harness     import asm_test
from Chansey_harness     import TestHarness
from Chansey_harness     import run_test as run

from CompChansey.Chansey import Chansey

#-------------------------------------------------------------------------
# Get new run_test
#-------------------------------------------------------------------------

from Chansey_run_test    import run_test

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

from ctrlreg.CtrlReg_test import test_case_table

@pytest.mark.parametrize( **test_case_table )
def test_ctrlreg_isolation( test_params, dump_vcd, test_verilog ):

  # Get messages
  if   hasattr( test_params, 'msgs'     ):
    test_msgs = test_params.msgs
  elif hasattr( test_params, 'msg_func' ):
    test_msgs = test_params.msg_func()

  run_test(

    # ctrlreg_msg  asm_testcase   ctrlreg_msgs      icache_msgs  dcache
    [ test_msgs,   None,          None,             [],          [] ],

    dump_vcd, test_verilog,
    test_params.src_delay, test_params.sink_delay,
  )
