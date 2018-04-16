#=========================================================================
# bgeu
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
    bgeu   x1, x2, label_a
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
    gen_br2_src0_dep_test( 5, "bgeu", 1, 0, True ),
    gen_br2_src0_dep_test( 4, "bgeu", 2, 0, True ),
    gen_br2_src0_dep_test( 3, "bgeu", 3, 0, True ),
    gen_br2_src0_dep_test( 2, "bgeu", 4, 0, True ),
    gen_br2_src0_dep_test( 1, "bgeu", 5, 0, True ),
    gen_br2_src0_dep_test( 0, "bgeu", 6, 0, True ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_dep_nottaken_test():
  return [
    gen_br2_src0_dep_test( 5, "bgeu", 1, 7, False ),
    gen_br2_src0_dep_test( 4, "bgeu", 2, 7, False ),
    gen_br2_src0_dep_test( 3, "bgeu", 3, 7, False ),
    gen_br2_src0_dep_test( 2, "bgeu", 4, 7, False ),
    gen_br2_src0_dep_test( 1, "bgeu", 5, 7, False ),
    gen_br2_src0_dep_test( 0, "bgeu", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_taken_test
#-------------------------------------------------------------------------

def gen_src1_dep_taken_test():
  return [
    gen_br2_src1_dep_test( 5, "bgeu", 7, 1, True ),
    gen_br2_src1_dep_test( 4, "bgeu", 7, 1, True ),
    gen_br2_src1_dep_test( 3, "bgeu", 7, 2, True ),
    gen_br2_src1_dep_test( 2, "bgeu", 7, 3, True ),
    gen_br2_src1_dep_test( 1, "bgeu", 7, 4, True ),
    gen_br2_src1_dep_test( 0, "bgeu", 7, 5, True ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_src1_dep_nottaken_test():
  return [
    gen_br2_src1_dep_test( 5, "bgeu", 1, 2, False ),
    gen_br2_src1_dep_test( 4, "bgeu", 1, 3, False ),
    gen_br2_src1_dep_test( 3, "bgeu", 1, 4, False ),
    gen_br2_src1_dep_test( 2, "bgeu", 1, 5, False ),
    gen_br2_src1_dep_test( 1, "bgeu", 1, 6, False ),
    gen_br2_src1_dep_test( 0, "bgeu", 1, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_taken_test
#-------------------------------------------------------------------------

def gen_srcs_dep_taken_test():
  return [
    gen_br2_srcs_dep_test( 5, "bgeu", 1, 0, True ),
    gen_br2_srcs_dep_test( 4, "bgeu", 2, 1, True ),
    gen_br2_srcs_dep_test( 3, "bgeu", 3, 2, True ),
    gen_br2_srcs_dep_test( 2, "bgeu", 4, 3, True ),
    gen_br2_srcs_dep_test( 1, "bgeu", 5, 4, True ),
    gen_br2_srcs_dep_test( 0, "bgeu", 6, 5, True ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_nottaken_test
#-------------------------------------------------------------------------

def gen_srcs_dep_nottaken_test():
  return [
    gen_br2_srcs_dep_test( 5, "bgeu", 1, 2, False ),
    gen_br2_srcs_dep_test( 4, "bgeu", 2, 3, False ),
    gen_br2_srcs_dep_test( 3, "bgeu", 3, 4, False ),
    gen_br2_srcs_dep_test( 2, "bgeu", 4, 5, False ),
    gen_br2_srcs_dep_test( 1, "bgeu", 5, 6, False ),
    gen_br2_srcs_dep_test( 0, "bgeu", 6, 7, False ),
  ]

#-------------------------------------------------------------------------
# gen_src0_eq_src1_nottaken_test
#-------------------------------------------------------------------------

def gen_src0_eq_src1_test():
  return [
    gen_br2_src0_eq_src1_test( "bgeu", 1, True ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    gen_br2_value_test( "bgeu", -1, -1, True  ),
    gen_br2_value_test( "bgeu", -1,  0, True  ),
    gen_br2_value_test( "bgeu", -1,  1, True  ),

    gen_br2_value_test( "bgeu",  0, -1, False ),
    gen_br2_value_test( "bgeu",  0,  0, True  ),
    gen_br2_value_test( "bgeu",  0,  1, False ),

    gen_br2_value_test( "bgeu",  1, -1, False ),
    gen_br2_value_test( "bgeu",  1,  0, True  ),
    gen_br2_value_test( "bgeu",  1,  1, True  ),

    gen_br2_value_test( "bgeu", 0xfffffff7, 0xfffffff7, True  ),
    gen_br2_value_test( "bgeu", 0xfffffff7, 0x7fffffff, True  ),
    gen_br2_value_test( "bgeu", 0xfffffff7, 0xfffffff0, True  ),
    gen_br2_value_test( "bgeu", 0x7fffffff, 0xfffffff7, False ),
    
    #specifically test if this is a unsigned comparison
    gen_br2_value_test( "bgeu", 0x00000001, 0xffffffff, False ),
    gen_br2_value_test( "bgeu", 0xffffffff, 0x00000001, True ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(25):
    src0  = Bits( 32, random.randint(0,0xffffffff) )
    src1  = Bits( 32, random.randint(0,0xffffffff) )
    taken = ( src0 >= src1 )
    asm_code.append( gen_br2_value_test( "bgeu", src0.uint(), src1.uint(), taken ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------

def gen_back_to_back_test():
  return """
     # Test backwards walk (back to back branch taken)

     csrr x3, mngr2proc < 0
     csrr x1, mngr2proc < 1

     bgeu  x3, x0, X0
     csrw proc2mngr, x0
     nop
     a0:
     csrw proc2mngr, x1 > 1
     bgeu  x3, x0, y0
     b0:
     bgeu  x3, x0, a0
     c0:
     bgeu  x3, x0, b0
     d0:
     bgeu  x3, x0, c0
     e0:
     bgeu  x3, x0, d0
     f0:
     bgeu  x3, x0, e0
     g0:
     bgeu  x3, x0, f0
     h0:
     bgeu  x3, x0, g0
     i0:
     bgeu  x3, x0, h0
     X0:
     bgeu  x3, x0, i0
     y0:

     bgeu  x3, x0, X1
     csrw proc2mngr, x0
     nop
     a1:
     csrw proc2mngr, x1 > 1
     bgeu  x3, x0, y1
     b1:
     bgeu  x3, x0, a1
     c1:
     bgeu  x3, x0, b1
     d1:
     bgeu  x3, x0, c1
     e1:
     bgeu  x3, x0, d1
     f1:
     bgeu  x3, x0, e1
     g1:
     bgeu  x3, x0, f1
     h1:
     bgeu  x3, x0, g1
     i1:
     bgeu  x3, x0, h1
     X1:
     bgeu  x3, x0, i1
     y1:

     bgeu  x3, x0, X2
     csrw proc2mngr, x0
     nop
     a2:
     csrw proc2mngr, x1 > 1
     bgeu  x3, x0, y2
     b2:
     bgeu  x3, x0, a2
     c2:
     bgeu  x3, x0, b2
     d2:
     bgeu  x3, x0, c2
     e2:
     bgeu  x3, x0, d2
     f2:
     bgeu  x3, x0, e2
     g2:
     bgeu  x3, x0, f2
     h2:
     bgeu  x3, x0, g2
     i2:
     bgeu  x3, x0, h2
     X2:
     bgeu  x3, x0, i2
     y2:

     bgeu  x3, x0, X3
     csrw proc2mngr, x0
     nop
     a3:
     csrw proc2mngr, x1 > 1
     bgeu  x3, x0, y3
     b3:
     bgeu  x3, x0, a3
     c3:
     bgeu  x3, x0, b3
     d3:
     bgeu  x3, x0, c3
     e3:
     bgeu  x3, x0, d3
     f3:
     bgeu  x3, x0, e3
     g3:
     bgeu  x3, x0, f3
     h3:
     bgeu  x3, x0, g3
     i3:
     bgeu  x3, x0, h3
     X3:
     bgeu  x3, x0, i3
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
