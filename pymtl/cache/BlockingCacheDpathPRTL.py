#=========================================================================
# BlockingCacheDpathPRTL.py
#=========================================================================

from pymtl      import *

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg
from ifcs import MemReqMsg4B, MemRespMsg4B
from ifcs import MemReqMsg16B, MemRespMsg16B

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# LAB TASK: Include necessary files
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

from pclib.rtl            import Mux, RegEnRst
from pclib.rtl.arith      import EqComparator
from sram.SramRTL         import SramRTL
from SliceNDicePRTL       import SliceNDicePRTL
from GenWriteDataPRTL     import GenWriteDataPRTL

size           = 8192               # Cache size in bytes
p_opaque_nbits = 8

# local parameters not meant to be set from outside

dbw            = 32                 # Short name for data bitwidth
abw            = 32                 # Short name for addr bitwidth
byte_off       = clog2(dbw)         # Byte Offset
clw            = 128                # Short name for cacheline bitwidth
nblocks        = size*8/clw         # Number of blocks in the cache
idw            = clog2(nblocks)-1   # Short name for index width
idw_off        = idw+4
num_words      = clw / dbw          # Number of Words in a CL
num_bytes      = clw / 8            # Number of Bytes in a CL
word_off       = clog2( num_words ) # Word Offset
o              = p_opaque_nbits

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

