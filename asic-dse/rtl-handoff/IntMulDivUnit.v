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
  wire   [   2:0] ctrl$req_typ;
  wire   [   0:0] ctrl$clk;
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
    .req_typ        ( ctrl$req_typ ),
    .clk            ( ctrl$clk ),
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
  assign ctrl$req_typ         = req_msg[69:67];
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
  input  wire [   2:0] req_typ,
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
  //         if s.req_typ == MduReqMsg.TYPE_MULHSU or s.req_typ == MduReqMsg.TYPE_MULH:
  //           s.a_mux_sel.value = A_MUX_SEL_SEXT
  //         else:
  //           s.a_mux_sel.value = A_MUX_SEL_LD
  //
  //         s.b_mux_sel.value      = B_MUX_SEL_LD
  //
  //         if s.req_typ == MduReqMsg.TYPE_MULH:
  //           s.result_mux_sel.value = RESULT_MUX_SEL_MULH
  //         else:
  //           s.result_mux_sel.value = RESULT_MUX_SEL_0
  //
  //         s.result_reg_en.value  = 1
  //         s.buffers_en.value     = 1
  //         s.is_hi.value          = (s.req_typ != 0)
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
      if (((req_typ == TYPE_MULHSU)||(req_typ == TYPE_MULH))) begin
        a_mux_sel = A_MUX_SEL_SEXT;
      end
      else begin
        a_mux_sel = A_MUX_SEL_LD;
      end
      b_mux_sel = B_MUX_SEL_LD;
      if ((req_typ == TYPE_MULH)) begin
        result_mux_sel = RESULT_MUX_SEL_MULH;
      end
      else begin
        result_mux_sel = RESULT_MUX_SEL_0;
      end
      result_reg_en = 1;
      buffers_en = 1;
      is_hi = (req_typ != 0);
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
  wire   [   2:0] ctrl$req_typ;
  wire   [   0:0] ctrl$sub_negative1;
  wire   [   0:0] ctrl$sub_negative2;
  wire   [   0:0] ctrl$clk;
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
    .req_typ           ( ctrl$req_typ ),
    .sub_negative1     ( ctrl$sub_negative1 ),
    .sub_negative2     ( ctrl$sub_negative2 ),
    .clk               ( ctrl$clk ),
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
  assign ctrl$req_typ            = req_msg[69:67];
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
  input  wire [   2:0] req_typ,
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
  //         s.is_div.value            = (s.req_typ[1] == 0) # div/divu = 0b100, 0b101
  //         s.is_signed.value         = (s.req_typ[0] == 0) # div/rem = 0b100, 0b110
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
      is_div = (req_typ[1] == 0);
      is_signed = (req_typ[0] == 0);
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

