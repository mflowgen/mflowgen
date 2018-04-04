#=========================================================================
# Integer Multiplier Variable-Latency RTL Model
#=========================================================================

from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle

class IntMulAltVRTL( VerilogModel ):

  # Verilog module setup

  vprefix    = "lab1_imul"
  vlinetrace = True

  # Constructor

  def __init__( s ):

    # Interface

    s.req   = InValRdyBundle  ( Bits(64) )
    s.resp  = OutValRdyBundle ( Bits(32) )

    # Verilog ports

    s.set_ports({
      'clk'         : s.clk,
      'reset'       : s.reset,

      'req_val'     : s.req.val,
      'req_rdy'     : s.req.rdy,
      'req_msg'     : s.req.msg,

      'resp_val'    : s.resp.val,
      'resp_rdy'    : s.resp.rdy,
      'resp_msg'    : s.resp.msg,
    })

