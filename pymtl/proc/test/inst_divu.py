#=========================================================================
# divu
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
    divu x3, x1, x2
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

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # https://github.com/riscv/riscv-tests/blob/master/isa/rv32um/divu.S
    gen_rr_value_test( "divu", 20,      6,    3         ),
    gen_rr_value_test( "divu", -20,     6,    715827879 ),
    gen_rr_value_test( "divu", 20,      -6 ,  0         ),
    gen_rr_value_test( "divu", -20,     -6,   0         ),
    gen_rr_value_test( "divu", -1<<31,  1,    -1<<31    ),
    gen_rr_value_test( "divu", -1<<31,  -1,   0         ),
    gen_rr_value_test( "divu", -1<<31,  0,    -1        ),
    gen_rr_value_test( "divu", -1,      0,    -1        ),
    gen_rr_value_test( "divu", 1,       0,    -1        ),
    gen_rr_value_test( "divu", 0,       0,    -1        ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def divu( a, b ):
  a, b = a.uint(), b.uint()
  if b == 0:
    return Bits( 32, -1 )
  else:
    return Bits( 32, a/b )

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, divu( src0, src1 ) )
    asm_code.append( gen_rr_value_test( "divu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
