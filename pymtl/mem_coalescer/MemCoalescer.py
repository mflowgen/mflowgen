#=========================================================================
# MemCoalescer
#
# A logic unit that coalesce requests accessing the same memory address
# and broadcast a response to all coalesced requests.
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg, MemReqMsg, MemRespMsg
from pclib.rtl  import RegRst, RegEnRst, RoundRobinArbiterEn, Mux, EqComparator

class MemCoalescer( Model ):

  def __init__( s, nports, MsgType ):

    #---------------------------------------------------------------------
    # Paremeters
    #---------------------------------------------------------------------

    addr_nbits    = 32
    data_nbits    = 32
    opaque_nbits  = 8

    #---------------------------------------------------------------------
    # Requesters <-> MemCoalescer
    #---------------------------------------------------------------------

    s.reqs      = InValRdyBundle  [nports]( MsgType.req )
    s.resps     = OutValRdyBundle [nports]( MsgType.resp )

    #---------------------------------------------------------------------
    # MemCoalescer <-> Memory
    #---------------------------------------------------------------------

    s.memreq        = OutValRdyBundle( MsgType.req )
    s.memresp       = InValRdyBundle ( MsgType.resp )

    #---------------------------------------------------------------------
    # Coalescer's states
    #---------------------------------------------------------------------

    # Coalescer's states (for all requesting ports)

    s.STATE_IDLE    = 0
    s.STATE_PENDING = 1

    s.state = RegRst( 1, reset_value = s.STATE_IDLE )

    # Per-port states

    s.PORT_STATE_IDLE     = 0
    s.PORT_STATE_PENDING  = 1

    s.ports_state = RegRst [nports] ( 1, reset_value = s.PORT_STATE_IDLE )

    #---------------------------------------------------------------------
    # curr_addr_reg: stores address being processed
    #---------------------------------------------------------------------

    s.curr_addr_reg = RegEnRst ( addr_nbits, reset_value = 0x0 )

    #---------------------------------------------------------------------
    # opaque_regs: store opaque fields of requests being processed
    #---------------------------------------------------------------------

    s.opaque_regs = RegEnRst [nports] ( opaque_nbits, reset_value = 0x0 )

    #---------------------------------------------------------------------
    # Arbiter
    #---------------------------------------------------------------------

    s.arbiter = RoundRobinArbiterEn( nports )

    #---------------------------------------------------------------------
    # Other components
    #---------------------------------------------------------------------

    # Mux that selects address granted by the arbiter

    s.granted_addr_sel_mux  = Mux ( addr_nbits, nports )

    # Mux that selects address that is compared against

    s.cmp_addr_sel_mux      = Mux ( addr_nbits, 2 )

    # Address comparator

    s.addr_cmps             = EqComparator [nports] ( nbits = addr_nbits )

    #---------------------------------------------------------------------
    # Wires
    #---------------------------------------------------------------------

    s.coalesced_bits        = Wire [nports] ( 1 )

    s.encoded_arb_grant     = Wire ( clog2( nports ) )

    #---------------------------------------------------------------------
    # Connections
    #---------------------------------------------------------------------

    # reqs <-> arbiter

    for i in range( nports ):
      s.connect_pairs( s.reqs[i].val, s.arbiter.reqs[i] )

    # reqs_addr <-> granted_addr_sel_mux

    for i in range( nports ):
      s.connect_pairs( s.reqs[i].msg.addr, s.granted_addr_sel_mux.in_[i] )

    # granted_addr_sel_mux <-> curr_addr_reg

    s.connect_pairs( s.granted_addr_sel_mux.out, s.curr_addr_reg.in_ )

    # granted_addr_sel_mux/curr_addr_reg <-> cmp_addr_sel_mux

    s.connect_pairs( s.curr_addr_reg.in_,   s.cmp_addr_sel_mux.in_[0] )
    s.connect_pairs( s.curr_addr_reg.out,   s.cmp_addr_sel_mux.in_[1] )

    # cmp_addr_sel_mux <-> addr_cmps

    for i in range( nports ):
      s.connect_pairs( s.cmp_addr_sel_mux.out,  s.addr_cmps[i].in0 )
      s.connect_pairs( s.reqs[i].msg.addr,      s.addr_cmps[i].in1 )

    # addr_cmps <-> coalesced_bits

    for i in range( nports ):
      s.connect_pairs( s.addr_cmps[i].out, s.coalesced_bits[i] )

    #---------------------------------------------------------------------
    # Internal combinational logic units
    #---------------------------------------------------------------------

    # Enable/Disable arbiter
    # Enable the arbiter only if there's a valid mem request that can
    # go out to the memory in this cycle
    @s.combinational
    def comb_arbiter_en():

      s.arbiter.en.value = s.memreq.val & s.memreq.rdy

    s.encoder_kill = Wire( 1 )

    # Encode output grants generated by the arbiter
    @s.combinational
    def comb_encode_arb_grants():

      s.encoder_kill.value = 0
      s.encoded_arb_grant.value = 0

      for i in range( nports ):
        if s.arbiter.grants[i] and s.encoder_kill == 0:
          s.encoded_arb_grant.value = i
          s.encoder_kill.value = 1

    # Enable/Disable curr_addr reg
    @s.combinational
    def comb_curr_addr_reg_en():

      s.curr_addr_reg.en.value = ( s.state.out == s.STATE_IDLE )

    # Global state transitions
    @s.combinational
    def state_transition():

      curr_state = s.state.out
      next_state = s.state.out

      # STATE_IDLE -> STATE_PENDING
      if ( curr_state == s.STATE_IDLE ):
        if ( s.memreq.val and s.memreq.rdy ):
          next_state = s.STATE_PENDING

      # STATE_PENDING -> STATE_IDLE
      if ( curr_state == s.STATE_PENDING ):
        if ( s.memresp.rdy and s.memresp.val ):
          next_state = s.STATE_IDLE

      s.state.in_.value = next_state

    # Port state transitions
    @s.combinational
    def ports_state_transition():

      for i in range( nports ):
        curr_state = s.ports_state[i].out
        next_state = s.ports_state[i].out

        # PORT_STATE_IDLE -> PORT_STATE_PENDING
        if ( curr_state == s.PORT_STATE_IDLE ):
          if ( s.coalesced_bits[i] and s.reqs[i].val and ~s.memresp.val ):
            next_state = s.PORT_STATE_PENDING

        # PORT_STATE_PENDING -> PORT_STATE_IDLE
        if ( curr_state == s.PORT_STATE_PENDING ):
          if ( s.memresp.rdy and s.memresp.val ):
            next_state = s.STATE_IDLE

        s.ports_state[i].in_.value = next_state

    # Enable/Disable opaque regs

    s.opaque_tmp_req   = Wire( MsgType.req  )

    @s.combinational
    def comb_opaque_regs_en():

      for i in range( nports ):
        # hawajkm: PyMTL bug
        s.opaque_tmp_req.value = s.reqs[i].msg
        s.opaque_regs[i].en.value = ( s.ports_state[i].out == s.PORT_STATE_IDLE )
        s.opaque_regs[i].in_.value = s.opaque_tmp_req.opaque

    @s.combinational
    def comb_cmp_addr_sel_mux_sel():

      s.cmp_addr_sel_mux.sel.value = (s.state.out == s.STATE_PENDING)

    @s.combinational
    def comb_granted_addr_sel_mux_sel():

      s.granted_addr_sel_mux.sel.value = s.encoded_arb_grant

    #---------------------------------------------------------------------
    # Interface combinational logic units
    #---------------------------------------------------------------------

    s.issued    = Wire( nports )
    s.coalesced = Wire( nports )

    # Set reqs_rdy signals
    @s.combinational
    def comb_reqs_rdy():

      for i in range( nports ):

        # whether a request can be issued

        s.issued[i].value = ( s.state.out == s.STATE_IDLE ) & s.coalesced_bits[i] & s.memreq.rdy

        # whether a request can be coalesced

        s.coalesced[i].value = ( s.state.out == s.STATE_PENDING ) &  s.coalesced_bits[i] & \
                               ( s.ports_state[i].out == s.PORT_STATE_IDLE ) & ~s.memresp.val

        # ready if a request is either issued or coalesced

        s.reqs[i].rdy.value = s.issued[i] | s.coalesced[i]

    # Set memreq

    s.memreq_kill = Wire( 1 )
    s.memreq_tmp_req  = Wire( MsgType.req )

    @s.combinational
    def comb_memreq():

      # val
      s.memreq.val.value =  ( s.state.out == s.STATE_IDLE ) & \
                            ( s.arbiter.grants != 0 )

      s.memreq_kill.value = 0
      s.memreq.msg.value  = 0

      # msg
      for i in range( nports ):
        if s.arbiter.grants[i] and s.memreq_kill == 0:
          # hawajkm: PyMTL bug
          s.memreq_tmp_req.value  = s.reqs[i].msg
          s.memreq.msg.value      = s.memreq_tmp_req
          s.memreq_kill.value     = 1

    # Set memresp_rdy
    @s.combinational
    def comb_memresp_rdy():

      s.memresp.rdy.value = 1
      for i in range( nports ):
        if ( s.ports_state[i].out == s.PORT_STATE_PENDING ):
          s.memresp.rdy.value &= s.resps[i].rdy

    # Set resps

    s.tmp_resp  = Wire( MsgType.resp )

    @s.combinational
    def comb_resps():

      for i in range( nports ):
        s.resps[i].val.value = s.memresp.val & \
                               ( s.ports_state[i].out == s.PORT_STATE_PENDING )

        # hawajkm: PyMTL bug
        s.tmp_resp.value        = s.memresp.msg
        s.tmp_resp.opaque.value = s.opaque_regs[i].out
        s.resps[i].msg.value    = s.tmp_resp

  def line_trace(s):
    return ''
