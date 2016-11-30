#========================================================================
# ubmark-bin-search: binary search kernel
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

from pymtl                       import *
from parc_encoding               import assemble
from parc_encoding_test          import mk_section
from string                      import translate, maketrans
from SparseMemoryImage           import SparseMemoryImage

from proc_ubmark_bin_search_data import d_keys, d_values, s_keys, ref

c_bin_search_s_keys_ptr    = 0x2000;
c_bin_search_s_values_ptr  = 0x3000;
c_bin_search_s_sz          = 20;
c_bin_search_d_keys_ptr    = 0x4000;
c_bin_search_d_values_ptr  = 0x5000;
c_bin_search_d_sz          = 50;

class ubmark_bin_search:

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
      print( " [ passed ]: bin-search" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """
    # load array pointers
    mfc0  r1, mngr2proc < 0x2000
    mfc0  r2, mngr2proc < 0x3000
    mfc0  r3, mngr2proc < 20
    mfc0  r4, mngr2proc < 0x4000
    mfc0  r5, mngr2proc < 0x5000
    mfc0  r6, mngr2proc < 50

    addiu r7, r0, 0      # loop counter i is in r7

  zero:
    sll   r25, r7, 2     # multiply by 4 to get i in the index form

    addu  r9, r1, r25    # pointer to i in srch_keys
    lw    r9, 0(r9)      # key = srch_keys[i]
    addiu r10, r0, 0     # idx_min
    sra   r11, r6, 1     # idx_mid = dict_sz/2
    addiu r12, r6, -1    # idx_max = (dict_sz-1)
    addiu r13, r0, 0     # done = false

    addiu r14, r0, -1    # -1
    addu  r15, r2, r25   # i pointer in srch_values
    sw    r14, 0(r15)    # srch_values[i] = -1

  one:
    sll   r24, r11, 2    # idx_mid in pointer form
    addu  r16, r4, r24   # idx_mid pointer in dict_keys
    lw    r17, 0(r16)    # midkey = dict_keys[idx_mid]

    bne   r9, r17, two   #  if ( key == midkey ) goto two:

    # if block starts
    addu  r16, r5, r24   # idx_mid pointer in dict_values
    lw    r18, 0(r16)    # dict_values[idx_mid]
    addu  r15, r2, r25   # i pointer in srch_values
    sw    r18, 0(r15)    # srch_values[i] = dict_values[idx_mid]
    addiu r13, r0, 1     # done = true
    # if block ends

  two:
    slt   r18, r17, r9   # midkey < key
    beq   r18, r0, three # if ( midkey < key ) goto three

                         # if block for midkey < key
    addiu r10, r11, 1    # idx_min = idx_mid + 1
    j     four           # if ( midkey > key ) goto four:
    # end of if block

    # else block
  three:
    slt   r18, r9, r17   # if midkey > key
    beq   r18, r0, four  # if ( midkey > key ) goto four:
    # if block for midkey > key
    addiu r12, r11, -1   # idx_max = idx_mid - 1
    # end of if block

  four:
    addu  r20, r10, r12  # idx_min + idx_max
    sra   r11, r20, 1    # idx_mid = ( idx_min + idx_max ) / 2

    slt   r21, r12, r10  # idx_max < idx_min
    or    r22, r21, r13  # done || (idx_max < idx_min)
    # while
    # ( !(done || (idx_max < idx_min)) )
    # goto one:
    beq   r22, r0, one

    addiu r7,  r7, 1     # i++
    bne   r7, r3, zero   # if (i < srch_sz) goto 0:

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

    d_keys_section = mk_section( ".data", c_bin_search_d_keys_ptr, d_keys )

    mem_image.add_section( d_keys_section )

    d_values_section = mk_section( ".data", c_bin_search_d_values_ptr, d_values )

    mem_image.add_section( d_values_section )

    s_keys_section = mk_section( ".data", c_bin_search_s_keys_ptr, s_keys )

    mem_image.add_section( s_keys_section )

    return mem_image
