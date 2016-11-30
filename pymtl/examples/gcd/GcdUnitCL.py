#=========================================================================
# GCD Unit CL Model
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle, valrdy_to_str
from pclib.cl   import InValRdyQueueAdapter, OutValRdyQueueAdapter

from GcdUnitMsg import GcdUnitReqMsg

#-------------------------------------------------------------------------
# gcd
#-------------------------------------------------------------------------
# Helper function that uses Euclid's algorithm to calculate the greatest
# common denomiator, but also to estimate the number of cycles a simple
# FSM-based GCD unit might take.

def gcd( a, b ):

  ncycles = 0
  while True:
    ncycles += 1
    if a < b:
      a,b = b,a
    elif b != 0:
      a = a - b
    else:
      return (a,ncycles)

#-------------------------------------------------------------------------
# GcdUnitCL
#-------------------------------------------------------------------------

class GcdUnitCL( Model ):

  # Constructor

  def __init__( s ):

    # Interface

    s.req    = InValRdyBundle  ( GcdUnitReqMsg() )
    s.resp   = OutValRdyBundle ( Bits(16)        )

    # Adapters

    s.req_q  = InValRdyQueueAdapter  ( s.req  )
    s.resp_q = OutValRdyQueueAdapter ( s.resp )

    # Member variables

    s.result  = 0
    s.counter = 0

    # Concurrent block

    @s.tick_cl
    def block():

      # Tick the queue adapters

      s.req_q.xtick()
      s.resp_q.xtick()

      # Handle delay to model the gcd unit latency

      if s.counter > 0:
        s.counter -= 1
        if s.counter == 0:
          s.resp_q.enq( s.result )

      # If we have a new message and the output queue is not full

      elif not s.req_q.empty() and not s.resp_q.full():
        req_msg = s.req_q.deq()
        s.result,s.counter = gcd( req_msg.a, req_msg.b )

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.req, s.resp )

