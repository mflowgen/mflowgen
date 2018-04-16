#=========================================================================
# sra
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
    sra x3, x1, x2
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
    gen_rr_dest_dep_test( 5, "sra", 0x08000000, 1, 0x04000000 ),
    gen_rr_dest_dep_test( 4, "sra", 0x40000000, 1, 0x20000000 ),
    gen_rr_dest_dep_test( 3, "sra", 0x20000000, 1, 0x10000000 ),
    gen_rr_dest_dep_test( 2, "sra", 0x10000000, 1, 0x08000000 ),
    gen_rr_dest_dep_test( 1, "sra", 0x08000000, 1, 0x04000000 ),
    gen_rr_dest_dep_test( 0, "sra", 0x04000000, 1, 0x02000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "sra", 0x02000000, 1, 0x01000000 ),
    gen_rr_src0_dep_test( 4, "sra", 0x01000000, 1, 0x00800000 ),
    gen_rr_src0_dep_test( 3, "sra", 0x00800000, 1, 0x00400000 ),
    gen_rr_src0_dep_test( 2, "sra", 0x00400000, 1, 0x00200000 ),
    gen_rr_src0_dep_test( 1, "sra", 0x00200000, 1, 0x00100000 ),
    gen_rr_src0_dep_test( 0, "sra", 0x00100000, 1, 0x00080000 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "sra", 0x00080000, 1, 0x00040000 ),
    gen_rr_src1_dep_test( 4, "sra", 0x00080000, 2, 0x00020000 ),
    gen_rr_src1_dep_test( 3, "sra", 0x00080000, 3, 0x00010000 ),
    gen_rr_src1_dep_test( 2, "sra", 0x00080000, 4, 0x00008000 ),
    gen_rr_src1_dep_test( 1, "sra", 0x00080000, 5, 0x00004000 ),
    gen_rr_src1_dep_test( 0, "sra", 0x00080000, 6, 0x00002000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "sra", 0x00080000, 1, 0x00040000 ),
    gen_rr_srcs_dep_test( 4, "sra", 0x00040000, 2, 0x00010000 ),
    gen_rr_srcs_dep_test( 3, "sra", 0x00020000, 3, 0x00004000 ),
    gen_rr_srcs_dep_test( 2, "sra", 0x00010000, 4, 0x00001000 ),
    gen_rr_srcs_dep_test( 1, "sra", 0x00008000, 5, 0x00000400 ),
    gen_rr_srcs_dep_test( 0, "sra", 0x00004000, 6, 0x00000100 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sra", 0x00000080, 1, 0x00000040 ),
    gen_rr_src1_eq_dest_test( "sra", 0x00000040, 1, 0x00000020 ),
    gen_rr_src0_eq_src1_test( "sra", 0x00000003, 0x000000000 ),
    gen_rr_srcs_eq_dest_test( "sra", 0x00000007, 0x000000000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rr_value_test( "sra", 0x80000000,  0, 0x80000000 ),
    gen_rr_value_test( "sra", 0x80000000,  1, 0xc0000000 ),
    gen_rr_value_test( "sra", 0x80000000,  7, 0xff000000 ),
    gen_rr_value_test( "sra", 0x80000000, 14, 0xfffe0000 ),
    gen_rr_value_test( "sra", 0x80000001, 31, 0xffffffff ),

    gen_rr_value_test( "sra", 0x7fffffff,  0, 0x7fffffff ),
    gen_rr_value_test( "sra", 0x7fffffff,  1, 0x3fffffff ),
    gen_rr_value_test( "sra", 0x7fffffff,  7, 0x00ffffff ),
    gen_rr_value_test( "sra", 0x7fffffff, 14, 0x0001ffff ),
    gen_rr_value_test( "sra", 0x7fffffff, 31, 0x00000000 ),

    gen_rr_value_test( "sra", 0x81818181,  0, 0x81818181 ),
    gen_rr_value_test( "sra", 0x81818181,  1, 0xc0c0c0c0 ),
    gen_rr_value_test( "sra", 0x81818181,  7, 0xff030303 ),
    gen_rr_value_test( "sra", 0x81818181, 14, 0xfffe0606 ),
    gen_rr_value_test( "sra", 0x81818181, 31, 0xffffffff ),

    # Verify that shifts only use bottom five bits

    gen_rr_value_test( "sra", 0x81818181, 0xffffffe0, 0x81818181 ),
    gen_rr_value_test( "sra", 0x81818181, 0xffffffe1, 0xc0c0c0c0 ),
    gen_rr_value_test( "sra", 0x81818181, 0xffffffe7, 0xff030303 ),
    gen_rr_value_test( "sra", 0x81818181, 0xffffffee, 0xfffe0606 ),
    gen_rr_value_test( "sra", 0x81818181, 0xffffffff, 0xffffffff ),
    gen_rr_value_test( "sra", 0x1ffffff1, 0x00001000, 0x1ffffff1 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits(  5, random.randint(0,31) )
    dest = Bits( 32, src0.int() >> src1.uint() )
    asm_code.append( gen_rr_value_test( "sra", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
