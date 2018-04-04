#=========================================================================
# beq
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

    mfc0  r1, mngr2proc < 2
    mfc0  r2, mngr2proc < 2

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    # This branch should be taken
    beq   r1, r2, label_a
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
    mtc0 r3, proc2mngr > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_src0_byp_taken_test
#-------------------------------------------------------------------------

def gen_src0_byp_taken_test():
  return [
    gen_br2_src0_byp_test( 5, "beq", 1, 1, True ),
    gen_br2_src0_byp_test( 4, "beq", 2, 2, True ),
    gen_br2_src0_byp_test( 3, "beq", 3, 3, True ),
    gen_br2_src0_byp_test( 2, "beq", 4, 4, True ),
    gen_br2_src0_byp_test( 1, "beq", 5, 5, True ),
    gen_br2_src0_byp_test( 0, "beq", 6, 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src0_byp_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_byp_nottaken_test():
  return [
    gen_br2_src0_byp_test( 5, "beq", 1, 2, False ),
    gen_br2_src0_byp_test( 4, "beq", 2, 3, False ),
    gen_br2_src0_byp_test( 3, "beq", 3, 4, False ),
    gen_br2_src0_byp_test( 2, "beq", 4, 5, False ),
    gen_br2_src0_byp_test( 1, "beq", 5, 6, False ),
    gen_br2_src0_byp_test( 0, "beq", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_taken_test
#-------------------------------------------------------------------------

def gen_src1_byp_taken_test():
  return [
    gen_br2_src1_byp_test( 5, "beq", 1, 1, True ),
    gen_br2_src1_byp_test( 4, "beq", 2, 2, True ),
    gen_br2_src1_byp_test( 3, "beq", 3, 3, True ),
    gen_br2_src1_byp_test( 2, "beq", 4, 4, True ),
    gen_br2_src1_byp_test( 1, "beq", 5, 5, True ),
    gen_br2_src1_byp_test( 0, "beq", 6, 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src1_byp_nottaken_test
#-------------------------------------------------------------------------

def gen_src1_byp_nottaken_test():
  return [
    gen_br2_src1_byp_test( 5, "beq", 1, 2, False ),
    gen_br2_src1_byp_test( 4, "beq", 2, 3, False ),
    gen_br2_src1_byp_test( 3, "beq", 3, 4, False ),
    gen_br2_src1_byp_test( 2, "beq", 4, 5, False ),
    gen_br2_src1_byp_test( 1, "beq", 5, 6, False ),
    gen_br2_src1_byp_test( 0, "beq", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_taken_test
#-------------------------------------------------------------------------

def gen_srcs_byp_taken_test():
  return [
    gen_br2_srcs_byp_test( 5, "beq", 1, 1, True ),
    gen_br2_srcs_byp_test( 4, "beq", 2, 2, True ),
    gen_br2_srcs_byp_test( 3, "beq", 3, 3, True ),
    gen_br2_srcs_byp_test( 2, "beq", 4, 4, True ),
    gen_br2_srcs_byp_test( 1, "beq", 5, 5, True ),
    gen_br2_srcs_byp_test( 0, "beq", 6, 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_byp_nottaken_test
#-------------------------------------------------------------------------

def gen_srcs_byp_nottaken_test():
  return [
    gen_br2_srcs_byp_test( 5, "beq", 1, 2, False ),
    gen_br2_srcs_byp_test( 4, "beq", 2, 3, False ),
    gen_br2_srcs_byp_test( 3, "beq", 3, 4, False ),
    gen_br2_srcs_byp_test( 2, "beq", 4, 5, False ),
    gen_br2_srcs_byp_test( 1, "beq", 5, 6, False ),
    gen_br2_srcs_byp_test( 0, "beq", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src0_eq_src1_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_eq_src1_test():
  return [
    gen_br2_src0_eq_src1_test( "beq", 1, True ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_br2_value_test( "beq", -1, -1, True  ),
    gen_br2_value_test( "beq", -1,  0, False ),
    gen_br2_value_test( "beq", -1,  1, False ),

    gen_br2_value_test( "beq",  0, -1, False ),
    gen_br2_value_test( "beq",  0,  0, True  ),
    gen_br2_value_test( "beq",  0,  1, False ),

    gen_br2_value_test( "beq",  1, -1, False ),
    gen_br2_value_test( "beq",  1,  0, False ),
    gen_br2_value_test( "beq",  1,  1, True  ),

    gen_br2_value_test( "beq", 0xfffffff7, 0xfffffff7, True  ),
    gen_br2_value_test( "beq", 0x7fffffff, 0x7fffffff, True  ),
    gen_br2_value_test( "beq", 0xfffffff7, 0x7fffffff, False ),
    gen_br2_value_test( "beq", 0x7fffffff, 0xfffffff7, False ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(25):
    src0  = Bits( 32, random.randint(0,0xffffffff) )
    src1  = Bits( 32, random.randint(0,0xffffffff) )
    taken = ( src0 == src1 )
    asm_code.append( gen_br2_value_test( "beq", src0.uint(), src1.uint(), taken ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
     # Test backwards walk (back to back branch taken)

     mfc0 r3, mngr2proc < 0
     mfc0 r1, mngr2proc < 1

     beq  r3, r0, x0
     mtc0 r0, proc2mngr
     nop
     a0:
     mtc0 r1, proc2mngr > 1
     beq  r3, r0, y0
     b0:
     beq  r3, r0, a0
     c0:
     beq  r3, r0, b0
     d0:
     beq  r3, r0, c0
     e0:
     beq  r3, r0, d0
     f0:
     beq  r3, r0, e0
     g0:
     beq  r3, r0, f0
     h0:
     beq  r3, r0, g0
     i0:
     beq  r3, r0, h0
     x0:
     beq  r3, r0, i0
     y0:

     beq  r3, r0, x1
     mtc0 r0, proc2mngr
     nop
     a1:
     mtc0 r1, proc2mngr > 1
     beq  r3, r0, y1
     b1:
     beq  r3, r0, a1
     c1:
     beq  r3, r0, b1
     d1:
     beq  r3, r0, c1
     e1:
     beq  r3, r0, d1
     f1:
     beq  r3, r0, e1
     g1:
     beq  r3, r0, f1
     h1:
     beq  r3, r0, g1
     i1:
     beq  r3, r0, h1
     x1:
     beq  r3, r0, i1
     y1:

     beq  r3, r0, x2
     mtc0   r0, proc2mngr
     nop
     a2:
     mtc0   r1, proc2mngr > 1
     beq  r3, r0, y2
     b2:
     beq  r3, r0, a2
     c2:
     beq  r3, r0, b2
     d2:
     beq  r3, r0, c2
     e2:
     beq  r3, r0, d2
     f2:
     beq  r3, r0, e2
     g2:
     beq  r3, r0, f2
     h2:
     beq  r3, r0, g2
     i2:
     beq  r3, r0, h2
     x2:
     beq  r3, r0, i2
     y2:

     beq  r3, r0, x3
     mtc0 r0, proc2mngr
     nop
     a3:
     mtc0 r1, proc2mngr > 1
     beq  r3, r0, y3
     b3:
     beq  r3, r0, a3
     c3:
     beq  r3, r0, b3
     d3:
     beq  r3, r0, c3
     e3:
     beq  r3, r0, d3
     f3:
     beq  r3, r0, e3
     g3:
     beq  r3, r0, f3
     h3:
     beq  r3, r0, g3
     i3:
     beq  r3, r0, h3
     x3:
     beq  r3, r0, i3
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
