#=========================================================================
# srl
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
    csrr x2, mngr2proc < 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    srl x3, x1, x2
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
    gen_rr_dest_dep_test( 5, "srl", 0x08000000, 1, 0x04000000 ),
    gen_rr_dest_dep_test( 4, "srl", 0x40000000, 1, 0x20000000 ),
    gen_rr_dest_dep_test( 3, "srl", 0x20000000, 1, 0x10000000 ),
    gen_rr_dest_dep_test( 2, "srl", 0x10000000, 1, 0x08000000 ),
    gen_rr_dest_dep_test( 1, "srl", 0x08000000, 1, 0x04000000 ),
    gen_rr_dest_dep_test( 0, "srl", 0x04000000, 1, 0x02000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "srl", 0x02000000, 1, 0x01000000 ),
    gen_rr_src0_dep_test( 4, "srl", 0x01000000, 1, 0x00800000 ),
    gen_rr_src0_dep_test( 3, "srl", 0x00800000, 1, 0x00400000 ),
    gen_rr_src0_dep_test( 2, "srl", 0x00400000, 1, 0x00200000 ),
    gen_rr_src0_dep_test( 1, "srl", 0x00200000, 1, 0x00100000 ),
    gen_rr_src0_dep_test( 0, "srl", 0x00100000, 1, 0x00080000 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "srl", 0x00080000, 1, 0x00040000 ),
    gen_rr_src1_dep_test( 4, "srl", 0x00080000, 2, 0x00020000 ),
    gen_rr_src1_dep_test( 3, "srl", 0x00080000, 3, 0x00010000 ),
    gen_rr_src1_dep_test( 2, "srl", 0x00080000, 4, 0x00008000 ),
    gen_rr_src1_dep_test( 1, "srl", 0x00080000, 5, 0x00004000 ),
    gen_rr_src1_dep_test( 0, "srl", 0x00080000, 6, 0x00002000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "srl", 0x00080000, 1, 0x00040000 ),
    gen_rr_srcs_dep_test( 4, "srl", 0x00040000, 2, 0x00010000 ),
    gen_rr_srcs_dep_test( 3, "srl", 0x00020000, 3, 0x00004000 ),
    gen_rr_srcs_dep_test( 2, "srl", 0x00010000, 4, 0x00001000 ),
    gen_rr_srcs_dep_test( 1, "srl", 0x00008000, 5, 0x00000400 ),
    gen_rr_srcs_dep_test( 0, "srl", 0x00004000, 6, 0x00000100 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "srl", 0x00000080, 1, 0x00000040 ),
    gen_rr_src1_eq_dest_test( "srl", 0x00000040, 1, 0x00000020 ),
    gen_rr_src0_eq_src1_test( "srl", 0x00000003, 0x000000000   ),
    gen_rr_srcs_eq_dest_test( "srl", 0x00000007, 0x000000000   ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "srl", 0x80000000,  0, 0x80000000 ),
    gen_rr_value_test( "srl", 0x80000000,  1, 0x40000000 ),
    gen_rr_value_test( "srl", 0x80000000,  7, 0x01000000 ),
    gen_rr_value_test( "srl", 0x80000000, 14, 0x00020000 ),
    gen_rr_value_test( "srl", 0x80000001, 31, 0x00000001 ),

    gen_rr_value_test( "srl", 0xffffffff,  0, 0xffffffff ),
    gen_rr_value_test( "srl", 0xffffffff,  1, 0x7fffffff ),
    gen_rr_value_test( "srl", 0xffffffff,  7, 0x01ffffff ),
    gen_rr_value_test( "srl", 0xffffffff, 14, 0x0003ffff ),
    gen_rr_value_test( "srl", 0xffffffff, 31, 0x00000001 ),

    gen_rr_value_test( "srl", 0x21212121,  0, 0x21212121 ),
    gen_rr_value_test( "srl", 0x21212121,  1, 0x10909090 ),
    gen_rr_value_test( "srl", 0x21212121,  7, 0x00424242 ),
    gen_rr_value_test( "srl", 0x21212121, 14, 0x00008484 ),
    gen_rr_value_test( "srl", 0x21212121, 31, 0x00000000 ),

    # Verify that shifts only use bottom five bits

    gen_rr_value_test( "srl", 0x21212121, 0xffffffe0, 0x21212121 ),
    gen_rr_value_test( "srl", 0x21212121, 0xffffffe1, 0x10909090 ),
    gen_rr_value_test( "srl", 0x21212121, 0xffffffe7, 0x00424242 ),
    gen_rr_value_test( "srl", 0x21212121, 0xffffffee, 0x00008484 ),
    gen_rr_value_test( "srl", 0x21212121, 0xffffffff, 0x00000000 ),
    gen_rr_value_test( "srl", 0x1ffffff1, 0x00001000, 0x1ffffff1 ),  
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits(  5, random.randint(0,31) )
    dest = src0 >> src1
    asm_code.append( gen_rr_value_test( "srl", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
