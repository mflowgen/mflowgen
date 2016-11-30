#========================================================================
# ubmark-cmplx-mult: complex multiply kernel
#========================================================================
#
# This code performs complex multiplication for two arrays:
#
# void cmplx_mult( int *dest, int *src0, int *src1, int size ) {
#   for ( int i = 0; i < size; i += 2 ) {
#     int src0_real = src0[i];
#     int src0_imag = src0[i+1];
#     int src1_real = src1[i];
#     int src1_imag = src1[i+1];
#     int result_real = ( src0_real * src1_real ) -
#                       ( src0_imag * src1_imag );
#     int result_imag = ( src0_real * src1_imag ) +
#                       ( src0_imag * src1_real );
#     dest[i]   = result_real;
#     dest[i+1] = result_imag;
# }

import struct

from pymtl                       import *
from parc_encoding               import assemble
from parc_encoding_test          import mk_section
from string                      import translate, maketrans
from SparseMemoryImage           import SparseMemoryImage

from proc_ubmark_cmplx_mult_data import src0, src1, ref

# pointers for the input and output arrays
c_cmplx_mult_src0_ptr = 0x2000
c_cmplx_mult_src1_ptr = 0x3000
c_cmplx_mult_dest_ptr = 0x4000
c_cmplx_mult_size     = 200

class ubmark_cmplx_mult:

  # verification function, argument is a bytearray from TestMemory instance

  @staticmethod
  def verify( memory ):

    is_pass      = True
    first_failed = -1

    for i in range(c_cmplx_mult_size):
      x = struct.unpack('i', memory[c_cmplx_mult_dest_ptr + i * 4 : c_cmplx_mult_dest_ptr + (i+1) * 4] )[0]
      if not ( x == ref[i] ):
        is_pass     = False
        first_faild = i
        print( " [ failed ] dest[{i}]: {x} != ref[{i}]: {ref} ".format( i=i, x=x, ref=ref[i] ) )
        return False

    if is_pass:
      print( " [ passed ]: cmplx-mult" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """
    # load array pointers
    mfc0  r1, mngr2proc < 200
    mfc0  r2, mngr2proc < 0x2000
    mfc0  r3, mngr2proc < 0x3000
    mfc0  r4, mngr2proc < 0x4000
    addiu r5, r0, 0

  loop:
    lw    r6, 0(r2)    # src0_real
    lw    r8, 0(r3)    # src1_real
    lw    r7, 4(r2)    # src0_imag
    lw    r9, 4(r3)    # src1_imag
    mul   r10, r6, r8  # real * real
    mul   r11, r7, r9  # imag * imag
    mul   r12, r7, r8  # imag * real
    mul   r13, r6, r9  # real * imag
    subu  r14, r10,r11 # dest_real
    addu  r15, r12,r13 # dest_imag
    addiu r5, r5, 2
    addiu r2, r2, 8
    addiu r3, r3, 8
    sw    r14, 0(r4)
    sw    r15, 4(r4)
    addiu r4, r4, 8
    bne   r5, r1, loop

    # end of the program
    mtc0  r0, proc2mngr > 0
    nop
    nop
    nop
    nop
    nop
    nop
"""

    mem_image = assemble( text )

    # load data by manually create data sections using binutils

    src0_section = mk_section( ".data", c_cmplx_mult_src0_ptr, src0 )

    mem_image.add_section( src0_section )

    src1_section = mk_section( ".data", c_cmplx_mult_src1_ptr, src1 )

    mem_image.add_section( src1_section )

    return mem_image