class BlockingCacheDpathPRTL( Model ):

  def __init__( s, idx_shamt   = 0                ,
                   MemReqMsgType   = MemReqMsg16B , MemRespMsgType   = MemRespMsg16B ,
                   CacheReqMsgType = MemReqMsg16B , CacheRespMsgType = MemRespMsg16B ):

    #---------------------------------------------------------------------
    # Parameters
    #---------------------------------------------------------------------

    # Actually get all datatypes and length from types
    __cache_req  = CacheReqMsgType ()
    __cache_resp = CacheRespMsgType()

    c_type_bw    = __cache_req.type_ .nbits
    c_addr_bw    = __cache_req.addr  .nbits
    c_opaq_bw    = __cache_req.opaque.nbits
    c_data_bw    = __cache_req.data  .nbits
    c_data_Bw    = c_data_bw / 8
    c_len_bw     = __cache_req.len   .nbits

    __mem_req    = MemReqMsgType  ()
    __mem_resp   = MemRespMsgType ()

    m_type_bw    = __mem_req  .type_ .nbits
    m_addr_bw    = __mem_req  .addr  .nbits
    m_opaq_bw    = __mem_req  .opaque.nbits
    m_data_bw    = __mem_req  .data  .nbits
    m_data_Bw    = m_data_bw / 8
    m_len_bw     = __mem_req  .len   .nbits

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Cache request

    s.cachereq_msg       = InPort ( CacheReqMsgType  )

    # Cache response

    s.cacheresp_msg      = OutPort( CacheRespMsgType )

    # Memory request

    s.memreq_msg         = OutPort( MemReqMsgType     )

    # Memory response

    s.memresp_msg        = InPort ( MemRespMsgType    )

    # control signals (ctrl->dpath)

    s.amo_min_sel        = InPort( 1 )
    s.amo_minu_sel       = InPort( 1 )
    s.amo_max_sel        = InPort( 1 )
    s.amo_maxu_sel       = InPort( 1 )
    s.amo_sel            = InPort( 4 )
    s.is_amo             = InPort( 1 )
    s.cachereq_en        = InPort( 1 )
    s.memresp_en         = InPort( 1 )
    s.is_refill          = InPort( 1 )
    s.tag_array_0_wen    = InPort( 1 )
    s.tag_array_0_ren    = InPort( 1 )
    s.tag_array_1_wen    = InPort( 1 )
    s.tag_array_1_ren    = InPort( 1 )
    s.way_sel            = InPort( 1 )
    s.way_sel_current    = InPort( 1 )
    s.data_array_wen     = InPort( 1 )
    s.data_array_ren     = InPort( 1 )
    s.skip_read_data_reg = InPort( 1 )
    s.cachereq_en        = InPort( 1 )

    # width of cacheline divided by number of bits per byte

    s.data_array_wben    = InPort( clw/8 )
    s.read_data_reg_en   = InPort( 1 )
    s.read_tag_reg_en    = InPort( 1 )
    s.byte_offset        = InPort( clog2(clw/dbw) )
    s.memreq_type        = InPort( 4 )
    s.cacheresp_type     = InPort( 4 )
    s.cacheresp_hit      = InPort( 1 )

    # status signals (dpath->ctrl)

    s.cachereq_data_reg_out = OutPort( c_data_bw )
    s.cachereq_len_reg_out  = OutPort( c_len_bw  )
    s.cachereq_type         = OutPort( c_type_bw )
    s.cachereq_addr         = OutPort( c_addr_bw )
    s.tag_match_0           = OutPort(     1     )
    s.tag_match_1           = OutPort(     1     )

    # Special for AMOs
    s.read_data_word        = OutPort(    dbw    )
    s.cachereq_data_word    = OutPort(    dbw    )

    # Register the unpacked cachereq_msg

    s.cachereq_type_reg = m = RegEnRst( dtype = c_type_bw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.cachereq_en,
      m.in_, s.cachereq_msg.type_,
      m.out, s.cachereq_type
    )

    s.cachereq_addr_reg = m = RegEnRst( dtype = c_addr_bw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.cachereq_en,
      m.in_, s.cachereq_msg.addr,
      m.out, s.cachereq_addr
    )

    s.cachereq_opaque_reg = m = RegEnRst( dtype = c_opaq_bw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.cachereq_en,
      m.in_, s.cachereq_msg.opaque,
      m.out, s.cacheresp_msg.opaque,
    )

    s.cachereq_data_reg = m = RegEnRst( dtype = c_data_bw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.cachereq_en,
      m.in_, s.cachereq_msg.data,
      m.out, s.cachereq_data_reg_out,
    )

    s.cachereq_len_reg = m = RegEnRst( dtype = c_len_bw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.cachereq_en,
      m.in_, s.cachereq_msg.len,
      m.out, s.cachereq_len_reg_out,
    )

    # Register the unpacked data from memresp_msg

    s.memresp_data_reg = m = RegEnRst( dtype = clw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.memresp_en,
      m.in_, s.memresp_msg.data,
    )

    #---------------------------------------------------------------------
    # AMOs
    #---------------------------------------------------------------------

    # Slice data into words

    @s.combinational
    def gen_amo_data():
      s.cachereq_data_word.value = s.cachereq_data_reg_out[0:dbw]
      s.read_data_word    .value = s.read_data            [0:dbw]

    # Calculate AMO minimum

    s.amo_min_mux = m = Mux( dtype = dbw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.read_data_word,
      m.in_[1],  s.cachereq_data_word,
      m.sel,     s.amo_min_sel,
    )

    # Calculate AMO minimum unsigned

    s.amo_minu_mux = m = Mux( dtype = dbw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.read_data_word,
      m.in_[1],  s.cachereq_data_word,
      m.sel,     s.amo_minu_sel,
    )

    # Calculate AMO maximum

    s.amo_max_mux = m = Mux( dtype = dbw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.read_data_word,
      m.in_[1],  s.cachereq_data_word,
      m.sel,     s.amo_max_sel,
    )

    # Calculate AMO maximum unsigned

    s.amo_maxu_mux = m = Mux( dtype = dbw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.read_data_word,
      m.in_[1],  s.cachereq_data_word,
      m.sel,     s.amo_maxu_sel,
    )

    # Generate cachereq write data which will be the data field or some
    # calculation with the read data for amos

    s.cachereq_data_reg_out_add   = Wire( dbw )
    s.cachereq_data_reg_out_and   = Wire( dbw )
    s.cachereq_data_reg_out_or    = Wire( dbw )
    s.cachereq_data_reg_out_swap  = Wire( dbw )
    s.cachereq_data_reg_out_min   = Wire( dbw )
    s.cachereq_data_reg_out_minu  = Wire( dbw )
    s.cachereq_data_reg_out_max   = Wire( dbw )
    s.cachereq_data_reg_out_maxu  = Wire( dbw )
    s.cachereq_data_reg_out_xor   = Wire( dbw )

    s.amo_sel_mux = m = Mux( dtype = dbw, nports = 9 )

    @s.combinational
    def comb_connect_wires():
      s.cachereq_data_reg_out_add.value   = s.cachereq_data_word + s.read_data_word
      s.cachereq_data_reg_out_and.value   = s.cachereq_data_word & s.read_data_word
      s.cachereq_data_reg_out_or.value    = s.cachereq_data_word | s.read_data_word
      s.cachereq_data_reg_out_swap.value  = s.cachereq_data_word
      s.cachereq_data_reg_out_min.value   = s.amo_min_mux.out
      s.cachereq_data_reg_out_minu.value  = s.amo_minu_mux.out
      s.cachereq_data_reg_out_max.value   = s.amo_max_mux.out
      s.cachereq_data_reg_out_maxu.value  = s.amo_maxu_mux.out
      s.cachereq_data_reg_out_xor.value   = s.cachereq_data_word ^ s.read_data_word

    s.connect_pairs(
      m.in_[0],  s.cachereq_data_reg_out_add,
      m.in_[1],  s.cachereq_data_reg_out_and,
      m.in_[2],  s.cachereq_data_reg_out_or,
      m.in_[3],  s.cachereq_data_reg_out_swap,
      m.in_[4],  s.cachereq_data_reg_out_min,
      m.in_[5],  s.cachereq_data_reg_out_minu,
      m.in_[6],  s.cachereq_data_reg_out_max,
      m.in_[7],  s.cachereq_data_reg_out_maxu,
      m.in_[8],  s.cachereq_data_reg_out_xor,
      m.sel,     s.amo_sel,
    )

    # In-case the AMO is smaller than a typical cache response

    s.amo_out = Wire ( c_data_bw )

    @s.combinational
    def comb_gen_amo_output():
      s.amo_out       .value = 0
      s.amo_out[0:dbw].value = s.amo_sel_mux.out

    # Get offset

    s.cachereq_offset  = Wire ( m_len_bw )

    @s.combinational
    def comb_cachereq_offset():
      s.cachereq_offset.value = s.cachereq_addr[0:m_len_bw]

    # AMO select or cacheresponse select

    s.cachresp_mux = m = Mux( dtype = c_data_bw, nports = 2 )

    s.connect_pairs(
      m.in_[0], s.cachereq_data_reg_out,
      m.in_[1], s.amo_out,
      m.sel,    s.is_amo,
    )

    # hawajkm: I would like to have a repeat unit that would produce a line
    #          with the wanted data repeated in every 

    s.gen_write_data = m = GenWriteDataPRTL( c_data_Bw, m_data_Bw )

    s.connect_pairs(
      m.in_,    s.cachresp_mux.out,
      m.offset, s.cachereq_offset,
    )

    # Refill mux

    s.refill_mux = m = Mux( dtype = clw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.gen_write_data.out,
      m.in_[1],  s.memresp_msg.data,
      m.sel,     s.is_refill,
    )

    s.cachereq_tag = Wire( abw - 4 )
    s.cachereq_idx = Wire( idw )

    @s.combinational
    def comb_replicate():
      s.cachereq_tag.value = s.cachereq_addr_reg.out[4:abw]
      s.cachereq_idx.value = s.cachereq_addr_reg.out[4:idw_off]

    # Concat

    s.temp_cachereq_tag = Wire( abw )
    s.cachereq_msg_addr = Wire( abw )
    s.cur_cachereq_idx  = Wire( idw )

    s.data_array_0_wen  = Wire(  1  )
    s.data_array_1_wen  = Wire(  1  )
    s.sram_tag_0_en     = Wire(  1  )
    s.sram_tag_1_en     = Wire(  1  )
    s.sram_data_0_en    = Wire(  1  )
    s.sram_data_1_en    = Wire(  1  )

    @s.combinational
    def comb_tag():
      s.cachereq_msg_addr.value = s.cachereq_msg.addr
      s.temp_cachereq_tag.value = concat( Bits(4, 0), s.cachereq_tag )
      if s.cachereq_en:
        s.cur_cachereq_idx.value = s.cachereq_msg_addr[4:idw_off]
      else:
        s.cur_cachereq_idx.value  = s.cachereq_idx

      # Shunning: This data_array_x_wen is built up in the same way as
      #           tag_array_x_wen. Why is this guy here, but the tag one is in ctrl?
      s.data_array_0_wen.value =  (s.data_array_wen & (s.way_sel_current == 0))
      s.data_array_1_wen.value =  (s.data_array_wen & (s.way_sel_current == 1))
      s.sram_tag_0_en.value    =  (s.tag_array_0_wen | s.tag_array_0_ren)
      s.sram_tag_1_en.value    =  (s.tag_array_1_wen | s.tag_array_1_ren)
      s.sram_data_0_en.value   =  ((s.data_array_wen & (s.way_sel_current==0)) | s.data_array_ren)
      s.sram_data_1_en.value   =  ((s.data_array_wen & (s.way_sel_current==1)) | s.data_array_ren)

    # Tag array 0

    s.tag_array_0_read_out = Wire( abw )

    s.tag_array_0 = m = SramRTL(num_bits    =  32                  ,
                                num_words   = 256                  ,
                                tech_node   = '28nm'               ,
                                module_name = 'sram_28nm_32x256_SP')

    s.connect_pairs(
      m.addr,  s.cur_cachereq_idx,
      m.out,   s.tag_array_0_read_out,
      m.we,    s.tag_array_0_wen,
      m.wmask, 0b1111,
      m.in_,   s.temp_cachereq_tag,
      m.ce,    s.sram_tag_0_en
    )

    # Tag array 1

    s.tag_array_1_read_out = Wire( abw )

    s.tag_array_1 = m = SramRTL(num_bits    =  32                  ,
                                num_words   = 256                  ,
                                tech_node   = '28nm'               ,
                                module_name = 'sram_28nm_32x256_SP')
    s.connect_pairs(
      m.addr,  s.cur_cachereq_idx,
      m.out,   s.tag_array_1_read_out,
      m.we,    s.tag_array_1_wen,
      m.wmask, 0b1111,
      m.in_,   s.temp_cachereq_tag,
      m.ce,    s.sram_tag_1_en
    )

    # Data array 0

    s.data_array_0_read_out = Wire( clw )

    s.data_array_0 = m = SramRTL(num_bits    = 128                   ,
                                 num_words   = 256                   ,
                                 tech_node   = '28nm'                ,
                                 module_name = 'sram_28nm_128x256_SP')

    s.connect_pairs(
      m.addr,  s.cur_cachereq_idx,
      m.out,   s.data_array_0_read_out,
      m.we,    s.data_array_0_wen,
      m.wmask, s.data_array_wben,
      m.in_,   s.refill_mux.out,
      m.ce,    s.sram_data_0_en
    )

    # Data array 1

    s.data_array_1_read_out = Wire( clw )

    s.data_array_1 = m = SramRTL(num_bits    = 128                   ,
                                 num_words   = 256                   ,
                                 tech_node   = '28nm'                ,
                                 module_name = 'sram_28nm_128x256_SP')

    s.connect_pairs(
      m.addr,  s.cur_cachereq_idx,
      m.out,   s.data_array_1_read_out,
      m.we,    s.data_array_1_wen,
      m.wmask, s.data_array_wben,
      m.in_,   s.refill_mux.out,
      m.ce,    s.sram_data_1_en
    )

    # Data read mux

    s.data_read_mux = m = Mux( dtype = clw, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.data_array_0_read_out,
      m.in_[1],  s.data_array_1_read_out,
      m.sel,     s.way_sel_current
    )

    # Eq comparator to check for tag matching (tag_compare_0)

    s.tag_compare_0 = m = EqComparator( nbits = abw - 4 )

    s.connect_pairs(
      m.in0, s.cachereq_tag,
      m.in1, s.tag_array_0_read_out[0:28],
      m.out, s.tag_match_0
    )

    # Eq comparator to check for tag matching (tag_compare_1)

    s.tag_compare_1 = m = EqComparator( nbits = abw - 4 )

    s.connect_pairs(
      m.in0, s.cachereq_tag,
      m.in1, s.tag_array_1_read_out[0:28],
      m.out, s.tag_match_1
    )

    # Mux that selects between the ways for requesting from memory

    s.way_sel_mux = m = Mux( dtype = abw - 4, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.tag_array_0_read_out[0:abw-4],
      m.in_[1],  s.tag_array_1_read_out[0:abw-4],
      m.sel,     s.way_sel_current
    )

    # Read data register

    s.read_data_reg = m = RegEnRst( dtype = clw, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.read_data_reg_en,
      m.in_, s.data_read_mux.out,
      m.out, s.memreq_msg.data
    )

    # Read tag register

    s.read_tag_reg = m = RegEnRst( dtype = abw - 4, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.read_tag_reg_en,
      m.in_, s.way_sel_mux.out,
    )

    # Memreq Type Mux

    s.memreq_type_mux_out = Wire( abw - 4 )

    s.tag_mux = m = Mux( dtype = abw - 4, nports = 2 )

    s.connect_pairs(
      m.in_[0],  s.cachereq_tag,
      m.in_[1],  s.read_tag_reg.out,
      m.sel,     s.memreq_type[0],
      m.out,     s.memreq_type_mux_out
    )

    # Pack address for memory request

    s.memreq_addr = Wire( abw )

    @s.combinational
    def comb_addr_evict():
      s.memreq_addr.value = concat(s.memreq_type_mux_out, Bits(4, 0))

    # Skip read data reg mux

    s.int_read_data = Wire( clw )

    s.skip_read_data_mux = m = Mux( dtype = clw, nports = 2 )

    s.connect_pairs(
      m.in_[0],   s.read_data_reg.out,
      m.in_[1],   s.data_read_mux.out,
      m.sel,      s.skip_read_data_reg,
      m.out,      s.int_read_data,
    )

    # Slice and Dice the output data

    s.read_data = Wire( c_data_bw )

    s.slice_n_dice = m = SliceNDicePRTL( m_data_Bw, c_data_Bw )

    s.connect_pairs(
      m.in_   , s.int_read_data  ,
      m.offset, s.cachereq_offset,
      m.len   , s.cachereq_len_reg_out,
      m.out   , s.read_data      ,
    )

    # For AMOs, we one slice a dbw-sized word; for now, this would support RV32 only
    # as RV64 requires a 32-bit support also

    # Output will be a wire that take a c_data_bw-sized slice from the cacheline
    # If the cache was configured to be a wide access, this will cause the output
    # to get all of the cacheline. The assumption is that output is at most cacheline
    # sized

    s.cacheresp_data_out = Wire( dbw )

    @s.combinational
    def comb_addr_refill():

      if   s.cacheresp_type == MemReqMsg.TYPE_READ      : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_ADD   : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_AND   : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_OR    : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_SWAP  : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MIN   : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MINU  : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAX   : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAXU  : s.cacheresp_msg.data.value = s.read_data
      elif s.cacheresp_type == MemReqMsg.TYPE_AMO_XOR   : s.cacheresp_msg.data.value = s.read_data
      else                                              : s.cacheresp_msg.data.value = 0

    # Taking slices of the cache request address
    #     byte offset: 2 bits wide
    #     word offset: 2 bits wide
    #     index: $clog2(nblocks) bits wide - 1 bits wide
    #     nbits: width of tag = width of addr - $clog2(nblocks) - 4
    #     entries: 256*8/128 = 16

    @s.combinational
    def comb_cacherespmsgpack():
      s.cacheresp_msg.type_.value = s.cacheresp_type
      s.cacheresp_msg.test.value  = concat( Bits( 1, 0 ), s.cacheresp_hit )
      s.cacheresp_msg.len.value   = s.cachereq_len_reg_out

    @s.combinational
    def comb_memrespmsgpack():
      s.memreq_msg.type_.value    = s.memreq_type
      s.memreq_msg.opaque.value   = 0
      s.memreq_msg.addr.value     = s.memreq_addr
      s.memreq_msg.len.value      = 0
