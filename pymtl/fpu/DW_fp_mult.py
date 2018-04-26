#=========================================================================
# DW_fp_mult
#=========================================================================
#
# module DW_fp_mult (a, b, rnd, z, status);
#
#   parameter sig_width = 23;      // RANGE 2 TO 253
#   parameter exp_width = 8;       // RANGE 3 TO 31
#   parameter ieee_compliance = 0; // RANGE 0 TO 1
#
#   input  [exp_width + sig_width:0] a;
#   input  [exp_width + sig_width:0] b;
#   input  [2:0] rnd;
#   output [exp_width + sig_width:0] z;
#   output [7:0] status;
#

from pymtl import *

class DW_fp_mult( VerilogModel ):

  # Verilog module setup

  vprefix    = ""
  vlinetrace = False

  # Constructor

  def __init__( s ):

    sig_width = 23      # RANGE 2 TO 253
    exp_width = 8       # RANGE 3 TO 31
    ieee_compliance = 0 # RANGE 0 TO 1

    # Interface

    s.a       = InPort ( exp_width + sig_width + 1 )
    s.b       = InPort ( exp_width + sig_width + 1 )
    s.rnd     = InPort ( 3 )
    s.z       = OutPort( exp_width + sig_width + 1 )
    s.status  = OutPort( 8 )

    # Verilog ports

    s.set_ports({
      'a'      : s.a,
      'b'      : s.b,
      'rnd'    : s.rnd,
      'z'      : s.z,
      'status' : s.status,
    })
