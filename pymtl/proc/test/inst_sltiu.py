#=========================================================================
# sltiu
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sltiu x3, x1, 6
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 1
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
    gen_rimm_dest_dep_test( 5, "sltiu",  1, 0, 0 ),
    gen_rimm_dest_dep_test( 4, "sltiu",  1, 1, 0 ),
    gen_rimm_dest_dep_test( 3, "sltiu",  0, 1, 1 ),
    gen_rimm_dest_dep_test( 2, "sltiu",  2, 1, 0 ),
    gen_rimm_dest_dep_test( 1, "sltiu",  2, 2, 0 ),
    gen_rimm_dest_dep_test( 0, "sltiu",  1, 2, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "sltiu",  3, 2, 0 ),
    gen_rimm_src_dep_test( 4, "sltiu",  3, 3, 0 ),
    gen_rimm_src_dep_test( 3, "sltiu",  2, 3, 1 ),
    gen_rimm_src_dep_test( 2, "sltiu",  4, 3, 0 ),
    gen_rimm_src_dep_test( 1, "sltiu",  4, 4, 0 ),
    gen_rimm_src_dep_test( 0, "sltiu",  3, 4, 1 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "sltiu",  9, 8, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_rimm_value_test( "sltiu", 0x00000000, 0x000, 0 ),
    gen_rimm_value_test( "sltiu", 0x00000001, 0x001, 0 ),
    gen_rimm_value_test( "sltiu", 0x00000003, 0x007, 1 ),
    gen_rimm_value_test( "sltiu", 0x00000007, 0x003, 0 ),

    gen_rimm_value_test( "sltiu", 0x00000000, 0x800, 1 ),
    gen_rimm_value_test( "sltiu", 0x80000000, 0x000, 0 ),
    gen_rimm_value_test( "sltiu", 0x80000000, 0x800, 1 ),

    gen_rimm_value_test( "sltiu", 0x00000000, 0x7ff, 1 ),
    gen_rimm_value_test( "sltiu", 0x7fffffff, 0x000, 0 ),
    gen_rimm_value_test( "sltiu", 0x7fffffff, 0x7ff, 0 ),

    gen_rimm_value_test( "sltiu", 0x80000000, 0x7ff, 0 ),
    gen_rimm_value_test( "sltiu", 0x7fffffff, 0x800, 1 ),

    gen_rimm_value_test( "sltiu", 0x00000000, 0xfff, 1 ),
    gen_rimm_value_test( "sltiu", 0xffffffff, 0x001, 0 ),
    gen_rimm_value_test( "sltiu", 0xffffffff, 0xfff, 0 ),
    
    #specifically test if this is a unsigned comparison
    gen_rimm_value_test( "sltiu", 0x00000001, 0xfff, 1 ),
    gen_rimm_value_test( "sltiu", 0xffffffff, 0x001, 0 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 12, random.randint(0,0xfff) )
    dest = Bits( 32, src < sext(imm,32) )
    asm_code.append( gen_rimm_value_test( "sltiu", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
