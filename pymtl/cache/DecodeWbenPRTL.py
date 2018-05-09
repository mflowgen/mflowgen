#========================================================================
# lab3-mem Decoder for Write Byte Enable
#========================================================================

from pymtl import *

#------------------------------------------------------------------------
# Decoder for Wben
#------------------------------------------------------------------------

class DecodeWbenPRTL( Model ):

  # interface

  def __init__( s, num_bytes = 4, mask_num_bytes = None ):

    # Internal parameters
    lnb   = clog2(num_bytes)
    mnb   = clog2(num_bytes)

    # If mask is not defined, we assume length is for the number of bytes
    if mask_num_bytes:
      mnb = clog2(mask_num_bytes)

    s.idx = InPort  (    lnb    )
    s.len = InPort  (    mnb    )
    s.out = OutPort ( num_bytes )

    # Combinational logic

    s.len_d   = Wire(   mnb   )

    @s.combinational
    def comb_logic():

      # Adjusted length
      s.len_d.value = s.len - 1

      # Construct a mask
      s.out  .value = 0
      s.out  .value = ~s.out
      s.out  .value = s.out << 1
      s.out  .value = s.out << s.len_d
      s.out  .value = ~s.out

      # Shift to starting index
      s.out  .value = s.out.value << s.idx
