#=========================================================================
# GcdXcelHLS
#=========================================================================
# Wrapper module for HLS generated hardware

from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle
from pclib.rtl    import SingleElementPipelinedQueue
from xcel.XcelMsg import XcelReqMsg, XcelRespMsg

class GcdXcelHLS( VerilogModel ):

  def __init__( s ):

    s.xcelreq  = InValRdyBundle ( XcelReqMsg()  )
    s.xcelresp = OutValRdyBundle( XcelRespMsg() )

    s.set_ports({
      'ap_clk'                    : s.clk,
      'ap_rst'                    : s.reset,
      'xcelreq_V_bits_V'          : s.xcelreq.msg,
      'xcelreq_V_bits_V_ap_vld'   : s.xcelreq.val,
      'xcelreq_V_bits_V_ap_ack'   : s.xcelreq.rdy,
      'xcelresp_V_bits_V'         : s.xcelresp.msg,
      'xcelresp_V_bits_V_ap_vld'  : s.xcelresp.val,
      'xcelresp_V_bits_V_ap_ack'  : s.xcelresp.rdy
    })

#-------------------------------------------------------------------------
# GcdXcelHLSWrapped
#-------------------------------------------------------------------------

class GcdXcelHLSWrapped( Model ):

  def __init__( s ):

    s.xcelreq  = InValRdyBundle ( XcelReqMsg()  )
    s.xcelresp = OutValRdyBundle( XcelRespMsg() )

    # Instantiate the xcel

    s.gcd = GcdXcelHLS()

    s.connect( s.xcelreq,  s.gcd.xcelreq  )

    # The single-element pipelined queue is connected to the response port
    # of the generated xcel as the HLS generated design can aggresively
    # return a response within the same cycle for a few computations and
    # the pipelined queue helps to integrate the xcel to a pipelined
    # processor implementation

    s.xcelresp_q = SingleElementPipelinedQueue( XcelRespMsg() )

    s.connect( s.gcd.xcelresp, s.xcelresp_q.enq )
    s.connect( s.xcelresp,     s.xcelresp_q.deq )

