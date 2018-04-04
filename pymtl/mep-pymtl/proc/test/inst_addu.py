#=========================================================================
# addu
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    mfc0 r1, mngr2proc < 5
    mfc0 r2, mngr2proc < 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    addu r3, r1, r2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 9
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

#-------------------------------------------------------------------------
# gen_dest_byp_test
#-------------------------------------------------------------------------

def gen_dest_byp_test():
  return [
    gen_rr_dest_byp_test( 5, "addu",  1, 1,  2 ),
    gen_rr_dest_byp_test( 4, "addu",  2, 1,  3 ),
    gen_rr_dest_byp_test( 3, "addu",  3, 1,  4 ),
    gen_rr_dest_byp_test( 2, "addu",  4, 1,  5 ),
    gen_rr_dest_byp_test( 1, "addu",  5, 1,  6 ),
    gen_rr_dest_byp_test( 0, "addu",  6, 1,  7 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_byp_test
#-------------------------------------------------------------------------

def gen_src0_byp_test():
  return [
    gen_rr_src0_byp_test( 5, "addu",  7, 1,  8 ),
    gen_rr_src0_byp_test( 4, "addu",  8, 1,  9 ),
    gen_rr_src0_byp_test( 3, "addu",  9, 1, 10 ),
    gen_rr_src0_byp_test( 2, "addu", 10, 1, 11 ),
    gen_rr_src0_byp_test( 1, "addu", 11, 1, 12 ),
    gen_rr_src0_byp_test( 0, "addu", 12, 1, 13 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_test
#-------------------------------------------------------------------------

def gen_src1_byp_test():
  return [
    gen_rr_src1_byp_test( 5, "addu", 13, 1, 14 ),
    gen_rr_src1_byp_test( 4, "addu", 14, 1, 15 ),
    gen_rr_src1_byp_test( 3, "addu", 15, 1, 16 ),
    gen_rr_src1_byp_test( 2, "addu", 16, 1, 17 ),
    gen_rr_src1_byp_test( 1, "addu", 17, 1, 18 ),
    gen_rr_src1_byp_test( 0, "addu", 18, 1, 19 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_test
#-------------------------------------------------------------------------

def gen_srcs_byp_test():
  return [
    gen_rr_srcs_byp_test( 5, "addu", 19, 1, 20 ),
    gen_rr_srcs_byp_test( 4, "addu", 20, 1, 21 ),
    gen_rr_srcs_byp_test( 3, "addu", 21, 1, 22 ),
    gen_rr_srcs_byp_test( 2, "addu", 22, 1, 23 ),
    gen_rr_srcs_byp_test( 1, "addu", 23, 1, 24 ),
    gen_rr_srcs_byp_test( 0, "addu", 24, 1, 25 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "addu", 25, 1, 26 ),
    gen_rr_src1_eq_dest_test( "addu", 26, 1, 27 ),
    gen_rr_src0_eq_src1_test( "addu", 27, 54 ),
    gen_rr_srcs_eq_dest_test( "addu", 28, 56 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "addu", 0x00000000, 0x00000000, 0x00000000 ),
    gen_rr_value_test( "addu", 0x00000001, 0x00000001, 0x00000002 ),
    gen_rr_value_test( "addu", 0x00000003, 0x00000007, 0x0000000a ),

    gen_rr_value_test( "addu", 0x00000000, 0xffff8000, 0xffff8000 ),
    gen_rr_value_test( "addu", 0x80000000, 0x00000000, 0x80000000 ),
    gen_rr_value_test( "addu", 0x80000000, 0xffff8000, 0x7fff8000 ),

    gen_rr_value_test( "addu", 0x00000000, 0x00007fff, 0x00007fff ),
    gen_rr_value_test( "addu", 0x7fffffff, 0x00000000, 0x7fffffff ),
    gen_rr_value_test( "addu", 0x7fffffff, 0x00007fff, 0x80007ffe ),

    gen_rr_value_test( "addu", 0x80000000, 0x00007fff, 0x80007fff ),
    gen_rr_value_test( "addu", 0x7fffffff, 0xffff8000, 0x7fff7fff ),

    gen_rr_value_test( "addu", 0x00000000, 0xffffffff, 0xffffffff ),
    gen_rr_value_test( "addu", 0xffffffff, 0x00000001, 0x00000000 ),
    gen_rr_value_test( "addu", 0xffffffff, 0xffffffff, 0xfffffffe ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = src0 + src1
    asm_code.append( gen_rr_value_test( "addu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

