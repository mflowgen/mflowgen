//-----------------------------------------------------------------------------
// ProcL0Mdu
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcL0Mdu
(
  input  wire [   0:0] clk,
  output wire [   0:0] commit_inst,
  output wire [  77:0] dmemreq_msg,
  input  wire [   0:0] dmemreq_rdy,
  output wire [   0:0] dmemreq_val,
  input  wire [  47:0] dmemresp_msg,
  output wire [   0:0] dmemresp_rdy,
  input  wire [   0:0] dmemresp_val,
  output wire [ 304:0] imemreq_msg,
  input  wire [   0:0] imemreq_rdy,
  output wire [   0:0] imemreq_val,
  input  wire [ 274:0] imemresp_msg,
  output wire [   0:0] imemresp_rdy,
  input  wire [   0:0] imemresp_val,
  input  wire [  31:0] mngr2proc_msg,
  output wire [   0:0] mngr2proc_rdy,
  input  wire [   0:0] mngr2proc_val,
  output wire [  31:0] proc2mngr_msg,
  input  wire [   0:0] proc2mngr_rdy,
  output wire [   0:0] proc2mngr_val,
  input  wire [   0:0] reset,
  output wire [   0:0] stats_en
);

  // mdu temporaries
  wire   [   0:0] mdu$resp_rdy;
  wire   [   0:0] mdu$clk;
  wire   [  69:0] mdu$req_msg;
  wire   [   0:0] mdu$req_val;
  wire   [   0:0] mdu$reset;
  wire   [  34:0] mdu$resp_msg;
  wire   [   0:0] mdu$resp_val;
  wire   [   0:0] mdu$req_rdy;

  IntMulDivUnit mdu
  (
    .resp_rdy ( mdu$resp_rdy ),
    .clk      ( mdu$clk ),
    .req_msg  ( mdu$req_msg ),
    .req_val  ( mdu$req_val ),
    .reset    ( mdu$reset ),
    .resp_msg ( mdu$resp_msg ),
    .resp_val ( mdu$resp_val ),
    .req_rdy  ( mdu$req_rdy )
  );

  // l0i temporaries
  wire   [ 274:0] l0i$memresp_msg;
  wire   [   0:0] l0i$memresp_val;
  wire   [   0:0] l0i$clk;
  wire   [   0:0] l0i$buffresp_rdy;
  wire   [   0:0] l0i$reset;
  wire   [   0:0] l0i$memreq_rdy;
  wire   [  77:0] l0i$buffreq_msg;
  wire   [   0:0] l0i$buffreq_val;
  wire   [   0:0] l0i$memresp_rdy;
  wire   [  47:0] l0i$buffresp_msg;
  wire   [   0:0] l0i$buffresp_val;
  wire   [ 304:0] l0i$memreq_msg;
  wire   [   0:0] l0i$memreq_val;
  wire   [   0:0] l0i$buffreq_rdy;

  InstBuffer_2_32B l0i
  (
    .memresp_msg  ( l0i$memresp_msg ),
    .memresp_val  ( l0i$memresp_val ),
    .clk          ( l0i$clk ),
    .buffresp_rdy ( l0i$buffresp_rdy ),
    .reset        ( l0i$reset ),
    .memreq_rdy   ( l0i$memreq_rdy ),
    .buffreq_msg  ( l0i$buffreq_msg ),
    .buffreq_val  ( l0i$buffreq_val ),
    .memresp_rdy  ( l0i$memresp_rdy ),
    .buffresp_msg ( l0i$buffresp_msg ),
    .buffresp_val ( l0i$buffresp_val ),
    .memreq_msg   ( l0i$memreq_msg ),
    .memreq_val   ( l0i$memreq_val ),
    .buffreq_rdy  ( l0i$buffreq_rdy )
  );

  // proc temporaries
  wire   [   0:0] proc$dmemreq_rdy;
  wire   [   0:0] proc$xcelreq_rdy;
  wire   [  34:0] proc$mduresp_msg;
  wire   [   0:0] proc$mduresp_val;
  wire   [   0:0] proc$imemreq_rdy;
  wire   [  47:0] proc$dmemresp_msg;
  wire   [   0:0] proc$dmemresp_val;
  wire   [   0:0] proc$clk;
  wire   [   0:0] proc$proc2mngr_rdy;
  wire   [  47:0] proc$imemresp_msg;
  wire   [   0:0] proc$imemresp_val;
  wire   [   0:0] proc$reset;
  wire   [  32:0] proc$xcelresp_msg;
  wire   [   0:0] proc$xcelresp_val;
  wire   [  31:0] proc$core_id;
  wire   [   0:0] proc$mdureq_rdy;
  wire   [  31:0] proc$mngr2proc_msg;
  wire   [   0:0] proc$mngr2proc_val;
  wire   [  77:0] proc$dmemreq_msg;
  wire   [   0:0] proc$dmemreq_val;
  wire   [  37:0] proc$xcelreq_msg;
  wire   [   0:0] proc$xcelreq_val;
  wire   [   0:0] proc$commit_inst;
  wire   [   0:0] proc$mduresp_rdy;
  wire   [  77:0] proc$imemreq_msg;
  wire   [   0:0] proc$imemreq_val;
  wire   [   0:0] proc$dmemresp_rdy;
  wire   [  31:0] proc$proc2mngr_msg;
  wire   [   0:0] proc$proc2mngr_val;
  wire   [   0:0] proc$imemresp_rdy;
  wire   [   0:0] proc$xcelresp_rdy;
  wire   [  69:0] proc$mdureq_msg;
  wire   [   0:0] proc$mdureq_val;
  wire   [   0:0] proc$mngr2proc_rdy;
  wire   [   0:0] proc$stats_en;

  ProcPRTL_0x2243624498be9761 proc
  (
    .dmemreq_rdy   ( proc$dmemreq_rdy ),
    .xcelreq_rdy   ( proc$xcelreq_rdy ),
    .mduresp_msg   ( proc$mduresp_msg ),
    .mduresp_val   ( proc$mduresp_val ),
    .imemreq_rdy   ( proc$imemreq_rdy ),
    .dmemresp_msg  ( proc$dmemresp_msg ),
    .dmemresp_val  ( proc$dmemresp_val ),
    .clk           ( proc$clk ),
    .proc2mngr_rdy ( proc$proc2mngr_rdy ),
    .imemresp_msg  ( proc$imemresp_msg ),
    .imemresp_val  ( proc$imemresp_val ),
    .reset         ( proc$reset ),
    .xcelresp_msg  ( proc$xcelresp_msg ),
    .xcelresp_val  ( proc$xcelresp_val ),
    .core_id       ( proc$core_id ),
    .mdureq_rdy    ( proc$mdureq_rdy ),
    .mngr2proc_msg ( proc$mngr2proc_msg ),
    .mngr2proc_val ( proc$mngr2proc_val ),
    .dmemreq_msg   ( proc$dmemreq_msg ),
    .dmemreq_val   ( proc$dmemreq_val ),
    .xcelreq_msg   ( proc$xcelreq_msg ),
    .xcelreq_val   ( proc$xcelreq_val ),
    .commit_inst   ( proc$commit_inst ),
    .mduresp_rdy   ( proc$mduresp_rdy ),
    .imemreq_msg   ( proc$imemreq_msg ),
    .imemreq_val   ( proc$imemreq_val ),
    .dmemresp_rdy  ( proc$dmemresp_rdy ),
    .proc2mngr_msg ( proc$proc2mngr_msg ),
    .proc2mngr_val ( proc$proc2mngr_val ),
    .imemresp_rdy  ( proc$imemresp_rdy ),
    .xcelresp_rdy  ( proc$xcelresp_rdy ),
    .mdureq_msg    ( proc$mdureq_msg ),
    .mdureq_val    ( proc$mdureq_val ),
    .mngr2proc_rdy ( proc$mngr2proc_rdy ),
    .stats_en      ( proc$stats_en )
  );

  // signal connections
  assign commit_inst        = proc$commit_inst;
  assign dmemreq_msg        = proc$dmemreq_msg;
  assign dmemreq_val        = proc$dmemreq_val;
  assign dmemresp_rdy       = proc$dmemresp_rdy;
  assign imemreq_msg        = l0i$memreq_msg;
  assign imemreq_val        = l0i$memreq_val;
  assign imemresp_rdy       = l0i$memresp_rdy;
  assign l0i$buffreq_msg    = proc$imemreq_msg;
  assign l0i$buffreq_val    = proc$imemreq_val;
  assign l0i$buffresp_rdy   = proc$imemresp_rdy;
  assign l0i$clk            = clk;
  assign l0i$memreq_rdy     = imemreq_rdy;
  assign l0i$memresp_msg    = imemresp_msg;
  assign l0i$memresp_val    = imemresp_val;
  assign l0i$reset          = reset;
  assign mdu$clk            = clk;
  assign mdu$req_msg        = proc$mdureq_msg;
  assign mdu$req_val        = proc$mdureq_val;
  assign mdu$reset          = reset;
  assign mdu$resp_rdy       = proc$mduresp_rdy;
  assign mngr2proc_rdy      = proc$mngr2proc_rdy;
  assign proc$clk           = clk;
  assign proc$core_id       = 32'd0;
  assign proc$dmemreq_rdy   = dmemreq_rdy;
  assign proc$dmemresp_msg  = dmemresp_msg;
  assign proc$dmemresp_val  = dmemresp_val;
  assign proc$imemreq_rdy   = l0i$buffreq_rdy;
  assign proc$imemresp_msg  = l0i$buffresp_msg;
  assign proc$imemresp_val  = l0i$buffresp_val;
  assign proc$mdureq_rdy    = mdu$req_rdy;
  assign proc$mduresp_msg   = mdu$resp_msg;
  assign proc$mduresp_val   = mdu$resp_val;
  assign proc$mngr2proc_msg = mngr2proc_msg;
  assign proc$mngr2proc_val = mngr2proc_val;
  assign proc$proc2mngr_rdy = proc2mngr_rdy;
  assign proc$reset         = reset;
  assign proc2mngr_msg      = proc$proc2mngr_msg;
  assign proc2mngr_val      = proc$proc2mngr_val;
  assign stats_en           = proc$stats_en;



endmodule // ProcL0Mdu
`default_nettype wire

//-----------------------------------------------------------------------------
// IntMulDivUnit
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulDivUnit
(
  input  wire [   0:0] clk,
  input  wire [  69:0] req_msg,
  output reg  [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  output reg  [  34:0] resp_msg,
  input  wire [   0:0] resp_rdy,
  output reg  [   0:0] resp_val
);

  // wire declarations
  wire   [   0:0] is_div;


  // register declarations
  reg    [   0:0] idiv$req_val;
  reg    [   0:0] idiv$resp_rdy;
  reg    [   0:0] imul$req_val;

  // imul temporaries
  wire   [   0:0] imul$resp_rdy;
  wire   [   0:0] imul$clk;
  wire   [  69:0] imul$req_msg;
  wire   [   0:0] imul$reset;
  wire   [  34:0] imul$resp_msg;
  wire   [   0:0] imul$resp_val;
  wire   [   0:0] imul$req_rdy;

  IntMulVarLat_0x4fa87c8a5af4e991 imul
  (
    .resp_rdy ( imul$resp_rdy ),
    .clk      ( imul$clk ),
    .req_msg  ( imul$req_msg ),
    .req_val  ( imul$req_val ),
    .reset    ( imul$reset ),
    .resp_msg ( imul$resp_msg ),
    .resp_val ( imul$resp_val ),
    .req_rdy  ( imul$req_rdy )
  );

  // idiv temporaries
  wire   [   0:0] idiv$clk;
  wire   [  69:0] idiv$req_msg;
  wire   [   0:0] idiv$reset;
  wire   [  34:0] idiv$resp_msg;
  wire   [   0:0] idiv$resp_val;
  wire   [   0:0] idiv$req_rdy;

  IntDivRem4_0x18c371d1cf60a588 idiv
  (
    .resp_rdy ( idiv$resp_rdy ),
    .clk      ( idiv$clk ),
    .req_msg  ( idiv$req_msg ),
    .req_val  ( idiv$req_val ),
    .reset    ( idiv$reset ),
    .resp_msg ( idiv$resp_msg ),
    .resp_val ( idiv$resp_val ),
    .req_rdy  ( idiv$req_rdy )
  );

  // signal connections
  assign idiv$clk      = clk;
  assign idiv$req_msg  = req_msg;
  assign idiv$reset    = reset;
  assign imul$clk      = clk;
  assign imul$req_msg  = req_msg;
  assign imul$reset    = reset;
  assign imul$resp_rdy = resp_rdy;
  assign is_div        = req_msg[69];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_val():
  //       s.imul.req.val.value = s.req.val & ~s.is_div
  //       s.idiv.req.val.value = s.req.val & s.is_div

  // logic for comb_in_val()
  always @ (*) begin
    imul$req_val = (req_val&~is_div);
    idiv$req_val = (req_val&is_div);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       if ~s.is_div:
  //         s.req.rdy.value = s.imul.req.rdy
  //       else:
  //         s.req.rdy.value = s.idiv.req.rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    if (~is_div) begin
      req_rdy = imul$req_rdy;
    end
    else begin
      req_rdy = idiv$req_rdy;
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_out_rdy():
  //       s.idiv.resp.rdy.value = 0
  //
  //       if ~s.imul.resp.val:
  //         s.idiv.resp.rdy.value = s.resp.rdy

  // logic for comb_out_rdy()
  always @ (*) begin
    idiv$resp_rdy = 0;
    if (~imul$resp_val) begin
      idiv$resp_rdy = resp_rdy;
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_out_val_msg():
  //       s.resp.val.value = s.imul.resp.val
  //       s.resp.msg.value = s.imul.resp.msg
  //
  //       if ~s.imul.resp.val:
  //         s.resp.val.value = s.idiv.resp.val
  //         s.resp.msg.value = s.idiv.resp.msg

  // logic for comb_out_val_msg()
  always @ (*) begin
    resp_val = imul$resp_val;
    resp_msg = imul$resp_msg;
    if (~imul$resp_val) begin
      resp_val = idiv$resp_val;
      resp_msg = idiv$resp_msg;
    end
    else begin
    end
  end


endmodule // IntMulDivUnit
`default_nettype wire

