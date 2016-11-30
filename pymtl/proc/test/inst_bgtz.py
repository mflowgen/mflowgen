#=========================================================================
# parc_bgtz_test.py
#=========================================================================

import pytest
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

    mfc0  r1, mngr2proc < 1

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    # This branch should be taken
    bgtz  r1, label_a
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
    gen_br1_src_byp_test( 5, "bgtz", 1, True ),
    gen_br1_src_byp_test( 4, "bgtz", 2, True ),
    gen_br1_src_byp_test( 3, "bgtz", 3, True ),
    gen_br1_src_byp_test( 2, "bgtz", 4, True ),
    gen_br1_src_byp_test( 1, "bgtz", 5, True ),
    gen_br1_src_byp_test( 0, "bgtz", 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src_byp_nottaken_test
#-------------------------------------------------------------------------

def gen_src_byp_nottaken_test():
  return [
    gen_br1_src_byp_test( 5, "bgtz", -1, False ),
    gen_br1_src_byp_test( 4, "bgtz", -2, False ),
    gen_br1_src_byp_test( 3, "bgtz", -3, False ),
    gen_br1_src_byp_test( 2, "bgtz", -4, False ),
    gen_br1_src_byp_test( 1, "bgtz", -5, False ),
    gen_br1_src_byp_test( 0, "bgtz", -6, False ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_br1_value_test( "bgtz", -1, False ),
    gen_br1_value_test( "bgtz",  0, False ),
    gen_br1_value_test( "bgtz",  1, True  ),

    gen_br1_value_test( "bgtz", 0xfffffff7, False ),
    gen_br1_value_test( "bgtz", 0x7fffffff, True  ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(25):
    src   = Bits( 32, random.randint(0,0xffffffff) )
    taken = ( src.int() > 0 )
    asm_code.append( gen_br1_value_test( "bgtz", src.uint(), taken ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
     # Test backwards walk (back to back branch taken)

     mfc0   r3,  mngr2proc < 1
     mfc0   r1,  mngr2proc < 1

     bgtz   r3,  x0
     mtc0   r0,  proc2mngr
     nop
     a0:
     mtc0   r1,  proc2mngr > 1
     bgtz   r3,  y0
     b0:
     bgtz   r3,  a0
     c0:
     bgtz   r3,  b0
     d0:
     bgtz   r3,  c0
     e0:
     bgtz   r3,  d0
     f0:
     bgtz   r3,  e0
     g0:
     bgtz   r3,  f0
     h0:
     bgtz   r3,  g0
     i0:
     bgtz   r3,  h0
     x0:
     bgtz   r3,  i0
     y0:

     bgtz   r3,  x1
     mtc0   r0,  proc2mngr
     nop
     a1:
     mtc0   r1,  proc2mngr > 1
     bgtz   r3,  y1
     b1:
     bgtz   r3,  a1
     c1:
     bgtz   r3,  b1
     d1:
     bgtz   r3,  c1
     e1:
     bgtz   r3,  d1
     f1:
     bgtz   r3,  e1
     g1:
     bgtz   r3,  f1
     h1:
     bgtz   r3,  g1
     i1:
     bgtz   r3,  h1
     x1:
     bgtz   r3,  i1
     y1:

     bgtz   r3,  x2
     mtc0   r0,  proc2mngr
     nop
     a2:
     mtc0   r1,  proc2mngr > 1
     bgtz   r3,  y2
     b2:
     bgtz   r3,  a2
     c2:
     bgtz   r3,  b2
     d2:
     bgtz   r3,  c2
     e2:
     bgtz   r3,  d2
     f2:
     bgtz   r3,  e2
     g2:
     bgtz   r3,  f2
     h2:
     bgtz   r3,  g2
     i2:
     bgtz   r3,  h2
     x2:
     bgtz   r3,  i2
     y2:

     bgtz   r3,  x3
     mtc0   r0,  proc2mngr
     nop
     a3:
     mtc0   r1,  proc2mngr > 1
     bgtz   r3,  y3
     b3:
     bgtz   r3,  a3
     c3:
     bgtz   r3,  b3
     d3:
     bgtz   r3,  c3
     e3:
     bgtz   r3,  d3
     f3:
     bgtz   r3,  e3
     g3:
     bgtz   r3,  f3
     h3:
     bgtz   r3,  g3
     i3:
     bgtz   r3,  h3
     x3:
     bgtz   r3,  i3
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
