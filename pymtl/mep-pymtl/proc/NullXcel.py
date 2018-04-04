#=========================================================================
# Null Accelerator Model
#=========================================================================
# This is an empty accelerator model. It includes a single 32-bit
# register named xr0 for testing purposes. It includes a memory
# interface, but this memory interface is not used. The model is
# synthesizable and can be combined with an processor RTL model.
#
# Here is a simple figure of the basic idea for the NullXcel.
#
#   --.                   .-.
#   q || deq.msg.data  -->|R|--> xcelresp.data
#   u || deq.msg.raddr    '^'
#   e || deq.msg.type_ --------> xcelresp.type_
#   u || deq.val --------------> xcelresp.val
#   e || deq.rdy <-------------- xcelresp.rdy
#   --'
#
# We use a two-input normal queue to buffer up the xcelreq. This
# eliminates any combinational loops when composing the accelerator with
# the processor. We combinationally connect the val/rdy from the dequeue
# interface of the xcelreq queue to the xcelresp interface. Essentially,
# an xcelreq is buffered up and waits in the queue until the xcelresp
# interface is ready to accept it.
#
# We directly connect the data from an xcelreq to the input of the xr0
# register, and ideally we would directly connect the output of the xr0
# register to the data of an xcelresp; this would work fine because there
# is only a single accelerator register. So if we are reading or writing
# an accelerator register it must be that one. There is one catch though.
# We don't really have wildcards in our test sources, so it is easier if
# we force the xcelresp data to zero on a write. So we have a little bit
# of muxing to do this.
#
# The final part is that we need to figure out when to set the enable on
# the xr0 register. This register is enabled when the transaction at the
# head of the xcelreq queue is a write and when the xcelresp interface is
# both valid and ready (i.e., the transaction is actually going to take
# place).
#

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg4B
from pclib.rtl  import NormalQueue, RegEn

from xcel.XcelMsg  import XcelReqMsg, XcelRespMsg

class NullXcel( Model ):

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

