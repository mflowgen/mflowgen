`ifndef VC_TRACE_V
`define VC_TRACE_V

//------------------------------------------------------------------------
// Line trace helper
//------------------------------------------------------------------------

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */

//------------------------------------------------------------------------
// Components
//------------------------------------------------------------------------

module Mux2
#(
  parameter nbits = 1
)(
  input  logic [nbits-1:0] in0, in1,
  input  logic             sel,
  output logic [nbits-1:0] out
);

  always @ (*)
  begin
    case ( sel )
      1'd0 : out = in0;
      1'd1 : out = in1;
      default : out = {nbits{1'bx}};
    endcase
  end

endmodule

module Mux3
#(
  parameter nbits = 1
)(
  input  logic [nbits-1:0] in0, in1, in2,
  input  logic       [1:0] sel,
  output logic [nbits-1:0] out
);

  always @ (*)
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      default : out = {nbits{1'bx}};
    endcase
  end

endmodule

module Reg
#(
  parameter nbits = 1
)(
  input  logic             clk, // Clock input
  output logic [nbits-1:0] q,   // Data output
  input  logic [nbits-1:0] d    // Data input
);

  always @( posedge clk )
    q <= d;

endmodule

module RegEn
#(
  parameter nbits = 1
)(
  input  logic             clk,   // Clock input
  output logic [nbits-1:0] q,     // Data output
  input  logic [nbits-1:0] d,     // Data input
  input  logic             en     // Enable input
);

  always @( posedge clk )
    if ( en )
      q <= d;

endmodule

module Subtractor
#(
  parameter nbits = 1
)(
  input  logic [nbits-1:0] in0,
  input  logic [nbits-1:0] in1,
  output logic [nbits-1:0] out
);

  assign out = in0 - in1;

endmodule

module LeftLogicalShifter
#(
  parameter nbits       = 1,
  parameter shamt_nbits = 1
)(
  input  logic       [nbits-1:0] in,
  input  logic [shamt_nbits-1:0] shamt,
  output logic       [nbits-1:0] out
);

  assign out = ( in << shamt );

endmodule

module RightLogicalShifter
#(
  parameter nbits       = 1,
  parameter shamt_nbits = 1
)(
  input  logic       [nbits-1:0] in,
  input  logic [shamt_nbits-1:0] shamt,
  output logic       [nbits-1:0] out
);

  assign out = ( in >> shamt );

endmodule

module RegRst
#(
  parameter nbits       = 1,
  parameter reset_value = 0
)(
  input  logic             clk,   // Clock input
  input  logic             reset, // Sync reset input
  output logic [nbits-1:0] q,     // Data output
  input  logic [nbits-1:0] d      // Data input
);

  always @( posedge clk )
    q <= reset ? reset_value : d;

endmodule

//------------------------------------------------------------------------
// The actual divider
//------------------------------------------------------------------------

