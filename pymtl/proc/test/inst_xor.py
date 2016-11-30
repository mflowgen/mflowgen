#=========================================================================
# xor
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
    mfc0 r1, mngr2proc < 0x0f0f0f0f
    mfc0 r2, mngr2proc < 0x00ff00ff
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xor r3, r1, r2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 0x0ff00ff0
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
    gen_rr_dest_byp_test( 5, "xor", 0x00000f0f, 0x000000ff, 0x00000ff0 ),
    gen_rr_dest_byp_test( 4, "xor", 0x0000f0f0, 0x00000ff0, 0x0000ff00 ),
    gen_rr_dest_byp_test( 3, "xor", 0x000f0f00, 0x0000ff00, 0x000ff000 ),
    gen_rr_dest_byp_test( 2, "xor", 0x00f0f000, 0x000ff000, 0x00ff0000 ),
    gen_rr_dest_byp_test( 1, "xor", 0x0f0f0000, 0x00ff0000, 0x0ff00000 ),
    gen_rr_dest_byp_test( 0, "xor", 0xf0f00000, 0x0ff00000, 0xff000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_byp_test
#-------------------------------------------------------------------------

def gen_src0_byp_test():
  return [
    gen_rr_src0_byp_test( 5, "xor", 0x0f00000f, 0xff000000, 0xf000000f ),
    gen_rr_src0_byp_test( 4, "xor", 0xf00000f0, 0xf000000f, 0x000000ff ),
    gen_rr_src0_byp_test( 3, "xor", 0x00000f0f, 0x000000ff, 0x00000ff0 ),
    gen_rr_src0_byp_test( 2, "xor", 0x0000f0f0, 0x00000ff0, 0x0000ff00 ),
    gen_rr_src0_byp_test( 1, "xor", 0x000f0f00, 0x0000ff00, 0x000ff000 ),
    gen_rr_src0_byp_test( 0, "xor", 0x00f0f000, 0x000ff000, 0x00ff0000 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_test
#-------------------------------------------------------------------------

def gen_src1_byp_test():
  return [
    gen_rr_src1_byp_test( 5, "xor", 0x0f0f0000, 0x00ff0000, 0x0ff00000 ),
    gen_rr_src1_byp_test( 4, "xor", 0xf0f00000, 0x0ff00000, 0xff000000 ),
    gen_rr_src1_byp_test( 3, "xor", 0x0f00000f, 0xff000000, 0xf000000f ),
    gen_rr_src1_byp_test( 2, "xor", 0xf00000f0, 0xf000000f, 0x000000ff ),
    gen_rr_src1_byp_test( 1, "xor", 0x00000f0f, 0x000000ff, 0x00000ff0 ),
    gen_rr_src1_byp_test( 0, "xor", 0x0000f0f0, 0x00000ff0, 0x0000ff00 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_test
#-------------------------------------------------------------------------

def gen_srcs_byp_test():
  return [
    gen_rr_srcs_byp_test( 5, "xor", 0x000f0f00, 0x0000ff00, 0x000ff000 ),
    gen_rr_srcs_byp_test( 4, "xor", 0x00f0f000, 0x000ff000, 0x00ff0000 ),
    gen_rr_srcs_byp_test( 3, "xor", 0x0f0f0000, 0x00ff0000, 0x0ff00000 ),
    gen_rr_srcs_byp_test( 2, "xor", 0xf0f00000, 0x0ff00000, 0xff000000 ),
    gen_rr_srcs_byp_test( 1, "xor", 0x0f00000f, 0xff000000, 0xf000000f ),
    gen_rr_srcs_byp_test( 0, "xor", 0xf00000f0, 0xf000000f, 0x000000ff ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "xor", 0x00000f0f, 0x000000ff, 0x00000ff0 ),
    gen_rr_src1_eq_dest_test( "xor", 0x0000f0f0, 0x00000ff0, 0x0000ff00 ),
    gen_rr_src0_eq_src1_test( "xor", 0x000f0f00, 0x00000000 ),
    gen_rr_srcs_eq_dest_test( "xor", 0x000f0f00, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_rr_value_test( "xor", 0xff00ff00, 0x0f0f0f0f, 0xf00ff00f ),
    gen_rr_value_test( "xor", 0x0ff00ff0, 0xf0f0f0f0, 0xff00ff00 ),
    gen_rr_value_test( "xor", 0x00ff00ff, 0x0f0f0f0f, 0x0ff00ff0 ),
    gen_rr_value_test( "xor", 0xf00ff00f, 0xf0f0f0f0, 0x00ff00ff ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = src0 ^ src1
    asm_code.append( gen_rr_value_test( "xor", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
