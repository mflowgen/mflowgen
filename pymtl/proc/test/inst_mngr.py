#=========================================================================
# mngr
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
    mfc0 r2, mngr2proc < 1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r2, proc2mngr > 1
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
    mfc0 r2, mngr2proc < 0xdeadbeef
    {nops_3}
    mtc0 r2, proc2mngr > 0xdeadbeef

    mfc0 r2, mngr2proc < 0x00000eef
    {nops_2}
    mtc0 r2, proc2mngr > 0x00000eef

    mfc0 r2, mngr2proc < 0xdeadbee0
    {nops_1}
    mtc0 r2, proc2mngr > 0xdeadbee0

    mfc0 r2, mngr2proc < 0xde000eef
    mtc0 r2, proc2mngr > 0xde000eef


    mfc0 r2, mngr2proc < 0xdeadbeef
    mtc0 r2, proc2mngr > 0xdeadbeef
    mfc0 r1, mngr2proc < 0xcafecafe
    mtc0 r1, proc2mngr > 0xcafecafe
  """.format(
    nops_3=gen_nops(3),
    nops_2=gen_nops(2),
    nops_1=gen_nops(1)
  )

#-------------------------------------------------------------------------
# gen_value_asm_test
#-------------------------------------------------------------------------

def gen_value_test():
  return """
    mtc0 r0, proc2mngr > 0x00000000 # test r0 is always 0
    mfc0 r0, mngr2proc < 0xabcabcff # even if we try to write r0
    mtc0 r0, proc2mngr > 0x00000000
  """

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():

  asm_code = []
  for i in xrange(100):
    value = random.randint(0,0xffffffff)
    asm_code.append( """

      mfc0 r1, mngr2proc < {value}
      mtc0 r1, proc2mngr > {value}

    """.format( **locals() ))

  return asm_code

