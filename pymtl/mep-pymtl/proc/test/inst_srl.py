#=========================================================================
# srl
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
    mfc0 r1, mngr2proc < 0x00008000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    srl r3, r1, 0x03
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 0x00001000
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
    gen_rimm_dest_byp_test( 5, "srl", 0x08000000, 1, 0x04000000 ),
    gen_rimm_dest_byp_test( 4, "srl", 0x40000000, 1, 0x20000000 ),
    gen_rimm_dest_byp_test( 3, "srl", 0x20000000, 1, 0x10000000 ),
    gen_rimm_dest_byp_test( 2, "srl", 0x10000000, 1, 0x08000000 ),
    gen_rimm_dest_byp_test( 1, "srl", 0x08000000, 1, 0x04000000 ),
    gen_rimm_dest_byp_test( 0, "srl", 0x04000000, 1, 0x02000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_rimm_src_byp_test( 5, "srl", 0x02000000, 1, 0x01000000 ),
    gen_rimm_src_byp_test( 4, "srl", 0x01000000, 1, 0x00800000 ),
    gen_rimm_src_byp_test( 3, "srl", 0x00800000, 1, 0x00400000 ),
    gen_rimm_src_byp_test( 2, "srl", 0x00400000, 1, 0x00200000 ),
    gen_rimm_src_byp_test( 1, "srl", 0x00200000, 1, 0x00100000 ),
    gen_rimm_src_byp_test( 0, "srl", 0x00100000, 1, 0x00080000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "srl", 0x00800000, 1, 0x00400000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "srl", 0x80000000,  0, 0x80000000 ),
    gen_rimm_value_test( "srl", 0x80000000,  1, 0x40000000 ),
    gen_rimm_value_test( "srl", 0x80000000,  7, 0x01000000 ),
    gen_rimm_value_test( "srl", 0x80000000, 14, 0x00020000 ),
    gen_rimm_value_test( "srl", 0x80000001, 31, 0x00000001 ),

    gen_rimm_value_test( "srl", 0xffffffff,  0, 0xffffffff ),
    gen_rimm_value_test( "srl", 0xffffffff,  1, 0x7fffffff ),
    gen_rimm_value_test( "srl", 0xffffffff,  7, 0x01ffffff ),
    gen_rimm_value_test( "srl", 0xffffffff, 14, 0x0003ffff ),
    gen_rimm_value_test( "srl", 0xffffffff, 31, 0x00000001 ),

    gen_rimm_value_test( "srl", 0x21212121,  0, 0x21212121 ),
    gen_rimm_value_test( "srl", 0x21212121,  1, 0x10909090 ),
    gen_rimm_value_test( "srl", 0x21212121,  7, 0x00424242 ),
    gen_rimm_value_test( "srl", 0x21212121, 14, 0x00008484 ),
    gen_rimm_value_test( "srl", 0x21212121, 31, 0x00000000 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits(  5, random.randint(0,31) )
    dest = src >> imm
    asm_code.append( gen_rimm_value_test( "srl", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
