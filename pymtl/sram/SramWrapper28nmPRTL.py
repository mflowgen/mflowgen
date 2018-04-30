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

    #------------------------------
    # BRG SRAM's golden interface
    #------------------------------

    s.we    = InPort (  1 )   # write en
    s.ce    = InPort (  1 )   # whole SRAM en
    s.addr  = InPort ( AW )   # address
    s.in_   = InPort ( BW )   # write data
    s.out   = OutPort( BW )   # read data
    s.wmask = InPort ( nb )   # byte write en

    #------------------------------
    # Handle physical banking
    #------------------------------

    banking_hor    = 1
    banking_ver    = 1

    bank_num_bits  = num_bits
    bank_num_words = num_words

    while (bank_num_bits > 128):
      banking_hor    *= 2
      assert( num_bits % banking_hor == 0)
      bank_num_bits   = num_bits / banking_hor

    while (bank_num_words > 4096):
      banking_ver    *= 2
      assert( num_words % banking_ver == 0)
      bank_num_words  = num_words / banking_ver

    #------------------------------
    # Choosing appropriate model
    #------------------------------

    if   num_words >= 32 and num_words <= 512:
      sram_model = RfSpHde28nmFuncPRTL
      sram_type  = 'rf_sp_hde'

    elif num_words >= 1024:
      sram_model = SramSpHde28nmFuncPRTL
      sram_type  = 'sram_sp_hde'

    else:
      raise ValueError

    #------------------------------
    # Generate automatic naming
    #------------------------------
    if (banking_hor > 1 or banking_ver > 1) or \
       (module_name == ''):

      # Force automatic module name generation if banking is to be
      # enforced or if module_name was not specified by parent module
      module_name = 'sram_28nm_{}x{}_SP'.format( bank_num_bits  ,
                                                 bank_num_words )

    #------------------------------
    # Instantiating Memories
    #------------------------------

    # We only support Horizantal banking for now
    assert(banking_ver == 1)

    s.mem = []
    for v in xrange(banking_ver):
      s.mem.append([])
      for h in xrange(banking_hor):
        s.mem[v].append( sram_model( bank_num_bits  ,
                                     bank_num_words ,
                                     module_name    ) )

    # Needed for different ports
    s.type_ = sram_type

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

    # Connect all physical banks
    for v in xrange(banking_ver):
      for h in xrange(banking_hor):

        # Specify bank
        bank = s.mem[v][h]

        # Boundries
        l  = (h + 0) * bank_num_bits
        h  = (h + 1) * bank_num_bits

        # Connect
        s.connect_pairs (

          # Outputs
          s    .q   [l:h] ,  bank.q         ,

          # Inputs
           bank.cen       , s    .cen       ,
           bank.wen       , s    .wen [l:h] ,
           bank.a         , s    .a         ,
           bank.d         , s    .d   [l:h] ,
           bank.gwen      , s    .gwen      ,

          # Special Constants
           bank.ema       , 3               ,
           bank.emaw      , 1               ,

          # Test Constants
           bank.ret1n     , 0               ,

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
