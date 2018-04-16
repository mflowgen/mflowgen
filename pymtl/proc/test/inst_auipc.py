#=========================================================================
# auipc
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    auipc x1, 0x00010                       # PC=0x200
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw  proc2mngr, x1 > 0x00010200
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
    gen_imm_dest_dep_test( 5, "auipc", 0x0001, 0x00001200 ),
    gen_imm_dest_dep_test( 4, "auipc", 0x0002, 0x0000221c ),
    gen_imm_dest_dep_test( 3, "auipc", 0x0003, 0x00003234 ),
    gen_imm_dest_dep_test( 2, "auipc", 0x0004, 0x00004248 ),
    gen_imm_dest_dep_test( 1, "auipc", 0x0005, 0x00005258 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_imm_value_test( "auipc", 0x00000, 0x00000200 ),
    gen_imm_value_test( "auipc", 0xfffff, 0xfffff208 ),
    gen_imm_value_test( "auipc", 0x7ffff, 0x7ffff210 ),
    gen_imm_value_test( "auipc", 0x80000, 0x80000218 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    imm  = Bits( 20, random.randint(0,0xfffff) )
    dest = (zext(imm,32) << 12) + 0x00000200 + (i*8)
    asm_code.append( gen_imm_value_test( "auipc", imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
