#========================================================================
# SRAM Wrapper
#========================================================================
# This is a simple val/rdy wrapper around an SRAM that is supposed to be
# generated using the ARM memory compiler. We add a skid buffer in order
# to support val/rdy protocol. A correct solution will have two or more
# elements of buffering in the memory response queue _and_ stall M0 if
# there are less than two free elements in the queue. Thus in the worst
# case, if M2 stalls we have room for two messages in the response queue:
# the message currently in M1 and the message currently in M0. Here is
# the updated design:
#
#         .------.          .------.
#         |      |          | 2elm |
#   M0 -> | sram | -> M1 -> | bypq | -> M2
#         |      |       .- |      |
#         '^-----'       |  '^-----'
#                        |
#  rdy <-(if nfree == 2)-'
#
# Here is the updated pipeline
# diagram.
#
#  cycle : 0  1  2  3  4  5
#  msg a : M0 M2
#  msg b :    M0 M2
#  msg c :       M0 M1 M2 M2 M2
#  msg d :          M0 q  q  q   # msg c is in skid buffer
#  msg e :             M0 M0 M0
#
#  cycle M0 M1 [q ] M2
#     0: a
#     1: b  a       a  # a is flows through bypass queue
#     2: c  b       b  # b is flows through bypass queue
#     3: d  c          # M2 is stalled, c will need to go into bypq
#     4: e  d    c     #
#     5: e      dc     # d skids behind c into the bypq
#
# Note, with a pipe queue you still need two elements of buffering.
# There could be a message in the response queue when M2 stalls and then
# you still don't have anywhere to put the message currently in M1.

from pymtl             import *
from pclib.ifcs        import InValRdyBundle, OutValRdyBundle
from pclib.ifcs        import MemReqMsg, MemRespMsg
from pclib.rtl         import RegRst, Mux
from pclib.rtl         import SingleElementBypassQueue, TwoElementBypassQueue

#-------------------------------------------------------------------------
# Verilog model of the SRAM
#-------------------------------------------------------------------------

# Module name set to match the ARM memory compiler

