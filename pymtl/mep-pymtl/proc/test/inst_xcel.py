#=========================================================================
# xcel
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_asm_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    mfc0 r1, mngr2proc < 0xdeadbeef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtx  r1, xr0, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mfx  r2, xr0, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r2, proc2mngr > 0xdeadbeef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

#-------------------------------------------------------------------------
# gen_bypass_asm_test
#-------------------------------------------------------------------------

def gen_bypass_test():
  return """

    mfc0 r2, mngr2proc < 0xdeadbeef
    {nops_3}
    mtx  r2, xr0, 0
    mfx  r3, xr0, 0
    {nops_3}
    mtc0 r3, proc2mngr > 0xdeadbeef

    mfc0 r2, mngr2proc < 0xdeadbe00
    {nops_2}
    mtx  r2, xr0, 0
    mfx  r3, xr0, 0
    {nops_2}
    mtc0 r3, proc2mngr > 0xdeadbe00

    mfc0 r2, mngr2proc < 0x00adbe00
    {nops_1}
    mtx  r2, xr0, 0
    mfx  r3, xr0, 0
    {nops_1}
    mtc0 r3, proc2mngr > 0x00adbe00

    mfc0 r2, mngr2proc < 0xdea00eef
    mtx  r2, xr0, 0
    mfx  r3, xr0, 0
    mtc0 r3, proc2mngr > 0xdea00eef

  """.format(
    nops_3=gen_nops(3),
    nops_2=gen_nops(2),
    nops_1=gen_nops(1)
  )

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():

  asm_code = []
  for i in xrange(50):
    value = random.randint(0,0xffffffff)
    asm_code.append( """

      mfc0 r2, mngr2proc < {value}
      mtx  r2, xr0, 0
      mfx  r3, xr0, 0
      mtc0 r3, proc2mngr > {value}

    """.format( **locals() ))

  return asm_code

#-------------------------------------------------------------------------
# gen_basic_gcd_test
#-------------------------------------------------------------------------

def gen_basic_gcd_test():
  return """
    mfc0 r1, mngr2proc < 100
    mfc0 r2, mngr2proc < 24
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtx  r1, xr1, 0
    mtx  r2, xr2, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mfx  r3, xr0, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

#-------------------------------------------------------------------------
# gen_basic_sort_test
#-------------------------------------------------------------------------

def gen_basic_sort_test():
  return """
    mfc0 r1, mngr2proc < 0x2000
    mfc0 r2, mngr2proc < 4
    nop
    nop
    nop
    addu r3, r0, r0
    addu r4, r0, r0
    nop
    nop
    mtx  r1, xr1, 0
    mtx  r2, xr2, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mfx  r3, xr0, 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mtc0 r3, proc2mngr > 1
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    .data
    .word 4
    .word 3
    .word 2
    .word 1
  """

#-------------------------------------------------------------------------
# gen_random_sort_test
#-------------------------------------------------------------------------

def gen_random_sort_test( nwords=50 ):

  # Generate some random data
  data = []
  for i in xrange(nwords):
    # accel assumes signed nubmer (2's complement)
    # only test positive
    data.append( random.randint(0,0x7fffffff) )

  asm_code = []

  init_inst = """
  mfc0 r1, mngr2proc < 0x2000 # base address of data
  mfc0 r2, mngr2proc < {}     # number of words to be sorted
  addu r3, r0, r0
  addu r4, r0, r0
  addu r5, r0, r0
  mtx  r1, xr1, 0
  mtx  r2, xr2, 0
  mfx  r3, xr0, 0             # start sort xcel
  mtc0 r3, proc2mngr > 1      # make sure it finishes
  """.format( nwords )

  asm_code.append( init_inst )

  # sort them to generate a reference
  ref_data = sorted( data )

  # move from memory to check if they are sorted
  for i in xrange(nwords):
    asm_code.append( "lw   r5, {}(r1)".format( 4*i ) )
    asm_code.append( "mtc0 r5, proc2mngr > {}".format( ref_data[i] ) )

  # add the data to the end of the assembly code

  asm_code.append( gen_word_data( data ) )
  return asm_code
