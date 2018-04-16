#=========================================================================
# xcel
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_asm_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0xdeadbeef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw 0x7e0, x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x2, 0x7e0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x2 > 0xdeadbeef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

#-------------------------------------------------------------------------
# gen_bypass_asm_test
#-------------------------------------------------------------------------

def gen_bypass_test():
  return """

    csrr x2, mngr2proc < 0xdeadbeef
    {nops_3}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_3}
    csrw proc2mngr, x3 > 0xdeadbeef

    csrr x2, mngr2proc < 0xdeadbe00
    {nops_2}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_2}
    csrw proc2mngr, x3 > 0xdeadbe00

    csrr x2, mngr2proc < 0x00adbe00
    {nops_1}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_1}
    csrw proc2mngr, x3 > 0x00adbe00

    csrr x2, mngr2proc < 0xdea00eef
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    csrw proc2mngr, x3 > 0xdea00eef

  """.format(
    nops_3=gen_nops(3),
    nops_2=gen_nops(2),
    nops_1=gen_nops(1)
  )

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():

  asm_code = []
  for i in xrange(50):
    value = random.randint(0,0xffffffff)
    asm_code.append( """

      csrr x2, mngr2proc < {value}
      csrw 0x7e0, x2
      csrr x3, 0x7e0
      csrw proc2mngr, x3 > {value}

    """.format( **locals() ))

  return asm_code