class SRAM( Model ):

  # Make sure widths match the .v

  vblackbox      = True
  vbb_modulename = "arm_sram_32x1024"
  vbb_no_reset   = True
  vbb_no_clk     = True

  def __init__( s, num_bits = 32, num_words = 1024 ):

    addr_width = clog2( num_words )  # address width

    # port names set to match the ARM memory compiler

    # clock (in PyMTL simulation it uses implict .clk port when
    # translated to Verilog, clock ports should be CLKA and CLKB

    s.CLKA = InPort ( 1 )
    s.CLKB = InPort ( 1 )

    # Port A
    s.QA   = OutPort( num_bits )     # read data
    s.CENA = InPort ( 1 )            # clock enable, active low
    s.WENA = InPort ( 4 )            # write enable per byte, active low
    s.AA   = InPort ( addr_width )   # address
    s.DA   = InPort ( num_bits )     # write data

    # Port B
    s.QB   = OutPort( num_bits )
    s.CENB = InPort ( 1 )
    s.WENB = InPort ( 4 )
    s.AB   = InPort ( addr_width )
    s.DB   = InPort ( num_bits )

    #.....................................................................
    # Instantiate BRAM instead of SRAM
    #.....................................................................
    # We instantiate BRAM here instead of SRAM.
    #
    # This SRAM is marked as a black box using vblackbox, so the internals
    # will be ignored during synthesis. Taking advantage of this, we are
    # putting BRAM into the internals so we can use the same module to
    # infer BRAMs when synthesized by the FPGA tools.
    #
    # The SRAM/BRAM ports are not quite the same. Here is how SRAM and
    # BRAM ports match up:
    #
    #     SRAM        BRAM
    #     -----------------------------------------
    #     QA          data1_out # Port A data out
    #     WENA        type1     # Port A write en (SRAM active low, BRAM high)
    #     AA          addr1     # Port A address
    #     DA          data1_in  # Port A data in
    #
    #     QB          data2_out # Port B data out
    #     WENB        type2     # Port B write en (SRAM active low, BRAM high)
    #     AB          addr2     # Port B address
    #     DB          data2_in  # Port B data in
    #
    #     CENA        en        # SRAM: port en (active low)
    #     CENB                  # BRAM: global en (active high)
    #
    # So there is an exact match up except for:
    #
    # - write_en : SRAM wen is 4-bit active low per-byte
    #            : BRAM wen is 3-bit active high
    # - enables  : SRAM has port enables
    #            : BRAM has global enable
    #
    # IMPORTANT: We set the BRAM request type (i.e., the write en) by
    # using (WEN == 0b0000). Note that even though the WEN is per-byte (4
    # bits), since we will only do word-aligned writes, we only check all
    # of the wen bits at once to see what to do.
    #
    # We make the BRAM global en by OR'ing the two SRAM port enables.

    s.bram_en        = Wire( 1 )

    s.bram_a_addr    = Wire( addr_width )
    s.bram_a_type    = Wire( 3 )
    s.bram_a_wdata   = Wire( num_bits )
    s.bram_a_rdata   = Wire( num_bits ) # read data, output of bram, M1 stage

    s.bram_b_addr    = Wire( addr_width )
    s.bram_b_type    = Wire( 3 )
    s.bram_b_wdata   = Wire( num_bits )
    s.bram_b_rdata   = Wire( num_bits )

    @s.combinational
    def comb_M0():

      # Port A
      s.bram_a_addr.value    = s.AA
      s.bram_a_type.value    = (s.WENA == 0b0000)
      s.bram_a_wdata.value   = s.DA
      s.QA.value             = s.bram_a_rdata

      # Port B
      s.bram_b_addr.value    = s.AB
      s.bram_b_type.value    = (s.WENB == 0b0000)
      s.bram_b_wdata.value   = s.DB
      s.QB.value             = s.bram_b_rdata

      s.bram_en.value        = (~s.CENA) | (~s.CENB)

    # BRAM

    s.bram = m = Bram2rw( num_bits, num_words )

    s.connect_pairs(
      s.bram_en,        m.en,

      s.bram_a_addr,    m.addr1,
      s.bram_a_type,    m.type1,
      s.bram_a_wdata,   m.data1_in,
      s.bram_a_rdata,   m.data1_out,

      s.bram_b_addr,    m.addr2,
      s.bram_b_type,    m.type2,
      s.bram_b_wdata,   m.data2_in,
      s.bram_b_rdata,   m.data2_out
    )

    #.........................................................................
    # Original SRAM memory array
    #.........................................................................

    # s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]
    #
    # @s.posedge_clk
    # def seq_logic():
    #   if not s.CENA:
    #     # port A is valid if CEN is low
    #     if not s.WENA:
    #       s.ram[ s.AA ].next = s.DA
    #       s.QA.next          = 0
    #     else:
    #       s.QA.next          = s.ram[ s.AA ]
    #
    #   if not s.CENB:
    #     # port B is valid if CEN is low
    #     if not s.WENB:
    #       s.ram[ s.AB ].next = s.DB
    #       s.QB.next          = 0
    #     else:
    #       s.QB.next          = s.ram[ s.AB ]

  def line_trace( s ):

    # Type ('wr', 'rd', '--')

    if ~s.CENA:
      if ~s.WENA[0] : typeA = 'wr'
      else          : typeA = 'rd'
    else:
      typeA = '--'

    if ~s.CENB:
      if ~s.WENB[0] : typeB = 'wr'
      else          : typeB = 'rd'
    else:
      typeB = '--'

    # Address shifted by 2 to better check against request address

    addrA = s.AA * 4
    addrB = s.AB * 4

    return "(A:{}:{}:{}:{}) (B:{}:{}:{}:{})".format(
        typeA, addrA, s.DA, s.QA,
        typeB, addrB, s.DB, s.QB )

#-------------------------------------------------------------------------
# BRAM
#-------------------------------------------------------------------------
# The Verilog that correctly infers BRAM in sim/verilog/bram-Bram2rw.v has
# this interface:
#
#   input                             clk,
#   input                             en,
#
#   input      [row_addr_bits-1:0]    addr1, // choose the "line" or COL to access
#   input      [p_type_width-1:0]     type1,
#   input      [p_col_width-1:0]      data1_in,
#   output reg [p_col_width-1:0]      data1_out,
#
#   input      [row_addr_bits-1:0]    addr2,
#   input      [p_type_width-1:0]     type2,
#   input      [p_col_width-1:0]      data2_in,
#   output reg [p_col_width-1:0]      data2_out
#
# Here we are matching it in PyMTL.

