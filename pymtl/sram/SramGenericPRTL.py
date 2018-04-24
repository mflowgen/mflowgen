#=========================================================================
# Generic model of the SRAM
#=========================================================================
# This is meant to be instantiated within a carefully named outer module
# so the outer module corresponds to an SRAM generated with the
# CACTI-based memory compiler.

from pymtl import *

class SramGenericPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256, instance_name = '' ):

    addr_width = clog2( num_words )      # address width
    nbytes     = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    # BRG SRAM's golden interface

    s.wen  = InPort ( 1 )          # write en
    s.cen  = InPort ( 1 )          # whole SRAM en
    s.addr = InPort ( addr_width ) # address
    s.in_  = InPort ( num_bits )   # write data
    s.out  = OutPort( num_bits )   # read data
    s.mask = InPort ( nbytes )     # byte write en

    # memory array

    s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]

    # read path

    s.dout = Wire( num_bits )

    @s.posedge_clk
    def read_logic():
      if s.cen and ( not s.wen ):
        s.dout.next = s.ram[ s.addr ]
      else:
        s.dout.next = 0

    # write path

    @s.posedge_clk
    def write_logic():
      for i in xrange( nbytes ):
        if s.cen and s.wen and s.mask[i]:
          s.ram[s.addr][ i*8 : i*8+8 ].next = s.in_[ i*8 : i*8+8 ]

    @s.combinational
    def comb_logic():
      s.out.value = s.dout


  def line_trace( s ):
    return "(addr={} din={} dout={})".format( s.addr, s.in_, s.out )
