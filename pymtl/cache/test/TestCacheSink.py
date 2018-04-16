#=========================================================================
# TestCacheSink.py
#=========================================================================

from pymtl      import *
from pclib.test import TestRandomDelay
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from pclib.ifcs import MemRespMsg

#-----------------------------------------------------------------------
# TestSimpleCacheSink
#-----------------------------------------------------------------------

class TestSimpleCacheSink( Model ):

  def __init__( s, dtype, msgs, check_test = True ):

    s.in_  = InValRdyBundle( dtype )
    s.done = OutPort       ( 1     )

    s.msgs = msgs
    s.idx  = 0

    @s.tick
    def tick():

      # Handle reset

      if s.reset:
        s.in_.rdy.next = False
        s.done   .next = False
        return

      # At the end of the cycle, we AND together the val/rdy bits to
      # determine if the input message transaction occured

      in_go = s.in_.val and s.in_.rdy

      # If the input transaction occured, verify that it is what we
      # expected. then increment the index.

      check = False

      if in_go:
        # if memresp is a write, ignore the data
        if   s.in_.msg.type_ == MemRespMsg.TYPE_WRITE:
          assert   s.in_.msg.opaque == s.msgs[s.idx].opaque
        elif s.in_.msg.type_ == MemRespMsg.TYPE_WRITE_INIT:
          assert   s.in_.msg.opaque == s.msgs[s.idx].opaque
        else:
          assert ( s.in_.msg.opaque == s.msgs[s.idx].opaque and
                    s.in_.msg.data  == s.msgs[s.idx].data )

        # check test field
        if check_test:
          if s.msgs[s.idx].test != 2:
            assert   s.in_.msg.test == s.msgs[s.idx].test

        # assert s.in_.msg == s.msgs[s.idx]
        s.idx = s.idx + 1

      # Set the ready and done signals.

      if ( s.idx < len(s.msgs) ):
        s.in_.rdy.next = True
        s.done   .next = False
      else:
        s.in_.rdy.next = False
        s.done   .next = True


  def line_trace( s ):

    return "{} ({:2})".format( s.in_, s.idx )

#-------------------------------------------------------------------------
# TestSink
#-------------------------------------------------------------------------

class TestCacheSink( Model ):

  def __init__( s, dtype, msgs, max_random_delay = 0, check_test = True ):

    s.in_  = InValRdyBundle( dtype )
    s.done = OutPort       ( 1     )

    # Instantiate modules

    s.delay = TestRandomDelay( dtype, max_random_delay )
    s.sink  = TestSimpleCacheSink( dtype, msgs, check_test )

    # Connect the input ports -> random delay -> sink

    s.connect( s.in_,       s.delay.in_ )
    s.connect( s.delay.out, s.sink.in_  )

    # Connect test sink done signal to output port

    s.connect( s.sink.done, s.done )

  def line_trace( s ):

    return "{}".format( s.in_ )
