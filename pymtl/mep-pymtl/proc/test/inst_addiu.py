#=========================================================================
# addiu
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl                import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    mfc0 r1, mngr2proc < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    addiu r3, r1, 0x0004
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

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_dest_byp_test
#-------------------------------------------------------------------------

def gen_dest_byp_test():
  return [
    gen_rimm_dest_byp_test( 5, "addiu",  1, 1,  2 ),
    gen_rimm_dest_byp_test( 4, "addiu",  2, 1,  3 ),
    gen_rimm_dest_byp_test( 3, "addiu",  3, 1,  4 ),
    gen_rimm_dest_byp_test( 2, "addiu",  4, 1,  5 ),
    gen_rimm_dest_byp_test( 1, "addiu",  5, 1,  6 ),
    gen_rimm_dest_byp_test( 0, "addiu",  6, 1,  7 ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_rimm_src_byp_test( 5, "addiu",  7, 1,  8 ),
    gen_rimm_src_byp_test( 4, "addiu",  8, 1,  9 ),
    gen_rimm_src_byp_test( 3, "addiu",  9, 1, 10 ),
    gen_rimm_src_byp_test( 2, "addiu", 10, 1, 11 ),
    gen_rimm_src_byp_test( 1, "addiu", 11, 1, 12 ),
    gen_rimm_src_byp_test( 0, "addiu", 12, 1, 13 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "addiu", 13, 1, 14 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "addiu", 0x00000000, 0x0000, 0x00000000 ),
    gen_rimm_value_test( "addiu", 0x00000001, 0x0001, 0x00000002 ),
    gen_rimm_value_test( "addiu", 0x00000003, 0x0007, 0x0000000a ),
    gen_rimm_value_test( "addiu", 0x00000004, 0xffff, 0x00000003 ),

    gen_rimm_value_test( "addiu", 0x00000000, 0x8000, 0xffff8000 ),
    gen_rimm_value_test( "addiu", 0x80000000, 0x0000, 0x80000000 ),
    gen_rimm_value_test( "addiu", 0x80000000, 0x8000, 0x7fff8000 ),

    gen_rimm_value_test( "addiu", 0x00000000, 0x7fff, 0x00007fff ),
    gen_rimm_value_test( "addiu", 0x7fffffff, 0x0000, 0x7fffffff ),
    gen_rimm_value_test( "addiu", 0x7fffffff, 0x7fff, 0x80007ffe ),

    gen_rimm_value_test( "addiu", 0x80000000, 0x7fff, 0x80007fff ),
    gen_rimm_value_test( "addiu", 0x7fffffff, 0x8000, 0x7fff7fff ),

    gen_rimm_value_test( "addiu", 0x00000000, 0xffff, 0xffffffff ),
    gen_rimm_value_test( "addiu", 0xffffffff, 0x0001, 0x00000000 ),
    gen_rimm_value_test( "addiu", 0xffffffff, 0xffff, 0xfffffffe ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 16, random.randint(0,0xffff) )
    dest = src + sext(imm,32)
    asm_code.append( gen_rimm_value_test( "addiu", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
