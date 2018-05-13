#=========================================================================
# DesignWareFloatingPointUnit
#=========================================================================
# This is a PyMTL wrapper around the DesignWare single-precision floating
# point units components.
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
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import NormalQueue
from ifcs.FpuMsg import FpuReqMsg, FpuRespMsg

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
# DW_fp_div
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_div( VerilogModel ):

  # Verilog module setup

  vprefix    = ""
  vlinetrace = False

  # Constructor

  def __init__( s, ieee_compliance ):

    sig_width      = 23      # RANGE 2 TO 253
    exp_width      = 8       # RANGE 3 TO 31
    faithful_round = 0       # RANGE 0 TO 1

    # Interface

    s.a       = InPort ( exp_width + sig_width + 1 )
    s.b       = InPort ( exp_width + sig_width + 1 )
    s.z       = OutPort( exp_width + sig_width + 1 )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )

    # Verilog parameters

    s.set_params({
      'ieee_compliance' : ieee_compliance,
      'faithful_round'  : faithful_round,
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
# DW_fp_div_pipelined
#-------------------------------------------------------------------------
# Add pipelining to DW_fp_div.

class DW_fp_div_pipelined( Model ):

  def __init__( s, ieee_compliance, num_stages=3 ):

    sig_width      = 23      # RANGE 2 TO 253
    exp_width      = 8       # RANGE 3 TO 31
    fp_width       = exp_width + sig_width + 1

    # Explicit module name

    s.explicit_modulename = "DW_fp_div_pipelined"

    # Interface

    s.a       = InPort ( fp_width )
    s.b       = InPort ( fp_width )
    s.z       = OutPort( fp_width )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )
    s.in_val  = InPort ( 1 )
    s.out_val = OutPort( 1 )
    s.busy    = OutPort( 1 )

    # Input registers

    s.a_reg   = Wire( fp_width )
    s.b_reg   = Wire( fp_width )
    s.rnd_reg = Wire( 3 )
    s.in_val_reg = Wire( 1 )

    # Pipeline registers

    s.pipe_val = [ Wire( 1 ) for i in range( num_stages ) ]
    s.pipe_z   = [ Wire( fp_width ) for i in range( num_stages ) ]
    s.pipe_status = [ Wire( 8 ) for i in range( num_stages ) ]

    # The div unit

    s.dw_fp_div = DW_fp_div( ieee_compliance )

    s.connect( s.a_reg,   s.dw_fp_div.a   )
    s.connect( s.b_reg,   s.dw_fp_div.b   )
    s.connect( s.rnd_reg, s.dw_fp_div.rnd )

    # Output

    s.connect( s.pipe_val[num_stages-1],    s.out_val )
    s.connect( s.pipe_z[num_stages-1],      s.z       )
    s.connect( s.pipe_status[num_stages-1], s.status  )

    # Busy signal

    @s.combinational
    def comb_busy():
      s.busy.value = s.in_val_reg
      for i in xrange( num_stages ):
        s.busy.value = s.busy | s.pipe_val[i]

    # Sequential logic

    @s.posedge_clk
    def posedge():
      if s.reset:
        # Only need to reset the valid registers.
        s.in_val_reg.next = 0

        for i in xrange( num_stages ):
          s.pipe_val[i].next = 0

      else:
        s.a_reg.next = s.a
        s.b_reg.next = s.b
        s.rnd_reg.next = s.rnd
        s.in_val_reg.next = s.in_val

        s.pipe_val[0].next     = s.in_val_reg
        s.pipe_z[0].next       = s.dw_fp_div.z
        s.pipe_status[0].next  = s.dw_fp_div.status

        for i in xrange( 1, num_stages ):
          s.pipe_val[i].next    = s.pipe_val[i-1]
          s.pipe_z[i].next      = s.pipe_z[i-1]
          s.pipe_status[i].next = s.pipe_status[i-1]

#-------------------------------------------------------------------------
# DW_fp_addsub
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_addsub( VerilogModel ):

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
    s.op      = InPort ( 1 )
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
      'op'     : s.op,
      'rnd'    : s.rnd,
      'z'      : s.z,
      'status' : s.status,
    })

