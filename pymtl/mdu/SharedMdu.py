#=========================================================================
# Integer Mul/Div Units for RISC-V Wrapped with Network and Arbitration
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from IntDivRem4   import IntDivRem4
from IntMulVarLat import IntMulVarLat

from ifcs import MduReqMsg, MduRespMsg

from networks import Funnel, Router
from mdu.IntMulDivUnit import IntMulDivUnit

class SharedMdu( Model ):

  # Constructor

  def __init__( s, nreqs=4, nbits=32, ntypes=8 ): # default arguments for RV32M

    # Explicit module name

    s.explicit_modulename = "SharedMdu_"+str( nreqs )

    # Interface

    req_type  = MduReqMsg(nbits, ntypes)
    resp_type = MduRespMsg(nbits)

    s.reqs  = InValRdyBundle [nreqs]( req_type )
    s.resps = OutValRdyBundle[nreqs]( resp_type )

    # Components

    s.funnel = Funnel( nreqs, req_type )
    s.mdu    = IntMulDivUnit( nbits, ntypes )
    s.router = Router( nreqs, resp_type )

    for i in xrange(nreqs):
      s.connect( s.reqs[i], s.funnel.in_[i] )

    s.connect( s.funnel.out, s.mdu.req )
    s.connect( s.mdu.resp, s.router.in_ )

    for i in xrange(nreqs):
      s.connect( s.router.out[i], s.resps[i] )

  # Line tracing

  def line_trace( s ):
    traces = []

    traces.append( s.mdu.line_trace() )

    for i in xrange( len(s.reqs) ):
      in_ = s.reqs[ i ]
      out = s.resps[ i ]
      in_str  = in_.to_str( "{}:{}:{}".format( in_.msg.opaque, in_.msg.op_a, in_.msg.op_b ) )
      out_str = out.to_str( "{}:{}".format( out.msg.opaque, out.msg.result ) )
      traces.append( '({}|{})'.format( in_str, out_str ) )

    return ''.join( traces )
