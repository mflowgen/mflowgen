#=========================================================================
# BlockingCacheCtrlPRTL.py
#=========================================================================

from pymtl      import *

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg
from ifcs import MemReqMsg4B, MemRespMsg4B
from ifcs import MemReqMsg16B, MemRespMsg16B

from pclib.rtl     import RegisterFile, RegEnRst

class InstBufferCtrl( Model ):

  def __init__( s, num_entries ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.buffreq_val     = InPort ( 1 )
    s.buffreq_rdy     = OutPort( 1 )
    s.buffresp_val    = OutPort( 1 )
    s.buffresp_rdy    = InPort ( 1 )
    s.memreq_val      = OutPort( 1 )
    s.memreq_rdy      = InPort ( 1 )
    s.memresp_val     = InPort ( 1 )
    s.memresp_rdy     = OutPort( 1 )

    # control signals (ctrl->dpath)

    s.buffreq_en      = OutPort( 1 )
    s.memresp_en      = OutPort( 1 )
    s.arrays_wen_mask = OutPort( num_entries )
    s.way_sel         = OutPort( 1 )
    s.way_sel_current = OutPort( 1 )
    s.cacheresp_hit   = OutPort( 1 )

    # status signals (dpath->ctrl)

    s.buffreq_addr       = InPort( addr_nbits )
    s.tag_match          = InPort( num_entries )

    #----------------------------------------------------------------------
    # State Definitions
    #----------------------------------------------------------------------

    s.STATE_IDLE           = Bits( 3, 0 )
    s.STATE_TAG_CHECK      = Bits( 3, 1 )
    s.STATE_READ_MISS      = Bits( 3, 2 )
    s.STATE_WAIT_HIT       = Bits( 3, 3 )
    s.STATE_WAIT_MISS      = Bits( 3, 4 )
    s.STATE_REFILL_REQUEST = Bits( 3, 5 )
    s.STATE_REFILL_WAIT    = Bits( 3, 6 )
    s.STATE_REFILL_UPDATE  = Bits( 3, 7 )

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
    s.hit_mask  = Wire( num_entries )
    s.miss_mask = Wire( num_entries )
    s.hit       = Wire( 1 )
    s.refill    = Wire( 1 )

    @s.combinational
    def comb_state_transition():
      s.in_go.value     = s.cachereq_val  & s.cachereq_rdy
      s.out_go.value    = s.cacheresp_val & s.cacheresp_rdy
      s.hit_mask.value  = s.is_valid_mask & s.tag_match_mask
      s.miss_mask.value = ~s.hit_mask
      s.hit.value       = reduce_or( hit_mask )

      # Hardcoded for 2 entries
      s.refill.value    = (s.miss_mask[0] & ~s.lru_way) | \
                          (s.miss_mask[1] &  s.lru_way)

    s.state_reg  = Wire( 3 )
    s.state_next = Wire( 3 )

    @s.combinational
    def comb_next_state():
      s.state_next.value = s.state_reg

      if s.state_reg == s.STATE_IDLE:
        if s.in_go: s.state_next.value = s.STATE_TAG_CHECK

      elif s.state_reg == s.STATE_TAG_CHECK:
        if s.hit:
          if s.buffresp_rdy:
            if    s.buffreq_val: s.state_next.value = s.STATE_TAG_CHECK
            elif ~s.buffreq_val: s.state_next.value = s.STATE_IDLE
          elif ~s.buffresp_rdy : s.state_next.value = s.STATE_WAIT_HIT
        # Do I even need the refill signal??
        elif ( s.refill )      : s.state_next.value = s.STATE_REFILL_REQUEST

      elif s.state_reg == s.STATE_READ_MISS:
        s.state_next.value = s.STATE_WAIT_MISS

      elif s.state_reg == s.STATE_REFILL_REQUEST:
        if s.memreq_rdy: s.state_next.value = s.STATE_REFILL_WAIT

      elif s.state_reg == s.STATE_REFILL_WAIT:
        if s.memresp_val: s.state_next.value = s.STATE_REFILL_UPDATE

      elif s.state_reg == s.STATE_REFILL_UPDATE:
        s.state_next.value = s.STATE_READ_MISS

      elif s.state_reg == s.STATE_WAIT_HIT:
        if s.out_go: s.state_next.value = s.STATE_IDLE

      elif s.state_reg == s.STATE_WAIT_MISS:
        if s.out_go: s.state_next.value = s.STATE_IDLE

      else:
        s.state_next.value = s.STATE_IDLE

    #----------------------------------------------------------------------
    # Valid/Dirty bits record
    #----------------------------------------------------------------------

    s.valid_bit_in        = Wire( 1 )
    s.valid_bits_wen      = Wire( 1 )
    s.valid_bits_wen_mask = Wire( num_entries )
    s.is_valid_mask       = Wire( num_entries )

    @s.combinational
    def comb_valid_bits():
      # Hardcoded for 2 entries
      s.valid_bits_wen_mask[0].value = s.valid_bits_wen & ~s.way_sel_current
      s.valid_bits_wen_mask[1].value = s.valid_bits_wen &  s.way_sel_current

    s.valid_bits = RegEnRst[num_entries]( dtype = 1, reset_value = 0 )

    for i in xrange( num_entries ):
      s.connect( s.valid_bits[i].en,  s.valid_bits_wen_mask[i] )
      s.connect( s.valid_bits[i].in_, s.valid_bit_in )
      s.connect( s.valid_bits[i].out, s.is_valid_mask[i] )

    #---------------------------------------------------------------------
    # LRU bit record
    #---------------------------------------------------------------------
    s.lru_in  = Wire( 1 )
    s.lru_wen = Wire( 1 )
    s.lru_way = Wire( 1 )

    @s.combinational
    def comb_lru_bit_in():
      s.lru_bit_in.value = ~s.way_sel_current 

    s.lru = m = RegEnRst( dtype = 1, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.lru_wen,
      m.in_, s.lru_in,
      m.out, s.lru_way,
    )

    #----------------------------------------------------------------------
    # Way selection.
    #   The way is determined in the tag check state, and is
    #   then recorded for the entire transaction
    #----------------------------------------------------------------------

    s.way_record_en = Wire( 1 )
    s.way_record_in = Wire( 1 )

    @s.combinational
    def comb_way_select():
      if   s.hit[0]:
        s.way_record_in.value = Bits( 1, 0 )
      elif s.hit[1]:
        s.way_record_in.value = Bits( 1, 1 )
      else:
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

    #---------------------------------------------------------------------
    # data/tag array enables
    #---------------------------------------------------------------------

    @s.combinational
    def comb_arrays_en():
      s.arrays_wen_mask[0].value = s.arrays_wen & ~s.way_sel_current
      s.arrays_wen_mask[1].value = s.arrays_wen &  s.way_sel_current

    #----------------------------------------------------------------------
    # State Outputs
    #----------------------------------------------------------------------

    x = Bits( 1, 0 )
    y = Bits( 1, 1 )
    n = Bits( 1, 0 )

    # Control signal bit slices

    CS_cachereq_rdy   = slice( 11, 12 )
    CS_cacheresp_val  = slice( 10, 11 )
    CS_memreq_val     = slice( 9,  10 )
    CS_memresp_rdy    = slice( 8,  9  )
    CS_cachereq_en    = slice( 7,  8  )
    CS_memresp_en     = slice( 6,  7  )
    CS_valid_bit_in   = slice( 5,  6  )
    CS_valid_bits_wen = slice( 4,  5  )
    CS_lru_wen        = slice( 3,  4  )
    CS_way_record_en  = slice( 2,  3  )
    CS_cacheresp_hit  = slice( 1,  2  )
    # Control bits based on next state
    # No read_en anymore because we use registers
    CS_NS_arrays_wen  = slice( 0,  1  )

    s.cs = Wire( 13 )

    @s.combinational
    def comb_control_table():
      sr = s.state_reg

      #                                                       $   $    mem mem  $    mem  val val lru way  $       arrays
      #                                                       req resp req resp req  resp bit wen wen rec  resp N  wen
      #                                                       rdy val  val rdy  en   en   in          en   hit  S
      s.cs.value                                    = concat( n,  n,   n,  n,   x,   x,   x,  n,  n,  n,   n,      n  )
      if   sr == s.STATE_IDLE:           s.cs.value = concat( y,  n,   n,  n,   y,   n,   x,  n,  n,  n,   n,      n  )
      elif sr == s.STATE_TAG_CHECK:      s.cs.value = concat( n,  n,   n,  n,   n,   n,   x,  n,  y,  y,   n,      n  )
      elif sr == s.STATE_READ_MISS:      s.cs.value = concat( n,  n,   n,  n,   n,   n,   x,  n,  y,  n,   n,      n  )
      elif sr == s.STATE_REFILL_REQUEST: s.cs.value = concat( n,  n,   y,  n,   n,   n,   x,  n,  n,  n,   n,      n  )
      elif sr == s.STATE_REFILL_WAIT:    s.cs.value = concat( n,  n,   n,  y,   n,   y,   x,  n,  n,  n,   n,      n  )
      elif sr == s.STATE_REFILL_UPDATE:  s.cs.value = concat( n,  n,   n,  n,   n,   n,   y,  y,  n,  n,   n,      y  )
      elif sr == s.STATE_WAIT_HIT:       s.cs.value = concat( n,  y,   n,  n,   n,   n,   x,  n,  n,  n,   y,      n  )
      elif sr == s.STATE_WAIT_MISS:      s.cs.value = concat( n,  y,   n,  n,   n,   n,   x,  n,  n,  n,   n,      n  )
      else:                              s.cs.value = concat( n,  n,   n,  n,   n,   n,   x,  n,  n,  n,   n,      n  )

      # Unpack signals

      s.cachereq_rdy.value   = s.cs[ CS_cachereq_rdy   ]
      s.cacheresp_val.value  = s.cs[ CS_cacheresp_val  ]
      s.memreq_val.value     = s.cs[ CS_memreq_val     ]
      s.memresp_rdy.value    = s.cs[ CS_memresp_rdy    ]
      s.cachereq_en.value    = s.cs[ CS_cachereq_en    ]
      s.memresp_en.value     = s.cs[ CS_memresp_en     ]
      s.valid_bit_in.value   = s.cs[ CS_valid_bit_in   ]
      s.valid_bits_wen.value = s.cs[ CS_valid_bits_wen ]
      s.lru_wen.value        = s.cs[ CS_lru_bits_wen   ]
      s.way_record_en.value  = s.cs[ CS_way_record_en  ]
      s.cacheresp_hit.value  = s.cs[ CS_cacheresp_hit  ]
      s.arrays_wen.value     = s.cs[ CS_NS_arrays_wen  ]

      # set cacheresp_val when there is a hit for one hit latency

      if s.hit && s.state_reg == s.STATE_TAG_CHECK:
        s.cacheresp_val.value = 1
        s.cacheresp_hit.value = 1

        # if can send response, immediately take new cachereq
        s.cachereq_rdy.value  = s.cacheresp_rdy
        s.cachereq_en.value   = s.cacheresp_rdy
