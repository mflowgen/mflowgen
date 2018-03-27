//-----------------------------------------------------------------------------
// GcdUnit
//-----------------------------------------------------------------------------
// dump-vcd: True
// verilator-xinit: zeros
`default_nettype none
module GcdUnit
(
  input  wire [   0:0] clk_io,
  input  wire [  31:0] req_msg_io,
  output wire [   0:0] req_rdy_io,
  input  wire [   0:0] req_val_io,
  input  wire [   0:0] reset_io,
  output wire [  15:0] resp_msg_io,
  input  wire [   0:0] resp_rdy_io,
  output wire [   0:0] resp_val_io
);

  //----------------------------------------------------------------------
  // Pads
  //----------------------------------------------------------------------

  // Pad macros

//  PRWDWUWHWSWDGE_H_G padname_o
//  (
//    .PAD (pad),      // PAD
//    .C   (),         // Leave disconnected in output mode
//    .I   (data),     //
//    .OEN (1'b0),     // Enable output pad mode (active LOW)
//    .IE  (1'b0),     // Disable input pad mode (active HIGH)
//    .SL  (1'b1),     // Enable slew rate control
//    .DS0 (1'b1),     // Choose highest drive strength = 2'b11
//    .DS1 (1'b1),     //
//    .PE  (1'b0),     // Disable pullup/pulldown
//    .PS  (1'b0),     //
//    .HE  (1'b0),     // Disable hold bus mode
//    .ST0 (1'b0),     // Disable schmitt trigger
//    .ST1 (1'b0)      // Disable schmitt trigger
//  );

//  PRWDWUWHWSWDGE_H_G padname_i
//  (
//    .PAD (pad),      // PAD
//    .C   (data),     //
//    .I   (),         // Leave disconnected in input mode
//    .OEN (1'b1),     // Disable output pad mode (active LOW)
//    .IE  (1'b1),     // Enable input pad mode (active HIGH)
//    .SL  (1'b0),     // Disable slew rate control
//    .DS0 (1'b0),     //
//    .DS1 (1'b0),     //
//    .PE  (1'b0),     // Disable pullup/pulldown
//    .PS  (1'b0),     //
//    .HE  (1'b0),     // Disable hold bus mode
//    .ST0 (1'b0),     // Disable schmitt trigger
//    .ST1 (1'b0)      // Disable schmitt trigger
//  );

  `define OUTPUT_PAD_V(name,pad,data) \
  PRWDWUWHWSWDGE_V_G name \
  (                       \
    .PAD (pad),           \
    .C   (),              \
    .I   (data),          \
    .OEN (1'b0),          \
    .IE  (1'b0),          \
    .SL  (1'b1),          \
    .DS0 (1'b1),          \
    .DS1 (1'b1),          \
    .PE  (1'b0),          \
    .PS  (1'b0),          \
    .HE  (1'b0),          \
    .ST0 (1'b0),          \
    .ST1 (1'b0)           \
  );

  `define OUTPUT_PAD_H(name,pad,data) \
  PRWDWUWHWSWDGE_H_G name \
  (                       \
    .PAD (pad),           \
    .C   (),              \
    .I   (data),          \
    .OEN (1'b0),          \
    .IE  (1'b0),          \
    .SL  (1'b1),          \
    .DS0 (1'b1),          \
    .DS1 (1'b1),          \
    .PE  (1'b0),          \
    .PS  (1'b0),          \
    .HE  (1'b0),          \
    .ST0 (1'b0),          \
    .ST1 (1'b0)           \
  );

  `define INPUT_PAD_V(name,pad,data) \
  PRWDWUWHWSWDGE_V_G name \
  (                       \
    .PAD (pad),           \
    .C   (data),          \
    .I   (),              \
    .OEN (1'b1),          \
    .IE  (1'b1),          \
    .SL  (1'b0),          \
    .DS0 (1'b0),          \
    .DS1 (1'b0),          \
    .PE  (1'b0),          \
    .PS  (1'b0),          \
    .HE  (1'b0),          \
    .ST0 (1'b0),          \
    .ST1 (1'b0)           \
  );

  `define INPUT_PAD_H(name,pad,data) \
  PRWDWUWHWSWDGE_H_G name \
  (                       \
    .PAD (pad),           \
    .C   (data),          \
    .I   (),              \
    .OEN (1'b1),          \
    .IE  (1'b1),          \
    .SL  (1'b0),          \
    .DS0 (1'b0),          \
    .DS1 (1'b0),          \
    .PE  (1'b0),          \
    .PS  (1'b0),          \
    .HE  (1'b0),          \
    .ST0 (1'b0),          \
    .ST1 (1'b0)           \
  );

// From the release notes for the IO cells + truth table from databook:
//
//     PAD    : Signal pin on pad side
//     C      : Input signal from pad to core in input pad mode
//     I      : Output signal from core to pad in output pad mode
//     OEN    : Output mode enable (active LOW) -- be careful here!
//            : - Drives core-side pin I to the pin PAD
//     IE     : Input mode enable (active HIGH) -- be careful here!
//            : - Drives pin PAD to the core-side pin C
//     SL     : Slew-rate-control enable. SL=1 enables Slew-rate-control function
//            : - ctorng: I think SL enables DS0 and DS1, but not sure
//     DS0    : Driving selector
//     DS1    : Driving selector
//     PE     : Pull enable (active HIGH)
//     PS     : Pull selector
//     HE     : Hold enable (active HIGH)
//     ST0    : Schmitt trigger enable (active HIGH)
//     ST1    : Schmitt trigger enable (active HIGH)
//     XIN    : Input signal pad from oscillator
//     XE     : Oscillator function enable
//     XOUT   : Output signal pad for oscillator cell on pad side
//     XC     : Output signal for oscillator cell on core side
//     AIO    : Analog signal
//     AVDD   : Analog power
//     AVSS   : Analog ground
//     VDDESD : ESD macro power
//     VSSESD : ESD macro ground
//
// Notes:
//
// - Super annoying.. none of the IO docs say exactly what SL does. I am
// guessing it "controls slew rate" by enabling higher drive using DS0 and
// DS1. I am turning it on for the pad in output-mode, and I am turning it
// off for the pad in input-mode.

  wire [   0:0] clk;      // input
  wire [  31:0] req_msg;  // input
  wire [   0:0] req_rdy;  // output
  wire [   0:0] req_val;  // input
  wire [   0:0] reset;    // input
  wire [  15:0] resp_msg; // output
  wire [   0:0] resp_rdy; // input
  wire [   0:0] resp_val; // output

  //                 Inst Name            PAD         data

   `INPUT_PAD_H(        clk_pad,      clk_io[0],      clk[0] )
   `INPUT_PAD_H(      reset_pad,    reset_io[0],    reset[0] )

   `INPUT_PAD_H(  req_msg_0_pad,  req_msg_io[0],  req_msg[0] )
   `INPUT_PAD_H(  req_msg_1_pad,  req_msg_io[1],  req_msg[1] )
   `INPUT_PAD_H(  req_msg_2_pad,  req_msg_io[2],  req_msg[2] )
   `INPUT_PAD_H(  req_msg_3_pad,  req_msg_io[3],  req_msg[3] )
   `INPUT_PAD_H(  req_msg_4_pad,  req_msg_io[4],  req_msg[4] )
   `INPUT_PAD_H(  req_msg_5_pad,  req_msg_io[5],  req_msg[5] )

   `INPUT_PAD_V(  req_msg_6_pad,  req_msg_io[6],  req_msg[6] )
   `INPUT_PAD_V(  req_msg_7_pad,  req_msg_io[7],  req_msg[7] )
   `INPUT_PAD_V(  req_msg_8_pad,  req_msg_io[8],  req_msg[8] )
   `INPUT_PAD_V(  req_msg_9_pad,  req_msg_io[9],  req_msg[9] )
   `INPUT_PAD_V( req_msg_10_pad, req_msg_io[10], req_msg[10] )
   `INPUT_PAD_V( req_msg_11_pad, req_msg_io[11], req_msg[11] )
   `INPUT_PAD_V( req_msg_12_pad, req_msg_io[12], req_msg[12] )
   `INPUT_PAD_V( req_msg_13_pad, req_msg_io[13], req_msg[13] )
   `INPUT_PAD_V( req_msg_14_pad, req_msg_io[14], req_msg[14] )
   `INPUT_PAD_V( req_msg_15_pad, req_msg_io[15], req_msg[15] )
   `INPUT_PAD_V( req_msg_16_pad, req_msg_io[16], req_msg[16] )
   `INPUT_PAD_V( req_msg_17_pad, req_msg_io[17], req_msg[17] )
   `INPUT_PAD_V( req_msg_18_pad, req_msg_io[18], req_msg[18] )
   `INPUT_PAD_V( req_msg_19_pad, req_msg_io[19], req_msg[19] )
   `INPUT_PAD_V( req_msg_20_pad, req_msg_io[20], req_msg[20] )
   `INPUT_PAD_V( req_msg_21_pad, req_msg_io[21], req_msg[21] )
   `INPUT_PAD_V( req_msg_22_pad, req_msg_io[22], req_msg[22] )
   `INPUT_PAD_V( req_msg_23_pad, req_msg_io[23], req_msg[23] )
   `INPUT_PAD_V( req_msg_24_pad, req_msg_io[24], req_msg[24] )

   `INPUT_PAD_H( req_msg_25_pad, req_msg_io[25], req_msg[25] )
   `INPUT_PAD_H( req_msg_26_pad, req_msg_io[26], req_msg[26] )
   `INPUT_PAD_H( req_msg_27_pad, req_msg_io[27], req_msg[27] )
   `INPUT_PAD_H( req_msg_28_pad, req_msg_io[28], req_msg[28] )
   `INPUT_PAD_H( req_msg_29_pad, req_msg_io[29], req_msg[29] )
   `INPUT_PAD_H( req_msg_30_pad, req_msg_io[30], req_msg[30] )
   `INPUT_PAD_H( req_msg_31_pad, req_msg_io[31], req_msg[31] )
  `OUTPUT_PAD_H(    req_rdy_pad,  req_rdy_io[0],  req_rdy[0] )

   `INPUT_PAD_V(     req_val_pad,   req_val_io[0],   req_val[0] )
  `OUTPUT_PAD_V(  resp_msg_0_pad,  resp_msg_io[0],  resp_msg[0] )
  `OUTPUT_PAD_V(  resp_msg_1_pad,  resp_msg_io[1],  resp_msg[1] )
  `OUTPUT_PAD_V(  resp_msg_2_pad,  resp_msg_io[2],  resp_msg[2] )
  `OUTPUT_PAD_V(  resp_msg_3_pad,  resp_msg_io[3],  resp_msg[3] )
  `OUTPUT_PAD_V(  resp_msg_4_pad,  resp_msg_io[4],  resp_msg[4] )
  `OUTPUT_PAD_V(  resp_msg_5_pad,  resp_msg_io[5],  resp_msg[5] )
  `OUTPUT_PAD_V(  resp_msg_6_pad,  resp_msg_io[6],  resp_msg[6] )
  `OUTPUT_PAD_V(  resp_msg_7_pad,  resp_msg_io[7],  resp_msg[7] )
  `OUTPUT_PAD_V(  resp_msg_8_pad,  resp_msg_io[8],  resp_msg[8] )
  `OUTPUT_PAD_V(  resp_msg_9_pad,  resp_msg_io[9],  resp_msg[9] )
  `OUTPUT_PAD_V( resp_msg_10_pad, resp_msg_io[10], resp_msg[10] )
  `OUTPUT_PAD_V( resp_msg_11_pad, resp_msg_io[11], resp_msg[11] )
  `OUTPUT_PAD_V( resp_msg_12_pad, resp_msg_io[12], resp_msg[12] )
  `OUTPUT_PAD_V( resp_msg_13_pad, resp_msg_io[13], resp_msg[13] )
  `OUTPUT_PAD_V( resp_msg_14_pad, resp_msg_io[14], resp_msg[14] )
  `OUTPUT_PAD_V( resp_msg_15_pad, resp_msg_io[15], resp_msg[15] )
   `INPUT_PAD_V(    resp_rdy_pad,  resp_rdy_io[0],  resp_rdy[0] )
  `OUTPUT_PAD_V(    resp_val_pad,  resp_val_io[0],  resp_val[0] )

  //----------------------------------------------------------------------
  // Other
  //----------------------------------------------------------------------

  // ctrl temporaries
  wire   [   0:0] ctrl$is_b_zero;
  wire   [   0:0] ctrl$resp_rdy;
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$is_a_lt_b;
  wire   [   0:0] ctrl$req_val;
  wire   [   0:0] ctrl$reset;
  wire   [   1:0] ctrl$a_mux_sel;
  wire   [   0:0] ctrl$resp_val;
  wire   [   0:0] ctrl$b_mux_sel;
  wire   [   0:0] ctrl$b_reg_en;
  wire   [   0:0] ctrl$a_reg_en;
  wire   [   0:0] ctrl$req_rdy;

  GcdUnitCtrlRTL_0x29124399ca008c5e ctrl
  (
    .is_b_zero ( ctrl$is_b_zero ),
    .resp_rdy  ( ctrl$resp_rdy ),
    .clk       ( ctrl$clk ),
    .is_a_lt_b ( ctrl$is_a_lt_b ),
    .req_val   ( ctrl$req_val ),
    .reset     ( ctrl$reset ),
    .a_mux_sel ( ctrl$a_mux_sel ),
    .resp_val  ( ctrl$resp_val ),
    .b_mux_sel ( ctrl$b_mux_sel ),
    .b_reg_en  ( ctrl$b_reg_en ),
    .a_reg_en  ( ctrl$a_reg_en ),
    .req_rdy   ( ctrl$req_rdy )
  );

  // dpath temporaries
  wire   [   1:0] dpath$a_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [  15:0] dpath$req_msg_b;
  wire   [  15:0] dpath$req_msg_a;
  wire   [   0:0] dpath$b_mux_sel;
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$b_reg_en;
  wire   [   0:0] dpath$a_reg_en;
  wire   [   0:0] dpath$is_b_zero;
  wire   [  15:0] dpath$resp_msg;
  wire   [   0:0] dpath$is_a_lt_b;

  GcdUnitDpathRTL_0x29124399ca008c5e dpath
  (
    .a_mux_sel ( dpath$a_mux_sel ),
    .clk       ( dpath$clk ),
    .req_msg_b ( dpath$req_msg_b ),
    .req_msg_a ( dpath$req_msg_a ),
    .b_mux_sel ( dpath$b_mux_sel ),
    .reset     ( dpath$reset ),
    .b_reg_en  ( dpath$b_reg_en ),
    .a_reg_en  ( dpath$a_reg_en ),
    .is_b_zero ( dpath$is_b_zero ),
    .resp_msg  ( dpath$resp_msg ),
    .is_a_lt_b ( dpath$is_a_lt_b )
  );

  // signal connections
  assign ctrl$clk        = clk;
  assign ctrl$is_a_lt_b  = dpath$is_a_lt_b;
  assign ctrl$is_b_zero  = dpath$is_b_zero;
  assign ctrl$req_val    = req_val;
  assign ctrl$reset      = reset;
  assign ctrl$resp_rdy   = resp_rdy;
  assign dpath$a_mux_sel = ctrl$a_mux_sel;
  assign dpath$a_reg_en  = ctrl$a_reg_en;
  assign dpath$b_mux_sel = ctrl$b_mux_sel;
  assign dpath$b_reg_en  = ctrl$b_reg_en;
  assign dpath$clk       = clk;
  assign dpath$req_msg_a = req_msg[31:16];
  assign dpath$req_msg_b = req_msg[15:0];
  assign dpath$reset     = reset;
  assign req_rdy         = ctrl$req_rdy;
  assign resp_msg        = dpath$resp_msg;
  assign resp_val        = ctrl$resp_val;



endmodule // GcdUnit
`default_nettype wire

