//-----------------------------------------------------------------------------
// SwShim_0x32a7578b0a6f3a5a
//-----------------------------------------------------------------------------
// dut: <examples.gcd.GcdUnitRTL.GcdUnitRTL object at 0x7f5cc9ac3c10>
// dut_asynch: <HostGcdUnit.HostGcdUnit object at 0x7f5cc9ac36d0>
// asynch_bitwidth: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostGcdUnit_SwShim
(
  input  wire [   0:0] clk,
  input  wire [  31:0] req_msg,
  output wire [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  output wire [  15:0] resp_msg,
  input  wire [   0:0] resp_rdy,
  output wire [   0:0] resp_val
);

  // wire declarations
  wire   [   0:0] dut_out_rdy$000;
  wire   [   0:0] dut_out_val$000;
  wire   [   0:0] dut_in_rdy$000;
  wire   [  15:0] dut_out_msg$000;
  wire   [   0:0] dut_in_val$000;
  wire   [  31:0] dut_in_msg$000;


  // in_deserialize temporaries
  wire   [   0:0] in_deserialize$out_rdy;
  wire   [   7:0] in_deserialize$in__msg;
  wire   [   0:0] in_deserialize$in__val;
  wire   [   0:0] in_deserialize$clk;
  wire   [   0:0] in_deserialize$reset;
  wire   [  16:0] in_deserialize$out_msg;
  wire   [   0:0] in_deserialize$out_val;
  wire   [   0:0] in_deserialize$in__rdy;

  ValRdyDeserializer_0x3fa12697d0f7bbd5 in_deserialize
  (
    .out_rdy ( in_deserialize$out_rdy ),
    .in__msg ( in_deserialize$in__msg ),
    .in__val ( in_deserialize$in__val ),
    .clk     ( in_deserialize$clk ),
    .reset   ( in_deserialize$reset ),
    .out_msg ( in_deserialize$out_msg ),
    .out_val ( in_deserialize$out_val ),
    .in__rdy ( in_deserialize$in__rdy )
  );

  // in_merge temporaries
  wire   [   0:0] in_merge$out_rdy;
  wire   [  31:0] in_merge$in_$000_msg;
  wire   [   0:0] in_merge$in_$000_val;
  wire   [   0:0] in_merge$clk;
  wire   [   0:0] in_merge$reset;
  wire   [  32:0] in_merge$out_msg;
  wire   [   0:0] in_merge$out_val;
  wire   [   0:0] in_merge$in_$000_rdy;

  ValRdyMerge_0x3f4cbc08d2b2c84c in_merge
  (
    .out_rdy     ( in_merge$out_rdy ),
    .in_$000_msg ( in_merge$in_$000_msg ),
    .in_$000_val ( in_merge$in_$000_val ),
    .clk         ( in_merge$clk ),
    .reset       ( in_merge$reset ),
    .out_msg     ( in_merge$out_msg ),
    .out_val     ( in_merge$out_val ),
    .in_$000_rdy ( in_merge$in_$000_rdy )
  );

  // in_serialize temporaries
  wire   [   0:0] in_serialize$out_rdy;
  wire   [  32:0] in_serialize$in__msg;
  wire   [   0:0] in_serialize$in__val;
  wire   [   0:0] in_serialize$clk;
  wire   [   0:0] in_serialize$reset;
  wire   [   7:0] in_serialize$out_msg;
  wire   [   0:0] in_serialize$out_val;
  wire   [   0:0] in_serialize$in__rdy;

  ValRdySerializer_0x2da4074966e2f2fa in_serialize
  (
    .out_rdy ( in_serialize$out_rdy ),
    .in__msg ( in_serialize$in__msg ),
    .in__val ( in_serialize$in__val ),
    .clk     ( in_serialize$clk ),
    .reset   ( in_serialize$reset ),
    .out_msg ( in_serialize$out_msg ),
    .out_val ( in_serialize$out_val ),
    .in__rdy ( in_serialize$in__rdy )
  );

  // dut temporaries
  wire   [   0:0] dut$out_ack;
  wire   [   7:0] dut$in__msg;
  wire   [   0:0] dut$in__req;
  wire   [   0:0] dut$clk;
  wire   [   0:0] dut$reset;
  wire   [   7:0] dut$out_msg;
  wire   [   0:0] dut$out_req;
  wire   [   0:0] dut$in__ack;

  HostGcdUnit dut
  (
    .out_ack_io ( dut$out_ack ),
    .in__msg_io ( dut$in__msg ),
    .in__req_io ( dut$in__req ),
    .clk_io     ( dut$clk ),
    .reset_io   ( dut$reset ),
    .out_msg_io ( dut$out_msg ),
    .out_req_io ( dut$out_req ),
    .in__ack_io ( dut$in__ack )
  );

  // in_split temporaries
  wire   [   0:0] in_split$out$000_rdy;
  wire   [  16:0] in_split$in__msg;
  wire   [   0:0] in_split$in__val;
  wire   [   0:0] in_split$clk;
  wire   [   0:0] in_split$reset;
  wire   [  15:0] in_split$out$000_msg;
  wire   [   0:0] in_split$out$000_val;
  wire   [   0:0] in_split$in__rdy;

  ValRdySplit_0x589cfa5f6fe757d4 in_split
  (
    .out$000_rdy ( in_split$out$000_rdy ),
    .in__msg     ( in_split$in__msg ),
    .in__val     ( in_split$in__val ),
    .clk         ( in_split$clk ),
    .reset       ( in_split$reset ),
    .out$000_msg ( in_split$out$000_msg ),
    .out$000_val ( in_split$out$000_val ),
    .in__rdy     ( in_split$in__rdy )
  );

  // in_valRdyToReqAck temporaries
  wire   [   0:0] in_valRdyToReqAck$out_ack;
  wire   [   7:0] in_valRdyToReqAck$in__msg;
  wire   [   0:0] in_valRdyToReqAck$in__val;
  wire   [   0:0] in_valRdyToReqAck$clk;
  wire   [   0:0] in_valRdyToReqAck$reset;
  wire   [   7:0] in_valRdyToReqAck$out_msg;
  wire   [   0:0] in_valRdyToReqAck$out_req;
  wire   [   0:0] in_valRdyToReqAck$in__rdy;

  ValRdyToReqAck_0x3871167c1fef1233_swshim in_valRdyToReqAck
  (
    .out_ack ( in_valRdyToReqAck$out_ack ),
    .in__msg ( in_valRdyToReqAck$in__msg ),
    .in__val ( in_valRdyToReqAck$in__val ),
    .clk     ( in_valRdyToReqAck$clk ),
    .reset   ( in_valRdyToReqAck$reset ),
    .out_msg ( in_valRdyToReqAck$out_msg ),
    .out_req ( in_valRdyToReqAck$out_req ),
    .in__rdy ( in_valRdyToReqAck$in__rdy )
  );

  // in_reqAckToValRdy temporaries
  wire   [   0:0] in_reqAckToValRdy$out_rdy;
  wire   [   7:0] in_reqAckToValRdy$in__msg;
  wire   [   0:0] in_reqAckToValRdy$in__req;
  wire   [   0:0] in_reqAckToValRdy$clk;
  wire   [   0:0] in_reqAckToValRdy$reset;
  wire   [   7:0] in_reqAckToValRdy$out_msg;
  wire   [   0:0] in_reqAckToValRdy$out_val;
  wire   [   0:0] in_reqAckToValRdy$in__ack;

  ReqAckToValRdy_0x1b4e41cb91c5205_swshim in_reqAckToValRdy
  (
    .out_rdy ( in_reqAckToValRdy$out_rdy ),
    .in__msg ( in_reqAckToValRdy$in__msg ),
    .in__req ( in_reqAckToValRdy$in__req ),
    .clk     ( in_reqAckToValRdy$clk ),
    .reset   ( in_reqAckToValRdy$reset ),
    .out_msg ( in_reqAckToValRdy$out_msg ),
    .out_val ( in_reqAckToValRdy$out_val ),
    .in__ack ( in_reqAckToValRdy$in__ack )
  );

  // signal connections
  assign dut$clk                    = clk;
  assign dut$in__msg                = in_valRdyToReqAck$out_msg;
  assign dut$in__req                = in_valRdyToReqAck$out_req;
  assign dut$out_ack                = in_reqAckToValRdy$in__ack;
  assign dut$reset                  = reset;
  assign dut_in_msg$000             = req_msg;
  assign dut_in_rdy$000             = in_merge$in_$000_rdy;
  assign dut_in_val$000             = req_val;
  assign dut_out_msg$000            = in_split$out$000_msg[15:0];
  assign dut_out_rdy$000            = resp_rdy;
  assign dut_out_val$000            = in_split$out$000_val;
  assign in_deserialize$clk         = clk;
  assign in_deserialize$in__msg     = in_reqAckToValRdy$out_msg;
  assign in_deserialize$in__val     = in_reqAckToValRdy$out_val;
  assign in_deserialize$out_rdy     = in_split$in__rdy;
  assign in_deserialize$reset       = reset;
  assign in_merge$clk               = clk;
  assign in_merge$in_$000_msg[31:0] = dut_in_msg$000;
  assign in_merge$in_$000_val       = dut_in_val$000;
  assign in_merge$out_rdy           = in_serialize$in__rdy;
  assign in_merge$reset             = reset;
  assign in_reqAckToValRdy$clk      = clk;
  assign in_reqAckToValRdy$in__msg  = dut$out_msg;
  assign in_reqAckToValRdy$in__req  = dut$out_req;
  assign in_reqAckToValRdy$out_rdy  = in_deserialize$in__rdy;
  assign in_reqAckToValRdy$reset    = reset;
  assign in_serialize$clk           = clk;
  assign in_serialize$in__msg       = in_merge$out_msg;
  assign in_serialize$in__val       = in_merge$out_val;
  assign in_serialize$out_rdy       = in_valRdyToReqAck$in__rdy;
  assign in_serialize$reset         = reset;
  assign in_split$clk               = clk;
  assign in_split$in__msg           = in_deserialize$out_msg;
  assign in_split$in__val           = in_deserialize$out_val;
  assign in_split$out$000_rdy       = dut_out_rdy$000;
  assign in_split$reset             = reset;
  assign in_valRdyToReqAck$clk      = clk;
  assign in_valRdyToReqAck$in__msg  = in_serialize$out_msg;
  assign in_valRdyToReqAck$in__val  = in_serialize$out_val;
  assign in_valRdyToReqAck$out_ack  = dut$in__ack;
  assign in_valRdyToReqAck$reset    = reset;
  assign req_rdy                    = dut_in_rdy$000;
  assign resp_msg                   = dut_out_msg$000;
  assign resp_val                   = dut_out_val$000;



endmodule // SwShim_0x32a7578b0a6f3a5a
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyToReqAck_0x3871167c1fef1233
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyToReqAck_0x3871167c1fef1233_swshim
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  input  wire [   0:0] out_ack,
  output reg  [   7:0] out_msg,
  output reg  [   0:0] out_req,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] synch_ack;
  wire   [   0:0] synch_1_out;
  wire   [   7:0] reg_out;


  // register declarations
  reg    [   0:0] reg_en;
  reg    [   1:0] state;

  // localparam declarations
  localparam STATE_HOLD = 1;
  localparam STATE_RECV = 0;
  localparam STATE_SEND = 2;
  localparam STATE_WAIT = 3;

  // synch_1 temporaries
  wire   [   0:0] synch_1$reset;
  wire   [   0:0] synch_1$in_;
  wire   [   0:0] synch_1$clk;
  wire   [   0:0] synch_1$out;

  RegRst_0x2ce052f8c32c5c39 synch_1
  (
    .reset ( synch_1$reset ),
    .in_   ( synch_1$in_ ),
    .clk   ( synch_1$clk ),
    .out   ( synch_1$out )
  );

  // synch_2 temporaries
  wire   [   0:0] synch_2$reset;
  wire   [   0:0] synch_2$in_;
  wire   [   0:0] synch_2$clk;
  wire   [   0:0] synch_2$out;

  RegRst_0x2ce052f8c32c5c39 synch_2
  (
    .reset ( synch_2$reset ),
    .in_   ( synch_2$in_ ),
    .clk   ( synch_2$clk ),
    .out   ( synch_2$out )
  );

  // reg_in temporaries
  wire   [   0:0] reg_in$reset;
  wire   [   7:0] reg_in$in_;
  wire   [   0:0] reg_in$clk;
  wire   [   0:0] reg_in$en;
  wire   [   7:0] reg_in$out;

  RegEn_0x45f1552f10c5f05d_swshim reg_in
  (
    .reset ( reg_in$reset ),
    .in_   ( reg_in$in_ ),
    .clk   ( reg_in$clk ),
    .en    ( reg_in$en ),
    .out   ( reg_in$out )
  );

  // signal connections
  assign reg_in$clk    = clk;
  assign reg_in$en     = reg_en;
  assign reg_in$in_    = in__msg;
  assign reg_in$reset  = reset;
  assign reg_out       = reg_in$out;
  assign synch_1$clk   = clk;
  assign synch_1$in_   = out_ack;
  assign synch_1$reset = reset;
  assign synch_1_out   = synch_1$out;
  assign synch_2$clk   = clk;
  assign synch_2$in_   = synch_1_out;
  assign synch_2$reset = reset;
  assign synch_ack     = synch_2$out;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def sequential_logic():
  //       if( s.reset ):
  //         s.state.next = s.STATE_RECV
  //       elif( s.state == s.STATE_RECV ):
  //         if( s.in_.val ) : s.state.next = s.STATE_HOLD
  //       elif( s.state == s.STATE_HOLD ):
  //         s.state.next = s.STATE_SEND
  //       elif( s.state == s.STATE_SEND ):
  //         if( s.synch_ack ) : s.state.next = s.STATE_WAIT
  //       elif( s.state == s.STATE_WAIT ):
  //         if( ~s.synch_ack ) : s.state.next = s.STATE_RECV

  // logic for sequential_logic()
  always @ (posedge clk) begin
    if (reset) begin
      state <= STATE_RECV;
    end
    else begin
      if ((state == STATE_RECV)) begin
        if (in__val) begin
          state <= STATE_HOLD;
        end
        else begin
        end
      end
      else begin
        if ((state == STATE_HOLD)) begin
          state <= STATE_SEND;
        end
        else begin
          if ((state == STATE_SEND)) begin
            if (synch_ack) begin
              state <= STATE_WAIT;
            end
            else begin
            end
          end
          else begin
            if ((state == STATE_WAIT)) begin
              if (~synch_ack) begin
                state <= STATE_RECV;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       s.in_.rdy.value = ( s.state == s.STATE_RECV )
  //       s.reg_en.value  = s.in_.val & s.in_.rdy
  //       s.out.msg.value = s.reg_out
  //       s.out.req.value = ( s.state == s.STATE_SEND )

  // logic for combinational_logic()
  always @ (*) begin
    in__rdy = (state == STATE_RECV);
    reg_en = (in__val&in__rdy);
    out_msg = reg_out;
    out_req = (state == STATE_SEND);
  end


