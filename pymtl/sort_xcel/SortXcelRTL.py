#=========================================================================
# Sort Unit RTL Model
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

from copy       import deepcopy

from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg, MemReqMsg, MemRespMsg
from pclib.rtl  import SingleElementBypassQueue, SingleElementPipelinedQueue
from pclib.rtl  import Reg

from XcelMsg    import XcelReqMsg, XcelRespMsg

class SortXcelRTL( Model ):

  # Constructor

  def __init__( s, mem_ifc_types=MemMsg(4,32,32) ):

    # Interface

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    s.memreq    = OutValRdyBundle ( mem_ifc_types.req  )
    s.memresp   = InValRdyBundle  ( mem_ifc_types.resp )

    # ''' TODO ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    # Create RTL model for sorting xcel
    # '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

    # Queues

    s.xcelreq_q = SingleElementPipelinedQueue( XcelReqMsg() )
    s.connect( s.xcelreq, s.xcelreq_q.enq )

    s.memreq_q = SingleElementBypassQueue( MemReqMsg(4,32,32) )
    s.connect( s.memreq, s.memreq_q.deq )

    s.memresp_q = SingleElementPipelinedQueue( MemRespMsg(4,32) )
    s.connect( s.memresp, s.memresp_q.enq )

    # Internal state

    s.base_addr   = Reg( 32 )
    s.size        = Reg( 32 )
    s.inner_count = Reg( 32 )
    s.outer_count = Reg( 32 )
    s.a           = Reg( 32 )

    # Line tracing

    s.prev_state = 0
    s.xcfg_trace = "  "

    # Helpers to make memory read/write requests

    s.mk_rd = mem_ifc_types.req.mk_rd
    s.mk_wr = mem_ifc_types.req.mk_wr

    #=====================================================================
    # State Update
    #=====================================================================

    s.STATE_XCFG    = 0
    s.STATE_FIRST0  = 1
    s.STATE_FIRST1  = 2
    s.STATE_BUBBLE0 = 3
    s.STATE_BUBBLE1 = 4
    s.STATE_LAST    = 5

    s.state         = Wire(8)

    s.go = Wire(1)

    @s.tick_rtl
    def block0():

      if s.reset:
        s.state.next = s.STATE_XCFG
      else:
        s.state.next = s.state

        if s.state == s.STATE_XCFG:
          if s.go & s.xcelresp.val & s.xcelresp.rdy:
            s.state.next = s.STATE_FIRST0

        elif s.state == s.STATE_FIRST0:
          if s.memreq_q.enq.rdy:
            s.state.next = s.STATE_FIRST1

        elif s.state == s.STATE_FIRST1:
          if s.memreq_q.enq.rdy and s.memresp_q.deq.rdy:
            s.state.next = s.STATE_BUBBLE0

        elif s.state == s.STATE_BUBBLE0:
          if s.memreq_q.enq.rdy and s.memresp_q.deq.rdy:
            s.state.next = s.STATE_BUBBLE1

        elif s.state == s.STATE_BUBBLE1:
          if s.memreq_q.enq.rdy and s.memresp_q.deq.rdy:
            if s.inner_count.out+1 < s.size.out:
              s.state.next = s.STATE_BUBBLE0
            else:
              s.state.next = s.STATE_LAST

        elif s.state == s.STATE_LAST:
          if s.memreq_q.enq.rdy and s.memresp_q.deq.rdy:
            if s.outer_count.out+1 < s.size.out:
              s.state.next = s.STATE_FIRST1
            else:
              s.state.next = s.STATE_XCFG

    #=====================================================================
    # State Outputs
    #=====================================================================

    @s.combinational
    def block1():

      s.xcelreq_q.deq.rdy.value = 0
      s.xcelresp.val.value      = 0
      s.memreq_q.enq.val.value  = 0
      s.memresp_q.deq.rdy.value = 0
      s.go.value                = 0

      s.outer_count.in_.value   = s.outer_count.out
      s.inner_count.in_.value   = s.inner_count.out

      #-------------------------------------------------------------------
      # STATE: XCFG
      #-------------------------------------------------------------------

      if s.state == s.STATE_XCFG:
        s.xcelreq_q.deq.rdy.value = s.xcelresp.rdy
        s.xcelresp.val.value = s.xcelreq_q.deq.val

        if s.xcelreq_q.deq.val:

          if s.xcelreq_q.deq.msg.type_ == XcelReqMsg.TYPE_WRITE:

            if   s.xcelreq_q.deq.msg.raddr == 0:
              s.outer_count.in_.value = 0
              s.go.value          = 1

            elif s.xcelreq_q.deq.msg.raddr == 1:
              s.base_addr.in_.value = s.xcelreq_q.deq.msg.data

            elif s.xcelreq_q.deq.msg.raddr == 2:
              s.size.in_.value = s.xcelreq_q.deq.msg.data

            # Send xcel response message

            s.xcelresp.msg.type_.value = XcelRespMsg.TYPE_WRITE

          else:

            # Send xcel response message, obviously you only want to
            # send the response message when accelerator is done

            s.xcelresp.msg.type_.value = XcelRespMsg.TYPE_READ
            s.xcelresp.msg.data.value  = 1

      #-------------------------------------------------------------------
      # STATE: FIRST0
      #-------------------------------------------------------------------
      # Send the first memory read request for the very first
      # element in the array.

      elif s.state == s.STATE_FIRST0:
        if s.memreq_q.enq.rdy:

          s.memreq_q.enq.val.value = 1
          s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_READ
          s.memreq_q.enq.msg.addr.value  = s.base_addr.out + 4*s.inner_count.out
          s.memreq_q.enq.msg.len.value   = 0

          s.inner_count.in_.value = 1

      #-------------------------------------------------------------------
      # STATE: FIRST1
      #-------------------------------------------------------------------
      # Wait for the memory response for the first element in the array,
      # and once it arrives store this element in a, and send the memory
      # read request for the second element.

      elif s.state == s.STATE_FIRST1:
        if s.memreq_q.enq.rdy and s.memresp_q.deq.val:
          s.memresp_q.deq.rdy.value = 1
          s.a.in_.value = s.memresp_q.deq.msg.data

          s.memreq_q.enq.val.value = 1
          s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_READ
          s.memreq_q.enq.msg.addr.value  = s.base_addr.out + 4*s.inner_count.out
          s.memreq_q.enq.msg.len.value   = 0

      #-------------------------------------------------------------------
      # STATE: BUBBLE0
      #-------------------------------------------------------------------
      # Wait for the memory read response to get the next element,
      # compare the new value to the previous max value, update b with
      # the new max value, and send a memory request to store the new min
      # value. Notice how we decrement the write address by four since we
      # want to store to the new min value _previous_ element.

      elif s.state == s.STATE_BUBBLE0:
        if s.memreq_q.enq.rdy and s.memresp_q.deq.val:
          s.memresp_q.deq.rdy.value = 1

          if s.a.out > s.memresp_q.deq.msg:
            s.a.in_.value = s.a.out
            s.memreq_q.enq.msg.data.value = s.memresp_q.deq.msg
          else:
            s.a.in_.value = s.memresp_q.deq.msg
            s.memreq_q.enq.msg.data.value = s.a.out

          s.memreq_q.enq.val.value = 1
          s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_WRITE
          s.memreq_q.enq.msg.addr.value  = (s.base_addr.out + 4*(s.inner_count.out-1))
          s.memreq_q.enq.msg.len.value   = 0

      #-------------------------------------------------------------------
      # STATE: BUBBLE1
      #-------------------------------------------------------------------
      # Wait for the memory write response, and then check to see if we
      # have reached the end of the array. If we have not reached the end
      # of the array, then make a new memory read request for the next
      # element; if we have reached the end of the array, then make a
      # final write request (with value from a) to update the final
      # element in the array.

      elif s.state == s.STATE_BUBBLE1:
        if s.memreq_q.enq.rdy and s.memresp_q.deq.val:
          s.memresp_q.deq.rdy.value = 1

          s.inner_count.in_.value = s.inner_count.out + 1
          if s.inner_count.out+1 < s.size.out:

            s.memreq_q.enq.val.value = 1
            s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_READ
            s.memreq_q.enq.msg.addr.value  = s.base_addr.out + 4*(s.inner_count.out+1)
            s.memreq_q.enq.msg.len.value   = 0

          else:

            s.memreq_q.enq.val.value = 1
            s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_WRITE
            s.memreq_q.enq.msg.addr.value  = (s.base_addr.out + 4*(s.inner_count.out))
            s.memreq_q.enq.msg.len.value   = 0
            s.memreq_q.enq.msg.data.value  = s.a.out

      #-------------------------------------------------------------------
      # STATE: LAST
      #-------------------------------------------------------------------
      # Wait for the last response, and then check to see if we need to
      # go through the array again. If we do need to go through array
      # again, then make a new memory read request for the very first
      # element in the array; if we do not need to go through the array
      # again, then we are all done and we can go back to accelerator
      # configuration.

      elif s.state == s.STATE_LAST:
        if s.memreq_q.enq.rdy and s.memresp_q.deq.val:
          s.memresp_q.deq.rdy.value = 1

          s.outer_count.in_.value = s.outer_count.out + 1
          if s.outer_count.out+1 < s.size.out:

            s.memreq_q.enq.val.value = 1
            s.memreq_q.enq.msg.type_.value = MemReqMsg.TYPE_READ
            s.memreq_q.enq.msg.addr.value  = s.base_addr.out
            s.memreq_q.enq.msg.len.value   = 0

            s.inner_count.in_.value = 1
    # '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

  # Line tracing

  def line_trace( s ):

    s.trace = ""

    # ''' TODO ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    # Define line trace here.
    # '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
    
    state2char = {
      s.STATE_XCFG    : "X ",
      s.STATE_FIRST0  : "F0",
      s.STATE_FIRST1  : "F1",
      s.STATE_BUBBLE0 : "B0",
      s.STATE_BUBBLE1 : "B1",
      s.STATE_LAST    : "L ",
    }

    s.state_str = state2char[s.state.uint()]

    s.trace = "({:2}:{:2}:{})".format(
      s.outer_count.out, s.inner_count.out,
      s.state_str
    )

    # '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

    return s.trace