//-----------------------------------------------------------------------------
// IntMulVarLat_0x4fa87c8a5af4e991
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulVarLat_0x4fa87c8a5af4e991
(
  input  wire [   0:0] clk,
  input  wire [  69:0] req_msg,
  output wire [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  output wire [  34:0] resp_msg,
  input  wire [   0:0] resp_rdy,
  output wire [   0:0] resp_val
);

  // ctrl temporaries
  wire   [   0:0] ctrl$is_b_zero;
  wire   [   0:0] ctrl$resp_rdy;
  wire   [   0:0] ctrl$clk;
  wire   [   2:0] ctrl$req_type;
  wire   [   0:0] ctrl$req_val;
  wire   [   0:0] ctrl$b_lsb;
  wire   [   0:0] ctrl$reset;
  wire   [   1:0] ctrl$a_mux_sel;
  wire   [   0:0] ctrl$resp_val;
  wire   [   1:0] ctrl$result_mux_sel;
  wire   [   0:0] ctrl$add_mux_sel;
  wire   [   0:0] ctrl$result_reg_en;
  wire   [   0:0] ctrl$b_mux_sel;
  wire   [   0:0] ctrl$is_hi;
  wire   [   0:0] ctrl$req_rdy;
  wire   [   0:0] ctrl$buffers_en;

  IntMulVarLatCtrl_0x4a27551a25d9401d ctrl
  (
    .is_b_zero      ( ctrl$is_b_zero ),
    .resp_rdy       ( ctrl$resp_rdy ),
    .clk            ( ctrl$clk ),
    .req_type       ( ctrl$req_type ),
    .req_val        ( ctrl$req_val ),
    .b_lsb          ( ctrl$b_lsb ),
    .reset          ( ctrl$reset ),
    .a_mux_sel      ( ctrl$a_mux_sel ),
    .resp_val       ( ctrl$resp_val ),
    .result_mux_sel ( ctrl$result_mux_sel ),
    .add_mux_sel    ( ctrl$add_mux_sel ),
    .result_reg_en  ( ctrl$result_reg_en ),
    .b_mux_sel      ( ctrl$b_mux_sel ),
    .is_hi          ( ctrl$is_hi ),
    .req_rdy        ( ctrl$req_rdy ),
    .buffers_en     ( ctrl$buffers_en )
  );

  // dpath temporaries
  wire   [   1:0] dpath$a_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [   1:0] dpath$result_mux_sel;
  wire   [   0:0] dpath$add_mux_sel;
  wire   [   0:0] dpath$result_reg_en;
  wire   [   0:0] dpath$b_mux_sel;
  wire   [  31:0] dpath$req_msg_b;
  wire   [  31:0] dpath$req_msg_a;
  wire   [   0:0] dpath$is_hi;
  wire   [   0:0] dpath$reset;
  wire   [   2:0] dpath$req_msg_opaque;
  wire   [   0:0] dpath$buffers_en;
  wire   [   2:0] dpath$resp_opaque;
  wire   [   0:0] dpath$is_b_zero;
  wire   [   0:0] dpath$b_lsb;
  wire   [  31:0] dpath$resp_result;

  IntMulVarLatDpath_0x1ea05e108635c477 dpath
  (
    .a_mux_sel      ( dpath$a_mux_sel ),
    .clk            ( dpath$clk ),
    .result_mux_sel ( dpath$result_mux_sel ),
    .add_mux_sel    ( dpath$add_mux_sel ),
    .result_reg_en  ( dpath$result_reg_en ),
    .b_mux_sel      ( dpath$b_mux_sel ),
    .req_msg_b      ( dpath$req_msg_b ),
    .req_msg_a      ( dpath$req_msg_a ),
    .is_hi          ( dpath$is_hi ),
    .reset          ( dpath$reset ),
    .req_msg_opaque ( dpath$req_msg_opaque ),
    .buffers_en     ( dpath$buffers_en ),
    .resp_opaque    ( dpath$resp_opaque ),
    .is_b_zero      ( dpath$is_b_zero ),
    .b_lsb          ( dpath$b_lsb ),
    .resp_result    ( dpath$resp_result )
  );

  // signal connections
  assign ctrl$b_lsb           = dpath$b_lsb;
  assign ctrl$clk             = clk;
  assign ctrl$is_b_zero       = dpath$is_b_zero;
  assign ctrl$req_type        = req_msg[69:67];
  assign ctrl$req_val         = req_val;
  assign ctrl$reset           = reset;
  assign ctrl$resp_rdy        = resp_rdy;
  assign dpath$a_mux_sel      = ctrl$a_mux_sel;
  assign dpath$add_mux_sel    = ctrl$add_mux_sel;
  assign dpath$b_mux_sel      = ctrl$b_mux_sel;
  assign dpath$buffers_en     = ctrl$buffers_en;
  assign dpath$clk            = clk;
  assign dpath$is_hi          = ctrl$is_hi;
  assign dpath$req_msg_a      = req_msg[63:32];
  assign dpath$req_msg_b      = req_msg[31:0];
  assign dpath$req_msg_opaque = req_msg[66:64];
  assign dpath$reset          = reset;
  assign dpath$result_mux_sel = ctrl$result_mux_sel;
  assign dpath$result_reg_en  = ctrl$result_reg_en;
  assign req_rdy              = ctrl$req_rdy;
  assign resp_msg[31:0]       = dpath$resp_result;
  assign resp_msg[34:32]      = dpath$resp_opaque;
  assign resp_val             = ctrl$resp_val;



endmodule // IntMulVarLat_0x4fa87c8a5af4e991
`default_nettype wire

//-----------------------------------------------------------------------------
// IntMulVarLatCtrl_0x4a27551a25d9401d
//-----------------------------------------------------------------------------
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulVarLatCtrl_0x4a27551a25d9401d
(
  output reg  [   1:0] a_mux_sel,
  output reg  [   0:0] add_mux_sel,
  input  wire [   0:0] b_lsb,
  output reg  [   0:0] b_mux_sel,
  output reg  [   0:0] buffers_en,
  input  wire [   0:0] clk,
  input  wire [   0:0] is_b_zero,
  output reg  [   0:0] is_hi,
  output reg  [   0:0] req_rdy,
  input  wire [   2:0] req_type,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [   0:0] resp_rdy,
  output reg  [   0:0] resp_val,
  output reg  [   1:0] result_mux_sel,
  output reg  [   0:0] result_reg_en
);

  // register declarations
  reg    [   1:0] curr_state__0;
  reg    [   1:0] current_state__1;
  reg    [   0:0] do_sh;
  reg    [   0:0] do_sh_add;
  reg    [   1:0] next_state__0;
  reg    [   1:0] state$in_;

  // localparam declarations
  localparam ADD_MUX_SEL_ADD = 0;
  localparam ADD_MUX_SEL_RESULT = 1;
  localparam ADD_MUX_SEL_X = 0;
  localparam A_MUX_SEL_LD = 1;
  localparam A_MUX_SEL_LSH = 0;
  localparam A_MUX_SEL_SEXT = 2;
  localparam A_MUX_SEL_X = 0;
  localparam B_MUX_SEL_LD = 1;
  localparam B_MUX_SEL_RSH = 0;
  localparam B_MUX_SEL_X = 0;
  localparam RESULT_MUX_SEL_0 = 1;
  localparam RESULT_MUX_SEL_ADD = 0;
  localparam RESULT_MUX_SEL_MULH = 2;
  localparam RESULT_MUX_SEL_X = 0;
  localparam STATE_CALC = 1;
  localparam STATE_DONE = 2;
  localparam STATE_IDLE = 0;
  localparam TYPE_MULH = 1;
  localparam TYPE_MULHSU = 2;

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
  //       if ( s.state.out == s.STATE_IDLE ):
  //         if ( s.req_val and s.req_rdy ):
  //           next_state = s.STATE_CALC
  //
  //       # Transistions out of CALC state
  //
  //       if ( s.state.out == s.STATE_CALC ):
  //         if s.is_b_zero:
  //           next_state = s.STATE_DONE
  //
  //       # Transistions out of DONE state
  //
  //       if ( s.state.out == s.STATE_DONE ):
  //         if ( s.resp_val and s.resp_rdy ):
  //           next_state = s.STATE_IDLE
  //
  //       s.state.in_.value = next_state

  // logic for state_transitions()
  always @ (*) begin
    curr_state__0 = state$out;
    next_state__0 = state$out;
    if ((state$out == STATE_IDLE)) begin
      if ((req_val&&req_rdy)) begin
        next_state__0 = STATE_CALC;
      end
      else begin
      end
    end
    else begin
    end
    if ((state$out == STATE_CALC)) begin
      if (is_b_zero) begin
        next_state__0 = STATE_DONE;
      end
      else begin
      end
    end
    else begin
    end
    if ((state$out == STATE_DONE)) begin
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
  //       # Initialize all control signals
  //
  //       s.do_sh_add.value      = 0
  //       s.do_sh.value          = 0
  //
  //       s.req_rdy.value        = 0
  //       s.resp_val.value       = 0
  //
  //       s.a_mux_sel.value      = 0
  //       s.b_mux_sel.value      = 0
  //       s.result_mux_sel.value = 0
  //       s.result_reg_en.value  = 0
  //       s.add_mux_sel.value    = 0
  //
  //       s.result_mux_sel.value = 0
  //       s.buffers_en.value     = 0
  //       s.is_hi.value          = 0
  //
  //       # In IDLE state we simply wait for inputs to arrive and latch them
  //
  //       if current_state == s.STATE_IDLE:
  //
  //         s.req_rdy.value        = 1
  //         s.resp_val.value       = 0
  //
  //         if s.req_type == MduReqMsg.TYPE_MULHSU or s.req_type == MduReqMsg.TYPE_MULH:
  //           s.a_mux_sel.value = A_MUX_SEL_SEXT
  //         else:
  //           s.a_mux_sel.value = A_MUX_SEL_LD
  //
  //         s.b_mux_sel.value      = B_MUX_SEL_LD
  //
  //         if s.req_type == MduReqMsg.TYPE_MULH:
  //           s.result_mux_sel.value = RESULT_MUX_SEL_MULH
  //         else:
  //           s.result_mux_sel.value = RESULT_MUX_SEL_0
  //
  //         s.result_reg_en.value  = 1
  //         s.buffers_en.value     = 1
  //         s.is_hi.value          = (s.req_type != 0)
  //         s.add_mux_sel.value    = ADD_MUX_SEL_X
  //
  //       # In CALC state we iteratively add/shift to caculate mult
  //
  //       elif current_state == s.STATE_CALC:
  //
  //         s.do_sh_add.value      = (s.b_lsb == 1) # do shift and add
  //         s.do_sh.value          = (s.b_lsb == 0) # do shift but no add
  //
  //         s.req_rdy.value        = 0
  //         s.resp_val.value       = 0
  //
  //         s.a_mux_sel.value      = A_MUX_SEL_LSH
  //         s.b_mux_sel.value      = B_MUX_SEL_RSH
  //         s.result_mux_sel.value = RESULT_MUX_SEL_ADD
  //         s.result_reg_en.value  = 1
  //         if s.do_sh_add:
  //           s.add_mux_sel.value  = ADD_MUX_SEL_ADD
  //         else:
  //           s.add_mux_sel.value  = ADD_MUX_SEL_RESULT
  //
  //       # In DONE state we simply wait for output transition to occur
  //
  //       elif current_state == s.STATE_DONE:
  //
  //         s.req_rdy.value        = 0
  //         s.resp_val.value       = 1
  //
  //         s.a_mux_sel.value      = A_MUX_SEL_X
  //         s.b_mux_sel.value      = B_MUX_SEL_X
  //         s.result_mux_sel.value = RESULT_MUX_SEL_X
  //         s.result_reg_en.value  = 0
  //         s.add_mux_sel.value    = ADD_MUX_SEL_X

  // logic for state_outputs()
  always @ (*) begin
    current_state__1 = state$out;
    do_sh_add = 0;
    do_sh = 0;
    req_rdy = 0;
    resp_val = 0;
    a_mux_sel = 0;
    b_mux_sel = 0;
    result_mux_sel = 0;
    result_reg_en = 0;
    add_mux_sel = 0;
    result_mux_sel = 0;
    buffers_en = 0;
    is_hi = 0;
    if ((current_state__1 == STATE_IDLE)) begin
      req_rdy = 1;
      resp_val = 0;
      if (((req_type == TYPE_MULHSU)||(req_type == TYPE_MULH))) begin
        a_mux_sel = A_MUX_SEL_SEXT;
      end
      else begin
        a_mux_sel = A_MUX_SEL_LD;
      end
      b_mux_sel = B_MUX_SEL_LD;
      if ((req_type == TYPE_MULH)) begin
        result_mux_sel = RESULT_MUX_SEL_MULH;
      end
      else begin
        result_mux_sel = RESULT_MUX_SEL_0;
      end
      result_reg_en = 1;
      buffers_en = 1;
      is_hi = (req_type != 0);
      add_mux_sel = ADD_MUX_SEL_X;
    end
    else begin
      if ((current_state__1 == STATE_CALC)) begin
        do_sh_add = (b_lsb == 1);
        do_sh = (b_lsb == 0);
        req_rdy = 0;
        resp_val = 0;
        a_mux_sel = A_MUX_SEL_LSH;
        b_mux_sel = B_MUX_SEL_RSH;
        result_mux_sel = RESULT_MUX_SEL_ADD;
        result_reg_en = 1;
        if (do_sh_add) begin
          add_mux_sel = ADD_MUX_SEL_ADD;
        end
        else begin
          add_mux_sel = ADD_MUX_SEL_RESULT;
        end
      end
      else begin
        if ((current_state__1 == STATE_DONE)) begin
          req_rdy = 0;
          resp_val = 1;
          a_mux_sel = A_MUX_SEL_X;
          b_mux_sel = B_MUX_SEL_X;
          result_mux_sel = RESULT_MUX_SEL_X;
          result_reg_en = 0;
          add_mux_sel = ADD_MUX_SEL_X;
        end
        else begin
        end
      end
    end
  end


endmodule // IntMulVarLatCtrl_0x4a27551a25d9401d
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
// IntMulVarLatDpath_0x1ea05e108635c477
//-----------------------------------------------------------------------------
// nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulVarLatDpath_0x1ea05e108635c477
(
  input  wire [   1:0] a_mux_sel,
  input  wire [   0:0] add_mux_sel,
  output wire [   0:0] b_lsb,
  input  wire [   0:0] b_mux_sel,
  input  wire [   0:0] buffers_en,
  input  wire [   0:0] clk,
  output wire [   0:0] is_b_zero,
  input  wire [   0:0] is_hi,
  input  wire [  31:0] req_msg_a,
  input  wire [  31:0] req_msg_b,
  input  wire [   2:0] req_msg_opaque,
  input  wire [   0:0] reset,
  output wire [   2:0] resp_opaque,
  output wire [  31:0] resp_result,
  input  wire [   1:0] result_mux_sel,
  input  wire [   0:0] result_reg_en
);

  // wire declarations
  wire   [  31:0] rshifter_out;
  wire   [  63:0] lshifter_out;
  wire   [  63:0] add_mux_out;


  // register declarations
  reg    [  63:0] a_mulh_negate;
  reg    [  63:0] opa_sext;

  // localparam declarations
  localparam nbits = 32;

  // is_hi_reg temporaries
  wire   [   0:0] is_hi_reg$reset;
  wire   [   0:0] is_hi_reg$in_;
  wire   [   0:0] is_hi_reg$clk;
  wire   [   0:0] is_hi_reg$en;
  wire   [   0:0] is_hi_reg$out;

  RegEn_0x7b12395e8ee7e2a2 is_hi_reg
  (
    .reset ( is_hi_reg$reset ),
    .in_   ( is_hi_reg$in_ ),
    .clk   ( is_hi_reg$clk ),
    .en    ( is_hi_reg$en ),
    .out   ( is_hi_reg$out )
  );

  // b_zero_cmp temporaries
  wire   [   0:0] b_zero_cmp$reset;
  wire   [  31:0] b_zero_cmp$in_;
  wire   [   0:0] b_zero_cmp$clk;
  wire   [   0:0] b_zero_cmp$out;

  ZeroComparator_0x20454677a5a72bab b_zero_cmp
  (
    .reset ( b_zero_cmp$reset ),
    .in_   ( b_zero_cmp$in_ ),
    .clk   ( b_zero_cmp$clk ),
    .out   ( b_zero_cmp$out )
  );

  // a_reg temporaries
  wire   [   0:0] a_reg$reset;
  wire   [  63:0] a_reg$in_;
  wire   [   0:0] a_reg$clk;
  wire   [  63:0] a_reg$out;

  Reg_0x57db20304fa2732b a_reg
  (
    .reset ( a_reg$reset ),
    .in_   ( a_reg$in_ ),
    .clk   ( a_reg$clk ),
    .out   ( a_reg$out )
  );

  // result_reg temporaries
  wire   [   0:0] result_reg$reset;
  wire   [  63:0] result_reg$in_;
  wire   [   0:0] result_reg$clk;
  wire   [   0:0] result_reg$en;
  wire   [  63:0] result_reg$out;

  RegEn_0x57db20304fa2732b result_reg
  (
    .reset ( result_reg$reset ),
    .in_   ( result_reg$in_ ),
    .clk   ( result_reg$clk ),
    .en    ( result_reg$en ),
    .out   ( result_reg$out )
  );

  // opaque_reg temporaries
  wire   [   0:0] opaque_reg$reset;
  wire   [   2:0] opaque_reg$in_;
  wire   [   0:0] opaque_reg$clk;
  wire   [   0:0] opaque_reg$en;
  wire   [   2:0] opaque_reg$out;

  RegEn_0x5f9f3b87a8883894 opaque_reg
  (
    .reset ( opaque_reg$reset ),
    .in_   ( opaque_reg$in_ ),
    .clk   ( opaque_reg$clk ),
    .en    ( opaque_reg$en ),
    .out   ( opaque_reg$out )
  );

  // add temporaries
  wire   [   0:0] add$clk;
  wire   [  63:0] add$in0;
  wire   [  63:0] add$in1;
  wire   [   0:0] add$reset;
  wire   [   0:0] add$cin;
  wire   [   0:0] add$cout;
  wire   [  63:0] add$out;

  Adder_0x2b59d76425453b4b add
  (
    .clk   ( add$clk ),
    .in0   ( add$in0 ),
    .in1   ( add$in1 ),
    .reset ( add$reset ),
    .cin   ( add$cin ),
    .cout  ( add$cout ),
    .out   ( add$out )
  );

  // add_mux temporaries
  wire   [   0:0] add_mux$reset;
  wire   [  63:0] add_mux$in_$000;
  wire   [  63:0] add_mux$in_$001;
  wire   [   0:0] add_mux$clk;
  wire   [   0:0] add_mux$sel;
  wire   [  63:0] add_mux$out;

  Mux_0x147b842ad2b97e56 add_mux
  (
    .reset   ( add_mux$reset ),
    .in_$000 ( add_mux$in_$000 ),
    .in_$001 ( add_mux$in_$001 ),
    .clk     ( add_mux$clk ),
    .sel     ( add_mux$sel ),
    .out     ( add_mux$out )
  );

  // lshifter temporaries
  wire   [   0:0] lshifter$reset;
  wire   [   3:0] lshifter$shamt;
  wire   [  63:0] lshifter$in_;
  wire   [   0:0] lshifter$clk;
  wire   [  63:0] lshifter$out;

  LeftLogicalShifter_0x39b234576217d1bd lshifter
  (
    .reset ( lshifter$reset ),
    .shamt ( lshifter$shamt ),
    .in_   ( lshifter$in_ ),
    .clk   ( lshifter$clk ),
    .out   ( lshifter$out )
  );

  // a_mux temporaries
  wire   [   0:0] a_mux$reset;
  wire   [  63:0] a_mux$in_$000;
  wire   [  63:0] a_mux$in_$001;
  wire   [  63:0] a_mux$in_$002;
  wire   [   0:0] a_mux$clk;
  wire   [   1:0] a_mux$sel;
  wire   [  63:0] a_mux$out;

  Mux_0x466754c116c83ee7 a_mux
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
  wire   [  31:0] b_mux$in_$000;
  wire   [  31:0] b_mux$in_$001;
  wire   [   0:0] b_mux$clk;
  wire   [   0:0] b_mux$sel;
  wire   [  31:0] b_mux$out;

  Mux_0x7e8c65f0610ab9ca b_mux
  (
    .reset   ( b_mux$reset ),
    .in_$000 ( b_mux$in_$000 ),
    .in_$001 ( b_mux$in_$001 ),
    .clk     ( b_mux$clk ),
    .sel     ( b_mux$sel ),
    .out     ( b_mux$out )
  );

  // result_mux temporaries
  wire   [   0:0] result_mux$reset;
  wire   [  63:0] result_mux$in_$000;
  wire   [  63:0] result_mux$in_$001;
  wire   [  63:0] result_mux$in_$002;
  wire   [   0:0] result_mux$clk;
  wire   [   1:0] result_mux$sel;
  wire   [  63:0] result_mux$out;

  Mux_0x466754c116c83ee7 result_mux
  (
    .reset   ( result_mux$reset ),
    .in_$000 ( result_mux$in_$000 ),
    .in_$001 ( result_mux$in_$001 ),
    .in_$002 ( result_mux$in_$002 ),
    .clk     ( result_mux$clk ),
    .sel     ( result_mux$sel ),
    .out     ( result_mux$out )
  );

  // rshifter temporaries
  wire   [   0:0] rshifter$reset;
  wire   [   3:0] rshifter$shamt;
  wire   [  31:0] rshifter$in_;
  wire   [   0:0] rshifter$clk;
  wire   [  31:0] rshifter$out;

  RightLogicalShifter_0x12be3eb4c8fdf0a3 rshifter
  (
    .reset ( rshifter$reset ),
    .shamt ( rshifter$shamt ),
    .in_   ( rshifter$in_ ),
    .clk   ( rshifter$clk ),
    .out   ( rshifter$out )
  );

  // b_reg temporaries
  wire   [   0:0] b_reg$reset;
  wire   [  31:0] b_reg$in_;
  wire   [   0:0] b_reg$clk;
  wire   [  31:0] b_reg$out;

  Reg_0x1eed677bd3b5c175 b_reg
  (
    .reset ( b_reg$reset ),
    .in_   ( b_reg$in_ ),
    .clk   ( b_reg$clk ),
    .out   ( b_reg$out )
  );

  // res_hilo_mux temporaries
  wire   [   0:0] res_hilo_mux$reset;
  wire   [  31:0] res_hilo_mux$in_$000;
  wire   [  31:0] res_hilo_mux$in_$001;
  wire   [   0:0] res_hilo_mux$clk;
  wire   [   0:0] res_hilo_mux$sel;
  wire   [  31:0] res_hilo_mux$out;

  Mux_0x7e8c65f0610ab9ca res_hilo_mux
  (
    .reset   ( res_hilo_mux$reset ),
    .in_$000 ( res_hilo_mux$in_$000 ),
    .in_$001 ( res_hilo_mux$in_$001 ),
    .clk     ( res_hilo_mux$clk ),
    .sel     ( res_hilo_mux$sel ),
    .out     ( res_hilo_mux$out )
  );

  // calc_shamt temporaries
  wire   [   0:0] calc_shamt$reset;
  wire   [   7:0] calc_shamt$in_;
  wire   [   0:0] calc_shamt$clk;
  wire   [   3:0] calc_shamt$out;

  IntMulVarLatCalcShamt_0x519a3680c5333519 calc_shamt
  (
    .reset ( calc_shamt$reset ),
    .in_   ( calc_shamt$in_ ),
    .clk   ( calc_shamt$clk ),
    .out   ( calc_shamt$out )
  );

  // signal connections
  assign a_mux$clk            = clk;
  assign a_mux$in_$000        = lshifter_out;
  assign a_mux$in_$001[31:0]  = req_msg_a;
  assign a_mux$in_$001[63:32] = 32'd0;
  assign a_mux$in_$002        = opa_sext;
  assign a_mux$reset          = reset;
  assign a_mux$sel            = a_mux_sel;
  assign a_reg$clk            = clk;
  assign a_reg$in_            = a_mux$out;
  assign a_reg$reset          = reset;
  assign add$cin              = 1'd0;
  assign add$clk              = clk;
  assign add$in0              = a_reg$out;
  assign add$in1              = result_reg$out;
  assign add$reset            = reset;
  assign add_mux$clk          = clk;
  assign add_mux$in_$000      = add$out;
  assign add_mux$in_$001      = result_reg$out;
  assign add_mux$reset        = reset;
  assign add_mux$sel          = add_mux_sel;
  assign add_mux_out          = add_mux$out;
  assign b_lsb                = b_reg$out[0];
  assign b_mux$clk            = clk;
  assign b_mux$in_$000        = rshifter_out;
  assign b_mux$in_$001        = req_msg_b;
  assign b_mux$reset          = reset;
  assign b_mux$sel            = b_mux_sel;
  assign b_reg$clk            = clk;
  assign b_reg$in_            = b_mux$out;
  assign b_reg$reset          = reset;
  assign b_zero_cmp$clk       = clk;
  assign b_zero_cmp$in_       = b_reg$out;
  assign b_zero_cmp$reset     = reset;
  assign calc_shamt$clk       = clk;
  assign calc_shamt$in_       = b_reg$out[7:0];
  assign calc_shamt$reset     = reset;
  assign is_b_zero            = b_zero_cmp$out;
  assign is_hi_reg$clk        = clk;
  assign is_hi_reg$en         = buffers_en;
  assign is_hi_reg$in_        = is_hi;
  assign is_hi_reg$reset      = reset;
  assign lshifter$clk         = clk;
  assign lshifter$in_         = a_reg$out;
  assign lshifter$reset       = reset;
  assign lshifter$shamt       = calc_shamt$out;
  assign lshifter_out         = lshifter$out;
  assign opaque_reg$clk       = clk;
  assign opaque_reg$en        = buffers_en;
  assign opaque_reg$in_       = req_msg_opaque;
  assign opaque_reg$reset     = reset;
  assign res_hilo_mux$clk     = clk;
  assign res_hilo_mux$in_$000 = result_reg$out[31:0];
  assign res_hilo_mux$in_$001 = result_reg$out[63:32];
  assign res_hilo_mux$reset   = reset;
  assign res_hilo_mux$sel     = is_hi_reg$out;
  assign resp_opaque          = opaque_reg$out;
  assign resp_result          = res_hilo_mux$out;
  assign result_mux$clk       = clk;
  assign result_mux$in_$000   = add_mux_out;
  assign result_mux$in_$001   = 64'd0;
  assign result_mux$in_$002   = a_mulh_negate;
  assign result_mux$reset     = reset;
  assign result_mux$sel       = result_mux_sel;
  assign result_reg$clk       = clk;
  assign result_reg$en        = result_reg_en;
  assign result_reg$in_       = result_mux$out;
  assign result_reg$reset     = reset;
  assign rshifter$clk         = clk;
  assign rshifter$in_         = b_reg$out;
  assign rshifter$reset       = reset;
  assign rshifter$shamt       = calc_shamt$out;
  assign rshifter_out         = rshifter$out;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_opa_sext():
  //       s.opa_sext.value = sext( s.req_msg_a, 64 )

  // logic for comb_opa_sext()
  always @ (*) begin
    opa_sext = { { 64-32 { req_msg_a[31] } }, req_msg_a[31:0] };
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_a_mulh_negate():
  //       s.a_mulh_negate.value = 0
  //       # Why can't I use nbits ???
  //       if s.req_msg_b[nbits-1]:
  //         s.a_mulh_negate[nbits:].value = ~s.req_msg_a + 1

  // logic for comb_a_mulh_negate()
  always @ (*) begin
    a_mulh_negate = 0;
    if (req_msg_b[(nbits-1)]) begin
      a_mulh_negate[(64)-1:nbits] = (~req_msg_a+1);
    end
    else begin
    end
  end


endmodule // IntMulVarLatDpath_0x1ea05e108635c477
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x7b12395e8ee7e2a2
//-----------------------------------------------------------------------------
// dtype: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x7b12395e8ee7e2a2
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   0:0] in_,
  output reg  [   0:0] out,
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


endmodule // RegEn_0x7b12395e8ee7e2a2
`default_nettype wire

//-----------------------------------------------------------------------------
// ZeroComparator_0x20454677a5a72bab
//-----------------------------------------------------------------------------
// nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ZeroComparator_0x20454677a5a72bab
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
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


endmodule // ZeroComparator_0x20454677a5a72bab
`default_nettype wire

//-----------------------------------------------------------------------------
// Reg_0x57db20304fa2732b
//-----------------------------------------------------------------------------
// dtype: 64
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Reg_0x57db20304fa2732b
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in_,
  output reg  [  63:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    out <= in_;
  end


endmodule // Reg_0x57db20304fa2732b
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x57db20304fa2732b
//-----------------------------------------------------------------------------
// dtype: 64
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x57db20304fa2732b
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  63:0] in_,
  output reg  [  63:0] out,
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


endmodule // RegEn_0x57db20304fa2732b
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x5f9f3b87a8883894
//-----------------------------------------------------------------------------
// dtype: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x5f9f3b87a8883894
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   2:0] in_,
  output reg  [   2:0] out,
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


endmodule // RegEn_0x5f9f3b87a8883894
`default_nettype wire

//-----------------------------------------------------------------------------
// Adder_0x2b59d76425453b4b
//-----------------------------------------------------------------------------
// nbits: 64
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Adder_0x2b59d76425453b4b
(
  input  wire [   0:0] cin,
  input  wire [   0:0] clk,
  output wire [   0:0] cout,
  input  wire [  63:0] in0,
  input  wire [  63:0] in1,
  output wire [  63:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  64:0] t0__0;
  reg    [  64:0] t1__0;
  reg    [  64:0] temp;

  // localparam declarations
  localparam twidth = 65;

  // signal connections
  assign cout = temp[64];
  assign out  = temp[63:0];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       # Zero extend the inputs by one bit so we can generate an extra
  //       # carry out bit
  //
  //       t0 = zext( s.in0, twidth )
  //       t1 = zext( s.in1, twidth )
  //
  //       s.temp.value = t0 + t1 + s.cin

  // logic for comb_logic()
  always @ (*) begin
    t0__0 = { { twidth-64 { 1'b0 } }, in0[63:0] };
    t1__0 = { { twidth-64 { 1'b0 } }, in1[63:0] };
    temp = ((t0__0+t1__0)+cin);
  end


endmodule // Adder_0x2b59d76425453b4b
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x147b842ad2b97e56
//-----------------------------------------------------------------------------
// dtype: 64
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x147b842ad2b97e56
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in_$000,
  input  wire [  63:0] in_$001,
  output reg  [  63:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  63:0] in_[0:1];
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


endmodule // Mux_0x147b842ad2b97e56
`default_nettype wire

//-----------------------------------------------------------------------------
// LeftLogicalShifter_0x39b234576217d1bd
//-----------------------------------------------------------------------------
// inout_nbits: 64
// shamt_nbits: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module LeftLogicalShifter_0x39b234576217d1bd
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in_,
  output reg  [  63:0] out,
  input  wire [   0:0] reset,
  input  wire [   3:0] shamt
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ << s.shamt

  // logic for comb_logic()
  always @ (*) begin
    out = (in_<<shamt);
  end


endmodule // LeftLogicalShifter_0x39b234576217d1bd
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x466754c116c83ee7
//-----------------------------------------------------------------------------
// dtype: 64
// nports: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x466754c116c83ee7
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in_$000,
  input  wire [  63:0] in_$001,
  input  wire [  63:0] in_$002,
  output reg  [  63:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] sel
);

  // localparam declarations
  localparam nports = 3;


  // array declarations
  wire   [  63:0] in_[0:2];
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


endmodule // Mux_0x466754c116c83ee7
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x7e8c65f0610ab9ca
//-----------------------------------------------------------------------------
// dtype: 32
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x7e8c65f0610ab9ca
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  input  wire [  31:0] in_$001,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  31:0] in_[0:1];
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


endmodule // Mux_0x7e8c65f0610ab9ca
`default_nettype wire

//-----------------------------------------------------------------------------
// RightLogicalShifter_0x12be3eb4c8fdf0a3
//-----------------------------------------------------------------------------
// inout_nbits: 32
// shamt_nbits: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RightLogicalShifter_0x12be3eb4c8fdf0a3
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   3:0] shamt
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ >> s.shamt

  // logic for comb_logic()
  always @ (*) begin
    out = (in_>>shamt);
  end


endmodule // RightLogicalShifter_0x12be3eb4c8fdf0a3
`default_nettype wire

//-----------------------------------------------------------------------------
// Reg_0x1eed677bd3b5c175
//-----------------------------------------------------------------------------
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Reg_0x1eed677bd3b5c175
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    out <= in_;
  end


endmodule // Reg_0x1eed677bd3b5c175
`default_nettype wire

//-----------------------------------------------------------------------------
// IntMulVarLatCalcShamt_0x519a3680c5333519
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulVarLatCalcShamt_0x519a3680c5333519
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in_,
  output reg  [   3:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def block():
  //
  //       if   s.in_    == 0: s.out.value = 8
  //       elif s.in_[0] == 1: s.out.value = 1
  //       elif s.in_[1] == 1: s.out.value = 1
  //       elif s.in_[2] == 1: s.out.value = 2
  //       elif s.in_[3] == 1: s.out.value = 3
  //       elif s.in_[4] == 1: s.out.value = 4
  //       elif s.in_[5] == 1: s.out.value = 5
  //       elif s.in_[6] == 1: s.out.value = 6
  //       elif s.in_[7] == 1: s.out.value = 7

  // logic for block()
  always @ (*) begin
    if ((in_ == 0)) begin
      out = 8;
    end
    else begin
      if ((in_[0] == 1)) begin
        out = 1;
      end
      else begin
        if ((in_[1] == 1)) begin
          out = 1;
        end
        else begin
          if ((in_[2] == 1)) begin
            out = 2;
          end
          else begin
            if ((in_[3] == 1)) begin
              out = 3;
            end
            else begin
              if ((in_[4] == 1)) begin
                out = 4;
              end
              else begin
                if ((in_[5] == 1)) begin
                  out = 5;
                end
                else begin
                  if ((in_[6] == 1)) begin
                    out = 6;
                  end
                  else begin
                    if ((in_[7] == 1)) begin
                      out = 7;
                    end
                    else begin
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end


endmodule // IntMulVarLatCalcShamt_0x519a3680c5333519
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4_0x18c371d1cf60a588
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4_0x18c371d1cf60a588
(
  input  wire [   0:0] clk,
  input  wire [  69:0] req_msg,
  output wire [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  output wire [  34:0] resp_msg,
  input  wire [   0:0] resp_rdy,
  output wire [   0:0] resp_val
);

  // ctrl temporaries
  wire   [   0:0] ctrl$resp_rdy;
  wire   [   0:0] ctrl$sub_negative1;
  wire   [   0:0] ctrl$sub_negative2;
  wire   [   0:0] ctrl$clk;
  wire   [   2:0] ctrl$req_type;
  wire   [   0:0] ctrl$req_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$remainder_reg_en;
  wire   [   0:0] ctrl$quotient_mux_sel;
  wire   [   0:0] ctrl$is_div;
  wire   [   0:0] ctrl$quotient_reg_en;
  wire   [   0:0] ctrl$resp_val;
  wire   [   0:0] ctrl$is_signed;
  wire   [   0:0] ctrl$divisor_mux_sel;
  wire   [   1:0] ctrl$remainder_mux_sel;
  wire   [   0:0] ctrl$req_rdy;
  wire   [   0:0] ctrl$buffers_en;

  IntDivRem4Ctrl_0x18c371d1cf60a588 ctrl
  (
    .resp_rdy          ( ctrl$resp_rdy ),
    .sub_negative1     ( ctrl$sub_negative1 ),
    .sub_negative2     ( ctrl$sub_negative2 ),
    .clk               ( ctrl$clk ),
    .req_type          ( ctrl$req_type ),
    .req_val           ( ctrl$req_val ),
    .reset             ( ctrl$reset ),
    .remainder_reg_en  ( ctrl$remainder_reg_en ),
    .quotient_mux_sel  ( ctrl$quotient_mux_sel ),
    .is_div            ( ctrl$is_div ),
    .quotient_reg_en   ( ctrl$quotient_reg_en ),
    .resp_val          ( ctrl$resp_val ),
    .is_signed         ( ctrl$is_signed ),
    .divisor_mux_sel   ( ctrl$divisor_mux_sel ),
    .remainder_mux_sel ( ctrl$remainder_mux_sel ),
    .req_rdy           ( ctrl$req_rdy ),
    .buffers_en        ( ctrl$buffers_en )
  );

  // dpath temporaries
  wire   [   0:0] dpath$remainder_reg_en;
  wire   [   0:0] dpath$quotient_mux_sel;
  wire   [   0:0] dpath$is_div;
  wire   [   0:0] dpath$quotient_reg_en;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$is_signed;
  wire   [  31:0] dpath$req_msg_b;
  wire   [   0:0] dpath$divisor_mux_sel;
  wire   [   1:0] dpath$remainder_mux_sel;
  wire   [   0:0] dpath$reset;
  wire   [   2:0] dpath$req_msg_opaque;
  wire   [   0:0] dpath$buffers_en;
  wire   [  31:0] dpath$req_msg_a;
  wire   [   2:0] dpath$resp_opaque;
  wire   [   0:0] dpath$sub_negative1;
  wire   [   0:0] dpath$sub_negative2;
  wire   [  31:0] dpath$resp_result;

  IntDivRem4Dpath_0x23a9c358c75db7a2 dpath
  (
    .remainder_reg_en  ( dpath$remainder_reg_en ),
    .quotient_mux_sel  ( dpath$quotient_mux_sel ),
    .is_div            ( dpath$is_div ),
    .quotient_reg_en   ( dpath$quotient_reg_en ),
    .clk               ( dpath$clk ),
    .is_signed         ( dpath$is_signed ),
    .req_msg_b         ( dpath$req_msg_b ),
    .divisor_mux_sel   ( dpath$divisor_mux_sel ),
    .remainder_mux_sel ( dpath$remainder_mux_sel ),
    .reset             ( dpath$reset ),
    .req_msg_opaque    ( dpath$req_msg_opaque ),
    .buffers_en        ( dpath$buffers_en ),
    .req_msg_a         ( dpath$req_msg_a ),
    .resp_opaque       ( dpath$resp_opaque ),
    .sub_negative1     ( dpath$sub_negative1 ),
    .sub_negative2     ( dpath$sub_negative2 ),
    .resp_result       ( dpath$resp_result )
  );

  // signal connections
  assign ctrl$clk                = clk;
  assign ctrl$req_type           = req_msg[69:67];
  assign ctrl$req_val            = req_val;
  assign ctrl$reset              = reset;
  assign ctrl$resp_rdy           = resp_rdy;
  assign ctrl$sub_negative1      = dpath$sub_negative1;
  assign ctrl$sub_negative2      = dpath$sub_negative2;
  assign dpath$buffers_en        = ctrl$buffers_en;
  assign dpath$clk               = clk;
  assign dpath$divisor_mux_sel   = ctrl$divisor_mux_sel;
  assign dpath$is_div            = ctrl$is_div;
  assign dpath$is_signed         = ctrl$is_signed;
  assign dpath$quotient_mux_sel  = ctrl$quotient_mux_sel;
  assign dpath$quotient_reg_en   = ctrl$quotient_reg_en;
  assign dpath$remainder_mux_sel = ctrl$remainder_mux_sel;
  assign dpath$remainder_reg_en  = ctrl$remainder_reg_en;
  assign dpath$req_msg_a         = req_msg[63:32];
  assign dpath$req_msg_b         = req_msg[31:0];
  assign dpath$req_msg_opaque    = req_msg[66:64];
  assign dpath$reset             = reset;
  assign req_rdy                 = ctrl$req_rdy;
  assign resp_msg[31:0]          = dpath$resp_result;
  assign resp_msg[34:32]         = dpath$resp_opaque;
  assign resp_val                = ctrl$resp_val;



endmodule // IntDivRem4_0x18c371d1cf60a588
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4Ctrl_0x18c371d1cf60a588
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4Ctrl_0x18c371d1cf60a588
(
  output reg  [   0:0] buffers_en,
  input  wire [   0:0] clk,
  output reg  [   0:0] divisor_mux_sel,
  output reg  [   0:0] is_div,
  output reg  [   0:0] is_signed,
  output reg  [   0:0] quotient_mux_sel,
  output reg  [   0:0] quotient_reg_en,
  output reg  [   1:0] remainder_mux_sel,
  output reg  [   0:0] remainder_reg_en,
  output reg  [   0:0] req_rdy,
  input  wire [   2:0] req_type,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [   0:0] resp_rdy,
  output reg  [   0:0] resp_val,
  input  wire [   0:0] sub_negative1,
  input  wire [   0:0] sub_negative2
);

  // register declarations
  reg    [   4:0] curr_state__0;
  reg    [   4:0] curr_state__1;
  reg    [   4:0] state$in_;

  // localparam declarations
  localparam D_MUX_SEL_IN = 0;
  localparam D_MUX_SEL_RSH = 1;
  localparam Q_MUX_SEL_0 = 0;
  localparam Q_MUX_SEL_LSH = 1;
  localparam R_MUX_SEL_IN = 0;
  localparam R_MUX_SEL_SUB1 = 1;
  localparam R_MUX_SEL_SUB2 = 2;
  localparam STATE_CALC = 17;
  localparam STATE_DONE = 1;
  localparam STATE_IDLE = 0;

  // state temporaries
  wire   [   0:0] state$reset;
  wire   [   0:0] state$clk;
  wire   [   4:0] state$out;

  RegRst_0x7595e02357c57db5 state
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
  //
  //       s.state.in_.value = s.state.out
  //
  //       if   curr_state == s.STATE_IDLE:
  //         if s.req_val and s.req_rdy:
  //           s.state.in_.value = s.STATE_CALC
  //
  //       elif curr_state == s.STATE_DONE:
  //         if s.resp_val and s.resp_rdy:
  //           s.state.in_.value = s.STATE_IDLE
  //
  //       else:
  //         s.state.in_.value = curr_state - 1

  // logic for state_transitions()
  always @ (*) begin
    curr_state__0 = state$out;
    state$in_ = state$out;
    if ((curr_state__0 == STATE_IDLE)) begin
      if ((req_val&&req_rdy)) begin
        state$in_ = STATE_CALC;
      end
      else begin
      end
    end
    else begin
      if ((curr_state__0 == STATE_DONE)) begin
        if ((resp_val&&resp_rdy)) begin
          state$in_ = STATE_IDLE;
        end
        else begin
        end
      end
      else begin
        state$in_ = (curr_state__0-1);
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_outputs():
  //
  //       curr_state = s.state.out
  //
  //       s.buffers_en.value = 0
  //       s.is_div.value     = 0
  //
  //       if   curr_state == s.STATE_IDLE:
  //         s.req_rdy.value     = 1
  //         s.resp_val.value    = 0
  //
  //         s.remainder_mux_sel.value = R_MUX_SEL_IN
  //         s.remainder_reg_en.value  = 1
  //
  //         s.quotient_mux_sel.value  = Q_MUX_SEL_0
  //         s.quotient_reg_en.value   = 1
  //
  //         s.divisor_mux_sel.value   = D_MUX_SEL_IN
  //
  //         s.buffers_en.value        = 1
  //         s.is_div.value            = (s.req_type[1] == 0) # div/divu = 0b100, 0b101
  //         s.is_signed.value         = (s.req_type[0] == 0) # div/rem = 0b100, 0b110
  //
  //       elif curr_state == s.STATE_DONE:
  //         s.req_rdy.value     = 0
  //         s.resp_val.value    = 1
  //
  //         s.quotient_mux_sel.value  = Q_MUX_SEL_0
  //         s.quotient_reg_en.value   = 0
  //
  //         s.remainder_mux_sel.value = R_MUX_SEL_IN
  //         s.remainder_reg_en.value  = 0
  //
  //         s.divisor_mux_sel.value   = D_MUX_SEL_IN
  //
  //       else: # calculating
  //         s.req_rdy.value     = 0
  //         s.resp_val.value    = 0
  //
  //         s.remainder_reg_en.value = ~(s.sub_negative1 & s.sub_negative2)
  //         if s.sub_negative2:
  //           s.remainder_mux_sel.value = R_MUX_SEL_SUB1
  //         else:
  //           s.remainder_mux_sel.value = R_MUX_SEL_SUB2
  //
  //         s.quotient_reg_en.value   = 1
  //         s.quotient_mux_sel.value  = Q_MUX_SEL_LSH
  //
  //         s.divisor_mux_sel.value   = D_MUX_SEL_RSH

  // logic for state_outputs()
  always @ (*) begin
    curr_state__1 = state$out;
    buffers_en = 0;
    is_div = 0;
    if ((curr_state__1 == STATE_IDLE)) begin
      req_rdy = 1;
      resp_val = 0;
      remainder_mux_sel = R_MUX_SEL_IN;
      remainder_reg_en = 1;
      quotient_mux_sel = Q_MUX_SEL_0;
      quotient_reg_en = 1;
      divisor_mux_sel = D_MUX_SEL_IN;
      buffers_en = 1;
      is_div = (req_type[1] == 0);
      is_signed = (req_type[0] == 0);
    end
    else begin
      if ((curr_state__1 == STATE_DONE)) begin
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
        if (sub_negative2) begin
          remainder_mux_sel = R_MUX_SEL_SUB1;
        end
        else begin
          remainder_mux_sel = R_MUX_SEL_SUB2;
        end
        quotient_reg_en = 1;
        quotient_mux_sel = Q_MUX_SEL_LSH;
        divisor_mux_sel = D_MUX_SEL_RSH;
      end
    end
  end


endmodule // IntDivRem4Ctrl_0x18c371d1cf60a588
`default_nettype wire

//-----------------------------------------------------------------------------
// RegRst_0x7595e02357c57db5
//-----------------------------------------------------------------------------
// dtype: 5
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegRst_0x7595e02357c57db5
(
  input  wire [   0:0] clk,
  input  wire [   4:0] in_,
  output reg  [   4:0] out,
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


endmodule // RegRst_0x7595e02357c57db5
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4Dpath_0x23a9c358c75db7a2
//-----------------------------------------------------------------------------
// nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4Dpath_0x23a9c358c75db7a2
(
  input  wire [   0:0] buffers_en,
  input  wire [   0:0] clk,
  input  wire [   0:0] divisor_mux_sel,
  input  wire [   0:0] is_div,
  input  wire [   0:0] is_signed,
  input  wire [   0:0] quotient_mux_sel,
  input  wire [   0:0] quotient_reg_en,
  input  wire [   1:0] remainder_mux_sel,
  input  wire [   0:0] remainder_reg_en,
  input  wire [  31:0] req_msg_a,
  input  wire [  31:0] req_msg_b,
  input  wire [   2:0] req_msg_opaque,
  input  wire [   0:0] reset,
  output wire [   2:0] resp_opaque,
  output wire [  31:0] resp_result,
  output wire [   0:0] sub_negative1,
  output wire [   0:0] sub_negative2
);

  // register declarations
  reg    [  31:0] a_negate;
  reg    [  31:0] b_negate;
  reg    [  31:0] quo_negate;
  reg    [  31:0] rem_negate;
  reg    [   0:0] res_quo_negate;
  reg    [   0:0] res_rem_negate;

  // localparam declarations
  localparam Q_MUX_SEL_0 = 0;
  localparam Q_MUX_SEL_LSH = 1;
  localparam nbits = 32;

  // remainder_mid_mux temporaries
  wire   [   0:0] remainder_mid_mux$reset;
  wire   [  63:0] remainder_mid_mux$in_$000;
  wire   [  63:0] remainder_mid_mux$in_$001;
  wire   [   0:0] remainder_mid_mux$clk;
  wire   [   0:0] remainder_mid_mux$sel;
  wire   [  63:0] remainder_mid_mux$out;

  Mux_0x147b842ad2b97e56 remainder_mid_mux
  (
    .reset   ( remainder_mid_mux$reset ),
    .in_$000 ( remainder_mid_mux$in_$000 ),
    .in_$001 ( remainder_mid_mux$in_$001 ),
    .clk     ( remainder_mid_mux$clk ),
    .sel     ( remainder_mid_mux$sel ),
    .out     ( remainder_mid_mux$out )
  );

  // remainder_mux temporaries
  wire   [   0:0] remainder_mux$reset;
  wire   [  63:0] remainder_mux$in_$000;
  wire   [  63:0] remainder_mux$in_$001;
  wire   [  63:0] remainder_mux$in_$002;
  wire   [   0:0] remainder_mux$clk;
  wire   [   1:0] remainder_mux$sel;
  wire   [  63:0] remainder_mux$out;

  Mux_0x466754c116c83ee7 remainder_mux
  (
    .reset   ( remainder_mux$reset ),
    .in_$000 ( remainder_mux$in_$000 ),
    .in_$001 ( remainder_mux$in_$001 ),
    .in_$002 ( remainder_mux$in_$002 ),
    .clk     ( remainder_mux$clk ),
    .sel     ( remainder_mux$sel ),
    .out     ( remainder_mux$out )
  );

  // res_quo_mux temporaries
  wire   [   0:0] res_quo_mux$reset;
  wire   [  31:0] res_quo_mux$in_$000;
  wire   [  31:0] res_quo_mux$in_$001;
  wire   [   0:0] res_quo_mux$clk;
  wire   [   0:0] res_quo_mux$sel;
  wire   [  31:0] res_quo_mux$out;

  Mux_0x7e8c65f0610ab9ca res_quo_mux
  (
    .reset   ( res_quo_mux$reset ),
    .in_$000 ( res_quo_mux$in_$000 ),
    .in_$001 ( res_quo_mux$in_$001 ),
    .clk     ( res_quo_mux$clk ),
    .sel     ( res_quo_mux$sel ),
    .out     ( res_quo_mux$out )
  );

  // remainder_reg temporaries
  wire   [   0:0] remainder_reg$reset;
  wire   [  63:0] remainder_reg$in_;
  wire   [   0:0] remainder_reg$clk;
  wire   [   0:0] remainder_reg$en;
  wire   [  63:0] remainder_reg$out;

  RegEn_0x57db20304fa2732b remainder_reg
  (
    .reset ( remainder_reg$reset ),
    .in_   ( remainder_reg$in_ ),
    .clk   ( remainder_reg$clk ),
    .en    ( remainder_reg$en ),
    .out   ( remainder_reg$out )
  );

  // res_rem_negate_flag temporaries
  wire   [   0:0] res_rem_negate_flag$reset;
  wire   [   0:0] res_rem_negate_flag$in_;
  wire   [   0:0] res_rem_negate_flag$clk;
  wire   [   0:0] res_rem_negate_flag$en;
  wire   [   0:0] res_rem_negate_flag$out;

  RegEn_0x7b12395e8ee7e2a2 res_rem_negate_flag
  (
    .reset ( res_rem_negate_flag$reset ),
    .in_   ( res_rem_negate_flag$in_ ),
    .clk   ( res_rem_negate_flag$clk ),
    .en    ( res_rem_negate_flag$en ),
    .out   ( res_rem_negate_flag$out )
  );

  // is_div_reg temporaries
  wire   [   0:0] is_div_reg$reset;
  wire   [   0:0] is_div_reg$in_;
  wire   [   0:0] is_div_reg$clk;
  wire   [   0:0] is_div_reg$en;
  wire   [   0:0] is_div_reg$out;

  RegEn_0x7b12395e8ee7e2a2 is_div_reg
  (
    .reset ( is_div_reg$reset ),
    .in_   ( is_div_reg$in_ ),
    .clk   ( is_div_reg$clk ),
    .en    ( is_div_reg$en ),
    .out   ( is_div_reg$out )
  );

  // res_quo_negate_flag temporaries
  wire   [   0:0] res_quo_negate_flag$reset;
  wire   [   0:0] res_quo_negate_flag$in_;
  wire   [   0:0] res_quo_negate_flag$clk;
  wire   [   0:0] res_quo_negate_flag$en;
  wire   [   0:0] res_quo_negate_flag$out;

  RegEn_0x7b12395e8ee7e2a2 res_quo_negate_flag
  (
    .reset ( res_quo_negate_flag$reset ),
    .in_   ( res_quo_negate_flag$in_ ),
    .clk   ( res_quo_negate_flag$clk ),
    .en    ( res_quo_negate_flag$en ),
    .out   ( res_quo_negate_flag$out )
  );

  // res_divrem_mux temporaries
  wire   [   0:0] res_divrem_mux$reset;
  wire   [  31:0] res_divrem_mux$in_$000;
  wire   [  31:0] res_divrem_mux$in_$001;
  wire   [   0:0] res_divrem_mux$clk;
  wire   [   0:0] res_divrem_mux$sel;
  wire   [  31:0] res_divrem_mux$out;

  Mux_0x7e8c65f0610ab9ca res_divrem_mux
  (
    .reset   ( res_divrem_mux$reset ),
    .in_$000 ( res_divrem_mux$in_$000 ),
    .in_$001 ( res_divrem_mux$in_$001 ),
    .clk     ( res_divrem_mux$clk ),
    .sel     ( res_divrem_mux$sel ),
    .out     ( res_divrem_mux$out )
  );

  // quotient_reg temporaries
  wire   [   0:0] quotient_reg$reset;
  wire   [  31:0] quotient_reg$in_;
  wire   [   0:0] quotient_reg$clk;
  wire   [   0:0] quotient_reg$en;
  wire   [  31:0] quotient_reg$out;

  RegEn_0x1eed677bd3b5c175 quotient_reg
  (
    .reset ( quotient_reg$reset ),
    .in_   ( quotient_reg$in_ ),
    .clk   ( quotient_reg$clk ),
    .en    ( quotient_reg$en ),
    .out   ( quotient_reg$out )
  );

  // quotient_mux temporaries
  wire   [   0:0] quotient_mux$reset;
  wire   [  31:0] quotient_mux$in_$000;
  wire   [  31:0] quotient_mux$in_$001;
  wire   [   0:0] quotient_mux$clk;
  wire   [   0:0] quotient_mux$sel;
  wire   [  31:0] quotient_mux$out;

  Mux_0x7e8c65f0610ab9ca quotient_mux
  (
    .reset   ( quotient_mux$reset ),
    .in_$000 ( quotient_mux$in_$000 ),
    .in_$001 ( quotient_mux$in_$001 ),
    .clk     ( quotient_mux$clk ),
    .sel     ( quotient_mux$sel ),
    .out     ( quotient_mux$out )
  );

  // sub2 temporaries
  wire   [   0:0] sub2$reset;
  wire   [   0:0] sub2$clk;
  wire   [  63:0] sub2$in0;
  wire   [  63:0] sub2$in1;
  wire   [  63:0] sub2$out;

  Subtractor_0x2b59d76425453b4b sub2
  (
    .reset ( sub2$reset ),
    .clk   ( sub2$clk ),
    .in0   ( sub2$in0 ),
    .in1   ( sub2$in1 ),
    .out   ( sub2$out )
  );

  // divisor_mux temporaries
  wire   [   0:0] divisor_mux$reset;
  wire   [  63:0] divisor_mux$in_$000;
  wire   [  63:0] divisor_mux$in_$001;
  wire   [   0:0] divisor_mux$clk;
  wire   [   0:0] divisor_mux$sel;
  wire   [  63:0] divisor_mux$out;

  Mux_0x147b842ad2b97e56 divisor_mux
  (
    .reset   ( divisor_mux$reset ),
    .in_$000 ( divisor_mux$in_$000 ),
    .in_$001 ( divisor_mux$in_$001 ),
    .clk     ( divisor_mux$clk ),
    .sel     ( divisor_mux$sel ),
    .out     ( divisor_mux$out )
  );

  // sub1 temporaries
  wire   [   0:0] sub1$reset;
  wire   [   0:0] sub1$clk;
  wire   [  63:0] sub1$in0;
  wire   [  63:0] sub1$in1;
  wire   [  63:0] sub1$out;

  Subtractor_0x2b59d76425453b4b sub1
  (
    .reset ( sub1$reset ),
    .clk   ( sub1$clk ),
    .in0   ( sub1$in0 ),
    .in1   ( sub1$in1 ),
    .out   ( sub1$out )
  );

  // opaque_reg temporaries
  wire   [   0:0] opaque_reg$reset;
  wire   [   2:0] opaque_reg$in_;
  wire   [   0:0] opaque_reg$clk;
  wire   [   0:0] opaque_reg$en;
  wire   [   2:0] opaque_reg$out;

  RegEn_0x5f9f3b87a8883894 opaque_reg
  (
    .reset ( opaque_reg$reset ),
    .in_   ( opaque_reg$in_ ),
    .clk   ( opaque_reg$clk ),
    .en    ( opaque_reg$en ),
    .out   ( opaque_reg$out )
  );

  // res_rem_mux temporaries
  wire   [   0:0] res_rem_mux$reset;
  wire   [  31:0] res_rem_mux$in_$000;
  wire   [  31:0] res_rem_mux$in_$001;
  wire   [   0:0] res_rem_mux$clk;
  wire   [   0:0] res_rem_mux$sel;
  wire   [  31:0] res_rem_mux$out;

  Mux_0x7e8c65f0610ab9ca res_rem_mux
  (
    .reset   ( res_rem_mux$reset ),
    .in_$000 ( res_rem_mux$in_$000 ),
    .in_$001 ( res_rem_mux$in_$001 ),
    .clk     ( res_rem_mux$clk ),
    .sel     ( res_rem_mux$sel ),
    .out     ( res_rem_mux$out )
  );

  // quotient_lsh temporaries
  wire   [   0:0] quotient_lsh$reset;
  wire   [   1:0] quotient_lsh$shamt;
  wire   [  31:0] quotient_lsh$in_;
  wire   [   0:0] quotient_lsh$clk;
  wire   [  31:0] quotient_lsh$out;

  LeftLogicalShifter_0x58d64523f88e3a01 quotient_lsh
  (
    .reset ( quotient_lsh$reset ),
    .shamt ( quotient_lsh$shamt ),
    .in_   ( quotient_lsh$in_ ),
    .clk   ( quotient_lsh$clk ),
    .out   ( quotient_lsh$out )
  );

  // divisor_reg temporaries
  wire   [   0:0] divisor_reg$reset;
  wire   [  63:0] divisor_reg$in_;
  wire   [   0:0] divisor_reg$clk;
  wire   [  63:0] divisor_reg$out;

  Reg_0x57db20304fa2732b divisor_reg
  (
    .reset ( divisor_reg$reset ),
    .in_   ( divisor_reg$in_ ),
    .clk   ( divisor_reg$clk ),
    .out   ( divisor_reg$out )
  );

  // divisor_rsh1 temporaries
  wire   [   0:0] divisor_rsh1$reset;
  wire   [   0:0] divisor_rsh1$shamt;
  wire   [  63:0] divisor_rsh1$in_;
  wire   [   0:0] divisor_rsh1$clk;
  wire   [  63:0] divisor_rsh1$out;

  RightLogicalShifter_0x5e9be0d284b3480a divisor_rsh1
  (
    .reset ( divisor_rsh1$reset ),
    .shamt ( divisor_rsh1$shamt ),
    .in_   ( divisor_rsh1$in_ ),
    .clk   ( divisor_rsh1$clk ),
    .out   ( divisor_rsh1$out )
  );

  // divisor_rsh2 temporaries
  wire   [   0:0] divisor_rsh2$reset;
  wire   [   0:0] divisor_rsh2$shamt;
  wire   [  63:0] divisor_rsh2$in_;
  wire   [   0:0] divisor_rsh2$clk;
  wire   [  63:0] divisor_rsh2$out;

  RightLogicalShifter_0x5e9be0d284b3480a divisor_rsh2
  (
    .reset ( divisor_rsh2$reset ),
    .shamt ( divisor_rsh2$shamt ),
    .in_   ( divisor_rsh2$in_ ),
    .clk   ( divisor_rsh2$clk ),
    .out   ( divisor_rsh2$out )
  );

  // signal connections
  assign divisor_mux$clk              = clk;
  assign divisor_mux$in_$000[30:0]    = 31'd0;
  assign divisor_mux$in_$000[62:31]   = b_negate;
  assign divisor_mux$in_$000[63:63]   = 1'd0;
  assign divisor_mux$in_$001          = divisor_rsh2$out;
  assign divisor_mux$reset            = reset;
  assign divisor_mux$sel              = divisor_mux_sel;
  assign divisor_reg$clk              = clk;
  assign divisor_reg$in_              = divisor_mux$out;
  assign divisor_reg$reset            = reset;
  assign divisor_rsh1$clk             = clk;
  assign divisor_rsh1$in_             = divisor_reg$out;
  assign divisor_rsh1$reset           = reset;
  assign divisor_rsh1$shamt           = 1'd1;
  assign divisor_rsh2$clk             = clk;
  assign divisor_rsh2$in_             = divisor_rsh1$out;
  assign divisor_rsh2$reset           = reset;
  assign divisor_rsh2$shamt           = 1'd1;
  assign is_div_reg$clk               = clk;
  assign is_div_reg$en                = buffers_en;
  assign is_div_reg$in_               = is_div;
  assign is_div_reg$reset             = reset;
  assign opaque_reg$clk               = clk;
  assign opaque_reg$en                = buffers_en;
  assign opaque_reg$in_               = req_msg_opaque;
  assign opaque_reg$reset             = reset;
  assign quotient_lsh$clk             = clk;
  assign quotient_lsh$in_             = quotient_reg$out;
  assign quotient_lsh$reset           = reset;
  assign quotient_lsh$shamt           = 2'd2;
  assign quotient_mux$clk             = clk;
  assign quotient_mux$reset           = reset;
  assign quotient_mux$sel             = quotient_mux_sel;
  assign quotient_reg$clk             = clk;
  assign quotient_reg$en              = quotient_reg_en;
  assign quotient_reg$in_             = quotient_mux$out;
  assign quotient_reg$reset           = reset;
  assign remainder_mid_mux$clk        = clk;
  assign remainder_mid_mux$in_$000    = sub1$out;
  assign remainder_mid_mux$in_$001    = remainder_reg$out;
  assign remainder_mid_mux$reset      = reset;
  assign remainder_mid_mux$sel        = sub_negative1;
  assign remainder_mux$clk            = clk;
  assign remainder_mux$in_$000[31:0]  = a_negate;
  assign remainder_mux$in_$000[63:32] = 32'd0;
  assign remainder_mux$in_$001        = sub1$out;
  assign remainder_mux$in_$002        = sub2$out;
  assign remainder_mux$reset          = reset;
  assign remainder_mux$sel            = remainder_mux_sel;
  assign remainder_reg$clk            = clk;
  assign remainder_reg$en             = remainder_reg_en;
  assign remainder_reg$in_            = remainder_mux$out;
  assign remainder_reg$reset          = reset;
  assign res_divrem_mux$clk           = clk;
  assign res_divrem_mux$in_$000       = res_rem_mux$out;
  assign res_divrem_mux$in_$001       = res_quo_mux$out;
  assign res_divrem_mux$reset         = reset;
  assign res_divrem_mux$sel           = is_div_reg$out;
  assign res_quo_mux$clk              = clk;
  assign res_quo_mux$in_$000          = quotient_reg$out;
  assign res_quo_mux$in_$001          = quo_negate;
  assign res_quo_mux$reset            = reset;
  assign res_quo_mux$sel              = res_quo_negate_flag$out;
  assign res_quo_negate_flag$clk      = clk;
  assign res_quo_negate_flag$en       = buffers_en;
  assign res_quo_negate_flag$in_      = res_quo_negate;
  assign res_quo_negate_flag$reset    = reset;
  assign res_rem_mux$clk              = clk;
  assign res_rem_mux$in_$000          = remainder_reg$out[31:0];
  assign res_rem_mux$in_$001          = rem_negate;
  assign res_rem_mux$reset            = reset;
  assign res_rem_mux$sel              = res_rem_negate_flag$out;
  assign res_rem_negate_flag$clk      = clk;
  assign res_rem_negate_flag$en       = buffers_en;
  assign res_rem_negate_flag$in_      = res_rem_negate;
  assign res_rem_negate_flag$reset    = reset;
  assign resp_opaque                  = opaque_reg$out;
  assign resp_result                  = res_divrem_mux$out;
  assign sub1$clk                     = clk;
  assign sub1$in0                     = remainder_reg$out;
  assign sub1$in1                     = divisor_reg$out;
  assign sub1$reset                   = reset;
  assign sub2$clk                     = clk;
  assign sub2$in0                     = remainder_mid_mux$out;
  assign sub2$in1                     = divisor_rsh1$out;
  assign sub2$reset                   = reset;
  assign sub_negative1                = sub1$out[63];
  assign sub_negative2                = sub2$out[63];

  // array declarations
  reg    [  31:0] quotient_mux$in_[0:1];
  assign quotient_mux$in_$000 = quotient_mux$in_[  0];
  assign quotient_mux$in_$001 = quotient_mux$in_[  1];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_negate_if_needed():
  //       s.a_negate.value = s.req_msg_a
  //       s.b_negate.value = s.req_msg_b
  //
  //       if s.is_signed & (s.req_msg_b != 0):
  //         if s.req_msg_a[nbits-1]:
  //           s.a_negate.value = ~s.req_msg_a + 1
  //         if s.req_msg_b[nbits-1]:
  //           s.b_negate.value = ~s.req_msg_b + 1

  // logic for comb_negate_if_needed()
  always @ (*) begin
    a_negate = req_msg_a;
    b_negate = req_msg_b;
    if ((is_signed&(req_msg_b != 0))) begin
      if (req_msg_a[(nbits-1)]) begin
        a_negate = (~req_msg_a+1);
      end
      else begin
      end
      if (req_msg_b[(nbits-1)]) begin
        b_negate = (~req_msg_b+1);
      end
      else begin
      end
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_quotient_mux_in():
  //       s.quotient_mux.in_[Q_MUX_SEL_0].value   = 0
  //       s.quotient_mux.in_[Q_MUX_SEL_LSH].value = s.quotient_lsh.out + \
  //         concat(~s.sub_negative1, ~s.sub_negative2)

  // logic for comb_quotient_mux_in()
  always @ (*) begin
    quotient_mux$in_[Q_MUX_SEL_0] = 0;
    quotient_mux$in_[Q_MUX_SEL_LSH] = (quotient_lsh$out+{ ~sub_negative1,~sub_negative2 });
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_res_negate_flags():
  //       s.res_rem_negate.value = s.is_signed & (s.req_msg_b != 0) & s.req_msg_a[nbits-1]
  //       s.res_quo_negate.value = s.is_signed & (s.req_msg_b != 0) & (s.req_msg_a[nbits-1] ^ s.req_msg_b[nbits-1])

  // logic for comb_res_negate_flags()
  always @ (*) begin
    res_rem_negate = ((is_signed&(req_msg_b != 0))&req_msg_a[(nbits-1)]);
    res_quo_negate = ((is_signed&(req_msg_b != 0))&(req_msg_a[(nbits-1)]^req_msg_b[(nbits-1)]));
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_negate_rem_quo():
  //       s.rem_negate.value = ~s.remainder_reg.out[0:nbits] + 1
  //       s.quo_negate.value = ~s.quotient_reg.out + 1

  // logic for comb_negate_rem_quo()
  always @ (*) begin
    rem_negate = (~remainder_reg$out[(nbits)-1:0]+1);
    quo_negate = (~quotient_reg$out+1);
  end


endmodule // IntDivRem4Dpath_0x23a9c358c75db7a2
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x1eed677bd3b5c175
//-----------------------------------------------------------------------------
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x1eed677bd3b5c175
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
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


endmodule // RegEn_0x1eed677bd3b5c175
`default_nettype wire

//-----------------------------------------------------------------------------
// Subtractor_0x2b59d76425453b4b
//-----------------------------------------------------------------------------
// nbits: 64
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Subtractor_0x2b59d76425453b4b
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in0,
  input  wire [  63:0] in1,
  output reg  [  63:0] out,
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


endmodule // Subtractor_0x2b59d76425453b4b
`default_nettype wire

//-----------------------------------------------------------------------------
// LeftLogicalShifter_0x58d64523f88e3a01
//-----------------------------------------------------------------------------
// inout_nbits: 32
// shamt_nbits: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module LeftLogicalShifter_0x58d64523f88e3a01
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] shamt
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ << s.shamt

  // logic for comb_logic()
  always @ (*) begin
    out = (in_<<shamt);
  end


endmodule // LeftLogicalShifter_0x58d64523f88e3a01
`default_nettype wire

//-----------------------------------------------------------------------------
// RightLogicalShifter_0x5e9be0d284b3480a
//-----------------------------------------------------------------------------
// inout_nbits: 64
// shamt_nbits: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RightLogicalShifter_0x5e9be0d284b3480a
(
  input  wire [   0:0] clk,
  input  wire [  63:0] in_,
  output reg  [  63:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] shamt
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ >> s.shamt

  // logic for comb_logic()
  always @ (*) begin
    out = (in_>>shamt);
  end


endmodule // RightLogicalShifter_0x5e9be0d284b3480a
`default_nettype wire

//-----------------------------------------------------------------------------
// InstBuffer_2_32B
//-----------------------------------------------------------------------------
// num_entries: 2
// line_nbytes: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module InstBuffer_2_32B
(
  input  wire [  77:0] buffreq_msg,
  output wire [   0:0] buffreq_rdy,
  input  wire [   0:0] buffreq_val,
  output wire [  47:0] buffresp_msg,
  input  wire [   0:0] buffresp_rdy,
  output wire [   0:0] buffresp_val,
  input  wire [   0:0] clk,
  output wire [ 304:0] memreq_msg,
  input  wire [   0:0] memreq_rdy,
  output wire [   0:0] memreq_val,
  input  wire [ 274:0] memresp_msg,
  output wire [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   1:0] ctrl$tag_match_mask;
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$memreq_rdy;
  wire   [   0:0] ctrl$memresp_val;
  wire   [   0:0] ctrl$buffresp_rdy;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$buffreq_val;
  wire   [   0:0] ctrl$way_sel_current;
  wire   [   1:0] ctrl$arrays_wen_mask;
  wire   [   0:0] ctrl$buffresp_val;
  wire   [   0:0] ctrl$memresp_rdy;
  wire   [   0:0] ctrl$way_sel;
  wire   [   0:0] ctrl$buffreq_rdy;
  wire   [   0:0] ctrl$buffresp_hit;
  wire   [   0:0] ctrl$buffreq_en;
  wire   [   0:0] ctrl$memreq_val;

  InstBufferCtrl_0x618a5bb1c2692bed ctrl
  (
    .tag_match_mask  ( ctrl$tag_match_mask ),
    .clk             ( ctrl$clk ),
    .memreq_rdy      ( ctrl$memreq_rdy ),
    .memresp_val     ( ctrl$memresp_val ),
    .buffresp_rdy    ( ctrl$buffresp_rdy ),
    .reset           ( ctrl$reset ),
    .buffreq_val     ( ctrl$buffreq_val ),
    .way_sel_current ( ctrl$way_sel_current ),
    .arrays_wen_mask ( ctrl$arrays_wen_mask ),
    .buffresp_val    ( ctrl$buffresp_val ),
    .memresp_rdy     ( ctrl$memresp_rdy ),
    .way_sel         ( ctrl$way_sel ),
    .buffreq_rdy     ( ctrl$buffreq_rdy ),
    .buffresp_hit    ( ctrl$buffresp_hit ),
    .buffreq_en      ( ctrl$buffreq_en ),
    .memreq_val      ( ctrl$memreq_val )
  );

  // resp_bypass temporaries
  wire   [   0:0] resp_bypass$clk;
  wire   [  47:0] resp_bypass$enq_msg;
  wire   [   0:0] resp_bypass$enq_val;
  wire   [   0:0] resp_bypass$reset;
  wire   [   0:0] resp_bypass$deq_rdy;
  wire   [   0:0] resp_bypass$enq_rdy;
  wire   [   0:0] resp_bypass$full;
  wire   [  47:0] resp_bypass$deq_msg;
  wire   [   0:0] resp_bypass$deq_val;

  SingleElementBypassQueue_0x6efe6bc018fd7126 resp_bypass
  (
    .clk     ( resp_bypass$clk ),
    .enq_msg ( resp_bypass$enq_msg ),
    .enq_val ( resp_bypass$enq_val ),
    .reset   ( resp_bypass$reset ),
    .deq_rdy ( resp_bypass$deq_rdy ),
    .enq_rdy ( resp_bypass$enq_rdy ),
    .full    ( resp_bypass$full ),
    .deq_msg ( resp_bypass$deq_msg ),
    .deq_val ( resp_bypass$deq_val )
  );

  // dpath temporaries
  wire   [ 274:0] dpath$memresp_msg;
  wire   [   0:0] dpath$way_sel_current;
  wire   [   0:0] dpath$way_sel;
  wire   [   0:0] dpath$clk;
  wire   [   1:0] dpath$arrays_wen_mask;
  wire   [   0:0] dpath$buffresp_hit;
  wire   [   0:0] dpath$buffreq_en;
  wire   [   0:0] dpath$reset;
  wire   [  77:0] dpath$buffreq_msg;
  wire   [  47:0] dpath$buffresp_msg;
  wire   [ 304:0] dpath$memreq_msg;
  wire   [   1:0] dpath$tag_match_mask;

  InstBufferDpath_0x3e710d7ddfe3566c dpath
  (
    .memresp_msg     ( dpath$memresp_msg ),
    .way_sel_current ( dpath$way_sel_current ),
    .way_sel         ( dpath$way_sel ),
    .clk             ( dpath$clk ),
    .arrays_wen_mask ( dpath$arrays_wen_mask ),
    .buffresp_hit    ( dpath$buffresp_hit ),
    .buffreq_en      ( dpath$buffreq_en ),
    .reset           ( dpath$reset ),
    .buffreq_msg     ( dpath$buffreq_msg ),
    .buffresp_msg    ( dpath$buffresp_msg ),
    .memreq_msg      ( dpath$memreq_msg ),
    .tag_match_mask  ( dpath$tag_match_mask )
  );

  // signal connections
  assign buffreq_rdy           = ctrl$buffreq_rdy;
  assign buffresp_msg          = resp_bypass$deq_msg;
  assign buffresp_val          = resp_bypass$deq_val;
  assign ctrl$buffreq_val      = buffreq_val;
  assign ctrl$buffresp_rdy     = resp_bypass$enq_rdy;
  assign ctrl$clk              = clk;
  assign ctrl$memreq_rdy       = memreq_rdy;
  assign ctrl$memresp_val      = memresp_val;
  assign ctrl$reset            = reset;
  assign ctrl$tag_match_mask   = dpath$tag_match_mask;
  assign dpath$arrays_wen_mask = ctrl$arrays_wen_mask;
  assign dpath$buffreq_en      = ctrl$buffreq_en;
  assign dpath$buffreq_msg     = buffreq_msg;
  assign dpath$buffresp_hit    = ctrl$buffresp_hit;
  assign dpath$clk             = clk;
  assign dpath$memresp_msg     = memresp_msg;
  assign dpath$reset           = reset;
  assign dpath$way_sel         = ctrl$way_sel;
  assign dpath$way_sel_current = ctrl$way_sel_current;
  assign memreq_msg            = dpath$memreq_msg;
  assign memreq_val            = ctrl$memreq_val;
  assign memresp_rdy           = ctrl$memresp_rdy;
  assign resp_bypass$clk       = clk;
  assign resp_bypass$deq_rdy   = buffresp_rdy;
  assign resp_bypass$enq_msg   = dpath$buffresp_msg;
  assign resp_bypass$enq_val   = ctrl$buffresp_val;
  assign resp_bypass$reset     = reset;



endmodule // InstBuffer_2_32B
`default_nettype wire

//-----------------------------------------------------------------------------
// InstBufferCtrl_0x618a5bb1c2692bed
//-----------------------------------------------------------------------------
// num_entries: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module InstBufferCtrl_0x618a5bb1c2692bed
(
  output reg  [   1:0] arrays_wen_mask,
  output reg  [   0:0] buffreq_en,
  output reg  [   0:0] buffreq_rdy,
  input  wire [   0:0] buffreq_val,
  output reg  [   0:0] buffresp_hit,
  input  wire [   0:0] buffresp_rdy,
  output reg  [   0:0] buffresp_val,
  input  wire [   0:0] clk,
  input  wire [   0:0] memreq_rdy,
  output reg  [   0:0] memreq_val,
  output reg  [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset,
  input  wire [   1:0] tag_match_mask,
  output wire [   0:0] way_sel,
  output reg  [   0:0] way_sel_current
);

  // wire declarations
  wire   [   0:0] lru_way;
  wire   [   1:0] is_valid_mask;


  // register declarations
  reg    [   0:0] arrays_wen;
  reg    [  10:0] cs;
  reg    [   0:0] hit;
  reg    [   1:0] hit_mask;
  reg    [   0:0] in_go;
  reg    [   0:0] lru_in;
  reg    [   0:0] lru_wen;
  reg    [   0:0] out_go;
  reg    [   2:0] sr__7;
  reg    [   2:0] state_next;
  reg    [   2:0] state_reg;
  reg    [   0:0] valid_bit_in;
  reg    [   0:0] valid_bits_wen;
  reg    [   1:0] valid_bits_wen_mask;
  reg    [   0:0] way_record_en;
  reg    [   0:0] way_record_in;

  // localparam declarations
  localparam STATE_IDLE = 3'd0;
  localparam STATE_MISS_ACCESS = 3'd2;
  localparam STATE_REFILL_REQUEST = 3'd5;
  localparam STATE_REFILL_UPDATE = 3'd7;
  localparam STATE_REFILL_WAIT = 3'd6;
  localparam STATE_TAG_CHECK = 3'd1;
  localparam STATE_WAIT_HIT = 3'd3;
  localparam STATE_WAIT_MISS = 3'd4;
  localparam n = 1'd0;
  localparam num_entries = 2;
  localparam x = 1'd0;
  localparam y = 1'd1;

  // loop variable declarations
  integer i;

  // valid_bits$000 temporaries
  wire   [   0:0] valid_bits$000$reset;
  wire   [   0:0] valid_bits$000$en;
  wire   [   0:0] valid_bits$000$clk;
  wire   [   0:0] valid_bits$000$in_;
  wire   [   0:0] valid_bits$000$out;

  RegEnRst_0x2ce052f8c32c5c39 valid_bits$000
  (
    .reset ( valid_bits$000$reset ),
    .en    ( valid_bits$000$en ),
    .clk   ( valid_bits$000$clk ),
    .in_   ( valid_bits$000$in_ ),
    .out   ( valid_bits$000$out )
  );

  // valid_bits$001 temporaries
  wire   [   0:0] valid_bits$001$reset;
  wire   [   0:0] valid_bits$001$en;
  wire   [   0:0] valid_bits$001$clk;
  wire   [   0:0] valid_bits$001$in_;
  wire   [   0:0] valid_bits$001$out;

  RegEnRst_0x2ce052f8c32c5c39 valid_bits$001
  (
    .reset ( valid_bits$001$reset ),
    .en    ( valid_bits$001$en ),
    .clk   ( valid_bits$001$clk ),
    .in_   ( valid_bits$001$in_ ),
    .out   ( valid_bits$001$out )
  );

  // lru temporaries
  wire   [   0:0] lru$reset;
  wire   [   0:0] lru$en;
  wire   [   0:0] lru$clk;
  wire   [   0:0] lru$in_;
  wire   [   0:0] lru$out;

  RegEnRst_0x2ce052f8c32c5c39 lru
  (
    .reset ( lru$reset ),
    .en    ( lru$en ),
    .clk   ( lru$clk ),
    .in_   ( lru$in_ ),
    .out   ( lru$out )
  );

  // way_record temporaries
  wire   [   0:0] way_record$reset;
  wire   [   0:0] way_record$en;
  wire   [   0:0] way_record$clk;
  wire   [   0:0] way_record$in_;
  wire   [   0:0] way_record$out;

  RegEnRst_0x2ce052f8c32c5c39 way_record
  (
    .reset ( way_record$reset ),
    .en    ( way_record$en ),
    .clk   ( way_record$clk ),
    .in_   ( way_record$in_ ),
    .out   ( way_record$out )
  );

  // signal connections
  assign is_valid_mask[0]     = valid_bits$000$out;
  assign is_valid_mask[1]     = valid_bits$001$out;
  assign lru$clk              = clk;
  assign lru$en               = lru_wen;
  assign lru$in_              = lru_in;
  assign lru$reset            = reset;
  assign lru_way              = lru$out;
  assign valid_bits$000$clk   = clk;
  assign valid_bits$000$en    = valid_bits_wen_mask[0];
  assign valid_bits$000$in_   = valid_bit_in;
  assign valid_bits$000$reset = reset;
  assign valid_bits$001$clk   = clk;
  assign valid_bits$001$en    = valid_bits_wen_mask[1];
  assign valid_bits$001$in_   = valid_bit_in;
  assign valid_bits$001$reset = reset;
  assign way_record$clk       = clk;
  assign way_record$en        = way_record_en;
  assign way_record$in_       = way_record_in;
  assign way_record$reset     = reset;
  assign way_sel              = way_record$out;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_state():
  //       if s.reset:
  //         s.state_reg.next = s.STATE_IDLE
  //       else:
  //         s.state_reg.next = s.state_next

  // logic for reg_state()
  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= STATE_IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_state_transition():
  //       s.in_go.value     = s.buffreq_val  & s.buffreq_rdy
  //       s.out_go.value    = s.buffresp_val & s.buffresp_rdy
  //       s.hit_mask.value  = s.is_valid_mask & s.tag_match_mask
  //       s.hit.value       = reduce_or( s.hit_mask )

  // logic for comb_state_transition()
  always @ (*) begin
    in_go = (buffreq_val&buffreq_rdy);
    out_go = (buffresp_val&buffresp_rdy);
    hit_mask = (is_valid_mask&tag_match_mask);
    hit = (|hit_mask);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_next_state():
  //       s.state_next.value = s.state_reg
  //
  //       if s.state_reg == s.STATE_IDLE:
  //         if s.in_go: s.state_next.value = s.STATE_TAG_CHECK
  //
  //       elif s.state_reg == s.STATE_TAG_CHECK:
  //         if s.hit:
  //           # requester is not ready to accept a response, wait
  //           if ~s.buffresp_rdy:  s.state_next.value = s.STATE_WAIT_HIT
  //           # can send the response, and there is an upcoming request, stay in TC for b-2-b reqs
  //           elif s.buffreq_val:  s.state_next.value = s.STATE_TAG_CHECK
  //           # can send the response, but no upcoming request, return to idle
  //           else:                s.state_next.value = s.STATE_IDLE
  //
  //         else: # miss -- need to refill
  //           s.state_next.value = s.STATE_REFILL_REQUEST
  //
  //       elif s.state_reg == s.STATE_REFILL_REQUEST:
  //         if s.memreq_rdy: s.state_next.value = s.STATE_REFILL_WAIT
  //
  //       elif s.state_reg == s.STATE_REFILL_WAIT:
  //         if s.memresp_val: s.state_next.value = s.STATE_REFILL_UPDATE
  //
  //       elif s.state_reg == s.STATE_REFILL_UPDATE:
  //         s.state_next.value = s.STATE_MISS_ACCESS
  //
  //       elif s.state_reg == s.STATE_MISS_ACCESS:
  //         s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_WAIT_HIT:
  //         if s.out_go: s.state_next.value = s.STATE_IDLE
  //
  //       elif s.state_reg == s.STATE_WAIT_MISS:
  //         if s.out_go: s.state_next.value = s.STATE_IDLE
  //
  //       else:
  //         s.state_next.value = s.STATE_IDLE

  // logic for comb_next_state()
  always @ (*) begin
    state_next = state_reg;
    if ((state_reg == STATE_IDLE)) begin
      if (in_go) begin
        state_next = STATE_TAG_CHECK;
      end
      else begin
      end
    end
    else begin
      if ((state_reg == STATE_TAG_CHECK)) begin
        if (hit) begin
          if (~buffresp_rdy) begin
            state_next = STATE_WAIT_HIT;
          end
          else begin
            if (buffreq_val) begin
              state_next = STATE_TAG_CHECK;
            end
            else begin
              state_next = STATE_IDLE;
            end
          end
        end
        else begin
          state_next = STATE_REFILL_REQUEST;
        end
      end
      else begin
        if ((state_reg == STATE_REFILL_REQUEST)) begin
          if (memreq_rdy) begin
            state_next = STATE_REFILL_WAIT;
          end
          else begin
          end
        end
        else begin
          if ((state_reg == STATE_REFILL_WAIT)) begin
            if (memresp_val) begin
              state_next = STATE_REFILL_UPDATE;
            end
            else begin
            end
          end
          else begin
            if ((state_reg == STATE_REFILL_UPDATE)) begin
              state_next = STATE_MISS_ACCESS;
            end
            else begin
              if ((state_reg == STATE_MISS_ACCESS)) begin
                state_next = STATE_WAIT_MISS;
              end
              else begin
                if ((state_reg == STATE_WAIT_HIT)) begin
                  if (out_go) begin
                    state_next = STATE_IDLE;
                  end
                  else begin
                  end
                end
                else begin
                  if ((state_reg == STATE_WAIT_MISS)) begin
                    if (out_go) begin
                      state_next = STATE_IDLE;
                    end
                    else begin
                    end
                  end
                  else begin
                    state_next = STATE_IDLE;
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_valid_bits():
  //       for i in xrange(num_entries):
  //         s.valid_bits_wen_mask[i].value = s.valid_bits_wen & (s.way_sel_current == i)

  // logic for comb_valid_bits()
  always @ (*) begin
    for (i=0; i < num_entries; i=i+1)
    begin
      valid_bits_wen_mask[i] = (valid_bits_wen&(way_sel_current == i));
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_lru_in():
  //       s.lru_in.value = ~s.way_sel_current 

  // logic for comb_lru_in()
  always @ (*) begin
    lru_in = ~way_sel_current;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_way_select():
  //       # Hardcoded for 2 entries
  //       if   s.hit_mask[0]:
  //         s.way_record_in.value = Bits( 1, 0 )
  //       elif s.hit_mask[1]:
  //         s.way_record_in.value = Bits( 1, 1 )
  //       else:
  //         s.way_record_in.value = s.lru_way
  //
  //       if s.state_reg == s.STATE_TAG_CHECK:
  //         s.way_sel_current.value = s.way_record_in
  //       else:
  //         s.way_sel_current.value = s.way_sel

  // logic for comb_way_select()
  always @ (*) begin
    if (hit_mask[0]) begin
      way_record_in = 1'd0;
    end
    else begin
      if (hit_mask[1]) begin
        way_record_in = 1'd1;
      end
      else begin
        way_record_in = lru_way;
      end
    end
    if ((state_reg == STATE_TAG_CHECK)) begin
      way_sel_current = way_record_in;
    end
    else begin
      way_sel_current = way_sel;
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_arrays_en():
  //       for i in xrange(num_entries):
  //         s.arrays_wen_mask[i].value = s.arrays_wen & (s.way_sel_current == i)

  // logic for comb_arrays_en()
  always @ (*) begin
    for (i=0; i < num_entries; i=i+1)
    begin
      arrays_wen_mask[i] = (arrays_wen&(way_sel_current == i));
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_control_table():
  //       sr = s.state_reg
  //
  //       #                                                       $   $    mem mem  $   val val lru way  $       arrays
  //       #                                                       req resp req resp req bit wen wen rec  resp N  wen
  //       #                                                       rdy val  val rdy  en  in          en   hit  S
  //       s.cs.value                                    = concat( n,  n,   n,  n,   x,  x,  n,  n,  n,   n,      n  )
  //       if   sr == s.STATE_IDLE:           s.cs.value = concat( y,  n,   n,  n,   y,  x,  n,  n,  n,   n,      n  )
  //       elif sr == s.STATE_TAG_CHECK:      s.cs.value = concat( n,  n,   n,  n,   n,  x,  n,  y,  y,   n,      n  )
  //       elif sr == s.STATE_MISS_ACCESS:    s.cs.value = concat( n,  n,   n,  n,   n,  x,  n,  y,  n,   n,      n  )
  //       elif sr == s.STATE_REFILL_REQUEST: s.cs.value = concat( n,  n,   y,  n,   n,  x,  n,  n,  n,   n,      n  )
  //       elif sr == s.STATE_REFILL_WAIT:    s.cs.value = concat( n,  n,   n,  y,   n,  x,  n,  n,  n,   n,      n  )
  //       elif sr == s.STATE_REFILL_UPDATE:  s.cs.value = concat( n,  n,   n,  n,   n,  y,  y,  n,  n,   n,      y  )
  //       elif sr == s.STATE_WAIT_HIT:       s.cs.value = concat( n,  y,   n,  n,   n,  x,  n,  n,  n,   y,      n  )
  //       elif sr == s.STATE_WAIT_MISS:      s.cs.value = concat( n,  y,   n,  n,   n,  x,  n,  n,  n,   n,      n  )
  //       else:                              s.cs.value = concat( n,  n,   n,  n,   n,  x,  n,  n,  n,   n,      n  )
  //
  //       # Unpack signals
  //
  //       s.buffreq_rdy.value    = s.cs[ CS_buffreq_rdy    ]
  //       s.buffresp_val.value   = s.cs[ CS_buffresp_val   ]
  //       s.memreq_val.value     = s.cs[ CS_memreq_val     ]
  //       s.memresp_rdy.value    = s.cs[ CS_memresp_rdy    ]
  //       s.buffreq_en.value     = s.cs[ CS_buffreq_en     ]
  //       s.valid_bit_in.value   = s.cs[ CS_valid_bit_in   ]
  //       s.valid_bits_wen.value = s.cs[ CS_valid_bits_wen ]
  //       s.lru_wen.value        = s.cs[ CS_lru_wen        ]
  //       s.way_record_en.value  = s.cs[ CS_way_record_en  ]
  //       s.buffresp_hit.value   = s.cs[ CS_buffresp_hit   ]
  //       s.arrays_wen.value     = s.cs[ CS_NS_arrays_wen  ]
  //
  //       # set buffresp_val when there is a hit for one hit latency
  //
  //       if s.hit & (s.state_reg == s.STATE_TAG_CHECK): # operator priority!!!
  //         s.buffresp_val.value = 1
  //         s.buffresp_hit.value = 1
  //
  //         # if can send response, immediately take new buffreq
  //         s.buffreq_rdy.value  = s.buffresp_rdy
  //         s.buffreq_en.value   = s.buffresp_rdy

  // logic for comb_control_table()
  always @ (*) begin
    sr__7 = state_reg;
    cs = { n,n,n,n,x,x,n,n,n,n,n };
    if ((sr__7 == STATE_IDLE)) begin
      cs = { y,n,n,n,y,x,n,n,n,n,n };
    end
    else begin
      if ((sr__7 == STATE_TAG_CHECK)) begin
        cs = { n,n,n,n,n,x,n,y,y,n,n };
      end
      else begin
        if ((sr__7 == STATE_MISS_ACCESS)) begin
          cs = { n,n,n,n,n,x,n,y,n,n,n };
        end
        else begin
          if ((sr__7 == STATE_REFILL_REQUEST)) begin
            cs = { n,n,y,n,n,x,n,n,n,n,n };
          end
          else begin
            if ((sr__7 == STATE_REFILL_WAIT)) begin
              cs = { n,n,n,y,n,x,n,n,n,n,n };
            end
            else begin
              if ((sr__7 == STATE_REFILL_UPDATE)) begin
                cs = { n,n,n,n,n,y,y,n,n,n,y };
              end
              else begin
                if ((sr__7 == STATE_WAIT_HIT)) begin
                  cs = { n,y,n,n,n,x,n,n,n,y,n };
                end
                else begin
                  if ((sr__7 == STATE_WAIT_MISS)) begin
                    cs = { n,y,n,n,n,x,n,n,n,n,n };
                  end
                  else begin
                    cs = { n,n,n,n,n,x,n,n,n,n,n };
                  end
                end
              end
            end
          end
        end
      end
    end
    buffreq_rdy = cs[(11)-1:10];
    buffresp_val = cs[(10)-1:9];
    memreq_val = cs[(9)-1:8];
    memresp_rdy = cs[(8)-1:7];
    buffreq_en = cs[(7)-1:6];
    valid_bit_in = cs[(6)-1:5];
    valid_bits_wen = cs[(5)-1:4];
    lru_wen = cs[(4)-1:3];
    way_record_en = cs[(3)-1:2];
    buffresp_hit = cs[(2)-1:1];
    arrays_wen = cs[(1)-1:0];
    if ((hit&(state_reg == STATE_TAG_CHECK))) begin
      buffresp_val = 1;
      buffresp_hit = 1;
      buffreq_rdy = buffresp_rdy;
      buffreq_en = buffresp_rdy;
    end
    else begin
    end
  end


endmodule // InstBufferCtrl_0x618a5bb1c2692bed
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x2ce052f8c32c5c39
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x2ce052f8c32c5c39
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   0:0] in_,
  output reg  [   0:0] out,
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
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x2ce052f8c32c5c39
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x6efe6bc018fd7126
//-----------------------------------------------------------------------------
// dtype: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x6efe6bc018fd7126
(
  input  wire [   0:0] clk,
  output wire [  47:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  47:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   0:0] full,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$bypass_mux_sel;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$full;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk            ( ctrl$clk ),
    .enq_val        ( ctrl$enq_val ),
    .reset          ( ctrl$reset ),
    .deq_rdy        ( ctrl$deq_rdy ),
    .bypass_mux_sel ( ctrl$bypass_mux_sel ),
    .wen            ( ctrl$wen ),
    .deq_val        ( ctrl$deq_val ),
    .full           ( ctrl$full ),
    .enq_rdy        ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$bypass_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$reset;
  wire   [  47:0] dpath$enq_bits;
  wire   [  47:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x6efe6bc018fd7126 dpath
  (
    .wen            ( dpath$wen ),
    .bypass_mux_sel ( dpath$bypass_mux_sel ),
    .clk            ( dpath$clk ),
    .reset          ( dpath$reset ),
    .enq_bits       ( dpath$enq_bits ),
    .deq_bits       ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk             = clk;
  assign ctrl$deq_rdy         = deq_rdy;
  assign ctrl$enq_val         = enq_val;
  assign ctrl$reset           = reset;
  assign deq_msg              = dpath$deq_bits;
  assign deq_val              = ctrl$deq_val;
  assign dpath$bypass_mux_sel = ctrl$bypass_mux_sel;
  assign dpath$clk            = clk;
  assign dpath$enq_bits       = enq_msg;
  assign dpath$reset          = reset;
  assign dpath$wen            = ctrl$wen;
  assign enq_rdy              = ctrl$enq_rdy;
  assign full                 = ctrl$full;



endmodule // SingleElementBypassQueue_0x6efe6bc018fd7126
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88
(
  output reg  [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   0:0] full,
  input  wire [   0:0] reset,
  output reg  [   0:0] wen
);

  // register declarations
  reg    [   0:0] do_bypass;
  reg    [   0:0] do_deq;
  reg    [   0:0] do_enq;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq():
  //
  //       # TODO: can't use temporaries here, verilog simulation semantics
  //       #       don't match the Python semantics!
  //       ## helper signals
  //
  //       #do_deq    = s.deq_rdy and s.deq_val
  //       #do_enq    = s.enq_rdy and s.enq_val
  //       #do_bypass = ~s.full and do_deq and do_enq
  //
  //       # full bit calculation: the full bit is cleared when a dequeue
  //       # transaction occurs; the full bit is set when the queue storage is
  //       # empty and a enqueue transaction occurs and when we are not bypassing
  //
  //       if   s.reset:                      s.full.next = 0
  //       elif s.do_deq:                     s.full.next = 0
  //       elif s.do_enq and not s.do_bypass: s.full.next = 1
  //       else:                              s.full.next = s.full

  // logic for seq()
  always @ (posedge clk) begin
    if (reset) begin
      full <= 0;
    end
    else begin
      if (do_deq) begin
        full <= 0;
      end
      else begin
        if ((do_enq&&!do_bypass)) begin
          full <= 1;
        end
        else begin
          full <= full;
        end
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb():
  //
  //       # bypass is always enabled when the queue is empty
  //
  //       s.bypass_mux_sel.value = ~s.full
  //
  //       # wen control signal: set the write enable signal if the storage queue
  //       # is empty and a valid enqueue request is present
  //
  //       s.wen.value = ~s.full & s.enq_val
  //
  //       # enq_rdy signal is asserted when the single element queue storage is
  //       # empty
  //
  //       s.enq_rdy.value = ~s.full
  //
  //       # deq_val signal is asserted when the single element queue storage is
  //       # full or when the queue is empty but we are bypassing
  //
  //       s.deq_val.value = s.full | ( ~s.full & s.enq_val )
  //
  //       # TODO: figure out how to make these work as temporaries
  //       # helper signals
  //
  //       s.do_deq.value    = s.deq_rdy and s.deq_val
  //       s.do_enq.value    = s.enq_rdy and s.enq_val
  //       s.do_bypass.value = ~s.full and s.do_deq and s.do_enq

  // logic for comb()
  always @ (*) begin
    bypass_mux_sel = ~full;
    wen = (~full&enq_val);
    enq_rdy = ~full;
    deq_val = (full|(~full&enq_val));
    do_deq = (deq_rdy&&deq_val);
    do_enq = (enq_rdy&&enq_val);
    do_bypass = (~full&&do_deq&&do_enq);
  end


endmodule // SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x6efe6bc018fd7126
//-----------------------------------------------------------------------------
// dtype: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x6efe6bc018fd7126
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  47:0] deq_bits,
  input  wire [  47:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  47:0] bypass_mux$in_$000;
  wire   [  47:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  47:0] bypass_mux$out;

  Mux_0x658bad8178bff57a bypass_mux
  (
    .reset   ( bypass_mux$reset ),
    .in_$000 ( bypass_mux$in_$000 ),
    .in_$001 ( bypass_mux$in_$001 ),
    .clk     ( bypass_mux$clk ),
    .sel     ( bypass_mux$sel ),
    .out     ( bypass_mux$out )
  );

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  47:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  47:0] queue$out;

  RegEn_0x720f4c6c66ec06fb queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign bypass_mux$clk     = clk;
  assign bypass_mux$in_$000 = queue$out;
  assign bypass_mux$in_$001 = enq_bits;
  assign bypass_mux$reset   = reset;
  assign bypass_mux$sel     = bypass_mux_sel;
  assign deq_bits           = bypass_mux$out;
  assign queue$clk          = clk;
  assign queue$en           = wen;
  assign queue$in_          = enq_bits;
  assign queue$reset        = reset;



endmodule // SingleElementBypassQueueDpath_0x6efe6bc018fd7126
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x658bad8178bff57a
//-----------------------------------------------------------------------------
// dtype: 48
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x658bad8178bff57a
(
  input  wire [   0:0] clk,
  input  wire [  47:0] in_$000,
  input  wire [  47:0] in_$001,
  output reg  [  47:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  47:0] in_[0:1];
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


endmodule // Mux_0x658bad8178bff57a
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x720f4c6c66ec06fb
//-----------------------------------------------------------------------------
// dtype: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x720f4c6c66ec06fb
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  47:0] in_,
  output reg  [  47:0] out,
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


endmodule // RegEn_0x720f4c6c66ec06fb
`default_nettype wire

//-----------------------------------------------------------------------------
// InstBufferDpath_0x3e710d7ddfe3566c
//-----------------------------------------------------------------------------
// num_entries: 2
// line_nbytes: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module InstBufferDpath_0x3e710d7ddfe3566c
(
  input  wire [   1:0] arrays_wen_mask,
  input  wire [   0:0] buffreq_en,
  input  wire [  77:0] buffreq_msg,
  input  wire [   0:0] buffresp_hit,
  output reg  [  47:0] buffresp_msg,
  input  wire [   0:0] clk,
  output reg  [ 304:0] memreq_msg,
  input  wire [ 274:0] memresp_msg,
  input  wire [   0:0] reset,
  output wire [   1:0] tag_match_mask,
  input  wire [   0:0] way_sel,
  input  wire [   0:0] way_sel_current
);

  // wire declarations
  wire   [ 255:0] read_data;


  // localparam declarations
  localparam TYPE_READ = 0;
  localparam addr_nbits = 32;
  localparam line_bw = 5;
  localparam opaque_nbits = 8;

  // tag_array$000 temporaries
  wire   [   0:0] tag_array$000$reset;
  wire   [   0:0] tag_array$000$en;
  wire   [   0:0] tag_array$000$clk;
  wire   [  26:0] tag_array$000$in_;
  wire   [  26:0] tag_array$000$out;

  RegEnRst_0xd239a4c17e8ef97 tag_array$000
  (
    .reset ( tag_array$000$reset ),
    .en    ( tag_array$000$en ),
    .clk   ( tag_array$000$clk ),
    .in_   ( tag_array$000$in_ ),
    .out   ( tag_array$000$out )
  );

  // tag_array$001 temporaries
  wire   [   0:0] tag_array$001$reset;
  wire   [   0:0] tag_array$001$en;
  wire   [   0:0] tag_array$001$clk;
  wire   [  26:0] tag_array$001$in_;
  wire   [  26:0] tag_array$001$out;

  RegEnRst_0xd239a4c17e8ef97 tag_array$001
  (
    .reset ( tag_array$001$reset ),
    .en    ( tag_array$001$en ),
    .clk   ( tag_array$001$clk ),
    .in_   ( tag_array$001$in_ ),
    .out   ( tag_array$001$out )
  );

  // buffreq_opaque_reg temporaries
  wire   [   0:0] buffreq_opaque_reg$reset;
  wire   [   0:0] buffreq_opaque_reg$en;
  wire   [   0:0] buffreq_opaque_reg$clk;
  wire   [   7:0] buffreq_opaque_reg$in_;
  wire   [   7:0] buffreq_opaque_reg$out;

  RegEnRst_0x513e5624ff809260 buffreq_opaque_reg
  (
    .reset ( buffreq_opaque_reg$reset ),
    .en    ( buffreq_opaque_reg$en ),
    .clk   ( buffreq_opaque_reg$clk ),
    .in_   ( buffreq_opaque_reg$in_ ),
    .out   ( buffreq_opaque_reg$out )
  );

  // buffreq_addr_reg temporaries
  wire   [   0:0] buffreq_addr_reg$reset;
  wire   [   0:0] buffreq_addr_reg$en;
  wire   [   0:0] buffreq_addr_reg$clk;
  wire   [  31:0] buffreq_addr_reg$in_;
  wire   [  31:0] buffreq_addr_reg$out;

  RegEnRst_0x3857337130dc0828 buffreq_addr_reg
  (
    .reset ( buffreq_addr_reg$reset ),
    .en    ( buffreq_addr_reg$en ),
    .clk   ( buffreq_addr_reg$clk ),
    .in_   ( buffreq_addr_reg$in_ ),
    .out   ( buffreq_addr_reg$out )
  );

  // data_read_mux temporaries
  wire   [   0:0] data_read_mux$reset;
  wire   [ 255:0] data_read_mux$in_$000;
  wire   [ 255:0] data_read_mux$in_$001;
  wire   [   0:0] data_read_mux$clk;
  wire   [   0:0] data_read_mux$sel;
  wire   [ 255:0] data_read_mux$out;

  Mux_0x4c6a83602fe32a6a data_read_mux
  (
    .reset   ( data_read_mux$reset ),
    .in_$000 ( data_read_mux$in_$000 ),
    .in_$001 ( data_read_mux$in_$001 ),
    .clk     ( data_read_mux$clk ),
    .sel     ( data_read_mux$sel ),
    .out     ( data_read_mux$out )
  );

  // read_word_sel_mux temporaries
  wire   [   0:0] read_word_sel_mux$reset;
  wire   [  31:0] read_word_sel_mux$in_$000;
  wire   [  31:0] read_word_sel_mux$in_$001;
  wire   [  31:0] read_word_sel_mux$in_$002;
  wire   [  31:0] read_word_sel_mux$in_$003;
  wire   [  31:0] read_word_sel_mux$in_$004;
  wire   [  31:0] read_word_sel_mux$in_$005;
  wire   [  31:0] read_word_sel_mux$in_$006;
  wire   [  31:0] read_word_sel_mux$in_$007;
  wire   [   0:0] read_word_sel_mux$clk;
  wire   [   2:0] read_word_sel_mux$sel;
  wire   [  31:0] read_word_sel_mux$out;

  Mux_0x32dec190374e5128 read_word_sel_mux
  (
    .reset   ( read_word_sel_mux$reset ),
    .in_$000 ( read_word_sel_mux$in_$000 ),
    .in_$001 ( read_word_sel_mux$in_$001 ),
    .in_$002 ( read_word_sel_mux$in_$002 ),
    .in_$003 ( read_word_sel_mux$in_$003 ),
    .in_$004 ( read_word_sel_mux$in_$004 ),
    .in_$005 ( read_word_sel_mux$in_$005 ),
    .in_$006 ( read_word_sel_mux$in_$006 ),
    .in_$007 ( read_word_sel_mux$in_$007 ),
    .clk     ( read_word_sel_mux$clk ),
    .sel     ( read_word_sel_mux$sel ),
    .out     ( read_word_sel_mux$out )
  );

  // tag_compare$000 temporaries
  wire   [   0:0] tag_compare$000$reset;
  wire   [   0:0] tag_compare$000$clk;
  wire   [  26:0] tag_compare$000$in0;
  wire   [  26:0] tag_compare$000$in1;
  wire   [   0:0] tag_compare$000$out;

  EqComparator_0x4c7a718b2f9234c tag_compare$000
  (
    .reset ( tag_compare$000$reset ),
    .clk   ( tag_compare$000$clk ),
    .in0   ( tag_compare$000$in0 ),
    .in1   ( tag_compare$000$in1 ),
    .out   ( tag_compare$000$out )
  );

  // tag_compare$001 temporaries
  wire   [   0:0] tag_compare$001$reset;
  wire   [   0:0] tag_compare$001$clk;
  wire   [  26:0] tag_compare$001$in0;
  wire   [  26:0] tag_compare$001$in1;
  wire   [   0:0] tag_compare$001$out;

  EqComparator_0x4c7a718b2f9234c tag_compare$001
  (
    .reset ( tag_compare$001$reset ),
    .clk   ( tag_compare$001$clk ),
    .in0   ( tag_compare$001$in0 ),
    .in1   ( tag_compare$001$in1 ),
    .out   ( tag_compare$001$out )
  );

  // data_array$000 temporaries
  wire   [   0:0] data_array$000$reset;
  wire   [   0:0] data_array$000$en;
  wire   [   0:0] data_array$000$clk;
  wire   [ 255:0] data_array$000$in_;
  wire   [ 255:0] data_array$000$out;

  RegEnRst_0x1c65c01affad8788 data_array$000
  (
    .reset ( data_array$000$reset ),
    .en    ( data_array$000$en ),
    .clk   ( data_array$000$clk ),
    .in_   ( data_array$000$in_ ),
    .out   ( data_array$000$out )
  );

  // data_array$001 temporaries
  wire   [   0:0] data_array$001$reset;
  wire   [   0:0] data_array$001$en;
  wire   [   0:0] data_array$001$clk;
  wire   [ 255:0] data_array$001$in_;
  wire   [ 255:0] data_array$001$out;

  RegEnRst_0x1c65c01affad8788 data_array$001
  (
    .reset ( data_array$001$reset ),
    .en    ( data_array$001$en ),
    .clk   ( data_array$001$clk ),
    .in_   ( data_array$001$in_ ),
    .out   ( data_array$001$out )
  );

  // signal connections
  assign buffreq_addr_reg$clk      = clk;
  assign buffreq_addr_reg$en       = buffreq_en;
  assign buffreq_addr_reg$in_      = buffreq_msg[65:34];
  assign buffreq_addr_reg$reset    = reset;
  assign buffreq_opaque_reg$clk    = clk;
  assign buffreq_opaque_reg$en     = buffreq_en;
  assign buffreq_opaque_reg$in_    = buffreq_msg[73:66];
  assign buffreq_opaque_reg$reset  = reset;
  assign buffresp_msg[43:36]       = buffreq_opaque_reg$out;
  assign data_array$000$clk        = clk;
  assign data_array$000$en         = arrays_wen_mask[0];
  assign data_array$000$in_        = memresp_msg[255:0];
  assign data_array$000$reset      = reset;
  assign data_array$001$clk        = clk;
  assign data_array$001$en         = arrays_wen_mask[1];
  assign data_array$001$in_        = memresp_msg[255:0];
  assign data_array$001$reset      = reset;
  assign data_read_mux$clk         = clk;
  assign data_read_mux$in_$000     = data_array$000$out;
  assign data_read_mux$in_$001     = data_array$001$out;
  assign data_read_mux$reset       = reset;
  assign data_read_mux$sel         = way_sel_current;
  assign read_data                 = data_read_mux$out;
  assign read_word_sel_mux$clk     = clk;
  assign read_word_sel_mux$in_$000 = read_data[31:0];
  assign read_word_sel_mux$in_$001 = read_data[63:32];
  assign read_word_sel_mux$in_$002 = read_data[95:64];
  assign read_word_sel_mux$in_$003 = read_data[127:96];
  assign read_word_sel_mux$in_$004 = read_data[159:128];
  assign read_word_sel_mux$in_$005 = read_data[191:160];
  assign read_word_sel_mux$in_$006 = read_data[223:192];
  assign read_word_sel_mux$in_$007 = read_data[255:224];
  assign read_word_sel_mux$reset   = reset;
  assign read_word_sel_mux$sel     = buffreq_addr_reg$out[4:2];
  assign tag_array$000$clk         = clk;
  assign tag_array$000$en          = arrays_wen_mask[0];
  assign tag_array$000$in_         = buffreq_addr_reg$out[31:5];
  assign tag_array$000$reset       = reset;
  assign tag_array$001$clk         = clk;
  assign tag_array$001$en          = arrays_wen_mask[1];
  assign tag_array$001$in_         = buffreq_addr_reg$out[31:5];
  assign tag_array$001$reset       = reset;
  assign tag_compare$000$clk       = clk;
  assign tag_compare$000$in0       = buffreq_addr_reg$out[31:5];
  assign tag_compare$000$in1       = tag_array$000$out;
  assign tag_compare$000$reset     = reset;
  assign tag_compare$001$clk       = clk;
  assign tag_compare$001$in0       = buffreq_addr_reg$out[31:5];
  assign tag_compare$001$in1       = tag_array$001$out;
  assign tag_compare$001$reset     = reset;
  assign tag_match_mask[0]         = tag_compare$000$out;
  assign tag_match_mask[1]         = tag_compare$001$out;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_buffresp_msg_pack():
  //       s.buffresp_msg.type_.value = MemRespMsg.TYPE_READ
  //       s.buffresp_msg.test.value  = concat( Bits( 1, 0 ), s.buffresp_hit )
  //       s.buffresp_msg.len.value   = Bits( 2, 0 )
  //       s.buffresp_msg.data.value  = s.read_word_sel_mux.out

  // logic for comb_buffresp_msg_pack()
  always @ (*) begin
    buffresp_msg[(48)-1:44] = TYPE_READ;
    buffresp_msg[(36)-1:34] = { 1'd0,buffresp_hit };
    buffresp_msg[(34)-1:32] = 2'd0;
    buffresp_msg[(32)-1:0] = read_word_sel_mux$out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_memreq_msg_pack():
  //       s.memreq_msg.type_.value  = MemReqMsg.TYPE_READ
  //       s.memreq_msg.opaque.value = Bits ( opaque_nbits, 0 )
  //       # No need to select/register the tag from tag array since there is no eviction!
  //       s.memreq_msg.addr.value   = concat(s.buffreq_addr_reg.out[line_bw:addr_nbits], Bits(line_bw, 0))
  //       s.memreq_msg.len.value    = Bits ( 4, 0 )

  // logic for comb_memreq_msg_pack()
  always @ (*) begin
    memreq_msg[(305)-1:301] = TYPE_READ;
    memreq_msg[(301)-1:293] = 8'd0;
    memreq_msg[(293)-1:261] = { buffreq_addr_reg$out[(addr_nbits)-1:line_bw],5'd0 };
    memreq_msg[(261)-1:256] = 4'd0;
  end


endmodule // InstBufferDpath_0x3e710d7ddfe3566c
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0xd239a4c17e8ef97
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 27
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0xd239a4c17e8ef97
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  26:0] in_,
  output reg  [  26:0] out,
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
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0xd239a4c17e8ef97
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x513e5624ff809260
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x513e5624ff809260
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   7:0] in_,
  output reg  [   7:0] out,
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
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x513e5624ff809260
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x3857337130dc0828
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x3857337130dc0828
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
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
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x3857337130dc0828
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x4c6a83602fe32a6a
//-----------------------------------------------------------------------------
// nports: 2
// dtype: 256
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x4c6a83602fe32a6a
(
  input  wire [   0:0] clk,
  input  wire [ 255:0] in_$000,
  input  wire [ 255:0] in_$001,
  output reg  [ 255:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [ 255:0] in_[0:1];
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


endmodule // Mux_0x4c6a83602fe32a6a
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x32dec190374e5128
//-----------------------------------------------------------------------------
// nports: 8
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x32dec190374e5128
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  input  wire [  31:0] in_$001,
  input  wire [  31:0] in_$002,
  input  wire [  31:0] in_$003,
  input  wire [  31:0] in_$004,
  input  wire [  31:0] in_$005,
  input  wire [  31:0] in_$006,
  input  wire [  31:0] in_$007,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   2:0] sel
);

  // localparam declarations
  localparam nports = 8;


  // array declarations
  wire   [  31:0] in_[0:7];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;
  assign in_[  4] = in_$004;
  assign in_[  5] = in_$005;
  assign in_[  6] = in_$006;
  assign in_[  7] = in_$007;

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


endmodule // Mux_0x32dec190374e5128
`default_nettype wire

//-----------------------------------------------------------------------------
// EqComparator_0x4c7a718b2f9234c
//-----------------------------------------------------------------------------
// nbits: 27
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module EqComparator_0x4c7a718b2f9234c
(
  input  wire [   0:0] clk,
  input  wire [  26:0] in0,
  input  wire [  26:0] in1,
  output reg  [   0:0] out,
  input  wire [   0:0] reset
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in0 == s.in1

  // logic for comb_logic()
  always @ (*) begin
    out = (in0 == in1);
  end


endmodule // EqComparator_0x4c7a718b2f9234c
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x1c65c01affad8788
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 256
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x1c65c01affad8788
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [ 255:0] in_,
  output reg  [ 255:0] out,
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
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x1c65c01affad8788
`default_nettype wire

//-----------------------------------------------------------------------------
// ProcPRTL_0x2243624498be9761
//-----------------------------------------------------------------------------
// num_cores: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcPRTL_0x2243624498be9761
(
  input  wire [   0:0] clk,
  output wire [   0:0] commit_inst,
  input  wire [  31:0] core_id,
  output wire [  77:0] dmemreq_msg,
  input  wire [   0:0] dmemreq_rdy,
  output wire [   0:0] dmemreq_val,
  input  wire [  47:0] dmemresp_msg,
  output wire [   0:0] dmemresp_rdy,
  input  wire [   0:0] dmemresp_val,
  output wire [  77:0] imemreq_msg,
  input  wire [   0:0] imemreq_rdy,
  output wire [   0:0] imemreq_val,
  input  wire [  47:0] imemresp_msg,
  output wire [   0:0] imemresp_rdy,
  input  wire [   0:0] imemresp_val,
  output wire [  69:0] mdureq_msg,
  input  wire [   0:0] mdureq_rdy,
  output wire [   0:0] mdureq_val,
  input  wire [  34:0] mduresp_msg,
  output wire [   0:0] mduresp_rdy,
  input  wire [   0:0] mduresp_val,
  input  wire [  31:0] mngr2proc_msg,
  output wire [   0:0] mngr2proc_rdy,
  input  wire [   0:0] mngr2proc_val,
  output wire [  31:0] proc2mngr_msg,
  input  wire [   0:0] proc2mngr_rdy,
  output wire [   0:0] proc2mngr_val,
  input  wire [   0:0] reset,
  output wire [   0:0] stats_en,
  output wire [  37:0] xcelreq_msg,
  input  wire [   0:0] xcelreq_rdy,
  output wire [   0:0] xcelreq_val,
  input  wire [  32:0] xcelresp_msg,
  output wire [   0:0] xcelresp_rdy,
  input  wire [   0:0] xcelresp_val
);

  // wire declarations
  wire   [   0:0] imemresp_drop;


  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$proc2mngr_rdy;
  wire   [   0:0] ctrl$br_cond_ltu_X;
  wire   [   0:0] ctrl$imemresp_val;
  wire   [   0:0] ctrl$mngr2proc_val;
  wire   [   0:0] ctrl$br_cond_lt_X;
  wire   [   0:0] ctrl$mduresp_val;
  wire   [   0:0] ctrl$xcelreq_rdy;
  wire   [  31:0] ctrl$inst_D;
  wire   [   0:0] ctrl$dmemreq_rdy;
  wire   [   0:0] ctrl$imemreq_rdy;
  wire   [   0:0] ctrl$xcelresp_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$dmemresp_val;
  wire   [   0:0] ctrl$mdureq_rdy;
  wire   [   0:0] ctrl$br_cond_eq_X;
  wire   [   2:0] ctrl$imm_type_D;
  wire   [   0:0] ctrl$dmemreq_val;
  wire   [   0:0] ctrl$mduresp_rdy;
  wire   [   0:0] ctrl$mngr2proc_rdy;
  wire   [   0:0] ctrl$mdureq_val;
  wire   [   2:0] ctrl$mdureq_msg_type;
  wire   [   1:0] ctrl$op1_byp_sel_D;
  wire   [   0:0] ctrl$dmemresp_rdy;
  wire   [   0:0] ctrl$reg_en_X;
  wire   [   0:0] ctrl$xcelreq_val;
  wire   [   1:0] ctrl$wb_result_sel_M;
  wire   [   0:0] ctrl$reg_en_D;
  wire   [   0:0] ctrl$reg_en_F;
  wire   [   0:0] ctrl$reg_en_M;
  wire   [   2:0] ctrl$dm_resp_sel_M;
  wire   [   0:0] ctrl$reg_en_W;
  wire   [   3:0] ctrl$alu_fn_X;
  wire   [   0:0] ctrl$xcelreq_msg_type;
  wire   [   1:0] ctrl$ex_result_sel_X;
  wire   [   1:0] ctrl$csrr_sel_D;
  wire   [   1:0] ctrl$dmemreq_msg_len;
  wire   [   3:0] ctrl$dmemreq_msg_type;
  wire   [   1:0] ctrl$op2_byp_sel_D;
  wire   [   0:0] ctrl$rf_wen_W;
  wire   [   4:0] ctrl$rf_waddr_W;
  wire   [   1:0] ctrl$pc_sel_F;
  wire   [   0:0] ctrl$proc2mngr_val;
  wire   [   0:0] ctrl$commit_inst;
  wire   [   0:0] ctrl$imemreq_val;
  wire   [   0:0] ctrl$imemresp_drop;
  wire   [   0:0] ctrl$op1_sel_D;
  wire   [   0:0] ctrl$xcelresp_rdy;
  wire   [   0:0] ctrl$stats_en_wen_W;
  wire   [   0:0] ctrl$imemresp_rdy;
  wire   [   1:0] ctrl$op2_sel_D;

  ProcCtrlPRTL_0x617f7f1281b6b6f0 ctrl
  (
    .clk              ( ctrl$clk ),
    .proc2mngr_rdy    ( ctrl$proc2mngr_rdy ),
    .br_cond_ltu_X    ( ctrl$br_cond_ltu_X ),
    .imemresp_val     ( ctrl$imemresp_val ),
    .mngr2proc_val    ( ctrl$mngr2proc_val ),
    .br_cond_lt_X     ( ctrl$br_cond_lt_X ),
    .mduresp_val      ( ctrl$mduresp_val ),
    .xcelreq_rdy      ( ctrl$xcelreq_rdy ),
    .inst_D           ( ctrl$inst_D ),
    .dmemreq_rdy      ( ctrl$dmemreq_rdy ),
    .imemreq_rdy      ( ctrl$imemreq_rdy ),
    .xcelresp_val     ( ctrl$xcelresp_val ),
    .reset            ( ctrl$reset ),
    .dmemresp_val     ( ctrl$dmemresp_val ),
    .mdureq_rdy       ( ctrl$mdureq_rdy ),
    .br_cond_eq_X     ( ctrl$br_cond_eq_X ),
    .imm_type_D       ( ctrl$imm_type_D ),
    .dmemreq_val      ( ctrl$dmemreq_val ),
    .mduresp_rdy      ( ctrl$mduresp_rdy ),
    .mngr2proc_rdy    ( ctrl$mngr2proc_rdy ),
    .mdureq_val       ( ctrl$mdureq_val ),
    .mdureq_msg_type  ( ctrl$mdureq_msg_type ),
    .op1_byp_sel_D    ( ctrl$op1_byp_sel_D ),
    .dmemresp_rdy     ( ctrl$dmemresp_rdy ),
    .reg_en_X         ( ctrl$reg_en_X ),
    .xcelreq_val      ( ctrl$xcelreq_val ),
    .wb_result_sel_M  ( ctrl$wb_result_sel_M ),
    .reg_en_D         ( ctrl$reg_en_D ),
    .reg_en_F         ( ctrl$reg_en_F ),
    .reg_en_M         ( ctrl$reg_en_M ),
    .dm_resp_sel_M    ( ctrl$dm_resp_sel_M ),
    .reg_en_W         ( ctrl$reg_en_W ),
    .alu_fn_X         ( ctrl$alu_fn_X ),
    .xcelreq_msg_type ( ctrl$xcelreq_msg_type ),
    .ex_result_sel_X  ( ctrl$ex_result_sel_X ),
    .csrr_sel_D       ( ctrl$csrr_sel_D ),
    .dmemreq_msg_len  ( ctrl$dmemreq_msg_len ),
    .dmemreq_msg_type ( ctrl$dmemreq_msg_type ),
    .op2_byp_sel_D    ( ctrl$op2_byp_sel_D ),
    .rf_wen_W         ( ctrl$rf_wen_W ),
    .rf_waddr_W       ( ctrl$rf_waddr_W ),
    .pc_sel_F         ( ctrl$pc_sel_F ),
    .proc2mngr_val    ( ctrl$proc2mngr_val ),
    .commit_inst      ( ctrl$commit_inst ),
    .imemreq_val      ( ctrl$imemreq_val ),
    .imemresp_drop    ( ctrl$imemresp_drop ),
    .op1_sel_D        ( ctrl$op1_sel_D ),
    .xcelresp_rdy     ( ctrl$xcelresp_rdy ),
    .stats_en_wen_W   ( ctrl$stats_en_wen_W ),
    .imemresp_rdy     ( ctrl$imemresp_rdy ),
    .op2_sel_D        ( ctrl$op2_sel_D )
  );

  // imemresp_drop_unit temporaries
  wire   [   0:0] imemresp_drop_unit$reset;
  wire   [  31:0] imemresp_drop_unit$in__msg;
  wire   [   0:0] imemresp_drop_unit$in__val;
  wire   [   0:0] imemresp_drop_unit$clk;
  wire   [   0:0] imemresp_drop_unit$drop;
  wire   [   0:0] imemresp_drop_unit$out_rdy;
  wire   [   0:0] imemresp_drop_unit$in__rdy;
  wire   [  31:0] imemresp_drop_unit$out_msg;
  wire   [   0:0] imemresp_drop_unit$out_val;

  DropUnitPRTL_0x3e9fa6cf37077802 imemresp_drop_unit
  (
    .reset   ( imemresp_drop_unit$reset ),
    .in__msg ( imemresp_drop_unit$in__msg ),
    .in__val ( imemresp_drop_unit$in__val ),
    .clk     ( imemresp_drop_unit$clk ),
    .drop    ( imemresp_drop_unit$drop ),
    .out_rdy ( imemresp_drop_unit$out_rdy ),
    .in__rdy ( imemresp_drop_unit$in__rdy ),
    .out_msg ( imemresp_drop_unit$out_msg ),
    .out_val ( imemresp_drop_unit$out_val )
  );

  // imemreq_queue temporaries
  wire   [   0:0] imemreq_queue$clk;
  wire   [  77:0] imemreq_queue$enq_msg;
  wire   [   0:0] imemreq_queue$enq_val;
  wire   [   0:0] imemreq_queue$reset;
  wire   [   0:0] imemreq_queue$deq_rdy;
  wire   [   0:0] imemreq_queue$enq_rdy;
  wire   [   0:0] imemreq_queue$empty;
  wire   [   0:0] imemreq_queue$full;
  wire   [  77:0] imemreq_queue$deq_msg;
  wire   [   0:0] imemreq_queue$deq_val;

  TwoElementBypassQueue_0x69a36ac73a4a8994 imemreq_queue
  (
    .clk     ( imemreq_queue$clk ),
    .enq_msg ( imemreq_queue$enq_msg ),
    .enq_val ( imemreq_queue$enq_val ),
    .reset   ( imemreq_queue$reset ),
    .deq_rdy ( imemreq_queue$deq_rdy ),
    .enq_rdy ( imemreq_queue$enq_rdy ),
    .empty   ( imemreq_queue$empty ),
    .full    ( imemreq_queue$full ),
    .deq_msg ( imemreq_queue$deq_msg ),
    .deq_val ( imemreq_queue$deq_val )
  );

  // xcelreq_queue temporaries
  wire   [   0:0] xcelreq_queue$clk;
  wire   [  37:0] xcelreq_queue$enq_msg;
  wire   [   0:0] xcelreq_queue$enq_val;
  wire   [   0:0] xcelreq_queue$reset;
  wire   [   0:0] xcelreq_queue$deq_rdy;
  wire   [   0:0] xcelreq_queue$enq_rdy;
  wire   [   0:0] xcelreq_queue$full;
  wire   [  37:0] xcelreq_queue$deq_msg;
  wire   [   0:0] xcelreq_queue$deq_val;

  SingleElementBypassQueue_0x4ff2229f876f4e1c xcelreq_queue
  (
    .clk     ( xcelreq_queue$clk ),
    .enq_msg ( xcelreq_queue$enq_msg ),
    .enq_val ( xcelreq_queue$enq_val ),
    .reset   ( xcelreq_queue$reset ),
    .deq_rdy ( xcelreq_queue$deq_rdy ),
    .enq_rdy ( xcelreq_queue$enq_rdy ),
    .full    ( xcelreq_queue$full ),
    .deq_msg ( xcelreq_queue$deq_msg ),
    .deq_val ( xcelreq_queue$deq_val )
  );

  // dpath temporaries
  wire   [   2:0] dpath$imm_type_D;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$reg_en_W;
  wire   [   1:0] dpath$op1_byp_sel_D;
  wire   [   0:0] dpath$reg_en_X;
  wire   [   1:0] dpath$op2_byp_sel_D;
  wire   [   1:0] dpath$wb_result_sel_M;
  wire   [   0:0] dpath$reg_en_D;
  wire   [   0:0] dpath$reg_en_F;
  wire   [   0:0] dpath$reg_en_M;
  wire   [   2:0] dpath$dm_resp_sel_M;
  wire   [   3:0] dpath$alu_fn_X;
  wire   [   1:0] dpath$ex_result_sel_X;
  wire   [   1:0] dpath$csrr_sel_D;
  wire   [   0:0] dpath$rf_wen_W;
  wire   [   4:0] dpath$rf_waddr_W;
  wire   [  31:0] dpath$mduresp_msg;
  wire   [   0:0] dpath$stats_en_wen_W;
  wire   [  31:0] dpath$mngr2proc_data;
  wire   [   0:0] dpath$reset;
  wire   [   1:0] dpath$pc_sel_F;
  wire   [  31:0] dpath$core_id;
  wire   [   0:0] dpath$op1_sel_D;
  wire   [  31:0] dpath$xcelresp_msg_data;
  wire   [  31:0] dpath$imemresp_msg_data;
  wire   [  31:0] dpath$dmemresp_msg_data;
  wire   [   1:0] dpath$op2_sel_D;
  wire   [   0:0] dpath$stats_en;
  wire   [   0:0] dpath$br_cond_ltu_X;
  wire   [  31:0] dpath$dmemreq_msg_data;
  wire   [  31:0] dpath$proc2mngr_data;
  wire   [   0:0] dpath$br_cond_lt_X;
  wire   [  31:0] dpath$inst_D;
  wire   [  31:0] dpath$mdureq_msg_op_b;
  wire   [  31:0] dpath$mdureq_msg_op_a;
  wire   [   4:0] dpath$xcelreq_msg_raddr;
  wire   [  31:0] dpath$dmemreq_msg_addr;
  wire   [   0:0] dpath$br_cond_eq_X;
  wire   [  31:0] dpath$xcelreq_msg_data;
  wire   [  77:0] dpath$imemreq_msg;

  ProcDpathPRTL_0x38dfe68c782cb555 dpath
  (
    .imm_type_D        ( dpath$imm_type_D ),
    .clk               ( dpath$clk ),
    .reg_en_W          ( dpath$reg_en_W ),
    .op1_byp_sel_D     ( dpath$op1_byp_sel_D ),
    .reg_en_X          ( dpath$reg_en_X ),
    .op2_byp_sel_D     ( dpath$op2_byp_sel_D ),
    .wb_result_sel_M   ( dpath$wb_result_sel_M ),
    .reg_en_D          ( dpath$reg_en_D ),
    .reg_en_F          ( dpath$reg_en_F ),
    .reg_en_M          ( dpath$reg_en_M ),
    .dm_resp_sel_M     ( dpath$dm_resp_sel_M ),
    .alu_fn_X          ( dpath$alu_fn_X ),
    .ex_result_sel_X   ( dpath$ex_result_sel_X ),
    .csrr_sel_D        ( dpath$csrr_sel_D ),
    .rf_wen_W          ( dpath$rf_wen_W ),
    .rf_waddr_W        ( dpath$rf_waddr_W ),
    .mduresp_msg       ( dpath$mduresp_msg ),
    .stats_en_wen_W    ( dpath$stats_en_wen_W ),
    .mngr2proc_data    ( dpath$mngr2proc_data ),
    .reset             ( dpath$reset ),
    .pc_sel_F          ( dpath$pc_sel_F ),
    .core_id           ( dpath$core_id ),
    .op1_sel_D         ( dpath$op1_sel_D ),
    .xcelresp_msg_data ( dpath$xcelresp_msg_data ),
    .imemresp_msg_data ( dpath$imemresp_msg_data ),
    .dmemresp_msg_data ( dpath$dmemresp_msg_data ),
    .op2_sel_D         ( dpath$op2_sel_D ),
    .stats_en          ( dpath$stats_en ),
    .br_cond_ltu_X     ( dpath$br_cond_ltu_X ),
    .dmemreq_msg_data  ( dpath$dmemreq_msg_data ),
    .proc2mngr_data    ( dpath$proc2mngr_data ),
    .br_cond_lt_X      ( dpath$br_cond_lt_X ),
    .inst_D            ( dpath$inst_D ),
    .mdureq_msg_op_b   ( dpath$mdureq_msg_op_b ),
    .mdureq_msg_op_a   ( dpath$mdureq_msg_op_a ),
    .xcelreq_msg_raddr ( dpath$xcelreq_msg_raddr ),
    .dmemreq_msg_addr  ( dpath$dmemreq_msg_addr ),
    .br_cond_eq_X      ( dpath$br_cond_eq_X ),
    .xcelreq_msg_data  ( dpath$xcelreq_msg_data ),
    .imemreq_msg       ( dpath$imemreq_msg )
  );

  // proc2mngr_queue temporaries
  wire   [   0:0] proc2mngr_queue$clk;
  wire   [  31:0] proc2mngr_queue$enq_msg;
  wire   [   0:0] proc2mngr_queue$enq_val;
  wire   [   0:0] proc2mngr_queue$reset;
  wire   [   0:0] proc2mngr_queue$deq_rdy;
  wire   [   0:0] proc2mngr_queue$enq_rdy;
  wire   [   0:0] proc2mngr_queue$full;
  wire   [  31:0] proc2mngr_queue$deq_msg;
  wire   [   0:0] proc2mngr_queue$deq_val;

  SingleElementBypassQueue_0x4c19e633b920d596 proc2mngr_queue
  (
    .clk     ( proc2mngr_queue$clk ),
    .enq_msg ( proc2mngr_queue$enq_msg ),
    .enq_val ( proc2mngr_queue$enq_val ),
    .reset   ( proc2mngr_queue$reset ),
    .deq_rdy ( proc2mngr_queue$deq_rdy ),
    .enq_rdy ( proc2mngr_queue$enq_rdy ),
    .full    ( proc2mngr_queue$full ),
    .deq_msg ( proc2mngr_queue$deq_msg ),
    .deq_val ( proc2mngr_queue$deq_val )
  );

  // dmemreq_queue temporaries
  wire   [   0:0] dmemreq_queue$clk;
  wire   [  77:0] dmemreq_queue$enq_msg;
  wire   [   0:0] dmemreq_queue$enq_val;
  wire   [   0:0] dmemreq_queue$reset;
  wire   [   0:0] dmemreq_queue$deq_rdy;
  wire   [   0:0] dmemreq_queue$enq_rdy;
  wire   [   0:0] dmemreq_queue$full;
  wire   [  77:0] dmemreq_queue$deq_msg;
  wire   [   0:0] dmemreq_queue$deq_val;

  SingleElementBypassQueue_0x69a36ac73a4a8994 dmemreq_queue
  (
    .clk     ( dmemreq_queue$clk ),
    .enq_msg ( dmemreq_queue$enq_msg ),
    .enq_val ( dmemreq_queue$enq_val ),
    .reset   ( dmemreq_queue$reset ),
    .deq_rdy ( dmemreq_queue$deq_rdy ),
    .enq_rdy ( dmemreq_queue$enq_rdy ),
    .full    ( dmemreq_queue$full ),
    .deq_msg ( dmemreq_queue$deq_msg ),
    .deq_val ( dmemreq_queue$deq_val )
  );

  // signal connections
  assign commit_inst                  = ctrl$commit_inst;
  assign commit_inst                  = ctrl$commit_inst;
  assign ctrl$br_cond_eq_X            = dpath$br_cond_eq_X;
  assign ctrl$br_cond_lt_X            = dpath$br_cond_lt_X;
  assign ctrl$br_cond_ltu_X           = dpath$br_cond_ltu_X;
  assign ctrl$clk                     = clk;
  assign ctrl$dmemreq_rdy             = dmemreq_queue$enq_rdy;
  assign ctrl$dmemresp_val            = dmemresp_val;
  assign ctrl$imemreq_rdy             = imemreq_queue$enq_rdy;
  assign ctrl$imemresp_val            = imemresp_drop_unit$out_val;
  assign ctrl$inst_D                  = dpath$inst_D;
  assign ctrl$mdureq_rdy              = mdureq_rdy;
  assign ctrl$mduresp_val             = mduresp_val;
  assign ctrl$mngr2proc_val           = mngr2proc_val;
  assign ctrl$proc2mngr_rdy           = proc2mngr_queue$enq_rdy;
  assign ctrl$reset                   = reset;
  assign ctrl$xcelreq_rdy             = xcelreq_queue$enq_rdy;
  assign ctrl$xcelresp_val            = xcelresp_val;
  assign dmemreq_msg                  = dmemreq_queue$deq_msg;
  assign dmemreq_queue$clk            = clk;
  assign dmemreq_queue$deq_rdy        = dmemreq_rdy;
  assign dmemreq_queue$enq_msg[31:0]  = dpath$dmemreq_msg_data;
  assign dmemreq_queue$enq_msg[33:32] = ctrl$dmemreq_msg_len;
  assign dmemreq_queue$enq_msg[65:34] = dpath$dmemreq_msg_addr;
  assign dmemreq_queue$enq_msg[77:74] = ctrl$dmemreq_msg_type;
  assign dmemreq_queue$enq_val        = ctrl$dmemreq_val;
  assign dmemreq_queue$reset          = reset;
  assign dmemreq_val                  = dmemreq_queue$deq_val;
  assign dmemresp_rdy                 = ctrl$dmemresp_rdy;
  assign dpath$alu_fn_X               = ctrl$alu_fn_X;
  assign dpath$clk                    = clk;
  assign dpath$core_id                = core_id;
  assign dpath$core_id                = core_id;
  assign dpath$csrr_sel_D             = ctrl$csrr_sel_D;
  assign dpath$dm_resp_sel_M          = ctrl$dm_resp_sel_M;
  assign dpath$dmemresp_msg_data      = dmemresp_msg[31:0];
  assign dpath$ex_result_sel_X        = ctrl$ex_result_sel_X;
  assign dpath$imemresp_msg_data      = imemresp_drop_unit$out_msg;
  assign dpath$imm_type_D             = ctrl$imm_type_D;
  assign dpath$mduresp_msg            = mduresp_msg[31:0];
  assign dpath$mngr2proc_data         = mngr2proc_msg;
  assign dpath$op1_byp_sel_D          = ctrl$op1_byp_sel_D;
  assign dpath$op1_sel_D              = ctrl$op1_sel_D;
  assign dpath$op2_byp_sel_D          = ctrl$op2_byp_sel_D;
  assign dpath$op2_sel_D              = ctrl$op2_sel_D;
  assign dpath$pc_sel_F               = ctrl$pc_sel_F;
  assign dpath$reg_en_D               = ctrl$reg_en_D;
  assign dpath$reg_en_F               = ctrl$reg_en_F;
  assign dpath$reg_en_M               = ctrl$reg_en_M;
  assign dpath$reg_en_W               = ctrl$reg_en_W;
  assign dpath$reg_en_X               = ctrl$reg_en_X;
  assign dpath$reset                  = reset;
  assign dpath$rf_waddr_W             = ctrl$rf_waddr_W;
  assign dpath$rf_wen_W               = ctrl$rf_wen_W;
  assign dpath$stats_en_wen_W         = ctrl$stats_en_wen_W;
  assign dpath$wb_result_sel_M        = ctrl$wb_result_sel_M;
  assign dpath$xcelresp_msg_data      = xcelresp_msg[31:0];
  assign imemreq_msg                  = imemreq_queue$deq_msg;
  assign imemreq_queue$clk            = clk;
  assign imemreq_queue$deq_rdy        = imemreq_rdy;
  assign imemreq_queue$enq_msg        = dpath$imemreq_msg;
  assign imemreq_queue$enq_val        = ctrl$imemreq_val;
  assign imemreq_queue$reset          = reset;
  assign imemreq_val                  = imemreq_queue$deq_val;
  assign imemresp_drop                = ctrl$imemresp_drop;
  assign imemresp_drop_unit$clk       = clk;
  assign imemresp_drop_unit$drop      = imemresp_drop;
  assign imemresp_drop_unit$in__msg   = imemresp_msg[31:0];
  assign imemresp_drop_unit$in__val   = imemresp_val;
  assign imemresp_drop_unit$out_rdy   = ctrl$imemresp_rdy;
  assign imemresp_drop_unit$reset     = reset;
  assign imemresp_rdy                 = imemresp_drop_unit$in__rdy;
  assign mdureq_msg[31:0]             = dpath$mdureq_msg_op_b;
  assign mdureq_msg[63:32]            = dpath$mdureq_msg_op_a;
  assign mdureq_msg[69:67]            = ctrl$mdureq_msg_type;
  assign mdureq_val                   = ctrl$mdureq_val;
  assign mduresp_rdy                  = ctrl$mduresp_rdy;
  assign mngr2proc_rdy                = ctrl$mngr2proc_rdy;
  assign proc2mngr_msg                = proc2mngr_queue$deq_msg;
  assign proc2mngr_queue$clk          = clk;
  assign proc2mngr_queue$deq_rdy      = proc2mngr_rdy;
  assign proc2mngr_queue$enq_msg      = dpath$proc2mngr_data;
  assign proc2mngr_queue$enq_val      = ctrl$proc2mngr_val;
  assign proc2mngr_queue$reset        = reset;
  assign proc2mngr_val                = proc2mngr_queue$deq_val;
  assign stats_en                     = dpath$stats_en;
  assign stats_en                     = dpath$stats_en;
  assign xcelreq_msg                  = xcelreq_queue$deq_msg;
  assign xcelreq_queue$clk            = clk;
  assign xcelreq_queue$deq_rdy        = xcelreq_rdy;
  assign xcelreq_queue$enq_msg[31:0]  = dpath$xcelreq_msg_data;
  assign xcelreq_queue$enq_msg[36:32] = dpath$xcelreq_msg_raddr;
  assign xcelreq_queue$enq_msg[37:37] = ctrl$xcelreq_msg_type;
  assign xcelreq_queue$enq_val        = ctrl$xcelreq_val;
  assign xcelreq_queue$reset          = reset;
  assign xcelreq_val                  = xcelreq_queue$deq_val;
  assign xcelresp_rdy                 = ctrl$xcelresp_rdy;



endmodule // ProcPRTL_0x2243624498be9761
`default_nettype wire

//-----------------------------------------------------------------------------
// ProcCtrlPRTL_0x617f7f1281b6b6f0
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcCtrlPRTL_0x617f7f1281b6b6f0
(
  output reg  [   3:0] alu_fn_X,
  input  wire [   0:0] br_cond_eq_X,
  input  wire [   0:0] br_cond_lt_X,
  input  wire [   0:0] br_cond_ltu_X,
  input  wire [   0:0] clk,
  output reg  [   0:0] commit_inst,
  output reg  [   1:0] csrr_sel_D,
  output reg  [   2:0] dm_resp_sel_M,
  output reg  [   1:0] dmemreq_msg_len,
  output reg  [   3:0] dmemreq_msg_type,
  input  wire [   0:0] dmemreq_rdy,
  output reg  [   0:0] dmemreq_val,
  output reg  [   0:0] dmemresp_rdy,
  input  wire [   0:0] dmemresp_val,
  output reg  [   1:0] ex_result_sel_X,
  input  wire [   0:0] imemreq_rdy,
  output reg  [   0:0] imemreq_val,
  output reg  [   0:0] imemresp_drop,
  output reg  [   0:0] imemresp_rdy,
  input  wire [   0:0] imemresp_val,
  output reg  [   2:0] imm_type_D,
  input  wire [  31:0] inst_D,
  output reg  [   2:0] mdureq_msg_type,
  input  wire [   0:0] mdureq_rdy,
  output reg  [   0:0] mdureq_val,
  output reg  [   0:0] mduresp_rdy,
  input  wire [   0:0] mduresp_val,
  output reg  [   0:0] mngr2proc_rdy,
  input  wire [   0:0] mngr2proc_val,
  output reg  [   1:0] op1_byp_sel_D,
  output reg  [   0:0] op1_sel_D,
  output reg  [   1:0] op2_byp_sel_D,
  output reg  [   1:0] op2_sel_D,
  output reg  [   1:0] pc_sel_F,
  input  wire [   0:0] proc2mngr_rdy,
  output reg  [   0:0] proc2mngr_val,
  output reg  [   0:0] reg_en_D,
  output reg  [   0:0] reg_en_F,
  output reg  [   0:0] reg_en_M,
  output reg  [   0:0] reg_en_W,
  output reg  [   0:0] reg_en_X,
  input  wire [   0:0] reset,
  output reg  [   4:0] rf_waddr_W,
  output reg  [   0:0] rf_wen_W,
  output reg  [   0:0] stats_en_wen_W,
  output reg  [   1:0] wb_result_sel_M,
  output reg  [   0:0] xcelreq_msg_type,
  input  wire [   0:0] xcelreq_rdy,
  output reg  [   0:0] xcelreq_val,
  output reg  [   0:0] xcelresp_rdy,
  input  wire [   0:0] xcelresp_val
);

  // wire declarations
  wire   [   0:0] ostall_proc2mngr_W;
  wire   [   2:0] rf_waddr_sel_D;


  // register declarations
  reg    [   3:0] alu_fn_D;
  reg    [   2:0] br_type_D;
  reg    [   2:0] br_type_X;
  reg    [  36:0] cs;
  reg    [   0:0] csrr_D;
  reg    [   0:0] csrw_D;
  reg    [   2:0] dm_resp_sel_D;
  reg    [   2:0] dm_resp_sel_X;
  reg    [   1:0] dmemreq_len_D;
  reg    [   1:0] dmemreq_len_M;
  reg    [   1:0] dmemreq_len_X;
  reg    [   3:0] dmemreq_type_D;
  reg    [   3:0] dmemreq_type_M;
  reg    [   3:0] dmemreq_type_X;
  reg    [   1:0] ex_result_sel_D;
  reg    [   7:0] inst__9;
  reg    [   7:0] inst_type_M;
  reg    [   7:0] inst_type_W;
  reg    [   7:0] inst_type_X;
  reg    [   0:0] inst_val_D;
  reg    [   0:0] jal_D;
  reg    [   3:0] mdu_D;
  reg    [   3:0] mdu_X;
  reg    [   0:0] mngr2proc_rdy_D;
  reg    [   0:0] next_val_D;
  reg    [   0:0] next_val_F;
  reg    [   0:0] next_val_M;
  reg    [   0:0] next_val_X;
  reg    [   0:0] osquash_D;
  reg    [   0:0] osquash_X;
  reg    [   0:0] ostall_D;
  reg    [   0:0] ostall_F;
  reg    [   0:0] ostall_M;
  reg    [   0:0] ostall_W;
  reg    [   0:0] ostall_X;
  reg    [   0:0] ostall_amo_X_rs1_D;
  reg    [   0:0] ostall_amo_X_rs2_D;
  reg    [   0:0] ostall_csrrx_X_rs1_D;
  reg    [   0:0] ostall_csrrx_X_rs2_D;
  reg    [   0:0] ostall_dmem_M;
  reg    [   0:0] ostall_dmem_X;
  reg    [   0:0] ostall_hazard_D;
  reg    [   0:0] ostall_ld_X_rs1_D;
  reg    [   0:0] ostall_ld_X_rs2_D;
  reg    [   0:0] ostall_mdu_D;
  reg    [   0:0] ostall_mdu_X;
  reg    [   0:0] ostall_mngr_D;
  reg    [   0:0] ostall_xcel_M;
  reg    [   0:0] ostall_xcel_X;
  reg    [   0:0] pc_redirect_D;
  reg    [   0:0] pc_redirect_X;
  reg    [   0:0] proc2mngr_val_D;
  reg    [   0:0] proc2mngr_val_M;
  reg    [   0:0] proc2mngr_val_W;
  reg    [   0:0] proc2mngr_val_X;
  reg    [   4:0] rf_waddr_D;
  reg    [   4:0] rf_waddr_M;
  reg    [   4:0] rf_waddr_X;
  reg    [   0:0] rf_wen_pending_D;
  reg    [   0:0] rf_wen_pending_M;
  reg    [   0:0] rf_wen_pending_W;
  reg    [   0:0] rf_wen_pending_X;
  reg    [   0:0] rs1_en_D;
  reg    [   0:0] rs2_en_D;
  reg    [   0:0] squash_D;
  reg    [   0:0] squash_F;
  reg    [   0:0] stall_D;
  reg    [   0:0] stall_F;
  reg    [   0:0] stall_M;
  reg    [   0:0] stall_W;
  reg    [   0:0] stall_X;
  reg    [   0:0] stats_en_wen_D;
  reg    [   0:0] stats_en_wen_M;
  reg    [   0:0] stats_en_wen_X;
  reg    [   0:0] stats_en_wen_pending_W;
  reg    [   0:0] val_D;
  reg    [   0:0] val_F;
  reg    [   0:0] val_M;
  reg    [   0:0] val_W;
  reg    [   0:0] val_X;
  reg    [   1:0] wb_result_sel_D;
  reg    [   1:0] wb_result_sel_X;
  reg    [   0:0] xcelreq_D;
  reg    [   0:0] xcelreq_M;
  reg    [   0:0] xcelreq_X;
  reg    [   0:0] xcelreq_type_D;
  reg    [   0:0] xcelreq_type_X;

  // localparam declarations
  localparam ADD = 15;
  localparam ADDI = 16;
  localparam AMOADD = 47;
  localparam AMOAND = 50;
  localparam AMOMAX = 52;
  localparam AMOMAXU = 54;
  localparam AMOMIN = 51;
  localparam AMOMINU = 53;
  localparam AMOOR = 49;
  localparam AMOSWAP = 46;
  localparam AMOXOR = 48;
  localparam AND = 24;
  localparam ANDI = 25;
  localparam AUIPC = 19;
  localparam BEQ = 30;
  localparam BGE = 33;
  localparam BGEU = 35;
  localparam BLT = 32;
  localparam BLTU = 34;
  localparam BNE = 31;
  localparam CSRR = 55;
  localparam CSRRX = 58;
  localparam CSRW = 56;
  localparam CSR_COREID = 3860;
  localparam CSR_MNGR2PROC = 4032;
  localparam CSR_NUMCORES = 4033;
  localparam CSR_PROC2MNGR = 1984;
  localparam CSR_STATS_EN = 1985;
  localparam DIV = 42;
  localparam DIVU = 43;
  localparam JAL = 36;
  localparam JALR = 37;
  localparam LB = 1;
  localparam LBU = 4;
  localparam LH = 2;
  localparam LHU = 5;
  localparam LUI = 18;
  localparam LW = 3;
  localparam MUL = 38;
  localparam MULH = 39;
  localparam MULHSU = 40;
  localparam MULHU = 41;
  localparam NOP = 0;
  localparam OR = 22;
  localparam ORI = 23;
  localparam REM = 44;
  localparam REMU = 45;
  localparam SB = 6;
  localparam SH = 7;
  localparam SLL = 9;
  localparam SLLI = 10;
  localparam SLT = 26;
  localparam SLTI = 27;
  localparam SLTIU = 29;
  localparam SLTU = 28;
  localparam SRA = 13;
  localparam SRAI = 14;
  localparam SRL = 11;
  localparam SRLI = 12;
  localparam SUB = 17;
  localparam SW = 8;
  localparam TYPE_AMO_ADD = 3;
  localparam TYPE_AMO_AND = 4;
  localparam TYPE_AMO_MAX = 9;
  localparam TYPE_AMO_MAXU = 10;
  localparam TYPE_AMO_MIN = 7;
  localparam TYPE_AMO_MINU = 8;
  localparam TYPE_AMO_OR = 5;
  localparam TYPE_AMO_SWAP = 6;
  localparam TYPE_AMO_XOR = 11;
  localparam TYPE_READ = 0;
  localparam TYPE_WRITE = 1;
  localparam XOR = 20;
  localparam XORI = 21;
  localparam alu_add = 4'd0;
  localparam alu_adz = 4'd13;
  localparam alu_and = 4'd6;
  localparam alu_cp0 = 4'd11;
  localparam alu_cp1 = 4'd12;
  localparam alu_lt = 4'd4;
  localparam alu_ltu = 4'd5;
  localparam alu_or = 4'd3;
  localparam alu_sll = 4'd2;
  localparam alu_sra = 4'd10;
  localparam alu_srl = 4'd9;
  localparam alu_sub = 4'd1;
  localparam alu_x = 4'd0;
  localparam alu_xor = 4'd7;
  localparam am_pc = 1'd1;
  localparam am_rf = 1'd0;
  localparam am_x = 1'd0;
  localparam bm_csr = 2'd2;
  localparam bm_imm = 2'd1;
  localparam bm_rf = 2'd0;
  localparam bm_x = 2'd0;
  localparam br_eq = 3'd4;
  localparam br_ge = 3'd5;
  localparam br_gu = 3'd6;
  localparam br_lt = 3'd2;
  localparam br_lu = 3'd3;
  localparam br_na = 3'd0;
  localparam br_ne = 3'd1;
  localparam br_x = 3'd0;
  localparam byp_d = 2'd0;
  localparam byp_m = 2'd2;
  localparam byp_w = 2'd3;
  localparam byp_x = 2'd1;
  localparam dm_b = 3'd0;
  localparam dm_bu = 3'd3;
  localparam dm_h = 3'd1;
  localparam dm_hu = 3'd4;
  localparam dm_w = 3'd2;
  localparam dm_x = 3'd0;
  localparam imm_b = 3'd2;
  localparam imm_i = 3'd0;
  localparam imm_j = 3'd4;
  localparam imm_s = 3'd1;
  localparam imm_u = 3'd3;
  localparam imm_x = 3'd0;
  localparam jalr = 3'd7;
  localparam md_div = 4'd4;
  localparam md_divu = 4'd5;
  localparam md_mh = 4'd1;
  localparam md_mhsu = 4'd2;
  localparam md_mhu = 4'd3;
  localparam md_mul = 4'd0;
  localparam md_rem = 4'd6;
  localparam md_remu = 4'd7;
  localparam md_x = 4'd8;
  localparam mem_ad = 4'd3;
  localparam mem_an = 4'd4;
  localparam mem_ld = 4'd1;
  localparam mem_mn = 4'd7;
  localparam mem_mnu = 4'd8;
  localparam mem_mx = 4'd9;
  localparam mem_mxu = 4'd10;
  localparam mem_nr = 4'd0;
  localparam mem_or = 4'd5;
  localparam mem_sp = 4'd6;
  localparam mem_st = 4'd2;
  localparam mem_xr = 4'd11;
  localparam mlen_b = 2'd1;
  localparam mlen_h = 2'd2;
  localparam mlen_w = 2'd0;
  localparam mlen_x = 2'd0;
  localparam n = 1'd0;
  localparam wm_a = 2'd0;
  localparam wm_c = 2'd2;
  localparam wm_m = 2'd1;
  localparam wm_x = 2'd0;
  localparam xm_a = 2'd0;
  localparam xm_m = 2'd1;
  localparam xm_p = 2'd2;
  localparam xm_x = 2'd0;
  localparam y = 1'd1;

  // inst_type_decoder_D temporaries
  wire   [   0:0] inst_type_decoder_D$reset;
  wire   [  31:0] inst_type_decoder_D$in_;
  wire   [   0:0] inst_type_decoder_D$clk;
  wire   [   7:0] inst_type_decoder_D$out;

  DecodeInstType_0x72c9bb161518ada2 inst_type_decoder_D
  (
    .reset ( inst_type_decoder_D$reset ),
    .in_   ( inst_type_decoder_D$in_ ),
    .clk   ( inst_type_decoder_D$clk ),
    .out   ( inst_type_decoder_D$out )
  );

  // signal connections
  assign inst_type_decoder_D$clk   = clk;
  assign inst_type_decoder_D$in_   = inst_D;
  assign inst_type_decoder_D$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_F():
  //       if s.reset:
  //         s.val_F.next = 0
  //       elif s.reg_en_F:
  //         s.val_F.next = 1

  // logic for reg_F()
  always @ (posedge clk) begin
    if (reset) begin
      val_F <= 0;
    end
    else begin
      if (reg_en_F) begin
        val_F <= 1;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_D():
  //       if s.reset:
  //         s.val_D.next = 0
  //       elif s.reg_en_D:
  //         s.val_D.next = s.next_val_F

  // logic for reg_D()
  always @ (posedge clk) begin
    if (reset) begin
      val_D <= 0;
    end
    else begin
      if (reg_en_D) begin
        val_D <= next_val_F;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_X():
  //       if s.reset:
  //         s.val_X.next            = 0
  //         s.stats_en_wen_X.next   = 0
  //       elif s.reg_en_X:
  //         s.val_X.next            = s.next_val_D
  //         s.rf_wen_pending_X.next = s.rf_wen_pending_D
  //         s.inst_type_X.next      = s.inst_type_decoder_D.out
  //         s.alu_fn_X.next         = s.alu_fn_D
  //         s.rf_waddr_X.next       = s.rf_waddr_D
  //         s.proc2mngr_val_X.next  = s.proc2mngr_val_D
  //         s.dmemreq_type_X.next   = s.dmemreq_type_D
  //         s.dmemreq_len_X.next    = s.dmemreq_len_D
  //         s.dm_resp_sel_X.next    = s.dm_resp_sel_D
  //         s.wb_result_sel_X.next  = s.wb_result_sel_D
  //         s.stats_en_wen_X.next   = s.stats_en_wen_D
  //         s.br_type_X.next        = s.br_type_D
  //         s.mdu_X.next            = s.mdu_D
  //         s.ex_result_sel_X.next  = s.ex_result_sel_D
  //         s.xcelreq_X.next        = s.xcelreq_D
  //         s.xcelreq_type_X.next   = s.xcelreq_type_D

  // logic for reg_X()
  always @ (posedge clk) begin
    if (reset) begin
      val_X <= 0;
      stats_en_wen_X <= 0;
    end
    else begin
      if (reg_en_X) begin
        val_X <= next_val_D;
        rf_wen_pending_X <= rf_wen_pending_D;
        inst_type_X <= inst_type_decoder_D$out;
        alu_fn_X <= alu_fn_D;
        rf_waddr_X <= rf_waddr_D;
        proc2mngr_val_X <= proc2mngr_val_D;
        dmemreq_type_X <= dmemreq_type_D;
        dmemreq_len_X <= dmemreq_len_D;
        dm_resp_sel_X <= dm_resp_sel_D;
        wb_result_sel_X <= wb_result_sel_D;
        stats_en_wen_X <= stats_en_wen_D;
        br_type_X <= br_type_D;
        mdu_X <= mdu_D;
        ex_result_sel_X <= ex_result_sel_D;
        xcelreq_X <= xcelreq_D;
        xcelreq_type_X <= xcelreq_type_D;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_M():
  //       if s.reset:
  //         s.val_M.next            = 0
  //         s.stats_en_wen_M.next   = 0
  //       elif s.reg_en_M:
  //         s.val_M.next            = s.next_val_X
  //         s.rf_wen_pending_M.next = s.rf_wen_pending_X
  //         s.inst_type_M.next      = s.inst_type_X
  //         s.rf_waddr_M.next       = s.rf_waddr_X
  //         s.proc2mngr_val_M.next  = s.proc2mngr_val_X
  //         s.dmemreq_type_M.next   = s.dmemreq_type_X
  //         s.dmemreq_len_M.next    = s.dmemreq_len_X
  //         s.dm_resp_sel_M.next    = s.dm_resp_sel_X
  //         s.wb_result_sel_M.next  = s.wb_result_sel_X
  //         s.stats_en_wen_M.next   = s.stats_en_wen_X
  //         # xcel
  //         s.xcelreq_M.next        = s.xcelreq_X

  // logic for reg_M()
  always @ (posedge clk) begin
    if (reset) begin
      val_M <= 0;
      stats_en_wen_M <= 0;
    end
    else begin
      if (reg_en_M) begin
        val_M <= next_val_X;
        rf_wen_pending_M <= rf_wen_pending_X;
        inst_type_M <= inst_type_X;
        rf_waddr_M <= rf_waddr_X;
        proc2mngr_val_M <= proc2mngr_val_X;
        dmemreq_type_M <= dmemreq_type_X;
        dmemreq_len_M <= dmemreq_len_X;
        dm_resp_sel_M <= dm_resp_sel_X;
        wb_result_sel_M <= wb_result_sel_X;
        stats_en_wen_M <= stats_en_wen_X;
        xcelreq_M <= xcelreq_X;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def reg_W():
  //
  //       if s.reset:
  //         s.val_W.next            = 0
  //         s.stats_en_wen_pending_W.next   = 0
  //       elif s.reg_en_W:
  //         s.val_W.next                  = s.next_val_M
  //         s.rf_wen_pending_W.next       = s.rf_wen_pending_M
  //         s.inst_type_W.next            = s.inst_type_M
  //         s.rf_waddr_W.next             = s.rf_waddr_M
  //         s.proc2mngr_val_W.next        = s.proc2mngr_val_M
  //         s.stats_en_wen_pending_W.next = s.stats_en_wen_M

  // logic for reg_W()
  always @ (posedge clk) begin
    if (reset) begin
      val_W <= 0;
      stats_en_wen_pending_W <= 0;
    end
    else begin
      if (reg_en_W) begin
        val_W <= next_val_M;
        rf_wen_pending_W <= rf_wen_pending_M;
        inst_type_W <= inst_type_M;
        rf_waddr_W <= rf_waddr_M;
        proc2mngr_val_W <= proc2mngr_val_M;
        stats_en_wen_pending_W <= stats_en_wen_M;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_reg_en_F():
  //       s.reg_en_F.value = ~s.stall_F | s.squash_F

  // logic for comb_reg_en_F()
  always @ (*) begin
    reg_en_F = (~stall_F|squash_F);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_PC_sel_F():
  //       if   s.pc_redirect_X:
  //
  //         if s.br_type_X == jalr:
  //           s.pc_sel_F.value = 3 # jalr target from ALU
  //         else:
  //           s.pc_sel_F.value = 1 # branch target
  //
  //       elif s.pc_redirect_D:
  //         s.pc_sel_F.value = 2 # use jal target
  //       else:
  //         s.pc_sel_F.value = 0 # use pc+4

  // logic for comb_PC_sel_F()
  always @ (*) begin
    if (pc_redirect_X) begin
      if ((br_type_X == jalr)) begin
        pc_sel_F = 3;
      end
      else begin
        pc_sel_F = 1;
      end
    end
    else begin
      if (pc_redirect_D) begin
        pc_sel_F = 2;
      end
      else begin
        pc_sel_F = 0;
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_F():
  //       # ostall due to imemresp
  //
  //       s.ostall_F.value      = s.val_F & ~s.imemresp_val
  //
  //       # stall and squash in F stage
  //
  //       s.stall_F.value       = s.val_F & ( s.ostall_F  | s.ostall_D |
  //                                           s.ostall_X  | s.ostall_M |
  //                                           s.ostall_W                 )
  //       s.squash_F.value      = s.val_F & ( s.osquash_D | s.osquash_X  )
  //
  //       # imem req is special, it actually be sent out _before_ the F
  //       # stage, we need to send memreq everytime we are getting squashed
  //       # because we need to redirect the PC. We also need to factor in
  //       # reset. When we are resetting we shouldn't send out imem req.
  //
  //       s.imemreq_val.value   =  ~s.reset & (~s.stall_F | s.squash_F)
  //       s.imemresp_rdy.value  =  ~s.stall_F | s.squash_F
  //
  //       # We drop the mem response when we are getting squashed
  //
  //       s.imemresp_drop.value = s.squash_F
  //
  //       s.next_val_F.value    = s.val_F & ~s.stall_F & ~s.squash_F

  // logic for comb_F()
  always @ (*) begin
    ostall_F = (val_F&~imemresp_val);
    stall_F = (val_F&((((ostall_F|ostall_D)|ostall_X)|ostall_M)|ostall_W));
    squash_F = (val_F&(osquash_D|osquash_X));
    imemreq_val = (~reset&(~stall_F|squash_F));
    imemresp_rdy = (~stall_F|squash_F);
    imemresp_drop = squash_F;
    next_val_F = ((val_F&~stall_F)&~squash_F);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_reg_en_D():
  //       s.reg_en_D.value = ~s.stall_D | s.squash_D

  // logic for comb_reg_en_D()
  always @ (*) begin
    reg_en_D = (~stall_D|squash_D);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_control_table_D():
  //       inst = s.inst_type_decoder_D.out.value
  //       #                                             br    jal op1   rs1 imm    op2    rs2 alu      dmm      dmm     xres  dmmux  wbmux rf  rv32m    cs cs
  //       #                                         val type   D  muxsel en type   muxsel  en fn       typ      len     sel   sel    sel   wen          rr rw
  //       if   inst == NOP    : s.cs.value = concat( y, br_na, n, am_x,  n, imm_x, bm_x,   n, alu_x,   mem_nr,  mlen_x, xm_x, dm_x,  wm_a, n,  md_x,    n, n )
  //       # RV32I
  //       # xcel/csrr/csrw
  //       elif inst == CSRRX  : s.cs.value = concat( y, br_na, n, am_x,  n, imm_i, bm_imm, n, alu_cp1, mem_nr,  mlen_x, xm_a, dm_x,  wm_c, y,  md_x,    y, n )
  //       elif inst == CSRR   : s.cs.value = concat( y, br_na, n, am_x,  n, imm_i, bm_csr, n, alu_cp1, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    y, n )
  //       elif inst == CSRW   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_cp0, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, n,  md_x,    n, y )
  //       # reg-reg
  //       elif inst == ADD    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_add, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SUB    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sub, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == AND    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_and, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == OR     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_or , mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == XOR    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_xor, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLT    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_lt , mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLTU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_ltu, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SRA    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sra, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SRL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_srl, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sll, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       # reg-imm
  //       elif inst == ADDI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == ANDI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_and, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == ORI    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_or , mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == XORI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_xor, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLTI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_lt , mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLTIU  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_ltu, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SRAI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_sra, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SRLI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_srl, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == SLLI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_sll, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == LUI    : s.cs.value = concat( y, br_na, n, am_x,  n, imm_u, bm_imm, n, alu_cp1, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == AUIPC  : s.cs.value = concat( y, br_na, n, am_pc, n, imm_u, bm_imm, n, alu_add, mem_nr,  mlen_x, xm_a, dm_x,  wm_a, y,  md_x,    n, n )
  //       # branch
  //       elif inst == BNE    : s.cs.value = concat( y, br_ne, n, am_rf, y, imm_b, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       elif inst == BEQ    : s.cs.value = concat( y, br_eq, n, am_rf, y, imm_b, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       elif inst == BLT    : s.cs.value = concat( y, br_lt, n, am_rf, y, imm_b, bm_rf,  y, alu_lt,  mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       elif inst == BLTU   : s.cs.value = concat( y, br_lu, n, am_rf, y, imm_b, bm_rf,  y, alu_ltu, mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       elif inst == BGE    : s.cs.value = concat( y, br_ge, n, am_rf, y, imm_b, bm_rf,  y, alu_lt,  mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       elif inst == BGEU   : s.cs.value = concat( y, br_gu, n, am_rf, y, imm_b, bm_rf,  y, alu_ltu, mem_nr,  mlen_x, xm_a, dm_x,  wm_x, n,  md_x,    n, n )
  //       # jump
  //       elif inst == JAL    : s.cs.value = concat( y, br_na, y, am_x,  n, imm_j, bm_x,   n, alu_x,   mem_nr,  mlen_x, xm_p, dm_x,  wm_a, y,  md_x,    n, n )
  //       elif inst == JALR   : s.cs.value = concat( y, jalr , n, am_rf, y, imm_i, bm_imm, n, alu_adz, mem_nr,  mlen_x, xm_p, dm_x,  wm_a, y,  md_x,    n, n )
  //       # mem
  //       elif inst == LB     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  mlen_b, xm_a, dm_b,  wm_m, y,  md_x,    n, n )
  //       elif inst == LH     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  mlen_h, xm_a, dm_h,  wm_m, y,  md_x,    n, n )
  //       elif inst == LW     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == LBU    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  mlen_b, xm_a, dm_bu, wm_m, y,  md_x,    n, n )
  //       elif inst == LHU    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  mlen_h, xm_a, dm_hu, wm_m, y,  md_x,    n, n )
  //       elif inst == SB     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_s, bm_imm, y, alu_add, mem_st,  mlen_b, xm_a, dm_x,  wm_m, n,  md_x,    n, n )
  //       elif inst == SH     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_s, bm_imm, y, alu_add, mem_st,  mlen_h, xm_a, dm_x,  wm_m, n,  md_x,    n, n )
  //       elif inst == SW     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_s, bm_imm, y, alu_add, mem_st,  mlen_w, xm_a, dm_x,  wm_m, n,  md_x,    n, n )
  //       # RV32A
  //       elif inst == AMOADD : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_ad,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOAND : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_an,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOOR  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_or,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOSWAP: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_sp,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOMIN : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mn,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOMINU: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mnu, mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOMAX : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mx,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOMAXU: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mxu, mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       elif inst == AMOXOR : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_xr,  mlen_w, xm_a, dm_w,  wm_m, y,  md_x,    n, n )
  //       # RV32M
  //       elif inst == MUL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_mul,  n, n )
  //       elif inst == MULH   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_mh,   n, n )
  //       elif inst == MULHSU : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_mhsu, n, n )
  //       elif inst == MULHU  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_mhu,  n, n )
  //       elif inst == DIV    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_div,  n, n )
  //       elif inst == DIVU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_divu, n, n )
  //       elif inst == REM    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_rem,  n, n )
  //       elif inst == REMU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x,   mem_nr,  mlen_x, xm_m, dm_x,  wm_a, y,  md_remu, n, n )
  //       else:                 s.cs.value = concat( n, br_x,  n, am_x,  n, imm_x, bm_x,   n, alu_x,   mem_nr,  mlen_x, xm_x, dm_x,  wm_x, n,  n,       n, n )
  //
  //       s.inst_val_D.value       = s.cs[36:37]
  //       s.br_type_D.value        = s.cs[33:36]
  //       s.jal_D.value            = s.cs[32:33]
  //       s.op1_sel_D.value        = s.cs[31:32]
  //       s.rs1_en_D.value         = s.cs[30:31]
  //       s.imm_type_D.value       = s.cs[27:30]
  //       s.op2_sel_D.value        = s.cs[25:27]
  //       s.rs2_en_D.value         = s.cs[24:25]
  //       s.alu_fn_D.value         = s.cs[20:24]
  //       s.dmemreq_type_D.value   = s.cs[16:20]
  //       s.dmemreq_len_D.value    = s.cs[14:16]
  //       s.ex_result_sel_D.value  = s.cs[12:14]
  //       s.dm_resp_sel_D.value    = s.cs[9:12]
  //       s.wb_result_sel_D.value  = s.cs[7:9]
  //       s.rf_wen_pending_D.value = s.cs[6:7]
  //       s.mdu_D.value            = s.cs[2:6]
  //       s.csrr_D.value           = s.cs[1:2]
  //       s.csrw_D.value           = s.cs[0:1]
  //
  //       # setting the actual write address
  //
  //       s.rf_waddr_D.value = s.inst_D[RD]
  //
  //       # csrr/csrw logic
  //
  //       s.csrr_sel_D.value      = 0
  //       s.xcelreq_type_D.value  = 0
  //       s.xcelreq_D.value       = 0
  //       s.mngr2proc_rdy_D.value = 0
  //       s.proc2mngr_val_D.value = 0
  //       s.stats_en_wen_D.value  = 0
  //
  //       if s.csrr_D:
  //         if   s.inst_D[CSRNUM] == CSR_NUMCORES:
  //           s.csrr_sel_D.value = 1
  //         elif s.inst_D[CSRNUM] == CSR_COREID:
  //           s.csrr_sel_D.value = 2
  //         elif s.inst_D[CSRNUM] == CSR_MNGR2PROC:
  //           s.mngr2proc_rdy_D.value = 1
  //
  //         else:
  //           # FIXME
  //           s.xcelreq_type_D.value = XcelReqMsg.TYPE_READ
  //           s.xcelreq_D.value = 1
  //
  //       if s.csrw_D:
  //         if   s.inst_D[CSRNUM] == CSR_PROC2MNGR:
  //           s.proc2mngr_val_D.value = 1
  //         elif s.inst_D[CSRNUM] == CSR_STATS_EN:
  //           s.stats_en_wen_D.value = 1
  //
  //         # In this case we handle accelerator registers requests.
  //         else:
  //           # FIXME
  //           s.xcelreq_type_D.value = XcelReqMsg.TYPE_WRITE
  //           s.xcelreq_D.value = 1

  // logic for comb_control_table_D()
  always @ (*) begin
    inst__9 = inst_type_decoder_D$out;
    if ((inst__9 == NOP)) begin
      cs = { y,br_na,n,am_x,n,imm_x,bm_x,n,alu_x,mem_nr,mlen_x,xm_x,dm_x,wm_a,n,md_x,n,n };
    end
    else begin
      if ((inst__9 == CSRRX)) begin
        cs = { y,br_na,n,am_x,n,imm_i,bm_imm,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_c,y,md_x,y,n };
      end
      else begin
        if ((inst__9 == CSRR)) begin
          cs = { y,br_na,n,am_x,n,imm_i,bm_csr,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,y,n };
        end
        else begin
          if ((inst__9 == CSRW)) begin
            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_cp0,mem_nr,mlen_x,xm_a,dm_x,wm_a,n,md_x,n,y };
          end
          else begin
            if ((inst__9 == ADD)) begin
              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
            end
            else begin
              if ((inst__9 == SUB)) begin
                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sub,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
              end
              else begin
                if ((inst__9 == AND)) begin
                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_and,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                end
                else begin
                  if ((inst__9 == OR)) begin
                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_or,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                  end
                  else begin
                    if ((inst__9 == XOR)) begin
                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_xor,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                    end
                    else begin
                      if ((inst__9 == SLT)) begin
                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                      end
                      else begin
                        if ((inst__9 == SLTU)) begin
                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                        end
                        else begin
                          if ((inst__9 == SRA)) begin
                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sra,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                          end
                          else begin
                            if ((inst__9 == SRL)) begin
                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_srl,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                            end
                            else begin
                              if ((inst__9 == SLL)) begin
                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sll,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                              end
                              else begin
                                if ((inst__9 == ADDI)) begin
                                  cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                end
                                else begin
                                  if ((inst__9 == ANDI)) begin
                                    cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_and,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                  end
                                  else begin
                                    if ((inst__9 == ORI)) begin
                                      cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_or,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                    end
                                    else begin
                                      if ((inst__9 == XORI)) begin
                                        cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_xor,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                      end
                                      else begin
                                        if ((inst__9 == SLTI)) begin
                                          cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                        end
                                        else begin
                                          if ((inst__9 == SLTIU)) begin
                                            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                          end
                                          else begin
                                            if ((inst__9 == SRAI)) begin
                                              cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_sra,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                            end
                                            else begin
                                              if ((inst__9 == SRLI)) begin
                                                cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_srl,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                              end
                                              else begin
                                                if ((inst__9 == SLLI)) begin
                                                  cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_sll,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                end
                                                else begin
                                                  if ((inst__9 == LUI)) begin
                                                    cs = { y,br_na,n,am_x,n,imm_u,bm_imm,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                  end
                                                  else begin
                                                    if ((inst__9 == AUIPC)) begin
                                                      cs = { y,br_na,n,am_pc,n,imm_u,bm_imm,n,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                    end
                                                    else begin
                                                      if ((inst__9 == BNE)) begin
                                                        cs = { y,br_ne,n,am_rf,y,imm_b,bm_rf,y,alu_x,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                      end
                                                      else begin
                                                        if ((inst__9 == BEQ)) begin
                                                          cs = { y,br_eq,n,am_rf,y,imm_b,bm_rf,y,alu_x,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                        end
                                                        else begin
                                                          if ((inst__9 == BLT)) begin
                                                            cs = { y,br_lt,n,am_rf,y,imm_b,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                          end
                                                          else begin
                                                            if ((inst__9 == BLTU)) begin
                                                              cs = { y,br_lu,n,am_rf,y,imm_b,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                            end
                                                            else begin
                                                              if ((inst__9 == BGE)) begin
                                                                cs = { y,br_ge,n,am_rf,y,imm_b,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                              end
                                                              else begin
                                                                if ((inst__9 == BGEU)) begin
                                                                  cs = { y,br_gu,n,am_rf,y,imm_b,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                                end
                                                                else begin
                                                                  if ((inst__9 == JAL)) begin
                                                                    cs = { y,br_na,y,am_x,n,imm_j,bm_x,n,alu_x,mem_nr,mlen_x,xm_p,dm_x,wm_a,y,md_x,n,n };
                                                                  end
                                                                  else begin
                                                                    if ((inst__9 == JALR)) begin
                                                                      cs = { y,jalr,n,am_rf,y,imm_i,bm_imm,n,alu_adz,mem_nr,mlen_x,xm_p,dm_x,wm_a,y,md_x,n,n };
                                                                    end
                                                                    else begin
                                                                      if ((inst__9 == LB)) begin
                                                                        cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_b,xm_a,dm_b,wm_m,y,md_x,n,n };
                                                                      end
                                                                      else begin
                                                                        if ((inst__9 == LH)) begin
                                                                          cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_h,xm_a,dm_h,wm_m,y,md_x,n,n };
                                                                        end
                                                                        else begin
                                                                          if ((inst__9 == LW)) begin
                                                                            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                          end
                                                                          else begin
                                                                            if ((inst__9 == LBU)) begin
                                                                              cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_b,xm_a,dm_bu,wm_m,y,md_x,n,n };
                                                                            end
                                                                            else begin
                                                                              if ((inst__9 == LHU)) begin
                                                                                cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_h,xm_a,dm_hu,wm_m,y,md_x,n,n };
                                                                              end
                                                                              else begin
                                                                                if ((inst__9 == SB)) begin
                                                                                  cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_b,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                end
                                                                                else begin
                                                                                  if ((inst__9 == SH)) begin
                                                                                    cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_h,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                  end
                                                                                  else begin
                                                                                    if ((inst__9 == SW)) begin
                                                                                      cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_w,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                    end
                                                                                    else begin
                                                                                      if ((inst__9 == AMOADD)) begin
                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_ad,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                      end
                                                                                      else begin
                                                                                        if ((inst__9 == AMOAND)) begin
                                                                                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_an,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                        end
                                                                                        else begin
                                                                                          if ((inst__9 == AMOOR)) begin
                                                                                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_or,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                          end
                                                                                          else begin
                                                                                            if ((inst__9 == AMOSWAP)) begin
                                                                                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_sp,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                            end
                                                                                            else begin
                                                                                              if ((inst__9 == AMOMIN)) begin
                                                                                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mn,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                              end
                                                                                              else begin
                                                                                                if ((inst__9 == AMOMINU)) begin
                                                                                                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mnu,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                end
                                                                                                else begin
                                                                                                  if ((inst__9 == AMOMAX)) begin
                                                                                                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mx,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                  end
                                                                                                  else begin
                                                                                                    if ((inst__9 == AMOMAXU)) begin
                                                                                                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mxu,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                    end
                                                                                                    else begin
                                                                                                      if ((inst__9 == AMOXOR)) begin
                                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_xr,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                      end
                                                                                                      else begin
                                                                                                        if ((inst__9 == MUL)) begin
                                                                                                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mul,n,n };
                                                                                                        end
                                                                                                        else begin
                                                                                                          if ((inst__9 == MULH)) begin
                                                                                                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mh,n,n };
                                                                                                          end
                                                                                                          else begin
                                                                                                            if ((inst__9 == MULHSU)) begin
                                                                                                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mhsu,n,n };
                                                                                                            end
                                                                                                            else begin
                                                                                                              if ((inst__9 == MULHU)) begin
                                                                                                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mhu,n,n };
                                                                                                              end
                                                                                                              else begin
                                                                                                                if ((inst__9 == DIV)) begin
                                                                                                                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_div,n,n };
                                                                                                                end
                                                                                                                else begin
                                                                                                                  if ((inst__9 == DIVU)) begin
                                                                                                                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_divu,n,n };
                                                                                                                  end
                                                                                                                  else begin
                                                                                                                    if ((inst__9 == REM)) begin
                                                                                                                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_rem,n,n };
                                                                                                                    end
                                                                                                                    else begin
                                                                                                                      if ((inst__9 == REMU)) begin
                                                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_remu,n,n };
                                                                                                                      end
                                                                                                                      else begin
                                                                                                                        cs = { n,br_x,n,am_x,n,imm_x,bm_x,n,alu_x,mem_nr,mlen_x,xm_x,dm_x,wm_x,n,n,n,n };
                                                                                                                      end
                                                                                                                    end
                                                                                                                  end
                                                                                                                end
                                                                                                              end
                                                                                                            end
                                                                                                          end
                                                                                                        end
                                                                                                      end
                                                                                                    end
                                                                                                  end
                                                                                                end
                                                                                              end
                                                                                            end
                                                                                          end
                                                                                        end
                                                                                      end
                                                                                    end
                                                                                  end
                                                                                end
                                                                              end
                                                                            end
                                                                          end
                                                                        end
                                                                      end
                                                                    end
                                                                  end
                                                                end
                                                              end
                                                            end
                                                          end
                                                        end
                                                      end
                                                    end
                                                  end
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    inst_val_D = cs[(37)-1:36];
    br_type_D = cs[(36)-1:33];
    jal_D = cs[(33)-1:32];
    op1_sel_D = cs[(32)-1:31];
    rs1_en_D = cs[(31)-1:30];
    imm_type_D = cs[(30)-1:27];
    op2_sel_D = cs[(27)-1:25];
    rs2_en_D = cs[(25)-1:24];
    alu_fn_D = cs[(24)-1:20];
    dmemreq_type_D = cs[(20)-1:16];
    dmemreq_len_D = cs[(16)-1:14];
    ex_result_sel_D = cs[(14)-1:12];
    dm_resp_sel_D = cs[(12)-1:9];
    wb_result_sel_D = cs[(9)-1:7];
    rf_wen_pending_D = cs[(7)-1:6];
    mdu_D = cs[(6)-1:2];
    csrr_D = cs[(2)-1:1];
    csrw_D = cs[(1)-1:0];
    rf_waddr_D = inst_D[(12)-1:7];
    csrr_sel_D = 0;
    xcelreq_type_D = 0;
    xcelreq_D = 0;
    mngr2proc_rdy_D = 0;
    proc2mngr_val_D = 0;
    stats_en_wen_D = 0;
    if (csrr_D) begin
      if ((inst_D[(32)-1:20] == CSR_NUMCORES)) begin
        csrr_sel_D = 1;
      end
      else begin
        if ((inst_D[(32)-1:20] == CSR_COREID)) begin
          csrr_sel_D = 2;
        end
        else begin
          if ((inst_D[(32)-1:20] == CSR_MNGR2PROC)) begin
            mngr2proc_rdy_D = 1;
          end
          else begin
            xcelreq_type_D = TYPE_READ;
            xcelreq_D = 1;
          end
        end
      end
    end
    else begin
    end
    if (csrw_D) begin
      if ((inst_D[(32)-1:20] == CSR_PROC2MNGR)) begin
        proc2mngr_val_D = 1;
      end
      else begin
        if ((inst_D[(32)-1:20] == CSR_STATS_EN)) begin
          stats_en_wen_D = 1;
        end
        else begin
          xcelreq_type_D = TYPE_WRITE;
          xcelreq_D = 1;
        end
      end
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_jump_D():
  //
  //       if s.val_D and s.jal_D:
  //         s.pc_redirect_D.value = 1
  //       else:
  //         s.pc_redirect_D.value = 0

  // logic for comb_jump_D()
  always @ (*) begin
    if ((val_D&&jal_D)) begin
      pc_redirect_D = 1;
    end
    else begin
      pc_redirect_D = 0;
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_bypass_D():
  //
  //       s.op1_byp_sel_D.value = byp_d
  //
  //       if s.rs1_en_D:
  //
  //         if   s.val_X & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //                      & s.rf_wen_pending_X:    s.op1_byp_sel_D.value = byp_x
  //         elif s.val_M & ( s.inst_D[ RS1 ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ) \
  //                      & s.rf_wen_pending_M:    s.op1_byp_sel_D.value = byp_m
  //         elif s.val_W & ( s.inst_D[ RS1 ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ) \
  //                      & s.rf_wen_pending_W:    s.op1_byp_sel_D.value = byp_w
  //
  //       s.op2_byp_sel_D.value = byp_d
  //
  //       if s.rs2_en_D:
  //
  //         if   s.val_X & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //                      & s.rf_wen_pending_X:    s.op2_byp_sel_D.value = byp_x
  //         elif s.val_M & ( s.inst_D[ RS2 ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ) \
  //                      & s.rf_wen_pending_M:    s.op2_byp_sel_D.value = byp_m
  //         elif s.val_W & ( s.inst_D[ RS2 ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ) \
  //                      & s.rf_wen_pending_W:    s.op2_byp_sel_D.value = byp_w

  // logic for comb_bypass_D()
  always @ (*) begin
    op1_byp_sel_D = byp_d;
    if (rs1_en_D) begin
      if ((((val_X&(inst_D[(20)-1:15] == rf_waddr_X))&(rf_waddr_X != 0))&rf_wen_pending_X)) begin
        op1_byp_sel_D = byp_x;
      end
      else begin
        if ((((val_M&(inst_D[(20)-1:15] == rf_waddr_M))&(rf_waddr_M != 0))&rf_wen_pending_M)) begin
          op1_byp_sel_D = byp_m;
        end
        else begin
          if ((((val_W&(inst_D[(20)-1:15] == rf_waddr_W))&(rf_waddr_W != 0))&rf_wen_pending_W)) begin
            op1_byp_sel_D = byp_w;
          end
          else begin
          end
        end
      end
    end
    else begin
    end
    op2_byp_sel_D = byp_d;
    if (rs2_en_D) begin
      if ((((val_X&(inst_D[(25)-1:20] == rf_waddr_X))&(rf_waddr_X != 0))&rf_wen_pending_X)) begin
        op2_byp_sel_D = byp_x;
      end
      else begin
        if ((((val_M&(inst_D[(25)-1:20] == rf_waddr_M))&(rf_waddr_M != 0))&rf_wen_pending_M)) begin
          op2_byp_sel_D = byp_m;
        end
        else begin
          if ((((val_W&(inst_D[(25)-1:20] == rf_waddr_W))&(rf_waddr_W != 0))&rf_wen_pending_W)) begin
            op2_byp_sel_D = byp_w;
          end
          else begin
          end
        end
      end
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_hazard_D():
  //
  //       s.ostall_ld_X_rs1_D.value =\
  //           s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & ( s.dmemreq_type_X == mem_ld )
  //
  //       s.ostall_ld_X_rs2_D.value =\
  //           s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & ( s.dmemreq_type_X == mem_ld )
  //
  //       s.ostall_amo_X_rs1_D.value =\
  //           s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & (   ( s.dmemreq_type_X == mem_ad  ) \
  //             | ( s.dmemreq_type_X == mem_an  ) \
  //             | ( s.dmemreq_type_X == mem_or  ) \
  //             | ( s.dmemreq_type_X == mem_sp  ) \
  //             | ( s.dmemreq_type_X == mem_mn  ) \
  //             | ( s.dmemreq_type_X == mem_mnu ) \
  //             | ( s.dmemreq_type_X == mem_mx  ) \
  //             | ( s.dmemreq_type_X == mem_mxu ) \
  //             | ( s.dmemreq_type_X == mem_xr  ) )
  //
  //       s.ostall_amo_X_rs2_D.value =\
  //           s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & (   ( s.dmemreq_type_X == mem_ad  ) \
  //             | ( s.dmemreq_type_X == mem_an  ) \
  //             | ( s.dmemreq_type_X == mem_or  ) \
  //             | ( s.dmemreq_type_X == mem_sp  ) \
  //             | ( s.dmemreq_type_X == mem_mn  ) \
  //             | ( s.dmemreq_type_X == mem_mnu ) \
  //             | ( s.dmemreq_type_X == mem_mx  ) \
  //             | ( s.dmemreq_type_X == mem_mxu ) \
  //             | ( s.dmemreq_type_X == mem_xr  ) )
  //
  //       s.ostall_csrrx_X_rs1_D.value =\
  //           s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & s.xcelreq_X & (s.xcelreq_type_X == XcelReqMsg.TYPE_READ)
  //
  //       s.ostall_csrrx_X_rs2_D.value =\
  //           s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
  //         & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
  //         & s.xcelreq_X & (s.xcelreq_type_X == XcelReqMsg.TYPE_READ)
  //
  //       s.ostall_hazard_D.value =\
  //           s.ostall_ld_X_rs1_D    | s.ostall_ld_X_rs2_D \
  //         | s.ostall_amo_X_rs1_D   | s.ostall_amo_X_rs2_D \
  //         | s.ostall_csrrx_X_rs1_D | s.ostall_csrrx_X_rs2_D

  // logic for comb_hazard_D()
  always @ (*) begin
    ostall_ld_X_rs1_D = (((((rs1_en_D&val_X)&rf_wen_pending_X)&(inst_D[(20)-1:15] == rf_waddr_X))&(rf_waddr_X != 0))&(dmemreq_type_X == mem_ld));
    ostall_ld_X_rs2_D = (((((rs2_en_D&val_X)&rf_wen_pending_X)&(inst_D[(25)-1:20] == rf_waddr_X))&(rf_waddr_X != 0))&(dmemreq_type_X == mem_ld));
    ostall_amo_X_rs1_D = (((((rs1_en_D&val_X)&rf_wen_pending_X)&(inst_D[(20)-1:15] == rf_waddr_X))&(rf_waddr_X != 0))&(((((((((dmemreq_type_X == mem_ad)|(dmemreq_type_X == mem_an))|(dmemreq_type_X == mem_or))|(dmemreq_type_X == mem_sp))|(dmemreq_type_X == mem_mn))|(dmemreq_type_X == mem_mnu))|(dmemreq_type_X == mem_mx))|(dmemreq_type_X == mem_mxu))|(dmemreq_type_X == mem_xr)));
    ostall_amo_X_rs2_D = (((((rs2_en_D&val_X)&rf_wen_pending_X)&(inst_D[(25)-1:20] == rf_waddr_X))&(rf_waddr_X != 0))&(((((((((dmemreq_type_X == mem_ad)|(dmemreq_type_X == mem_an))|(dmemreq_type_X == mem_or))|(dmemreq_type_X == mem_sp))|(dmemreq_type_X == mem_mn))|(dmemreq_type_X == mem_mnu))|(dmemreq_type_X == mem_mx))|(dmemreq_type_X == mem_mxu))|(dmemreq_type_X == mem_xr)));
    ostall_csrrx_X_rs1_D = ((((((rs1_en_D&val_X)&rf_wen_pending_X)&(inst_D[(20)-1:15] == rf_waddr_X))&(rf_waddr_X != 0))&xcelreq_X)&(xcelreq_type_X == TYPE_READ));
    ostall_csrrx_X_rs2_D = ((((((rs2_en_D&val_X)&rf_wen_pending_X)&(inst_D[(25)-1:20] == rf_waddr_X))&(rf_waddr_X != 0))&xcelreq_X)&(xcelreq_type_X == TYPE_READ));
    ostall_hazard_D = (((((ostall_ld_X_rs1_D|ostall_ld_X_rs2_D)|ostall_amo_X_rs1_D)|ostall_amo_X_rs2_D)|ostall_csrrx_X_rs1_D)|ostall_csrrx_X_rs2_D);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_D():
  //
  //       # ostall due to mngr2proc
  //       s.ostall_mngr_D.value = s.mngr2proc_rdy_D & ~s.mngr2proc_val
  //
  //       # ostall due to mdu
  //       s.ostall_mdu_D.value  = s.val_D & (s.mdu_D != md_x) & ~s.mdureq_rdy
  //
  //       # put together all ostall conditions
  //
  //       s.ostall_D.value = s.val_D & ( s.ostall_mngr_D | s.ostall_hazard_D | s.ostall_mdu_D );
  //
  //       # stall in D stage
  //
  //       s.stall_D.value = s.val_D & ( s.ostall_D | s.ostall_X |
  //                                     s.ostall_M | s.ostall_W   )
  //
  //       # osquash due to jumps
  //       # Note that, in the same combinational block, we have to calculate
  //       # s.stall_D first then use it in osquash_D. Several people have
  //       # stuck here just because they calculate osquash_D before stall_D!
  //
  //       s.osquash_D.value = s.val_D & ~s.stall_D & s.pc_redirect_D
  //
  //       # squash in D stage
  //
  //       s.squash_D.value = s.val_D & s.osquash_X
  //
  //       # mngr2proc port
  //
  //       s.mngr2proc_rdy.value = s.val_D & ~s.stall_D & s.mngr2proc_rdy_D
  //
  //       # mdu request valid signal
  //
  //       s.mdureq_val.value = s.val_D & ~s.stall_D & ~s.squash_D & (s.mdu_D != md_x)
  //
  //       # send lower 3 bits, since 0-7 are valid types and don't care is 8
  //
  //       s.mdureq_msg_type.value = s.mdu_D[0:3]
  //
  //       # next valid bit
  //
  //       s.next_val_D.value = s.val_D & ~s.stall_D & ~s.squash_D

  // logic for comb_D()
  always @ (*) begin
    ostall_mngr_D = (mngr2proc_rdy_D&~mngr2proc_val);
    ostall_mdu_D = ((val_D&(mdu_D != md_x))&~mdureq_rdy);
    ostall_D = (val_D&((ostall_mngr_D|ostall_hazard_D)|ostall_mdu_D));
    stall_D = (val_D&(((ostall_D|ostall_X)|ostall_M)|ostall_W));
    osquash_D = ((val_D&~stall_D)&pc_redirect_D);
    squash_D = (val_D&osquash_X);
    mngr2proc_rdy = ((val_D&~stall_D)&mngr2proc_rdy_D);
    mdureq_val = (((val_D&~stall_D)&~squash_D)&(mdu_D != md_x));
    mdureq_msg_type = mdu_D[(3)-1:0];
    next_val_D = ((val_D&~stall_D)&~squash_D);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_reg_en_X():
  //       s.reg_en_X.value  = ~s.stall_X

  // logic for comb_reg_en_X()
  always @ (*) begin
    reg_en_X = ~stall_X;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_br_X():
  //       s.pc_redirect_X.value = 0
  //
  //       if s.val_X:
  //         if   s.br_type_X == br_eq: s.pc_redirect_X.value = s.br_cond_eq_X
  //         elif s.br_type_X == br_lt: s.pc_redirect_X.value = s.br_cond_lt_X
  //         elif s.br_type_X == br_lu: s.pc_redirect_X.value = s.br_cond_ltu_X
  //         elif s.br_type_X == br_ne: s.pc_redirect_X.value = ~s.br_cond_eq_X
  //         elif s.br_type_X == br_ge: s.pc_redirect_X.value = ~s.br_cond_lt_X
  //         elif s.br_type_X == br_gu: s.pc_redirect_X.value = ~s.br_cond_ltu_X
  //         elif s.br_type_X == jalr : s.pc_redirect_X.value = 1

  // logic for comb_br_X()
  always @ (*) begin
    pc_redirect_X = 0;
    if (val_X) begin
      if ((br_type_X == br_eq)) begin
        pc_redirect_X = br_cond_eq_X;
      end
      else begin
        if ((br_type_X == br_lt)) begin
          pc_redirect_X = br_cond_lt_X;
        end
        else begin
          if ((br_type_X == br_lu)) begin
            pc_redirect_X = br_cond_ltu_X;
          end
          else begin
            if ((br_type_X == br_ne)) begin
              pc_redirect_X = ~br_cond_eq_X;
            end
            else begin
              if ((br_type_X == br_ge)) begin
                pc_redirect_X = ~br_cond_lt_X;
              end
              else begin
                if ((br_type_X == br_gu)) begin
                  pc_redirect_X = ~br_cond_ltu_X;
                end
                else begin
                  if ((br_type_X == jalr)) begin
                    pc_redirect_X = 1;
                  end
                  else begin
                  end
                end
              end
            end
          end
        end
      end
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_X():
  //
  //       # ostall due to xcelreq
  //       s.ostall_xcel_X.value = s.xcelreq_X & ~s.xcelreq_rdy
  //
  //       # ostall due to dmemreq
  //       s.ostall_dmem_X.value = ( s.dmemreq_type_X != mem_nr ) & ~s.dmemreq_rdy
  //
  //       # ostall due to mdu
  //       s.ostall_mdu_X.value = (s.mdu_X != md_x) & ~s.mduresp_val
  //
  //       s.ostall_X.value = s.val_X & ( s.ostall_dmem_X | s.ostall_mdu_X | s.ostall_xcel_X )
  //
  //       # stall in X stage
  //
  //       s.stall_X.value  = s.val_X & ( s.ostall_X | s.ostall_M | s.ostall_W )
  //
  //       # osquash due to taken branches
  //       # Note that, in the same combinational block, we have to calculate
  //       # s.stall_X first then use it in osquash_X. Several people have
  //       # stuck here just because they calculate osquash_X before stall_X!
  //
  //       s.osquash_X.value   = s.val_X & ~s.stall_X & s.pc_redirect_X
  //
  //       # send dmemreq if not stalling
  //
  //       s.dmemreq_val.value = s.val_X & ~s.stall_X & ( s.dmemreq_type_X != mem_nr )
  //
  //       # set dmemreq type, with MemReqMsg.TYPE_READ as "don't care / load"
  //
  //       if   s.dmemreq_type_X == mem_st  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_WRITE
  //       elif s.dmemreq_type_X == mem_ad  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_ADD
  //       elif s.dmemreq_type_X == mem_an  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_AND
  //       elif s.dmemreq_type_X == mem_or  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_OR
  //       elif s.dmemreq_type_X == mem_sp  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_SWAP
  //       elif s.dmemreq_type_X == mem_mn  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MIN
  //       elif s.dmemreq_type_X == mem_mnu : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MINU
  //       elif s.dmemreq_type_X == mem_mx  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MAX
  //       elif s.dmemreq_type_X == mem_mxu : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MAXU
  //       elif s.dmemreq_type_X == mem_xr  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_XOR
  //       else                             : s.dmemreq_msg_type.value = MemReqMsg.TYPE_READ
  //
  //       # set dmemreq len
  //
  //       s.dmemreq_msg_len.value = s.dmemreq_len_X
  //
  //       # send xcelreq if not stalling
  //
  //       s.xcelreq_val.value = s.val_X & ~s.stall_X & s.xcelreq_X
  //       s.xcelreq_msg_type.value  = s.xcelreq_type_X
  //
  //       # mdu resp ready signal
  //
  //       s.mduresp_rdy.value = s.val_X & ~s.stall_X & ( s.mdu_X != md_x )
  //
  //       # next valid bit
  //
  //       s.next_val_X.value  = s.val_X & ~s.stall_X

  // logic for comb_X()
  always @ (*) begin
    ostall_xcel_X = (xcelreq_X&~xcelreq_rdy);
    ostall_dmem_X = ((dmemreq_type_X != mem_nr)&~dmemreq_rdy);
    ostall_mdu_X = ((mdu_X != md_x)&~mduresp_val);
    ostall_X = (val_X&((ostall_dmem_X|ostall_mdu_X)|ostall_xcel_X));
    stall_X = (val_X&((ostall_X|ostall_M)|ostall_W));
    osquash_X = ((val_X&~stall_X)&pc_redirect_X);
    dmemreq_val = ((val_X&~stall_X)&(dmemreq_type_X != mem_nr));
    if ((dmemreq_type_X == mem_st)) begin
      dmemreq_msg_type = TYPE_WRITE;
    end
    else begin
      if ((dmemreq_type_X == mem_ad)) begin
        dmemreq_msg_type = TYPE_AMO_ADD;
      end
      else begin
        if ((dmemreq_type_X == mem_an)) begin
          dmemreq_msg_type = TYPE_AMO_AND;
        end
        else begin
          if ((dmemreq_type_X == mem_or)) begin
            dmemreq_msg_type = TYPE_AMO_OR;
          end
          else begin
            if ((dmemreq_type_X == mem_sp)) begin
              dmemreq_msg_type = TYPE_AMO_SWAP;
            end
            else begin
              if ((dmemreq_type_X == mem_mn)) begin
                dmemreq_msg_type = TYPE_AMO_MIN;
              end
              else begin
                if ((dmemreq_type_X == mem_mnu)) begin
                  dmemreq_msg_type = TYPE_AMO_MINU;
                end
                else begin
                  if ((dmemreq_type_X == mem_mx)) begin
                    dmemreq_msg_type = TYPE_AMO_MAX;
                  end
                  else begin
                    if ((dmemreq_type_X == mem_mxu)) begin
                      dmemreq_msg_type = TYPE_AMO_MAXU;
                    end
                    else begin
                      if ((dmemreq_type_X == mem_xr)) begin
                        dmemreq_msg_type = TYPE_AMO_XOR;
                      end
                      else begin
                        dmemreq_msg_type = TYPE_READ;
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    dmemreq_msg_len = dmemreq_len_X;
    xcelreq_val = ((val_X&~stall_X)&xcelreq_X);
    xcelreq_msg_type = xcelreq_type_X;
    mduresp_rdy = ((val_X&~stall_X)&(mdu_X != md_x));
    next_val_X = (val_X&~stall_X);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_reg_en_M():
  //       s.reg_en_M.value = ~s.stall_M

  // logic for comb_reg_en_M()
  always @ (*) begin
    reg_en_M = ~stall_M;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_M():
  //
  //       # ostall due to xcel resp
  //       s.ostall_xcel_M.value = s.xcelreq_M & ~s.xcelresp_val
  //
  //       # ostall due to dmem resp
  //       s.ostall_dmem_M.value = ( s.dmemreq_type_M != mem_nr ) & ~s.dmemresp_val
  //
  //       s.ostall_M.value = s.val_M & ( s.ostall_dmem_M | s.ostall_xcel_M )
  //
  //       # stall in M stage
  //
  //       s.stall_M.value  = s.val_M & ( s.ostall_M | s.ostall_W )
  //
  //       # set dmemresp ready if not stalling
  //
  //       s.dmemresp_rdy.value = s.val_M & ~s.stall_M & ( s.dmemreq_type_M != mem_nr )
  //
  //       # set xcelresp ready if not stalling
  //
  //       s.xcelresp_rdy.value = s.val_M & ~s.stall_M & s.xcelreq_M
  //
  //       # next valid bit
  //
  //       s.next_val_M.value   = s.val_M & ~s.stall_M

  // logic for comb_M()
  always @ (*) begin
    ostall_xcel_M = (xcelreq_M&~xcelresp_val);
    ostall_dmem_M = ((dmemreq_type_M != mem_nr)&~dmemresp_val);
    ostall_M = (val_M&(ostall_dmem_M|ostall_xcel_M));
    stall_M = (val_M&(ostall_M|ostall_W));
    dmemresp_rdy = ((val_M&~stall_M)&(dmemreq_type_M != mem_nr));
    xcelresp_rdy = ((val_M&~stall_M)&xcelreq_M);
    next_val_M = (val_M&~stall_M);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_W():
  //       s.reg_en_W.value = ~s.stall_W

  // logic for comb_W()
  always @ (*) begin
    reg_en_W = ~stall_W;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_W():
  //       # set RF write enable if valid
  //
  //       s.rf_wen_W.value       = s.val_W & s.rf_wen_pending_W
  //       s.stats_en_wen_W.value = s.val_W & s.stats_en_wen_pending_W
  //
  //       # ostall due to proc2mngr
  //
  //       s.ostall_W.value      = s.val_W & s.proc2mngr_val_W & ~s.proc2mngr_rdy
  //
  //       # stall in W stage
  //
  //       s.stall_W.value       = s.val_W & s.ostall_W
  //
  //       # set proc2mngr val if not stalling
  //
  //       s.proc2mngr_val.value = s.val_W & ~s.stall_W & s.proc2mngr_val_W
  //
  //       s.commit_inst.value   = s.val_W & ~s.stall_W

  // logic for comb_W()
  always @ (*) begin
    rf_wen_W = (val_W&rf_wen_pending_W);
    stats_en_wen_W = (val_W&stats_en_wen_pending_W);
    ostall_W = ((val_W&proc2mngr_val_W)&~proc2mngr_rdy);
    stall_W = (val_W&ostall_W);
    proc2mngr_val = ((val_W&~stall_W)&proc2mngr_val_W);
    commit_inst = (val_W&~stall_W);
  end


endmodule // ProcCtrlPRTL_0x617f7f1281b6b6f0
`default_nettype wire

//-----------------------------------------------------------------------------
// DecodeInstType_0x72c9bb161518ada2
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DecodeInstType_0x72c9bb161518ada2
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [   7:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam ADD = 15;
  localparam ADDI = 16;
  localparam AMOADD = 47;
  localparam AMOAND = 50;
  localparam AMOMAX = 52;
  localparam AMOMAXU = 54;
  localparam AMOMIN = 51;
  localparam AMOMINU = 53;
  localparam AMOOR = 49;
  localparam AMOSWAP = 46;
  localparam AMOXOR = 48;
  localparam AND = 24;
  localparam ANDI = 25;
  localparam AUIPC = 19;
  localparam BEQ = 30;
  localparam BGE = 33;
  localparam BGEU = 35;
  localparam BLT = 32;
  localparam BLTU = 34;
  localparam BNE = 31;
  localparam CSRR = 55;
  localparam CSRRX = 58;
  localparam CSRW = 56;
  localparam DIV = 42;
  localparam DIVU = 43;
  localparam JAL = 36;
  localparam JALR = 37;
  localparam LB = 1;
  localparam LBU = 4;
  localparam LH = 2;
  localparam LHU = 5;
  localparam LUI = 18;
  localparam LW = 3;
  localparam MUL = 38;
  localparam MULH = 39;
  localparam MULHSU = 40;
  localparam MULHU = 41;
  localparam NOP = 0;
  localparam OR = 22;
  localparam ORI = 23;
  localparam REM = 44;
  localparam REMU = 45;
  localparam SB = 6;
  localparam SH = 7;
  localparam SLL = 9;
  localparam SLLI = 10;
  localparam SLT = 26;
  localparam SLTI = 27;
  localparam SLTIU = 29;
  localparam SLTU = 28;
  localparam SRA = 13;
  localparam SRAI = 14;
  localparam SRL = 11;
  localparam SRLI = 12;
  localparam SUB = 17;
  localparam SW = 8;
  localparam XOR = 20;
  localparam XORI = 21;
  localparam ZERO = 57;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       s.out.value = ZERO
  //
  //       if   s.in_ == 0b10011:                 s.out.value = NOP
  //       elif s.in_[OPCODE] == 0b0110011:
  //         if   s.in_[FUNCT7] == 0b0000000:
  //           if   s.in_[FUNCT3] == 0b000:       s.out.value = ADD
  //           elif s.in_[FUNCT3] == 0b001:       s.out.value = SLL
  //           elif s.in_[FUNCT3] == 0b010:       s.out.value = SLT
  //           elif s.in_[FUNCT3] == 0b011:       s.out.value = SLTU
  //           elif s.in_[FUNCT3] == 0b100:       s.out.value = XOR
  //           elif s.in_[FUNCT3] == 0b101:       s.out.value = SRL
  //           elif s.in_[FUNCT3] == 0b110:       s.out.value = OR
  //           elif s.in_[FUNCT3] == 0b111:       s.out.value = AND
  //         elif s.in_[FUNCT7] == 0b0100000:
  //           if   s.in_[FUNCT3] == 0b000:       s.out.value = SUB
  //           elif s.in_[FUNCT3] == 0b101:       s.out.value = SRA
  //         elif s.in_[FUNCT7] == 0b0000001:
  //           if   s.in_[FUNCT3] == 0b000:       s.out.value = MUL
  //           if   s.in_[FUNCT3] == 0b001:       s.out.value = MULH
  //           if   s.in_[FUNCT3] == 0b010:       s.out.value = MULHSU
  //           if   s.in_[FUNCT3] == 0b011:       s.out.value = MULHU
  //           if   s.in_[FUNCT3] == 0b100:       s.out.value = DIV
  //           if   s.in_[FUNCT3] == 0b101:       s.out.value = DIVU
  //           if   s.in_[FUNCT3] == 0b110:       s.out.value = REM
  //           if   s.in_[FUNCT3] == 0b111:       s.out.value = REMU
  //
  //       elif s.in_[OPCODE] == 0b0010011:
  //         if   s.in_[FUNCT3] == 0b000:         s.out.value = ADDI
  //         elif s.in_[FUNCT3] == 0b010:         s.out.value = SLTI
  //         elif s.in_[FUNCT3] == 0b011:         s.out.value = SLTIU
  //         elif s.in_[FUNCT3] == 0b100:         s.out.value = XORI
  //         elif s.in_[FUNCT3] == 0b110:         s.out.value = ORI
  //         elif s.in_[FUNCT3] == 0b111:         s.out.value = ANDI
  //         elif s.in_[FUNCT3] == 0b001:         s.out.value = SLLI
  //         elif s.in_[FUNCT3] == 0b101:
  //           if   s.in_[FUNCT7] == 0b0000000:   s.out.value = SRLI
  //           elif s.in_[FUNCT7] == 0b0100000:   s.out.value = SRAI
  //
  //       elif s.in_[OPCODE] == 0b0100011:
  //         if   s.in_[FUNCT3] == 0b000:         s.out.value = SB
  //         elif s.in_[FUNCT3] == 0b001:         s.out.value = SH
  //         elif s.in_[FUNCT3] == 0b010:         s.out.value = SW
  //
  //       elif s.in_[OPCODE] == 0b0000011:
  //         if   s.in_[FUNCT3] == 0b000:         s.out.value = LB
  //         elif s.in_[FUNCT3] == 0b001:         s.out.value = LH
  //         elif s.in_[FUNCT3] == 0b010:         s.out.value = LW
  //         elif s.in_[FUNCT3] == 0b100:         s.out.value = LBU
  //         elif s.in_[FUNCT3] == 0b101:         s.out.value = LHU
  //
  //       elif s.in_[OPCODE] == 0b1100011:
  //         if   s.in_[FUNCT3] == 0b000:         s.out.value = BEQ
  //         elif s.in_[FUNCT3] == 0b001:         s.out.value = BNE
  //         elif s.in_[FUNCT3] == 0b100:         s.out.value = BLT
  //         elif s.in_[FUNCT3] == 0b101:         s.out.value = BGE
  //         elif s.in_[FUNCT3] == 0b110:         s.out.value = BLTU
  //         elif s.in_[FUNCT3] == 0b111:         s.out.value = BGEU
  //
  //       elif s.in_[OPCODE] == 0b0110111:       s.out.value = LUI
  //
  //       elif s.in_[OPCODE] == 0b0010111:       s.out.value = AUIPC
  //
  //       elif s.in_[OPCODE] == 0b1101111:       s.out.value = JAL
  //
  //       elif s.in_[OPCODE] == 0b1100111:       s.out.value = JALR
  //
  //       elif s.in_[OPCODE] == 0b1110011:
  //         if   s.in_[FUNCT3] == 0b001:         s.out.value = CSRW
  //         elif s.in_[FUNCT3] == 0b010:
  //           if s.in_[FUNCT7] == 0b0111111:     s.out.value = CSRRX
  //           else:                              s.out.value = CSRR
  //       # elif s.in_[OPCODE] == 0b0001011:     s.out.value = CUST0
  //
  //       elif s.in_[OPCODE] == 0b0101111:
  //         if   s.in_[FUNCT3] == 0b010:
  //           if   s.in_[FUNCT5] == 0b00001:     s.out.value = AMOSWAP
  //           elif s.in_[FUNCT5] == 0b00000:     s.out.value = AMOADD
  //           elif s.in_[FUNCT5] == 0b00100:     s.out.value = AMOXOR
  //           elif s.in_[FUNCT5] == 0b01000:     s.out.value = AMOOR
  //           elif s.in_[FUNCT5] == 0b01100:     s.out.value = AMOAND
  //           elif s.in_[FUNCT5] == 0b10000:     s.out.value = AMOMIN
  //           elif s.in_[FUNCT5] == 0b10100:     s.out.value = AMOMAX
  //           elif s.in_[FUNCT5] == 0b11000:     s.out.value = AMOMINU
  //           elif s.in_[FUNCT5] == 0b11100:     s.out.value = AMOMAXU

  // logic for comb_logic()
  always @ (*) begin
    out = ZERO;
    if ((in_ == 19)) begin
      out = NOP;
    end
    else begin
      if ((in_[(7)-1:0] == 51)) begin
        if ((in_[(32)-1:25] == 0)) begin
          if ((in_[(15)-1:12] == 0)) begin
            out = ADD;
          end
          else begin
            if ((in_[(15)-1:12] == 1)) begin
              out = SLL;
            end
            else begin
              if ((in_[(15)-1:12] == 2)) begin
                out = SLT;
              end
              else begin
                if ((in_[(15)-1:12] == 3)) begin
                  out = SLTU;
                end
                else begin
                  if ((in_[(15)-1:12] == 4)) begin
                    out = XOR;
                  end
                  else begin
                    if ((in_[(15)-1:12] == 5)) begin
                      out = SRL;
                    end
                    else begin
                      if ((in_[(15)-1:12] == 6)) begin
                        out = OR;
                      end
                      else begin
                        if ((in_[(15)-1:12] == 7)) begin
                          out = AND;
                        end
                        else begin
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        else begin
          if ((in_[(32)-1:25] == 32)) begin
            if ((in_[(15)-1:12] == 0)) begin
              out = SUB;
            end
            else begin
              if ((in_[(15)-1:12] == 5)) begin
                out = SRA;
              end
              else begin
              end
            end
          end
          else begin
            if ((in_[(32)-1:25] == 1)) begin
              if ((in_[(15)-1:12] == 0)) begin
                out = MUL;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 1)) begin
                out = MULH;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 2)) begin
                out = MULHSU;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 3)) begin
                out = MULHU;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 4)) begin
                out = DIV;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 5)) begin
                out = DIVU;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 6)) begin
                out = REM;
              end
              else begin
              end
              if ((in_[(15)-1:12] == 7)) begin
                out = REMU;
              end
              else begin
              end
            end
            else begin
            end
          end
        end
      end
      else begin
        if ((in_[(7)-1:0] == 19)) begin
          if ((in_[(15)-1:12] == 0)) begin
            out = ADDI;
          end
          else begin
            if ((in_[(15)-1:12] == 2)) begin
              out = SLTI;
            end
            else begin
              if ((in_[(15)-1:12] == 3)) begin
                out = SLTIU;
              end
              else begin
                if ((in_[(15)-1:12] == 4)) begin
                  out = XORI;
                end
                else begin
                  if ((in_[(15)-1:12] == 6)) begin
                    out = ORI;
                  end
                  else begin
                    if ((in_[(15)-1:12] == 7)) begin
                      out = ANDI;
                    end
                    else begin
                      if ((in_[(15)-1:12] == 1)) begin
                        out = SLLI;
                      end
                      else begin
                        if ((in_[(15)-1:12] == 5)) begin
                          if ((in_[(32)-1:25] == 0)) begin
                            out = SRLI;
                          end
                          else begin
                            if ((in_[(32)-1:25] == 32)) begin
                              out = SRAI;
                            end
                            else begin
                            end
                          end
                        end
                        else begin
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        else begin
          if ((in_[(7)-1:0] == 35)) begin
            if ((in_[(15)-1:12] == 0)) begin
              out = SB;
            end
            else begin
              if ((in_[(15)-1:12] == 1)) begin
                out = SH;
              end
              else begin
                if ((in_[(15)-1:12] == 2)) begin
                  out = SW;
                end
                else begin
                end
              end
            end
          end
          else begin
            if ((in_[(7)-1:0] == 3)) begin
              if ((in_[(15)-1:12] == 0)) begin
                out = LB;
              end
              else begin
                if ((in_[(15)-1:12] == 1)) begin
                  out = LH;
                end
                else begin
                  if ((in_[(15)-1:12] == 2)) begin
                    out = LW;
                  end
                  else begin
                    if ((in_[(15)-1:12] == 4)) begin
                      out = LBU;
                    end
                    else begin
                      if ((in_[(15)-1:12] == 5)) begin
                        out = LHU;
                      end
                      else begin
                      end
                    end
                  end
                end
              end
            end
            else begin
              if ((in_[(7)-1:0] == 99)) begin
                if ((in_[(15)-1:12] == 0)) begin
                  out = BEQ;
                end
                else begin
                  if ((in_[(15)-1:12] == 1)) begin
                    out = BNE;
                  end
                  else begin
                    if ((in_[(15)-1:12] == 4)) begin
                      out = BLT;
                    end
                    else begin
                      if ((in_[(15)-1:12] == 5)) begin
                        out = BGE;
                      end
                      else begin
                        if ((in_[(15)-1:12] == 6)) begin
                          out = BLTU;
                        end
                        else begin
                          if ((in_[(15)-1:12] == 7)) begin
                            out = BGEU;
                          end
                          else begin
                          end
                        end
                      end
                    end
                  end
                end
              end
              else begin
                if ((in_[(7)-1:0] == 55)) begin
                  out = LUI;
                end
                else begin
                  if ((in_[(7)-1:0] == 23)) begin
                    out = AUIPC;
                  end
                  else begin
                    if ((in_[(7)-1:0] == 111)) begin
                      out = JAL;
                    end
                    else begin
                      if ((in_[(7)-1:0] == 103)) begin
                        out = JALR;
                      end
                      else begin
                        if ((in_[(7)-1:0] == 115)) begin
                          if ((in_[(15)-1:12] == 1)) begin
                            out = CSRW;
                          end
                          else begin
                            if ((in_[(15)-1:12] == 2)) begin
                              if ((in_[(32)-1:25] == 63)) begin
                                out = CSRRX;
                              end
                              else begin
                                out = CSRR;
                              end
                            end
                            else begin
                            end
                          end
                        end
                        else begin
                          if ((in_[(7)-1:0] == 47)) begin
                            if ((in_[(15)-1:12] == 2)) begin
                              if ((in_[(32)-1:27] == 1)) begin
                                out = AMOSWAP;
                              end
                              else begin
                                if ((in_[(32)-1:27] == 0)) begin
                                  out = AMOADD;
                                end
                                else begin
                                  if ((in_[(32)-1:27] == 4)) begin
                                    out = AMOXOR;
                                  end
                                  else begin
                                    if ((in_[(32)-1:27] == 8)) begin
                                      out = AMOOR;
                                    end
                                    else begin
                                      if ((in_[(32)-1:27] == 12)) begin
                                        out = AMOAND;
                                      end
                                      else begin
                                        if ((in_[(32)-1:27] == 16)) begin
                                          out = AMOMIN;
                                        end
                                        else begin
                                          if ((in_[(32)-1:27] == 20)) begin
                                            out = AMOMAX;
                                          end
                                          else begin
                                            if ((in_[(32)-1:27] == 24)) begin
                                              out = AMOMINU;
                                            end
                                            else begin
                                              if ((in_[(32)-1:27] == 28)) begin
                                                out = AMOMAXU;
                                              end
                                              else begin
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                            else begin
                            end
                          end
                          else begin
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end


endmodule // DecodeInstType_0x72c9bb161518ada2
`default_nettype wire

//-----------------------------------------------------------------------------
// DropUnitPRTL_0x3e9fa6cf37077802
//-----------------------------------------------------------------------------
// nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DropUnitPRTL_0x3e9fa6cf37077802
(
  input  wire [   0:0] clk,
  input  wire [   0:0] drop,
  input  wire [  31:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  31:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] do_wait__0;
  reg    [   0:0] in_go__0;
  reg    [   0:0] snoop_state$in_;

  // localparam declarations
  localparam SNOOP = 0;
  localparam WAIT = 1;

  // snoop_state temporaries
  wire   [   0:0] snoop_state$reset;
  wire   [   0:0] snoop_state$clk;
  wire   [   0:0] snoop_state$out;

  RegRst_0x2ce052f8c32c5c39 snoop_state
  (
    .reset ( snoop_state$reset ),
    .in_   ( snoop_state$in_ ),
    .clk   ( snoop_state$clk ),
    .out   ( snoop_state$out )
  );

  // signal connections
  assign out_msg           = in__msg;
  assign snoop_state$clk   = clk;
  assign snoop_state$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transitions():
  //
  //       in_go   = s.in_.rdy and s.in_.val
  //       do_wait = s.drop    and not in_go
  //
  //       if s.snoop_state.out.value == SNOOP:
  //         if do_wait: s.snoop_state.in_.value = WAIT
  //         else:       s.snoop_state.in_.value = SNOOP
  //
  //       elif s.snoop_state.out == WAIT:
  //         if in_go: s.snoop_state.in_.value = SNOOP
  //         else:     s.snoop_state.in_.value = WAIT

  // logic for state_transitions()
  always @ (*) begin
    in_go__0 = (in__rdy&&in__val);
    do_wait__0 = (drop&&!in_go__0);
    if ((snoop_state$out == SNOOP)) begin
      if (do_wait__0) begin
        snoop_state$in_ = WAIT;
      end
      else begin
        snoop_state$in_ = SNOOP;
      end
    end
    else begin
      if ((snoop_state$out == WAIT)) begin
        if (in_go__0) begin
          snoop_state$in_ = SNOOP;
        end
        else begin
          snoop_state$in_ = WAIT;
        end
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def set_outputs():
  //
  //       if   s.snoop_state.out == SNOOP:
  //         s.out.val.value = s.in_.val and not s.drop
  //         s.in_.rdy.value = s.out.rdy
  //
  //       elif s.snoop_state.out == WAIT:
  //         s.out.val.value = 0
  //         s.in_.rdy.value = 1

  // logic for set_outputs()
  always @ (*) begin
    if ((snoop_state$out == SNOOP)) begin
      out_val = (in__val&&!drop);
      in__rdy = out_rdy;
    end
    else begin
      if ((snoop_state$out == WAIT)) begin
        out_val = 0;
        in__rdy = 1;
      end
      else begin
      end
    end
  end


endmodule // DropUnitPRTL_0x3e9fa6cf37077802
`default_nettype wire

//-----------------------------------------------------------------------------
// RegRst_0x2ce052f8c32c5c39
//-----------------------------------------------------------------------------
// dtype: 1
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegRst_0x2ce052f8c32c5c39
(
  input  wire [   0:0] clk,
  input  wire [   0:0] in_,
  output reg  [   0:0] out,
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


endmodule // RegRst_0x2ce052f8c32c5c39
`default_nettype wire

//-----------------------------------------------------------------------------
// TwoElementBypassQueue_0x69a36ac73a4a8994
//-----------------------------------------------------------------------------
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module TwoElementBypassQueue_0x69a36ac73a4a8994
(
  input  wire [   0:0] clk,
  output wire [  77:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  output reg  [   0:0] empty,
  input  wire [  77:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   0:0] full,
  input  wire [   0:0] reset
);

  // queue1 temporaries
  wire   [   0:0] queue1$clk;
  wire   [  77:0] queue1$enq_msg;
  wire   [   0:0] queue1$enq_val;
  wire   [   0:0] queue1$reset;
  wire   [   0:0] queue1$deq_rdy;
  wire   [   0:0] queue1$enq_rdy;
  wire   [   0:0] queue1$full;
  wire   [  77:0] queue1$deq_msg;
  wire   [   0:0] queue1$deq_val;

  SingleElementBypassQueue_0x69a36ac73a4a8994 queue1
  (
    .clk     ( queue1$clk ),
    .enq_msg ( queue1$enq_msg ),
    .enq_val ( queue1$enq_val ),
    .reset   ( queue1$reset ),
    .deq_rdy ( queue1$deq_rdy ),
    .enq_rdy ( queue1$enq_rdy ),
    .full    ( queue1$full ),
    .deq_msg ( queue1$deq_msg ),
    .deq_val ( queue1$deq_val )
  );

  // queue0 temporaries
  wire   [   0:0] queue0$clk;
  wire   [  77:0] queue0$enq_msg;
  wire   [   0:0] queue0$enq_val;
  wire   [   0:0] queue0$reset;
  wire   [   0:0] queue0$deq_rdy;
  wire   [   0:0] queue0$enq_rdy;
  wire   [   0:0] queue0$full;
  wire   [  77:0] queue0$deq_msg;
  wire   [   0:0] queue0$deq_val;

  SingleElementBypassQueue_0x69a36ac73a4a8994 queue0
  (
    .clk     ( queue0$clk ),
    .enq_msg ( queue0$enq_msg ),
    .enq_val ( queue0$enq_val ),
    .reset   ( queue0$reset ),
    .deq_rdy ( queue0$deq_rdy ),
    .enq_rdy ( queue0$enq_rdy ),
    .full    ( queue0$full ),
    .deq_msg ( queue0$deq_msg ),
    .deq_val ( queue0$deq_val )
  );

  // signal connections
  assign deq_msg        = queue1$deq_msg;
  assign deq_val        = queue1$deq_val;
  assign enq_rdy        = queue0$enq_rdy;
  assign queue0$clk     = clk;
  assign queue0$deq_rdy = queue1$enq_rdy;
  assign queue0$enq_msg = enq_msg;
  assign queue0$enq_val = enq_val;
  assign queue0$reset   = reset;
  assign queue1$clk     = clk;
  assign queue1$deq_rdy = deq_rdy;
  assign queue1$enq_msg = queue0$deq_msg;
  assign queue1$enq_val = queue0$deq_val;
  assign queue1$reset   = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def full_empty():
  //       s.full.value  = s.queue0.full & s.queue1.full
  //       s.empty.value = (~s.queue0.full) & (~s.queue1.full)

  // logic for full_empty()
  always @ (*) begin
    full = (queue0$full&queue1$full);
    empty = (~queue0$full&~queue1$full);
  end


endmodule // TwoElementBypassQueue_0x69a36ac73a4a8994
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x69a36ac73a4a8994
//-----------------------------------------------------------------------------
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x69a36ac73a4a8994
(
  input  wire [   0:0] clk,
  output wire [  77:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  77:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   0:0] full,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$bypass_mux_sel;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$full;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk            ( ctrl$clk ),
    .enq_val        ( ctrl$enq_val ),
    .reset          ( ctrl$reset ),
    .deq_rdy        ( ctrl$deq_rdy ),
    .bypass_mux_sel ( ctrl$bypass_mux_sel ),
    .wen            ( ctrl$wen ),
    .deq_val        ( ctrl$deq_val ),
    .full           ( ctrl$full ),
    .enq_rdy        ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$bypass_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$reset;
  wire   [  77:0] dpath$enq_bits;
  wire   [  77:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x69a36ac73a4a8994 dpath
  (
    .wen            ( dpath$wen ),
    .bypass_mux_sel ( dpath$bypass_mux_sel ),
    .clk            ( dpath$clk ),
    .reset          ( dpath$reset ),
    .enq_bits       ( dpath$enq_bits ),
    .deq_bits       ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk             = clk;
  assign ctrl$deq_rdy         = deq_rdy;
  assign ctrl$enq_val         = enq_val;
  assign ctrl$reset           = reset;
  assign deq_msg              = dpath$deq_bits;
  assign deq_val              = ctrl$deq_val;
  assign dpath$bypass_mux_sel = ctrl$bypass_mux_sel;
  assign dpath$clk            = clk;
  assign dpath$enq_bits       = enq_msg;
  assign dpath$reset          = reset;
  assign dpath$wen            = ctrl$wen;
  assign enq_rdy              = ctrl$enq_rdy;
  assign full                 = ctrl$full;



endmodule // SingleElementBypassQueue_0x69a36ac73a4a8994
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x69a36ac73a4a8994
//-----------------------------------------------------------------------------
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x69a36ac73a4a8994
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  77:0] deq_bits,
  input  wire [  77:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  77:0] bypass_mux$in_$000;
  wire   [  77:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  77:0] bypass_mux$out;

  Mux_0x1cb1a0d012419b0c bypass_mux
  (
    .reset   ( bypass_mux$reset ),
    .in_$000 ( bypass_mux$in_$000 ),
    .in_$001 ( bypass_mux$in_$001 ),
    .clk     ( bypass_mux$clk ),
    .sel     ( bypass_mux$sel ),
    .out     ( bypass_mux$out )
  );

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  77:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  77:0] queue$out;

  RegEn_0xa9dde837ed7f81 queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign bypass_mux$clk     = clk;
  assign bypass_mux$in_$000 = queue$out;
  assign bypass_mux$in_$001 = enq_bits;
  assign bypass_mux$reset   = reset;
  assign bypass_mux$sel     = bypass_mux_sel;
  assign deq_bits           = bypass_mux$out;
  assign queue$clk          = clk;
  assign queue$en           = wen;
  assign queue$in_          = enq_bits;
  assign queue$reset        = reset;



endmodule // SingleElementBypassQueueDpath_0x69a36ac73a4a8994
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x1cb1a0d012419b0c
//-----------------------------------------------------------------------------
// dtype: 78
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x1cb1a0d012419b0c
(
  input  wire [   0:0] clk,
  input  wire [  77:0] in_$000,
  input  wire [  77:0] in_$001,
  output reg  [  77:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  77:0] in_[0:1];
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


endmodule // Mux_0x1cb1a0d012419b0c
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0xa9dde837ed7f81
//-----------------------------------------------------------------------------
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0xa9dde837ed7f81
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  77:0] in_,
  output reg  [  77:0] out,
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


endmodule // RegEn_0xa9dde837ed7f81
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x4ff2229f876f4e1c
//-----------------------------------------------------------------------------
// dtype: 38
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x4ff2229f876f4e1c
(
  input  wire [   0:0] clk,
  output wire [  37:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  37:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   0:0] full,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$bypass_mux_sel;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$full;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk            ( ctrl$clk ),
    .enq_val        ( ctrl$enq_val ),
    .reset          ( ctrl$reset ),
    .deq_rdy        ( ctrl$deq_rdy ),
    .bypass_mux_sel ( ctrl$bypass_mux_sel ),
    .wen            ( ctrl$wen ),
    .deq_val        ( ctrl$deq_val ),
    .full           ( ctrl$full ),
    .enq_rdy        ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$bypass_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$reset;
  wire   [  37:0] dpath$enq_bits;
  wire   [  37:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x4ff2229f876f4e1c dpath
  (
    .wen            ( dpath$wen ),
    .bypass_mux_sel ( dpath$bypass_mux_sel ),
    .clk            ( dpath$clk ),
    .reset          ( dpath$reset ),
    .enq_bits       ( dpath$enq_bits ),
    .deq_bits       ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk             = clk;
  assign ctrl$deq_rdy         = deq_rdy;
  assign ctrl$enq_val         = enq_val;
  assign ctrl$reset           = reset;
  assign deq_msg              = dpath$deq_bits;
  assign deq_val              = ctrl$deq_val;
  assign dpath$bypass_mux_sel = ctrl$bypass_mux_sel;
  assign dpath$clk            = clk;
  assign dpath$enq_bits       = enq_msg;
  assign dpath$reset          = reset;
  assign dpath$wen            = ctrl$wen;
  assign enq_rdy              = ctrl$enq_rdy;
  assign full                 = ctrl$full;



endmodule // SingleElementBypassQueue_0x4ff2229f876f4e1c
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x4ff2229f876f4e1c
//-----------------------------------------------------------------------------
// dtype: 38
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x4ff2229f876f4e1c
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  37:0] deq_bits,
  input  wire [  37:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  37:0] bypass_mux$in_$000;
  wire   [  37:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  37:0] bypass_mux$out;

  Mux_0x11fd6c662836f6bc bypass_mux
  (
    .reset   ( bypass_mux$reset ),
    .in_$000 ( bypass_mux$in_$000 ),
    .in_$001 ( bypass_mux$in_$001 ),
    .clk     ( bypass_mux$clk ),
    .sel     ( bypass_mux$sel ),
    .out     ( bypass_mux$out )
  );

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  37:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  37:0] queue$out;

  RegEn_0x577c1534e1827e09 queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign bypass_mux$clk     = clk;
  assign bypass_mux$in_$000 = queue$out;
  assign bypass_mux$in_$001 = enq_bits;
  assign bypass_mux$reset   = reset;
  assign bypass_mux$sel     = bypass_mux_sel;
  assign deq_bits           = bypass_mux$out;
  assign queue$clk          = clk;
  assign queue$en           = wen;
  assign queue$in_          = enq_bits;
  assign queue$reset        = reset;



endmodule // SingleElementBypassQueueDpath_0x4ff2229f876f4e1c
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x11fd6c662836f6bc
//-----------------------------------------------------------------------------
// dtype: 38
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x11fd6c662836f6bc
(
  input  wire [   0:0] clk,
  input  wire [  37:0] in_$000,
  input  wire [  37:0] in_$001,
  output reg  [  37:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  37:0] in_[0:1];
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


endmodule // Mux_0x11fd6c662836f6bc
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x577c1534e1827e09
//-----------------------------------------------------------------------------
// dtype: 38
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x577c1534e1827e09
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  37:0] in_,
  output reg  [  37:0] out,
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


endmodule // RegEn_0x577c1534e1827e09
`default_nettype wire

//-----------------------------------------------------------------------------
// ProcDpathPRTL_0x38dfe68c782cb555
//-----------------------------------------------------------------------------
// num_cores: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcDpathPRTL_0x38dfe68c782cb555
(
  input  wire [   3:0] alu_fn_X,
  output wire [   0:0] br_cond_eq_X,
  output wire [   0:0] br_cond_lt_X,
  output wire [   0:0] br_cond_ltu_X,
  input  wire [   0:0] clk,
  input  wire [  31:0] core_id,
  input  wire [   1:0] csrr_sel_D,
  input  wire [   2:0] dm_resp_sel_M,
  output wire [  31:0] dmemreq_msg_addr,
  output wire [  31:0] dmemreq_msg_data,
  input  wire [  31:0] dmemresp_msg_data,
  input  wire [   1:0] ex_result_sel_X,
  output reg  [  77:0] imemreq_msg,
  input  wire [  31:0] imemresp_msg_data,
  input  wire [   2:0] imm_type_D,
  output wire [  31:0] inst_D,
  output wire [  31:0] mdureq_msg_op_a,
  output wire [  31:0] mdureq_msg_op_b,
  input  wire [  31:0] mduresp_msg,
  input  wire [  31:0] mngr2proc_data,
  input  wire [   1:0] op1_byp_sel_D,
  input  wire [   0:0] op1_sel_D,
  input  wire [   1:0] op2_byp_sel_D,
  input  wire [   1:0] op2_sel_D,
  input  wire [   1:0] pc_sel_F,
  output wire [  31:0] proc2mngr_data,
  input  wire [   0:0] reg_en_D,
  input  wire [   0:0] reg_en_F,
  input  wire [   0:0] reg_en_M,
  input  wire [   0:0] reg_en_W,
  input  wire [   0:0] reg_en_X,
  input  wire [   0:0] reset,
  input  wire [   4:0] rf_waddr_W,
  input  wire [   0:0] rf_wen_W,
  output reg  [   0:0] stats_en,
  input  wire [   0:0] stats_en_wen_W,
  input  wire [   1:0] wb_result_sel_M,
  output wire [  31:0] xcelreq_msg_data,
  output wire [   4:0] xcelreq_msg_raddr,
  input  wire [  31:0] xcelresp_msg_data
);

  // wire declarations
  wire   [  31:0] jalr_target_X;
  wire   [  31:0] rf_rdata1_D;
  wire   [  31:0] rf_wdata_W;
  wire   [  31:0] byp_data_W;
  wire   [  31:0] byp_data_X;
  wire   [  31:0] pc_plus4_F;
  wire   [  31:0] br_target_X;
  wire   [  31:0] rf_rdata0_D;
  wire   [  31:0] pc_F;
  wire   [  31:0] byp_data_M;
  wire   [  31:0] jal_target_D;


  // register declarations
  reg    [  31:0] dmemresp_msg_data_lb_M;
  reg    [  31:0] dmemresp_msg_data_lbu_M;
  reg    [  31:0] dmemresp_msg_data_lh_M;
  reg    [  31:0] dmemresp_msg_data_lhu_M;
  reg    [  31:0] dmemresp_msg_data_lw_M;
  reg    [  15:0] dmemresp_msg_data_truncated16_M;
  reg    [   7:0] dmemresp_msg_data_truncated8_M;

  // dmem_write_data_reg_X temporaries
  wire   [   0:0] dmem_write_data_reg_X$reset;
  wire   [   0:0] dmem_write_data_reg_X$en;
  wire   [   0:0] dmem_write_data_reg_X$clk;
  wire   [  31:0] dmem_write_data_reg_X$in_;
  wire   [  31:0] dmem_write_data_reg_X$out;

  RegEnRst_0x3857337130dc0828 dmem_write_data_reg_X
  (
    .reset ( dmem_write_data_reg_X$reset ),
    .en    ( dmem_write_data_reg_X$en ),
    .clk   ( dmem_write_data_reg_X$clk ),
    .in_   ( dmem_write_data_reg_X$in_ ),
    .out   ( dmem_write_data_reg_X$out )
  );

  // wb_result_reg_W temporaries
  wire   [   0:0] wb_result_reg_W$reset;
  wire   [   0:0] wb_result_reg_W$en;
  wire   [   0:0] wb_result_reg_W$clk;
  wire   [  31:0] wb_result_reg_W$in_;
  wire   [  31:0] wb_result_reg_W$out;

  RegEnRst_0x3857337130dc0828 wb_result_reg_W
  (
    .reset ( wb_result_reg_W$reset ),
    .en    ( wb_result_reg_W$en ),
    .clk   ( wb_result_reg_W$clk ),
    .in_   ( wb_result_reg_W$in_ ),
    .out   ( wb_result_reg_W$out )
  );

  // op2_sel_mux_D temporaries
  wire   [   0:0] op2_sel_mux_D$reset;
  wire   [  31:0] op2_sel_mux_D$in_$000;
  wire   [  31:0] op2_sel_mux_D$in_$001;
  wire   [  31:0] op2_sel_mux_D$in_$002;
  wire   [   0:0] op2_sel_mux_D$clk;
  wire   [   1:0] op2_sel_mux_D$sel;
  wire   [  31:0] op2_sel_mux_D$out;

  Mux_0x32d1d735b6f2dcf9 op2_sel_mux_D
  (
    .reset   ( op2_sel_mux_D$reset ),
    .in_$000 ( op2_sel_mux_D$in_$000 ),
    .in_$001 ( op2_sel_mux_D$in_$001 ),
    .in_$002 ( op2_sel_mux_D$in_$002 ),
    .clk     ( op2_sel_mux_D$clk ),
    .sel     ( op2_sel_mux_D$sel ),
    .out     ( op2_sel_mux_D$out )
  );

  // pc_reg_X temporaries
  wire   [   0:0] pc_reg_X$reset;
  wire   [   0:0] pc_reg_X$en;
  wire   [   0:0] pc_reg_X$clk;
  wire   [  31:0] pc_reg_X$in_;
  wire   [  31:0] pc_reg_X$out;

  RegEnRst_0x3857337130dc0828 pc_reg_X
  (
    .reset ( pc_reg_X$reset ),
    .en    ( pc_reg_X$en ),
    .clk   ( pc_reg_X$clk ),
    .in_   ( pc_reg_X$in_ ),
    .out   ( pc_reg_X$out )
  );

  // csrr_sel_mux_D temporaries
  wire   [   0:0] csrr_sel_mux_D$reset;
  wire   [  31:0] csrr_sel_mux_D$in_$000;
  wire   [  31:0] csrr_sel_mux_D$in_$001;
  wire   [  31:0] csrr_sel_mux_D$in_$002;
  wire   [   0:0] csrr_sel_mux_D$clk;
  wire   [   1:0] csrr_sel_mux_D$sel;
  wire   [  31:0] csrr_sel_mux_D$out;

  Mux_0x32d1d735b6f2dcf9 csrr_sel_mux_D
  (
    .reset   ( csrr_sel_mux_D$reset ),
    .in_$000 ( csrr_sel_mux_D$in_$000 ),
    .in_$001 ( csrr_sel_mux_D$in_$001 ),
    .in_$002 ( csrr_sel_mux_D$in_$002 ),
    .clk     ( csrr_sel_mux_D$clk ),
    .sel     ( csrr_sel_mux_D$sel ),
    .out     ( csrr_sel_mux_D$out )
  );

  // pc_reg_D temporaries
  wire   [   0:0] pc_reg_D$reset;
  wire   [   0:0] pc_reg_D$en;
  wire   [   0:0] pc_reg_D$clk;
  wire   [  31:0] pc_reg_D$in_;
  wire   [  31:0] pc_reg_D$out;

  RegEnRst_0x3857337130dc0828 pc_reg_D
  (
    .reset ( pc_reg_D$reset ),
    .en    ( pc_reg_D$en ),
    .clk   ( pc_reg_D$clk ),
    .in_   ( pc_reg_D$in_ ),
    .out   ( pc_reg_D$out )
  );

  // pc_reg_F temporaries
  wire   [   0:0] pc_reg_F$reset;
  wire   [   0:0] pc_reg_F$en;
  wire   [   0:0] pc_reg_F$clk;
  wire   [  31:0] pc_reg_F$in_;
  wire   [  31:0] pc_reg_F$out;

  RegEnRst_0x6c5cfbd4c2d1e32c pc_reg_F
  (
    .reset ( pc_reg_F$reset ),
    .en    ( pc_reg_F$en ),
    .clk   ( pc_reg_F$clk ),
    .in_   ( pc_reg_F$in_ ),
    .out   ( pc_reg_F$out )
  );

  // op1_reg_X temporaries
  wire   [   0:0] op1_reg_X$reset;
  wire   [   0:0] op1_reg_X$en;
  wire   [   0:0] op1_reg_X$clk;
  wire   [  31:0] op1_reg_X$in_;
  wire   [  31:0] op1_reg_X$out;

  RegEnRst_0x3857337130dc0828 op1_reg_X
  (
    .reset ( op1_reg_X$reset ),
    .en    ( op1_reg_X$en ),
    .clk   ( op1_reg_X$clk ),
    .in_   ( op1_reg_X$in_ ),
    .out   ( op1_reg_X$out )
  );

  // alu_X temporaries
  wire   [   0:0] alu_X$clk;
  wire   [  31:0] alu_X$in0;
  wire   [  31:0] alu_X$in1;
  wire   [   3:0] alu_X$fn;
  wire   [   0:0] alu_X$reset;
  wire   [   0:0] alu_X$ops_lt;
  wire   [   0:0] alu_X$ops_ltu;
  wire   [  31:0] alu_X$out;
  wire   [   0:0] alu_X$ops_eq;

  AluPRTL_0x487c51659b588c2b alu_X
  (
    .clk     ( alu_X$clk ),
    .in0     ( alu_X$in0 ),
    .in1     ( alu_X$in1 ),
    .fn      ( alu_X$fn ),
    .reset   ( alu_X$reset ),
    .ops_lt  ( alu_X$ops_lt ),
    .ops_ltu ( alu_X$ops_ltu ),
    .out     ( alu_X$out ),
    .ops_eq  ( alu_X$ops_eq )
  );

  // op2_byp_mux_D temporaries
  wire   [   0:0] op2_byp_mux_D$reset;
  wire   [  31:0] op2_byp_mux_D$in_$000;
  wire   [  31:0] op2_byp_mux_D$in_$001;
  wire   [  31:0] op2_byp_mux_D$in_$002;
  wire   [  31:0] op2_byp_mux_D$in_$003;
  wire   [   0:0] op2_byp_mux_D$clk;
  wire   [   1:0] op2_byp_mux_D$sel;
  wire   [  31:0] op2_byp_mux_D$out;

  Mux_0x7be03e4007003adc op2_byp_mux_D
  (
    .reset   ( op2_byp_mux_D$reset ),
    .in_$000 ( op2_byp_mux_D$in_$000 ),
    .in_$001 ( op2_byp_mux_D$in_$001 ),
    .in_$002 ( op2_byp_mux_D$in_$002 ),
    .in_$003 ( op2_byp_mux_D$in_$003 ),
    .clk     ( op2_byp_mux_D$clk ),
    .sel     ( op2_byp_mux_D$sel ),
    .out     ( op2_byp_mux_D$out )
  );

  // ex_result_sel_mux_X temporaries
  wire   [   0:0] ex_result_sel_mux_X$reset;
  wire   [  31:0] ex_result_sel_mux_X$in_$000;
  wire   [  31:0] ex_result_sel_mux_X$in_$001;
  wire   [  31:0] ex_result_sel_mux_X$in_$002;
  wire   [   0:0] ex_result_sel_mux_X$clk;
  wire   [   1:0] ex_result_sel_mux_X$sel;
  wire   [  31:0] ex_result_sel_mux_X$out;

  Mux_0x32d1d735b6f2dcf9 ex_result_sel_mux_X
  (
    .reset   ( ex_result_sel_mux_X$reset ),
    .in_$000 ( ex_result_sel_mux_X$in_$000 ),
    .in_$001 ( ex_result_sel_mux_X$in_$001 ),
    .in_$002 ( ex_result_sel_mux_X$in_$002 ),
    .clk     ( ex_result_sel_mux_X$clk ),
    .sel     ( ex_result_sel_mux_X$sel ),
    .out     ( ex_result_sel_mux_X$out )
  );

  // op2_reg_X temporaries
  wire   [   0:0] op2_reg_X$reset;
  wire   [   0:0] op2_reg_X$en;
  wire   [   0:0] op2_reg_X$clk;
  wire   [  31:0] op2_reg_X$in_;
  wire   [  31:0] op2_reg_X$out;

  RegEnRst_0x3857337130dc0828 op2_reg_X
  (
    .reset ( op2_reg_X$reset ),
    .en    ( op2_reg_X$en ),
    .clk   ( op2_reg_X$clk ),
    .in_   ( op2_reg_X$in_ ),
    .out   ( op2_reg_X$out )
  );

  // stats_en_reg_W temporaries
  wire   [   0:0] stats_en_reg_W$reset;
  wire   [   0:0] stats_en_reg_W$en;
  wire   [   0:0] stats_en_reg_W$clk;
  wire   [  31:0] stats_en_reg_W$in_;
  wire   [  31:0] stats_en_reg_W$out;

  RegEnRst_0x3857337130dc0828 stats_en_reg_W
  (
    .reset ( stats_en_reg_W$reset ),
    .en    ( stats_en_reg_W$en ),
    .clk   ( stats_en_reg_W$clk ),
    .in_   ( stats_en_reg_W$in_ ),
    .out   ( stats_en_reg_W$out )
  );

  // rf temporaries
  wire   [   4:0] rf$rd_addr$000;
  wire   [   4:0] rf$rd_addr$001;
  wire   [  31:0] rf$wr_data;
  wire   [   0:0] rf$clk;
  wire   [   4:0] rf$wr_addr;
  wire   [   0:0] rf$wr_en;
  wire   [   0:0] rf$reset;
  wire   [  31:0] rf$rd_data$000;
  wire   [  31:0] rf$rd_data$001;

  RegisterFile_0x2abe1c1ba9590e64 rf
  (
    .rd_addr$000 ( rf$rd_addr$000 ),
    .rd_addr$001 ( rf$rd_addr$001 ),
    .wr_data     ( rf$wr_data ),
    .clk         ( rf$clk ),
    .wr_addr     ( rf$wr_addr ),
    .wr_en       ( rf$wr_en ),
    .reset       ( rf$reset ),
    .rd_data$000 ( rf$rd_data$000 ),
    .rd_data$001 ( rf$rd_data$001 )
  );

  // pc_sel_mux_F temporaries
  wire   [   0:0] pc_sel_mux_F$reset;
  wire   [  31:0] pc_sel_mux_F$in_$000;
  wire   [  31:0] pc_sel_mux_F$in_$001;
  wire   [  31:0] pc_sel_mux_F$in_$002;
  wire   [  31:0] pc_sel_mux_F$in_$003;
  wire   [   0:0] pc_sel_mux_F$clk;
  wire   [   1:0] pc_sel_mux_F$sel;
  wire   [  31:0] pc_sel_mux_F$out;

  Mux_0x7be03e4007003adc pc_sel_mux_F
  (
    .reset   ( pc_sel_mux_F$reset ),
    .in_$000 ( pc_sel_mux_F$in_$000 ),
    .in_$001 ( pc_sel_mux_F$in_$001 ),
    .in_$002 ( pc_sel_mux_F$in_$002 ),
    .in_$003 ( pc_sel_mux_F$in_$003 ),
    .clk     ( pc_sel_mux_F$clk ),
    .sel     ( pc_sel_mux_F$sel ),
    .out     ( pc_sel_mux_F$out )
  );

  // wb_result_sel_mux_M temporaries
  wire   [   0:0] wb_result_sel_mux_M$reset;
  wire   [  31:0] wb_result_sel_mux_M$in_$000;
  wire   [  31:0] wb_result_sel_mux_M$in_$001;
  wire   [  31:0] wb_result_sel_mux_M$in_$002;
  wire   [   0:0] wb_result_sel_mux_M$clk;
  wire   [   1:0] wb_result_sel_mux_M$sel;
  wire   [  31:0] wb_result_sel_mux_M$out;

  Mux_0x32d1d735b6f2dcf9 wb_result_sel_mux_M
  (
    .reset   ( wb_result_sel_mux_M$reset ),
    .in_$000 ( wb_result_sel_mux_M$in_$000 ),
    .in_$001 ( wb_result_sel_mux_M$in_$001 ),
    .in_$002 ( wb_result_sel_mux_M$in_$002 ),
    .clk     ( wb_result_sel_mux_M$clk ),
    .sel     ( wb_result_sel_mux_M$sel ),
    .out     ( wb_result_sel_mux_M$out )
  );

  // pc_incr_X temporaries
  wire   [   0:0] pc_incr_X$reset;
  wire   [  31:0] pc_incr_X$in_;
  wire   [   0:0] pc_incr_X$clk;
  wire   [  31:0] pc_incr_X$out;

  Incrementer_0x17b02585ea4ef9aa pc_incr_X
  (
    .reset ( pc_incr_X$reset ),
    .in_   ( pc_incr_X$in_ ),
    .clk   ( pc_incr_X$clk ),
    .out   ( pc_incr_X$out )
  );

  // op1_byp_mux_D temporaries
  wire   [   0:0] op1_byp_mux_D$reset;
  wire   [  31:0] op1_byp_mux_D$in_$000;
  wire   [  31:0] op1_byp_mux_D$in_$001;
  wire   [  31:0] op1_byp_mux_D$in_$002;
  wire   [  31:0] op1_byp_mux_D$in_$003;
  wire   [   0:0] op1_byp_mux_D$clk;
  wire   [   1:0] op1_byp_mux_D$sel;
  wire   [  31:0] op1_byp_mux_D$out;

  Mux_0x7be03e4007003adc op1_byp_mux_D
  (
    .reset   ( op1_byp_mux_D$reset ),
    .in_$000 ( op1_byp_mux_D$in_$000 ),
    .in_$001 ( op1_byp_mux_D$in_$001 ),
    .in_$002 ( op1_byp_mux_D$in_$002 ),
    .in_$003 ( op1_byp_mux_D$in_$003 ),
    .clk     ( op1_byp_mux_D$clk ),
    .sel     ( op1_byp_mux_D$sel ),
    .out     ( op1_byp_mux_D$out )
  );

  // pc_incr_F temporaries
  wire   [   0:0] pc_incr_F$reset;
  wire   [  31:0] pc_incr_F$in_;
  wire   [   0:0] pc_incr_F$clk;
  wire   [  31:0] pc_incr_F$out;

  Incrementer_0x17b02585ea4ef9aa pc_incr_F
  (
    .reset ( pc_incr_F$reset ),
    .in_   ( pc_incr_F$in_ ),
    .clk   ( pc_incr_F$clk ),
    .out   ( pc_incr_F$out )
  );

  // pc_plus_imm_D temporaries
  wire   [   0:0] pc_plus_imm_D$clk;
  wire   [  31:0] pc_plus_imm_D$in0;
  wire   [  31:0] pc_plus_imm_D$in1;
  wire   [   0:0] pc_plus_imm_D$reset;
  wire   [   0:0] pc_plus_imm_D$cin;
  wire   [   0:0] pc_plus_imm_D$cout;
  wire   [  31:0] pc_plus_imm_D$out;

  Adder_0x20454677a5a72bab pc_plus_imm_D
  (
    .clk   ( pc_plus_imm_D$clk ),
    .in0   ( pc_plus_imm_D$in0 ),
    .in1   ( pc_plus_imm_D$in1 ),
    .reset ( pc_plus_imm_D$reset ),
    .cin   ( pc_plus_imm_D$cin ),
    .cout  ( pc_plus_imm_D$cout ),
    .out   ( pc_plus_imm_D$out )
  );

  // imm_gen_D temporaries
  wire   [   2:0] imm_gen_D$imm_type;
  wire   [   0:0] imm_gen_D$clk;
  wire   [  31:0] imm_gen_D$inst;
  wire   [   0:0] imm_gen_D$reset;
  wire   [  31:0] imm_gen_D$imm;

  ImmGenPRTL_0x487c51659b588c2b imm_gen_D
  (
    .imm_type ( imm_gen_D$imm_type ),
    .clk      ( imm_gen_D$clk ),
    .inst     ( imm_gen_D$inst ),
    .reset    ( imm_gen_D$reset ),
    .imm      ( imm_gen_D$imm )
  );

  // dmemresp_mux_M temporaries
  wire   [   0:0] dmemresp_mux_M$reset;
  wire   [  31:0] dmemresp_mux_M$in_$000;
  wire   [  31:0] dmemresp_mux_M$in_$001;
  wire   [  31:0] dmemresp_mux_M$in_$002;
  wire   [  31:0] dmemresp_mux_M$in_$003;
  wire   [  31:0] dmemresp_mux_M$in_$004;
  wire   [   0:0] dmemresp_mux_M$clk;
  wire   [   2:0] dmemresp_mux_M$sel;
  wire   [  31:0] dmemresp_mux_M$out;

  Mux_0x683fd9fa42038363 dmemresp_mux_M
  (
    .reset   ( dmemresp_mux_M$reset ),
    .in_$000 ( dmemresp_mux_M$in_$000 ),
    .in_$001 ( dmemresp_mux_M$in_$001 ),
    .in_$002 ( dmemresp_mux_M$in_$002 ),
    .in_$003 ( dmemresp_mux_M$in_$003 ),
    .in_$004 ( dmemresp_mux_M$in_$004 ),
    .clk     ( dmemresp_mux_M$clk ),
    .sel     ( dmemresp_mux_M$sel ),
    .out     ( dmemresp_mux_M$out )
  );

  // br_target_reg_X temporaries
  wire   [   0:0] br_target_reg_X$reset;
  wire   [   0:0] br_target_reg_X$en;
  wire   [   0:0] br_target_reg_X$clk;
  wire   [  31:0] br_target_reg_X$in_;
  wire   [  31:0] br_target_reg_X$out;

  RegEnRst_0x3857337130dc0828 br_target_reg_X
  (
    .reset ( br_target_reg_X$reset ),
    .en    ( br_target_reg_X$en ),
    .clk   ( br_target_reg_X$clk ),
    .in_   ( br_target_reg_X$in_ ),
    .out   ( br_target_reg_X$out )
  );

  // ex_result_reg_M temporaries
  wire   [   0:0] ex_result_reg_M$reset;
  wire   [   0:0] ex_result_reg_M$en;
  wire   [   0:0] ex_result_reg_M$clk;
  wire   [  31:0] ex_result_reg_M$in_;
  wire   [  31:0] ex_result_reg_M$out;

  RegEnRst_0x3857337130dc0828 ex_result_reg_M
  (
    .reset ( ex_result_reg_M$reset ),
    .en    ( ex_result_reg_M$en ),
    .clk   ( ex_result_reg_M$clk ),
    .in_   ( ex_result_reg_M$in_ ),
    .out   ( ex_result_reg_M$out )
  );

  // op1_sel_mux_D temporaries
  wire   [   0:0] op1_sel_mux_D$reset;
  wire   [  31:0] op1_sel_mux_D$in_$000;
  wire   [  31:0] op1_sel_mux_D$in_$001;
  wire   [   0:0] op1_sel_mux_D$clk;
  wire   [   0:0] op1_sel_mux_D$sel;
  wire   [  31:0] op1_sel_mux_D$out;

  Mux_0x7e8c65f0610ab9ca op1_sel_mux_D
  (
    .reset   ( op1_sel_mux_D$reset ),
    .in_$000 ( op1_sel_mux_D$in_$000 ),
    .in_$001 ( op1_sel_mux_D$in_$001 ),
    .clk     ( op1_sel_mux_D$clk ),
    .sel     ( op1_sel_mux_D$sel ),
    .out     ( op1_sel_mux_D$out )
  );

  // inst_D_reg temporaries
  wire   [   0:0] inst_D_reg$reset;
  wire   [   0:0] inst_D_reg$en;
  wire   [   0:0] inst_D_reg$clk;
  wire   [  31:0] inst_D_reg$in_;
  wire   [  31:0] inst_D_reg$out;

  RegEnRst_0x3857337130dc0828 inst_D_reg
  (
    .reset ( inst_D_reg$reset ),
    .en    ( inst_D_reg$en ),
    .clk   ( inst_D_reg$clk ),
    .in_   ( inst_D_reg$in_ ),
    .out   ( inst_D_reg$out )
  );

  // signal connections
  assign alu_X$clk                   = clk;
  assign alu_X$fn                    = alu_fn_X;
  assign alu_X$in0                   = op1_reg_X$out;
  assign alu_X$in1                   = op2_reg_X$out;
  assign alu_X$reset                 = reset;
  assign br_cond_eq_X                = alu_X$ops_eq;
  assign br_cond_lt_X                = alu_X$ops_lt;
  assign br_cond_ltu_X               = alu_X$ops_ltu;
  assign br_target_X                 = br_target_reg_X$out;
  assign br_target_reg_X$clk         = clk;
  assign br_target_reg_X$en          = reg_en_X;
  assign br_target_reg_X$in_         = pc_plus_imm_D$out;
  assign br_target_reg_X$reset       = reset;
  assign byp_data_M                  = wb_result_sel_mux_M$out;
  assign byp_data_W                  = wb_result_reg_W$out;
  assign byp_data_X                  = ex_result_sel_mux_X$out;
  assign csrr_sel_mux_D$clk          = clk;
  assign csrr_sel_mux_D$in_$000      = mngr2proc_data;
  assign csrr_sel_mux_D$in_$001      = 32'd1;
  assign csrr_sel_mux_D$in_$002      = core_id;
  assign csrr_sel_mux_D$reset        = reset;
  assign csrr_sel_mux_D$sel          = csrr_sel_D;
  assign dmem_write_data_reg_X$clk   = clk;
  assign dmem_write_data_reg_X$en    = reg_en_X;
  assign dmem_write_data_reg_X$in_   = op2_byp_mux_D$out;
  assign dmem_write_data_reg_X$reset = reset;
  assign dmemreq_msg_addr            = alu_X$out;
  assign dmemreq_msg_data            = dmem_write_data_reg_X$out;
  assign dmemresp_mux_M$clk          = clk;
  assign dmemresp_mux_M$in_$000      = dmemresp_msg_data_lb_M;
  assign dmemresp_mux_M$in_$001      = dmemresp_msg_data_lh_M;
  assign dmemresp_mux_M$in_$002      = dmemresp_msg_data_lw_M;
  assign dmemresp_mux_M$in_$003      = dmemresp_msg_data_lbu_M;
  assign dmemresp_mux_M$in_$004      = dmemresp_msg_data_lhu_M;
  assign dmemresp_mux_M$reset        = reset;
  assign dmemresp_mux_M$sel          = dm_resp_sel_M;
  assign ex_result_reg_M$clk         = clk;
  assign ex_result_reg_M$en          = reg_en_M;
  assign ex_result_reg_M$in_         = ex_result_sel_mux_X$out;
  assign ex_result_reg_M$reset       = reset;
  assign ex_result_sel_mux_X$clk     = clk;
  assign ex_result_sel_mux_X$in_$000 = alu_X$out;
  assign ex_result_sel_mux_X$in_$001 = mduresp_msg;
  assign ex_result_sel_mux_X$in_$002 = pc_incr_X$out;
  assign ex_result_sel_mux_X$reset   = reset;
  assign ex_result_sel_mux_X$sel     = ex_result_sel_X;
  assign imm_gen_D$clk               = clk;
  assign imm_gen_D$imm_type          = imm_type_D;
  assign imm_gen_D$inst              = inst_D;
  assign imm_gen_D$reset             = reset;
  assign inst_D                      = inst_D_reg$out;
  assign inst_D_reg$clk              = clk;
  assign inst_D_reg$en               = reg_en_D;
  assign inst_D_reg$in_              = imemresp_msg_data;
  assign inst_D_reg$reset            = reset;
  assign jal_target_D                = pc_plus_imm_D$out;
  assign jalr_target_X               = alu_X$out;
  assign mdureq_msg_op_a             = op1_sel_mux_D$out;
  assign mdureq_msg_op_b             = op2_sel_mux_D$out;
  assign op1_byp_mux_D$clk           = clk;
  assign op1_byp_mux_D$in_$000       = rf_rdata0_D;
  assign op1_byp_mux_D$in_$001       = byp_data_X;
  assign op1_byp_mux_D$in_$002       = byp_data_M;
  assign op1_byp_mux_D$in_$003       = byp_data_W;
  assign op1_byp_mux_D$reset         = reset;
  assign op1_byp_mux_D$sel           = op1_byp_sel_D;
  assign op1_reg_X$clk               = clk;
  assign op1_reg_X$en                = reg_en_X;
  assign op1_reg_X$in_               = op1_sel_mux_D$out;
  assign op1_reg_X$reset             = reset;
  assign op1_sel_mux_D$clk           = clk;
  assign op1_sel_mux_D$in_$000       = op1_byp_mux_D$out;
  assign op1_sel_mux_D$in_$001       = pc_reg_D$out;
  assign op1_sel_mux_D$reset         = reset;
  assign op1_sel_mux_D$sel           = op1_sel_D;
  assign op2_byp_mux_D$clk           = clk;
  assign op2_byp_mux_D$in_$000       = rf_rdata1_D;
  assign op2_byp_mux_D$in_$001       = byp_data_X;
  assign op2_byp_mux_D$in_$002       = byp_data_M;
  assign op2_byp_mux_D$in_$003       = byp_data_W;
  assign op2_byp_mux_D$reset         = reset;
  assign op2_byp_mux_D$sel           = op2_byp_sel_D;
  assign op2_reg_X$clk               = clk;
  assign op2_reg_X$en                = reg_en_X;
  assign op2_reg_X$in_               = op2_sel_mux_D$out;
  assign op2_reg_X$reset             = reset;
  assign op2_sel_mux_D$clk           = clk;
  assign op2_sel_mux_D$in_$000       = op2_byp_mux_D$out;
  assign op2_sel_mux_D$in_$001       = imm_gen_D$imm;
  assign op2_sel_mux_D$in_$002       = csrr_sel_mux_D$out;
  assign op2_sel_mux_D$reset         = reset;
  assign op2_sel_mux_D$sel           = op2_sel_D;
  assign pc_F                        = pc_reg_F$out;
  assign pc_incr_F$clk               = clk;
  assign pc_incr_F$in_               = pc_F;
  assign pc_incr_F$reset             = reset;
  assign pc_incr_X$clk               = clk;
  assign pc_incr_X$in_               = pc_reg_X$out;
  assign pc_incr_X$reset             = reset;
  assign pc_plus4_F                  = pc_incr_F$out;
  assign pc_plus_imm_D$clk           = clk;
  assign pc_plus_imm_D$in0           = pc_reg_D$out;
  assign pc_plus_imm_D$in1           = imm_gen_D$imm;
  assign pc_plus_imm_D$reset         = reset;
  assign pc_reg_D$clk                = clk;
  assign pc_reg_D$en                 = reg_en_D;
  assign pc_reg_D$in_                = pc_F;
  assign pc_reg_D$reset              = reset;
  assign pc_reg_F$clk                = clk;
  assign pc_reg_F$en                 = reg_en_F;
  assign pc_reg_F$in_                = pc_sel_mux_F$out;
  assign pc_reg_F$reset              = reset;
  assign pc_reg_X$clk                = clk;
  assign pc_reg_X$en                 = reg_en_X;
  assign pc_reg_X$in_                = pc_reg_D$out;
  assign pc_reg_X$reset              = reset;
  assign pc_sel_mux_F$clk            = clk;
  assign pc_sel_mux_F$in_$000        = pc_plus4_F;
  assign pc_sel_mux_F$in_$001        = br_target_X;
  assign pc_sel_mux_F$in_$002        = jal_target_D;
  assign pc_sel_mux_F$in_$003        = jalr_target_X;
  assign pc_sel_mux_F$reset          = reset;
  assign pc_sel_mux_F$sel            = pc_sel_F;
  assign proc2mngr_data              = wb_result_reg_W$out;
  assign rf$clk                      = clk;
  assign rf$rd_addr$000              = inst_D[19:15];
  assign rf$rd_addr$001              = inst_D[24:20];
  assign rf$reset                    = reset;
  assign rf$wr_addr                  = rf_waddr_W;
  assign rf$wr_data                  = rf_wdata_W;
  assign rf$wr_en                    = rf_wen_W;
  assign rf_rdata0_D                 = rf$rd_data$000;
  assign rf_rdata1_D                 = rf$rd_data$001;
  assign rf_wdata_W                  = wb_result_reg_W$out;
  assign stats_en_reg_W$clk          = clk;
  assign stats_en_reg_W$en           = stats_en_wen_W;
  assign stats_en_reg_W$in_          = wb_result_reg_W$out;
  assign stats_en_reg_W$reset        = reset;
  assign wb_result_reg_W$clk         = clk;
  assign wb_result_reg_W$en          = reg_en_W;
  assign wb_result_reg_W$in_         = wb_result_sel_mux_M$out;
  assign wb_result_reg_W$reset       = reset;
  assign wb_result_sel_mux_M$clk     = clk;
  assign wb_result_sel_mux_M$in_$000 = ex_result_reg_M$out;
  assign wb_result_sel_mux_M$in_$001 = dmemresp_mux_M$out;
  assign wb_result_sel_mux_M$in_$002 = xcelresp_msg_data;
  assign wb_result_sel_mux_M$reset   = reset;
  assign wb_result_sel_mux_M$sel     = wb_result_sel_M;
  assign xcelreq_msg_data            = op1_reg_X$out;
  assign xcelreq_msg_raddr           = op2_reg_X$out[4:0];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def imem_req_F():
  //       s.imemreq_msg.addr.value  = s.pc_sel_mux_F.out

  // logic for imem_req_F()
  always @ (*) begin
    imemreq_msg[(66)-1:34] = pc_sel_mux_F$out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def dmemresp_logic_M():
  //       s.dmemresp_msg_data_truncated8_M.value  = s.dmemresp_msg_data[0:8]
  //       s.dmemresp_msg_data_truncated16_M.value = s.dmemresp_msg_data[0:16]
  //
  //       s.dmemresp_msg_data_lb_M.value  = sext( s.dmemresp_msg_data_truncated8_M,  32 )
  //       s.dmemresp_msg_data_lh_M.value  = sext( s.dmemresp_msg_data_truncated16_M, 32 )
  //       s.dmemresp_msg_data_lw_M.value  = s.dmemresp_msg_data
  //       s.dmemresp_msg_data_lbu_M.value = zext( s.dmemresp_msg_data_truncated8_M,  32 )
  //       s.dmemresp_msg_data_lhu_M.value = zext( s.dmemresp_msg_data_truncated16_M, 32 )

  // logic for dmemresp_logic_M()
  always @ (*) begin
    dmemresp_msg_data_truncated8_M = dmemresp_msg_data[(8)-1:0];
    dmemresp_msg_data_truncated16_M = dmemresp_msg_data[(16)-1:0];
    dmemresp_msg_data_lb_M = { { 32-8 { dmemresp_msg_data_truncated8_M[7] } }, dmemresp_msg_data_truncated8_M[7:0] };
    dmemresp_msg_data_lh_M = { { 32-16 { dmemresp_msg_data_truncated16_M[15] } }, dmemresp_msg_data_truncated16_M[15:0] };
    dmemresp_msg_data_lw_M = dmemresp_msg_data;
    dmemresp_msg_data_lbu_M = { { 32-8 { 1'b0 } }, dmemresp_msg_data_truncated8_M[7:0] };
    dmemresp_msg_data_lhu_M = { { 32-16 { 1'b0 } }, dmemresp_msg_data_truncated16_M[15:0] };
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def stats_en_logic_W():
  //       s.stats_en.value = reduce_or( s.stats_en_reg_W.out ) # reduction with bitwise OR

  // logic for stats_en_logic_W()
  always @ (*) begin
    stats_en = (|stats_en_reg_W$out);
  end


endmodule // ProcDpathPRTL_0x38dfe68c782cb555
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x32d1d735b6f2dcf9
//-----------------------------------------------------------------------------
// nports: 3
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x32d1d735b6f2dcf9
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  input  wire [  31:0] in_$001,
  input  wire [  31:0] in_$002,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] sel
);

  // localparam declarations
  localparam nports = 3;


  // array declarations
  wire   [  31:0] in_[0:2];
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


endmodule // Mux_0x32d1d735b6f2dcf9
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x6c5cfbd4c2d1e32c
//-----------------------------------------------------------------------------
// reset_value: 508
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x6c5cfbd4c2d1e32c
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam reset_value = 508;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //       if s.reset:
  //         s.out.next = reset_value
  //       elif s.en:
  //         s.out.next = s.in_

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (reset) begin
      out <= reset_value;
    end
    else begin
      if (en) begin
        out <= in_;
      end
      else begin
      end
    end
  end


endmodule // RegEnRst_0x6c5cfbd4c2d1e32c
`default_nettype wire

//-----------------------------------------------------------------------------
// AluPRTL_0x487c51659b588c2b
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module AluPRTL_0x487c51659b588c2b
(
  input  wire [   0:0] clk,
  input  wire [   3:0] fn,
  input  wire [  31:0] in0,
  input  wire [  31:0] in1,
  output reg  [   0:0] ops_eq,
  output reg  [   0:0] ops_lt,
  output reg  [   0:0] ops_ltu,
  output reg  [  31:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  32:0] tmp_a;
  reg    [  63:0] tmp_b;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       s.tmp_a.value = 0
  //       s.tmp_b.value = 0
  //
  //       if   s.fn ==  0: s.out.value = s.in0 + s.in1       # ADD
  //       elif s.fn == 11: s.out.value = s.in0               # CP OP0
  //       elif s.fn == 12: s.out.value = s.in1               # CP OP1
  //
  //       #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //       # Add more ALU functions
  //       #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
  //
  //       elif s.fn ==  1: s.out.value = s.in0 - s.in1       # SUB
  //       elif s.fn ==  2: s.out.value = s.in0 << s.in1[0:5] # SLL
  //       elif s.fn ==  3: s.out.value = s.in0 | s.in1       # OR
  //
  //       elif s.fn ==  4:                                   # SLT
  //         s.tmp_a.value = sext( s.in0, 33 ) - sext( s.in1, 33 )
  //         s.out.value   = s.tmp_a[32]
  //
  //       elif s.fn ==  5: s.out.value = s.in0 < s.in1       # SLTU
  //       elif s.fn ==  6: s.out.value = s.in0 & s.in1       # AND
  //       elif s.fn ==  7: s.out.value = s.in0 ^ s.in1       # XOR
  //       elif s.fn ==  8: s.out.value = ~( s.in0 | s.in1 )  # NOR
  //       elif s.fn ==  9: s.out.value = s.in0 >> (s.in1[0:5]) # SRL
  //
  //       elif s.fn == 10:                                   # SRA
  //         s.tmp_b.value = sext( s.in0, 64 ) >> s.in1[0:5]
  //         s.out.value   = s.tmp_b[0:32]
  //
  //       elif s.fn == 13:                                   # ADDZ for clearing LSB
  //         s.tmp_b.value = s.in0 + s.in1
  //         s.out[0].value = 0
  //         s.out[1:32].value = s.tmp_b[1:32]
  //         
  //
  //       #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
  //
  //       else:            s.out.value = 0                   # Unknown
  //
  //       s.ops_eq.value = ( s.in0 == s.in1 )
  //
  //       #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //       # Add more ALU functions
  //       # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
  //
  //       s.ops_lt.value  = s.tmp_a[32]
  //       s.ops_ltu.value = ( s.in0 < s.in1 )

  // logic for comb_logic()
  always @ (*) begin
    tmp_a = 0;
    tmp_b = 0;
    if ((fn == 0)) begin
      out = (in0+in1);
    end
    else begin
      if ((fn == 11)) begin
        out = in0;
      end
      else begin
        if ((fn == 12)) begin
          out = in1;
        end
        else begin
          if ((fn == 1)) begin
            out = (in0-in1);
          end
          else begin
            if ((fn == 2)) begin
              out = (in0<<in1[(5)-1:0]);
            end
            else begin
              if ((fn == 3)) begin
                out = (in0|in1);
              end
              else begin
                if ((fn == 4)) begin
                  tmp_a = ({ { 33-32 { in0[31] } }, in0[31:0] }-{ { 33-32 { in1[31] } }, in1[31:0] });
                  out = tmp_a[32];
                end
                else begin
                  if ((fn == 5)) begin
                    out = (in0 < in1);
                  end
                  else begin
                    if ((fn == 6)) begin
                      out = (in0&in1);
                    end
                    else begin
                      if ((fn == 7)) begin
                        out = (in0^in1);
                      end
                      else begin
                        if ((fn == 8)) begin
                          out = ~(in0|in1);
                        end
                        else begin
                          if ((fn == 9)) begin
                            out = (in0>>in1[(5)-1:0]);
                          end
                          else begin
                            if ((fn == 10)) begin
                              tmp_b = ({ { 64-32 { in0[31] } }, in0[31:0] }>>in1[(5)-1:0]);
                              out = tmp_b[(32)-1:0];
                            end
                            else begin
                              if ((fn == 13)) begin
                                tmp_b = (in0+in1);
                                out[0] = 0;
                                out[(32)-1:1] = tmp_b[(32)-1:1];
                              end
                              else begin
                                out = 0;
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    ops_eq = (in0 == in1);
    ops_lt = tmp_a[32];
    ops_ltu = (in0 < in1);
  end


endmodule // AluPRTL_0x487c51659b588c2b
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x7be03e4007003adc
//-----------------------------------------------------------------------------
// nports: 4
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x7be03e4007003adc
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  input  wire [  31:0] in_$001,
  input  wire [  31:0] in_$002,
  input  wire [  31:0] in_$003,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] sel
);

  // localparam declarations
  localparam nports = 4;


  // array declarations
  wire   [  31:0] in_[0:3];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;

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


endmodule // Mux_0x7be03e4007003adc
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x2abe1c1ba9590e64
//-----------------------------------------------------------------------------
// const_zero: True
// dtype: 32
// nregs: 32
// rd_ports: 2
// wr_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x2abe1c1ba9590e64
(
  input  wire [   0:0] clk,
  input  wire [   4:0] rd_addr$000,
  input  wire [   4:0] rd_addr$001,
  output wire [  31:0] rd_data$000,
  output wire [  31:0] rd_data$001,
  input  wire [   0:0] reset,
  input  wire [   4:0] wr_addr,
  input  wire [  31:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  31:0] regs$000;
  wire   [  31:0] regs$001;
  wire   [  31:0] regs$002;
  wire   [  31:0] regs$003;
  wire   [  31:0] regs$004;
  wire   [  31:0] regs$005;
  wire   [  31:0] regs$006;
  wire   [  31:0] regs$007;
  wire   [  31:0] regs$008;
  wire   [  31:0] regs$009;
  wire   [  31:0] regs$010;
  wire   [  31:0] regs$011;
  wire   [  31:0] regs$012;
  wire   [  31:0] regs$013;
  wire   [  31:0] regs$014;
  wire   [  31:0] regs$015;
  wire   [  31:0] regs$016;
  wire   [  31:0] regs$017;
  wire   [  31:0] regs$018;
  wire   [  31:0] regs$019;
  wire   [  31:0] regs$020;
  wire   [  31:0] regs$021;
  wire   [  31:0] regs$022;
  wire   [  31:0] regs$023;
  wire   [  31:0] regs$024;
  wire   [  31:0] regs$025;
  wire   [  31:0] regs$026;
  wire   [  31:0] regs$027;
  wire   [  31:0] regs$028;
  wire   [  31:0] regs$029;
  wire   [  31:0] regs$030;
  wire   [  31:0] regs$031;


  // localparam declarations
  localparam nregs = 32;
  localparam rd_ports = 2;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   4:0] rd_addr[0:1];
  assign rd_addr[  0] = rd_addr$000;
  assign rd_addr[  1] = rd_addr$001;
  reg    [  31:0] rd_data[0:1];
  assign rd_data$000 = rd_data[  0];
  assign rd_data$001 = rd_data[  1];
  reg    [  31:0] regs[0:31];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];
  assign regs$002 = regs[  2];
  assign regs$003 = regs[  3];
  assign regs$004 = regs[  4];
  assign regs$005 = regs[  5];
  assign regs$006 = regs[  6];
  assign regs$007 = regs[  7];
  assign regs$008 = regs[  8];
  assign regs$009 = regs[  9];
  assign regs$010 = regs[ 10];
  assign regs$011 = regs[ 11];
  assign regs$012 = regs[ 12];
  assign regs$013 = regs[ 13];
  assign regs$014 = regs[ 14];
  assign regs$015 = regs[ 15];
  assign regs$016 = regs[ 16];
  assign regs$017 = regs[ 17];
  assign regs$018 = regs[ 18];
  assign regs$019 = regs[ 19];
  assign regs$020 = regs[ 20];
  assign regs$021 = regs[ 21];
  assign regs$022 = regs[ 22];
  assign regs$023 = regs[ 23];
  assign regs$024 = regs[ 24];
  assign regs$025 = regs[ 25];
  assign regs$026 = regs[ 26];
  assign regs$027 = regs[ 27];
  assign regs$028 = regs[ 28];
  assign regs$029 = regs[ 29];
  assign regs$030 = regs[ 30];
  assign regs$031 = regs[ 31];

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic_const_zero():
  //         if s.wr_en and s.wr_addr != 0:
  //           s.regs[ s.wr_addr ].next = s.wr_data

  // logic for seq_logic_const_zero()
  always @ (posedge clk) begin
    if ((wr_en&&(wr_addr != 0))) begin
      regs[wr_addr] <= wr_data;
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //         for i in range( rd_ports ):
  //           assert s.rd_addr[i] < nregs
  //           if s.rd_addr[i] == 0:
  //             s.rd_data[i].value = 0
  //           else:
  //             s.rd_data[i].value = s.regs[ s.rd_addr[i] ]

  // logic for comb_logic()
  always @ (*) begin
    for (i=0; i < rd_ports; i=i+1)
    begin
      if ((rd_addr[i] == 0)) begin
        rd_data[i] = 0;
      end
      else begin
        rd_data[i] = regs[rd_addr[i]];
      end
    end
  end


endmodule // RegisterFile_0x2abe1c1ba9590e64
`default_nettype wire

//-----------------------------------------------------------------------------
// Incrementer_0x17b02585ea4ef9aa
//-----------------------------------------------------------------------------
// nbits: 32
// increment_amount: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Incrementer_0x17b02585ea4ef9aa
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam increment_amount = 4;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       s.out.value = s.in_ + increment_amount

  // logic for comb_logic()
  always @ (*) begin
    out = (in_+increment_amount);
  end


endmodule // Incrementer_0x17b02585ea4ef9aa
`default_nettype wire

//-----------------------------------------------------------------------------
// Adder_0x20454677a5a72bab
//-----------------------------------------------------------------------------
// nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Adder_0x20454677a5a72bab
(
  input  wire [   0:0] cin,
  input  wire [   0:0] clk,
  output wire [   0:0] cout,
  input  wire [  31:0] in0,
  input  wire [  31:0] in1,
  output wire [  31:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  32:0] t0__0;
  reg    [  32:0] t1__0;
  reg    [  32:0] temp;

  // localparam declarations
  localparam twidth = 33;

  // signal connections
  assign cout = temp[32];
  assign out  = temp[31:0];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       # Zero extend the inputs by one bit so we can generate an extra
  //       # carry out bit
  //
  //       t0 = zext( s.in0, twidth )
  //       t1 = zext( s.in1, twidth )
  //
  //       s.temp.value = t0 + t1 + s.cin

  // logic for comb_logic()
  always @ (*) begin
    t0__0 = { { twidth-32 { 1'b0 } }, in0[31:0] };
    t1__0 = { { twidth-32 { 1'b0 } }, in1[31:0] };
    temp = ((t0__0+t1__0)+cin);
  end


endmodule // Adder_0x20454677a5a72bab
`default_nettype wire

//-----------------------------------------------------------------------------
// ImmGenPRTL_0x487c51659b588c2b
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ImmGenPRTL_0x487c51659b588c2b
(
  input  wire [   0:0] clk,
  output reg  [  31:0] imm,
  input  wire [   2:0] imm_type,
  input  wire [  31:0] inst,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] tmp1;
  reg    [  11:0] tmp12;
  reg    [   6:0] tmp7;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //       # Always sext!
  //
  //       if   s.imm_type == 0: # I-type
  //
  //         # Shunning: Nasty but this is for translation to work. I did
  //         # create a PR in the past to handle this.
  //         # See https://github.com/cornell-brg/pymtl/pull/158
  //
  //         s.tmp12.value = s.inst[ I_IMM ]
  //
  //         s.imm.value = concat( sext( s.tmp12, 32 ) )
  //
  //       elif s.imm_type == 2: # B-type
  //
  //         s.tmp1.value = s.inst[ B_IMM3 ]
  //
  //         s.imm.value = concat( sext( s.tmp1, 20 ),
  //                                     s.inst[ B_IMM2 ],
  //                                     s.inst[ B_IMM1 ],
  //                                     s.inst[ B_IMM0 ],
  //                                     Bits( 1, 0 ) )
  //
  //       #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //       # Add more immediate types
  //       #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
  //
  //       elif s.imm_type == 1: # S-type
  //
  //         s.tmp7.value = s.inst[ S_IMM1 ]
  //
  //         s.imm.value = concat( sext( s.tmp7, 27 ),
  //                                     s.inst[ S_IMM0 ] )
  //
  //       elif s.imm_type == 3: # U-type
  //
  //         s.imm.value = concat(       s.inst[ U_IMM ],
  //                                     Bits( 12, 0 ) )
  //
  //       elif s.imm_type == 4: # J-type
  //
  //         s.tmp1.value = s.inst[ J_IMM3 ]
  //
  //         s.imm.value = concat( sext( s.tmp1, 12 ),
  //                                     s.inst[ J_IMM2 ],
  //                                     s.inst[ J_IMM1 ],
  //                                     s.inst[ J_IMM0 ],
  //                                     Bits( 1, 0 ) )
  //
  //       #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
  //
  //       else:
  //         s.imm.value = 0

  // logic for comb_logic()
  always @ (*) begin
    if ((imm_type == 0)) begin
      tmp12 = inst[(32)-1:20];
      imm = { { { 32-12 { tmp12[11] } }, tmp12[11:0] } };
    end
    else begin
      if ((imm_type == 2)) begin
        tmp1 = inst[(32)-1:31];
        imm = { { { 20-1 { tmp1[0] } }, tmp1[0:0] },inst[(8)-1:7],inst[(31)-1:25],inst[(12)-1:8],1'd0 };
      end
      else begin
        if ((imm_type == 1)) begin
          tmp7 = inst[(32)-1:25];
          imm = { { { 27-7 { tmp7[6] } }, tmp7[6:0] },inst[(12)-1:7] };
        end
        else begin
          if ((imm_type == 3)) begin
            imm = { inst[(32)-1:12],12'd0 };
          end
          else begin
            if ((imm_type == 4)) begin
              tmp1 = inst[(32)-1:31];
              imm = { { { 12-1 { tmp1[0] } }, tmp1[0:0] },inst[(20)-1:12],inst[(21)-1:20],inst[(31)-1:21],1'd0 };
            end
            else begin
              imm = 0;
            end
          end
        end
      end
    end
  end


endmodule // ImmGenPRTL_0x487c51659b588c2b
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x683fd9fa42038363
//-----------------------------------------------------------------------------
// nports: 5
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x683fd9fa42038363
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  input  wire [  31:0] in_$001,
  input  wire [  31:0] in_$002,
  input  wire [  31:0] in_$003,
  input  wire [  31:0] in_$004,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   2:0] sel
);

  // localparam declarations
  localparam nports = 5;


  // array declarations
  wire   [  31:0] in_[0:4];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;
  assign in_[  4] = in_$004;

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


endmodule // Mux_0x683fd9fa42038363
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x4c19e633b920d596
//-----------------------------------------------------------------------------
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x4c19e633b920d596
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  31:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   0:0] full,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$bypass_mux_sel;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$full;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementBypassQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk            ( ctrl$clk ),
    .enq_val        ( ctrl$enq_val ),
    .reset          ( ctrl$reset ),
    .deq_rdy        ( ctrl$deq_rdy ),
    .bypass_mux_sel ( ctrl$bypass_mux_sel ),
    .wen            ( ctrl$wen ),
    .deq_val        ( ctrl$deq_val ),
    .full           ( ctrl$full ),
    .enq_rdy        ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$bypass_mux_sel;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$reset;
  wire   [  31:0] dpath$enq_bits;
  wire   [  31:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x4c19e633b920d596 dpath
  (
    .wen            ( dpath$wen ),
    .bypass_mux_sel ( dpath$bypass_mux_sel ),
    .clk            ( dpath$clk ),
    .reset          ( dpath$reset ),
    .enq_bits       ( dpath$enq_bits ),
    .deq_bits       ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk             = clk;
  assign ctrl$deq_rdy         = deq_rdy;
  assign ctrl$enq_val         = enq_val;
  assign ctrl$reset           = reset;
  assign deq_msg              = dpath$deq_bits;
  assign deq_val              = ctrl$deq_val;
  assign dpath$bypass_mux_sel = ctrl$bypass_mux_sel;
  assign dpath$clk            = clk;
  assign dpath$enq_bits       = enq_msg;
  assign dpath$reset          = reset;
  assign dpath$wen            = ctrl$wen;
  assign enq_rdy              = ctrl$enq_rdy;
  assign full                 = ctrl$full;



endmodule // SingleElementBypassQueue_0x4c19e633b920d596
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x4c19e633b920d596
//-----------------------------------------------------------------------------
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x4c19e633b920d596
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  31:0] deq_bits,
  input  wire [  31:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  31:0] bypass_mux$in_$000;
  wire   [  31:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  31:0] bypass_mux$out;

  Mux_0x7e8c65f0610ab9ca bypass_mux
  (
    .reset   ( bypass_mux$reset ),
    .in_$000 ( bypass_mux$in_$000 ),
    .in_$001 ( bypass_mux$in_$001 ),
    .clk     ( bypass_mux$clk ),
    .sel     ( bypass_mux$sel ),
    .out     ( bypass_mux$out )
  );

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  31:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  31:0] queue$out;

  RegEn_0x1eed677bd3b5c175 queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign bypass_mux$clk     = clk;
  assign bypass_mux$in_$000 = queue$out;
  assign bypass_mux$in_$001 = enq_bits;
  assign bypass_mux$reset   = reset;
  assign bypass_mux$sel     = bypass_mux_sel;
  assign deq_bits           = bypass_mux$out;
  assign queue$clk          = clk;
  assign queue$en           = wen;
  assign queue$in_          = enq_bits;
  assign queue$reset        = reset;



endmodule // SingleElementBypassQueueDpath_0x4c19e633b920d596
`default_nettype wire

