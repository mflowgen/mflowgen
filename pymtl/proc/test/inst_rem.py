#=========================================================================
# rem
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
    rem x3, x1, x2
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
    # https://github.com/riscv/riscv-tests/blob/master/isa/rv32um/rem.S
    gen_rr_value_test( "rem", 20,      6,    2       ),
    gen_rr_value_test( "rem", -20,     6,    -2      ),
    gen_rr_value_test( "rem", 20,      -6,   2       ),
    gen_rr_value_test( "rem", -20,     -6,   -2      ),
    gen_rr_value_test( "rem", -1<<31,  1,    0       ),
    gen_rr_value_test( "rem", -1<<31,  -1,   0       ),
    gen_rr_value_test( "rem", -1<<31,  0,    -1<<31  ),
    gen_rr_value_test( "rem", -1,      0,    -1      ),
    gen_rr_value_test( "rem", 1,       0,    1       ),
    gen_rr_value_test( "rem", 0,       0,    0       ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def rem( a, b ):
  a, b = a.int(), b.int()
  if b == 0:
    return Bits( 32, a )
  else:
    res = abs(a) % abs(b)
    if a<0: res = -res 
    return Bits( 32, res )

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, rem( src0, src1 ) )
    asm_code.append( gen_rr_value_test( "rem", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
