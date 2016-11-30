#=========================================================================
# xori
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xori r3, r1, 0x00ff
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr >0x0f0f0ff0
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
    gen_rimm_dest_byp_test( 5, "xori", 0x00000f0f, 0x00ff, 0x00000ff0 ),
    gen_rimm_dest_byp_test( 4, "xori", 0x0000f0f0, 0x0ff0, 0x0000ff00 ),
    gen_rimm_dest_byp_test( 3, "xori", 0x00000f0f, 0xff00, 0x0000f00f ),
    gen_rimm_dest_byp_test( 2, "xori", 0x0000f0f0, 0xf00f, 0x000000ff ),
    gen_rimm_dest_byp_test( 1, "xori", 0x00000f0f, 0x00ff, 0x00000ff0 ),
    gen_rimm_dest_byp_test( 0, "xori", 0x0000f0f0, 0x0ff0, 0x0000ff00 ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_rimm_src_byp_test( 5, "xori", 0x00000f0f, 0x00ff, 0x00000ff0 ),
    gen_rimm_src_byp_test( 4, "xori", 0x0000f0f0, 0x0ff0, 0x0000ff00 ),
    gen_rimm_src_byp_test( 3, "xori", 0x00000f0f, 0xff00, 0x0000f00f ),
    gen_rimm_src_byp_test( 2, "xori", 0x0000f0f0, 0xf00f, 0x000000ff ),
    gen_rimm_src_byp_test( 1, "xori", 0x00000f0f, 0x00ff, 0x00000ff0 ),
    gen_rimm_src_byp_test( 0, "xori", 0x0000f0f0, 0x0ff0, 0x0000ff00 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "xori", 0x00000f0f, 0xff00, 0x0000f00f ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_rimm_value_test( "xori", 0xff00ff00, 0x0f0f, 0xff00f00f ),
    gen_rimm_value_test( "xori", 0x0ff00ff0, 0xf0f0, 0x0ff0ff00 ),
    gen_rimm_value_test( "xori", 0x00ff00ff, 0x0f0f, 0x00ff0ff0 ),
    gen_rimm_value_test( "xori", 0xf00ff00f, 0xf0f0, 0xf00f00ff ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 16, random.randint(0,0xffff) )
    dest = src ^ zext(imm,32)
    asm_code.append( gen_rimm_value_test( "xori", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