//-----------------------------------------------------------------------------
// GcdUnitCtrlRTL_0x29124399ca008c5e
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module GcdUnitCtrlRTL_0x29124399ca008c5e
(
  output reg  [   1:0] a_mux_sel,
  output reg  [   0:0] a_reg_en,
  output reg  [   0:0] b_mux_sel,
  output reg  [   0:0] b_reg_en,
  input  wire [   0:0] clk,
  input  wire [   0:0] is_a_lt_b,
  input  wire [   0:0] is_b_zero,
  output reg  [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [   0:0] resp_rdy,
  output reg  [   0:0] resp_val
);

  // register declarations
  reg    [   1:0] curr_state__0;
  reg    [   1:0] current_state__1;
  reg    [   0:0] do_sub;
  reg    [   0:0] do_swap;
  reg    [   1:0] next_state__0;
  reg    [   1:0] state$in_;

  // localparam declarations
  localparam A_MUX_SEL_B = 2;
  localparam A_MUX_SEL_IN = 0;
  localparam A_MUX_SEL_SUB = 1;
  localparam A_MUX_SEL_X = 0;
  localparam B_MUX_SEL_A = 0;
  localparam B_MUX_SEL_IN = 1;
  localparam B_MUX_SEL_X = 0;
  localparam STATE_CALC = 1;
  localparam STATE_DONE = 2;
  localparam STATE_IDLE = 0;

  // state temporaries
  wire   [   0:0] state$reset;
  wire   [   0:0] state$clk;
  wire   [   1:0] state$out;

  RegRst_0x9f365fdf6c8998a state
  (
    .reset ( state$reset ),
    .in_   ( state$in_ ),
    .clk   ( state$clk ),
    .out   ( state$out )
  );

  // signal connections
  assign state$clk   = clk;
  assign state$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transitions():
  //
  //       curr_state = s.state.out
  //       next_state = s.state.out
  //
  //       # Transistions out of IDLE state
  //
  //       if ( curr_state == s.STATE_IDLE ):
  //         if ( s.req_val and s.req_rdy ):
  //           next_state = s.STATE_CALC
  //
  //       # Transistions out of CALC state
  //
  //       if ( curr_state == s.STATE_CALC ):
  //         if ( not s.is_a_lt_b and s.is_b_zero ):
  //           next_state = s.STATE_DONE
  //
  //       # Transistions out of DONE state
  //
  //       if ( curr_state == s.STATE_DONE ):
  //         if ( s.resp_val and s.resp_rdy ):
  //           next_state = s.STATE_IDLE
  //
  //       s.state.in_.value = next_state

  // logic for state_transitions()
  always @ (*) begin
    curr_state__0 = state$out;
    next_state__0 = state$out;
    if ((curr_state__0 == STATE_IDLE)) begin
      if ((req_val&&req_rdy)) begin
        next_state__0 = STATE_CALC;
      end
      else begin
      end
    end
    else begin
    end
    if ((curr_state__0 == STATE_CALC)) begin
      if ((!is_a_lt_b&&is_b_zero)) begin
        next_state__0 = STATE_DONE;
      end
      else begin
      end
    end
    else begin
    end
    if ((curr_state__0 == STATE_DONE)) begin
      if ((resp_val&&resp_rdy)) begin
        next_state__0 = STATE_IDLE;
      end
      else begin
      end
    end
    else begin
    end
    state$in_ = next_state__0;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_outputs():
  //
  //       current_state = s.state.out
  //
  //       # In IDLE state we simply wait for inputs to arrive and latch them
  //
  //       if current_state == s.STATE_IDLE:
  //         s.req_rdy.value   = 1
  //         s.resp_val.value  = 0
  //         s.a_mux_sel.value = A_MUX_SEL_IN
  //         s.a_reg_en.value  = 1
  //         s.b_mux_sel.value = B_MUX_SEL_IN
  //         s.b_reg_en.value  = 1
  //
  //       # In CALC state we iteratively swap/sub to calculate GCD
  //
  //       elif current_state == s.STATE_CALC:
  //
  //         s.do_swap.value = s.is_a_lt_b
  //         s.do_sub.value  = ~s.is_b_zero
  //
  //         s.req_rdy.value   = 0
  //         s.resp_val.value  = 0
  //         s.a_mux_sel.value = A_MUX_SEL_B if s.do_swap else A_MUX_SEL_SUB
  //         s.a_reg_en.value  = 1
  //         s.b_mux_sel.value = B_MUX_SEL_A
  //         s.b_reg_en.value  = s.do_swap
  //
  //       # In DONE state we simply wait for output transaction to occur
  //
  //       elif current_state == s.STATE_DONE:
  //         s.req_rdy.value   = 0
  //         s.resp_val.value  = 1
  //         s.a_mux_sel.value = A_MUX_SEL_X
  //         s.a_reg_en.value  = 0
  //         s.b_mux_sel.value = B_MUX_SEL_X
  //         s.b_reg_en.value  = 0

  // logic for state_outputs()
  always @ (*) begin
    current_state__1 = state$out;
    if ((current_state__1 == STATE_IDLE)) begin
      req_rdy = 1;
      resp_val = 0;
      a_mux_sel = A_MUX_SEL_IN;
      a_reg_en = 1;
      b_mux_sel = B_MUX_SEL_IN;
      b_reg_en = 1;
    end
    else begin
      if ((current_state__1 == STATE_CALC)) begin
        do_swap = is_a_lt_b;
        do_sub = ~is_b_zero;
        req_rdy = 0;
        resp_val = 0;
        a_mux_sel = do_swap ? A_MUX_SEL_B : A_MUX_SEL_SUB;
        a_reg_en = 1;
        b_mux_sel = B_MUX_SEL_A;
        b_reg_en = do_swap;
      end
      else begin
        if ((current_state__1 == STATE_DONE)) begin
          req_rdy = 0;
          resp_val = 1;
          a_mux_sel = A_MUX_SEL_X;
          a_reg_en = 0;
          b_mux_sel = B_MUX_SEL_X;
          b_reg_en = 0;
        end
        else begin
        end
      end
    end
  end


endmodule // GcdUnitCtrlRTL_0x29124399ca008c5e
`default_nettype wire

//-----------------------------------------------------------------------------
// RegRst_0x9f365fdf6c8998a
//-----------------------------------------------------------------------------
// dtype: 2
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegRst_0x9f365fdf6c8998a
(
  input  wire [   0:0] clk,
  input  wire [   1:0] in_,
  output reg  [   1:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam reset_value = 0;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       if s.reset:
  //         s.out.next = reset_value
  //       else:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      out <= in_;
    end
  end


endmodule // RegRst_0x9f365fdf6c8998a
`default_nettype wire

//-----------------------------------------------------------------------------
// GcdUnitDpathRTL_0x29124399ca008c5e
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module GcdUnitDpathRTL_0x29124399ca008c5e
(
  input  wire [   1:0] a_mux_sel,
  input  wire [   0:0] a_reg_en,
  input  wire [   0:0] b_mux_sel,
  input  wire [   0:0] b_reg_en,
  input  wire [   0:0] clk,
  output wire [   0:0] is_a_lt_b,
  output wire [   0:0] is_b_zero,
  input  wire [  15:0] req_msg_a,
  input  wire [  15:0] req_msg_b,
  input  wire [   0:0] reset,
  output wire [  15:0] resp_msg
);

  // wire declarations
  wire   [  15:0] sub_out;
  wire   [  15:0] b_reg_out;


  // a_reg temporaries
  wire   [   0:0] a_reg$reset;
  wire   [  15:0] a_reg$in_;
  wire   [   0:0] a_reg$clk;
  wire   [   0:0] a_reg$en;
  wire   [  15:0] a_reg$out;

  RegEn_0x68db79c4ec1d6e5b a_reg
  (
    .reset ( a_reg$reset ),
    .in_   ( a_reg$in_ ),
    .clk   ( a_reg$clk ),
    .en    ( a_reg$en ),
    .out   ( a_reg$out )
  );

  // a_lt_b temporaries
  wire   [   0:0] a_lt_b$reset;
  wire   [   0:0] a_lt_b$clk;
  wire   [  15:0] a_lt_b$in0;
  wire   [  15:0] a_lt_b$in1;
  wire   [   0:0] a_lt_b$out;

  LtComparator_0x422b1f52edd46a85 a_lt_b
  (
    .reset ( a_lt_b$reset ),
    .clk   ( a_lt_b$clk ),
    .in0   ( a_lt_b$in0 ),
    .in1   ( a_lt_b$in1 ),
    .out   ( a_lt_b$out )
  );

  // b_zero temporaries
  wire   [   0:0] b_zero$reset;
  wire   [  15:0] b_zero$in_;
  wire   [   0:0] b_zero$clk;
  wire   [   0:0] b_zero$out;

  ZeroComparator_0x422b1f52edd46a85 b_zero
  (
    .reset ( b_zero$reset ),
    .in_   ( b_zero$in_ ),
    .clk   ( b_zero$clk ),
    .out   ( b_zero$out )
  );

  // a_mux temporaries
  wire   [   0:0] a_mux$reset;
  wire   [  15:0] a_mux$in_$000;
  wire   [  15:0] a_mux$in_$001;
  wire   [  15:0] a_mux$in_$002;
  wire   [   0:0] a_mux$clk;
  wire   [   1:0] a_mux$sel;
  wire   [  15:0] a_mux$out;

  Mux_0x683fa1a418b072c9 a_mux
  (
    .reset   ( a_mux$reset ),
    .in_$000 ( a_mux$in_$000 ),
    .in_$001 ( a_mux$in_$001 ),
    .in_$002 ( a_mux$in_$002 ),
    .clk     ( a_mux$clk ),
    .sel     ( a_mux$sel ),
    .out     ( a_mux$out )
  );

  // b_mux temporaries
  wire   [   0:0] b_mux$reset;
  wire   [  15:0] b_mux$in_$000;
  wire   [  15:0] b_mux$in_$001;
  wire   [   0:0] b_mux$clk;
  wire   [   0:0] b_mux$sel;
  wire   [  15:0] b_mux$out;

  Mux_0xdd6473406d1a99a b_mux
  (
    .reset   ( b_mux$reset ),
    .in_$000 ( b_mux$in_$000 ),
    .in_$001 ( b_mux$in_$001 ),
    .clk     ( b_mux$clk ),
    .sel     ( b_mux$sel ),
    .out     ( b_mux$out )
  );

  // sub temporaries
  wire   [   0:0] sub$reset;
  wire   [   0:0] sub$clk;
  wire   [  15:0] sub$in0;
  wire   [  15:0] sub$in1;
  wire   [  15:0] sub$out;

  Subtractor_0x422b1f52edd46a85 sub
  (
    .reset ( sub$reset ),
    .clk   ( sub$clk ),
    .in0   ( sub$in0 ),
    .in1   ( sub$in1 ),
    .out   ( sub$out )
  );

  // b_reg temporaries
  wire   [   0:0] b_reg$reset;
  wire   [  15:0] b_reg$in_;
  wire   [   0:0] b_reg$clk;
  wire   [   0:0] b_reg$en;
  wire   [  15:0] b_reg$out;

  RegEn_0x68db79c4ec1d6e5b b_reg
  (
    .reset ( b_reg$reset ),
    .in_   ( b_reg$in_ ),
    .clk   ( b_reg$clk ),
    .en    ( b_reg$en ),
    .out   ( b_reg$out )
  );

  // signal connections
  assign a_lt_b$clk    = clk;
  assign a_lt_b$in0    = a_reg$out;
  assign a_lt_b$in1    = b_reg$out;
  assign a_lt_b$reset  = reset;
  assign a_mux$clk     = clk;
  assign a_mux$in_$000 = req_msg_a;
  assign a_mux$in_$001 = sub_out;
  assign a_mux$in_$002 = b_reg_out;
  assign a_mux$reset   = reset;
  assign a_mux$sel     = a_mux_sel;
  assign a_reg$clk     = clk;
  assign a_reg$en      = a_reg_en;
  assign a_reg$in_     = a_mux$out;
  assign a_reg$reset   = reset;
  assign b_mux$clk     = clk;
  assign b_mux$in_$000 = a_reg$out;
  assign b_mux$in_$001 = req_msg_b;
  assign b_mux$reset   = reset;
  assign b_mux$sel     = b_mux_sel;
  assign b_reg$clk     = clk;
  assign b_reg$en      = b_reg_en;
  assign b_reg$in_     = b_mux$out;
  assign b_reg$reset   = reset;
  assign b_reg_out     = b_reg$out;
  assign b_zero$clk    = clk;
  assign b_zero$in_    = b_reg$out;
  assign b_zero$reset  = reset;
  assign is_a_lt_b     = a_lt_b$out;
  assign is_b_zero     = b_zero$out;
  assign resp_msg      = sub$out;
  assign sub$clk       = clk;
  assign sub$in0       = a_reg$out;
  assign sub$in1       = b_reg$out;
  assign sub$reset     = reset;
  assign sub_out       = sub$out;



endmodule // GcdUnitDpathRTL_0x29124399ca008c5e
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x68db79c4ec1d6e5b
//-----------------------------------------------------------------------------
// dtype: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x68db79c4ec1d6e5b
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  15:0] in_,
  output reg  [  15:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       if s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (en) begin
      out <= in_;
    end
    else begin
    end
  end


endmodule // RegEn_0x68db79c4ec1d6e5b
`default_nettype wire

//-----------------------------------------------------------------------------
// LtComparator_0x422b1f52edd46a85
//-----------------------------------------------------------------------------
// nbits: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module LtComparator_0x422b1f52edd46a85
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in0,
  input  wire [  15:0] in1,
  output reg  [   0:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in0 < s.in1

  // logic for comb_logic()
  always @ (*) begin
    out = (in0 < in1);
  end


endmodule // LtComparator_0x422b1f52edd46a85
`default_nettype wire

//-----------------------------------------------------------------------------
// ZeroComparator_0x422b1f52edd46a85
//-----------------------------------------------------------------------------
// nbits: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ZeroComparator_0x422b1f52edd46a85
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_,
  output reg  [   0:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ == 0

  // logic for comb_logic()
  always @ (*) begin
    out = (in_ == 0);
  end


endmodule // ZeroComparator_0x422b1f52edd46a85
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x683fa1a418b072c9
//-----------------------------------------------------------------------------
// dtype: 16
// nports: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x683fa1a418b072c9
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_$000,
  input  wire [  15:0] in_$001,
  input  wire [  15:0] in_$002,
  output reg  [  15:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] sel
);

  // localparam declarations
  localparam nports = 3;


  // array declarations
  wire   [  15:0] in_[0:2];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       assert s.sel < nports
  //       s.out.v = s.in_[ s.sel ]

  // logic for comb_logic()
  always @ (*) begin
    out = in_[sel];
  end


endmodule // Mux_0x683fa1a418b072c9
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0xdd6473406d1a99a
//-----------------------------------------------------------------------------
// dtype: 16
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0xdd6473406d1a99a
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_$000,
  input  wire [  15:0] in_$001,
  output reg  [  15:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  15:0] in_[0:1];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       assert s.sel < nports
  //       s.out.v = s.in_[ s.sel ]

  // logic for comb_logic()
  always @ (*) begin
    out = in_[sel];
  end


endmodule // Mux_0xdd6473406d1a99a
`default_nettype wire

//-----------------------------------------------------------------------------
// Subtractor_0x422b1f52edd46a85
//-----------------------------------------------------------------------------
// nbits: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Subtractor_0x422b1f52edd46a85
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in0,
  input  wire [  15:0] in1,
  output reg  [  15:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in0 - s.in1

  // logic for comb_logic()
  always @ (*) begin
    out = (in0-in1);
  end


endmodule // Subtractor_0x422b1f52edd46a85
`default_nettype wire