endmodule // ValRdyToReqAck_0x3871167c1fef1233
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x45f1552f10c5f05d
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x45f1552f10c5f05d_swshim
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   7:0] in_,
  output reg  [   7:0] out,
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


endmodule // RegEn_0x45f1552f10c5f05d
`default_nettype wire

//-----------------------------------------------------------------------------
// ReqAckToValRdy_0x1b4e41cb91c5205
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ReqAckToValRdy_0x1b4e41cb91c5205_swshim
(
  input  wire [   0:0] clk,
  output reg  [   0:0] in__ack,
  input  wire [   7:0] in__msg,
  input  wire [   0:0] in__req,
  output reg  [   7:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] synch_1_out;
  wire   [   0:0] in_req;
  wire   [   7:0] reg_out;


  // register declarations
  reg    [   0:0] reg_en;
  reg    [   1:0] state;

  // localparam declarations
  localparam STATE_HOLD = 1;
  localparam STATE_RECV = 0;
  localparam STATE_SEND = 2;
  localparam STATE_WAIT = 3;

  // synch_1 temporaries
  wire   [   0:0] synch_1$reset;
  wire   [   0:0] synch_1$in_;
  wire   [   0:0] synch_1$clk;
  wire   [   0:0] synch_1$out;

  RegRst_0x2ce052f8c32c5c39 synch_1
  (
    .reset ( synch_1$reset ),
    .in_   ( synch_1$in_ ),
    .clk   ( synch_1$clk ),
    .out   ( synch_1$out )
  );

  // synch_2 temporaries
  wire   [   0:0] synch_2$reset;
  wire   [   0:0] synch_2$in_;
  wire   [   0:0] synch_2$clk;
  wire   [   0:0] synch_2$out;

  RegRst_0x2ce052f8c32c5c39 synch_2
  (
    .reset ( synch_2$reset ),
    .in_   ( synch_2$in_ ),
    .clk   ( synch_2$clk ),
    .out   ( synch_2$out )
  );

  // reg_in temporaries
  wire   [   0:0] reg_in$reset;
  wire   [   7:0] reg_in$in_;
  wire   [   0:0] reg_in$clk;
  wire   [   0:0] reg_in$en;
  wire   [   7:0] reg_in$out;

  RegEn_0x45f1552f10c5f05d_swshim reg_in
  (
    .reset ( reg_in$reset ),
    .in_   ( reg_in$in_ ),
    .clk   ( reg_in$clk ),
    .en    ( reg_in$en ),
    .out   ( reg_in$out )
  );

  // signal connections
  assign in_req        = synch_2$out;
  assign reg_in$clk    = clk;
  assign reg_in$en     = reg_en;
  assign reg_in$in_    = in__msg;
  assign reg_in$reset  = reset;
  assign reg_out       = reg_in$out;
  assign synch_1$clk   = clk;
  assign synch_1$in_   = in__req;
  assign synch_1$reset = reset;
  assign synch_1_out   = synch_1$out;
  assign synch_2$clk   = clk;
  assign synch_2$in_   = synch_1_out;
  assign synch_2$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def sequential_logic():
  //       if( s.reset ):
  //         s.state.next = s.STATE_RECV
  //       elif( s.state == s.STATE_RECV ):
  //         if( s.in_req ) : s.state.next = s.STATE_WAIT
  //       elif( s.state == s.STATE_WAIT ):
  //         if( ~s.in_req ) : s.state.next = s.STATE_SEND
  //       elif( s.state == s.STATE_SEND ):
  //         if( s.out.rdy ) : s.state.next = s.STATE_HOLD
  //       elif( s.state == s.STATE_HOLD ):
  //         s.state.next = s.STATE_RECV

  // logic for sequential_logic()
  always @ (posedge clk) begin
    if (reset) begin
      state <= STATE_RECV;
    end
    else begin
      if ((state == STATE_RECV)) begin
        if (in_req) begin
          state <= STATE_WAIT;
        end
        else begin
        end
      end
      else begin
        if ((state == STATE_WAIT)) begin
          if (~in_req) begin
            state <= STATE_SEND;
          end
          else begin
          end
        end
        else begin
          if ((state == STATE_SEND)) begin
            if (out_rdy) begin
              state <= STATE_HOLD;
            end
            else begin
            end
          end
          else begin
            if ((state == STATE_HOLD)) begin
              state <= STATE_RECV;
            end
            else begin
            end
          end
        end
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       s.in_.ack.value = ( s.state == s.STATE_WAIT )
  //       s.reg_en.value  = s.in_req and ( s.state == s.STATE_RECV )
  //       s.out.msg.value = s.reg_out
  //       s.out.val.value = ( s.state == s.STATE_SEND )

  // logic for combinational_logic()
  always @ (*) begin
    in__ack = (state == STATE_WAIT);
    reg_en = (in_req&&(state == STATE_RECV));
    out_msg = reg_out;
    out_val = (state == STATE_SEND);
  end


endmodule // ReqAckToValRdy_0x1b4e41cb91c5205
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyDeserializer_0x3fa12697d0f7bbd5
//-----------------------------------------------------------------------------
// dtype_in: 8
// dtype_out: 17
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyDeserializer_0x3fa12697d0f7bbd5
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  16:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] count;
  wire   [  23:0] reg_out;
  wire   [  23:0] reg_in;


  // register declarations
  reg    [   1:0] counter;
  reg    [   0:0] reg_en;
  reg    [   2:0] state;

  // localparam declarations
  localparam STATE_RECV = 0;
  localparam STATE_SEND = 1;
  localparam p_nmsgs = 3;

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [  23:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [  23:0] reg_$out;

  RegEn_0x32a57bb87cf40013_swshim reg_
  (
    .reset ( reg_$reset ),
    .in_   ( reg_$in_ ),
    .clk   ( reg_$clk ),
    .en    ( reg_$en ),
    .out   ( reg_$out )
  );

  // signal connections
  assign out_msg         = reg_out[16:0];
  assign reg_$clk        = clk;
  assign reg_$en         = reg_en;
  assign reg_$in_[15:0]  = reg_out[23:8];
  assign reg_$in_[23:16] = in__msg;
  assign reg_$reset      = reset;
  assign reg_out         = reg_$out;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def sequential_logic():
  //       if( s.reset ):
  //         s.state  .next = s.STATE_RECV
  //         s.counter.next = 0x0
  //       elif( s.state == s.STATE_RECV and s.in_.val and s.in_.rdy ):
  //         if ( s.counter == p_nmsgs-1 ):
  //           s.state  .next = s.STATE_SEND
  //           s.counter.next = 0x0
  //         else                         :
  //           s.state  .next = s.STATE_RECV
  //           s.counter.next = s.counter + 1
  //       elif( s.state == s.STATE_SEND and s.out.val and s.out.rdy ):
  //         s.state  .next = s.STATE_RECV
  //         s.counter.next = 0x0

  // logic for sequential_logic()
  always @ (posedge clk) begin
    if (reset) begin
      state <= STATE_RECV;
      counter <= 0;
    end
    else begin
      if (((state == STATE_RECV)&&in__val&&in__rdy)) begin
        if ((counter == (p_nmsgs-1))) begin
          state <= STATE_SEND;
          counter <= 0;
        end
        else begin
          state <= STATE_RECV;
          counter <= (counter+1);
        end
      end
      else begin
        if (((state == STATE_SEND)&&out_val&&out_rdy)) begin
          state <= STATE_RECV;
          counter <= 0;
        end
        else begin
        end
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       s.in_.rdy.value = s.state == s.STATE_RECV
  //       s.out.val.value = s.state == s.STATE_SEND
  //       s.reg_en.value  = s.in_.val & ( s.state == s.STATE_RECV )

  // logic for combinational_logic()
  always @ (*) begin
    in__rdy = (state == STATE_RECV);
    out_val = (state == STATE_SEND);
    reg_en = (in__val&(state == STATE_RECV));
  end


endmodule // ValRdyDeserializer_0x3fa12697d0f7bbd5
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x32a57bb87cf40013
//-----------------------------------------------------------------------------
// dtype: 24
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x32a57bb87cf40013_swshim
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  23:0] in_,
  output reg  [  23:0] out,
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


endmodule // RegEn_0x32a57bb87cf40013
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyMerge_0x3f4cbc08d2b2c84c
//-----------------------------------------------------------------------------
// p_nports: 1
// p_nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyMerge_0x3f4cbc08d2b2c84c
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  output wire [  32:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] grants;
  wire   [   0:0] in_val;


  // register declarations
  reg    [   0:0] in_rdy;
  reg    [   0:0] reqs;

  // localparam declarations
  localparam p_nports = 1;

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [  31:0] mux$in_$000;
  wire   [   0:0] mux$clk;
  wire   [   0:0] mux$sel;
  wire   [  31:0] mux$out;

  Mux_0x644bb806a7356553 mux
  (
    .reset   ( mux$reset ),
    .in_$000 ( mux$in_$000 ),
    .clk     ( mux$clk ),
    .sel     ( mux$sel ),
    .out     ( mux$out )
  );

  // signal connections
  assign grants         = 1'd1;
  assign in_$000_rdy    = in_rdy[0];
  assign in_val[0]      = in_$000_val;
  assign mux$clk        = clk;
  assign mux$in_$000    = in_$000_msg;
  assign mux$reset      = reset;
  assign mux$sel        = grants;
  assign out_msg[31:0]  = mux$out;
  assign out_msg[32:32] = grants;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       if p_nports > 1 :
  //         s.reqs.value         = s.in_val & sext( s.out.rdy, p_nports )
  //         s.in_rdy.value       = s.grants & sext( s.out.rdy, p_nports )
  //       else :
  //         s.reqs.value         = 1
  //         s.in_rdy.value       = s.out.rdy
  //       s.out.val.value      = reduce_or( s.reqs & s.in_val )

  // logic for combinational_logic()
  always @ (*) begin
    if ((p_nports > 1)) begin
      reqs = (in_val&{ { p_nports-1 { out_rdy[0] } }, out_rdy[0:0] });
      in_rdy = (grants&{ { p_nports-1 { out_rdy[0] } }, out_rdy[0:0] });
    end
    else begin
      reqs = 1;
      in_rdy = out_rdy;
    end
    out_val = (|(reqs&in_val));
  end


endmodule // ValRdyMerge_0x3f4cbc08d2b2c84c
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x644bb806a7356553
//-----------------------------------------------------------------------------
// nports: 1
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x644bb806a7356553
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_$000,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [  31:0] in_[0:0];
  assign in_[  0] = in_$000;

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def logic():
  //       if not s.sel:
  //         s.out.value = 0
  //       else:
  //         for i in range( nports ):
  //           if s.sel[i]:
  //             s.out.value = s.in_[i]

  // logic for logic()
  always @ (*) begin
    if (!sel) begin
      out = 0;
    end
    else begin
      for (i=0; i < nports; i=i+1)
      begin
        if (sel[i]) begin
          out = in_[i];
        end
        else begin
        end
      end
    end
  end


endmodule // Mux_0x644bb806a7356553
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdySerializer_0x2da4074966e2f2fa
//-----------------------------------------------------------------------------
// dtype_in: 33
// dtype_out: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySerializer_0x2da4074966e2f2fa
(
  input  wire [   0:0] clk,
  input  wire [  32:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [   7:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [  39:0] reg_out;
  wire   [  39:0] reg_in;


  // register declarations
  reg    [   0:0] count;
  reg    [   2:0] counter;
  reg    [   0:0] load;

  // localparam declarations
  localparam p_nmsgs = 5;

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [   7:0] mux$in_$000;
  wire   [   7:0] mux$in_$001;
  wire   [   7:0] mux$in_$002;
  wire   [   7:0] mux$in_$003;
  wire   [   7:0] mux$in_$004;
  wire   [   0:0] mux$clk;
  wire   [   2:0] mux$sel;
  wire   [   7:0] mux$out;

  Mux_0x611160c9e19c1f45 mux
  (
    .reset   ( mux$reset ),
    .in_$000 ( mux$in_$000 ),
    .in_$001 ( mux$in_$001 ),
    .in_$002 ( mux$in_$002 ),
    .in_$003 ( mux$in_$003 ),
    .in_$004 ( mux$in_$004 ),
    .clk     ( mux$clk ),
    .sel     ( mux$sel ),
    .out     ( mux$out )
  );

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [  39:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [  39:0] reg_$out;

  RegEn_0x3297a3f612d222c3_swshim reg_
  (
    .reset ( reg_$reset ),
    .in_   ( reg_$in_ ),
    .clk   ( reg_$clk ),
    .en    ( reg_$en ),
    .out   ( reg_$out )
  );

  // signal connections
  assign mux$clk       = clk;
  assign mux$in_$000   = reg_out[7:0];
  assign mux$in_$001   = reg_out[15:8];
  assign mux$in_$002   = reg_out[23:16];
  assign mux$in_$003   = reg_out[31:24];
  assign mux$in_$004   = reg_out[39:32];
  assign mux$reset     = reset;
  assign mux$sel       = counter;
  assign out_msg       = mux$out;
  assign reg_$clk      = clk;
  assign reg_$en       = load;
  assign reg_$in_      = reg_in;
  assign reg_$reset    = reset;
  assign reg_in[32:0]  = in__msg;
  assign reg_in[39:33] = 7'd0;
  assign reg_out       = reg_$out;


  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def sequential_logic():
  //       if( s.reset ):
  //         s.in_.rdy.next = 1;
  //         s.count  .next = 0;
  //         s.counter.next = 0x0;
  //         s.out.val.next = 0;
  //       elif( s.load ):
  //         s.in_.rdy.next = 0;
  //         s.count  .next = 1;
  //         s.counter.next = 0x0;
  //         s.out.val.next = 1;
  //       elif( s.out.rdy & (s.counter == p_nmsgs-1) ):
  //         s.in_.rdy.next = 1;
  //         s.count  .next = 0;
  //         s.counter.next = 0x0;
  //         s.out.val.next = 0;
  //       elif( s.out.rdy & s.count ):
  //         s.in_.rdy.next = 0;
  //         s.count  .next = 1;
  //         s.counter.next = s.counter + 0x1;
  //         s.out.val.next = 1;

  // logic for sequential_logic()
  always @ (posedge clk) begin
    if (reset) begin
      in__rdy <= 1;
      count <= 0;
      counter <= 0;
      out_val <= 0;
    end
    else begin
      if (load) begin
        in__rdy <= 0;
        count <= 1;
        counter <= 0;
        out_val <= 1;
      end
      else begin
        if ((out_rdy&(counter == (p_nmsgs-1)))) begin
          in__rdy <= 1;
          count <= 0;
          counter <= 0;
          out_val <= 0;
        end
        else begin
          if ((out_rdy&count)) begin
            in__rdy <= 0;
            count <= 1;
            counter <= (counter+1);
            out_val <= 1;
          end
          else begin
          end
        end
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       s.load.value = s.in_.val & s.in_.rdy

  // logic for combinational_logic()
  always @ (*) begin
    load = (in__val&in__rdy);
  end


endmodule // ValRdySerializer_0x2da4074966e2f2fa
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x3297a3f612d222c3
//-----------------------------------------------------------------------------
// dtype: 40
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x3297a3f612d222c3_swshim
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  39:0] in_,
  output reg  [  39:0] out,
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


endmodule // RegEn_0x3297a3f612d222c3
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x611160c9e19c1f45
//-----------------------------------------------------------------------------
// dtype: 8
// nports: 5
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x611160c9e19c1f45
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in_$000,
  input  wire [   7:0] in_$001,
  input  wire [   7:0] in_$002,
  input  wire [   7:0] in_$003,
  input  wire [   7:0] in_$004,
  output reg  [   7:0] out,
  input  wire [   0:0] reset,
  input  wire [   2:0] sel
);

  // localparam declarations
  localparam nports = 5;


  // array declarations
  wire   [   7:0] in_[0:4];
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


endmodule // Mux_0x611160c9e19c1f45
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
// ValRdySplit_0x589cfa5f6fe757d4
//-----------------------------------------------------------------------------
// p_nports: 1
// p_nbits: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySplit_0x589cfa5f6fe757d4
(
  input  wire [   0:0] clk,
  input  wire [  16:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  15:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] channel;
  wire   [   0:0] out_rdy;


  // register declarations
  reg    [   0:0] out_val;

  // localparam declarations
  localparam p_nports = 1;

  // demux temporaries
  wire   [   0:0] demux$reset;
  wire   [  15:0] demux$in_;
  wire   [   0:0] demux$clk;
  wire   [   0:0] demux$sel;
  wire   [  15:0] demux$out$000;

  Demux_0x2e56d2646372c923 demux
  (
    .reset   ( demux$reset ),
    .in_     ( demux$in_ ),
    .clk     ( demux$clk ),
    .sel     ( demux$sel ),
    .out$000 ( demux$out$000 )
  );

  // signal connections
  assign channel     = in__msg[16:16];
  assign demux$clk   = clk;
  assign demux$in_   = in__msg[15:0];
  assign demux$reset = reset;
  assign demux$sel   = channel;
  assign out$000_msg = demux$out$000;
  assign out$000_val = out_val[0];
  assign out_rdy[0]  = out$000_rdy;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //       if p_nports > 1 :
  //         s.out_val.value      = sext( s.in_.val, p_nports ) & s.channel
  //       else :
  //         s.out_val.value      = s.in_.val & s.channel
  //       s.in_.rdy.value      = reduce_or( s.channel & s.out_rdy )

  // logic for combinational_logic()
  always @ (*) begin
    if ((p_nports > 1)) begin
      out_val = ({ { p_nports-1 { in__val[0] } }, in__val[0:0] }&channel);
    end
    else begin
      out_val = (in__val&channel);
    end
    in__rdy = (|(channel&out_rdy));
  end


endmodule // ValRdySplit_0x589cfa5f6fe757d4
`default_nettype wire

//-----------------------------------------------------------------------------
// Demux_0x2e56d2646372c923
//-----------------------------------------------------------------------------
// nports: 1
// dtype: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Demux_0x2e56d2646372c923
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_,
  output wire [  15:0] out$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [  15:0] out[0:0];
  assign out$000 = out[  0];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def logic():
  //       for i in range( nports ):
  //         s.out[i].value = s.in_ if s.sel[i] else 0

  // logic for logic()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      out[i] = sel[i] ? in_ : 0;
    end
  end


endmodule // Demux_0x2e56d2646372c923
`default_nettype wire
