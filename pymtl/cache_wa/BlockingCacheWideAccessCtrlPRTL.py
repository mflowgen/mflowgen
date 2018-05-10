#=========================================================================
# BlockingCacheWideAccessCtrlPRTL.py
#=========================================================================

from pymtl      import *

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg
from ifcs import MemReqMsg4B, MemRespMsg4B
from ifcs import MemReqMsg16B, MemRespMsg16B

from pclib.rtl     import RegisterFile, RegEnRst
from DecodeWbenRTL import DecodeWbenRTL

size           = 8192             # Cache size in bytes
p_opaque_nbits = 8

# local parameters not meant to be set from outside

dbw            = 32              # Short name for data bitwidth
abw            = 32              # Short name for addr bitwidth
clw            = 128             # Short name for cacheline bitwidth
nblocks        = size*8/clw      # Number of blocks in the cache
o              = p_opaque_nbits
idw            = clog2(nblocks)-1  # Short name for index width
num_bytes      = clw / 8
num_bytes_bw   = clog2(num_bytes)
idw_off        = idw+4

class BlockingCacheWideAccessCtrlPRTL( Model ):
  def __init__( s, idx_shamt = 0, CacheReqType  = MemReqMsg4B  ,
                                  CacheRespType = MemRespMsg4B ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Cache request

    s.cachereq_val       = InPort ( 1 )
    s.cachereq_rdy       = OutPort( 1 )

    # Cache response

    s.cacheresp_val      = OutPort( 1 )
    s.cacheresp_rdy      = InPort ( 1 )

    # Memory request

    s.memreq_val         = OutPort( 1 )
    s.memreq_rdy         = InPort ( 1 )

    # Memory response

    s.memresp_val        = InPort ( 1 )
    s.memresp_rdy        = OutPort( 1 )

    # control signals (ctrl->dpath)

    s.cachereq_en        = OutPort( 1 )
    s.memresp_en         = OutPort( 1 )
    s.is_refill          = OutPort( 1 )
    s.tag_array_0_wen    = OutPort( 1 )
    s.tag_array_0_ren    = OutPort( 1 )
    s.tag_array_1_wen    = OutPort( 1 )
    s.tag_array_1_ren    = OutPort( 1 )
    s.way_sel            = OutPort( 1 )
    s.way_sel_current    = OutPort( 1 )
    s.data_array_wen     = OutPort( 1 )
    s.data_array_ren     = OutPort( 1 )
    s.skip_read_data_reg = OutPort( 1 )

    # width of cacheline divided by number of bits per byte

    s.data_array_wben    = OutPort( clw/8 )
    s.read_data_reg_en   = OutPort( 1 )
    s.read_tag_reg_en    = OutPort( 1 )
    s.read_byte_sel      = OutPort( clog2(clw/8) )
    s.memreq_type        = OutPort( 4 )
    s.cacheresp_type     = OutPort( 4 )
    s.cacheresp_hit      = OutPort( 1 )

    # status signals (dpath->ctrl)

    # Actually get all datatypes and length from types
    tmp   = CacheReqType()

    # status signals (dpath->ctrl)

    type_bw = tmp.type_.nbits
    addr_bw = tmp.addr.nbits
    opaq_bw = tmp.opaque.nbits
    data_bw = tmp.data.nbits
    len_bw = tmp.len.nbits

    s.cachereq_data_reg_out = InPort ( data_bw )
    s.cachereq_len_reg_out  = InPort ( len_bw  )
    s.read_word_sel_mux_out = InPort ( dbw     )
    s.cachereq_type         = InPort ( type_bw )
    s.cachereq_addr         = InPort ( addr_bw )
    s.tag_match_0           = InPort ( 1 )
    s.tag_match_1           = InPort ( 1 )

    #----------------------------------------------------------------------
    # State Definitions
    #----------------------------------------------------------------------

    s.STATE_IDLE                       = Bits( 5, 0 )
    s.STATE_TAG_CHECK                  = Bits( 5, 1 )
    s.STATE_WRITE_CACHE_RESP_HIT       = Bits( 5, 2 )
    s.STATE_WRITE_DATA_ACCESS_HIT      = Bits( 5, 3 )
    s.STATE_READ_DATA_ACCESS_MISS      = Bits( 5, 4 )
    s.STATE_WRITE_DATA_ACCESS_MISS     = Bits( 5, 5 )
    s.STATE_WAIT_HIT                   = Bits( 5, 6 )
    s.STATE_WAIT_MISS                  = Bits( 5, 7 )
    s.STATE_REFILL_REQUEST             = Bits( 5, 8 )
    s.STATE_REFILL_WAIT                = Bits( 5, 9 )
    s.STATE_REFILL_UPDATE              = Bits( 5, 10 )
    s.STATE_EVICT_PREPARE              = Bits( 5, 11 )
    s.STATE_EVICT_REQUEST              = Bits( 5, 12 )
    s.STATE_EVICT_WAIT                 = Bits( 5, 13 )
    s.STATE_INIT_DATA_ACCESS           = Bits( 5, 18 )

    #----------------------------------------------------------------------
    # State
    #----------------------------------------------------------------------

    @s.posedge_clk
    def reg_state():
      if s.reset:
        s.state_reg.next = s.STATE_IDLE
      else:
        s.state_reg.next = s.state_next

    #----------------------------------------------------------------------
    # State Transitions
    #----------------------------------------------------------------------

    s.in_go     = Wire( 1 )
    s.out_go    = Wire( 1 )
    s.hit_0     = Wire( 1 )
    s.hit_1     = Wire( 1 )
    s.hit       = Wire( 1 )
    s.is_read   = Wire( 1 )
    s.is_write  = Wire( 1 )
    s.is_init   = Wire( 1 )
    s.read_hit  = Wire( 1 )
    s.write_hit = Wire( 1 )
    s.miss_0    = Wire( 1 )
    s.miss_1    = Wire( 1 )
    s.refill    = Wire( 1 )
    s.evict     = Wire( 1 )

    @s.combinational
    def comb_state_transition():
      s.in_go.value     = s.cachereq_val  & s.cachereq_rdy
      s.out_go.value    = s.cacheresp_val & s.cacheresp_rdy
      s.hit_0.value     = s.is_valid_0 & s.tag_match_0
      s.hit_1.value     = s.is_valid_1 & s.tag_match_1
      s.hit.value       = s.hit_0 | s.hit_1
      s.is_read.value   = s.cachereq_type == MemReqMsg.TYPE_READ
      s.is_write.value  = s.cachereq_type == MemReqMsg.TYPE_WRITE
      s.is_init.value   = s.cachereq_type == MemReqMsg.TYPE_WRITE_INIT
      s.read_hit.value  = s.is_read & s.hit
      s.write_hit.value = s.is_write & s.hit
      s.miss_0.value    = ~s.hit_0
      s.miss_1.value    = ~s.hit_1
      s.refill.value    = (s.miss_0 & ~s.is_dirty_0 & ~s.lru_way) | \
                          (s.miss_1 & ~s.is_dirty_1 &  s.lru_way)
      s.evict.value     = (s.miss_0 &  s.is_dirty_0 & ~s.lru_way) | \
                          (s.miss_1 &  s.is_dirty_1 &  s.lru_way)

    s.state_reg  = Wire( 5 )
    s.state_next = Wire( 5 )

    @s.combinational
    def comb_next_state():
      s.state_next.value = s.state_reg
      if s.state_reg == s.STATE_IDLE:
        if ( s.in_go ) : s.state_next.value = s.STATE_TAG_CHECK

      elif s.state_reg == s.STATE_TAG_CHECK:
        if   ( s.is_init      )                                   : s.state_next.value = s.STATE_INIT_DATA_ACCESS
        elif ( s.read_hit  &  s.cacheresp_rdy &  s.cachereq_val ) : s.state_next.value = s.STATE_TAG_CHECK
        elif ( s.read_hit  &  s.cacheresp_rdy & ~s.cachereq_val ) : s.state_next.value = s.STATE_IDLE
        elif ( s.read_hit  & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WAIT_HIT
        elif ( s.write_hit &  s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT
        elif ( s.write_hit & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_CACHE_RESP_HIT
        elif ( s.refill       )                                   : s.state_next.value = s.STATE_REFILL_REQUEST
        elif ( s.evict        )                                   : s.state_next.value = s.STATE_EVICT_PREPARE

      elif s.state_reg == s.STATE_WRITE_CACHE_RESP_HIT:
        if (s.cacheresp_rdy):   s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT

      elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
        if (s.cachereq_val):    s.state_next.value = s.STATE_TAG_CHECK
        else:                   s.state_next.value = s.STATE_IDLE

      elif s.state_reg == s.STATE_READ_DATA_ACCESS_MISS:
        s.state_next.value =    s.STATE_WAIT_MISS

      elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_MISS:
        if (s.cacheresp_rdy):   s.state_next.value = s.STATE_IDLE
        else:                   s.state_next.value = s.STATE_WAIT_MISS

      elif s.state_reg == s.STATE_INIT_DATA_ACCESS:
        s.state_next.value = s.STATE_WAIT_MISS

      elif s.state_reg == s.STATE_REFILL_REQUEST:
        if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_REFILL_WAIT
        elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_REFILL_REQUEST

      elif s.state_reg == s.STATE_REFILL_WAIT:
        if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_UPDATE
        elif ( ~s.memresp_val ): s.state_next.value = s.STATE_REFILL_WAIT

      elif s.state_reg == s.STATE_REFILL_UPDATE:
        if   ( s.is_read      ): s.state_next.value = s.STATE_READ_DATA_ACCESS_MISS
        elif ( s.is_write     ): s.state_next.value = s.STATE_WRITE_DATA_ACCESS_MISS

      elif s.state_reg == s.STATE_EVICT_PREPARE:
        s.state_next.value = s.STATE_EVICT_REQUEST

      elif s.state_reg == s.STATE_EVICT_REQUEST:
        if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_EVICT_WAIT
        elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_EVICT_REQUEST

      elif s.state_reg == s.STATE_EVICT_WAIT:
        if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_REQUEST
        elif ( ~s.memresp_val ): s.state_next.value = s.STATE_EVICT_WAIT

      elif s.state_reg == s.STATE_WAIT_HIT:
        if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE

      elif s.state_reg == s.STATE_WAIT_MISS:
        if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE

      else:
        s.state_next.value = s.STATE_IDLE

    #----------------------------------------------------------------------
    # Valid/Dirty bits record
    #----------------------------------------------------------------------

    s.cachereq_idx          = Wire( idw )
    s.valid_bit_in          = Wire( 1 )
    s.valid_bits_write_en   = Wire( 1 )
    s.valid_bits_write_en_0 = Wire( 1 )
    s.valid_bits_write_en_1 = Wire( 1 )
    s.is_valid_0            = Wire( 1 )
    s.is_valid_1            = Wire( 1 )

    left_idx = 4+idx_shamt
    right_idx = idw_off+idx_shamt

    @s.combinational
    def comb_cachereq_idx():
      s.cachereq_idx.value          = s.cachereq_addr[left_idx:right_idx]
      s.valid_bits_write_en_0.value = s.valid_bits_write_en & ~s.way_sel_current
      s.valid_bits_write_en_1.value = s.valid_bits_write_en &  s.way_sel_current

    # hawajkm: RegisterFile is not resetable. Converting valid arrays to
    #          bit-vectors

    s.valid_bits_0_in  = Wire( nblocks / 2 )
    s.valid_bits_0_out = Wire( nblocks / 2 )

    s.valid_bits_0 = m = RegEnRst( dtype = (nblocks / 2), reset_value = 0 )

    s.connect_pairs(
      m.en , s.valid_bits_write_en_0,
      m.in_, s.valid_bits_0_in      ,
      m.out, s.valid_bits_0_out     ,
    )

    @s.combinational
    def gen_valid_0():
      # Generate valids for writes
      s.valid_bits_0_in                .value = s.valid_bits_0_out
      s.valid_bits_0_in[s.cachereq_idx].value = s.valid_bit_in

      # Read valids
      s.is_valid_0                     .value = s.valid_bits_0_out[s.cachereq_idx]


    # hawajkm: RegisterFile is not resetable. Converting valid arrays to
    #          bit-vectors

    s.valid_bits_1_in  = Wire( nblocks / 2 )
    s.valid_bits_1_out = Wire( nblocks / 2 )

    s.valid_bits_1 = m = RegEnRst( dtype = (nblocks / 2), reset_value = 0 )

    s.connect_pairs(
      m.en , s.valid_bits_write_en_1,
      m.in_, s.valid_bits_1_in      ,
      m.out, s.valid_bits_1_out     ,
    )

    @s.combinational
    def gen_valid_1():
      # Generate valids for writes
      s.valid_bits_1_in                .value = s.valid_bits_1_out
      s.valid_bits_1_in[s.cachereq_idx].value = s.valid_bit_in

      # Read valids
      s.is_valid_1                     .value = s.valid_bits_1_out[s.cachereq_idx]


    s.dirty_bit_in          = Wire( 1 )
    s.dirty_bits_write_en   = Wire( 1 )
    s.dirty_bits_write_en_0 = Wire( 1 )
    s.dirty_bits_write_en_1 = Wire( 1 )
    s.is_dirty_0            = Wire( 1 )
    s.is_dirty_1            = Wire( 1 )

    @s.combinational
    def comb_cachereq_idx():
      s.dirty_bits_write_en_0.value = s.dirty_bits_write_en & ~s.way_sel_current
      s.dirty_bits_write_en_1.value = s.dirty_bits_write_en &  s.way_sel_current

    s.dirty_bits_0 = m = RegisterFile( Bits(1), nblocks/2, 1, 1, False)
    s.connect_pairs(
      m.rd_addr[0],  s.cachereq_idx,
      m.rd_data[0],  s.is_dirty_0,
      m.wr_en,       s.dirty_bits_write_en_0,
      m.wr_addr,     s.cachereq_idx,
      m.wr_data,     s.dirty_bit_in
    )

    s.dirty_bits_1 = m = RegisterFile( Bits(1), nblocks/2, 1, 1, False)
    s.connect_pairs(
      m.rd_addr[0],  s.cachereq_idx,
      m.rd_data[0],  s.is_dirty_1,
      m.wr_en,       s.dirty_bits_write_en_1,
      m.wr_addr,     s.cachereq_idx,
      m.wr_data,     s.dirty_bit_in
    )

    s.lru_bit_in            = Wire( 1 )
    s.lru_bits_write_en     = Wire( 1 )
    s.lru_way               = Wire( 1 )

    s.lru_bits     = m = RegisterFile( Bits(1), nblocks/2, 1, 1, False)
    s.connect_pairs(
      m.rd_addr[0],  s.cachereq_idx,
      m.rd_data[0],  s.lru_way,
      m.wr_en,       s.lru_bits_write_en,
      m.wr_addr,     s.cachereq_idx,
      m.wr_data,     s.lru_bit_in
    )

    #----------------------------------------------------------------------
    # Way selection.
    #   The way is determined in the tag check state, and is
    #   then recorded for the entire transaction
    #----------------------------------------------------------------------

    s.way_record_en         = Wire( 1 )
    s.way_record_in         = Wire( 1 )

    @s.combinational
    def comb_way_select():
      if (s.hit) :
        if (s.hit_0) :
          s.way_record_in.value = Bits( 1, 0 )
        else :
          if (s.hit_1) :
            s.way_record_in.value = Bits( 1, 1 )
          else :
            s.way_record_in.value = Bits( 1, 0 )
      else :
        s.way_record_in.value = s.lru_way

      if s.state_reg == s.STATE_TAG_CHECK:
        s.way_sel_current.value = s.way_record_in
      else:
        s.way_sel_current.value = s.way_sel

    s.way_record = m = RegEnRst( dtype = 1, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.way_record_en,
      m.in_, s.way_record_in,
      m.out, s.way_sel
    )

    #----------------------------------------------------------------------
    # State Outputs
    #----------------------------------------------------------------------

    # General parameters
    x       = Bits( 1, 0 )
    y       = Bits( 1, 1 )
    n       = Bits( 1, 0 )

    # Parameters for is_refill
    r_x     = Bits( 1, 0 )
    r_c     = Bits( 1, 0 ) # fill data array from _c_ache
    r_m     = Bits( 1, 1 ) # fill data array from _m_em

    # Parameters for memreq_type_mux
    m_x     = Bits( 4, 0 )
    m_e     = Bits( 4, 1 )
    m_r     = Bits( 4, 0 )

    s.tag_array_wen = Wire( 1 )
    s.tag_array_ren = Wire( 1 )

    # Control signal bit slices

    CS_cachereq_rdy        = slice( 20, 21 )
    CS_cacheresp_val       = slice( 19, 20 )
    CS_memreq_val          = slice( 18, 19 )
    CS_memresp_rdy         = slice( 17, 18 )
    CS_cachereq_en         = slice( 16, 17 )
    CS_memresp_en          = slice( 15, 16 )
    CS_is_refill           = slice( 14, 15 )
    CS_read_data_reg_en    = slice( 13, 14 )
    CS_read_tag_reg_en     = slice( 12, 13 )
    CS_memreq_type         = slice( 8,  12 ) # 4 bits
    CS_valid_bit_in        = slice( 7,  8  )
    CS_valid_bits_write_en = slice( 6,  7  )
    CS_dirty_bit_in        = slice( 5,  6  )
    CS_dirty_bits_write_en = slice( 4,  5  )
    CS_lru_bits_write_en   = slice( 3,  4  )
    CS_way_record_en       = slice( 2,  3  )
    CS_cacheresp_hit       = slice( 1,  2  )
    CS_skip_read_data_reg  = slice( 0,  1  )

    s.cs = Wire( 21 )

    @s.combinational
    def comb_control_table():
      sr = s.state_reg

      #                                                                    $    $    mem mem  $    mem         read read mem  valid valid dirty dirty lru   way    $    skip
      #                                                                    req  resp req resp req  resp is     data tag  req  bit   write bit   write write record resp data
      #                                                                    rdy  val  val rdy  en   en   refill en   en   type in    en    in    en    en    en     hit  reg
      s.cs.value                                                 = concat( n,   n,   n,  n,   x,   x,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      if   sr == s.STATE_IDLE:                        s.cs.value = concat( y,   n,   n,  n,   y,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_TAG_CHECK:                   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    y,     n,   y    )
      elif sr == s.STATE_WRITE_CACHE_RESP_HIT:        s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    y,    n,     y,   n    )
      elif sr == s.STATE_WRITE_DATA_ACCESS_HIT:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     y,   n    )
      elif sr == s.STATE_READ_DATA_ACCESS_MISS:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   n    )
      elif sr == s.STATE_WRITE_DATA_ACCESS_MISS:      s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
      elif sr == s.STATE_INIT_DATA_ACCESS:            s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    n,    y,    y,    n,     n,   n    )
      elif sr == s.STATE_REFILL_REQUEST:              s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_r, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_REFILL_WAIT:                 s.cs.value = concat( n,   n,   n,  y,   n,   y,   r_m,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_REFILL_UPDATE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, y,    y,    n,    y,    n,    n,     n,   n    )
      elif sr == s.STATE_EVICT_PREPARE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   y,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_EVICT_REQUEST:               s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_e, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_EVICT_WAIT:                  s.cs.value = concat( n,   n,   n,  y,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      elif sr == s.STATE_WAIT_HIT:                    s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     y,   n    )
      elif sr == s.STATE_WAIT_MISS:                   s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
      else :                                          s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )

      # Unpack signals

      s.cachereq_rdy.value        = s.cs[ CS_cachereq_rdy        ]
      s.cacheresp_val.value       = s.cs[ CS_cacheresp_val       ]
      s.memreq_val.value          = s.cs[ CS_memreq_val          ]
      s.memresp_rdy.value         = s.cs[ CS_memresp_rdy         ]
      s.cachereq_en.value         = s.cs[ CS_cachereq_en         ]
      s.memresp_en.value          = s.cs[ CS_memresp_en          ]
      s.is_refill.value           = s.cs[ CS_is_refill           ]
      s.read_data_reg_en.value    = s.cs[ CS_read_data_reg_en    ]
      s.read_tag_reg_en.value     = s.cs[ CS_read_tag_reg_en     ]
      s.memreq_type.value         = s.cs[ CS_memreq_type         ]
      s.valid_bit_in.value        = s.cs[ CS_valid_bit_in        ]
      s.valid_bits_write_en.value = s.cs[ CS_valid_bits_write_en ]
      s.dirty_bit_in.value        = s.cs[ CS_dirty_bit_in        ]
      s.dirty_bits_write_en.value = s.cs[ CS_dirty_bits_write_en ]
      s.lru_bits_write_en.value   = s.cs[ CS_lru_bits_write_en   ]
      s.way_record_en.value       = s.cs[ CS_way_record_en       ]
      s.cacheresp_hit.value       = s.cs[ CS_cacheresp_hit       ]
      s.skip_read_data_reg.value  = s.cs[ CS_skip_read_data_reg  ]

      # set cacheresp_val when there is a hit for one hit latency
      if (s.read_hit | s.write_hit) and (s.state_reg == s.STATE_TAG_CHECK):
        s.cacheresp_val.value = 1
        s.cacheresp_hit.value = 1

        # if read hit, if can send response, immediately take new cachereq
        if s.read_hit:
          s.cachereq_rdy.value  = s.cacheresp_rdy
          s.cachereq_en.value   = s.cacheresp_rdy

      # since cacheresp already handled, can immediately take new cachereq
      elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
        s.cachereq_rdy.value  = 1
        s.cachereq_en.value   = 1

    # Control bits based on next state

    NS_tag_array_wen  = slice( 3, 4 )
    NS_tag_array_ren  = slice( 2, 3 )
    NS_data_array_wen = slice( 1, 2 )
    NS_data_array_ren = slice( 0, 1 )

    s.ns = Wire( 4 )

    @s.combinational
    def comb_control_table():

      # set enable for tag_array and data_array one cycle early (dependant on next_state)
      sn = s.state_next
      s.ns.value = concat( n,   n,    n,  n )
      #                                                              tag   tag   data  data
      #                                                              array array array array
      #                                                              wen   ren   wen   ren
      if   sn == s.STATE_IDLE:                   s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_TAG_CHECK:              s.ns.value = concat( n,    y,    n,    y,   )
      elif sn == s.STATE_WRITE_CACHE_RESP_HIT:   s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_WRITE_DATA_ACCESS_HIT:  s.ns.value = concat( y,    n,    y,    n,   )
      elif sn == s.STATE_READ_DATA_ACCESS_MISS:  s.ns.value = concat( n,    n,    n,    y,   )
      elif sn == s.STATE_WRITE_DATA_ACCESS_MISS: s.ns.value = concat( y,    n,    y,    n,   )
      elif sn == s.STATE_INIT_DATA_ACCESS:       s.ns.value = concat( y,    n,    y,    n,   )
      elif sn == s.STATE_REFILL_REQUEST:         s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_REFILL_WAIT:            s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_REFILL_UPDATE:          s.ns.value = concat( y,    n,    y,    n,   )
      elif sn == s.STATE_EVICT_PREPARE:          s.ns.value = concat( n,    y,    n,    y,   )
      elif sn == s.STATE_EVICT_REQUEST:          s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_EVICT_WAIT:             s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_WAIT_HIT:               s.ns.value = concat( n,    n,    n,    n,   )
      elif sn == s.STATE_WAIT_MISS:              s.ns.value = concat( n,    n,    n,    n,   )
      else :                                     s.ns.value = concat( n,    n,    n,    n,   )

      # Unpack signals

      s.tag_array_wen.value  = s.ns[ NS_tag_array_wen  ]
      s.tag_array_ren.value  = s.ns[ NS_tag_array_ren  ]
      s.data_array_wen.value = s.ns[ NS_data_array_wen ]
      s.data_array_ren.value = s.ns[ NS_data_array_ren ]

    # lru bit determination
    @s.combinational
    def comb_lru_bit_in():
      s.lru_bit_in.value = ~s.way_sel_current

    # tag array enables
    @s.combinational
    def comb_tag_arry_en():
      s.tag_array_0_wen.value = s.tag_array_wen & ~s.way_sel_current
      s.tag_array_0_ren.value = s.tag_array_ren
      s.tag_array_1_wen.value = s.tag_array_wen &  s.way_sel_current
      s.tag_array_1_ren.value = s.tag_array_ren

    # Building data_array_wben
    # This is in control because we want to facilitate more complex patterns
    #   when we want to start supporting subword accesses

    s.cachereq_offset  = Wire ( clog2(clw / 8) )
    s.wben_decoder_out = Wire ( 16 )

    @s.combinational
    def comb_cachereq_offset():
      s.cachereq_offset.value = s.cachereq_addr[0:num_bytes_bw]

    s.wben_decoder = m = DecodeWbenRTL( num_bytes )
    s.connect_pairs(
      m.idx,  s.cachereq_offset    ,
      m.len,  s.cachereq_len_reg_out,
      m.out,  s.wben_decoder_out   ,
    )

    # Choose byte to read from cacheline based on what the offset was

    @s.combinational
    def comb_read_word_sel():
      s.read_byte_sel.value = s.cachereq_offset

    @s.combinational
    def comb_enable_writing():

      # Logic to enable writing of the entire cacheline in case of refill
      # and just one word for writes and init

      if   ( s.is_refill ) : s.data_array_wben.value = Bits( 16, 0xffff )
      else                 : s.data_array_wben.value = s.wben_decoder_out

      # Managing the cache response type based on cache request type

      s.cacheresp_type.value = s.cachereq_type

