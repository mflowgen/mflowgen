#=========================================================================
# DirectMappedInstBufferCtrl.py
#=========================================================================

from pymtl      import *

from pclib.rtl     import RegisterFile, RegEnRst

class DirectMappedInstBufferCtrl( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.buffreq_val  = InPort ( 1 )
    s.buffreq_rdy  = OutPort( 1 )
    s.buffresp_val = OutPort( 1 )
    s.buffresp_rdy = InPort ( 1 )
    s.memreq_val   = OutPort( 1 )
    s.memreq_rdy   = InPort ( 1 )
    s.memresp_val  = InPort ( 1 )
    s.memresp_rdy  = OutPort( 1 )

    # control signals (ctrl->dpath)

    s.buffreq_en   = OutPort( 1 )
    s.arrays_wen   = OutPort( 1 )
    s.buffresp_hit = OutPort( 1 )

    # status signals (dpath->ctrl)

    s.tag_match    = InPort( 1 )
    s.is_valid     = InPort( 1 )

    #----------------------------------------------------------------------
    # State Definitions
    #----------------------------------------------------------------------

    s.STATE_IDLE           = Bits( 3, 0 )
    s.STATE_TAG_CHECK      = Bits( 3, 1 )
    s.STATE_MISS_ACCESS    = Bits( 3, 2 )
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
    s.hit       = Wire( 1 )

    @s.combinational
    def comb_state_transition():
      s.in_go.value  = s.buffreq_val  & s.buffreq_rdy
      s.out_go.value = s.buffresp_val & s.buffresp_rdy
      s.hit.value    = s.is_valid & s.tag_match

    s.state_reg  = Wire( 3 )
    s.state_next = Wire( 3 )

    @s.combinational
    def comb_next_state():
      s.state_next.value = s.state_reg

      if s.state_reg == s.STATE_IDLE:
        if s.in_go: s.state_next.value = s.STATE_TAG_CHECK

      elif s.state_reg == s.STATE_TAG_CHECK:
        if s.hit:
          # requester is not ready to accept a response, wait
          if ~s.buffresp_rdy:  s.state_next.value = s.STATE_WAIT_HIT
          # can send the response, and there is an upcoming request, stay in TC for b-2-b reqs
          elif s.buffreq_val:  s.state_next.value = s.STATE_TAG_CHECK
          # can send the response, but no upcoming request, return to idle
          else:                s.state_next.value = s.STATE_IDLE

        else: # miss -- need to refill
          s.state_next.value = s.STATE_REFILL_REQUEST

      elif s.state_reg == s.STATE_REFILL_REQUEST:
        if s.memreq_rdy: s.state_next.value = s.STATE_REFILL_WAIT

      elif s.state_reg == s.STATE_REFILL_WAIT:
        if s.memresp_val: s.state_next.value = s.STATE_REFILL_UPDATE

      elif s.state_reg == s.STATE_REFILL_UPDATE:
        s.state_next.value = s.STATE_MISS_ACCESS

      elif s.state_reg == s.STATE_MISS_ACCESS:
        s.state_next.value = s.STATE_WAIT_MISS

      elif s.state_reg == s.STATE_WAIT_HIT:
        if s.out_go: s.state_next.value = s.STATE_IDLE

      elif s.state_reg == s.STATE_WAIT_MISS:
        if s.out_go: s.state_next.value = s.STATE_IDLE

      else:
        s.state_next.value = s.STATE_IDLE

    #----------------------------------------------------------------------
    # State Outputs
    #----------------------------------------------------------------------

    x = Bits( 1, 0 )
    y = Bits( 1, 1 )
    n = Bits( 1, 0 )

    # Control signal bit slices

    CS_buffreq_rdy    = slice( 6, 7 )
    CS_buffresp_val   = slice( 5, 6 )
    CS_memreq_val     = slice( 4, 5 )
    CS_memresp_rdy    = slice( 3, 4 )
    CS_buffreq_en     = slice( 2, 3 )
    CS_buffresp_hit   = slice( 1, 2 )
    CS_arrays_wen     = slice( 0, 1 )

    s.cs = Wire( 7 )

    @s.combinational
    def comb_control_table():
      sr = s.state_reg

      #                                                       $   $    mem mem  $   $    arrays
      #                                                       req resp req resp req resp wen
      #                                                       rdy val  val rdy  en  hit  
      s.cs.value                                    = concat( n,  n,   n,  n,   x,  n,   n  )
      if   sr == s.STATE_IDLE:           s.cs.value = concat( y,  n,   n,  n,   y,  n,   n  )
      elif sr == s.STATE_TAG_CHECK:      s.cs.value = concat( n,  n,   n,  n,   n,  n,   n  )
      elif sr == s.STATE_MISS_ACCESS:    s.cs.value = concat( n,  n,   n,  n,   n,  n,   n  )
      elif sr == s.STATE_REFILL_REQUEST: s.cs.value = concat( n,  n,   y,  n,   n,  n,   n  )
      elif sr == s.STATE_REFILL_WAIT:    s.cs.value = concat( n,  n,   n,  y,   n,  n,   n  )
      elif sr == s.STATE_REFILL_UPDATE:  s.cs.value = concat( n,  n,   n,  n,   n,  n,   y  )
      elif sr == s.STATE_WAIT_HIT:       s.cs.value = concat( n,  y,   n,  n,   n,  y,   n  )
      elif sr == s.STATE_WAIT_MISS:      s.cs.value = concat( n,  y,   n,  n,   n,  n,   n  )
      else:                              s.cs.value = concat( n,  n,   n,  n,   n,  n,   n  )

      # Unpack signals

      s.buffreq_rdy.value    = s.cs[ CS_buffreq_rdy    ]
      s.buffresp_val.value   = s.cs[ CS_buffresp_val   ]
      s.memreq_val.value     = s.cs[ CS_memreq_val     ]
      s.memresp_rdy.value    = s.cs[ CS_memresp_rdy    ]
      s.buffreq_en.value     = s.cs[ CS_buffreq_en     ]
      s.buffresp_hit.value   = s.cs[ CS_buffresp_hit   ]
      s.arrays_wen.value     = s.cs[ CS_arrays_wen     ]

      # set buffresp_val when there is a hit for one hit latency

      if s.hit & (s.state_reg == s.STATE_TAG_CHECK): # operator priority!!!
        s.buffresp_val.value = 1
        s.buffresp_hit.value = 1

        # if can send response, immediately take new buffreq
        s.buffreq_rdy.value  = s.buffresp_rdy
        s.buffreq_en.value   = s.buffresp_rdy