class Bram2rw( Model ):

  vmark_as_bram    = True                                 # suppress wire/array declarations
  vannotate_arrays = { 'ram': '(* RAM_STYLE="BLOCK" *)' } # annotate 'ram' to infer BRAM

  def __init__( s, num_bits = 32, num_words = 128 ):

    addr_width = clog2( num_words )       # address width

    s.en        = InPort ( 1 )            # enable

    # Port A
    s.data1_out = OutPort( num_bits )     # read data
    s.type1     = InPort ( 3 )            # type (0 read, 1 write)
    s.addr1     = InPort ( addr_width )   # address
    s.data1_in  = InPort ( num_bits )     # write data

    # Port B
    s.data2_out = OutPort( num_bits )     # read data
    s.type2     = InPort ( 3 )            # type (0 read, 1 write)
    s.addr2     = InPort ( addr_width )   # address
    s.data2_in  = InPort ( num_bits )     # write data

    # memory array

    s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]

    @s.posedge_clk
    def seq_logic():
      if s.en:
        # Port A
        # write first, so written data is latched
        if s.type1 == 1:
          s.ram[ s.addr1 ].next = s.data1_in
          s.data1_out.next      = 0
        else:
          s.data1_out.next      = s.ram[ s.addr1 ]

        # Port B
        # write first, so written data is latched
        if s.type2 == 1:
          s.ram[ s.addr2 ].next = s.data2_in
          s.data2_out.next      = 0
        else:
          s.data2_out.next      = s.ram[ s.addr2 ]

  def line_trace( s ):
    return ''
#    return "(addr1={} data1_in={} data1_out={}) (addr2={} data2_in={} data2_out={})".format( s.addr1, s.data1_in, s.data1_out, s.addr2, s.data2_in, s.data2_out )

#-------------------------------------------------------------------------
# SRAM wrapper with val/rdy interfaces
#-------------------------------------------------------------------------

