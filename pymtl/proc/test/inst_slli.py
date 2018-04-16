#=========================================================================
# slli
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x80008000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    slli x3, x1, 0x03
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x00040000
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
    gen_rimm_dest_dep_test( 5, "slli", 0x00000001, 1, 0x00000002 ),
    gen_rimm_dest_dep_test( 4, "slli", 0x00000002, 1, 0x00000004 ),
    gen_rimm_dest_dep_test( 3, "slli", 0x00000004, 1, 0x00000008 ),
    gen_rimm_dest_dep_test( 2, "slli", 0x00000008, 1, 0x00000010 ),
    gen_rimm_dest_dep_test( 1, "slli", 0x00000010, 1, 0x00000020 ),
    gen_rimm_dest_dep_test( 0, "slli", 0x00000020, 1, 0x00000040 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "slli", 0x00000040, 1, 0x00000080 ),
    gen_rimm_src_dep_test( 4, "slli", 0x00000080, 1, 0x00000100 ),
    gen_rimm_src_dep_test( 3, "slli", 0x00000100, 1, 0x00000200 ),
    gen_rimm_src_dep_test( 2, "slli", 0x00000200, 1, 0x00000400 ),
    gen_rimm_src_dep_test( 1, "slli", 0x00000400, 1, 0x00000800 ),
    gen_rimm_src_dep_test( 0, "slli", 0x00000800, 1, 0x00001000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "slli", 0x00001000, 1, 0x00002000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "slli", 0x00000001,  0, 0x00000001 ),
    gen_rimm_value_test( "slli", 0x00000001,  1, 0x00000002 ),
    gen_rimm_value_test( "slli", 0x00000001,  7, 0x00000080 ),
    gen_rimm_value_test( "slli", 0x00000001, 14, 0x00004000 ),
    gen_rimm_value_test( "slli", 0x00000001, 31, 0x80000000 ),

    gen_rimm_value_test( "slli", 0xffffffff,  0, 0xffffffff ),
    gen_rimm_value_test( "slli", 0xffffffff,  1, 0xfffffffe ),
    gen_rimm_value_test( "slli", 0xffffffff,  7, 0xffffff80 ),
    gen_rimm_value_test( "slli", 0xffffffff, 14, 0xffffc000 ),
    gen_rimm_value_test( "slli", 0xffffffff, 31, 0x80000000 ),

    gen_rimm_value_test( "slli", 0x21212121,  0, 0x21212121 ),
    gen_rimm_value_test( "slli", 0x21212121,  1, 0x42424242 ),
    gen_rimm_value_test( "slli", 0x21212121,  7, 0x90909080 ),
    gen_rimm_value_test( "slli", 0x21212121, 14, 0x48484000 ),
    gen_rimm_value_test( "slli", 0x21212121, 31, 0x80000000 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits(  5, random.randint(0,31) )
    dest = src << imm
    asm_code.append( gen_rimm_value_test( "slli", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
