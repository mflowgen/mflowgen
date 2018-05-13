#=========================================================================
# fcvt.w.s
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fmv.w.x f1, x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fcvt.w.s x3, f1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 4
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
    gen_fp_cvt_dest_dep_test( 5, "fcvt.w.s", f2i(1), 1, True ),
    gen_fp_cvt_dest_dep_test( 4, "fcvt.w.s", f2i(2), 2, True ),
    gen_fp_cvt_dest_dep_test( 3, "fcvt.w.s", f2i(3), 3, True ),
    gen_fp_cvt_dest_dep_test( 2, "fcvt.w.s", f2i(4), 4, True ),
    gen_fp_cvt_dest_dep_test( 1, "fcvt.w.s", f2i(5), 5, True ),
    gen_fp_cvt_dest_dep_test( 0, "fcvt.w.s", f2i(6), 6, True ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_fp_cvt_src_dep_test( 5, "fcvt.w.s", f2i( 7), 7, True ),
    gen_fp_cvt_src_dep_test( 4, "fcvt.w.s", f2i( 8), 8, True ),
    gen_fp_cvt_src_dep_test( 3, "fcvt.w.s", f2i( 9), 9, True ),
    gen_fp_cvt_src_dep_test( 2, "fcvt.w.s", f2i(10), 10, True ),
    gen_fp_cvt_src_dep_test( 1, "fcvt.w.s", f2i(11), 11, True ),
    gen_fp_cvt_src_dep_test( 0, "fcvt.w.s", f2i(12), 12, True ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  negzero = 0x80000000

  return [

    gen_fp_cvt_value_test( "fcvt.w.s", f2i( 0.0),  0, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i( 1.0),  1, True ),
    # basic neg
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(-1.0), -1, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", negzero,    0, True ),
    # basic exact
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(0.5),   0, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(4.0),   4, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(2.0),   2, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(0.125), 0, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(0.75),  0, True ),
    # basic inexact
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(0.3),   0, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(-0.4),  0, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(5.4),   5, True ),
    # riscv
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(2.5),        2,     True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(-1235.1),    -1235, True ),
    gen_fp_cvt_value_test( "fcvt.w.s", f2i(3.14159265), 3,     True ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src = random.randint(-0xfffff,0xfffff)
    asm_code.append( gen_fp_cvt_value_test( "fcvt.w.s", f2i(src), src, True ) )
  return asm_code

