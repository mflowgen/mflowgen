#=========================================================================
# bltz
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

    mfc0  r1, mngr2proc < -1

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    # This branch should be taken
    bltz  r1, label_a
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

    # Only the second bit should be set if branch was taken
    mtc0  r3, proc2mngr > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_src_byp_taken_test
#-------------------------------------------------------------------------

def gen_src_byp_taken_test():
  return [
    gen_br1_src_byp_test( 5, "bltz", -1, True ),
    gen_br1_src_byp_test( 4, "bltz", -2, True ),
    gen_br1_src_byp_test( 3, "bltz", -3, True ),
    gen_br1_src_byp_test( 2, "bltz", -4, True ),
    gen_br1_src_byp_test( 1, "bltz", -5, True ),
    gen_br1_src_byp_test( 0, "bltz", -6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_nottaken_test
#-------------------------------------------------------------------------

def gen_src_byp_nottaken_test():
  return [
    gen_br1_src_byp_test( 5, "bltz", 1, False ),
    gen_br1_src_byp_test( 4, "bltz", 2, False ),
    gen_br1_src_byp_test( 3, "bltz", 3, False ),
    gen_br1_src_byp_test( 2, "bltz", 4, False ),
    gen_br1_src_byp_test( 1, "bltz", 5, False ),
    gen_br1_src_byp_test( 0, "bltz", 6, False ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_br1_value_test( "bltz", -1, True  ),
    gen_br1_value_test( "bltz",  0, False ),
    gen_br1_value_test( "bltz",  1, False ),

    gen_br1_value_test( "bltz", 0xfffffff7, True  ),
    gen_br1_value_test( "bltz", 0x7fffffff, False ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(25):
    src   = Bits( 32, random.randint(0,0xffffffff) )
    taken = ( src.int() < 0 )
    asm_code.append( gen_br1_value_test( "bltz", src.uint(), taken ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
     # Test backwards walk (back to back branch taken)

     mfc0   r3,  mngr2proc < -1
     mfc0   r1,  mngr2proc < 1

     bltz   r3,  x0
     mtc0   r0,  proc2mngr
     nop
     a0:
     mtc0   r1,  proc2mngr > 1
     bltz   r3,  y0
     b0:
     bltz   r3,  a0
     c0:
     bltz   r3,  b0
     d0:
     bltz   r3,  c0
     e0:
     bltz   r3,  d0
     f0:
     bltz   r3,  e0
     g0:
     bltz   r3,  f0
     h0:
     bltz   r3,  g0
     i0:
     bltz   r3,  h0
     x0:
     bltz   r3,  i0
     y0:

     bltz   r3,  x1
     mtc0   r0,  proc2mngr
     nop
     a1:
     mtc0   r1,  proc2mngr > 1
     bltz   r3,  y1
     b1:
     bltz   r3,  a1
     c1:
     bltz   r3,  b1
     d1:
     bltz   r3,  c1
     e1:
     bltz   r3,  d1
     f1:
     bltz   r3,  e1
     g1:
     bltz   r3,  f1
     h1:
     bltz   r3,  g1
     i1:
     bltz   r3,  h1
     x1:
     bltz   r3,  i1
     y1:

     bltz   r3,  x2
     mtc0   r0,  proc2mngr
     nop
     a2:
     mtc0   r1,  proc2mngr > 1
     bltz   r3,  y2
     b2:
     bltz   r3,  a2
     c2:
     bltz   r3,  b2
     d2:
     bltz   r3,  c2
     e2:
     bltz   r3,  d2
     f2:
     bltz   r3,  e2
     g2:
     bltz   r3,  f2
     h2:
     bltz   r3,  g2
     i2:
     bltz   r3,  h2
     x2:
     bltz   r3,  i2
     y2:

     bltz   r3,  x3
     mtc0   r0,  proc2mngr
     nop
     a3:
     mtc0   r1,  proc2mngr > 1
     bltz   r3,  y3
     b3:
     bltz   r3,  a3
     c3:
     bltz   r3,  b3
     d3:
     bltz   r3,  c3
     e3:
     bltz   r3,  d3
     f3:
     bltz   r3,  e3
     g3:
     bltz   r3,  f3
     h3:
     bltz   r3,  g3
     i3:
     bltz   r3,  h3
     x3:
     bltz   r3,  i3
     y3:
     nop
     nop
     nop
     nop
     nop
     nop
     nop

  """

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
