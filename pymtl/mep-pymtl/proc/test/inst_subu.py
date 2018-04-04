#=========================================================================
# subu
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
    subu r3, r1, r2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 1
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
# gen_dest_byp_test
#-------------------------------------------------------------------------

def gen_dest_byp_test():
  return [
    gen_rr_dest_byp_test( 5, "subu",  2, 1,  1 ),
    gen_rr_dest_byp_test( 4, "subu",  3, 1,  2 ),
    gen_rr_dest_byp_test( 3, "subu",  4, 1,  3 ),
    gen_rr_dest_byp_test( 2, "subu",  5, 1,  4 ),
    gen_rr_dest_byp_test( 1, "subu",  6, 1,  5 ),
    gen_rr_dest_byp_test( 0, "subu",  7, 1,  6 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_byp_test
#-------------------------------------------------------------------------

def gen_src0_byp_test():
  return [
    gen_rr_src0_byp_test( 5, "subu",  8, 1,  7 ),
    gen_rr_src0_byp_test( 4, "subu",  9, 1,  8 ),
    gen_rr_src0_byp_test( 3, "subu", 10, 1,  9 ),
    gen_rr_src0_byp_test( 2, "subu", 11, 1, 10 ),
    gen_rr_src0_byp_test( 1, "subu", 12, 1, 11 ),
    gen_rr_src0_byp_test( 0, "subu", 13, 1, 12 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_test
#-------------------------------------------------------------------------

def gen_src1_byp_test():
  return [
    gen_rr_src1_byp_test( 5, "subu", 14, 1, 13 ),
    gen_rr_src1_byp_test( 4, "subu", 15, 1, 14 ),
    gen_rr_src1_byp_test( 3, "subu", 16, 1, 15 ),
    gen_rr_src1_byp_test( 2, "subu", 17, 1, 16 ),
    gen_rr_src1_byp_test( 1, "subu", 18, 1, 17 ),
    gen_rr_src1_byp_test( 0, "subu", 19, 1, 18 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_test
#-------------------------------------------------------------------------

def gen_srcs_byp_test():
  return [
    gen_rr_srcs_byp_test( 5, "subu", 20, 1, 19 ),
    gen_rr_srcs_byp_test( 4, "subu", 21, 1, 20 ),
    gen_rr_srcs_byp_test( 3, "subu", 22, 1, 21 ),
    gen_rr_srcs_byp_test( 2, "subu", 23, 1, 22 ),
    gen_rr_srcs_byp_test( 1, "subu", 24, 1, 23 ),
    gen_rr_srcs_byp_test( 0, "subu", 25, 1, 24 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "subu", 26, 1, 25 ),
    gen_rr_src1_eq_dest_test( "subu", 27, 1, 26 ),
    gen_rr_src0_eq_src1_test( "subu", 28, 0 ),
    gen_rr_srcs_eq_dest_test( "subu", 29, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "subu", 0x00000000, 0x00000000, 0x00000000 ),
    gen_rr_value_test( "subu", 0x00000001, 0x00000001, 0x00000000 ),
    gen_rr_value_test( "subu", 0x00000003, 0x00000007, 0xfffffffc ),

    gen_rr_value_test( "subu", 0x00000000, 0xffff8000, 0x00008000 ),
    gen_rr_value_test( "subu", 0x80000000, 0x00000000, 0x80000000 ),
    gen_rr_value_test( "subu", 0x80000000, 0xffff8000, 0x80008000 ),

    gen_rr_value_test( "subu", 0x00000000, 0x00007fff, 0xffff8001 ),
    gen_rr_value_test( "subu", 0x7fffffff, 0x00000000, 0x7fffffff ),
    gen_rr_value_test( "subu", 0x7fffffff, 0x00007fff, 0x7fff8000 ),

    gen_rr_value_test( "subu", 0x80000000, 0x00007fff, 0x7fff8001 ),
    gen_rr_value_test( "subu", 0x7fffffff, 0xffff8000, 0x80007fff ),

    gen_rr_value_test( "subu", 0x00000000, 0xffffffff, 0x00000001 ),
    gen_rr_value_test( "subu", 0xffffffff, 0x00000001, 0xfffffffe ),
    gen_rr_value_test( "subu", 0xffffffff, 0xffffffff, 0x00000000 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = src0 - src1
    asm_code.append( gen_rr_value_test( "subu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
