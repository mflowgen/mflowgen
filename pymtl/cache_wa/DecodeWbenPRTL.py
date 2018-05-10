#========================================================================
# lab3-mem Decoder for Write Byte Enable
#========================================================================

from pymtl import *

#------------------------------------------------------------------------
# Decoder for Wben
#------------------------------------------------------------------------

class DecodeWbenPRTL( Model ):

  # interface

  def __init__( s, num_bytes = 4 ):

    # Internal parameters
    lnb   = clog2(num_bytes)

    s.idx = InPort  (    lnb    )
    s.len = InPort  (    lnb    )
    s.out = OutPort ( num_bytes )

    # Combinational logic

    s.meta_len = Wire( lnb + 1)

    @s.combinational
    def comb_logic():

      # Adjusted length
      s.meta_len.value  = num_bytes if s.len == 0 else s.len

      # Concstruct a mask
      s.out     .value = 0
      s.out     .value = ~s.out
      s.out     .value =  s.out << s.meta_len
      s.out     .value = ~s.out

      # Shift to starting index
      s.out     .value = s.out.value << s.idx
