#=========================================================================
# Sort Unit FL Model
#=========================================================================
# Sort array in memory containing positive integers.
# Accelerator register interface:
#
#  xr0 : go/done
#  xr1 : base address of array
#  xr2 : number of elements in array
#
# Accelerator protocol involves the following steps:
#  1. Write the base address of array via xr1
#  2. Write the number of elements in array via xr2
#  3. Tell accelerator to go by writing xr0
#  4. Wait for accelerator to finish by reading xr0, result will be 1
#

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg
from pclib.fl   import InValRdyQueueAdapter, OutValRdyQueueAdapter
from pclib.fl   import ListMemPortAdapter

from XcelMsg    import XcelReqMsg, XcelRespMsg

class SortXcelFL( Model ):

  # Constructor

  def __init__( s, mem_ifc_types=MemMsg(4,32,32) ):

    # Interface

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    s.memreq    = OutValRdyBundle ( mem_ifc_types.req  )
    s.memresp   = InValRdyBundle  ( mem_ifc_types.resp )

    # Adapters

    s.xcelreq_q  = InValRdyQueueAdapter  ( s.xcelreq  )
    s.xcelresp_q = OutValRdyQueueAdapter ( s.xcelresp )

    s.data       = ListMemPortAdapter( s.memreq, s.memresp )

    # Concurrent block

    @s.tick_fl
    def block():

      # We loop handling accelerator requests. We are only expecting
      # writes to xr0-2, so any other requests are an error. We exit the
      # loop when we see the write to xr0.

      go = False
      while not go:

        xcelreq_msg = s.xcelreq_q.popleft()

        # Only expecting writes to xr0-2, so any other request is an xcel
        # protocol error.

        assert xcelreq_msg.type_ == XcelReqMsg.TYPE_WRITE, \
          "Only reg writes allowed during setup!"

        assert xcelreq_msg.raddr in [0,1,2], \
          "Only reg writes to 0,1,2 allowed during setup!"

        # Use xcel register address to configure accelerator

        if   xcelreq_msg.raddr == 0: go = True
        elif xcelreq_msg.raddr == 1: s.data.set_base( xcelreq_msg.data )
        elif xcelreq_msg.raddr == 2: s.data.set_size( xcelreq_msg.data )

        # Send xcel response message

        xcelresp_msg = XcelRespMsg()
        xcelresp_msg.type_ = XcelRespMsg.TYPE_WRITE
        s.xcelresp_q.append( xcelresp_msg )

      # Now that we have setup the list memory port adapter, we can use
      # the data as a standard Python list. The adapter handles turning
      # reads and writes to the list into the corresponding read/write
      # memory requests, and also waiting for the responses. So we first
      # create a sorted version of the list ...

      data_sorted = sorted(s.data)

      # And then we copy the result out to memory

      for i in xrange(len(data_sorted)):
        s.data[i] = data_sorted[i]

      # Now wait for read of xr0

      xcelmsg = s.xcelreq_q.popleft()

      # Only expecting read from xr0, so any other request is an xcel
      # protocol error.

      assert xcelreq_msg.type_ == XcelReqMsg.TYPE_READ, \
        "Only reg reads allowed during done phase!"

      assert xcelreq_msg.raddr == 0, \
        "Only reg writes to 0,1,2 allowed during done phase!"

      # Send xcel response message indicating xcel is done

      xcelresp_msg = XcelRespMsg()
      xcelresp_msg.type_ = XcelRespMsg.TYPE_READ
      xcelresp_msg.data  = 1
      s.xcelresp_q.append( xcelresp_msg )

  # Line tracing

  def line_trace( s ):
    return "{}({}){}".format( s.xcelreq, s.data.line_trace(), s.xcelresp )

