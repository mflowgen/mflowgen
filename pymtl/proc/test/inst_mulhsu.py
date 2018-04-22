#=========================================================================
# mulhsu
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
    csrr x2, mngr2proc < 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mulhsu x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

def gen_value_test():
  return [
    # https://github.com/riscv/riscv-tests/blob/master/isa/rv32um/mulhsu.S
    gen_rr_value_test( "mulhsu", 0x00000000, 0x00000000, 0x00000000 ),
    gen_rr_value_test( "mulhsu", 0x00000001, 0x00000001, 0x00000000 ),
    gen_rr_value_test( "mulhsu", 0x00000003, 0x00000007, 0x00000000 ),
    gen_rr_value_test( "mulhsu", 0x00000000, 0xffff8000, 0x00000000 ),
    gen_rr_value_test( "mulhsu", 0x80000000, 0x00000000, 0x00000000 ),
    gen_rr_value_test( "mulhsu", 0x80000000, 0xffff8000, 0x80004000 ),
    gen_rr_value_test( "mulhsu", 0xaaaaaaab, 0x0002fe7d, 0xffff0081 ),
    gen_rr_value_test( "mulhsu", 0x0002fe7d, 0xaaaaaaab, 0x0001fefe ),
    gen_rr_value_test( "mulhsu", 0xff000000, 0xff000000, 0xff010000 ),
    gen_rr_value_test( "mulhsu", 0xffffffff, 0xffffffff, 0xffffffff ),
    gen_rr_value_test( "mulhsu", 0xffffffff, 0x00000001, 0xffffffff ),
    gen_rr_value_test( "mulhsu", 0x00000001, 0xffffffff, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def mulhsu( a, b ):
  return (sext( a, 64 ) * zext( b, 64 ))[32:64]

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = mulhsu( src0, src1 )
    asm_code.append( gen_rr_value_test( "mulhsu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
