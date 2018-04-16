#=========================================================================
# Generic model of the SRAM
#=========================================================================
# This is meant to be instantiated within a carefully named outer module
# so the outer module corresponds to an SRAM generated with the
# CACTI-based memory compiler.

from pymtl import *

class SramGenericPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256 ):

    addr_width = clog2( num_words )      # address width
    nbytes     = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    # port names set to match the ARM memory compiler

    # clock (in PyMTL simulation it uses implict .clk port when
    # translated to Verilog, actual clock ports should be CE1

    s.CE1  = InPort ( 1 )          # clk
    s.WEB1 = InPort ( 1 )          # bar( write en )
    s.OEB1 = InPort ( 1 )          # bar( out en )
    s.CSB1 = InPort ( 1 )          # bar( whole SRAM en )
    s.A1   = InPort ( addr_width ) # address
    s.I1   = InPort ( num_bits )   # write data
    s.O1   = OutPort( num_bits )   # read data
    s.WBM1 = InPort ( nbytes )     # byte write en

    # memory array

    s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]

    # read path

    s.dout = Wire( num_bits )

    @s.posedge_clk
    def read_logic():
      if ( not s.CSB1 ) and s.WEB1:
        s.dout.next = s.ram[ s.A1 ]
      else:
        s.dout.next = 0

    # write path

    @s.posedge_clk
    def write_logic():
      for i in xrange( nbytes ):
        if ~s.CSB1 and ~s.WEB1 and s.WBM1[i]:
          s.ram[s.A1][ i*8 : i*8+8 ].next = s.I1[ i*8 : i*8+8 ]

    @s.combinational
    def comb_logic():
      if not s.OEB1:
        s.O1.value = s.dout
      else:
        s.O1.value = 0


  def line_trace( s ):
    return "(A1={} I1A={} O1={})".format( s.A1, s.I1, s.O1 )
