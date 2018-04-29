#=========================================================================
# SRAM Wrapper for memories in 28nm technology node
#=========================================================================

from pymtl import *

# SRAMs Functional model
from sram.SramSpHde28nmFuncPRTL import SramSpHde28nmFuncPRTL
from sram.  RfSpHde28nmFuncPRTL import   RfSpHde28nmFuncPRTL

class SramWrapper28nmPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256, module_name = '' ):

    AW = clog2( num_words )      # address width
    nb = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)
    BW = num_bits

    # BRG SRAM's golden interface

    s.we    = InPort (  1 )   # write en
    s.ce    = InPort (  1 )   # whole SRAM en
    s.addr  = InPort ( AW )   # address
    s.in_   = InPort ( BW )   # write data
    s.out   = OutPort( BW )   # read data
    s.wmask = InPort ( nb )   # byte write en

    # Instantiate ARM functional model

    if num_words >= 32 and num_words <= 512:
      s.mem   = RfSpHde28nmFuncPRTL( num_bits, num_words, module_name )
      s.type_ = 'rf_sp_hde'
    elif num_words >= 1024:
      s.mem   = SramSpHde28nmFuncPRTL( num_bits, num_words, module_name )
      s.type_ = 'sram_sp_hde'

    # Wires
    s.ceny      = Wire(  1 )
    s.weny      = Wire(  1 )
    s.ay        = Wire( AW )
    s.q         = Wire( BW )
    s.so        = Wire(  3 )
    s.cen       = Wire(  1 )
    s.wen       = Wire( BW )
    s.a         = Wire( AW )
    s.d         = Wire( BW )
    s.ema       = Wire(  3 )
    s.emaw      = Wire(  2 )
    s.ten       = Wire(  1 )
    s.tcen      = Wire(  1 )
    s.twen      = Wire(  1 )
    s.ta        = Wire( AW )
    s.td        = Wire( BW )
    s.gwen      = Wire(  1 )
    s.tgwen     = Wire(  1 )
    s.ret1n     = Wire(  1 )
    s.si        = Wire(  2 )
    s.se        = Wire(  1 )
    s.dftrambyp = Wire(  1 )

    # Common connections

    # Connect
    s.connect_pairs (

      # Outputs
      s    .q         , s.mem.q         ,

      # Inputs
      s.mem.cen       , s    .cen       ,
      s.mem.wen       , s    .wen       ,
      s.mem.a         , s    .a         ,
      s.mem.d         , s    .d         ,
      s.mem.gwen      , s    .gwen      ,

      # Special Constants
      s.mem.ema       , 3               ,
      s.mem.emaw      , 1               ,

      # Test Constants
      s.mem.ret1n     , 0               ,

    )

    # Only SRAMs

    if s.type_ == 'sram_sp_hde':
      # Connect
      s.connect_pairs (

        # Outputs
        s    .ceny      , s.mem.CENY      ,
        s    .weny      , s.mem.WENY      ,
        s    .ay        , s.mem.AY        ,
        s    .so        , s.mem.SO        ,

        # Test Constants
        s.mem.ten       , 1               ,
        s.mem.tcen      , 1               ,
        s.mem.twen      , 1               ,
        s.mem.tgwen     , 1               ,
        s.mem.ta        , 0               ,
        s.mem.td        , 0               ,
        s.mem.si        , 0               ,
        s.mem.se        , 0               ,
        s.mem.dftrambyp , 0               ,

      )


    # Wrapping Logic
    @s.combinational
    def comb():

      # Output request
      s.out.value = s.q

      # Input request
      s.cen .value = ~s.ce
      s.gwen.value = ~s.we
      s.a   .value =  s.addr
      s.d   .value =  s.in_

      # Mask
      for i in xrange(nb):
        for b in xrange(8):
          s.wen[i*8 + b].value = ~s.wmask[i]

  def line_trace( s ):
    return "(addr={} din={} dout={})".format( s.addr, s.in_, s.out )
