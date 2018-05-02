#=========================================================================
# BloomFilterXcel.py
#=========================================================================
# A wrapper around a BloomFilter and supports the accelerator interface.

from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle
from pclib.rtl    import NormalQueue, RegEn
from proc.XcelMsg import XcelReqMsg, XcelRespMsg

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg4B

class BloomFilterXcel( Model ):

  # Constructor

  def __init__( s, mem_ifc_types=MemMsg4B() ):

    # Interface

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    s.memreq    = OutValRdyBundle ( mem_ifc_types.req  )
    s.memresp   = InValRdyBundle  ( mem_ifc_types.resp )

    # Queues

    s.xcelreq_q = NormalQueue( 2, XcelReqMsg() )
    s.connect( s.xcelreq, s.xcelreq_q.enq )

    # Single accelerator register

    s.xr0       = RegEn( 32 )

    # Direct connections for xcelreq/xcelresp

    s.connect( s.xcelreq_q.deq.msg.data,  s.xr0.in_            )
    s.connect( s.xcelreq_q.deq.msg.type_, s.xcelresp.msg.type_ )
    s.connect( s.xcelreq_q.deq.val,       s.xcelresp.val       )
    s.connect( s.xcelreq_q.deq.rdy,       s.xcelresp.rdy       )

    # Even though memreq/memresp interface is not hooked up, we still
    # need to set the output ports correctly.

    s.connect( s.memreq.val,  0 )
    s.connect( s.memresp.rdy, 0 )

    # Combinational block

    @s.combinational
    def block():

      # Mux to force xcelresp data to zero on a write

      if s.xcelreq_q.deq.msg.type_ == XcelReqMsg.TYPE_WRITE:
        s.xcelresp.msg.data.value = 0
      else:
        s.xcelresp.msg.data.value = s.xr0.out

      # Logic for register enable

      s.xr0.en.value = (s.xcelreq_q.deq.msg.type_ == XcelReqMsg.TYPE_WRITE) \
                      & s.xcelreq_q.deq.val & s.xcelresp.rdy

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.xcelreq, s.xcelresp )

