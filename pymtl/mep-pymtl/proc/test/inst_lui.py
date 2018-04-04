#=========================================================================
# lui
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
    lui r1, 0x0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r1, proc2mngr > 0x00010000
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
    gen_imm_dest_byp_test( 5, "lui", 0x0001, 0x00010000 ),
    gen_imm_dest_byp_test( 4, "lui", 0x0002, 0x00020000 ),
    gen_imm_dest_byp_test( 3, "lui", 0x0003, 0x00030000 ),
    gen_imm_dest_byp_test( 2, "lui", 0x0004, 0x00040000 ),
    gen_imm_dest_byp_test( 1, "lui", 0x0005, 0x00050000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_imm_value_test( "lui", 0x0000, 0x00000000 ),
    gen_imm_value_test( "lui", 0xffff, 0xffff0000 ),
    gen_imm_value_test( "lui", 0x7fff, 0x7fff0000 ),
    gen_imm_value_test( "lui", 0x8000, 0x80000000 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    imm  = Bits( 16, random.randint(0,0xffff) )
    dest = zext(imm,32) << 16
    asm_code.append( gen_imm_value_test( "lui", imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
