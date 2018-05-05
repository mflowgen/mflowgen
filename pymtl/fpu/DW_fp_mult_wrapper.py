#=========================================================================
# DW_fp_mult_wrapper
#=========================================================================
# This is a PyMTL wrapper around the DesignWare single-precision floating
# point multiplier.
#
# ### Verilog Interface
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
# ### IEEE Compliance
#
# By default this is zero, but I set it to one below. This seemed like
# the right thing to do since we are trying to create a FPU suitable for
# use in an RISC-V processor which is IEEE compliant.
#
# ### Rounding Modes
#
# Table 1-6 of the fp_overview2.pdf Synopsys DesignWare documentation
# specifies what the various rounding modes are. From the documentation
# "Table 1-6 describes the supported rounding modes in terms of the near
# floating-point values F1 and F2 (F1 < F2), of an infinite precision
# value F, and show how the rounding mode are encoded."
#
#  000  IEEE round to nearest (even)  Round to the nearest representable
#                                     significand. If the two
#                                     significands are equally near,
#                                     choose the even significand (the
#                                     one with LSB=0).
#
#  001  IEEE round to zero            Use F1 if the value is positive
#                                     or F2 if the value is negative.
#
#  010  IEEE round to pos infinity    Output is always F2.
#
#  011  IEEE round to neg infinity    Output is always F1.
#
#  100  round to nearest up           Round to the nearest representable
#                                     significand. If F1 and F2 are
#                                     equally near, then use F2.
#
#  101  round away from zero          Use F1 when F < 0, otherwise F2.
#
# I took a look at this:
#
#  https://www.gnu.org/software/libc/manual/html_node/Rounding.html
#
# It mentions the four IEEE rounding modes above. In C you can set the
# rounding mode using various constants and the fesetround function. The
# default mode is round to nearest. So given all of this, I think the
# right thing to do is to hard code the rounding mode to 000.
#
# ### Status
#
# The status output is specified as follows:
#
#  - bit 0 : zero
#  - bit 1 : infinity
#  - bit 2 : invalid
#  - bit 3 : tiny
#  - bit 4 : huge
#  - bit 5 : inexact
#  - bit 6 : hugeint
#  - bit 7 : passA, divide by zero
#

from pymtl import *
import struct

#-------------------------------------------------------------------------
# DW_fp_mult
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_mult( VerilogModel ):

  # Verilog module setup

  vprefix    = ""
  vlinetrace = False

  # Constructor

  def __init__( s, ieee_compliance ):

    sig_width = 23      # RANGE 2 TO 253
    exp_width = 8       # RANGE 3 TO 31

    # Interface

    s.a       = InPort ( exp_width + sig_width + 1 )
    s.b       = InPort ( exp_width + sig_width + 1 )
    s.z       = OutPort( exp_width + sig_width + 1 )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )

    # Verilog parameters

    s.set_params({
      'ieee_compliance' : ieee_compliance,
    })

    # Verilog ports

    s.set_ports({
      'a'      : s.a,
      'b'      : s.b,
      'rnd'    : s.rnd,
      'z'      : s.z,
      'status' : s.status,
    })

#-------------------------------------------------------------------------
# DW_fp_mult_wrapper
#-------------------------------------------------------------------------
# This is a normal PyMTL model which wraps around the DW component. We
# use this extra layer of wrapping for a couple of reasons: (1) we can
# force the rounding mode to be nearest, (2) we can force the IEEE
# compliance mode to be true, and (3) we can add a little line tracing.

class DW_fp_mult_wrapper( Model ):

  # Constructor

  def __init__( s ):

    # Interface

    s.a       = InPort ( 32 )
    s.b       = InPort ( 32 )
    s.z       = OutPort( 32 )
    s.status  = OutPort( 8 )

    # Instantiate inner model

    s.inner = DW_fp_mult( ieee_compliance = 1 );
    s.connect( s.inner.a,      s.a           );
    s.connect( s.inner.b,      s.b           );
    s.connect( s.inner.rnd,    0b000         );
    s.connect( s.inner.z,      s.z           );
    s.connect( s.inner.status, s.status      );

  # Line Trace

  def line_trace( s ):
    # a_fp = struct.unpack('<f', struct.pack('<I', s.a))[0]
    # b_fp = struct.unpack('<f', struct.pack('<I', s.b))[0]
    # z_fp = struct.unpack('<f', struct.pack('<I', s.z))[0]
    # return "{: .3e} {: .3e} () {: .3e}".format( a_fp, b_fp, z_fp )
    return "{} {} () {}".format( s.a, s.b, s.z )

