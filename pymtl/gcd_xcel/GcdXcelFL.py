#=========================================================================
# Gcd Unit FL Model
#=========================================================================
# Computes the Gcd of two numbers
# Accelerator register interface:
#
#  xr0 : go/result
#  xr1 : operand A
#  xr2 : operand B
#
# Accelerator protocol involves the following steps:
#  1. Write the operand A by writing to xr1
#  2. Write the operand B by writing to xr2
#  3. Tell the accelerator to compute gcd and wait for result by reading
#     xr0

from fractions  import gcd

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.fl   import InValRdyQueueAdapter, OutValRdyQueueAdapter

from xcel.XcelMsg  import XcelReqMsg, XcelRespMsg

class GcdXcelFL( Model ):

  # Constructor

  def __init__( s ):

    # Interface

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    # Adapters

    s.xcelreq_q  = InValRdyQueueAdapter  ( s.xcelreq  )
    s.xcelresp_q = OutValRdyQueueAdapter ( s.xcelresp )

    # Internal State

    s.operandA = 0
    s.operandB = 0
    s.result   = 0

    # Concurrent block

    @s.tick_fl
    def block():

      go = False
      while not go:

        xcelreq_msg = s.xcelreq_q.popleft()

        if xcelreq_msg.type_ == XcelReqMsg.TYPE_WRITE:

          assert  xcelreq_msg.raddr in [1,2], \
            "Only reg writes to 1,2 allowed during setup!"

          # Use xcel register address to configure accelerator

          if   xcelreq_msg.raddr == 1: s.operandA = xcelreq_msg.data
          elif xcelreq_msg.raddr == 2: s.operandB = xcelreq_msg.data

          # Send xcel response message

          xcelresp_msg        = XcelRespMsg()
          xcelresp_msg.opaque = xcelreq_msg.opaque
          xcelresp_msg.type_  = XcelRespMsg.TYPE_WRITE
          s.xcelresp_q.append( xcelresp_msg )

        elif xcelreq_msg.type_ == XcelReqMsg.TYPE_READ:

          assert  xcelreq_msg.raddr in [0], \
            "Only reg read to 0 allowed!"

          go = True

      # Compute Gcd of the operands

      s.result = gcd( s.operandA, s.operandB )

      # Send xcel response message indicating xcel is done

      xcelresp_msg        = XcelRespMsg()
      xcelresp_msg.opaque = xcelreq_msg.opaque
      xcelresp_msg.type_  = XcelRespMsg.TYPE_READ
      xcelresp_msg.data   = s.result
      xcelresp_msg.id     = xcelreq_msg.id
      s.xcelresp_q.append( xcelresp_msg )

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.xcelreq, s.xcelresp )

