#=========================================================================
# Functional Model for Sram SP HDE 28nm
#=========================================================================

from pymtl import *

class SramSpHde28nmFuncPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256, instance_name = '' ):

    AW = clog2( num_words )      # address width
    BW = num_bits                # $ceil(num_bits/8)
    bW = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    # Module name
    s.explicit_modulename = instance_name

    # port names set to match the ARM memory compiler

    # clock (in PyMTL simulation it uses implict .clk port when
    # translated to Verilog, actual clock ports should be CE1
    s.CENY      = OutPort(  1 )
    s.WENY      = OutPort(  1 )
    s.AY        = OutPort( AW )
    s.Q         = OutPort( BW )
    s.SO        = OutPort(  3 )
    #s.CLK      = InPort (  1 )
    s.CEN       = InPort (  1 )
    s.WEN       = InPort ( BW )
    s.A         = InPort ( AW )
    s.D         = InPort ( BW )
    s.EMA       = InPort (  3 )
    s.EMAW      = InPort (  2 )
    s.TEN       = InPort (  1 )
    s.TCEN      = InPort (  1 )
    s.TWEN      = InPort (  1 )
    s.TA        = InPort ( AW )
    s.TD        = InPort ( BW )
    s.GWEN      = InPort (  1 )
    s.TGWEN     = InPort (  1 )
    s.RET1N     = InPort (  1 )
    s.SI        = InPort (  2 )
    s.SE        = InPort (  1 )
    s.DFTRAMBYP = InPort (  1 )

    # memory array

    s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]

    # read path

    s.dout = Wire( num_bits )

    @s.posedge_clk
    def read_logic():
      if ( not s.CEN ) and s.GWEN:
        s.dout.next = s.ram[ s.A ]
      else:
        s.dout.next = 0

    # write path
    @s.posedge_clk
    def write_logic():
      if ( not s.CEN ) and ( not s.GWEN ):
        s.ram[s.A].next = (s.ram[s.A] & s.WEN) | (s.D & ~s.WEN)

    @s.combinational
    def comb_logic():
      s.Q.value = s.dout


  def line_trace( s ):
    return "(A1={} I1A={} O1={})".format( s.A1, s.I1, s.O1 )
