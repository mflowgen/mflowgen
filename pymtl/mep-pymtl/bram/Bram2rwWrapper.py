#========================================================================
# BRAM 2rw Wrapper
#========================================================================
# This is a simple val/rdy wrapper around a 2rw BRAM that is supposed to
# be inferred by the Xilinx tools.
#
# We add a skid buffer in order to support val/rdy protocol. A correct
# solution will have two or more elements of buffering in the memory
# response queue _and_ stall M0 if there are less than two free elements
# in the queue. Thus in the worst case, if M2 stalls we have room for two
# messages in the response queue: the message currently in M1 and the
# message currently in M0. Here is the updated design:
#
#         .------.          .------.
#         |      |          | 2elm |
#   M0 -> | bram | -> M1 -> | bypq | -> M2
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
from pclib.rtl         import RegRst
from pclib.rtl         import SingleElementBypassQueue, TwoElementBypassQueue

#-------------------------------------------------------------------------
# BRAM
#-------------------------------------------------------------------------

# The Verilog BRAM in sim/verilog/bram-Bram2rw.v has this interface:
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
# Here I am matching it in PyMTL.

class Bram2rw( Model ):

  vmark_as_bram    = True                                 # suppress wire/array declarations
  vannotate_arrays = { 'ram': '(* RAM_STYLE="BLOCK" *)' } # annotate 'ram' to infer BRAM

  def __init__( s, num_bits = 32, num_words = 128 ):

    addr_width = clog2( num_words )  # address width

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
    return "(addr1={} data1_in={} data1_out={}) (addr2={} data2_in={} data2_out={})".format( s.addr1, s.data1_in, s.data1_out, s.addr2, s.data2_in, s.data2_out )


#-------------------------------------------------------------------------
# BRAM wrapper with val/rdy interfaces
#-------------------------------------------------------------------------

class Bram2rwWrapper( Model ):

  def __init__( s, num_bits = 32, num_words = 128 ):

    # Interface

    # Default memory message has 8 bits opaque field and 32 bits address.

    s.memreqa  = InValRdyBundle ( MemReqMsg ( 8, 32, num_bits ) )
    s.memrespa = OutValRdyBundle( MemRespMsg( 8,     num_bits ) )

    s.memreqb  = InValRdyBundle ( MemReqMsg ( 8, 32, num_bits ) )
    s.memrespb = OutValRdyBundle( MemRespMsg( 8,     num_bits ) )

    s.msga = MemReqMsg ( 8, 32, num_bits )
    s.msgb = MemReqMsg ( 8, 32, num_bits )

    addr_width = clog2( num_words )  # address width

    #---------------------------------------------------------------------
    # MO stage
    #---------------------------------------------------------------------

    s.memreqa_go_M0     = Wire( 1 )
    s.memreqb_go_M0     = Wire( 1 )

    s.bram_en_M0        = Wire( 1 )

    s.bram_a_addr_M0    = Wire( addr_width )
    s.bram_a_type_M0    = Wire( 3 )
    s.bram_a_wdata_M0   = Wire( num_bits )
    s.bram_a_rdata_M1   = Wire( num_bits ) # read data, output of bram, M1 stage

    s.bram_b_addr_M0    = Wire( addr_width )
    s.bram_b_type_M0    = Wire( 3 )
    s.bram_b_wdata_M0   = Wire( num_bits )
    s.bram_b_rdata_M1   = Wire( num_bits )

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
      s.bram_a_addr_M0.value    = s.memreqa_msg_addr[2:addr_width_plus2]
      s.bram_a_type_M0.value    = s.memreqa.msg.type_
      s.bram_a_wdata_M0.value   = s.memreqa.msg.data

      # Port B
      s.memreqb_go_M0.value     = s.memreqb.val & s.memreqb.rdy
      s.bram_b_addr_M0.value    = s.memreqb_msg_addr[2:addr_width_plus2]
      s.bram_b_type_M0.value    = s.memreqb.msg.type_
      s.bram_b_wdata_M0.value   = s.memreqb.msg.data

      s.bram_en_M0.value        = s.memreqa_go_M0 | s.memreqb_go_M0

    # BRAM

    s.bram = m = Bram2rw( num_bits, num_words )

    s.connect_pairs(
      s.bram_en_M0,        m.en,

      s.bram_a_addr_M0,    m.addr1,
      s.bram_a_type_M0,    m.type1,
      s.bram_a_wdata_M0,   m.data1_in,
      s.bram_a_rdata_M1,   m.data1_out,

      s.bram_b_addr_M0,    m.addr2,
      s.bram_b_type_M0,    m.type2,
      s.bram_b_wdata_M0,   m.data2_in,
      s.bram_b_rdata_M1,   m.data2_out
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

    s.memrespa_msg_data_M1 = Wire( num_bits )
    s.memrespb_msg_data_M1 = Wire( num_bits )

    @s.combinational
    def comb_M1():
      # zero out data if request is a write
      if s.memreqa_msg_reg.out.type_ == 0:
        s.memrespa_msg_data_M1.value = s.bram_a_rdata_M1
      else:
        s.memrespa_msg_data_M1.value = 0
      if s.memreqb_msg_reg.out.type_ == 0:
        s.memrespb_msg_data_M1.value = s.bram_b_rdata_M1
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
    return s.bram.line_trace()

