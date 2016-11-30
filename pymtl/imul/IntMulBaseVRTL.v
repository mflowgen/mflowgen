//========================================================================
// Integer Multiplier Fixed-Latency Implementation
//========================================================================

`ifndef LAB1_IMUL_INT_MUL_BASE_V
`define LAB1_IMUL_INT_MUL_BASE_V

`include "vc/trace.v"

// ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Define datapath and control unit here.
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

`include "vc/counters.v"
`include "vc/muxes.v"
`include "vc/regs.v"
`include "vc/arithmetic.v"

//========================================================================
// Integer Multiplier Fixed-Latency Datapath
//========================================================================

module lab1_imul_IntMulBaseDpathRTL
(
  input  logic        clk,
  input  logic        reset,

  // Data signals

  input  logic [31:0] req_msg_a,
  input  logic [31:0] req_msg_b,
  output logic [31:0] resp_msg,

  // Control signals (ctrl -> dpath)

  input  logic        a_mux_sel,
  input  logic        b_mux_sel,
  input  logic        result_mux_sel,
  input  logic        result_reg_en,
  input  logic        add_mux_sel,

  // Status signals (dpath -> ctrl)

  output logic        b_lsb
);

  // B mux

  logic [31:0] rshifter_out;
  logic [31:0] b_mux_out;

  vc_Mux2#(32) b_mux
  (
    .sel   (b_mux_sel),
    .in0   (rshifter_out),
    .in1   (req_msg_b),
    .out   (b_mux_out)
  );

  // B register

  logic [31:0] b_reg_out;

  vc_Reg#(32) b_reg
  (
    .clk   (clk),
    .d     (b_mux_out),
    .q     (b_reg_out)
  );

  // Right shifter

  vc_RightLogicalShifter#(32,1) rshifter
  (
    .in    (b_reg_out),
    .shamt (1'b1),
    .out   (rshifter_out)
  );

  // A mux

  logic [31:0] lshifter_out;
  logic [31:0] a_mux_out;

  vc_Mux2#(32) a_mux
  (
    .sel   (a_mux_sel),
    .in0   (lshifter_out),
    .in1   (req_msg_a),
    .out   (a_mux_out)
  );

  // A register

  logic [31:0] a_reg_out;

  vc_Reg#(32) a_reg
  (
    .clk   (clk),
    .d     (a_mux_out),
    .q     (a_reg_out)
  );

  // Left shifter

  vc_LeftLogicalShifter#(32,1) lshifter
  (
    .in    (a_reg_out),
    .shamt (1'b1),
    .out   (lshifter_out)
  );

  // Result mux

  logic [31:0] add_mux_out;
  logic [31:0] result_mux_out;

  vc_Mux2#(32) result_mux
  (
    .sel   (result_mux_sel),
    .in0   (add_mux_out),
    .in1   (32'b0),
    .out   (result_mux_out)
  );

  // Result register

  logic [31:0] result_reg_out;

  vc_EnReg#(32) result_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (result_reg_en),
    .d     (result_mux_out),
    .q     (result_reg_out)
  );

  // Adder

  logic [31:0] add_out;

  vc_SimpleAdder#(32) add
  (
    .in0   (a_reg_out),
    .in1   (result_reg_out),
    .out   (add_out)
  );

  // Add mux

  vc_Mux2#(32) add_mux
  (
    .sel   (add_mux_sel),
    .in0   (add_out),
    .in1   (result_reg_out),
    .out   (add_mux_out)
  );

  // Status signals

  assign b_lsb = b_reg_out[0];

  // Connect to output port

  assign resp_msg = result_reg_out;

endmodule

//========================================================================
// Integer Multiplier Fixed-Latency Control Unit
//========================================================================

module lab1_imul_IntMulBaseCtrlRTL
(
  input  logic clk,
  input  logic reset,

  // Dataflow signals

  input  logic req_val,
  output logic req_rdy,

  output logic resp_val,
  input  logic resp_rdy,

  // Control signals (ctrl -> dpath)

  output logic a_mux_sel,
  output logic b_mux_sel,
  output logic result_mux_sel,
  output logic result_reg_en,
  output logic add_mux_sel,

  // Status signals (dpath -> ctrl)

  input  logic b_lsb
);

  //----------------------------------------------------------------------
  // State
  //----------------------------------------------------------------------

  typedef enum logic [$clog2(3)-1:0] {
    STATE_IDLE,
    STATE_CALC,
    STATE_DONE
  } state_t;

  state_t state_reg;
  state_t state_next;

  always_ff @( posedge clk ) begin
    if ( reset )
      state_reg <= STATE_IDLE;
    else
      state_reg <= state_next;
  end

  //----------------------------------------------------------------------
  // Counter
  //----------------------------------------------------------------------

  logic       counter_reset;
  logic       counter_increment;
  logic [5:0] counter_count;
  logic       counter_count_is_zero;
  logic       counter_count_is_max;

  vc_BasicCounter#(6,0,32) counter
  (
    .clk           (clk),
    .reset         (counter_reset),
    .clear         (1'b0),
    .increment     (counter_increment),
    .decrement     (1'b0),
    .count         (counter_count),
    .count_is_zero (counter_count_is_zero),
    .count_is_max  (counter_count_is_max)
  );

  //----------------------------------------------------------------------
  // State Transitions
  //----------------------------------------------------------------------

  logic req_go, resp_go, is_calc_done;

  assign req_go       = req_val  && req_rdy;
  assign resp_go      = resp_val && resp_rdy;
  assign is_calc_done = counter_count_is_max;

  always_comb begin

    state_next = state_reg;

    case ( state_reg )

      STATE_IDLE: if ( req_go       ) state_next = STATE_CALC;
      STATE_CALC: if ( is_calc_done ) state_next = STATE_DONE;
      STATE_DONE: if ( resp_go      ) state_next = STATE_IDLE;
      default:                        state_next = 'x;

    endcase

  end

  //----------------------------------------------------------------------
  // State Outputs
  //----------------------------------------------------------------------

  localparam a_x     = 1'dx;
  localparam a_rsh   = 1'd0;
  localparam a_ld    = 1'd1;

  localparam b_x     = 1'dx;
  localparam b_lsh   = 1'd0;
  localparam b_ld    = 1'd1;

  localparam res_x   = 1'dx;
  localparam res_add = 1'd0;
  localparam res_0   = 1'd1;

  localparam add_x   = 1'dx;
  localparam add_add = 1'd0;
  localparam add_res = 1'd1;

  task cs
  (
    input cs_req_rdy,
    input cs_resp_val,
    input cs_a_mux_sel,
    input cs_b_mux_sel,
    input cs_result_mux_sel,
    input cs_result_reg_en,
    input cs_add_mux_sel,
    input cs_counter_reset,
    input cs_counter_increment
  );
  begin
    req_rdy           = cs_req_rdy;
    resp_val          = cs_resp_val;
    a_mux_sel         = cs_a_mux_sel;
    b_mux_sel         = cs_b_mux_sel;
    result_mux_sel    = cs_result_mux_sel;
    result_reg_en     = cs_result_reg_en;
    add_mux_sel       = cs_add_mux_sel;
    counter_reset     = cs_counter_reset;
    counter_increment = cs_counter_increment;
  end
  endtask

  // Labels for Mealy transistions

  logic do_sh_add, do_sh;

  assign do_sh_add = (b_lsb == 1); // do shift and add
  assign do_sh     = (b_lsb == 0); // do shift but no add

  // Set outputs using a control signal "table"

  always_comb begin

    case ( state_reg )

 //                             req resp a mux  b mux  res mux  res add mux  cntr cntr
 //                             rdy val  sel    sel    sel      en  sel      rst  inc
 STATE_IDLE:                cs( 1,  0,   a_ld,  b_ld,  res_0,   1,  add_x,   1,   0 );
 STATE_CALC: if (do_sh_add) cs( 0,  0,   a_rsh, b_lsh, res_add, 1,  add_add, 0,   1 );
        else if (do_sh    ) cs( 0,  0,   a_rsh, b_lsh, res_add, 1,  add_res, 0,   1 );
 STATE_DONE:                cs( 0,  1,   a_x,   b_x,   res_x,   0,  add_x,   1,   0 );
 default:                   cs('x, 'x,   a_x,   b_x,   res_x,  'x,  add_x,  'x,  'x );

    endcase

  end

endmodule

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

//========================================================================
// Integer Multiplier Fixed-Latency Implementation
//========================================================================

module lab1_imul_IntMulBaseVRTL
(
  input  logic        clk,
  input  logic        reset,

  input  logic        req_val,
  output logic        req_rdy,
  input  logic [63:0] req_msg,

  output logic        resp_val,
  input  logic        resp_rdy,
  output logic [31:0] resp_msg
);

  // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Instantiate datapath and control models here and then connect them
  // together.
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  // Control signals

  logic a_mux_sel;
  logic b_mux_sel;
  logic result_mux_sel;
  logic result_reg_en;
  logic add_mux_sel;

  // Status signals

  logic b_lsb;

  // Instantiate and connect datapath

  lab1_imul_IntMulBaseDpathRTL dpath
  (
    .req_msg_a (req_msg[63:32]),
    .req_msg_b (req_msg[31: 0]),
    .*
  );

  // Instantiate and connect control unit

  lab1_imul_IntMulBaseCtrlRTL ctrl
  (
    .*
  );

  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin

    $sformat( str, "%x", req_msg );
    vc_trace.append_val_rdy_str( trace_str, req_val, req_rdy, str );

    vc_trace.append_str( trace_str, "(" );

    // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // Add additional line tracing using the helper tasks for
    // internal state including the current FSM state.
    // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

    $sformat( str, "%x", dpath.a_reg_out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    $sformat( str, "%x", dpath.b_reg_out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    $sformat( str, "%x", dpath.result_reg_out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    case ( ctrl.state_reg )

      ctrl.STATE_IDLE:
        vc_trace.append_str( trace_str, "I " );

      ctrl.STATE_CALC:
      begin
        if ( ctrl.do_sh_add )
          vc_trace.append_str( trace_str, "C+" );
        else if ( ctrl.do_sh )
          vc_trace.append_str( trace_str, "C " );
        else
          vc_trace.append_str( trace_str, "C?" );
      end

      ctrl.STATE_DONE:
        vc_trace.append_str( trace_str, "D " );

      default:
        vc_trace.append_str( trace_str, "? " );

    endcase

    // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

    vc_trace.append_str( trace_str, ")" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* LAB1_IMUL_INT_MUL_BASE_V */

