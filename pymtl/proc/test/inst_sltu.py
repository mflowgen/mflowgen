#=========================================================================
# sltu
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
    sltu x3, x1, x2
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
    gen_rr_dest_dep_test( 5, "sltu", 1, 0, 0 ),
    gen_rr_dest_dep_test( 4, "sltu", 2, 3, 1 ),
    gen_rr_dest_dep_test( 3, "sltu", 3, 2, 0 ),
    gen_rr_dest_dep_test( 2, "sltu", 4, 4, 0 ),
    gen_rr_dest_dep_test( 1, "sltu", 5, 6, 1 ),
    gen_rr_dest_dep_test( 0, "sltu", 6, 1, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "sltu",  7, 9, 1 ),
    gen_rr_src0_dep_test( 4, "sltu", 10, 9, 0 ),
    gen_rr_src0_dep_test( 3, "sltu",  9, 9, 0 ),
    gen_rr_src0_dep_test( 2, "sltu",  8, 9, 1 ),
    gen_rr_src0_dep_test( 1, "sltu", 11, 9, 0 ),
    gen_rr_src0_dep_test( 0, "sltu", 12, 9, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "sltu", 9,  7, 0 ),
    gen_rr_src1_dep_test( 4, "sltu", 9, 10, 1 ),
    gen_rr_src1_dep_test( 3, "sltu", 9,  8, 0 ),
    gen_rr_src1_dep_test( 2, "sltu", 9,  9, 0 ),
    gen_rr_src1_dep_test( 1, "sltu", 9, 11, 1 ),
    gen_rr_src1_dep_test( 0, "sltu", 9, 12, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "sltu", 1, 6, 1 ),
    gen_rr_srcs_dep_test( 4, "sltu", 5, 2, 0 ),
    gen_rr_srcs_dep_test( 3, "sltu", 2, 3, 1 ),
    gen_rr_srcs_dep_test( 2, "sltu", 8, 7, 0 ),
    gen_rr_srcs_dep_test( 1, "sltu", 7, 8, 1 ),
    gen_rr_srcs_dep_test( 0, "sltu", 6, 1, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sltu",  9, 8, 0 ),
    gen_rr_src1_eq_dest_test( "sltu",  8, 9, 1 ),
    gen_rr_src0_eq_src1_test( "sltu", 10, 0 ),
    gen_rr_srcs_eq_dest_test( "sltu", 10, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "sltu", 0x00000000, 0x00000000, 0 ),
    gen_rr_value_test( "sltu", 0x00000001, 0x00000001, 0 ),
    gen_rr_value_test( "sltu", 0x00000003, 0x00000007, 1 ),
    gen_rr_value_test( "sltu", 0x00000007, 0x00000003, 0 ),

    gen_rr_value_test( "sltu", 0x00000000, 0xffff8000, 1 ),
    gen_rr_value_test( "sltu", 0x80000000, 0x00000000, 0 ),
    gen_rr_value_test( "sltu", 0x80000000, 0xffff8000, 1 ),

    gen_rr_value_test( "sltu", 0x00000000, 0x00007fff, 1 ),
    gen_rr_value_test( "sltu", 0x7fffffff, 0x00000000, 0 ),
    gen_rr_value_test( "sltu", 0x7fffffff, 0x00007fff, 0 ),

    gen_rr_value_test( "sltu", 0x80000000, 0x00007fff, 0 ),
    gen_rr_value_test( "sltu", 0x7fffffff, 0xffff8000, 1 ),

    gen_rr_value_test( "sltu", 0x00000000, 0xffffffff, 1 ),
    gen_rr_value_test( "sltu", 0xffffffff, 0x00000001, 0 ),
    gen_rr_value_test( "sltu", 0xffffffff, 0xffffffff, 0 ),
    
    #specifically test if this is a unsigned comparison
    gen_rr_value_test( "sltu", 0x00000001, 0xffffffff, 1 ),
    gen_rr_value_test( "sltu", 0xffffffff, 0x00000001, 0 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, src0 < src1 )
    asm_code.append( gen_rr_value_test( "sltu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
