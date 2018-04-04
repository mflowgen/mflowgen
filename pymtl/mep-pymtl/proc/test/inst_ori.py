#=========================================================================
# ori
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
    ori r3, r1, 0x00ff
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr >0x0f0f0fff
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
    gen_rimm_dest_byp_test( 5, "ori", 0x00000f0f, 0x00ff, 0x00000fff ),
    gen_rimm_dest_byp_test( 4, "ori", 0x0000f0f0, 0x0ff0, 0x0000fff0 ),
    gen_rimm_dest_byp_test( 3, "ori", 0x00000f0f, 0xff00, 0x0000ff0f ),
    gen_rimm_dest_byp_test( 2, "ori", 0x0000f0f0, 0xf00f, 0x0000f0ff ),
    gen_rimm_dest_byp_test( 1, "ori", 0x00000f0f, 0x00ff, 0x00000fff ),
    gen_rimm_dest_byp_test( 0, "ori", 0x0000f0f0, 0x0ff0, 0x0000fff0 ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_rimm_src_byp_test( 5, "ori", 0x00000f0f, 0x00ff, 0x00000fff ),
    gen_rimm_src_byp_test( 4, "ori", 0x0000f0f0, 0x0ff0, 0x0000fff0 ),
    gen_rimm_src_byp_test( 3, "ori", 0x00000f0f, 0xff00, 0x0000ff0f ),
    gen_rimm_src_byp_test( 2, "ori", 0x0000f0f0, 0xf00f, 0x0000f0ff ),
    gen_rimm_src_byp_test( 1, "ori", 0x00000f0f, 0x00ff, 0x00000fff ),
    gen_rimm_src_byp_test( 0, "ori", 0x0000f0f0, 0x0ff0, 0x0000fff0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "ori", 0x00000f0f, 0xff00, 0x0000ff0f ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_rimm_value_test( "ori", 0xff00ff00, 0x0f0f, 0xff00ff0f ),
    gen_rimm_value_test( "ori", 0x0ff00ff0, 0xf0f0, 0x0ff0fff0 ),
    gen_rimm_value_test( "ori", 0x00ff00ff, 0x0f0f, 0x00ff0fff ),
    gen_rimm_value_test( "ori", 0xf00ff00f, 0xf0f0, 0xf00ff0ff ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 16, random.randint(0,0xffff) )
    dest = src | zext(imm,32)
    asm_code.append( gen_rimm_value_test( "ori", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
