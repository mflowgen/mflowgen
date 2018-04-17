#=========================================================================
# TestNetCacheSink.py
#=========================================================================

from copy       import deepcopy

from pymtl      import *
from pclib.test import TestRandomDelay
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from pclib.ifcs import MemRespMsg

#-----------------------------------------------------------------------
# TestSimpleNetCacheSink
#-----------------------------------------------------------------------
# Ignore test field and wr data field

class TestSimpleNetCacheSink( Model ):

  def __init__( s, dtype, msgs ):

    s.in_  = InValRdyBundle( dtype )
    s.done = OutPort       ( 1     )

    s.msgs     = deepcopy(msgs)
    s.recv     = []
    s.idx      = 0
    s.msgs_len = len( msgs )

    def equal( a, b ): # return True if equal
      if a.type_ != b.type_:
        return False
      # if memresp is a write, ignore the data
      if   a.type_ == MemRespMsg.TYPE_WRITE:
        return a.opaque == b.opaque and \
               a.len    == b.len
      elif a.type_ == MemRespMsg.TYPE_WRITE_INIT:
        return a.opaque == b.opaque and \
               a.len    == b.len
      else:
        return a.opaque == b.opaque and \
               a.data   == b.data and \
               a.len    == b.len

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

      if in_go:

        in_msgs = False

        for x in s.msgs:
          if equal( s.in_.msg, x ):

            in_msgs = True

            # Update State
            s.msgs.remove( x )
            s.recv.append( x )
            s.idx = s.idx + 1

            break

        # Unexpected message, raise error

        if in_msgs == False:

          for x in s.recv:
            if equal( s.in_.msg, x ):
              raise AssertionError( "Message {} arrived twice!"
                                    .format( s.in_.msg ) )

          raise AssertionError( "Message {} not found in Test Sink!"
                                .format( s.in_.msg ) )

      # Set the ready and done signals.

      if ( s.idx < s.msgs_len ):
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

class TestNetCacheSink( Model ):

  def __init__( s, dtype, msgs, max_random_delay = 0 ):

    s.in_  = InValRdyBundle( dtype )
    s.done = OutPort       ( 1     )

    # Instantiate modules

    s.delay = TestRandomDelay( dtype, max_random_delay )
    s.sink  = TestSimpleNetCacheSink( dtype, msgs )

    # Connect the input ports -> random delay -> sink

    s.connect( s.in_,       s.delay.in_ )
    s.connect( s.delay.out, s.sink.in_  )

    # Connect test sink done signal to output port

    s.connect( s.sink.done, s.done )

  def line_trace( s ):

    return "{}".format( s.in_ )
