#=========================================================================
# mul
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 5
    csrr x2, mngr2proc < 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mul x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 20
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [
    gen_rr_dest_dep_test( 5, "mul",  1, 2,  2 ),
    gen_rr_dest_dep_test( 4, "mul",  2, 2,  4 ),
    gen_rr_dest_dep_test( 3, "mul",  3, 2,  6 ),
    gen_rr_dest_dep_test( 2, "mul",  4, 2,  8 ),
    gen_rr_dest_dep_test( 1, "mul",  5, 2, 10 ),
    gen_rr_dest_dep_test( 0, "mul",  6, 2, 12 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "mul",  7, 2, 14 ),
    gen_rr_src0_dep_test( 4, "mul",  8, 2, 16 ),
    gen_rr_src0_dep_test( 3, "mul",  9, 2, 18 ),
    gen_rr_src0_dep_test( 2, "mul", 10, 2, 20 ),
    gen_rr_src0_dep_test( 2, "mul", 11, 2, 22 ),
    gen_rr_src0_dep_test( 0, "mul", 12, 2, 24 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "mul", 2, 13, 26 ),
    gen_rr_src1_dep_test( 4, "mul", 2, 14, 28 ),
    gen_rr_src1_dep_test( 3, "mul", 2, 15, 30 ),
    gen_rr_src1_dep_test( 2, "mul", 2, 16, 32 ),
    gen_rr_src1_dep_test( 1, "mul", 2, 17, 34 ),
    gen_rr_src1_dep_test( 0, "mul", 2, 18, 36 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "mul", 2, 1,  2 ),
    gen_rr_srcs_dep_test( 4, "mul", 3, 2,  6 ),
    gen_rr_srcs_dep_test( 3, "mul", 4, 3, 12 ),
    gen_rr_srcs_dep_test( 2, "mul", 5, 4, 20 ),
    gen_rr_srcs_dep_test( 1, "mul", 6, 5, 30 ),
    gen_rr_srcs_dep_test( 0, "mul", 7, 6, 42 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "mul", 25, 2, 50 ),
    gen_rr_src1_eq_dest_test( "mul", 26, 2, 52 ),
    gen_rr_src0_eq_src1_test( "mul", 2, 4 ),
    gen_rr_srcs_eq_dest_test( "mul", 3, 9 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Zero and one operands

    gen_rr_value_test( "mul",  0,  0, 0 ),
    gen_rr_value_test( "mul",  0,  1, 0 ),
    gen_rr_value_test( "mul",  1,  0, 0 ),
    gen_rr_value_test( "mul",  1,  1, 1 ),
    gen_rr_value_test( "mul",  0, -1, 0 ),
    gen_rr_value_test( "mul", -1,  0, 0 ),
    gen_rr_value_test( "mul", -1, -1, 1 ),

    # Positive operands

    gen_rr_value_test( "mul",    42,   13,       546 ),
    gen_rr_value_test( "mul",   716,   89,     63724 ),
    gen_rr_value_test( "mul", 20154, 8330, 167882820 ),

    # Negative operands

    gen_rr_value_test( "mul",    42,    -13,      -546 ),
    gen_rr_value_test( "mul",  -716,     89,    -63724 ),
    gen_rr_value_test( "mul", -20154, -8330, 167882820 ),

    # Mixed tests

    gen_rr_value_test( "mul", 0x0deadbee, 0x10000000, 0xe0000000 ),
    gen_rr_value_test( "mul", 0xdeadbeef, 0x10000000, 0xf0000000 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, src0 * src1, trunc=True )
    asm_code.append( gen_rr_value_test( "mul", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
