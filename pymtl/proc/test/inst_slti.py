#=========================================================================
# slti
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    slti r3, r1, 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 0
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
    gen_rimm_dest_byp_test( 5, "slti",  1, 0, 0 ),
    gen_rimm_dest_byp_test( 4, "slti",  1, 1, 0 ),
    gen_rimm_dest_byp_test( 3, "slti",  0, 1, 1 ),
    gen_rimm_dest_byp_test( 2, "slti",  2, 1, 0 ),
    gen_rimm_dest_byp_test( 1, "slti",  2, 2, 0 ),
    gen_rimm_dest_byp_test( 0, "slti",  1, 2, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_rimm_src_byp_test( 5, "slti",  3, 2, 0 ),
    gen_rimm_src_byp_test( 4, "slti",  3, 3, 0 ),
    gen_rimm_src_byp_test( 3, "slti",  2, 3, 1 ),
    gen_rimm_src_byp_test( 2, "slti",  4, 3, 0 ),
    gen_rimm_src_byp_test( 1, "slti",  4, 4, 0 ),
    gen_rimm_src_byp_test( 0, "slti",  3, 4, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "slti",  9, 8, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "slti", 0x00000000, 0x0000, 0 ),
    gen_rimm_value_test( "slti", 0x00000001, 0x0001, 0 ),
    gen_rimm_value_test( "slti", 0x00000003, 0x0007, 1 ),
    gen_rimm_value_test( "slti", 0x00000007, 0x0003, 0 ),

    gen_rimm_value_test( "slti", 0x00000000, 0x8000, 0 ),
    gen_rimm_value_test( "slti", 0x80000000, 0x0000, 1 ),
    gen_rimm_value_test( "slti", 0x80000000, 0x8000, 1 ),

    gen_rimm_value_test( "slti", 0x00000000, 0x7fff, 1 ),
    gen_rimm_value_test( "slti", 0x7fffffff, 0x0000, 0 ),
    gen_rimm_value_test( "slti", 0x7fffffff, 0x7fff, 0 ),

    gen_rimm_value_test( "slti", 0x80000000, 0x7fff, 1 ),
    gen_rimm_value_test( "slti", 0x7fffffff, 0x8000, 0 ),

    gen_rimm_value_test( "slti", 0x00000000, 0xffff, 0 ),
    gen_rimm_value_test( "slti", 0xffffffff, 0x0001, 1 ),
    gen_rimm_value_test( "slti", 0xffffffff, 0xffff, 0 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 16, random.randint(0,0xffff) )
    dest = Bits( 32, src.int() < sext(imm,32).int() )
    asm_code.append( gen_rimm_value_test( "slti", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
