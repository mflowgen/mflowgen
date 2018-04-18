#=======================================================================
# TestAsynchSink
#=======================================================================

from copy  import deepcopy
from pymtl import *
from ifcs  import InReqAckBundle

class TestSinkError( Exception ):
  pass

#-----------------------------------------------------------------------
# TestAsynchSink
#-----------------------------------------------------------------------

class TestAsynchSink( Model ):

  def __init__( s, dtype, msgs ):

    s.in_  = InReqAckBundle( dtype )
    s.done = OutPort       ( 1     )

    s.msgs = deepcopy( msgs )
    s.idx  = 0

    @s.tick
    def tick():

      # Handle reset

      if s.reset:
        s.in_.ack.next = False
        s.done   .next = False
        return
      else:
        s.in_.ack.next = s.in_.req

      # determine if the input message transaction occured

      in_go = not s.in_.req and s.in_.ack

      # If the input transaction occured, verify that it is what we
      # expected. then increment the index.

      if in_go:
        if s.in_.msg != s.msgs[s.idx]:

          error_msg = """
 The test sink received an incorrect message!
  - sink name    : {sink_name}
  - msg number   : {msg_number}
  - expected msg : {expected_msg}
  - actual msg   : {actual_msg}
"""

          raise TestSinkError( error_msg.format(
            sink_name    = s.name,
            msg_number   = s.idx,
            expected_msg = s.msgs[s.idx],
            actual_msg   = s.in_.msg,
          ))

        s.idx = s.idx + 1

      # Set the ready and done signals.

      if ( s.idx < len(s.msgs) ):
        s.done   .next = False
      else:
        s.done   .next = True


  def line_trace( s ):
    return "{}".format( s.in_ )

