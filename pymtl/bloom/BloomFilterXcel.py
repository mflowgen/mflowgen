#=========================================================================
# BloomFilterXcel.py
#=========================================================================
# A wrapper around a BloomFilter and supports the accelerator interface.

from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle
from pclib.rtl    import NormalQueue, RegRst
from proc.XcelMsg import XcelReqMsg, XcelRespMsg
from BloomFilter  import BloomFilterMsg, BloomFilterParallel

# BRGTC2 custom MemMsg modified for RISC-V 32

#from ifcs import MemMsg4B
from ifcs.MemMsg import MemReqMsg4B

class BloomFilterXcel( Model ):

  # Constructor

  def __init__( s, snoop_mem_msg=MemReqMsg4B(), csr_begin=128,
                num_bits_exponent=8, num_hash_funs=3 ):

    # CSR offsets for accelerator registers

    s.CSR_OFFSET_STATUS    = 0
    s.CSR_OFFSET_CHECK_VAL = 1
    s.CSR_OFFSET_CHECK_RES = 2
    s.CSR_OFFSET_CLEAR     = 3

    # Status register

    s.STATUS_DISABLED   = 0
    s.STATUS_ENABLED_R  = 1
    s.STATUS_ENABLED_W  = 2
    s.STATUS_ENABLED_RW = 3
    s.STATUS_EXCEPTION  = 4

    # Check value register

    s.CHECK_VALUE_DONE = 0

    # Check result register. Yes = BF (might) contain this value. No = BF
    # (definitely) doesn't contain this value. Invalid = Check result
    # isn't complete yet. Note that reading the check result register
    # clears its state.

    s.CHECK_RESULT_INV  = 0
    s.CHECK_RESULT_YES  = 1
    s.CHECK_RESULT_NO   = 2

    # Clear register

    s.CLEAR_DONE      = 0
    s.CLEAR_REQUESTED = 1

    # Interface

    bloom_msg = BloomFilterMsg( snoop_mem_msg.addr.nbits )

    # Processor ports

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    # Snoop port for dcache requests

    s.memreq_snoop    = InValRdyBundle ( snoop_mem_msg  )

    # Queues

    s.xcelreq_q = NormalQueue( 2, XcelReqMsg() )
    s.bloomreq_q = NormalQueue( 2, bloom_msg )
    # Note: we're using a 3-element queue to support some buffering when
    # there are streaming requests from the snoop port and we want to
    # check one value.
    s.snoop_q = NormalQueue( 3, snoop_mem_msg.addr.nbits )

    # Accelerator registers

    s.status    = RegRst( 32, reset_value=s.STATUS_DISABLED  )
    s.check_val = RegRst( 32, reset_value=s.CHECK_VALUE_DONE )
    s.check_res = RegRst( 32, reset_value=s.CHECK_RESULT_INV )
    s.clear     = RegRst( 32, reset_value=s.CLEAR_DONE       )

    # The bloom filter

    s.bloom_filter = BloomFilterParallel( num_bits_exponent,
                                          num_hash_funs,
                                          bloom_msg )

    s.connect( s.bloom_filter.in_, s.bloomreq_q.deq )

    @s.combinational
    def comb():
      s.status.in_.value = s.status.out
      s.check_val.in_.value = s.check_val.out
      s.check_res.in_.value = s.check_res.out
      s.clear.in_.value = s.clear.out
      s.xcelresp.msg.data.value = 0
      s.bloomreq_q.enq.val.value = 0
      s.bloomreq_q.enq.msg.value = 0
      s.snoop_q.deq.rdy.value = 0
      s.snoop_q.enq.val.value = 0
      s.snoop_q.enq.msg.value = 0
      s.bloom_filter.check_out.rdy.value = 1

      # Enqueueing the Bloom Request Queue

      if s.bloomreq_q.enq.rdy:
        if s.clear.out == s.CLEAR_REQUESTED:
          s.bloomreq_q.enq.val.value = 1
          s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_CLEAR
          s.bloomreq_q.enq.msg.word.value = 0
          s.clear.in_.value = s.CLEAR_DONE

        elif s.check_val.out != s.CHECK_VALUE_DONE:
          s.bloomreq_q.enq.val.value = 1
          s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_CHECK
          s.bloomreq_q.enq.msg.word.value = s.check_val.out
          s.check_val.in_.value = s.CHECK_VALUE_DONE

        elif s.snoop_q.deq.val:
          s.bloomreq_q.enq.val.value = 1
          s.snoop_q.deq.rdy.value = 1
          s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_INSERT
          s.bloomreq_q.enq.msg.word.value = s.snoop_q.deq.msg

      # Enqueueing the Snoop Queue

      # XXX: memreq_snoop.val should be tied to memreq.val AND memreq.rdy
      if s.memreq_snoop.val:

        # Filter out the memory requests based on the status we're in.
        if ( (s.status.out == s.STATUS_ENABLED_R and
              s.memreq_snoop.msg.type_ == snoop_mem_msg.TYPE_READ) or
             (s.status.out == s.STATUS_ENABLED_W and
              s.memreq_snoop.msg.type_ != snoop_mem_msg.TYPE_READ) or
             s.status.out == s.STATUS_ENABLED_RW ):
          s.snoop_q.enq.val.value = 1
          s.snoop_q.enq.msg.value = s.memreq_snoop.msg.addr

          if not s.snoop_q.enq.rdy:
            # We can't put the item to the snoop q, so we need to throw
            # an exception!
            s.status.in_.value = s.STATUS_EXCEPTION

      # Check value

      if s.bloom_filter.check_out.val:
        if s.bloom_filter.check_out.msg == 1:
          s.check_res.in_.value = s.CHECK_RESULT_YES
        else:
          s.check_res.in_.value = s.CHECK_RESULT_NO

      # Accelerator register access. Note that this is at the bottom of
      # the combinational block to ensure the writes to the registers are
      # prioritized from the processor side.

      if s.xcelreq_q.deq.val and s.xcelreq_q.deq.rdy:
        if s.xcelreq_q.deq.msg.type_ == XcelReqMsg.TYPE_WRITE:

          if s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_STATUS:
            s.status.in_.value = s.xcelreq_q.deq.msg.data

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_VAL:
            s.check_val.in_.value = s.xcelreq_q.deq.msg.data

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_RES:
            s.check_res.in_.value = s.xcelreq_q.deq.msg.data

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CLEAR:
            s.clear.in_.value = s.xcelreq_q.deq.msg.data

        else:  # TYPE_READ

          if s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_STATUS:
            s.xcelresp.msg.data.value = s.status.out

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_VAL:
            s.xcelresp.msg.data.value = s.check_val.out

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_RES:
            s.xcelresp.msg.data.value = s.check_res.out

            # If the check result is available, reset the check result so
            # that the processor doesn't have to reset it.

            if s.check_res.out != s.CHECK_RESULT_INV:
              s.check_res.in_.value = s.CHECK_RESULT_INV

          elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CLEAR:
            s.xcelresp.msg.data.value = s.clear.out


    # Direct connections for xcelreq/xcelresp

    s.connect( s.snoop_q.enq.msg, s.memreq_snoop.msg.addr )
    s.connect( s.xcelreq, s.xcelreq_q.enq )
    s.connect( s.xcelreq_q.deq.msg.type_, s.xcelresp.msg.type_ )
    s.connect( s.xcelreq_q.deq.val,       s.xcelresp.val       )
    s.connect( s.xcelreq_q.deq.rdy,       s.xcelresp.rdy       )

    # Tie the ready to 1 since this unit only snoops. Also externally, the
    # AND of the val and rdy ports should be tied to memreq_snoop.val.
    s.connect( s.memreq_snoop.rdy, 1 )

  # Line tracing

  def line_trace( s ):
    #return "{}(){}".format( s.xcelreq, s.xcelresp )
    return "s:{} v:{} r:{} c:{}|{}|{}|{}|{}".format(
        s.status.out[0:4], s.check_val.out, s.check_res.out[0:4], s.clear.out[0:4],
        s.xcelreq_q.line_trace(),
        s.snoop_q.line_trace(), s.bloomreq_q.line_trace(),
        s.bloom_filter.line_trace() )

