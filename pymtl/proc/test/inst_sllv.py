#=========================================================================
# sllv
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
    mfc0 r1, mngr2proc < 0x80008000
    mfc0 r2, mngr2proc < 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sllv r3, r1, r2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 0x00040000
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
    gen_rr_dest_byp_test( 5, "sllv", 0x00000001, 1, 0x00000002 ),
    gen_rr_dest_byp_test( 4, "sllv", 0x00000002, 1, 0x00000004 ),
    gen_rr_dest_byp_test( 3, "sllv", 0x00000004, 1, 0x00000008 ),
    gen_rr_dest_byp_test( 2, "sllv", 0x00000008, 1, 0x00000010 ),
    gen_rr_dest_byp_test( 1, "sllv", 0x00000010, 1, 0x00000020 ),
    gen_rr_dest_byp_test( 0, "sllv", 0x00000020, 1, 0x00000040 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_byp_test
#-------------------------------------------------------------------------

def gen_src0_byp_test():
  return [
    gen_rr_src0_byp_test( 5, "sllv", 0x00000040, 1, 0x00000080 ),
    gen_rr_src0_byp_test( 4, "sllv", 0x00000080, 1, 0x00000100 ),
    gen_rr_src0_byp_test( 3, "sllv", 0x00000100, 1, 0x00000200 ),
    gen_rr_src0_byp_test( 2, "sllv", 0x00000200, 1, 0x00000400 ),
    gen_rr_src0_byp_test( 1, "sllv", 0x00000400, 1, 0x00000800 ),
    gen_rr_src0_byp_test( 0, "sllv", 0x00000800, 1, 0x00001000 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_test
#-------------------------------------------------------------------------

def gen_src1_byp_test():
  return [
    gen_rr_src1_byp_test( 5, "sllv", 0x00001000, 1, 0x00002000 ),
    gen_rr_src1_byp_test( 4, "sllv", 0x00002000, 1, 0x00004000 ),
    gen_rr_src1_byp_test( 3, "sllv", 0x00004000, 1, 0x00008000 ),
    gen_rr_src1_byp_test( 2, "sllv", 0x00008000, 1, 0x00010000 ),
    gen_rr_src1_byp_test( 1, "sllv", 0x00010000, 1, 0x00020000 ),
    gen_rr_src1_byp_test( 0, "sllv", 0x00020000, 1, 0x00040000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_test
#-------------------------------------------------------------------------

def gen_srcs_byp_test():
  return [
    gen_rr_srcs_byp_test( 5, "sllv", 0x00040000, 1, 0x00080000 ),
    gen_rr_srcs_byp_test( 4, "sllv", 0x00080000, 1, 0x00100000 ),
    gen_rr_srcs_byp_test( 3, "sllv", 0x00100000, 1, 0x00200000 ),
    gen_rr_srcs_byp_test( 2, "sllv", 0x00200000, 1, 0x00400000 ),
    gen_rr_srcs_byp_test( 1, "sllv", 0x00400000, 1, 0x00800000 ),
    gen_rr_srcs_byp_test( 0, "sllv", 0x00800000, 1, 0x01000000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sllv", 0x01000000, 1, 0x02000000 ),
    gen_rr_src1_eq_dest_test( "sllv", 0x02000000, 1, 0x04000000 ),
    gen_rr_src0_eq_src1_test( "sllv", 0x00000003, 0x000000018 ),
    gen_rr_srcs_eq_dest_test( "sllv", 0x00000007, 0x000000380 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "sllv", 0x00000001,  0, 0x00000001 ),
    gen_rr_value_test( "sllv", 0x00000001,  1, 0x00000002 ),
    gen_rr_value_test( "sllv", 0x00000001,  7, 0x00000080 ),
    gen_rr_value_test( "sllv", 0x00000001, 14, 0x00004000 ),
    gen_rr_value_test( "sllv", 0x00000001, 31, 0x80000000 ),

    gen_rr_value_test( "sllv", 0xffffffff,  0, 0xffffffff ),
    gen_rr_value_test( "sllv", 0xffffffff,  1, 0xfffffffe ),
    gen_rr_value_test( "sllv", 0xffffffff,  7, 0xffffff80 ),
    gen_rr_value_test( "sllv", 0xffffffff, 14, 0xffffc000 ),
    gen_rr_value_test( "sllv", 0xffffffff, 31, 0x80000000 ),

    gen_rr_value_test( "sllv", 0x21212121,  0, 0x21212121 ),
    gen_rr_value_test( "sllv", 0x21212121,  1, 0x42424242 ),
    gen_rr_value_test( "sllv", 0x21212121,  7, 0x90909080 ),
    gen_rr_value_test( "sllv", 0x21212121, 14, 0x48484000 ),
    gen_rr_value_test( "sllv", 0x21212121, 31, 0x80000000 ),

    # Verify that shifts only use bottom five bits

    gen_rr_value_test( "sllv", 0x21212121, 0xffffffe0, 0x21212121 ),
    gen_rr_value_test( "sllv", 0x21212121, 0xffffffe1, 0x42424242 ),
    gen_rr_value_test( "sllv", 0x21212121, 0xffffffe7, 0x90909080 ),
    gen_rr_value_test( "sllv", 0x21212121, 0xffffffee, 0x48484000 ),
    gen_rr_value_test( "sllv", 0x21212121, 0xffffffff, 0x80000000 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits(  5, random.randint(0,31) )
    dest = src0 << src1
    asm_code.append( gen_rr_value_test( "sllv", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
