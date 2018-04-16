#=========================================================================
# mul_lw
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    csrr x1, mngr2proc < 0x2000  
    nop
    nop
    nop
    nop
    nop
    nop
    lw   x2, 0(x1)              # x2 = [0x2000] = 2
    lw   x3, 0(x1)              # x3 = [0x2000] = 2
    mul  x4, x2, x3             # x4 = x2 * x3 = 4
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x4 > 0x00000004 

    .data                       # The base address is 0x2000
    .word 0x00000002 
  """

def gen_more_test():
  return """

    csrr x1, mngr2proc < 0x3000 # sw address
    csrr x2, mngr2proc < 3      # x2 = 3
    csrr x3, mngr2proc < 4      # x3 = 4
    csrr x4, mngr2proc < 0
    csrr x5, mngr2proc < 0
    csrr x6, mngr2proc < 0
    sw   x2, 0(x1)              # sw 3 to 0x3000
    sw   x3, 4(x1)              # sw 4 to 0x3004
    lw   x5, 0(x1)              # x5 = [0x3000] = 3
    lw   x6, 4(x1)              # x6 = [0x3004] = 4
    mul  x4, x5, x6             # x4 = 3 * 4 = 12
    mul  x5, x4, x5             # x5 = 12 * 3 = 36
    sw   x4, 0(x1)              # sw 12 to 0x3000
    sw   x5, 4(x1)              # sw 36 to 0x3004
    lw   x2, 0(x1)              # x2 = [0x3000] = 12
    lw   x3, 4(x1)              # x3 = [0x3000] = 36
    mul  x6, x2, x3             # x6 = 12 * 36 = 432
    csrw proc2mngr, x2 > 12
    csrw proc2mngr, x3 > 36
    csrw proc2mngr, x4 > 12 
    csrw proc2mngr, x5 > 36
    csrw proc2mngr, x6 > 432
  """
