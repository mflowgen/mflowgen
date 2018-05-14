#=========================================================================
# InstBuffer.py
#=========================================================================
# This InstBuffer wraps around DirectMappedInstBuffer and provides the
# ability to bypass the DirectMappedInstBuffer if the input bit from host
# is set.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg, MemRespMsg

from pclib.rtl.queues import SingleElementBypassQueue

from DirectMappedInstBuffer  import DirectMappedInstBuffer

class InstBuffer( Model ):

  def __init__( s, num_entries, line_nbytes ):

    s.explicit_modulename = "InstBuffer_{}_{}B".format( num_entries, line_nbytes)

    opaque_nbits = 8
    data_nbits   = 32
    addr_nbits   = 32
    data_len     = addr_nbits / 8
    line_nbits   = line_nbytes * 8

    zero_nbits   = line_nbits - addr_nbits

    # Host input bit

    s.L0_disable = InPort( 1 )

    # Proc side

    s.buffreq  = InValRdyBundle ( MemReqMsg(opaque_nbits, addr_nbits, data_nbits) )
    s.buffresp = OutValRdyBundle( MemRespMsg(opaque_nbits, data_nbits)  )

    # Mem side

    s.memreq   = OutValRdyBundle( MemReqMsg(opaque_nbits, addr_nbits, line_nbits) )
    s.memresp  = InValRdyBundle ( MemRespMsg(opaque_nbits, line_nbits) )

    s.inner = DirectMappedInstBuffer( num_entries, line_nbytes )

    @s.combinational
    def comb_proc_side():

      if s.L0_disable: # host turns the l0 off, proc <-> mem

        # Mute inner.buffreq
        s.inner.buffreq.val.value  = 0
        s.inner.buffreq.msg.value  = 0

        # Mute inner.buffresp
        s.inner.buffresp.rdy.value = 0

        # Mute inner.memreq
        s.inner.memreq.rdy.value   = 0

        # Mute inner.memresp
        s.inner.memresp.val.value  = 0
        s.inner.memresp.msg.value  = 0

        # memreq <- buffreq
        s.memreq.val.value         = s.buffreq.val

        s.memreq.msg.type_.value   = s.buffreq.msg.type_
        s.memreq.msg.opaque.value  = s.buffreq.msg.opaque
        s.memreq.msg.addr.value    = s.buffreq.msg.addr
        s.memreq.msg.len.value     = data_len
        s.memreq.msg.data.value    = concat( Bits(zero_nbits, 0), s.buffreq.msg.data )

        s.buffreq.rdy.value        = s.memreq.rdy

        # buffresp <- memresp
        s.buffresp.val.value        = s.memresp.val

        s.buffresp.msg.type_.value  = s.memresp.msg.type_
        s.buffresp.msg.opaque.value = s.memresp.msg.opaque
        s.buffresp.msg.test.value   = s.memresp.msg.test
        s.buffresp.msg.len.value    = 0
        s.buffresp.msg.data.value   = s.memresp.msg[0:data_nbits]

        s.memresp.rdy.value         = s.buffresp.rdy

      else: # otherwise proc <-> inner <-> mem

        # inner.buffreq <- buffreq
        s.inner.buffreq.val.value  = s.buffreq.val
        s.inner.buffreq.msg.value  = s.buffreq.msg
        s.buffreq.rdy.value        = s.inner.buffreq.rdy

        # buffresp <- inner.buffresp
        s.buffresp.val.value       = s.inner.buffresp.val
        s.buffresp.msg.value       = s.inner.buffresp.msg
        s.inner.buffresp.rdy.value = s.buffresp.rdy

        # memreq <- inner.memreq
        s.memreq.val.value         = s.inner.memreq.val
        s.memreq.msg.value         = s.inner.memreq.msg
        s.inner.memreq.rdy.value   = s.memreq.rdy

        # inner.memresp <- memresp
        s.inner.memresp.val.value  = s.memresp.val
        s.inner.memresp.msg.value  = s.memresp.msg
        s.memresp.rdy.value        = s.inner.memresp.rdy

  def line_trace( s ):
    if s.L0_disable:  return "(--)"
    return s.inner.line_trace()

