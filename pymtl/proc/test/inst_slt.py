#=========================================================================
# slt
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 4
    csrr x2, mngr2proc < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    slt x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 1
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
    gen_rr_dest_dep_test( 5, "slt", 1, 0, 0 ),
    gen_rr_dest_dep_test( 4, "slt", 1, 1, 0 ),
    gen_rr_dest_dep_test( 3, "slt", 0, 1, 1 ),
    gen_rr_dest_dep_test( 2, "slt", 2, 1, 0 ),
    gen_rr_dest_dep_test( 1, "slt", 2, 2, 0 ),
    gen_rr_dest_dep_test( 0, "slt", 1, 2, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "slt", 1, 3, 1 ),
    gen_rr_src0_dep_test( 4, "slt", 6, 3, 0 ),
    gen_rr_src0_dep_test( 3, "slt", 2, 3, 1 ),
    gen_rr_src0_dep_test( 2, "slt", 6, 3, 0 ),
    gen_rr_src0_dep_test( 1, "slt", 3, 3, 0 ),
    gen_rr_src0_dep_test( 0, "slt", 4, 3, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "slt", 3, 1, 0 ),
    gen_rr_src1_dep_test( 4, "slt", 3, 6, 1 ),
    gen_rr_src1_dep_test( 3, "slt", 3, 2, 0 ),
    gen_rr_src1_dep_test( 2, "slt", 3, 5, 1 ),
    gen_rr_src1_dep_test( 1, "slt", 3, 3, 0 ),
    gen_rr_src1_dep_test( 0, "slt", 3, 4, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "slt", 6, 1, 0 ),
    gen_rr_srcs_dep_test( 4, "slt", 2, 5, 1 ),
    gen_rr_srcs_dep_test( 3, "slt", 4, 3, 0 ),
    gen_rr_srcs_dep_test( 2, "slt", 1, 1, 0 ),
    gen_rr_srcs_dep_test( 1, "slt", 3, 6, 1 ),
    gen_rr_srcs_dep_test( 0, "slt", 5, 2, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "slt",  9,  8, 0 ),
    gen_rr_src1_eq_dest_test( "slt",  8,  9, 1 ),
    gen_rr_src0_eq_src1_test( "slt", 10, 0 ),
    gen_rr_srcs_eq_dest_test( "slt", 11, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "slt", 0x00000000, 0x00000000, 0 ),
    gen_rr_value_test( "slt", 0x00000001, 0x00000001, 0 ),
    gen_rr_value_test( "slt", 0x00000003, 0x00000007, 1 ),
    gen_rr_value_test( "slt", 0x00000007, 0x00000003, 0 ),

    gen_rr_value_test( "slt", 0x00000000, 0xffff8000, 0 ),
    gen_rr_value_test( "slt", 0x80000000, 0x00000000, 1 ),
    gen_rr_value_test( "slt", 0x80000000, 0xffff8000, 1 ),

    gen_rr_value_test( "slt", 0x00000000, 0x00007fff, 1 ),
    gen_rr_value_test( "slt", 0x7fffffff, 0x00000000, 0 ),
    gen_rr_value_test( "slt", 0x7fffffff, 0x00007fff, 0 ),

    gen_rr_value_test( "slt", 0x80000000, 0x00007fff, 1 ),
    gen_rr_value_test( "slt", 0x7fffffff, 0xffff8000, 0 ),

    gen_rr_value_test( "slt", 0x00000000, 0xffffffff, 0 ),
    gen_rr_value_test( "slt", 0xffffffff, 0x00000001, 1 ),
    gen_rr_value_test( "slt", 0xffffffff, 0xffffffff, 0 ),
        
    #specifically test if this is a signed comparison
    gen_rr_value_test( "slt", 0x00000001, 0xffffffff, 0 ),
    gen_rr_value_test( "slt", 0xffffffff, 0x00000001, 1 ),


  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, src0.int() < src1.int() )
    asm_code.append( gen_rr_value_test( "slt", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
