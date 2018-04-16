#========================================================================
# ubmark-cmult: complex multiply kernel
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

from pymtl                                import *
from lab2_proc.test.tinyrv2_encoding_test import mk_section
from string                               import translate, maketrans
from lab2_proc.tinyrv2_encoding           import assemble
from lab2_proc.SparseMemoryImage          import SparseMemoryImage

from proc_ubmark_cmult_data      import src0, src1, ref

# pointers for the input and output arrays
c_cmplx_mult_src0_ptr = 0x2000
c_cmplx_mult_src1_ptr = 0x3000
c_cmplx_mult_dest_ptr = 0x4000
c_cmplx_mult_size     = 200

class ubmark_cmult:

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
      print( " [ passed ]: cmult" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """
    # load array pointers
    csrr  x1, mngr2proc < 200
    csrr  x2, mngr2proc < 0x2000
    csrr  x3, mngr2proc < 0x3000
    csrr  x4, mngr2proc < 0x4000
    addi  x5, x0, 0

  loop:
    lw    x6, 0(x2)    # src0_real
    lw    x8, 0(x3)    # src1_real
    lw    x7, 4(x2)    # src0_imag
    lw    x9, 4(x3)    # src1_imag
    mul   x10, x6, x8  # real * real
    mul   x11, x7, x9  # imag * imag
    mul   x12, x7, x8  # imag * real
    mul   x13, x6, x9  # real * imag
    sub   x14, x10,x11 # dest_real
    add   x15, x12,x13 # dest_imag
    addi  x5, x5, 2
    addi  x2, x2, 8
    addi  x3, x3, 8
    sw    x14, 0(x4)
    sw    x15, 4(x4)
    addi  x4, x4, 8
    bne   x5, x1, loop

    # end of the program
    csrw  proc2mngr, x0 > 0
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
