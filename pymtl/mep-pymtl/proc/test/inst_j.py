#=========================================================================
# j
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use r3 to track the control flow pattern
    addiu r3, r0, 0

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    j     label_a
    addiu r3, r3, 0b01

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addiu r3, r3, 0b10

    # Only the second bit should be set if jump was taken
    mtc0  r3, proc2mngr > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_jump_test
#-------------------------------------------------------------------------

def gen_jump_test():
  return """

    # Use r3 to track the control flow pattern
    addiu r3, r0, 0

    j     label_a           # j -.
    addiu r3, r3, 0b000001  #    |
                           #    |
  label_b:                 # <--+-.
    addiu r3, r3, 0b000010  #    | |
    j     label_c           # j -+-+-.
    addiu r3, r3, 0b000100  #    | | |
                           #    | | |
  label_a:                 # <--' | |
    addiu r3, r3, 0b001000  #      | |
    j     label_b           # j ---' |
    addiu r3, r3, 0b010000  #        |
                           #        |
  label_c:                 # <------'
    addiu r3, r3, 0b100000  #

    # Only the second bit should be set if jump was taken
    mtc0  r3, proc2mngr > 0b101010

  """

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
    mfc0  r3, mngr2proc < 1
    j     x0
    # send zero if fail
    mtc0  r0, proc2mngr      # don't expect a value
    y0:
    mtc0  r3, proc2mngr > 1
    j     z0
    h0:
    j     y0
    g0:
    j     h0
    f0:
    j     g0
    e0:
    j     f0
    d0:
    j     e0
    c0:
    j     d0
    b0:
    j     c0
    a0:
    j     b0
    x0:
    j     a0
    z0:

    j     x1
    # send zero if fail
    mtc0  r0, proc2mngr      # don't expect a value
    y1:
    mtc0  r3, proc2mngr > 1
    j     z1
    h1:
    j     y1
    g1:
    j     h1
    f1:
    j     g1
    e1:
    j     f1
    d1:
    j     e1
    c1:
    j     d1
    b1:
    j     c1
    a1:
    j     b1
    x1:
    j     a1
    z1:

    j     x2
    # send zero if fail
    mtc0  r0, proc2mngr      # don't expect a value
    y2:
    mtc0  r3, proc2mngr > 1
    j     z2
    h2:
    j     y2
    g2:
    j     h2
    f2:
    j     g2
    e2:
    j     f2
    d2:
    j     e2
    c2:
    j     d2
    b2:
    j     c2
    a2:
    j     b2
    x2:
    j     a2
    z2:

    j     x3
    # send zero if fail
    mtc0  r0, proc2mngr      # don't expect a value
    y3:
    mtc0  r3, proc2mngr > 1
    j     z3
    h3:
    j     y3
    g3:
    j     h3
    f3:
    j     g3
    e3:
    j     f3
    d3:
    j     e3
    c3:
    j     d3
    b3:
    j     c3
    a3:
    j     b3
    x3:
    j     a3
    z3:

    nop
    nop
    nop
    nop
    nop
    nop

  """

#-------------------------------------------------------------------------
# gen_j_after_branch_test
#-------------------------------------------------------------------------

def gen_j_after_branch_test():
  return"""
    mfc0 r1, mngr2proc < 0x2000 # sw address
    mfc0 r2, mngr2proc < 3
    mfc0 r3, mngr2proc < 4
    mfc0 r4, mngr2proc < 12
    mfc0 r5, mngr2proc < 0
    mfc0 r6, mngr2proc < 0

    sw   r2, 0(r1)
    sw   r3, 4(r1)

    lw   r5, 0(r1)
    lw   r6, 4(r1)
    mul  r7, r5, r6
    beq  r7, r4, success0
    j    fail

  success0:

    lw   r5, 0(r1)
    lw   r6, 4(r1)
    mul  r7, r5, r6
    beq  r7, r4, success1
    j    fail

  success1:

    lw   r5, 0(r1)
    lw   r6, 4(r1)
    mul  r7, r5, r6
    beq  r7, r4, success2
    j    fail

    fail:
 
    mtc0 r0, proc2mngr # don't expect a value
    j    end

  success2:

    nop
    nop
    nop
    nop
    nop
    mtc0 r7, proc2mngr > 12
    
  end:

    nop
    nop
    nop
  """

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
