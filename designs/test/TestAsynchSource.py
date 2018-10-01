#=======================================================================
# TestAsynchSource
#=======================================================================

from pymtl import *
from ifcs  import OutReqAckBundle

#-----------------------------------------------------------------------
# TestAsynchSource
#-----------------------------------------------------------------------
class TestAsynchSource( Model ):
  'Outputs data provided in ``msgs`` onto a val/rdy interface.'

  def __init__( s, dtype, msgs ):

    s.out  = OutReqAckBundle( dtype )
    s.done = OutPort        ( 1     )

    s.msgs = msgs
    s.idx  = 0

    @s.tick
    def tick():

      # Handle reset

      if s.reset:
        if s.msgs:
          s.out.msg.next = s.msgs[0]
        s.out.req  .next = False
        s.done     .next = False
        return

      # Check if we have more messages to send.

      if ( s.idx == len(s.msgs) ):
        if s.msgs:
          s.out.msg.next = s.msgs[0]
        s.out.req  .next = False
        s.done     .next = True
        return

      # determine if the output message transaction occured

      out_go = s.out.req and s.out.ack

      # If the output transaction occured, then increment the index.

      if out_go:
        s.idx = s.idx + 1

      # The output message is always the indexed message in the list, or if
      # we are done then it is the first message again.

      if ( s.idx < len(s.msgs) ):
        s.out.msg.next = s.msgs[s.idx]
        s.out.req.next = ~s.out.ack 
        s.done   .next = False
      else:
        s.out.msg.next = s.msgs[0]
        s.out.req.next = False
        s.done   .next = True

  def line_trace( s ):

    return "{}".format( s.out )

