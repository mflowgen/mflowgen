#=========================================================================
# fmv.x.w and fmv.w.x
#=========================================================================

import random

from pymtl                import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    csrr x1, mngr2proc, < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x2, mngr2proc, < 6
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Move the value in x1 to f2. This ensures that we don't have a
    # unified register file.
    fmv.w.x f2, x1
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
    csrw proc2mngr, x3 > 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x2 > 6
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
# gen_fmv_template
#-------------------------------------------------------------------------

def gen_fmv_template( num_nops_src, num_nops_fp, num_nops_dest, val,
                      fp_reg="f2" ):
  return """

    # Move some junk into x2 to ensure f2 doesn't alias into x2.
    csrr x2, mngr2proc < 0xdeadf00d
    # Move val into int reg.
    csrr x1, mngr2proc < {val}
    {nops_src}
    # Move the value to fp reg.
    fmv.w.x {fp_reg}, x1
    {nops_fp}
    # Move the value back to int reg.
    fmv.x.w x3, {fp_reg}
    {nops_dest}
    csrw proc2mngr, x3 > {val}
    csrw proc2mngr, x2 > 0xdeadf00d

  """.format(
    nops_src  = gen_nops(num_nops_src),
    nops_fp   = gen_nops(num_nops_fp),
    nops_dest = gen_nops(num_nops_dest),
    **locals()
  )

#-------------------------------------------------------------------------
# gen_fmv_w_x_src_dep_test
#-------------------------------------------------------------------------

def gen_fmv_w_x_src_dep_test():
  return [
    gen_fmv_template( 5, 8, 8, 2 ),
    gen_fmv_template( 4, 8, 8, 3 ),
    gen_fmv_template( 3, 8, 8, 4 ),
    gen_fmv_template( 2, 8, 8, 5 ),
    gen_fmv_template( 1, 8, 8, 6 ),
    gen_fmv_template( 0, 8, 8, 7 ),
  ]

#-------------------------------------------------------------------------
# gen_fmv_bypass_dep_test
#-------------------------------------------------------------------------

def gen_fmv_bypass_dep_test():
  return [
    gen_fmv_template( 8, 5, 8, 2 ),
    gen_fmv_template( 8, 4, 8, 3 ),
    gen_fmv_template( 8, 3, 8, 4 ),
    gen_fmv_template( 8, 2, 8, 5 ),
    gen_fmv_template( 8, 1, 8, 6 ),
    gen_fmv_template( 8, 0, 8, 7 ),
  ]

#-------------------------------------------------------------------------
# gen_fmv_x_w_dest_dep_test
#-------------------------------------------------------------------------

def gen_fmv_x_w_dest_dep_test():
  return [
    gen_fmv_template( 8, 8, 5, 2 ),
    gen_fmv_template( 8, 8, 4, 3 ),
    gen_fmv_template( 8, 8, 3, 4 ),
    gen_fmv_template( 8, 8, 2, 5 ),
    gen_fmv_template( 8, 8, 1, 6 ),
    gen_fmv_template( 8, 8, 0, 7 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    # Include f0 too since it's a valid reg unlike x0!
    asm_code.append( gen_fmv_template( 0, 0, 0, src.uint(),
                                       fp_reg="f{}".format( (i + 1) % 32 ) ) )
  return asm_code
