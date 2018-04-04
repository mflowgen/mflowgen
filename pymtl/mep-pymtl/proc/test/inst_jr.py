#=========================================================================
# jr
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

    lui   r1,     %hi[label_a]
    ori   r1, r0, %lo[label_a]
    jr    r1
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
# gen_src_byp_test
#-------------------------------------------------------------------------

def gen_src_byp_test():
  return [
    gen_jr_src_byp_test( 5 ),
    gen_jr_src_byp_test( 4 ),
    gen_jr_src_byp_test( 3 ),
    gen_jr_src_byp_test( 2 ),
    gen_jr_src_byp_test( 1 ),
    gen_jr_src_byp_test( 0 ),
  ]

#-------------------------------------------------------------------------
# gen_jump_test
#-------------------------------------------------------------------------

def gen_jump_test():
  return """

    # Use r3 to track the control flow pattern
    addiu r3, r0, 0

    lui   r1,     %hi[label_a]
    ori   r1, r0, %lo[label_a]
    jr    r1                   # j -.
                               #    |
    addiu r3, r3, 0b000001     #    |
                               #    |
  label_b:                     # <--+-.
    addiu r3, r3, 0b000010     #    | |
                               #    | |
    lui   r1,     %hi[label_c] #    | |
    ori   r1, r0, %lo[label_c] #    | |
    jr    r1                   # j -+-+-.
                               #    | | |
    addiu r3, r3, 0b000100     #    | | |
                               #    | | |
  label_a:                     # <--' | |
    addiu r3, r3, 0b001000     #      | |
                               #      | |
    lui   r1,     %hi[label_b] #      | |
    ori   r1, r0, %lo[label_b] #      | |
    jr    r1                   # j ---' |
                               #        |
    addiu r3, r3, 0b010000     #        |
                               #        |
  label_c:                     # <------'
    addiu r3, r3, 0b100000     #

    # Only the second bit should be set if jump was taken
    mtc0  r3, proc2mngr > 0b101010

  """

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