#-------------------------------------------------------------------------
# DW_fp_addsub_pipelined
#-------------------------------------------------------------------------
# Add pipelining to DW_fp_addsub.

class DW_fp_addsub_pipelined( Model ):

  def __init__( s, ieee_compliance, num_stages=2 ):

    sig_width      = 23      # RANGE 2 TO 253
    exp_width      = 8       # RANGE 3 TO 31
    fp_width       = exp_width + sig_width + 1

    # Explicit module name

    s.explicit_modulename = "DW_fp_addsub_pipelined"

    # Interface

    s.a       = InPort ( fp_width )
    s.b       = InPort ( fp_width )
    s.op      = InPort ( 1 )
    s.z       = OutPort( fp_width )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )
    s.in_val  = InPort ( 1 )
    s.out_val = OutPort( 1 )
    s.busy    = OutPort( 1 )

    # Input registers

    s.a_reg   = Wire( fp_width )
    s.b_reg   = Wire( fp_width )
    s.op_reg  = Wire( 1 )
    s.rnd_reg = Wire( 3 )
    s.in_val_reg = Wire( 1 )

    # Pipeline registers

    s.pipe_val = [ Wire( 1 ) for i in range( num_stages ) ]
    s.pipe_z   = [ Wire( fp_width ) for i in range( num_stages ) ]
    s.pipe_status = [ Wire( 8 ) for i in range( num_stages ) ]

    # The addsub unit

    s.dw_fp_addsub = DW_fp_addsub( ieee_compliance )

    s.connect( s.a_reg,   s.dw_fp_addsub.a   )
    s.connect( s.b_reg,   s.dw_fp_addsub.b   )
    s.connect( s.op_reg,  s.dw_fp_addsub.op  )
    s.connect( s.rnd_reg, s.dw_fp_addsub.rnd )

    # Output

    s.connect( s.pipe_val[num_stages-1],    s.out_val )
    s.connect( s.pipe_z[num_stages-1],      s.z       )
    s.connect( s.pipe_status[num_stages-1], s.status  )

    # Busy signal

    @s.combinational
    def comb_busy():
      s.busy.value = s.in_val_reg
      for i in xrange( num_stages ):
        s.busy.value = s.busy | s.pipe_val[i]

    # Sequential logic

    @s.posedge_clk
    def posedge():
      if s.reset:
        # Only need to reset the valid registers.
        s.in_val_reg.next = 0

        for i in xrange( num_stages ):
          s.pipe_val[i].next = 0

      else:
        s.a_reg.next = s.a
        s.b_reg.next = s.b
        s.op_reg.next = s.op
        s.rnd_reg.next = s.rnd
        s.in_val_reg.next = s.in_val

        s.pipe_val[0].next     = s.in_val_reg
        s.pipe_z[0].next       = s.dw_fp_addsub.z
        s.pipe_status[0].next  = s.dw_fp_addsub.status

        for i in xrange( 1, num_stages ):
          s.pipe_val[i].next    = s.pipe_val[i-1]
          s.pipe_z[i].next      = s.pipe_z[i-1]
          s.pipe_status[i].next = s.pipe_status[i-1]

#-------------------------------------------------------------------------
# DW_fp_cmp
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_cmp( VerilogModel ):

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
    s.zctr    = InPort ( 1 )
    s.aeqb    = OutPort ( 1 )
    s.altb    = OutPort ( 1 )
    s.agtb    = OutPort ( 1 )
    s.unordered = OutPort ( 1 )
    s.z0      = OutPort( exp_width + sig_width + 1 )
    s.z1      = OutPort( exp_width + sig_width + 1 )
    s.status0 = OutPort( 8 )
    s.status1 = OutPort( 8 )

    # Verilog parameters

    s.set_params({
      'ieee_compliance' : ieee_compliance,
    })

    # Verilog ports

    s.set_ports({
      'a'      : s.a,
      'b'      : s.b,
      'zctr'   : s.zctr,
      'aeqb'   : s.aeqb,
      'altb'   : s.altb,
      'agtb'   : s.agtb,
      'unordered' : s.unordered,
      'z0'     : s.z0,
      'z1'     : s.z1,
      'status0': s.status0,
      'status1': s.status1,
    })

