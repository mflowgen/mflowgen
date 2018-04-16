#=========================================================================
# srai
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x00008000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    srai x3, x1, 0x03
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x00001000
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
    gen_rimm_dest_dep_test( 5, "srai", 0x08000000, 1, 0x04000000 ),
    gen_rimm_dest_dep_test( 4, "srai", 0x40000000, 1, 0x20000000 ),
    gen_rimm_dest_dep_test( 3, "srai", 0x20000000, 1, 0x10000000 ),
    gen_rimm_dest_dep_test( 2, "srai", 0x10000000, 1, 0x08000000 ),
    gen_rimm_dest_dep_test( 1, "srai", 0x08000000, 1, 0x04000000 ),
    gen_rimm_dest_dep_test( 0, "srai", 0x04000000, 1, 0x02000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "srai", 0x02000000, 1, 0x01000000 ),
    gen_rimm_src_dep_test( 4, "srai", 0x01000000, 1, 0x00800000 ),
    gen_rimm_src_dep_test( 3, "srai", 0x00800000, 1, 0x00400000 ),
    gen_rimm_src_dep_test( 2, "srai", 0x00400000, 1, 0x00200000 ),
    gen_rimm_src_dep_test( 1, "srai", 0x00200000, 1, 0x00100000 ),
    gen_rimm_src_dep_test( 0, "srai", 0x00100000, 1, 0x00080000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "srai", 0x00800000, 1, 0x00400000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "srai", 0x80000000,  0, 0x80000000 ),
    gen_rimm_value_test( "srai", 0x80000000,  1, 0xc0000000 ),
    gen_rimm_value_test( "srai", 0x80000000,  7, 0xff000000 ),
    gen_rimm_value_test( "srai", 0x80000000, 14, 0xfffe0000 ),
    gen_rimm_value_test( "srai", 0x80000001, 31, 0xffffffff ),

    gen_rimm_value_test( "srai", 0x7fffffff,  0, 0x7fffffff ),
    gen_rimm_value_test( "srai", 0x7fffffff,  1, 0x3fffffff ),
    gen_rimm_value_test( "srai", 0x7fffffff,  7, 0x00ffffff ),
    gen_rimm_value_test( "srai", 0x7fffffff, 14, 0x0001ffff ),
    gen_rimm_value_test( "srai", 0x7fffffff, 31, 0x00000000 ),

    gen_rimm_value_test( "srai", 0x81818181,  0, 0x81818181 ),
    gen_rimm_value_test( "srai", 0x81818181,  1, 0xc0c0c0c0 ),
    gen_rimm_value_test( "srai", 0x81818181,  7, 0xff030303 ),
    gen_rimm_value_test( "srai", 0x81818181, 14, 0xfffe0606 ),
    gen_rimm_value_test( "srai", 0x81818181, 31, 0xffffffff ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits(  5, random.randint(0,31) )
    dest = Bits( 32, src.int() >> imm.uint() )
    asm_code.append( gen_rimm_value_test( "srai", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
