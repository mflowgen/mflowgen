#=========================================================================
# BlockingCacheWideAccessPRTL.py
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg4B, MemRespMsg4B
from ifcs import MemReqMsg16B, MemRespMsg16B

from pclib.rtl.queues import SingleElementBypassQueue

from BlockingCacheWideAccessCtrlPRTL  import BlockingCacheWideAccessCtrlPRTL
from BlockingCacheWideAccessDpathPRTL import BlockingCacheWideAccessDpathPRTL

# Note on num_banks:
# In a multi-banked cache design, cache lines are interleaved to
# different cache banks, so that consecutive cache lines correspond to a
# different bank. The following is the addressing structure in our
# four-banked data caches:
#
# +--------------------------+--------------+--------+--------+--------+
# |        22b               |     4b       |   2b   |   2b   |   2b   |
# |        tag               |   index      |bank idx| offset | subwd  |
# +--------------------------+--------------+--------+--------+--------+
#
# In this lab you don't have to consider multi-banked cache design. We
# will compose four-banked cache in lab5 multi-core lab. You can modify
# your cache to multi-banked by slightly modifying the address structure.
# For now you can simply assume num_banks == 0.

class BlockingCacheWideAccessPRTL( Model ):

  def __init__( s, num_banks = 0, CacheReqType  = MemReqMsg16B  ,
                                  CacheRespType = MemRespMsg16B ):

    if num_banks <= 0:
      idx_shamt = 0
    else:
      idx_shamt = clog2( num_banks )

    # Proc <-> Cache

    s.cachereq  = InValRdyBundle ( CacheReqType  )
    s.cacheresp = OutValRdyBundle( CacheRespType )

    # Cache <-> Mem

    s.memreq    = OutValRdyBundle( MemReqMsg16B  )
    s.memresp   = InValRdyBundle ( MemRespMsg16B )

    s.ctrl      = BlockingCacheWideAccessCtrlPRTL ( idx_shamt, CacheReqType  ,
                                                     CacheRespType )
    s.dpath     = BlockingCacheWideAccessDpathPRTL( idx_shamt, CacheReqType  ,
                                                     CacheRespType )

    # Bypass Queue for buffering response

    s.resp_bypass = SingleElementBypassQueue( MemRespMsg16B )

    # Control

    s.connect_pairs(

      # Cache request

      s.ctrl.cachereq_val,      s.cachereq.val,
      s.ctrl.cachereq_rdy,      s.cachereq.rdy,

      # Cache response

      s.ctrl.cacheresp_val,     s.resp_bypass.enq.val,
      s.ctrl.cacheresp_rdy,     s.resp_bypass.enq.rdy,

      s.resp_bypass.deq.val,    s.cacheresp.val,
      s.resp_bypass.deq.rdy,    s.cacheresp.rdy,

      # Memory request

      s.ctrl.memreq_val,        s.memreq.val,
      s.ctrl.memreq_rdy,        s.memreq.rdy,

      # Memory response

      s.ctrl.memresp_val,       s.memresp.val,
      s.ctrl.memresp_rdy,       s.memresp.rdy,

    )

    # Dpath

    s.connect_pairs(

      # Cache request

      s.dpath.cachereq_msg,     s.cachereq.msg,

      # Cache response

      s.dpath.cacheresp_msg,    s.resp_bypass.enq.msg,
      s.resp_bypass.deq.msg,    s.cacheresp.msg,

      # Memory request

      s.dpath.memreq_msg,       s.memreq.msg,

      # Memory response

      s.dpath.memresp_msg,      s.memresp.msg,

    )

    # Ctrl <-> Dpath

    s.connect_auto( s.ctrl, s.dpath )

    #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

  def line_trace( s ):

    #: return ""

    #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    # LAB TASK: Create line tracing
    #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

    state = s.ctrl.state_reg

    if   state == s.ctrl.STATE_IDLE:                        state_str = "(I )"
    elif state == s.ctrl.STATE_TAG_CHECK:                   state_str = "(TC)"
    elif state == s.ctrl.STATE_WRITE_CACHE_RESP_HIT:        state_str = "(WR)"
    elif state == s.ctrl.STATE_WRITE_DATA_ACCESS_HIT:       state_str = "(WD)"
    elif state == s.ctrl.STATE_READ_DATA_ACCESS_MISS:       state_str = "(RD)"
    elif state == s.ctrl.STATE_WRITE_DATA_ACCESS_MISS:      state_str = "(WD)"
    elif state == s.ctrl.STATE_INIT_DATA_ACCESS:            state_str = "(IN)"
    elif state == s.ctrl.STATE_REFILL_REQUEST:              state_str = "(RR)"
    elif state == s.ctrl.STATE_REFILL_WAIT:                 state_str = "(RW)"
    elif state == s.ctrl.STATE_REFILL_UPDATE:               state_str = "(RU)"
    elif state == s.ctrl.STATE_EVICT_PREPARE:               state_str = "(EP)"
    elif state == s.ctrl.STATE_EVICT_REQUEST:               state_str = "(ER)"
    elif state == s.ctrl.STATE_EVICT_WAIT:                  state_str = "(EW)"
    elif state == s.ctrl.STATE_WAIT_HIT:                    state_str = "(W )"
    elif state == s.ctrl.STATE_WAIT_MISS:                   state_str = "(W )"
    else :                                                  state_str = "(? )"

    return state_str

    #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