module IntDivRem4Ctrl
#(
  parameter nbits = 64
)(
  input  logic       clk,
  input  logic       reset,
  output logic       divisor_mux_sel,
  output logic       quotient_mux_sel,
  output logic       quotient_reg_en,
  output logic [1:0] remainder_mux_sel,
  output logic       remainder_reg_en,
  output logic       req_rdy,
  input  logic       req_val,
  input  logic       resp_rdy,
  output logic       resp_val,
  input  logic       sub_negative1,
  input  logic       sub_negative2
);

  // register declarations
  logic [$clog2(nbits):0] state$in_;
  logic [$clog2(nbits):0] state$out;

  // localparam declarations
  localparam D_MUX_SEL_IN = 0;
  localparam D_MUX_SEL_RSH = 1;
  localparam Q_MUX_SEL_0 = 0;
  localparam Q_MUX_SEL_LSH = 1;
  localparam R_MUX_SEL_IN = 0;
  localparam R_MUX_SEL_SUB1 = 1;
  localparam R_MUX_SEL_SUB2 = 2;
  localparam STATE_CALC = 1+nbits/2;
  localparam STATE_DONE = 1;
  localparam STATE_IDLE = 0;

  // state temporaries
  RegRst#(1+$clog2(nbits), 0) state
  (
    .clk   ( clk ),
    .reset ( reset ),
    .d     ( state$in_ ),
    .q     ( state$out )
  );

  // state_transitions
  always @ (*) begin
    state$in_ = state$out;
    if (state$out == STATE_IDLE) begin
      if (req_val && req_rdy)
        state$in_ = STATE_CALC;
    end
    else if (state$out== STATE_DONE) begin
      if (resp_val && resp_rdy)
        state$in_ = STATE_IDLE;
    end
    else
        state$in_ = state$out - 1;
  end

  always @ (*) begin
    if (state$out == STATE_IDLE) begin
      req_rdy = 1;
      resp_val = 0;
      remainder_mux_sel = R_MUX_SEL_IN;
      remainder_reg_en = 1;
      quotient_mux_sel = Q_MUX_SEL_0;
      quotient_reg_en = 1;
      divisor_mux_sel = D_MUX_SEL_IN;
    end
    else if (state$out == STATE_DONE) begin
      req_rdy = 0;
      resp_val = 1;
      quotient_mux_sel = Q_MUX_SEL_0;
      quotient_reg_en = 0;
      remainder_mux_sel = R_MUX_SEL_IN;
      remainder_reg_en = 0;
      divisor_mux_sel = D_MUX_SEL_IN;
    end
    else begin
      req_rdy = 0;
      resp_val = 0;
      remainder_reg_en = ~(sub_negative1&sub_negative2);
      if (sub_negative2)  remainder_mux_sel = R_MUX_SEL_SUB1;
      else                remainder_mux_sel = R_MUX_SEL_SUB2;
      quotient_reg_en = 1;
      quotient_mux_sel = Q_MUX_SEL_LSH;
      divisor_mux_sel = D_MUX_SEL_RSH;
    end
  end

endmodule

