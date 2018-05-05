//-----------------------------------------------------------------------------
// HostGcdUnit_SwShim
//-----------------------------------------------------------------------------
// dut: <examples.gcd.GcdUnitRTL.GcdUnitRTL object at 0x7fa8bc7210d0>
// dut_asynch: <HostGcdUnit.HostGcdUnit object at 0x7fa8bc725190>
// asynch_bitwidth: 8
// translate: False
// dump_vcd: None
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

  ValRdyToReqAck_0x3871167c1fef1233 in_valRdyToReqAck
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

  ReqAckToValRdy_0x1b4e41cb91c5205 in_reqAckToValRdy
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



endmodule // HostGcdUnit_SwShim
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

  RegEn_0x32a57bb87cf40013 reg_
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
module RegEn_0x32a57bb87cf40013
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
  //         s.reqs.value    = 1
  //         s.in_rdy.value  = s.out.rdy
  //         s.out.val.value = reduce_or( s.reqs & s.in_val )

  // logic for combinational_logic()
  always @ (*) begin
    reqs = 1;
    in_rdy = out_rdy;
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

  RegEn_0x3297a3f612d222c3 reg_
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
// RegEn_0x3297a3f612d222c3
//-----------------------------------------------------------------------------
// dtype: 40
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x3297a3f612d222c3
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
// HostGcdUnit
//-----------------------------------------------------------------------------
// asynch_bitwidth: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostGcdUnit
(
  input  wire [   0:0] clk_io,
  output wire [   0:0] in__ack_io,
  input  wire [   7:0] in__msg_io,
  input  wire [   0:0] in__req_io,
  input  wire [   0:0] out_ack_io,
  output wire [   7:0] out_msg_io,
  output wire [   0:0] out_req_io,
  input  wire [   0:0] reset_io
);

  //----------------------------------------------------------------------
  // Pads
  //----------------------------------------------------------------------

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
    .I   (1'b0),          \
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
    .I   (1'b0),          \
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

  wire [   0:0] clk;     // input
  wire [   0:0] reset;   // input
  wire [   7:0] in__msg; // input
  wire [   0:0] in__req; // input
  wire [   0:0] in__ack; // output
  wire [   7:0] out_msg; // output
  wire [   0:0] out_req; // output
  wire [   0:0] out_ack; // input

  //                 Inst Name            PAD         data

   `INPUT_PAD_V(        clk_iocell,      clk_io[0],      clk[0] )

   `INPUT_PAD_H(      reset_iocell,    reset_io[0],    reset[0] )

   `INPUT_PAD_V(  in__msg_0_iocell,  in__msg_io[0],  in__msg[0] )
   `INPUT_PAD_V(  in__msg_1_iocell,  in__msg_io[1],  in__msg[1] )
   `INPUT_PAD_V(  in__msg_2_iocell,  in__msg_io[2],  in__msg[2] )
   `INPUT_PAD_V(  in__msg_3_iocell,  in__msg_io[3],  in__msg[3] )
   `INPUT_PAD_V(  in__msg_4_iocell,  in__msg_io[4],  in__msg[4] )
   `INPUT_PAD_V(  in__msg_5_iocell,  in__msg_io[5],  in__msg[5] )
   `INPUT_PAD_V(  in__msg_6_iocell,  in__msg_io[6],  in__msg[6] )
   `INPUT_PAD_V(  in__msg_7_iocell,  in__msg_io[7],  in__msg[7] )
   `INPUT_PAD_V(    in__req_iocell,  in__req_io[0],  in__req[0] )
   `INPUT_PAD_V(    out_ack_iocell,  out_ack_io[0],  out_ack[0] )

  `OUTPUT_PAD_V(    in__ack_iocell,  in__ack_io[0],  in__ack[0] )
  `OUTPUT_PAD_V(  out_msg_0_iocell,  out_msg_io[0],  out_msg[0] )
  `OUTPUT_PAD_V(  out_msg_1_iocell,  out_msg_io[1],  out_msg[1] )
  `OUTPUT_PAD_V(  out_msg_2_iocell,  out_msg_io[2],  out_msg[2] )
  `OUTPUT_PAD_V(  out_msg_3_iocell,  out_msg_io[3],  out_msg[3] )
  `OUTPUT_PAD_V(  out_msg_4_iocell,  out_msg_io[4],  out_msg[4] )
  `OUTPUT_PAD_V(  out_msg_5_iocell,  out_msg_io[5],  out_msg[5] )
  `OUTPUT_PAD_V(  out_msg_6_iocell,  out_msg_io[6],  out_msg[6] )
  `OUTPUT_PAD_V(  out_msg_7_iocell,  out_msg_io[7],  out_msg[7] )
  `OUTPUT_PAD_V(    out_req_iocell,  out_req_io[0],  out_req[0] )


  // wire declarations
  wire   [   0:0] dut_out_val$000;
  wire   [   0:0] dut_out_rdy$000;
  wire   [   0:0] dut_in_rdy$000;
  wire   [  15:0] dut_out_msg$000;
  wire   [   0:0] dut_in_val$000;
  wire   [  31:0] dut_in_msg$000;


  // out_serialize temporaries
  wire   [   0:0] out_serialize$out_rdy;
  wire   [  16:0] out_serialize$in__msg;
  wire   [   0:0] out_serialize$in__val;
  wire   [   0:0] out_serialize$clk;
  wire   [   0:0] out_serialize$reset;
  wire   [   7:0] out_serialize$out_msg;
  wire   [   0:0] out_serialize$out_val;
  wire   [   0:0] out_serialize$in__rdy;

  ValRdySerializer_0x44f3cbdd11620196 out_serialize
  (
    .out_rdy ( out_serialize$out_rdy ),
    .in__msg ( out_serialize$in__msg ),
    .in__val ( out_serialize$in__val ),
    .clk     ( out_serialize$clk ),
    .reset   ( out_serialize$reset ),
    .out_msg ( out_serialize$out_msg ),
    .out_val ( out_serialize$out_val ),
    .in__rdy ( out_serialize$in__rdy )
  );

  // in_deserialize temporaries
  wire   [   0:0] in_deserialize$out_rdy;
  wire   [   7:0] in_deserialize$in__msg;
  wire   [   0:0] in_deserialize$in__val;
  wire   [   0:0] in_deserialize$clk;
  wire   [   0:0] in_deserialize$reset;
  wire   [  32:0] in_deserialize$out_msg;
  wire   [   0:0] in_deserialize$out_val;
  wire   [   0:0] in_deserialize$in__rdy;

  ValRdyDeserializer_0x1c18cc10687cb97b in_deserialize
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

  // out_valRdyToReqAck temporaries
  wire   [   0:0] out_valRdyToReqAck$out_ack;
  wire   [   7:0] out_valRdyToReqAck$in__msg;
  wire   [   0:0] out_valRdyToReqAck$in__val;
  wire   [   0:0] out_valRdyToReqAck$clk;
  wire   [   0:0] out_valRdyToReqAck$reset;
  wire   [   7:0] out_valRdyToReqAck$out_msg;
  wire   [   0:0] out_valRdyToReqAck$out_req;
  wire   [   0:0] out_valRdyToReqAck$in__rdy;

  ValRdyToReqAck_0x3871167c1fef1233 out_valRdyToReqAck
  (
    .out_ack ( out_valRdyToReqAck$out_ack ),
    .in__msg ( out_valRdyToReqAck$in__msg ),
    .in__val ( out_valRdyToReqAck$in__val ),
    .clk     ( out_valRdyToReqAck$clk ),
    .reset   ( out_valRdyToReqAck$reset ),
    .out_msg ( out_valRdyToReqAck$out_msg ),
    .out_req ( out_valRdyToReqAck$out_req ),
    .in__rdy ( out_valRdyToReqAck$in__rdy )
  );

  // in_q$000 temporaries
  wire   [   0:0] in_q$000$clk;
  wire   [  31:0] in_q$000$enq_msg;
  wire   [   0:0] in_q$000$enq_val;
  wire   [   0:0] in_q$000$reset;
  wire   [   0:0] in_q$000$deq_rdy;
  wire   [   0:0] in_q$000$enq_rdy;
  wire   [   3:0] in_q$000$num_free_entries;
  wire   [  31:0] in_q$000$deq_msg;
  wire   [   0:0] in_q$000$deq_val;

  NormalQueue_0x5d6b3b47697c8177 in_q$000
  (
    .clk              ( in_q$000$clk ),
    .enq_msg          ( in_q$000$enq_msg ),
    .enq_val          ( in_q$000$enq_val ),
    .reset            ( in_q$000$reset ),
    .deq_rdy          ( in_q$000$deq_rdy ),
    .enq_rdy          ( in_q$000$enq_rdy ),
    .num_free_entries ( in_q$000$num_free_entries ),
    .deq_msg          ( in_q$000$deq_msg ),
    .deq_val          ( in_q$000$deq_val )
  );

  // out_merge temporaries
  wire   [   0:0] out_merge$out_rdy;
  wire   [  15:0] out_merge$in_$000_msg;
  wire   [   0:0] out_merge$in_$000_val;
  wire   [   0:0] out_merge$clk;
  wire   [   0:0] out_merge$reset;
  wire   [  16:0] out_merge$out_msg;
  wire   [   0:0] out_merge$out_val;
  wire   [   0:0] out_merge$in_$000_rdy;

  ValRdyMerge_0x11d24dc292334c5c out_merge
  (
    .out_rdy     ( out_merge$out_rdy ),
    .in_$000_msg ( out_merge$in_$000_msg ),
    .in_$000_val ( out_merge$in_$000_val ),
    .clk         ( out_merge$clk ),
    .reset       ( out_merge$reset ),
    .out_msg     ( out_merge$out_msg ),
    .out_val     ( out_merge$out_val ),
    .in_$000_rdy ( out_merge$in_$000_rdy )
  );

  // dut temporaries
  wire   [   0:0] dut$resp_rdy;
  wire   [   0:0] dut$clk;
  wire   [  31:0] dut$req_msg;
  wire   [   0:0] dut$req_val;
  wire   [   0:0] dut$reset;
  wire   [  15:0] dut$resp_msg;
  wire   [   0:0] dut$resp_val;
  wire   [   0:0] dut$req_rdy;

  GcdUnit dut
  (
    .resp_rdy ( dut$resp_rdy ),
    .clk      ( dut$clk ),
    .req_msg  ( dut$req_msg ),
    .req_val  ( dut$req_val ),
    .reset    ( dut$reset ),
    .resp_msg ( dut$resp_msg ),
    .resp_val ( dut$resp_val ),
    .req_rdy  ( dut$req_rdy )
  );

  // in_split temporaries
  wire   [   0:0] in_split$out$000_rdy;
  wire   [  32:0] in_split$in__msg;
  wire   [   0:0] in_split$in__val;
  wire   [   0:0] in_split$clk;
  wire   [   0:0] in_split$reset;
  wire   [  31:0] in_split$out$000_msg;
  wire   [   0:0] in_split$out$000_val;
  wire   [   0:0] in_split$in__rdy;

  ValRdySplit_0x4a3a9b62fa78933c in_split
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

  // in_reqAckToValRdy temporaries
  wire   [   0:0] in_reqAckToValRdy$out_rdy;
  wire   [   7:0] in_reqAckToValRdy$in__msg;
  wire   [   0:0] in_reqAckToValRdy$in__req;
  wire   [   0:0] in_reqAckToValRdy$clk;
  wire   [   0:0] in_reqAckToValRdy$reset;
  wire   [   7:0] in_reqAckToValRdy$out_msg;
  wire   [   0:0] in_reqAckToValRdy$out_val;
  wire   [   0:0] in_reqAckToValRdy$in__ack;

  ReqAckToValRdy_0x1b4e41cb91c5205 in_reqAckToValRdy
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
  assign dut$clk                     = clk;
  assign dut$req_msg                 = dut_in_msg$000;
  assign dut$req_val                 = dut_in_val$000;
  assign dut$reset                   = reset;
  assign dut$resp_rdy                = dut_out_rdy$000;
  assign dut_in_msg$000              = in_q$000$deq_msg;
  assign dut_in_rdy$000              = dut$req_rdy;
  assign dut_in_val$000              = in_q$000$deq_val;
  assign dut_out_msg$000             = dut$resp_msg;
  assign dut_out_rdy$000             = out_merge$in_$000_rdy;
  assign dut_out_val$000             = dut$resp_val;
  assign in__ack                     = in_reqAckToValRdy$in__ack;
  assign in_deserialize$clk          = clk;
  assign in_deserialize$in__msg      = in_reqAckToValRdy$out_msg;
  assign in_deserialize$in__val      = in_reqAckToValRdy$out_val;
  assign in_deserialize$out_rdy      = in_split$in__rdy;
  assign in_deserialize$reset        = reset;
  assign in_q$000$clk                = clk;
  assign in_q$000$deq_rdy            = dut_in_rdy$000;
  assign in_q$000$enq_msg            = in_split$out$000_msg[31:0];
  assign in_q$000$enq_val            = in_split$out$000_val;
  assign in_q$000$reset              = reset;
  assign in_reqAckToValRdy$clk       = clk;
  assign in_reqAckToValRdy$in__msg   = in__msg;
  assign in_reqAckToValRdy$in__req   = in__req;
  assign in_reqAckToValRdy$out_rdy   = in_deserialize$in__rdy;
  assign in_reqAckToValRdy$reset     = reset;
  assign in_split$clk                = clk;
  assign in_split$in__msg            = in_deserialize$out_msg;
  assign in_split$in__val            = in_deserialize$out_val;
  assign in_split$out$000_rdy        = in_q$000$enq_rdy;
  assign in_split$reset              = reset;
  assign out_merge$clk               = clk;
  assign out_merge$in_$000_msg[15:0] = dut_out_msg$000;
  assign out_merge$in_$000_val       = dut_out_val$000;
  assign out_merge$out_rdy           = out_serialize$in__rdy;
  assign out_merge$reset             = reset;
  assign out_msg                     = out_valRdyToReqAck$out_msg;
  assign out_req                     = out_valRdyToReqAck$out_req;
  assign out_serialize$clk           = clk;
  assign out_serialize$in__msg       = out_merge$out_msg;
  assign out_serialize$in__val       = out_merge$out_val;
  assign out_serialize$out_rdy       = out_valRdyToReqAck$in__rdy;
  assign out_serialize$reset         = reset;
  assign out_valRdyToReqAck$clk      = clk;
  assign out_valRdyToReqAck$in__msg  = out_serialize$out_msg;
  assign out_valRdyToReqAck$in__val  = out_serialize$out_val;
  assign out_valRdyToReqAck$out_ack  = out_ack;
  assign out_valRdyToReqAck$reset    = reset;



endmodule // HostGcdUnit
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdySerializer_0x44f3cbdd11620196
//-----------------------------------------------------------------------------
// dtype_in: 17
// dtype_out: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySerializer_0x44f3cbdd11620196
(
  input  wire [   0:0] clk,
  input  wire [  16:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [   7:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [  23:0] reg_out;
  wire   [  23:0] reg_in;


  // register declarations
  reg    [   0:0] count;
  reg    [   1:0] counter;
  reg    [   0:0] load;

  // localparam declarations
  localparam p_nmsgs = 3;

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [   7:0] mux$in_$000;
  wire   [   7:0] mux$in_$001;
  wire   [   7:0] mux$in_$002;
  wire   [   0:0] mux$clk;
  wire   [   1:0] mux$sel;
  wire   [   7:0] mux$out;

  Mux_0x341febeacc223741 mux
  (
    .reset   ( mux$reset ),
    .in_$000 ( mux$in_$000 ),
    .in_$001 ( mux$in_$001 ),
    .in_$002 ( mux$in_$002 ),
    .clk     ( mux$clk ),
    .sel     ( mux$sel ),
    .out     ( mux$out )
  );

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [  23:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [  23:0] reg_$out;

  RegEn_0x32a57bb87cf40013 reg_
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
  assign mux$reset     = reset;
  assign mux$sel       = counter;
  assign out_msg       = mux$out;
  assign reg_$clk      = clk;
  assign reg_$en       = load;
  assign reg_$in_      = reg_in;
  assign reg_$reset    = reset;
  assign reg_in[16:0]  = in__msg;
  assign reg_in[23:17] = 7'd0;
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


endmodule // ValRdySerializer_0x44f3cbdd11620196
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x341febeacc223741
//-----------------------------------------------------------------------------
// dtype: 8
// nports: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x341febeacc223741
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in_$000,
  input  wire [   7:0] in_$001,
  input  wire [   7:0] in_$002,
  output reg  [   7:0] out,
  input  wire [   0:0] reset,
  input  wire [   1:0] sel
);

  // localparam declarations
  localparam nports = 3;


  // array declarations
  wire   [   7:0] in_[0:2];
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


endmodule // Mux_0x341febeacc223741
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyDeserializer_0x1c18cc10687cb97b
//-----------------------------------------------------------------------------
// dtype_in: 8
// dtype_out: 33
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyDeserializer_0x1c18cc10687cb97b
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  32:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] count;
  wire   [  39:0] reg_out;
  wire   [  39:0] reg_in;


  // register declarations
  reg    [   2:0] counter;
  reg    [   0:0] reg_en;
  reg    [   2:0] state;

  // localparam declarations
  localparam STATE_RECV = 0;
  localparam STATE_SEND = 1;
  localparam p_nmsgs = 5;

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [  39:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [  39:0] reg_$out;

  RegEn_0x3297a3f612d222c3 reg_
  (
    .reset ( reg_$reset ),
    .in_   ( reg_$in_ ),
    .clk   ( reg_$clk ),
    .en    ( reg_$en ),
    .out   ( reg_$out )
  );

  // signal connections
  assign out_msg         = reg_out[32:0];
  assign reg_$clk        = clk;
  assign reg_$en         = reg_en;
  assign reg_$in_[31:0]  = reg_out[39:8];
  assign reg_$in_[39:32] = in__msg;
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


endmodule // ValRdyDeserializer_0x1c18cc10687cb97b
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyToReqAck_0x3871167c1fef1233
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyToReqAck_0x3871167c1fef1233
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
  wire   [   7:0] reg_out;


  // register declarations
  reg    [   0:0] reg_en;
  reg    [   1:0] state$in_;

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

  RegEn_0x45f1552f10c5f05d reg_in
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
  assign state$clk     = clk;
  assign state$reset   = reset;
  assign synch_1$clk   = clk;
  assign synch_1$in_   = out_ack;
  assign synch_1$reset = reset;
  assign synch_2$clk   = clk;
  assign synch_2$in_   = synch_1$out;
  assign synch_2$reset = reset;
  assign synch_ack     = synch_2$out;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transition():
  //       s.state.in_.value = s.state.out
  //
  //       if   s.state.out == s.STATE_RECV:
  //         if s.in_.val:
  //           s.state.in_.value = s.STATE_HOLD
  //
  //       elif s.state.out == s.STATE_HOLD:
  //         s.state.in_.value = s.STATE_SEND
  //
  //       elif s.state.out == s.STATE_SEND:
  //         if s.synch_ack:
  //           s.state.in_.value = s.STATE_WAIT
  //
  //       elif s.state.out == s.STATE_WAIT:
  //         if ~s.synch_ack:
  //           s.state.in_.value = s.STATE_RECV

  // logic for state_transition()
  always @ (*) begin
    state$in_ = state$out;
    if ((state$out == STATE_RECV)) begin
      if (in__val) begin
        state$in_ = STATE_HOLD;
      end
      else begin
      end
    end
    else begin
      if ((state$out == STATE_HOLD)) begin
        state$in_ = STATE_SEND;
      end
      else begin
        if ((state$out == STATE_SEND)) begin
          if (synch_ack) begin
            state$in_ = STATE_WAIT;
          end
          else begin
          end
        end
        else begin
          if ((state$out == STATE_WAIT)) begin
            if (~synch_ack) begin
              state$in_ = STATE_RECV;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_output():
  //       s.in_.rdy.value = ( s.state.out == s.STATE_RECV )
  //       s.reg_en.value  = s.in_.val & s.in_.rdy
  //       s.out.msg.value = s.reg_out
  //       s.out.req.value = ( s.state.out == s.STATE_SEND )

  // logic for state_output()
  always @ (*) begin
    in__rdy = (state$out == STATE_RECV);
    reg_en = (in__val&in__rdy);
    out_msg = reg_out;
    out_req = (state$out == STATE_SEND);
  end


endmodule // ValRdyToReqAck_0x3871167c1fef1233
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
// RegEn_0x45f1552f10c5f05d
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x45f1552f10c5f05d
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
// NormalQueue_0x5d6b3b47697c8177
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x5d6b3b47697c8177
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  31:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   3:0] num_free_entries,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   3:0] ctrl$waddr;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   3:0] ctrl$raddr;
  wire   [   3:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x18ba6db74e0ae73 ctrl
  (
    .clk              ( ctrl$clk ),
    .enq_val          ( ctrl$enq_val ),
    .reset            ( ctrl$reset ),
    .deq_rdy          ( ctrl$deq_rdy ),
    .waddr            ( ctrl$waddr ),
    .wen              ( ctrl$wen ),
    .deq_val          ( ctrl$deq_val ),
    .raddr            ( ctrl$raddr ),
    .num_free_entries ( ctrl$num_free_entries ),
    .enq_rdy          ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   3:0] dpath$waddr;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$wen;
  wire   [   3:0] dpath$raddr;
  wire   [   0:0] dpath$reset;
  wire   [  31:0] dpath$enq_bits;
  wire   [  31:0] dpath$deq_bits;

  NormalQueueDpath_0x5d6b3b47697c8177 dpath
  (
    .waddr    ( dpath$waddr ),
    .clk      ( dpath$clk ),
    .wen      ( dpath$wen ),
    .raddr    ( dpath$raddr ),
    .reset    ( dpath$reset ),
    .enq_bits ( dpath$enq_bits ),
    .deq_bits ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk         = clk;
  assign ctrl$deq_rdy     = deq_rdy;
  assign ctrl$enq_val     = enq_val;
  assign ctrl$reset       = reset;
  assign deq_msg          = dpath$deq_bits;
  assign deq_val          = ctrl$deq_val;
  assign dpath$clk        = clk;
  assign dpath$enq_bits   = enq_msg;
  assign dpath$raddr      = ctrl$raddr;
  assign dpath$reset      = reset;
  assign dpath$waddr      = ctrl$waddr;
  assign dpath$wen        = ctrl$wen;
  assign enq_rdy          = ctrl$enq_rdy;
  assign num_free_entries = ctrl$num_free_entries;



endmodule // NormalQueue_0x5d6b3b47697c8177
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueCtrl_0x18ba6db74e0ae73
//-----------------------------------------------------------------------------
// num_entries: 10
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueCtrl_0x18ba6db74e0ae73
(
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   3:0] num_free_entries,
  output reg  [   3:0] raddr,
  input  wire [   0:0] reset,
  output reg  [   3:0] waddr,
  output reg  [   0:0] wen
);

  // register declarations
  reg    [   3:0] deq_ptr;
  reg    [   3:0] deq_ptr_inc;
  reg    [   3:0] deq_ptr_next;
  reg    [   0:0] do_deq;
  reg    [   0:0] do_enq;
  reg    [   0:0] empty;
  reg    [   3:0] enq_ptr;
  reg    [   3:0] enq_ptr_inc;
  reg    [   3:0] enq_ptr_next;
  reg    [   0:0] full;
  reg    [   0:0] full_next_cycle;

  // localparam declarations
  localparam last_idx = 9;
  localparam num_entries = 10;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq():
  //
  //       if s.reset: s.deq_ptr.next = 0
  //       else:       s.deq_ptr.next = s.deq_ptr_next
  //
  //       if s.reset: s.enq_ptr.next = 0
  //       else:       s.enq_ptr.next = s.enq_ptr_next
  //
  //       if   s.reset:               s.full.next = 0
  //       elif s.full_next_cycle:     s.full.next = 1
  //       elif (s.do_deq and s.full): s.full.next = 0
  //       else:                       s.full.next = s.full

  // logic for seq()
  always @ (posedge clk) begin
    if (reset) begin
      deq_ptr <= 0;
    end
    else begin
      deq_ptr <= deq_ptr_next;
    end
    if (reset) begin
      enq_ptr <= 0;
    end
    else begin
      enq_ptr <= enq_ptr_next;
    end
    if (reset) begin
      full <= 0;
    end
    else begin
      if (full_next_cycle) begin
        full <= 1;
      end
      else begin
        if ((do_deq&&full)) begin
          full <= 0;
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
  //       # set output signals
  //
  //       s.empty.value   = not s.full and (s.enq_ptr == s.deq_ptr)
  //
  //       s.enq_rdy.value = not s.full
  //       s.deq_val.value = not s.empty
  //
  //       # only enqueue/dequeue if valid and ready
  //
  //       s.do_enq.value = s.enq_rdy and s.enq_val
  //       s.do_deq.value = s.deq_rdy and s.deq_val
  //
  //       # set control signals
  //
  //       s.wen.value     = s.do_enq
  //       s.waddr.value   = s.enq_ptr
  //       s.raddr.value   = s.deq_ptr
  //
  //       # enq ptr incrementer
  //
  //       if s.enq_ptr == s.last_idx: s.enq_ptr_inc.value = 0
  //       else:                       s.enq_ptr_inc.value = s.enq_ptr + 1
  //
  //       # deq ptr incrementer
  //
  //       if s.deq_ptr == s.last_idx: s.deq_ptr_inc.value = 0
  //       else:                       s.deq_ptr_inc.value = s.deq_ptr + 1
  //
  //       # set the next ptr value
  //
  //       if s.do_enq: s.enq_ptr_next.value = s.enq_ptr_inc
  //       else:        s.enq_ptr_next.value = s.enq_ptr
  //
  //       if s.do_deq: s.deq_ptr_next.value = s.deq_ptr_inc
  //       else:        s.deq_ptr_next.value = s.deq_ptr
  //
  //       # number of free entries calculation
  //
  //       if   s.reset:
  //         s.num_free_entries.value = s.num_entries
  //       elif s.full:
  //         s.num_free_entries.value = 0
  //       elif s.empty:
  //         s.num_free_entries.value = s.num_entries
  //       elif s.enq_ptr > s.deq_ptr:
  //         s.num_free_entries.value = s.num_entries - ( s.enq_ptr - s.deq_ptr )
  //       elif s.deq_ptr > s.enq_ptr:
  //         s.num_free_entries.value = s.deq_ptr - s.enq_ptr
  //
  //       s.full_next_cycle.value = (s.do_enq and not s.do_deq and
  //                                 (s.enq_ptr_next == s.deq_ptr))

  // logic for comb()
  always @ (*) begin
    empty = (!full&&(enq_ptr == deq_ptr));
    enq_rdy = !full;
    deq_val = !empty;
    do_enq = (enq_rdy&&enq_val);
    do_deq = (deq_rdy&&deq_val);
    wen = do_enq;
    waddr = enq_ptr;
    raddr = deq_ptr;
    if ((enq_ptr == last_idx)) begin
      enq_ptr_inc = 0;
    end
    else begin
      enq_ptr_inc = (enq_ptr+1);
    end
    if ((deq_ptr == last_idx)) begin
      deq_ptr_inc = 0;
    end
    else begin
      deq_ptr_inc = (deq_ptr+1);
    end
    if (do_enq) begin
      enq_ptr_next = enq_ptr_inc;
    end
    else begin
      enq_ptr_next = enq_ptr;
    end
    if (do_deq) begin
      deq_ptr_next = deq_ptr_inc;
    end
    else begin
      deq_ptr_next = deq_ptr;
    end
    if (reset) begin
      num_free_entries = num_entries;
    end
    else begin
      if (full) begin
        num_free_entries = 0;
      end
      else begin
        if (empty) begin
          num_free_entries = num_entries;
        end
        else begin
          if ((enq_ptr > deq_ptr)) begin
            num_free_entries = (num_entries-(enq_ptr-deq_ptr));
          end
          else begin
            if ((deq_ptr > enq_ptr)) begin
              num_free_entries = (deq_ptr-enq_ptr);
            end
            else begin
            end
          end
        end
      end
    end
    full_next_cycle = (do_enq&&!do_deq&&(enq_ptr_next == deq_ptr));
  end


endmodule // NormalQueueCtrl_0x18ba6db74e0ae73
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x5d6b3b47697c8177
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x5d6b3b47697c8177
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_bits,
  input  wire [  31:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [  31:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  31:0] queue$rd_data$000;

  RegisterFile_0x2802997ae98ca224 queue
  (
    .rd_addr$000 ( queue$rd_addr$000 ),
    .wr_data     ( queue$wr_data ),
    .clk         ( queue$clk ),
    .wr_addr     ( queue$wr_addr ),
    .wr_en       ( queue$wr_en ),
    .reset       ( queue$reset ),
    .rd_data$000 ( queue$rd_data$000 )
  );

  // signal connections
  assign deq_bits          = queue$rd_data$000;
  assign queue$clk         = clk;
  assign queue$rd_addr$000 = raddr;
  assign queue$reset       = reset;
  assign queue$wr_addr     = waddr;
  assign queue$wr_data     = enq_bits;
  assign queue$wr_en       = wen;



endmodule // NormalQueueDpath_0x5d6b3b47697c8177
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x2802997ae98ca224
//-----------------------------------------------------------------------------
// dtype: 32
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x2802997ae98ca224
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [  31:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  31:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  31:0] regs[0:9];
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

  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq_logic():
  //         if s.wr_en:
  //           s.regs[ s.wr_addr ].next = s.wr_data

  // logic for seq_logic()
  always @ (posedge clk) begin
    if (wr_en) begin
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
  //           s.rd_data[i].value = s.regs[ s.rd_addr[i] ]

  // logic for comb_logic()
  always @ (*) begin
    for (i=0; i < rd_ports; i=i+1)
    begin
      rd_data[i] = regs[rd_addr[i]];
    end
  end


endmodule // RegisterFile_0x2802997ae98ca224
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyMerge_0x11d24dc292334c5c
//-----------------------------------------------------------------------------
// p_nports: 1
// p_nbits: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyMerge_0x11d24dc292334c5c
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  output wire [  16:0] out_msg,
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

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [  15:0] mux$in_$000;
  wire   [   0:0] mux$clk;
  wire   [   0:0] mux$sel;
  wire   [  15:0] mux$out;

  Mux_0x2e56d2646372c923 mux
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
  assign out_msg[15:0]  = mux$out;
  assign out_msg[16:16] = grants;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //         s.reqs.value    = 1
  //         s.in_rdy.value  = s.out.rdy
  //         s.out.val.value = reduce_or( s.reqs & s.in_val )

  // logic for combinational_logic()
  always @ (*) begin
    reqs = 1;
    in_rdy = out_rdy;
    out_val = (|(reqs&in_val));
  end


endmodule // ValRdyMerge_0x11d24dc292334c5c
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x2e56d2646372c923
//-----------------------------------------------------------------------------
// nports: 1
// dtype: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x2e56d2646372c923
(
  input  wire [   0:0] clk,
  input  wire [  15:0] in_$000,
  output reg  [  15:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [  15:0] in_[0:0];
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


endmodule // Mux_0x2e56d2646372c923
`default_nettype wire

//-----------------------------------------------------------------------------
// GcdUnit
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module GcdUnit
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

//-----------------------------------------------------------------------------
// ValRdySplit_0x4a3a9b62fa78933c
//-----------------------------------------------------------------------------
// p_nports: 1
// p_nbits: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySplit_0x4a3a9b62fa78933c
(
  input  wire [   0:0] clk,
  input  wire [  32:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  31:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   0:0] channel;
  wire   [   0:0] out_rdy;


  // register declarations
  reg    [   0:0] out_val;

  // demux temporaries
  wire   [   0:0] demux$reset;
  wire   [  31:0] demux$in_;
  wire   [   0:0] demux$clk;
  wire   [   0:0] demux$sel;
  wire   [  31:0] demux$out$000;

  Demux_0x644bb806a7356553 demux
  (
    .reset   ( demux$reset ),
    .in_     ( demux$in_ ),
    .clk     ( demux$clk ),
    .sel     ( demux$sel ),
    .out$000 ( demux$out$000 )
  );

  // signal connections
  assign channel     = in__msg[32:32];
  assign demux$clk   = clk;
  assign demux$in_   = in__msg[31:0];
  assign demux$reset = reset;
  assign demux$sel   = channel;
  assign out$000_msg = demux$out$000;
  assign out$000_val = out_val[0];
  assign out_rdy[0]  = out$000_rdy;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //         s.out_val.value = s.in_.val & s.channel
  //         s.in_.rdy.value = reduce_or( s.channel & s.out_rdy )

  // logic for combinational_logic()
  always @ (*) begin
    out_val = (in__val&channel);
    in__rdy = (|(channel&out_rdy));
  end


endmodule // ValRdySplit_0x4a3a9b62fa78933c
`default_nettype wire

//-----------------------------------------------------------------------------
// Demux_0x644bb806a7356553
//-----------------------------------------------------------------------------
// nports: 1
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Demux_0x644bb806a7356553
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output wire [  31:0] out$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [  31:0] out[0:0];
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


endmodule // Demux_0x644bb806a7356553
`default_nettype wire

//-----------------------------------------------------------------------------
// ReqAckToValRdy_0x1b4e41cb91c5205
//-----------------------------------------------------------------------------
// dtype: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ReqAckToValRdy_0x1b4e41cb91c5205
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
  wire   [   0:0] in_req;
  wire   [   7:0] reg_out;


  // register declarations
  reg    [   0:0] reg_en;
  reg    [   1:0] state$in_;

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

  RegEn_0x45f1552f10c5f05d reg_in
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
  assign state$clk     = clk;
  assign state$reset   = reset;
  assign synch_1$clk   = clk;
  assign synch_1$in_   = in__req;
  assign synch_1$reset = reset;
  assign synch_2$clk   = clk;
  assign synch_2$in_   = synch_1$out;
  assign synch_2$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transition():
  //       s.state.in_.value = s.state.out
  //
  //       if   s.state.out == s.STATE_RECV:
  //         if s.in_req:
  //           s.state.in_.value = s.STATE_WAIT
  //
  //       elif s.state.out == s.STATE_WAIT:
  //         if ~s.in_req:
  //           s.state.in_.value = s.STATE_SEND
  //
  //       elif s.state.out == s.STATE_SEND:
  //         if s.out.rdy:
  //           s.state.in_.value = s.STATE_HOLD
  //
  //       elif s.state.out == s.STATE_HOLD:
  //         s.state.in_.value = s.STATE_RECV

  // logic for state_transition()
  always @ (*) begin
    state$in_ = state$out;
    if ((state$out == STATE_RECV)) begin
      if (in_req) begin
        state$in_ = STATE_WAIT;
      end
      else begin
      end
    end
    else begin
      if ((state$out == STATE_WAIT)) begin
        if (~in_req) begin
          state$in_ = STATE_SEND;
        end
        else begin
        end
      end
      else begin
        if ((state$out == STATE_SEND)) begin
          if (out_rdy) begin
            state$in_ = STATE_HOLD;
          end
          else begin
          end
        end
        else begin
          if ((state$out == STATE_HOLD)) begin
            state$in_ = STATE_RECV;
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
  // def state_output():
  //       s.in_.ack.value = ( s.state.out == s.STATE_WAIT )
  //       s.reg_en.value  = s.in_req & ( s.state.out == s.STATE_RECV )
  //       s.out.msg.value = s.reg_out
  //       s.out.val.value = ( s.state.out == s.STATE_SEND )

  // logic for state_output()
  always @ (*) begin
    in__ack = (state$out == STATE_WAIT);
    reg_en = (in_req&(state$out == STATE_RECV));
    out_msg = reg_out;
    out_val = (state$out == STATE_SEND);
  end


endmodule // ReqAckToValRdy_0x1b4e41cb91c5205
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
  //         s.out_val.value = s.in_.val & s.channel
  //         s.in_.rdy.value = reduce_or( s.channel & s.out_rdy )

  // logic for combinational_logic()
  always @ (*) begin
    out_val = (in__val&channel);
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