#-------------------------------------------------------------------------
# DW_fp_i2flt
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_i2flt( VerilogModel ):

  # Verilog module setup

  vprefix    = ""
  vlinetrace = False

  # Constructor

  def __init__( s ):

    sig_width = 23      # RANGE 2 TO 253
    exp_width = 8       # RANGE 3 TO 31
    isize     = 32      # RANGE 3 to 512
    isign     = 1       # 0 : unsigned, 1 : signed

    # Interface

    s.a       = InPort ( isize )
    s.z       = OutPort( exp_width + sig_width + 1 )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )

    # Verilog ports

    s.set_ports({
      'a'      : s.a,
      'rnd'    : s.rnd,
      'z'      : s.z,
      'status' : s.status,
    })

#-------------------------------------------------------------------------
# DW_fp_flt2i
#-------------------------------------------------------------------------
# Python wrapper for just the Verilog model with no extra logic used
# to do the Verilog import.

class DW_fp_flt2i( VerilogModel ):

  # Verilog module setup

  vprefix    = ""
  vlinetrace = False

  # Constructor

  def __init__( s, ieee_compliance ):

    sig_width = 23      # RANGE 2 TO 253
    exp_width = 8       # RANGE 3 TO 31
    isize     = 32      # RANGE 3 to 512

    # Interface

    s.a       = InPort( exp_width + sig_width + 1 )
    s.z       = OutPort ( isize )
    s.rnd     = InPort ( 3 )
    s.status  = OutPort( 8 )

    # Verilog parameters

    s.set_params({
      'ieee_compliance' : ieee_compliance,
    })

    # Verilog ports

    s.set_ports({
      'a'      : s.a,
      'rnd'    : s.rnd,
      'z'      : s.z,
      'status' : s.status,
    })

#-------------------------------------------------------------------------
# DesignWareFloatingPointUnit
#-------------------------------------------------------------------------
# This is a normal PyMTL model which wraps around the DW components. This
# uses val/rdy ports to communicate the input and output values.

