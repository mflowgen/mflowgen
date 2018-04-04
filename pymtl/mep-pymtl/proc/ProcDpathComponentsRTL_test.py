#=========================================================================
# ProcDpathComponentsRTL_test.py
#=========================================================================

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl                  import *
from test.harness           import *
from pclib.test             import mk_test_case_table, run_sim
from pclib.test             import run_test_vector_sim
from ProcDpathComponentsRTL import BranchTargetCalcRTL
from ProcDpathComponentsRTL import JumpTargetCalcRTL
from ProcDpathComponentsRTL import AluRTL

#-------------------------------------------------------------------------
# BranchTargetCalcRTL
#-------------------------------------------------------------------------

def test_branch_target( dump_vcd, test_verilog ):
  run_test_vector_sim( BranchTargetCalcRTL(), [
    ('pc_plus4      imm_sext      br_target*'),
    [ 0x00000000,   0x00000000,   0x00000000],
    [ 0x00000004,   0x00000002,   0x0000000c],
    [ 0xfee00dd0,   0x00000000,   0xfee00dd0],
    [ 0x042309ec,   0x00000d25,   0x04233e80],
    [ 0x00399e00,   0xffffffa3,   0x00399c8c],
    [ 0x00000000,   0x00201ee2,   0x00807b88],
    [ 0xffffffff,   0xffffffff,   0xfffffffb],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# JumpTargetCalcRTL
#-------------------------------------------------------------------------

def test_jump_target( dump_vcd, test_verilog ):
  run_test_vector_sim( JumpTargetCalcRTL(), [
    ('pc_plus4      imm_target    j_target*'),
    [ 0x00000000,   0x0000000,    0x00000000],
    [ 0x00000004,   0x0000002,    0x00000008],
    [ 0xfee00dd0,   0x0000000,    0xfc000000],
    [ 0x042309ec,   0x0000d25,    0x04003494],
    [ 0x00399e00,   0x3ffffa3,    0x03fffe8c],
    [ 0x00000000,   0x0201ee2,    0x00807b88],
    [ 0xffffffff,   0x3ffffff,    0xfffffffc],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# AluRTL
#-------------------------------------------------------------------------

def test_alu_add( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   0,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   0,  0x0ffbc964,   '?',      '?',       '?'      ],
    #pos-neg
    [ 0x00132050,   0xd6620040,   0,  0xd6752090,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   0,  0xfff0e890,   '?',      '?',       '?'      ],
    # neg-neg
    [ 0xfeeeeaa3,   0xf4650000,   0,  0xf353eaa3,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

#''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Add more ALU function tests
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_alu_sub( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   1,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   1,  0x0ff9835c,   '?',      '?',       '?'      ],
    # pos-neg
    [ 0x00132050,   0xd6620040,   1,  0x29b12010,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   1,  0xfff05ff0,   '?',      '?',       '?'      ],
    # neg-neg
    [ 0xfeeeeaa3,   0xf4650000,   1,  0x0a89eaa3,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_sll( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   2,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x00000001,   0x05050505,   2,  0x0a0a0a0a,   '?',      '?',       '?'      ],
    [ 0x00000002,   0x05050505,   2,  0x14141414,   '?',      '?',       '?'      ],
    [ 0x00000004,   0x05050505,   2,  0x50505050,   '?',      '?',       '?'      ],
    [ 0x00000008,   0x50505050,   2,  0x50505000,   '?',      '?',       '?'      ],
    [ 0x0000000f,   0x50505050,   2,  0x28280000,   '?',      '?',       '?'      ],
    [ 0x00000010,   0x50505050,   2,  0x50500000,   '?',      '?',       '?'      ],
    [ 0x0000001f,   0x50505050,   2,  0x00000000,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_or( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   3,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   3,  0x0ffba764,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   3,  0xd6732050,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   3,  0xfff0e450,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,   3,  0xfeefeaa3,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_slt( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   4,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   4,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   4,  0x00000000,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   4,  0x00000001,   '?',      '?',       '?'      ],
    [ 0xffffffff,   0xf4650000,   4,  0x00000000,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xffffffff,   4,  0x00000001,   '?',      '?',       '?'      ],
    [ 0x80000000,   0x7fffffff,   4,  0x00000001,   '?',      '?',       '?'      ],
    [ 0x7fffffff,   0x80000000,   4,  0x00000000,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_sltu( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   5,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   5,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   5,  0x00000001,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   5,  0x00000000,   '?',      '?',       '?'      ],
    [ 0xffffffff,   0xf4650000,   5,  0x00000000,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xffffffff,   5,  0x00000001,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_and( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   6,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   6,  0x00002200,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   6,  0x00020040,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   6,  0x00000440,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,   6,  0xf4640000,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_xor( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   7,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   7,  0x0ffb8564,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   7,  0xd6712010,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   7,  0xfff0e010,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,   7,  0x0a8beaa3,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_nor( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   8,  0xffffffff,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,   8,  0xf004589b,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,   8,  0x298cdfaf,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,   8,  0x000f1baf,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,   8,  0x0110155c,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_srl( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,   9,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x00000001,   0x05050505,   9,  0x02828282,   '?',      '?',       '?'      ],
    [ 0x00000002,   0x05050505,   9,  0x01414141,   '?',      '?',       '?'      ],
    [ 0x00000004,   0x05050505,   9,  0x00505050,   '?',      '?',       '?'      ],
    [ 0x00000008,   0x50505050,   9,  0x00505050,   '?',      '?',       '?'      ],
    [ 0x0000000f,   0x50505050,   9,  0x0000a0a0,   '?',      '?',       '?'      ],
    [ 0x00000010,   0x50505050,   9,  0x00005050,   '?',      '?',       '?'      ],
    [ 0x0000001f,   0x50505050,   9,  0x00000000,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_sra( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,  10,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x00000001,   0x05050505,  10,  0x02828282,   '?',      '?',       '?'      ],
    [ 0x00000002,   0x05050505,  10,  0x01414141,   '?',      '?',       '?'      ],
    [ 0xffffff01,   0x05050505,  10,  0x02828282,   '?',      '?',       '?'      ],
    [ 0xffffff02,   0x05050505,  10,  0x01414141,   '?',      '?',       '?'      ],
    [ 0x00000004,   0x05050505,  10,  0x00505050,   '?',      '?',       '?'      ],
    [ 0x00000008,   0x80808080,  10,  0xff808080,   '?',      '?',       '?'      ],
    [ 0x0000000f,   0x80808080,  10,  0xffff0101,   '?',      '?',       '?'      ],
    [ 0x00000010,   0x80808080,  10,  0xffff8080,   '?',      '?',       '?'      ],
    [ 0x0000001f,   0x80808080,  10,  0xffffffff,   '?',      '?',       '?'      ],
    [ 0x0000001f,   0xffffffff,  10,  0xffffffff,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

def test_alu_cp_op0( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,  11,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,  11,  0x0ffaa660,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,  11,  0x00132050,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,  11,  0xfff0a440,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,  11,  0xfeeeeaa3,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_cp_op1( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,  12,  0x00000000,   '?',      '?',       '?'      ],
    [ 0x0ffaa660,   0x00012304,  12,  0x00012304,   '?',      '?',       '?'      ],
    [ 0x00132050,   0xd6620040,  12,  0xd6620040,   '?',      '?',       '?'      ],
    [ 0xfff0a440,   0x00004450,  12,  0x00004450,   '?',      '?',       '?'      ],
    [ 0xfeeeeaa3,   0xf4650000,  12,  0xf4650000,   '?',      '?',       '?'      ],
  ], dump_vcd, test_verilog )

def test_alu_fn_eqaulity( dump_vcd, test_verilog ):
  run_test_vector_sim( AluRTL(), [
    ('in0           in1           fn  out*          ops_eq*   op0_zero*  op0_neg*'),
    [ 0x00000000,   0x00000000,  13,  0x00000000,   1,        1,         0      ],
    [ 0x0ffaa660,   0x00012304,  14,  0x00000000,   0,        0,         0      ],
    [ 0x00132050,   0xd6620040,  13,  0x00000000,   0,        0,         0      ],
    [ 0xfff0a440,   0x00004450,  14,  0x00000000,   0,        0,         1      ],
    [ 0xfeeeeaa3,   0xf4650000,  13,  0x00000000,   0,        0,         1      ],
  ], dump_vcd, test_verilog )