module IntDivRem4Dpath
#(
  parameter nbits = 64
)(
  input  logic               clk,
  input  logic               reset,
  input  logic               divisor_mux_sel,
  input  logic               quotient_mux_sel,
  input  logic               quotient_reg_en,
  input  logic [1:0]         remainder_mux_sel,
  input  logic               remainder_reg_en,
  input  logic [nbits*2-1:0] req_msg,
  output logic [nbits*2-1:0] resp_msg,
  output logic               sub_negative1,
  output logic               sub_negative2
);

  // localparam declarations
  localparam Q_MUX_SEL_LSH = 1;

  logic [nbits*2-1:0] remainder_mux$in_$000;
  logic [nbits*2-1:0] remainder_mux$in_$001;
  logic [nbits*2-1:0] remainder_mux$in_$002;
  logic [nbits*2-1:0] remainder_mux$out;

  Mux3#(nbits*2) remainder_mux
  (
    .in0  ( remainder_mux$in_$000 ),
    .in1  ( remainder_mux$in_$001 ),
    .in2  ( remainder_mux$in_$002 ),
    .sel  ( remainder_mux_sel ),
    .out  ( remainder_mux$out )
  );

  // remainder_reg temporaries
  logic [nbits*2-1:0] remainder_reg$in_;
  logic [nbits*2-1:0] remainder_reg$out;

  RegEn#(nbits*2) remainder_reg
  (
    .clk ( clk ),
    .d   ( remainder_reg$in_ ),
    .en  ( remainder_reg_en ),
    .q   ( remainder_reg$out )
  );

  // divisor_mux temporaries
  logic [nbits*2-1:0] divisor_mux$in_$000;
  logic [nbits*2-1:0] divisor_mux$in_$001;
  logic [nbits*2-1:0] divisor_mux$out;

  Mux2#(nbits*2) divisor_mux
  (
    .in0 ( divisor_mux$in_$000 ),
    .in1 ( divisor_mux$in_$001 ),
    .sel ( divisor_mux_sel ),
    .out ( divisor_mux$out )
  );

  // divisor_reg temporaries
  logic [nbits*2-1:0] divisor_reg$in_;
  logic [nbits*2-1:0] divisor_reg$out;

  Reg#(nbits*2) divisor_reg
  (
    .clk ( clk ),
    .d   ( divisor_reg$in_ ),
    .q   ( divisor_reg$out )
  );

  // quotient_mux temporaries
  logic [nbits-1:0] quotient_mux$in_$000;
  logic [nbits-1:0] quotient_mux$in_$001;
  logic [nbits-1:0] quotient_mux$out;

  Mux2#(nbits) quotient_mux
  (
    .in0 ( quotient_mux$in_$000 ),
    .in1 ( quotient_mux$in_$001 ),
    .sel ( quotient_mux_sel ),
    .out ( quotient_mux$out )
  );

  // quotient_reg temporaries
  logic [nbits-1:0] quotient_reg$in_;
  logic [nbits-1:0] quotient_reg$out;

  RegEn#(nbits) quotient_reg
  (
    .clk ( clk ),
    .d   ( quotient_reg$in_ ),
    .en  ( quotient_reg_en ),
    .q   ( quotient_reg$out )
  );

  // quotient_lsh temporaries
  logic [nbits-1:0] quotient_lsh$in_;
  logic [1:0] quotient_lsh$shamt;
  logic [nbits-1:0] quotient_lsh$out;

  LeftLogicalShifter#(nbits, 2) quotient_lsh
  (
    .in    ( quotient_lsh$in_ ),
    .shamt ( quotient_lsh$shamt ),
    .out   ( quotient_lsh$out )
  );

  // sub1 temporaries
  logic [nbits*2-1:0] sub1$in0;
  logic [nbits*2-1:0] sub1$in1;
  logic [nbits*2-1:0] sub1$out;

  Subtractor#(nbits*2) sub1
  (
    .in0 ( sub1$in0 ),
    .in1 ( sub1$in1 ),
    .out ( sub1$out )
  );

  // remainder_mid_mux temporaries
  logic [nbits*2-1:0] remainder_mid_mux$in_$000;
  logic [nbits*2-1:0] remainder_mid_mux$in_$001;
  logic [nbits*2-1:0] remainder_mid_mux$out;

  Mux2#(nbits*2) remainder_mid_mux
  (
    .in0 ( remainder_mid_mux$in_$000 ),
    .in1 ( remainder_mid_mux$in_$001 ),
    .sel ( sub_negative1 ),
    .out ( remainder_mid_mux$out )
  );

  // divisor_rsh1 temporaries
  logic [nbits*2-1:0] divisor_rsh1$in_;
  logic divisor_rsh1$shamt;
  logic [nbits*2-1:0] divisor_rsh1$out;

  RightLogicalShifter#(nbits*2) divisor_rsh1
  (
    .in    ( divisor_rsh1$in_ ),
    .shamt ( divisor_rsh1$shamt ),
    .out   ( divisor_rsh1$out )
  );

  // sub2 temporaries
  logic [nbits*2-1:0] sub2$in0;
  logic [nbits*2-1:0] sub2$in1;
  logic [nbits*2-1:0] sub2$out;

  Subtractor#(nbits*2) sub2
  (
    .in0   ( sub2$in0 ),
    .in1   ( sub2$in1 ),
    .out   ( sub2$out )
  );

  // divisor_rsh2 temporaries
  logic [nbits*2-1:0] divisor_rsh2$in_;
  logic divisor_rsh2$shamt;
  logic [nbits*2-1:0] divisor_rsh2$out;

  RightLogicalShifter#(nbits*2) divisor_rsh2
  (
    .in    ( divisor_rsh2$in_ ),
    .shamt ( divisor_rsh2$shamt ),
    .out   ( divisor_rsh2$out )
  );

  // signal connections
  assign divisor_mux$in_$000[nbits*2-2:nbits-1]    = req_msg[nbits*2-1:nbits];
  assign divisor_mux$in_$000[nbits*2-1:nbits*2-1]  = 1'd0;
  assign divisor_mux$in_$000[nbits-2:0]            = 0;
  assign divisor_mux$in_$001           = divisor_rsh2$out;
  assign divisor_reg$in_               = divisor_mux$out;
  assign divisor_rsh1$in_              = divisor_reg$out;
  assign divisor_rsh1$shamt            = 1'd1;
  assign divisor_rsh2$in_              = divisor_rsh1$out;
  assign divisor_rsh2$shamt            = 1'd1;
  assign quotient_lsh$in_              = quotient_reg$out;
  assign quotient_lsh$shamt            = 2'd2;
  assign quotient_mux$in_$000          = 0;
  assign quotient_reg$in_              = quotient_mux$out;
  assign remainder_mid_mux$in_$000     = sub1$out;
  assign remainder_mid_mux$in_$001     = remainder_reg$out;
  assign remainder_mux$in_$000[nbits*2-1:nbits] = 0;
  assign remainder_mux$in_$000[nbits-1:0] = req_msg[nbits-1:0];
  assign remainder_mux$in_$001         = sub1$out;
  assign remainder_mux$in_$002         = sub2$out;
  assign remainder_reg$in_             = remainder_mux$out;
  assign resp_msg[nbits*2-1:nbits]     = quotient_reg$out;
  assign resp_msg[nbits-1:0]           = remainder_reg$out[nbits-1:0];
  assign sub1$in0                      = remainder_reg$out;
  assign sub1$in1                      = divisor_reg$out;
  assign sub2$in0                      = remainder_mid_mux$out;
  assign sub2$in1                      = divisor_rsh1$out;
  assign sub_negative1                 = sub1$out[nbits*2-1];
  assign sub_negative2                 = sub2$out[nbits*2-1];

  always @ (*) begin
    quotient_mux$in_$001 = quotient_lsh$out + { {(nbits-2){1'b0}},
                                                ~sub_negative1,
                                                ~sub_negative2 };
  end

endmodule

module IntDivRem4
#(
  parameter nbits = 64
)(
  input  logic [        0:0] clk,
  input  logic [        0:0] reset,
  input  logic [nbits*2-1:0] req_msg,
  output logic [        0:0] req_rdy,
  input  logic [        0:0] req_val,
  output logic [nbits*2-1:0] resp_msg,
  input  logic [        0:0] resp_rdy,
  output logic [        0:0] resp_val
);
  logic       quotient_mux_sel;
  logic       quotient_reg_en;
  logic [1:0] remainder_mux_sel;
  logic       remainder_reg_en;
  logic       divisor_mux_sel;
  logic       sub_negative1;
  logic       sub_negative2;

  IntDivRem4Dpath#(nbits) dpath
  (
    .clk               ( clk ),
    .reset             ( reset ),
    .req_msg           ( req_msg ),
    .quotient_mux_sel  ( quotient_mux_sel ),
    .quotient_reg_en   ( quotient_reg_en ),
    .remainder_mux_sel ( remainder_mux_sel ),
    .remainder_reg_en  ( remainder_reg_en ),
    .divisor_mux_sel   ( divisor_mux_sel ),
    .resp_msg          ( resp_msg ),
    .sub_negative1     ( sub_negative1 ),
    .sub_negative2     ( sub_negative2 )
  );

  IntDivRem4Ctrl#(nbits) ctrl
  (
    .clk               ( clk ),
    .reset             ( reset ),
    .req_val           ( req_val ),
    .resp_rdy          ( resp_rdy ),
    .sub_negative1     ( sub_negative1 ),
    .sub_negative2     ( sub_negative2 ),
    .req_rdy           ( req_rdy ),
    .resp_val          ( resp_val ),
    .quotient_mux_sel  ( quotient_mux_sel ),
    .quotient_reg_en   ( quotient_reg_en ),
    .remainder_mux_sel ( remainder_mux_sel ),
    .remainder_reg_en  ( remainder_reg_en ),
    .divisor_mux_sel   ( divisor_mux_sel )
  );

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin
    vc_trace.append_str( trace_str, "(" );

    $sformat( str, "Rem:%x", dpath.remainder_reg$out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    $sformat( str, "Quo:%x", dpath.quotient_reg$out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    $sformat( str, "Div:%x", dpath.divisor_reg$out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    vc_trace.append_str( trace_str, ")" );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule
