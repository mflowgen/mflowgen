#=========================================================================
# lui
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    lui x1, 0x0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x1 > 0x00001000
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
    gen_imm_dest_dep_test( 5, "lui", 0x0001, 0x00001000 ),
    gen_imm_dest_dep_test( 4, "lui", 0x0002, 0x00002000 ),
    gen_imm_dest_dep_test( 3, "lui", 0x0003, 0x00003000 ),
    gen_imm_dest_dep_test( 2, "lui", 0x0004, 0x00004000 ),
    gen_imm_dest_dep_test( 1, "lui", 0x0005, 0x00005000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_imm_value_test( "lui", 0x00000, 0x00000000 ),
    gen_imm_value_test( "lui", 0xfffff, 0xfffff000 ),
    gen_imm_value_test( "lui", 0x7ffff, 0x7ffff000 ),
    gen_imm_value_test( "lui", 0x80000, 0x80000000 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    imm  = Bits( 20, random.randint(0,0xfffff) )
    dest = zext(imm,32) << 12
    asm_code.append( gen_imm_value_test( "lui", imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
