#=========================================================================
# fcvt.s.w
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fcvt.s.w f2, x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fmv.x.w x3, f2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x40800000  # 4.0
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
    gen_fp_cvt_dest_dep_test( 5, "fcvt.s.w", 1, f2i(1), False ),
    gen_fp_cvt_dest_dep_test( 4, "fcvt.s.w", 2, f2i(2), False ),
    gen_fp_cvt_dest_dep_test( 3, "fcvt.s.w", 3, f2i(3), False ),
    gen_fp_cvt_dest_dep_test( 2, "fcvt.s.w", 4, f2i(4), False ),
    gen_fp_cvt_dest_dep_test( 1, "fcvt.s.w", 5, f2i(5), False ),
    gen_fp_cvt_dest_dep_test( 0, "fcvt.s.w", 6, f2i(6), False ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_fp_cvt_src_dep_test( 5, "fcvt.s.w", 7,  f2i( 7), False ),
    gen_fp_cvt_src_dep_test( 4, "fcvt.s.w", 8,  f2i( 8), False ),
    gen_fp_cvt_src_dep_test( 3, "fcvt.s.w", 9,  f2i( 9), False ),
    gen_fp_cvt_src_dep_test( 2, "fcvt.s.w", 10, f2i(10), False ),
    gen_fp_cvt_src_dep_test( 1, "fcvt.s.w", 11, f2i(11), False ),
    gen_fp_cvt_src_dep_test( 0, "fcvt.s.w", 12, f2i(12), False ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  negzero = 0x80000000

  return [

    gen_fp_cvt_value_test( "fcvt.s.w", 0, f2i( 0.0), False ),
    gen_fp_cvt_value_test( "fcvt.s.w", 1, f2i( 1.0), False ),
    # basic neg
    gen_fp_cvt_value_test( "fcvt.s.w", -1, f2i(-1.0), False ),
    # basic exact
    gen_fp_cvt_value_test( "fcvt.s.w", 15,     f2i(15.0),     False ),
    gen_fp_cvt_value_test( "fcvt.s.w", 4,      f2i(4.0),      False ),
    gen_fp_cvt_value_test( "fcvt.s.w", 2,      f2i(2.0),      False ),
    gen_fp_cvt_value_test( "fcvt.s.w", -10,    f2i(-10.0),    False ),
    gen_fp_cvt_value_test( "fcvt.s.w", -12345, f2i(-12345.0), False ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src = random.randint(-0xfffff,0xfffff)
    asm_code.append( gen_fp_cvt_value_test( "fcvt.s.w", src, f2i(src), False ) )
  return asm_code

