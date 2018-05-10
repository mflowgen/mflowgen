#=========================================================================
# DirectMappedInstBuffer.py
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg, MemRespMsg

from pclib.rtl.queues import SingleElementBypassQueue

from DirectMappedInstBufferCtrl  import DirectMappedInstBufferCtrl
from DirectMappedInstBufferDpath import DirectMappedInstBufferDpath

class DirectMappedInstBuffer( Model ):

  def __init__( s, num_entries, line_nbytes ):

    s.explicit_modulename = "DirectMappedInstBuffer_{}_{}B".format( num_entries, line_nbytes)

    opaque_nbits = 8
    data_nbits   = 32
    addr_nbits   = 32
    line_nbits   = line_nbytes * 8

    # Proc <-> Buffer

    s.buffreq  = InValRdyBundle ( MemReqMsg(opaque_nbits, addr_nbits, data_nbits) )
    s.buffresp = OutValRdyBundle( MemRespMsg(opaque_nbits, data_nbits)  )

    # Buffer <-> Mem

    s.memreq    = OutValRdyBundle( MemReqMsg(opaque_nbits, data_nbits, line_nbits) )
    s.memresp   = InValRdyBundle ( MemRespMsg(opaque_nbits, line_nbits) )

    s.ctrl      = DirectMappedInstBufferCtrl ()
    s.dpath     = DirectMappedInstBufferDpath( num_entries, line_nbytes )

    # Bypass Queue to cut the ready path because we allow back-to-back
    # requests by letting cachereq_rdy = cacheresp_rdy 

    s.resp_bypass = SingleElementBypassQueue( MemRespMsg(opaque_nbits, data_nbits) )

    # Control

    s.connect_pairs(

      # Buff request

      s.ctrl.buffreq_val,    s.buffreq.val,
      s.ctrl.buffreq_rdy,    s.buffreq.rdy,

      # Buff response

      s.ctrl.buffresp_val,   s.resp_bypass.enq.val,
      s.ctrl.buffresp_rdy,   s.resp_bypass.enq.rdy,
      s.resp_bypass.deq.val, s.buffresp.val,
      s.resp_bypass.deq.rdy, s.buffresp.rdy,

      # Memory request

      s.ctrl.memreq_val,     s.memreq.val,
      s.ctrl.memreq_rdy,     s.memreq.rdy,

      # Memory response

      s.ctrl.memresp_val,    s.memresp.val,
      s.ctrl.memresp_rdy,    s.memresp.rdy,

    )

    # Dpath

    s.connect_pairs(

      # Buff request

      s.dpath.buffreq_msg,     s.buffreq.msg,

      # Buff response

      s.dpath.buffresp_msg,    s.resp_bypass.enq.msg,
      s.resp_bypass.deq.msg,    s.buffresp.msg,

      # Memory request

      s.dpath.memreq_msg,       s.memreq.msg,

      # Memory response

      s.dpath.memresp_msg,      s.memresp.msg,

    )

    # Ctrl <-> Dpath

    s.connect_auto( s.ctrl, s.dpath )

  def line_trace( s ):

    state = s.ctrl.state_reg

    if   state == s.ctrl.STATE_IDLE:           state_str = "(I )"
    elif state == s.ctrl.STATE_TAG_CHECK:      state_str = "(TC)"
    elif state == s.ctrl.STATE_REFILL_REQUEST: state_str = "(RR)"
    elif state == s.ctrl.STATE_REFILL_WAIT:    state_str = "(RW)"
    elif state == s.ctrl.STATE_WAIT_HIT:       state_str = "(W )"
    elif state == s.ctrl.STATE_WAIT_MISS:      state_str = "(W )"
    else :                                     state_str = "(? )"

    return state_str
