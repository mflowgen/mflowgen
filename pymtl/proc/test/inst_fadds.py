#=========================================================================
# fadd.s
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x40a00000  # 5.0
    csrr x2, mngr2proc < 0x40800000  # 4.0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fmv.w.x f1, x1
    fmv.w.x f2, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fadd.s f3, f1, f2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fmv.x.w x3, f3
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x41100000  # 9.0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [
    gen_fp_rr_dest_dep_test( 5, "fadd.s", f2i(1), f2i(1), f2i(2) ),
    gen_fp_rr_dest_dep_test( 4, "fadd.s", f2i(2), f2i(1), f2i(3) ),
    gen_fp_rr_dest_dep_test( 3, "fadd.s", f2i(3), f2i(1), f2i(4) ),
    gen_fp_rr_dest_dep_test( 2, "fadd.s", f2i(4), f2i(1), f2i(5) ),
    gen_fp_rr_dest_dep_test( 1, "fadd.s", f2i(5), f2i(1), f2i(6) ),
    gen_fp_rr_dest_dep_test( 0, "fadd.s", f2i(6), f2i(1), f2i(7) ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_fp_rr_src0_dep_test( 5, "fadd.s", f2i( 7), f2i(1), f2i( 8) ),
    gen_fp_rr_src0_dep_test( 4, "fadd.s", f2i( 8), f2i(1), f2i( 9) ),
    gen_fp_rr_src0_dep_test( 3, "fadd.s", f2i( 9), f2i(1), f2i(10) ),
    gen_fp_rr_src0_dep_test( 2, "fadd.s", f2i(10), f2i(1), f2i(11) ),
    gen_fp_rr_src0_dep_test( 1, "fadd.s", f2i(11), f2i(1), f2i(12) ),
    gen_fp_rr_src0_dep_test( 0, "fadd.s", f2i(12), f2i(1), f2i(13) ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_fp_rr_src1_dep_test( 5, "fadd.s", f2i(1), f2i(13), f2i(14) ),
    gen_fp_rr_src1_dep_test( 4, "fadd.s", f2i(1), f2i(14), f2i(15) ),
    gen_fp_rr_src1_dep_test( 3, "fadd.s", f2i(1), f2i(15), f2i(16) ),
    gen_fp_rr_src1_dep_test( 2, "fadd.s", f2i(1), f2i(16), f2i(17) ),
    gen_fp_rr_src1_dep_test( 1, "fadd.s", f2i(1), f2i(17), f2i(18) ),
    gen_fp_rr_src1_dep_test( 0, "fadd.s", f2i(1), f2i(18), f2i(19) ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_fp_rr_srcs_dep_test( 5, "fadd.s", f2i(12), f2i(2), f2i(14) ),
    gen_fp_rr_srcs_dep_test( 4, "fadd.s", f2i(13), f2i(3), f2i(16) ),
    gen_fp_rr_srcs_dep_test( 3, "fadd.s", f2i(14), f2i(4), f2i(18) ),
    gen_fp_rr_srcs_dep_test( 2, "fadd.s", f2i(15), f2i(5), f2i(20) ),
    gen_fp_rr_srcs_dep_test( 1, "fadd.s", f2i(16), f2i(6), f2i(22) ),
    gen_fp_rr_srcs_dep_test( 0, "fadd.s", f2i(17), f2i(7), f2i(24) ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_fp_rr_src0_eq_dest_test( "fadd.s", f2i(25), f2i(1), f2i(26) ),
    gen_fp_rr_src1_eq_dest_test( "fadd.s", f2i(26), f2i(1), f2i(27) ),
    gen_fp_rr_src0_eq_src1_test( "fadd.s", f2i(27), f2i(54) ),
    gen_fp_rr_srcs_eq_dest_test( "fadd.s", f2i(28), f2i(56) ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  negzero = 0x80000000

  return [

    gen_fp_rr_value_test( "fadd.s", f2i( 0.0), f2i( 0.0), f2i( 0.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 1.0), f2i( 0.0), f2i( 1.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 0.0), f2i( 1.0), f2i( 1.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 1.0), f2i( 1.0), f2i( 2.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 0.0), f2i( 0.0), f2i( 0.0) ),
    # basic neg
    gen_fp_rr_value_test( "fadd.s", f2i(-1.0), f2i( 0.0), f2i(-1.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 0.0), f2i(-1.0), f2i(-1.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i(-1.0), f2i( 1.0), f2i( 0.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 1.0), f2i(-1.0), f2i( 0.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i(-1.0), f2i(-1.0), f2i(-2.0) ),
    gen_fp_rr_value_test( "fadd.s", negzero,   f2i( 0.0), f2i( 0.0) ),
    gen_fp_rr_value_test( "fadd.s", f2i( 0.0), negzero,   f2i( 0.0) ),
    gen_fp_rr_value_test( "fadd.s", negzero,   negzero,   negzero   ),
    # basic exact
    gen_fp_rr_value_test( "fadd.s", f2i(0.5),   f2i(4.0),  f2i(4.5)   ),
    gen_fp_rr_value_test( "fadd.s", f2i(4.0),   f2i(0.5),  f2i(4.5)   ),
    gen_fp_rr_value_test( "fadd.s", f2i(2.0),   f2i(2.0),  f2i(4.0)   ),
    gen_fp_rr_value_test( "fadd.s", f2i(0.125), f2i(0.75), f2i(0.875) ),
    gen_fp_rr_value_test( "fadd.s", f2i(0.75),  f2i(0.125),f2i(0.875) ),
    # basic inexact
    gen_fp_rr_value_test( "fadd.s", f2i(0.3),   f2i(0.1), 0x3ecccccd ),
    #gen_fp_rr_value_test( "fadd.s", f2i(0.4),   f2i(0.3), 0x3f333334 ),
    gen_fp_rr_value_test( "fadd.s", f2i(0.4),   f2i(0.4), 0x3f4ccccd ),
    # riscv
    gen_fp_rr_value_test( "fadd.s", f2i(2.5),        f2i(1.0),        f2i(3.5 ),      ),
    #gen_fp_rr_value_test( "fadd.s", f2i(-1235.1),    f2i(1.1),       f2i(-1234),      ),
    gen_fp_rr_value_test( "fadd.s", f2i(3.14159265), f2i(0.00000001), f2i(3.14159265) ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = random.randint(-0xfffff,0xfffff)
    src1 = random.randint(-0xfffff,0xfffff)
    dest = src0 + src1
    asm_code.append( gen_fp_rr_value_test( "fadd.s", f2i(src0), f2i(src1),
                                           f2i(dest) ) )
  return asm_code

