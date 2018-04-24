#=========================================================================
# SRAM Wrapper for sram_sp_hde 28nm
#=========================================================================

from pymtl import *

# SRAMs Functional model
from sram.SramSpHde28nmFuncPRTL import SramSpHde28nmFuncPRTL

class SramWrapper28nmPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256, instance_name = '' ):

    AW = clog2( num_words )      # address width
    nb = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)
    BW = num_bits

    # BRG SRAM's golden interface

    s.wen  = InPort (  1 )          # write en
    s.cen  = InPort (  1 )          # whole SRAM en
    s.addr = InPort ( AW ) # address
    s.in_  = InPort ( BW )   # write data
    s.out  = OutPort( BW )   # read data
    s.mask = InPort ( nb )     # byte write en

    # Instantiate ARM functional model

    s.mem  = SramSpHde28nmFuncPRTL( num_bits, num_words, instance_name )

    # Wires
    s.CENY      = Wire(  1 )
    s.WENY      = Wire(  1 )
    s.AY        = Wire( AW )
    s.Q         = Wire( BW )
    s.SO        = Wire(  3 )
    s.CEN       = Wire(  1 )
    s.WEN       = Wire( BW )
    s.A         = Wire( AW )
    s.D         = Wire( BW )
    s.EMA       = Wire(  3 )
    s.EMAW      = Wire(  2 )
    s.TEN       = Wire(  1 )
    s.TCEN      = Wire(  1 )
    s.TWEN      = Wire(  1 )
    s.TA        = Wire( AW )
    s.TD        = Wire( BW )
    s.GWEN      = Wire(  1 )
    s.TGWEN     = Wire(  1 )
    s.RET1N     = Wire(  1 )
    s.SI        = Wire(  2 )
    s.SE        = Wire(  1 )
    s.DFTRAMBYP = Wire(  1 )

    # Connect
    s.connect_pairs (

      # Input
      s    .CENY      , s.mem.CENY      ,
      s    .WENY      , s.mem.WENY      ,
      s    .AY        , s.mem.AY        ,
      s    .Q         , s.mem.Q         ,
      s    .SO        , s.mem.SO        ,

      # Output
      s.mem.CEN       , s    .CEN       ,
      s.mem.WEN       , s    .WEN       ,
      s.mem.A         , s    .A         ,
      s.mem.D         , s    .D         ,
      s.mem.GWEN      , s    .GWEN      ,

      # Special Constants
      s.mem.EMA       , 3               ,
      s.mem.EMAW      , 1               ,

      # Test Constants
      s.mem.TEN       , 1               ,
      s.mem.TCEN      , 1               ,
      s.mem.TWEN      , 1               ,
      s.mem.TGWEN     , 1               ,
      s.mem.TA        , 0               ,
      s.mem.TD        , 0               ,
      s.mem.RET1N     , 0               ,
      s.mem.SI        , 0               ,
      s.mem.SE        , 0               ,
      s.mem.DFTRAMBYP , 0               ,

      #s.mem.EMA       , s    .EMA       ,
      #s.mem.EMAW      , s    .EMAW      ,
      #s.mem.TEN       , s    .TEN       ,
      #s.mem.TCEN      , s    .TCEN      ,
      #s.mem.TWEN      , s    .TWEN      ,
      #s.mem.TGWEN     , s    .TGWEN     ,
      #s.mem.TA        , s    .TA        ,
      #s.mem.TD        , s    .TD        ,
      #s.mem.RET1N     , s    .RET1N     ,
      #s.mem.SI        , s    .SI        ,
      #s.mem.SE        , s    .SE        ,
      #s.mem.DFTRAMBYP , s    .DFTRAMBYP ,

    )

    # Wrapping Logic
    @s.combinational
    def comb():

      # Output request
      s.out.value = s.Q

      # Input request
      s.CEN .value = ~s.cen
      s.GWEN.value = ~s.wen
      s.A   .value =  s.addr
      s.D   .value =  s.in_

      # Mask
      for i in xrange(nb):
        for b in xrange(8):
          s.WEN[i*8 + b].value = ~s.mask[i]


  def line_trace( s ):
    return "(addr={} din={} dout={})".format( s.addr, s.in_, s.out )
