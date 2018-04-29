#========================================================================
# SRAM Val/Rdy Wrapper
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
from pclib.rtl         import RegRst
from pclib.rtl         import SingleElementBypassQueue, TwoElementBypassQueue
from sram              import SramRTL

class SramValRdyPRTL( Model ):

  def __init__( s, tech_node = 'generic', prefix = 'sram' ):

    # Explicit module name

    s.explicit_modulename = "SramValRdyPRTL"

    # size is fixed as 64x64

    num_bits  = 64
    num_words = 64

    # Interface

    # Default memory message has 8 bits opaque field and 32 bits address.

    s.memreq  = InValRdyBundle ( MemReqMsg ( 8, 32, num_bits ) )
    s.memresp = OutValRdyBundle( MemRespMsg( 8,     num_bits ) )

    addr_width = clog2( num_words )  # address width
    addr_start = clog2(num_bits/8)
    addr_end   = addr_start+addr_width+1

    #---------------------------------------------------------------------
    # MO stage
    #---------------------------------------------------------------------

    s.memreq_go_M0     = Wire( 1 )

    s.sram_a_addr_32_M0 = Wire( 32 )
    s.sram_a_addr_M0    = Wire( addr_width )
    s.sram_a_wen_M0     = Wire( 1 )
    s.sram_a_en_M0      = Wire( 1 )
    s.sram_a_wdata_M0   = Wire( num_bits )
    s.sram_a_rdata_M1   = Wire( num_bits ) # read data, output of sram, M1 stage

    @s.combinational
    def comb_M0():
      s.memreq_go_M0.value      = s.memreq.val & s.memreq.rdy
      s.sram_a_addr_32_M0.value = s.memreq.msg.addr # make it translatable
      s.sram_a_addr_M0.value    = s.sram_a_addr_32_M0[addr_start:addr_end]
      s.sram_a_wen_M0.value     = s.memreq.val & ( s.memreq.msg.type_ == 1 )
      s.sram_a_en_M0.value      = s.memreq_go_M0
      s.sram_a_wdata_M0.value   = s.memreq.msg.data

    # SRAM

    module_name = '{}_{}_{}x{}_SP'.format( prefix, tech_node, num_bits, num_words )

    s.sram = m = SramRTL( num_bits, num_words, tech_node, module_name )

    s.connect_pairs(
      m.addr,  s.sram_a_addr_M0,
      m.we,    s.sram_a_wen_M0,
      m.wmask, 0b11111111,
      m.ce,    s.sram_a_en_M0,
      m.in_,   s.sram_a_wdata_M0,
      m.out,   s.sram_a_rdata_M1,
    )

    # Pipeline registers

    s.memreq_val_reg = m = RegRst( 1 )
    s.connect( s.memreq_go_M0, m.in_ )

    s.memreq_msg_reg_out_addr = Wire( 32 )

    s.memreq_msg_reg = m = RegRst( MemReqMsg( 8, 32, num_bits ) )
    s.connect( s.memreq.msg, m.in_ )

    #---------------------------------------------------------------------
    # M1 stage
    #---------------------------------------------------------------------

    s.memresp_msg_data_M1 = Wire( num_bits )

    @s.combinational
    def comb_M1():
      # zero out data if request is a write
      if s.memreq_msg_reg.out.type_ == 0:
        s.memresp_msg_data_M1.value = s.sram_a_rdata_M1
      else:
        s.memresp_msg_data_M1.value = 0

    # Bypass queues

    s.memresp_queue_rdy = Wire( 1 )

    s.memresp_queue = m = TwoElementBypassQueue( MemRespMsg( 8, num_bits ) )

    s.connect_pairs(
      m.enq.val,        s.memreq_val_reg.out,
      m.enq.rdy,        s.memresp_queue_rdy,
      m.enq.msg.type_,  s.memreq_msg_reg.out.type_,
      m.enq.msg.opaque, s.memreq_msg_reg.out.opaque,
      m.enq.msg.len,    s.memreq_msg_reg.out.len,
      m.enq.msg.test,   0,                             # always set "test" field to be 0
      m.enq.msg.data,   s.memresp_msg_data_M1,

      m.deq.val,        s.memresp.val,
      m.deq.rdy,        s.memresp.rdy,
      m.deq.msg,        s.memresp.msg,
    )

    # Input ready signal: input (memreq) is ready if the bypass queue is empty

    s.connect( s.memreq.rdy, s.memresp_queue.empty )

  def line_trace( s ):
    return s.sram.line_trace()
