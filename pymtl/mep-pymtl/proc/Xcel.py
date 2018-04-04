#=========================================================================
# Xcel Model
#=========================================================================
# This is a top-level accelerator model that instantiates a specific
# accelerator or a network of xcels.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg4B
from pclib.rtl  import SingleElementPipelinedQueue

from xcel.XcelMsg  import XcelReqMsg, XcelRespMsg

from NullXcel import NullXcel

from gcd_xcel.GcdXcelFL        import GcdXcelFL
from gcd_xcel.GcdXcelHLS       import GcdXcelHLSWrapped
from sort_hls_xcel.SortXcelHLS import SortXcelHLSWrapped

class Xcel( Model ):

  # Constructor

  def __init__( s, mem_ifc_types=MemMsg4B() ):

    # Interface

    s.xcelreq   = InValRdyBundle  ( XcelReqMsg()  )
    s.xcelresp  = OutValRdyBundle ( XcelRespMsg() )

    s.memreq    = OutValRdyBundle ( mem_ifc_types.req  )
    s.memresp   = InValRdyBundle  ( mem_ifc_types.resp )

    # Instantiate an xcel

    s.xcel = SortXcelHLSWrapped()

    s.connect( s.xcelreq,  s.xcel.xcelreq  )
    s.connect( s.xcelresp, s.xcel.xcelresp )

    s.connect( s.memreq,   s.xcel.memreq   )
    s.connect( s.memresp,  s.xcel.memresp  )

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.xcelreq, s.xcelresp )