class SramWrapper( Model ):

  # Defaults: 32b accesses * 6144 words = 24KB, partitioned into 6 subarrays

  def __init__( s, num_bits = 32, num_words = 6144, num_subarrays = 6 ):

    # use explicit_modulename

    s.explicit_modulename = 'SramWrapper'

    # Interface

    # Default memory message has 8 bits opaque field and 32 bits address.

    s.memreqa  = InValRdyBundle ( MemReqMsg ( 8, 32, num_bits ) )
    s.memrespa = OutValRdyBundle( MemRespMsg( 8,     num_bits ) )

    s.memreqb  = InValRdyBundle ( MemReqMsg ( 8, 32, num_bits ) )
    s.memrespb = OutValRdyBundle( MemRespMsg( 8,     num_bits ) )

    addr_width          = clog2( num_words )               # address width
    subarray_addr_width = clog2( num_words/num_subarrays ) # address width of each subarray

    #---------------------------------------------------------------------
    # MO stage
    #---------------------------------------------------------------------

    s.memreqa_go_M0       = Wire( 1 )
    s.memreqb_go_M0       = Wire( 1 )

    s.sram_a_addr_M0      = Wire( addr_width )
    s.sram_a_wen_M0       = Wire( 4 )
    s.sram_a_en_M0        = Wire( 1 )
    s.sram_a_wen_bar_M0   = Wire( 4 )
    s.sram_a_en_bar_M0    = Wire( 1 )
    s.sram_a_wdata_M0     = Wire( num_bits )
    s.sram_a_rdata_sub_M1 = [ Wire( num_bits ) for _ in xrange( num_subarrays ) ] # read data, output of sram, M1 stage

    s.sram_b_addr_M0      = Wire( addr_width )
    s.sram_b_wen_M0       = Wire( 4 )
    s.sram_b_en_M0        = Wire( 1 )
    s.sram_b_wen_bar_M0   = Wire( 4 )
    s.sram_b_en_bar_M0    = Wire( 1 )
    s.sram_b_wdata_M0     = Wire( num_bits )
    s.sram_b_rdata_sub_M1 = [ Wire( num_bits ) for _ in xrange( num_subarrays ) ]

    s.memreqa_msg_addr = Wire( 32 )
    s.memreqb_msg_addr = Wire( 32 )

    @s.combinational
    def addr_M0():
      s.memreqa_msg_addr.value = s.memreqa.msg.addr
      s.memreqb_msg_addr.value = s.memreqb.msg.addr

    addr_width_plus2 = addr_width + 2

    @s.combinational
    def comb_M0():
      # Port A
      s.memreqa_go_M0.value     = s.memreqa.val & s.memreqa.rdy
      s.sram_a_addr_M0.value    = s.memreqa_msg_addr[2:addr_width_plus2]
      s.sram_a_wen_M0.value     = \
        0b1111 if ( s.memreqa.val & (s.memreqa.msg.type_ == 1) ) else 0b0000
      s.sram_a_en_M0.value      = s.memreqa_go_M0
      s.sram_a_wen_bar_M0.value = ~s.sram_a_wen_M0
      s.sram_a_en_bar_M0.value  = ~s.sram_a_en_M0
      s.sram_a_wdata_M0.value   = s.memreqa.msg.data
      # Port B
      s.memreqb_go_M0.value     = s.memreqb.val & s.memreqb.rdy
      s.sram_b_addr_M0.value    = s.memreqb_msg_addr[2:addr_width_plus2]
      s.sram_b_wen_M0.value     = \
        0b1111 if ( s.memreqb.val & (s.memreqb.msg.type_ == 1) ) else 0b0000
      s.sram_b_en_M0.value      = s.memreqb_go_M0
      s.sram_b_wen_bar_M0.value = ~s.sram_b_wen_M0
      s.sram_b_en_bar_M0.value  = ~s.sram_b_en_M0
      s.sram_b_wdata_M0.value   = s.memreqb.msg.data

    # Divide signal to subarrays

    s.subarray_a_en_bar  = Wire( num_subarrays )
    s.subarray_a_wen_bar = [ Wire( 4 ) for _ in xrange( num_subarrays ) ]
    s.subarray_a_addr    = Wire( subarray_addr_width )
    s.subarray_b_en_bar  = Wire( num_subarrays )
    s.subarray_b_wen_bar = [ Wire( 4 ) for _ in xrange( num_subarrays ) ]
    s.subarray_b_addr    = Wire( subarray_addr_width )

    subarray_addr_width_plus2 = subarray_addr_width + 2

    # Turn on only the subarray ports designated by the upper address bits
    #
    # - turn off all subarrays
    # - iterate over xrange( num_subarrays )
    # - if address upper bits match this subarray, turn it on.
    #
    # Port A can only access the first port of each subarray. Port B can
    # only access the second port of each subarray. Since each subarray
    # is dual-ported, port A and B _can_ both access the same subarray.
    #
    # This behavior might be undefined though, depending on the inner
    # SRAM block implementation.

    @s.combinational
    def divide_subarray():
      for i in xrange( num_subarrays ):
        # Port A
        s.subarray_a_addr.value       = s.memreqa_msg_addr[2:subarray_addr_width_plus2] # word address
        s.subarray_a_en_bar[i].value  = 1
        s.subarray_a_wen_bar[i].value = 0b1111
        if s.sram_a_addr_M0[ subarray_addr_width : addr_width ] == i:
          s.subarray_a_en_bar[i].value  = s.sram_a_en_bar_M0
          s.subarray_a_wen_bar[i].value = s.sram_a_wen_bar_M0
        # Port B
        s.subarray_b_addr.value       = s.memreqb_msg_addr[2:subarray_addr_width_plus2] # word address
        s.subarray_b_en_bar[i].value  = 1
        s.subarray_b_wen_bar[i].value = 0b1111
        if s.sram_b_addr_M0[ subarray_addr_width : addr_width ] == i:
          s.subarray_b_en_bar[i].value  = s.sram_b_en_bar_M0
          s.subarray_b_wen_bar[i].value = s.sram_b_wen_bar_M0

    # SRAM

    s.srams = [ SRAM( num_bits, num_words / num_subarrays ) for _ in xrange(num_subarrays) ]

    for i in xrange(num_subarrays):
      s.connect_pairs(
        s.clk,                    s.srams[i].CLKA,
        s.clk,                    s.srams[i].CLKB,
        s.subarray_a_addr,        s.srams[i].AA,
        s.subarray_a_wen_bar[i],  s.srams[i].WENA,
        s.subarray_a_en_bar[i],   s.srams[i].CENA,
        s.sram_a_wdata_M0,        s.srams[i].DA,
        s.sram_a_rdata_sub_M1[i], s.srams[i].QA,

        s.subarray_b_addr,        s.srams[i].AB,
        s.subarray_b_wen_bar[i],  s.srams[i].WENB,
        s.subarray_b_en_bar[i],   s.srams[i].CENB,
        s.sram_b_wdata_M0,        s.srams[i].DB,
        s.sram_b_rdata_sub_M1[i], s.srams[i].QB
      )

    # Pipeline registers

    s.memreqa_val_reg = m = RegRst( 1 )
    s.connect( s.memreqa_go_M0, m.in_ )

    s.memreqa_msg_reg = m = RegRst( MemReqMsg( 8, 32, num_bits ) )
    s.connect( s.memreqa.msg, m.in_ )

    s.memreqb_val_reg = m = RegRst( 1 )
    s.connect( s.memreqb_go_M0, m.in_ )

    s.memreqb_msg_reg = m = RegRst( MemReqMsg( 8, 32, num_bits ) )
    s.connect( s.memreqb.msg, m.in_ )

    #---------------------------------------------------------------------
    # M1 stage
    #---------------------------------------------------------------------

    s.memreqa_msg_addr_M1 = Wire( 32 )
    s.memreqb_msg_addr_M1 = Wire( 32 )

    @s.combinational
    def addr_M1():
      s.memreqa_msg_addr_M1.value = s.memreqa_msg_reg.out.addr
      s.memreqb_msg_addr_M1.value = s.memreqb_msg_reg.out.addr

    s.sram_a_rdata_M1 = Wire( num_bits )
    s.sram_b_rdata_M1 = Wire( num_bits )

    # select read data from one of the subarrays
    # use uppper bit to select sub-arrays

    s.rdata_sel_a = Wire( addr_width - subarray_addr_width )
    s.rdata_sel_b = Wire( addr_width - subarray_addr_width )

    @s.combinational
    def subarray_combine():
      s.rdata_sel_a.value = s.memreqa_msg_addr_M1[ subarray_addr_width_plus2 : addr_width_plus2 ]
      s.rdata_sel_b.value = s.memreqb_msg_addr_M1[ subarray_addr_width_plus2 : addr_width_plus2 ]

    s.rdata_a_mux = Mux( num_bits, num_subarrays )
    s.rdata_b_mux = Mux( num_bits, num_subarrays )

    for i in xrange( num_subarrays ):
      s.connect( s.rdata_a_mux.in_[i], s.sram_a_rdata_sub_M1[i] )
      s.connect( s.rdata_b_mux.in_[i], s.sram_b_rdata_sub_M1[i] )

    s.connect_pairs(
      s.rdata_a_mux.out, s.sram_a_rdata_M1,
      s.rdata_a_mux.sel, s.rdata_sel_a
    )

    s.connect_pairs(
      s.rdata_b_mux.out, s.sram_b_rdata_M1,
      s.rdata_b_mux.sel, s.rdata_sel_b
    )

    s.memrespa_msg_data_M1 = Wire( num_bits )
    s.memrespb_msg_data_M1 = Wire( num_bits )

    @s.combinational
    def comb_M1():
      # zero out data if request is a write
      if s.memreqa_msg_reg.out.type_ == 0:
        s.memrespa_msg_data_M1.value = s.sram_a_rdata_M1
      else:
        s.memrespa_msg_data_M1.value = 0
      if s.memreqb_msg_reg.out.type_ == 0:
        s.memrespb_msg_data_M1.value = s.sram_b_rdata_M1
      else:
        s.memrespb_msg_data_M1.value = 0

    # Bypass queues

    s.memrespa_queue_rdy = Wire( 1 )
    s.memrespb_queue_rdy = Wire( 1 )

    s.memrespa_queue = m = TwoElementBypassQueue( MemRespMsg( 8, num_bits ) )

    s.connect_pairs(
      m.enq.val,        s.memreqa_val_reg.out,
      m.enq.rdy,        s.memrespa_queue_rdy,
      m.enq.msg.type_,  s.memreqa_msg_reg.out.type_,
      m.enq.msg.opaque, s.memreqa_msg_reg.out.opaque,
      m.enq.msg.len,    s.memreqa_msg_reg.out.len,
      m.enq.msg.test,   0,                             # always set "test" field to be 0
      m.enq.msg.data,   s.memrespa_msg_data_M1,

      m.deq.val,        s.memrespa.val,
      m.deq.rdy,        s.memrespa.rdy,
      m.deq.msg,        s.memrespa.msg,
    )

    s.memrespb_queue = m = TwoElementBypassQueue( MemRespMsg( 8, num_bits ) )

    s.connect_pairs(
      m.enq.val,        s.memreqb_val_reg.out,
      m.enq.rdy,        s.memrespb_queue_rdy,
      m.enq.msg.type_,  s.memreqb_msg_reg.out.type_,
      m.enq.msg.opaque, s.memreqb_msg_reg.out.opaque,
      m.enq.msg.len,    s.memreqb_msg_reg.out.len,
      m.enq.msg.test,   0,                             # always set "test" field to be 0
      m.enq.msg.data,   s.memrespb_msg_data_M1,

      m.deq.val,        s.memrespb.val,
      m.deq.rdy,        s.memrespb.rdy,
      m.deq.msg,        s.memrespb.msg,
    )

    # Input ready signal: input (memreq) is ready if the bypass queue is empty

    s.connect( s.memreqa.rdy, s.memrespa_queue.empty )
    s.connect( s.memreqb.rdy, s.memrespb_queue.empty )

  def line_trace( s ):
    return ' ____ '.join( [ s.srams[i].line_trace() for i in xrange( len(s.srams) ) ] )
