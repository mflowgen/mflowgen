#=========================================================================
# ProcFL_mix_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from harness import *
from proc.ProcFL import ProcFL

#-------------------------------------------------------------------------
# jal_beq
#-------------------------------------------------------------------------

import inst_jal_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal_beq.gen_basic_test     ) ,
])
def test_jal_beq( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )
 
#-------------------------------------------------------------------------
# mul_mem
#-------------------------------------------------------------------------

import inst_mul_mem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul_mem.gen_basic_test     ) ,
  asm_test( inst_mul_mem.gen_more_test      ) ,
])
def test_mul_mem( name, test, dump_vcd ):
  run_test( ProcFL, test, dump_vcd )
 
  
