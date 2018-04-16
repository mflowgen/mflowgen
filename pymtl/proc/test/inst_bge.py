#=========================================================================
# bge
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use x3 to track the control flow pattern
    addi  x3, x0, 0

    csrr  x1, mngr2proc < 2
    csrr  x2, mngr2proc < 2

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    # This branch should be taken
    bge   x1, x2, label_a
    addi  x3, x3, 0b01

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addi  x3, x3, 0b10

    # Only the second bit should be set if branch was taken
    csrw proc2mngr, x3 > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_src0_dep_taken_test
#-------------------------------------------------------------------------

def gen_src0_dep_taken_test():
  return [
    gen_br2_src0_dep_test( 5, "bge", 1, 0, True ),
    gen_br2_src0_dep_test( 4, "bge", 2, 0, True ),
    gen_br2_src0_dep_test( 3, "bge", 3, 0, True ),
    gen_br2_src0_dep_test( 2, "bge", 4, 0, True ),
    gen_br2_src0_dep_test( 1, "bge", 5, 0, True ),
    gen_br2_src0_dep_test( 0, "bge", 6, 0, True ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_dep_nottaken_test():
  return [
    gen_br2_src0_dep_test( 5, "bge", 1, 7, False ),
    gen_br2_src0_dep_test( 4, "bge", 2, 7, False ),
    gen_br2_src0_dep_test( 3, "bge", 3, 7, False ),
    gen_br2_src0_dep_test( 2, "bge", 4, 7, False ),
    gen_br2_src0_dep_test( 1, "bge", 5, 7, False ),
    gen_br2_src0_dep_test( 0, "bge", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_taken_test
#-------------------------------------------------------------------------

def gen_src1_dep_taken_test():
  return [
    gen_br2_src1_dep_test( 5, "bge", 7, 1, True ),
    gen_br2_src1_dep_test( 4, "bge", 7, 2, True ),
    gen_br2_src1_dep_test( 3, "bge", 7, 3, True ),
    gen_br2_src1_dep_test( 2, "bge", 7, 4, True ),
    gen_br2_src1_dep_test( 1, "bge", 7, 5, True ),
    gen_br2_src1_dep_test( 0, "bge", 7, 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_src1_dep_nottaken_test():
  return [
    gen_br2_src1_dep_test( 5, "bge", 0, 1, False ),
    gen_br2_src1_dep_test( 4, "bge", 0, 2, False ),
    gen_br2_src1_dep_test( 3, "bge", 0, 3, False ),
    gen_br2_src1_dep_test( 2, "bge", 0, 4, False ),
    gen_br2_src1_dep_test( 1, "bge", 0, 5, False ),
    gen_br2_src1_dep_test( 0, "bge", 0, 6, False ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_taken_test
#-------------------------------------------------------------------------

def gen_srcs_dep_taken_test():
  return [
    gen_br2_srcs_dep_test( 5, "bge", 1, 0, True ),
    gen_br2_srcs_dep_test( 4, "bge", 2, 1, True ),
    gen_br2_srcs_dep_test( 3, "bge", 3, 2, True ),
    gen_br2_srcs_dep_test( 2, "bge", 4, 3, True ),
    gen_br2_srcs_dep_test( 1, "bge", 5, 4, True ),
    gen_br2_srcs_dep_test( 0, "bge", 6, 5, True ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_srcs_dep_nottaken_test():
  return [
    gen_br2_srcs_dep_test( 5, "bge", 1, 2, False ),
    gen_br2_srcs_dep_test( 4, "bge", 2, 3, False ),
    gen_br2_srcs_dep_test( 3, "bge", 3, 4, False ),
    gen_br2_srcs_dep_test( 2, "bge", 4, 5, False ),
    gen_br2_srcs_dep_test( 1, "bge", 5, 6, False ),
    gen_br2_srcs_dep_test( 0, "bge", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src0_eq_src1_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_eq_src1_test():
  return [
    gen_br2_src0_eq_src1_test( "bge", 1, True ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_br2_value_test( "bge", -1, -1, True  ),
    gen_br2_value_test( "bge", -1,  0, False ),
    gen_br2_value_test( "bge", -1,  1, False ),

    gen_br2_value_test( "bge",  0, -1, True ),
    gen_br2_value_test( "bge",  0,  0, True  ),
    gen_br2_value_test( "bge",  0,  1, False ),

    gen_br2_value_test( "bge",  1, -1, True ),
    gen_br2_value_test( "bge",  1,  0, True ),
    gen_br2_value_test( "bge",  1,  1, True  ),

    gen_br2_value_test( "bge", 0xfffffff7, 0xfffffff7, True  ),
    gen_br2_value_test( "bge", 0xfffffff7, 0x7fffffff, False  ),
    gen_br2_value_test( "bge", 0xfffffff7, 0xfffffff0, True ),
    gen_br2_value_test( "bge", 0x7fffffff, 0xfffffff7, True ),

    #specifically test if this is a signed comparison
    gen_br2_value_test( "bge", 0x00000001, 0xffffffff, True ),
    gen_br2_value_test( "bge", 0xffffffff, 0x00000001, False ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(25):
    src0  = Bits( 32, random.randint(0,0xffffffff) )
    src1  = Bits( 32, random.randint(0,0xffffffff) )
    taken = ( src0.int() >= src1.int() )
    asm_code.append( gen_br2_value_test( "bge", src0.uint(), src1.uint(), taken ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
     # Test backwards walk (back to back branch taken)

     csrr x3, mngr2proc < 0
     csrr x1, mngr2proc < 1

     bge  x3, x0, X0
     csrw proc2mngr, x0
     nop
     a0:
     csrw proc2mngr, x1 > 1
     bge  x3, x0, y0
     b0:
     bge  x3, x0, a0
     c0:
     bge  x3, x0, b0
     d0:
     bge  x3, x0, c0
     e0:
     bge  x3, x0, d0
     f0:
     bge  x3, x0, e0
     g0:
     bge  x3, x0, f0
     h0:
     bge  x3, x0, g0
     i0:
     bge  x3, x0, h0
     X0:
     bge  x3, x0, i0
     y0:

     bge  x3, x0, X1
     csrw proc2mngr, x0
     nop
     a1:
     csrw proc2mngr, x1 > 1
     bge  x3, x0, y1
     b1:
     bge  x3, x0, a1
     c1:
     bge  x3, x0, b1
     d1:
     bge  x3, x0, c1
     e1:
     bge  x3, x0, d1
     f1:
     bge  x3, x0, e1
     g1:
     bge  x3, x0, f1
     h1:
     bge  x3, x0, g1
     i1:
     bge  x3, x0, h1
     X1:
     bge  x3, x0, i1
     y1:

     bge  x3, x0, X2
     csrw proc2mngr, x0
     nop
     a2:
     csrw proc2mngr, x1 > 1
     bge  x3, x0, y2
     b2:
     bge  x3, x0, a2
     c2:
     bge  x3, x0, b2
     d2:
     bge  x3, x0, c2
     e2:
     bge  x3, x0, d2
     f2:
     bge  x3, x0, e2
     g2:
     bge  x3, x0, f2
     h2:
     bge  x3, x0, g2
     i2:
     bge  x3, x0, h2
     X2:
     bge  x3, x0, i2
     y2:

     bge  x3, x0, X3
     csrw proc2mngr, x0
     nop
     a3:
     csrw proc2mngr, x1 > 1
     bge  x3, x0, y3
     b3:
     bge  x3, x0, a3
     c3:
     bge  x3, x0, b3
     d3:
     bge  x3, x0, c3
     e3:
     bge  x3, x0, d3
     f3:
     bge  x3, x0, e3
     g3:
     bge  x3, x0, f3
     h3:
     bge  x3, x0, g3
     i3:
     bge  x3, x0, h3
     X3:
     bge  x3, x0, i3
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
