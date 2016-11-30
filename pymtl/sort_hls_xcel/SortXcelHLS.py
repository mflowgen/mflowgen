#=========================================================================
# SortXcelHLS
#=========================================================================
# Wrapper module for HLS generated hardware

import os

from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle
from pclib.ifcs   import MemReqMsg, MemRespMsg
from pclib.rtl    import SingleElementBypassQueue
from pclib.rtl    import SingleElementPipelinedQueue

from xcel.XcelMsg      import XcelReqMsg, XcelRespMsg
from xcel.XcelMemMsg   import XMemReqMsg, XMemRespMsg

#-------------------------------------------------------------------------
# SortXcelHLS
#-------------------------------------------------------------------------

class SortXcelHLS( VerilogModel ):

  def __init__( s ):

    s.xcelreq  = InValRdyBundle ( XcelReqMsg()  )
    s.xcelresp = OutValRdyBundle( XcelRespMsg() )

    s.memreq   = OutValRdyBundle( XMemReqMsg (8,32,32) )
    s.memresp  = InValRdyBundle ( XMemRespMsg(8,32)    )

    s.set_ports({
      'ap_clk'                   : s.clk,
      'ap_rst'                   : s.reset,
      'xcelreq_V_bits_V'         : s.xcelreq.msg,
      'xcelreq_V_bits_V_ap_vld'  : s.xcelreq.val,
      'xcelreq_V_bits_V_ap_ack'  : s.xcelreq.rdy,
      'xcelresp_V_bits_V'        : s.xcelresp.msg,
      'xcelresp_V_bits_V_ap_vld' : s.xcelresp.val,
      'xcelresp_V_bits_V_ap_ack' : s.xcelresp.rdy,
      'memreq_V_bits_V'          : s.memreq.msg,
      'memreq_V_bits_V_ap_vld'   : s.memreq.val,
      'memreq_V_bits_V_ap_ack'   : s.memreq.rdy,
      'memresp_V_bits_V'         : s.memresp.msg,
      'memresp_V_bits_V_ap_vld'  : s.memresp.val,
      'memresp_V_bits_V_ap_ack'  : s.memresp.rdy
    })

#-------------------------------------------------------------------------
# SortXcelHLSWrapped
#-------------------------------------------------------------------------

class SortXcelHLSWrapped( Model ):

  def __init__( s ):

    s.xcelreq  = InValRdyBundle ( XcelReqMsg()  )
    s.xcelresp = OutValRdyBundle( XcelRespMsg() )

    s.memreq   = OutValRdyBundle( MemReqMsg (8,32,32) )
    s.memresp  = InValRdyBundle ( MemRespMsg(8,32)    )

    # Instantiate the xcel

    s.sort = SortXcelHLS()

    s.connect( s.xcelreq,  s.sort.xcelreq  )
    s.connect( s.xcelresp, s.sort.xcelresp )

    s.connect( s.memreq,   s.sort.memreq   )

    # the xcel mem message and the ece4750 branch mem message are different
    s.connect( s.sort.memresp.val,    s.memresp.val    )
    s.connect( s.sort.memresp.rdy,    s.memresp.rdy    )

    s.connect( s.sort.memresp.msg.type_,  s.memresp.msg.type_  )
    s.connect( s.sort.memresp.msg.opaque, s.memresp.msg.opaque )
    s.connect( s.sort.memresp.msg.len,    s.memresp.msg.len    )
    s.connect( s.sort.memresp.msg.data,   s.memresp.msg.data   )

