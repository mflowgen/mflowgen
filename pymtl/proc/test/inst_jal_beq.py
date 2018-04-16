#=========================================================================
# jal_beq
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------
# Tests that there are no problems when a jal instruction follows 
# immediately after a beq instruction. As there is no branch delay slot,
# the jal instruction should not be executed. 

def gen_basic_test():
  return """

    csrr x1, mngr2proc < 0x2000 # sw address
    csrr x2, mngr2proc < 3
    csrr x3, mngr2proc < 4
    csrr x4, mngr2proc < 12
    csrr x5, mngr2proc < 0
    csrr x6, mngr2proc < 0
    sw   x2, 0(x1)
    sw   x3, 4(x1)
    lw   x5, 0(x1)
    lw   x6, 4(x1)
    mul  x7, x5, x6
    beq  x7, x4, success0
    jal  x0, fail

  success0:
    lw   x5, 0(x1)
    lw   x6, 4(x1)
    mul  x7, x5, x6
    beq  x7, x4, success1
    jal  x0, fail

  success1:
    lw   x5, 0(x1)
    lw   x6, 4(x1)
    mul  x7, x5, x6
    beq  x7, x4, success2
    jal  x0, fail
  
  fail:
    csrw proc2mngr, x0 # don't expect a value
    jal  x0, end

  success2:
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x7 > 12
    
  end:
    nop
    nop
    nop
  """
