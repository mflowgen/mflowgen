#=========================================================================
# fle.s
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x40800000  # 4.0
    csrr x2, mngr2proc < 0x40a00000  # 5.0
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
    fle.s x3, f1, f2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 1
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
    gen_fp_rr_dest_dep_test( 5, "fle.s", f2i(1), f2i(3), 1, False ),
    gen_fp_rr_dest_dep_test( 4, "fle.s", f2i(2), f2i(3), 1, False ),
    gen_fp_rr_dest_dep_test( 3, "fle.s", f2i(3), f2i(3), 1, False ),
    gen_fp_rr_dest_dep_test( 2, "fle.s", f2i(4), f2i(3), 0, False ),
    gen_fp_rr_dest_dep_test( 1, "fle.s", f2i(5), f2i(3), 0, False ),
    gen_fp_rr_dest_dep_test( 0, "fle.s", f2i(6), f2i(3), 0, False ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_fp_rr_src0_dep_test( 5, "fle.s", f2i( 7), f2i(10), 1, False ),
    gen_fp_rr_src0_dep_test( 4, "fle.s", f2i( 8), f2i(10), 1, False ),
    gen_fp_rr_src0_dep_test( 3, "fle.s", f2i( 9), f2i(10), 1, False ),
    gen_fp_rr_src0_dep_test( 2, "fle.s", f2i(10), f2i(10), 1, False ),
    gen_fp_rr_src0_dep_test( 1, "fle.s", f2i(11), f2i(10), 0, False ),
    gen_fp_rr_src0_dep_test( 0, "fle.s", f2i(12), f2i(10), 0, False ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_fp_rr_src1_dep_test( 5, "fle.s", f2i(16), f2i(13), 0, False ),
    gen_fp_rr_src1_dep_test( 4, "fle.s", f2i(16), f2i(14), 0, False ),
    gen_fp_rr_src1_dep_test( 3, "fle.s", f2i(16), f2i(15), 0, False ),
    gen_fp_rr_src1_dep_test( 2, "fle.s", f2i(16), f2i(16), 1, False ),
    gen_fp_rr_src1_dep_test( 1, "fle.s", f2i(16), f2i(17), 1, False ),
    gen_fp_rr_src1_dep_test( 0, "fle.s", f2i(16), f2i(18), 1, False ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_fp_rr_srcs_dep_test( 5, "fle.s", f2i(12), f2i(13), 1, False ),
    gen_fp_rr_srcs_dep_test( 4, "fle.s", f2i(13), f2i(12), 0, False ),
    gen_fp_rr_srcs_dep_test( 3, "fle.s", f2i(14), f2i(15), 1, False ),
    gen_fp_rr_srcs_dep_test( 2, "fle.s", f2i(15), f2i(14), 0, False ),
    gen_fp_rr_srcs_dep_test( 1, "fle.s", f2i(16), f2i(17), 1, False ),
    gen_fp_rr_srcs_dep_test( 0, "fle.s", f2i(17), f2i(16), 0, False ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_fp_rr_src0_eq_dest_test( "fle.s", f2i(25), f2i(26), 1, False ),
    gen_fp_rr_src1_eq_dest_test( "fle.s", f2i(28), f2i(27), 0, False ),
    gen_fp_rr_src0_eq_src1_test( "fle.s", f2i(27), 1, False ),
    gen_fp_rr_srcs_eq_dest_test( "fle.s", f2i(28), 1, False ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  negzero = 0x80000000

  return [

    gen_fp_rr_value_test( "fle.s", f2i( 0.0), f2i( 0.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 1.0), f2i( 0.0), 0, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 0.0), f2i( 1.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 1.0), f2i( 1.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 0.0), f2i( 0.0), 1, False ),
    # basic neg
    gen_fp_rr_value_test( "fle.s", f2i(-1.0), f2i( 0.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 0.0), f2i(-1.0), 0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(-1.0), f2i( 1.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 1.0), f2i(-1.0), 0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(-1.0), f2i(-1.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", negzero,   f2i( 0.0), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i( 0.0), negzero,   1, False ),
    gen_fp_rr_value_test( "fle.s", negzero,   negzero,   1, False ),
    # basic exact
    gen_fp_rr_value_test( "fle.s", f2i(0.5),   f2i(4.0),  1, False ),
    gen_fp_rr_value_test( "fle.s", f2i(4.0),   f2i(0.5),  0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(2.0),   f2i(2.0),  1, False ),
    gen_fp_rr_value_test( "fle.s", f2i(0.125), f2i(0.75), 1, False ),
    gen_fp_rr_value_test( "fle.s", f2i(0.75),  f2i(0.125),0, False ),
    # basic inexact
    gen_fp_rr_value_test( "fle.s", f2i(0.3),   f2i(0.1), 0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(0.4),   f2i(0.3), 0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(0.4),   f2i(0.4), 1, False ),
    # riscv
    gen_fp_rr_value_test( "fle.s", f2i(2.5),        f2i(1.0),        0, False ),
    gen_fp_rr_value_test( "fle.s", f2i(-1235.1),    f2i(1.1),        1, False ),
    gen_fp_rr_value_test( "fle.s", f2i(3.14159265), f2i(0.00000001), 0, False ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = random.randint(-0xfffff,0xfffff)
    src1 = random.randint(-0xfffff,0xfffff) if random.randint(0, 4) != 0 else src0
    dest = 1 if ( src0 <= src1 ) else 0
    asm_code.append( gen_fp_rr_value_test( "fle.s", f2i(src0), f2i(src1),
                                           dest, False ) )
  return asm_code

