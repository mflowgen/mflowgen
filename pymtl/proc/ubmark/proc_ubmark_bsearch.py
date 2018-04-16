#========================================================================
# ubmark-bsearch: binary search kernel
#========================================================================
#
# This code performs a binary search in a dictionary of key value pairs.
# The corresponding keys and values are accessed by using the same index
# to the respective array (e.g. for dict[v] = k, if v == dict_keys[5],
# then k == dict_values[5]). The dictionary is sorted by keys so that
# dict_keys[i + 1] >= dict_keys[i]. The dictionary size is dict_sz.
#
# The kernel performs searches for the keys in srch_keys in the
# dictionary, and if found, saves the corresponding value to the
# srch_values. There are srch_sz many total queries to the dictionary.
#
# void bin_search( int srch_keys[], int srch_values[], int srch_sz,
#                  int dict_keys[], int dict_values[], int dict_sz ) {
#
#   for ( int i = 0; i < srch_sz; i++ ) {
#     int key     = srch_keys[i];
#     int idx_min = 0;
#     int idx_mid = dict_sz / 2;
#     int idx_max = dict_sz - 1;
#
#     bool done = false;
#     srch_values[i] = -1;
#     do {
#       int midkey = dict_keys[idx_mid];
#
#       if ( key == midkey ) {
#         srch_values[i] = dict_values[idx_mid];
#         done = true;
#       }
#
#       if ( key > midkey )
#         idx_min = idx_mid + 1;
#       else if ( key < midkey )
#         idx_max = idx_mid - 1;
#
#       idx_mid = ( idx_min + idx_max ) / 2;
#
#     } while ( !done && (idx_min <= idx_max) );
#   }
# }

import struct

from pymtl                                import *
from lab2_proc.test.tinyrv2_encoding_test import mk_section
from string                               import translate, maketrans
from lab2_proc.tinyrv2_encoding           import assemble
from lab2_proc.SparseMemoryImage          import SparseMemoryImage

from proc_ubmark_bsearch_data    import d_keys, d_values, s_keys, ref

c_bin_search_s_keys_ptr    = 0x2000;
c_bin_search_s_values_ptr  = 0x3000;
c_bin_search_s_sz          = 20;
c_bin_search_d_keys_ptr    = 0x4000;
c_bin_search_d_values_ptr  = 0x5000;
c_bin_search_d_sz          = 50;

class ubmark_bsearch:

  # verification function, argument is a bytearray from TestMemory instance

  @staticmethod
  def verify( memory ):

    is_pass      = True
    first_failed = -1

    for i in range(c_bin_search_s_sz):
      x = struct.unpack('i', memory[c_bin_search_s_values_ptr + i * 4 : c_bin_search_s_values_ptr + (i+1) * 4] )[0]
      if not ( x == ref[i] ):
        is_pass     = False
        first_faild = i
        print( " [ failed ] dest[{i}]: {x} != ref[{i}]: {ref} ".format( i=i, x=x, ref=ref[i] ) )
        break

    if is_pass:
      print( " [ passed ]: bsearch" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """
    # load array pointers
    csrr  x1, mngr2proc < 0x2000
    csrr  x2, mngr2proc < 0x3000
    csrr  x3, mngr2proc < 20
    csrr  x4, mngr2proc < 0x4000
    csrr  x5, mngr2proc < 0x5000
    csrr  x6, mngr2proc < 50

    addi  x7, x0, 0      # loop counter i is in x7

  zero:
    slli  x25, x7, 2     # multiply by 4 to get i in the index form

    add   x9, x1, x25    # pointer to i in srch_keys
    lw    x9, 0(x9)      # key = srch_keys[i]
    addi  x10, x0, 0     # idx_min
    srai  x11, x6, 1     # idx_mid = dict_sz/2
    addi  x12, x6, -1    # idx_max = (dict_sz-1)
    addi  x13, x0, 0     # done = false

    addi  x14, x0, -1    # -1
    add   x15, x2, x25   # i pointer in srch_values
    sw    x14, 0(x15)    # srch_values[i] = -1

  one:
    slli  x24, x11, 2    # idx_mid in pointer form
    add   x16, x4, x24   # idx_mid pointer in dict_keys
    lw    x17, 0(x16)    # midkey = dict_keys[idx_mid]

    bne   x9, x17, two   #  if ( key == midkey ) goto two:

    # if block starts
    add   x16, x5, x24   # idx_mid pointer in dict_values
    lw    x18, 0(x16)    # dict_values[idx_mid]
    add   x15, x2, x25   # i pointer in srch_values
    sw    x18, 0(x15)    # srch_values[i] = dict_values[idx_mid]
    addi  x13, x0, 1     # done = true
    # if block ends

  two:
    slt   x18, x17, x9   # midkey < key
    beq   x18, x0, three # if ( midkey < key ) goto three

                         # if block for midkey < key
    addi  x10, x11, 1    # idx_min = idx_mid + 1
    jal   x0, four   # if ( midkey > key ) goto four:
    # end of if block

    # else block
  three:
    slt   x18, x9, x17   # if midkey > key
    beq   x18, x0, four  # if ( midkey > key ) goto four:
    # if block for midkey > key
    addi  x12, x11, -1   # idx_max = idx_mid - 1
    # end of if block

  four:
    add   x20, x10, x12  # idx_min + idx_max
    srai  x11, x20, 1    # idx_mid = ( idx_min + idx_max ) / 2

    slt   x21, x12, x10  # idx_max < idx_min
    or    x22, x21, x13  # done || (idx_max < idx_min)
    # while
    # ( !(done || (idx_max < idx_min)) )
    # goto one:
    beq   x22, x0, one

    addi  x7, x7, 1     # i++
    bne   x7, x3, zero   # if (i < srch_sz) goto 0:

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

    d_keys_section = mk_section( ".data", c_bin_search_d_keys_ptr, d_keys )

    mem_image.add_section( d_keys_section )

    d_values_section = mk_section( ".data", c_bin_search_d_values_ptr, d_values )

    mem_image.add_section( d_values_section )

    s_keys_section = mk_section( ".data", c_bin_search_s_keys_ptr, s_keys )

    mem_image.add_section( s_keys_section )

    return mem_image
