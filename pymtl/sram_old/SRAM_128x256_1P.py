#=========================================================================
# 128 bits x 256 words SRAM model
#=========================================================================

from pymtl           import *
from SramGenericPRTL import SramGenericPRTL

class SRAM_128x256_1P( Model ):

  # Make sure widths match the .v

  # This is only a behavior model, treated as a black box when translated
  # to Verilog.

  vblackbox      = True
  vbb_modulename = "SRAM_128x256_1P"
  vbb_no_reset   = True
  vbb_no_clk     = True

  def __init__( s ):

    # clock (in PyMTL simulation it uses implict .clk port when
    # translated to Verilog, actual clock ports should be CE1

    s.CE1  = InPort ( 1   )  # clk
    s.WEB1 = InPort ( 1   )  # bar( write en )
    s.OEB1 = InPort ( 1   )  # bar( out en )
    s.CSB1 = InPort ( 1   )  # bar( whole SRAM en )
    s.A1   = InPort ( 8   )  # address
    s.I1   = InPort ( 128 )  # write data
    s.O1   = OutPort( 128 )  # read data
    s.WBM1 = InPort ( 16  )  # byte write en

    # instantiate a generic sram inside

    s.sram_generic = SramGenericPRTL( 128, 256 )

    s.connect( s.CE1,  s.sram_generic.CE1  )
    s.connect( s.WEB1, s.sram_generic.WEB1 )
    s.connect( s.OEB1, s.sram_generic.OEB1 )
    s.connect( s.CSB1, s.sram_generic.CSB1 )
    s.connect( s.A1,   s.sram_generic.A1   )
    s.connect( s.I1,   s.sram_generic.I1   )
    s.connect( s.O1,   s.sram_generic.O1   )
    s.connect( s.WBM1, s.sram_generic.WBM1 )