class DesignWareFloatingPointUnit( Model ):

  # Constructor

  def __init__( s ):

    s.DW_FRND_NE = 0b000
    s.DW_FRND_TZ = 0b001
    s.DW_FRND_DN = 0b011
    s.DW_FRND_UP = 0b010
    s.DW_FRND_MM = 0b100

    s.DW_FEXC_NX = 0b00100000
    s.DW_FEXC_UF = 0b00001000
    s.DW_FEXC_OF = 0b00010000
    s.DW_FEXC_DZ = 0b10000000
    s.DW_FEXC_NV = 0b00000100

    s.DW_ADDSUB_ADD = 0
    s.DW_ADDSUB_SUB = 1

    # Explicit module name

    s.explicit_modulename = "DesignWareFloatingPointUnit"

    # Interface

    s.req    = InValRdyBundle( FpuReqMsg() )
    s.resp   = OutValRdyBundle( FpuRespMsg() )

    #

    s.resp_go = Wire( 1 )
    s.dw_frnd = Wire( 3 )
    s.riscv_fexc = Wire( 5 )
    s.dw_fexc = Wire( 8 )
    s.req_q  = NormalQueue( 2, FpuReqMsg() )
    s.resp_q = NormalQueue( 2, FpuRespMsg() )

    s.connect( s.req, s.req_q.enq )
    s.connect( s.resp, s.resp_q.deq )

    # Instantiate inner models

    s.fp_mult   = DW_fp_mult( ieee_compliance = 1 );
    s.fp_addsub = DW_fp_addsub_pipelined( ieee_compliance = 1, num_stages = 2 );
    s.fp_div    = DW_fp_div_pipelined( ieee_compliance = 1, num_stages = 3 );
    s.fp_cmp    = DW_fp_cmp( ieee_compliance = 1 );
    s.fp_flt2i  = DW_fp_flt2i( ieee_compliance = 1 );
    s.fp_i2flt  = DW_fp_i2flt();

    @s.combinational
    def comb():
      s.fp_mult.a.value       = 0
      s.fp_mult.b.value       = 0
      s.fp_mult.rnd.value     = 0

      s.fp_addsub.a.value     = 0
      s.fp_addsub.b.value     = 0
      s.fp_addsub.op.value    = 0
      s.fp_addsub.rnd.value   = 0
      s.fp_addsub.in_val.value= 0

      s.fp_div.a.value        = 0
      s.fp_div.b.value        = 0
      s.fp_div.rnd.value      = 0
      s.fp_div.in_val.value   = 0

      s.fp_cmp.a.value        = 0
      s.fp_cmp.b.value        = 0
      s.fp_cmp.zctr.value     = 0

      s.fp_flt2i.a.value      = 0
      s.fp_flt2i.rnd.value    = 0

      s.fp_i2flt.a.value      = 0
      s.fp_i2flt.rnd.value    = 0

      s.resp_q.enq.msg.opaque.value = 0
      s.resp_q.enq.msg.result.value = 0

      s.dw_fexc.value             = 0
      s.resp_q.enq.msg.fexc.value = 0
      s.dw_frnd.value             = 0
      s.riscv_fexc.value          = 0

      s.req_q.deq.rdy.value   = 0
      s.resp_q.enq.val.value  = 0
      s.resp_go.value         = 0

      # Because the rounding mode is encoded differently in DW and RISC-V,
      # we convert between the two here.

      if s.req_q.deq.msg.frnd == FpuReqMsg.FRND_NE:
        s.dw_frnd.value = s.DW_FRND_NE
      elif s.req_q.deq.msg.frnd == FpuReqMsg.FRND_TZ:
        s.dw_frnd.value = s.DW_FRND_TZ
      elif s.req_q.deq.msg.frnd == FpuReqMsg.FRND_DN:
        s.dw_frnd.value = s.DW_FRND_DN
      elif s.req_q.deq.msg.frnd == FpuReqMsg.FRND_UP:
        s.dw_frnd.value = s.DW_FRND_UP
      elif s.req_q.deq.msg.frnd == FpuReqMsg.FRND_MM:
        s.dw_frnd.value = s.DW_FRND_MM

      if s.req_q.deq.val and s.resp_q.enq.rdy:
        s.resp_go.value        = 1

        if s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FMUL:
          s.fp_mult.a.value       = s.req_q.deq.msg.op_a
          s.fp_mult.b.value       = s.req_q.deq.msg.op_b
          s.fp_mult.rnd.value     = s.dw_frnd
          s.resp_q.enq.msg.result.value = s.fp_mult.z
          s.dw_fexc.value         = s.fp_mult.status

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FADD:
          s.fp_addsub.a.value     = s.req_q.deq.msg.op_a
          s.fp_addsub.b.value     = s.req_q.deq.msg.op_b
          s.fp_addsub.op.value    = s.DW_ADDSUB_ADD
          s.fp_addsub.rnd.value   = s.dw_frnd
          s.fp_addsub.in_val.value= not s.fp_addsub.busy
          s.resp_q.enq.msg.result.value = s.fp_addsub.z
          s.dw_fexc.value         = s.fp_addsub.status
          s.resp_go.value        = s.fp_addsub.out_val

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FSUB:
          s.fp_addsub.a.value     = s.req_q.deq.msg.op_a
          s.fp_addsub.b.value     = s.req_q.deq.msg.op_b
          s.fp_addsub.op.value    = s.DW_ADDSUB_SUB
          s.fp_addsub.rnd.value   = s.dw_frnd
          s.fp_addsub.in_val.value= not s.fp_addsub.busy
          s.resp_q.enq.msg.result.value = s.fp_addsub.z
          s.dw_fexc.value         = s.fp_addsub.status
          s.resp_go.value         = s.fp_addsub.out_val

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FDIV:
          s.fp_div.a.value        = s.req_q.deq.msg.op_a
          s.fp_div.b.value        = s.req_q.deq.msg.op_b
          s.fp_div.rnd.value      = s.dw_frnd
          s.fp_div.in_val.value   = not s.fp_div.busy
          s.resp_q.enq.msg.result.value = s.fp_div.z
          s.dw_fexc.value         = s.fp_div.status
          s.resp_go.value         = s.fp_div.out_val

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FMIN:
          s.fp_cmp.a.value        = s.req_q.deq.msg.op_a
          s.fp_cmp.b.value        = s.req_q.deq.msg.op_b
          s.fp_cmp.zctr.value     = 0
          s.resp_q.enq.msg.result.value = s.fp_cmp.z0
          if s.fp_cmp.unordered:
            s.dw_fexc.value       = s.DW_FEXC_NV

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FMAX:
          s.fp_cmp.a.value        = s.req_q.deq.msg.op_a
          s.fp_cmp.b.value        = s.req_q.deq.msg.op_b
          s.fp_cmp.zctr.value     = 1
          s.resp_q.enq.msg.result.value = s.fp_cmp.z0
          if s.fp_cmp.unordered:
            s.dw_fexc.value       = s.DW_FEXC_NV

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FCEQ:
          s.fp_cmp.a.value        = s.req_q.deq.msg.op_a
          s.fp_cmp.b.value        = s.req_q.deq.msg.op_b
          s.fp_cmp.zctr.value     = 0
          s.resp_q.enq.msg.result.value = s.fp_cmp.aeqb
          if s.fp_cmp.unordered:
            s.dw_fexc.value       = s.DW_FEXC_NV

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FCLT:
          s.fp_cmp.a.value        = s.req_q.deq.msg.op_a
          s.fp_cmp.b.value        = s.req_q.deq.msg.op_b
          s.fp_cmp.zctr.value     = 0
          s.resp_q.enq.msg.result.value = s.fp_cmp.altb
          if s.fp_cmp.unordered:
            s.dw_fexc.value       = s.DW_FEXC_NV

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FCLE:
          s.fp_cmp.a.value        = s.req_q.deq.msg.op_a
          s.fp_cmp.b.value        = s.req_q.deq.msg.op_b
          s.fp_cmp.zctr.value     = 0
          s.resp_q.enq.msg.result.value = s.fp_cmp.altb | s.fp_cmp.aeqb
          if s.fp_cmp.unordered:
            s.dw_fexc.value       = s.DW_FEXC_NV

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FF2I:
          s.fp_flt2i.a.value      = s.req_q.deq.msg.op_a
          s.fp_flt2i.rnd.value    = s.dw_frnd
          s.resp_q.enq.msg.result.value = s.fp_flt2i.z
          s.dw_fexc.value         = s.fp_flt2i.status

        elif s.req_q.deq.msg.type_ == FpuReqMsg.TYPE_FI2F:
          s.fp_i2flt.a.value      = s.req_q.deq.msg.op_a
          s.fp_i2flt.rnd.value    = s.dw_frnd
          s.resp_q.enq.msg.result.value = s.fp_i2flt.z
          s.dw_fexc.value         = s.fp_i2flt.status


        s.resp_q.enq.msg.opaque.value = s.req_q.deq.msg.opaque
        s.req_q.deq.rdy.value = s.resp_go
        s.resp_q.enq.val.value = s.resp_go

      # Because the exceptions are encoded differently in DW and RISC-V,
      # we convert between the two here.

      if s.dw_fexc & s.DW_FEXC_NX:
        s.riscv_fexc.value = s.riscv_fexc | FpuRespMsg.FEXC_NX
      if s.dw_fexc & s.DW_FEXC_UF:
        s.riscv_fexc.value = s.riscv_fexc | FpuRespMsg.FEXC_UF
      if s.dw_fexc & s.DW_FEXC_OF:
        s.riscv_fexc.value = s.riscv_fexc | FpuRespMsg.FEXC_OF
      if s.dw_fexc & s.DW_FEXC_DZ:
        s.riscv_fexc.value = s.riscv_fexc | FpuRespMsg.FEXC_DZ
      if s.dw_fexc & s.DW_FEXC_NV:
        s.riscv_fexc.value = s.riscv_fexc | FpuRespMsg.FEXC_NV

      s.resp_q.enq.msg.fexc.value   = s.riscv_fexc

  def line_trace( s ):
    return "{} {} {}".format( s.fp_div.busy, s.fp_div.in_val,
                           s.fp_div.out_val )

