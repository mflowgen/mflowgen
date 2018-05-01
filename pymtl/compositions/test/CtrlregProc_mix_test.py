#=========================================================================
# ProcRTL_mix_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from CtrlregProc_harness import *
from compositions.CtrlregProc import CtrlregProc

#-------------------------------------------------------------------------
# jal_beq
#-------------------------------------------------------------------------

from proc.test import inst_jal_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal_beq.gen_basic_test     ) ,
])
def test_jal_beq( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# mul_mem
#-------------------------------------------------------------------------

from proc.test import inst_mul_mem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul_mem.gen_basic_test     ) ,
  asm_test( inst_mul_mem.gen_more_test      ) ,
])
def test_mul_mem( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )


