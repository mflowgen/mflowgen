//-----------------------------------------------------------------------------
// HostButterfree
//-----------------------------------------------------------------------------
// asynch_bitwidth: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostButterfree
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
  wire   [   0:0] dut_out_val$001;
  wire   [   0:0] dut_out_val$002;
  wire   [   0:0] dut_out_val$003;
  wire   [   0:0] dut_out_val$004;
  wire   [   0:0] dut_out_val$005;
  wire   [   0:0] dut_out_val$006;
  wire   [   0:0] dut_out_val$007;
  wire   [   0:0] dut_out_val$008;
  wire   [   0:0] dut_out_val$009;
  wire   [   0:0] dut_out_rdy$000;
  wire   [   0:0] dut_out_rdy$001;
  wire   [   0:0] dut_out_rdy$002;
  wire   [   0:0] dut_out_rdy$003;
  wire   [   0:0] dut_out_rdy$004;
  wire   [   0:0] dut_out_rdy$005;
  wire   [   0:0] dut_out_rdy$006;
  wire   [   0:0] dut_out_rdy$007;
  wire   [   0:0] dut_out_rdy$008;
  wire   [   0:0] dut_out_rdy$009;
  wire   [   0:0] dut_in_rdy$000;
  wire   [   0:0] dut_in_rdy$001;
  wire   [   0:0] dut_in_rdy$002;
  wire   [   0:0] dut_in_rdy$003;
  wire   [   0:0] dut_in_rdy$004;
  wire   [   0:0] dut_in_rdy$005;
  wire   [   0:0] dut_in_rdy$006;
  wire   [   0:0] dut_in_rdy$007;
  wire   [   0:0] dut_in_rdy$008;
  wire   [   0:0] dut_in_rdy$009;
  wire   [ 175:0] dut_out_msg$000;
  wire   [ 175:0] dut_out_msg$001;
  wire   [  47:0] dut_out_msg$002;
  wire   [  31:0] dut_out_msg$003;
  wire   [ 145:0] dut_out_msg$004;
  wire   [  31:0] dut_out_msg$005;
  wire   [  31:0] dut_out_msg$006;
  wire   [  31:0] dut_out_msg$007;
  wire   [  34:0] dut_out_msg$008;
  wire   [  32:0] dut_out_msg$009;
  wire   [   0:0] dut_in_val$000;
  wire   [   0:0] dut_in_val$001;
  wire   [   0:0] dut_in_val$002;
  wire   [   0:0] dut_in_val$003;
  wire   [   0:0] dut_in_val$004;
  wire   [   0:0] dut_in_val$005;
  wire   [   0:0] dut_in_val$006;
  wire   [   0:0] dut_in_val$007;
  wire   [   0:0] dut_in_val$008;
  wire   [   0:0] dut_in_val$009;
  wire   [ 145:0] dut_in_msg$000;
  wire   [ 175:0] dut_in_msg$001;
  wire   [  36:0] dut_in_msg$002;
  wire   [  77:0] dut_in_msg$003;
  wire   [ 145:0] dut_in_msg$004;
  wire   [  69:0] dut_in_msg$005;
  wire   [  31:0] dut_in_msg$006;
  wire   [  31:0] dut_in_msg$007;
  wire   [  31:0] dut_in_msg$008;
  wire   [  31:0] dut_in_msg$009;


  // out_serialize temporaries
  wire   [   0:0] out_serialize$out_rdy;
  wire   [ 185:0] out_serialize$in__msg;
  wire   [   0:0] out_serialize$in__val;
  wire   [   0:0] out_serialize$clk;
  wire   [   0:0] out_serialize$reset;
  wire   [   7:0] out_serialize$out_msg;
  wire   [   0:0] out_serialize$out_val;
  wire   [   0:0] out_serialize$in__rdy;

  ValRdySerializer_0x4786b4d82317711b out_serialize
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
  wire   [ 185:0] in_deserialize$out_msg;
  wire   [   0:0] in_deserialize$out_val;
  wire   [   0:0] in_deserialize$in__rdy;

  ValRdyDeserializer_0x3af46cc9f334024 in_deserialize
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
  wire   [ 145:0] in_q$000$enq_msg;
  wire   [   0:0] in_q$000$enq_val;
  wire   [   0:0] in_q$000$reset;
  wire   [   0:0] in_q$000$deq_rdy;
  wire   [   0:0] in_q$000$enq_rdy;
  wire   [   4:0] in_q$000$num_free_entries;
  wire   [ 145:0] in_q$000$deq_msg;
  wire   [   0:0] in_q$000$deq_val;

  NormalQueue_0x2f40bb4fbe95aa17 in_q$000
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

  // in_q$001 temporaries
  wire   [   0:0] in_q$001$clk;
  wire   [ 175:0] in_q$001$enq_msg;
  wire   [   0:0] in_q$001$enq_val;
  wire   [   0:0] in_q$001$reset;
  wire   [   0:0] in_q$001$deq_rdy;
  wire   [   0:0] in_q$001$enq_rdy;
  wire   [   4:0] in_q$001$num_free_entries;
  wire   [ 175:0] in_q$001$deq_msg;
  wire   [   0:0] in_q$001$deq_val;

  NormalQueue_0x3ab90c4e3f034ee7 in_q$001
  (
    .clk              ( in_q$001$clk ),
    .enq_msg          ( in_q$001$enq_msg ),
    .enq_val          ( in_q$001$enq_val ),
    .reset            ( in_q$001$reset ),
    .deq_rdy          ( in_q$001$deq_rdy ),
    .enq_rdy          ( in_q$001$enq_rdy ),
    .num_free_entries ( in_q$001$num_free_entries ),
    .deq_msg          ( in_q$001$deq_msg ),
    .deq_val          ( in_q$001$deq_val )
  );

  // in_q$002 temporaries
  wire   [   0:0] in_q$002$clk;
  wire   [  36:0] in_q$002$enq_msg;
  wire   [   0:0] in_q$002$enq_val;
  wire   [   0:0] in_q$002$reset;
  wire   [   0:0] in_q$002$deq_rdy;
  wire   [   0:0] in_q$002$enq_rdy;
  wire   [   4:0] in_q$002$num_free_entries;
  wire   [  36:0] in_q$002$deq_msg;
  wire   [   0:0] in_q$002$deq_val;

  NormalQueue_0x60e518ea8d2a340a in_q$002
  (
    .clk              ( in_q$002$clk ),
    .enq_msg          ( in_q$002$enq_msg ),
    .enq_val          ( in_q$002$enq_val ),
    .reset            ( in_q$002$reset ),
    .deq_rdy          ( in_q$002$deq_rdy ),
    .enq_rdy          ( in_q$002$enq_rdy ),
    .num_free_entries ( in_q$002$num_free_entries ),
    .deq_msg          ( in_q$002$deq_msg ),
    .deq_val          ( in_q$002$deq_val )
  );

  // in_q$003 temporaries
  wire   [   0:0] in_q$003$clk;
  wire   [  77:0] in_q$003$enq_msg;
  wire   [   0:0] in_q$003$enq_val;
  wire   [   0:0] in_q$003$reset;
  wire   [   0:0] in_q$003$deq_rdy;
  wire   [   0:0] in_q$003$enq_rdy;
  wire   [   4:0] in_q$003$num_free_entries;
  wire   [  77:0] in_q$003$deq_msg;
  wire   [   0:0] in_q$003$deq_val;

  NormalQueue_0x591bd2093ecf65eb in_q$003
  (
    .clk              ( in_q$003$clk ),
    .enq_msg          ( in_q$003$enq_msg ),
    .enq_val          ( in_q$003$enq_val ),
    .reset            ( in_q$003$reset ),
    .deq_rdy          ( in_q$003$deq_rdy ),
    .enq_rdy          ( in_q$003$enq_rdy ),
    .num_free_entries ( in_q$003$num_free_entries ),
    .deq_msg          ( in_q$003$deq_msg ),
    .deq_val          ( in_q$003$deq_val )
  );

  // in_q$004 temporaries
  wire   [   0:0] in_q$004$clk;
  wire   [ 145:0] in_q$004$enq_msg;
  wire   [   0:0] in_q$004$enq_val;
  wire   [   0:0] in_q$004$reset;
  wire   [   0:0] in_q$004$deq_rdy;
  wire   [   0:0] in_q$004$enq_rdy;
  wire   [   4:0] in_q$004$num_free_entries;
  wire   [ 145:0] in_q$004$deq_msg;
  wire   [   0:0] in_q$004$deq_val;

  NormalQueue_0x2f40bb4fbe95aa17 in_q$004
  (
    .clk              ( in_q$004$clk ),
    .enq_msg          ( in_q$004$enq_msg ),
    .enq_val          ( in_q$004$enq_val ),
    .reset            ( in_q$004$reset ),
    .deq_rdy          ( in_q$004$deq_rdy ),
    .enq_rdy          ( in_q$004$enq_rdy ),
    .num_free_entries ( in_q$004$num_free_entries ),
    .deq_msg          ( in_q$004$deq_msg ),
    .deq_val          ( in_q$004$deq_val )
  );

  // in_q$005 temporaries
  wire   [   0:0] in_q$005$clk;
  wire   [  69:0] in_q$005$enq_msg;
  wire   [   0:0] in_q$005$enq_val;
  wire   [   0:0] in_q$005$reset;
  wire   [   0:0] in_q$005$deq_rdy;
  wire   [   0:0] in_q$005$enq_rdy;
  wire   [   4:0] in_q$005$num_free_entries;
  wire   [  69:0] in_q$005$deq_msg;
  wire   [   0:0] in_q$005$deq_val;

  NormalQueue_0x371e2f8d9e1182c3 in_q$005
  (
    .clk              ( in_q$005$clk ),
    .enq_msg          ( in_q$005$enq_msg ),
    .enq_val          ( in_q$005$enq_val ),
    .reset            ( in_q$005$reset ),
    .deq_rdy          ( in_q$005$deq_rdy ),
    .enq_rdy          ( in_q$005$enq_rdy ),
    .num_free_entries ( in_q$005$num_free_entries ),
    .deq_msg          ( in_q$005$deq_msg ),
    .deq_val          ( in_q$005$deq_val )
  );

  // in_q$006 temporaries
  wire   [   0:0] in_q$006$clk;
  wire   [  31:0] in_q$006$enq_msg;
  wire   [   0:0] in_q$006$enq_val;
  wire   [   0:0] in_q$006$reset;
  wire   [   0:0] in_q$006$deq_rdy;
  wire   [   0:0] in_q$006$enq_rdy;
  wire   [   4:0] in_q$006$num_free_entries;
  wire   [  31:0] in_q$006$deq_msg;
  wire   [   0:0] in_q$006$deq_val;

  NormalQueue_0x761e6db39471549 in_q$006
  (
    .clk              ( in_q$006$clk ),
    .enq_msg          ( in_q$006$enq_msg ),
    .enq_val          ( in_q$006$enq_val ),
    .reset            ( in_q$006$reset ),
    .deq_rdy          ( in_q$006$deq_rdy ),
    .enq_rdy          ( in_q$006$enq_rdy ),
    .num_free_entries ( in_q$006$num_free_entries ),
    .deq_msg          ( in_q$006$deq_msg ),
    .deq_val          ( in_q$006$deq_val )
  );

  // in_q$007 temporaries
  wire   [   0:0] in_q$007$clk;
  wire   [  31:0] in_q$007$enq_msg;
  wire   [   0:0] in_q$007$enq_val;
  wire   [   0:0] in_q$007$reset;
  wire   [   0:0] in_q$007$deq_rdy;
  wire   [   0:0] in_q$007$enq_rdy;
  wire   [   4:0] in_q$007$num_free_entries;
  wire   [  31:0] in_q$007$deq_msg;
  wire   [   0:0] in_q$007$deq_val;

  NormalQueue_0x761e6db39471549 in_q$007
  (
    .clk              ( in_q$007$clk ),
    .enq_msg          ( in_q$007$enq_msg ),
    .enq_val          ( in_q$007$enq_val ),
    .reset            ( in_q$007$reset ),
    .deq_rdy          ( in_q$007$deq_rdy ),
    .enq_rdy          ( in_q$007$enq_rdy ),
    .num_free_entries ( in_q$007$num_free_entries ),
    .deq_msg          ( in_q$007$deq_msg ),
    .deq_val          ( in_q$007$deq_val )
  );

  // in_q$008 temporaries
  wire   [   0:0] in_q$008$clk;
  wire   [  31:0] in_q$008$enq_msg;
  wire   [   0:0] in_q$008$enq_val;
  wire   [   0:0] in_q$008$reset;
  wire   [   0:0] in_q$008$deq_rdy;
  wire   [   0:0] in_q$008$enq_rdy;
  wire   [   4:0] in_q$008$num_free_entries;
  wire   [  31:0] in_q$008$deq_msg;
  wire   [   0:0] in_q$008$deq_val;

  NormalQueue_0x761e6db39471549 in_q$008
  (
    .clk              ( in_q$008$clk ),
    .enq_msg          ( in_q$008$enq_msg ),
    .enq_val          ( in_q$008$enq_val ),
    .reset            ( in_q$008$reset ),
    .deq_rdy          ( in_q$008$deq_rdy ),
    .enq_rdy          ( in_q$008$enq_rdy ),
    .num_free_entries ( in_q$008$num_free_entries ),
    .deq_msg          ( in_q$008$deq_msg ),
    .deq_val          ( in_q$008$deq_val )
  );

  // in_q$009 temporaries
  wire   [   0:0] in_q$009$clk;
  wire   [  31:0] in_q$009$enq_msg;
  wire   [   0:0] in_q$009$enq_val;
  wire   [   0:0] in_q$009$reset;
  wire   [   0:0] in_q$009$deq_rdy;
  wire   [   0:0] in_q$009$enq_rdy;
  wire   [   4:0] in_q$009$num_free_entries;
  wire   [  31:0] in_q$009$deq_msg;
  wire   [   0:0] in_q$009$deq_val;

  NormalQueue_0x761e6db39471549 in_q$009
  (
    .clk              ( in_q$009$clk ),
    .enq_msg          ( in_q$009$enq_msg ),
    .enq_val          ( in_q$009$enq_val ),
    .reset            ( in_q$009$reset ),
    .deq_rdy          ( in_q$009$deq_rdy ),
    .enq_rdy          ( in_q$009$enq_rdy ),
    .num_free_entries ( in_q$009$num_free_entries ),
    .deq_msg          ( in_q$009$deq_msg ),
    .deq_val          ( in_q$009$deq_val )
  );

  // out_merge temporaries
  wire   [   0:0] out_merge$out_rdy;
  wire   [ 175:0] out_merge$in_$000_msg;
  wire   [   0:0] out_merge$in_$000_val;
  wire   [ 175:0] out_merge$in_$001_msg;
  wire   [   0:0] out_merge$in_$001_val;
  wire   [ 175:0] out_merge$in_$002_msg;
  wire   [   0:0] out_merge$in_$002_val;
  wire   [ 175:0] out_merge$in_$003_msg;
  wire   [   0:0] out_merge$in_$003_val;
  wire   [ 175:0] out_merge$in_$004_msg;
  wire   [   0:0] out_merge$in_$004_val;
  wire   [ 175:0] out_merge$in_$005_msg;
  wire   [   0:0] out_merge$in_$005_val;
  wire   [ 175:0] out_merge$in_$006_msg;
  wire   [   0:0] out_merge$in_$006_val;
  wire   [ 175:0] out_merge$in_$007_msg;
  wire   [   0:0] out_merge$in_$007_val;
  wire   [ 175:0] out_merge$in_$008_msg;
  wire   [   0:0] out_merge$in_$008_val;
  wire   [ 175:0] out_merge$in_$009_msg;
  wire   [   0:0] out_merge$in_$009_val;
  wire   [   0:0] out_merge$clk;
  wire   [   0:0] out_merge$reset;
  wire   [ 185:0] out_merge$out_msg;
  wire   [   0:0] out_merge$out_val;
  wire   [   0:0] out_merge$in_$000_rdy;
  wire   [   0:0] out_merge$in_$001_rdy;
  wire   [   0:0] out_merge$in_$002_rdy;
  wire   [   0:0] out_merge$in_$003_rdy;
  wire   [   0:0] out_merge$in_$004_rdy;
  wire   [   0:0] out_merge$in_$005_rdy;
  wire   [   0:0] out_merge$in_$006_rdy;
  wire   [   0:0] out_merge$in_$007_rdy;
  wire   [   0:0] out_merge$in_$008_rdy;
  wire   [   0:0] out_merge$in_$009_rdy;

  ValRdyMerge_0x2543de4f552d5e2b out_merge
  (
    .out_rdy     ( out_merge$out_rdy ),
    .in_$000_msg ( out_merge$in_$000_msg ),
    .in_$000_val ( out_merge$in_$000_val ),
    .in_$001_msg ( out_merge$in_$001_msg ),
    .in_$001_val ( out_merge$in_$001_val ),
    .in_$002_msg ( out_merge$in_$002_msg ),
    .in_$002_val ( out_merge$in_$002_val ),
    .in_$003_msg ( out_merge$in_$003_msg ),
    .in_$003_val ( out_merge$in_$003_val ),
    .in_$004_msg ( out_merge$in_$004_msg ),
    .in_$004_val ( out_merge$in_$004_val ),
    .in_$005_msg ( out_merge$in_$005_msg ),
    .in_$005_val ( out_merge$in_$005_val ),
    .in_$006_msg ( out_merge$in_$006_msg ),
    .in_$006_val ( out_merge$in_$006_val ),
    .in_$007_msg ( out_merge$in_$007_msg ),
    .in_$007_val ( out_merge$in_$007_val ),
    .in_$008_msg ( out_merge$in_$008_msg ),
    .in_$008_val ( out_merge$in_$008_val ),
    .in_$009_msg ( out_merge$in_$009_msg ),
    .in_$009_val ( out_merge$in_$009_val ),
    .clk         ( out_merge$clk ),
    .reset       ( out_merge$reset ),
    .out_msg     ( out_merge$out_msg ),
    .out_val     ( out_merge$out_val ),
    .in_$000_rdy ( out_merge$in_$000_rdy ),
    .in_$001_rdy ( out_merge$in_$001_rdy ),
    .in_$002_rdy ( out_merge$in_$002_rdy ),
    .in_$003_rdy ( out_merge$in_$003_rdy ),
    .in_$004_rdy ( out_merge$in_$004_rdy ),
    .in_$005_rdy ( out_merge$in_$005_rdy ),
    .in_$006_rdy ( out_merge$in_$006_rdy ),
    .in_$007_rdy ( out_merge$in_$007_rdy ),
    .in_$008_rdy ( out_merge$in_$008_rdy ),
    .in_$009_rdy ( out_merge$in_$009_rdy )
  );

  // dut temporaries
  wire   [   0:0] dut$dmemreq_rdy;
  wire   [   0:0] dut$imemreq_rdy;
  wire   [ 145:0] dut$dmemresp_msg;
  wire   [   0:0] dut$dmemresp_val;
  wire   [ 175:0] dut$host_icachereq_msg;
  wire   [   0:0] dut$host_icachereq_val;
  wire   [  36:0] dut$ctrlregreq_msg;
  wire   [   0:0] dut$ctrlregreq_val;
  wire   [  77:0] dut$host_dcachereq_msg;
  wire   [   0:0] dut$host_dcachereq_val;
  wire   [   0:0] dut$clk;
  wire   [   0:0] dut$host_dcacheresp_rdy;
  wire   [   0:0] dut$proc2mngr_2_rdy;
  wire   [   0:0] dut$host_icacheresp_rdy;
  wire   [ 145:0] dut$imemresp_msg;
  wire   [   0:0] dut$imemresp_val;
  wire   [  69:0] dut$host_mdureq_msg;
  wire   [   0:0] dut$host_mdureq_val;
  wire   [  31:0] dut$mngr2proc_2_msg;
  wire   [   0:0] dut$mngr2proc_2_val;
  wire   [  31:0] dut$mngr2proc_3_msg;
  wire   [   0:0] dut$mngr2proc_3_val;
  wire   [  31:0] dut$mngr2proc_0_msg;
  wire   [   0:0] dut$mngr2proc_0_val;
  wire   [  31:0] dut$mngr2proc_1_msg;
  wire   [   0:0] dut$mngr2proc_1_val;
  wire   [   0:0] dut$reset;
  wire   [   0:0] dut$proc2mngr_3_rdy;
  wire   [   0:0] dut$proc2mngr_0_rdy;
  wire   [   0:0] dut$proc2mngr_1_rdy;
  wire   [   0:0] dut$host_mduresp_rdy;
  wire   [   0:0] dut$ctrlregresp_rdy;
  wire   [ 175:0] dut$dmemreq_msg;
  wire   [   0:0] dut$dmemreq_val;
  wire   [ 175:0] dut$imemreq_msg;
  wire   [   0:0] dut$imemreq_val;
  wire   [   0:0] dut$dmemresp_rdy;
  wire   [   0:0] dut$host_icachereq_rdy;
  wire   [   0:0] dut$ctrlregreq_rdy;
  wire   [   0:0] dut$host_dcachereq_rdy;
  wire   [  47:0] dut$host_dcacheresp_msg;
  wire   [   0:0] dut$host_dcacheresp_val;
  wire   [  31:0] dut$proc2mngr_2_msg;
  wire   [   0:0] dut$proc2mngr_2_val;
  wire   [ 145:0] dut$host_icacheresp_msg;
  wire   [   0:0] dut$host_icacheresp_val;
  wire   [   0:0] dut$imemresp_rdy;
  wire   [   0:0] dut$host_mdureq_rdy;
  wire   [   0:0] dut$mngr2proc_2_rdy;
  wire   [   0:0] dut$mngr2proc_3_rdy;
  wire   [   0:0] dut$mngr2proc_0_rdy;
  wire   [   0:0] dut$mngr2proc_1_rdy;
  wire   [  31:0] dut$proc2mngr_3_msg;
  wire   [   0:0] dut$proc2mngr_3_val;
  wire   [  31:0] dut$proc2mngr_0_msg;
  wire   [   0:0] dut$proc2mngr_0_val;
  wire   [  31:0] dut$proc2mngr_1_msg;
  wire   [   0:0] dut$proc2mngr_1_val;
  wire   [  34:0] dut$host_mduresp_msg;
  wire   [   0:0] dut$host_mduresp_val;
  wire   [   0:0] dut$debug;
  wire   [  32:0] dut$ctrlregresp_msg;
  wire   [   0:0] dut$ctrlregresp_val;

  Butterfree dut
  (
    .dmemreq_rdy         ( dut$dmemreq_rdy ),
    .imemreq_rdy         ( dut$imemreq_rdy ),
    .dmemresp_msg        ( dut$dmemresp_msg ),
    .dmemresp_val        ( dut$dmemresp_val ),
    .host_icachereq_msg  ( dut$host_icachereq_msg ),
    .host_icachereq_val  ( dut$host_icachereq_val ),
    .ctrlregreq_msg      ( dut$ctrlregreq_msg ),
    .ctrlregreq_val      ( dut$ctrlregreq_val ),
    .host_dcachereq_msg  ( dut$host_dcachereq_msg ),
    .host_dcachereq_val  ( dut$host_dcachereq_val ),
    .clk                 ( dut$clk ),
    .host_dcacheresp_rdy ( dut$host_dcacheresp_rdy ),
    .proc2mngr_2_rdy     ( dut$proc2mngr_2_rdy ),
    .host_icacheresp_rdy ( dut$host_icacheresp_rdy ),
    .imemresp_msg        ( dut$imemresp_msg ),
    .imemresp_val        ( dut$imemresp_val ),
    .host_mdureq_msg     ( dut$host_mdureq_msg ),
    .host_mdureq_val     ( dut$host_mdureq_val ),
    .mngr2proc_2_msg     ( dut$mngr2proc_2_msg ),
    .mngr2proc_2_val     ( dut$mngr2proc_2_val ),
    .mngr2proc_3_msg     ( dut$mngr2proc_3_msg ),
    .mngr2proc_3_val     ( dut$mngr2proc_3_val ),
    .mngr2proc_0_msg     ( dut$mngr2proc_0_msg ),
    .mngr2proc_0_val     ( dut$mngr2proc_0_val ),
    .mngr2proc_1_msg     ( dut$mngr2proc_1_msg ),
    .mngr2proc_1_val     ( dut$mngr2proc_1_val ),
    .reset               ( dut$reset ),
    .proc2mngr_3_rdy     ( dut$proc2mngr_3_rdy ),
    .proc2mngr_0_rdy     ( dut$proc2mngr_0_rdy ),
    .proc2mngr_1_rdy     ( dut$proc2mngr_1_rdy ),
    .host_mduresp_rdy    ( dut$host_mduresp_rdy ),
    .ctrlregresp_rdy     ( dut$ctrlregresp_rdy ),
    .dmemreq_msg         ( dut$dmemreq_msg ),
    .dmemreq_val         ( dut$dmemreq_val ),
    .imemreq_msg         ( dut$imemreq_msg ),
    .imemreq_val         ( dut$imemreq_val ),
    .dmemresp_rdy        ( dut$dmemresp_rdy ),
    .host_icachereq_rdy  ( dut$host_icachereq_rdy ),
    .ctrlregreq_rdy      ( dut$ctrlregreq_rdy ),
    .host_dcachereq_rdy  ( dut$host_dcachereq_rdy ),
    .host_dcacheresp_msg ( dut$host_dcacheresp_msg ),
    .host_dcacheresp_val ( dut$host_dcacheresp_val ),
    .proc2mngr_2_msg     ( dut$proc2mngr_2_msg ),
    .proc2mngr_2_val     ( dut$proc2mngr_2_val ),
    .host_icacheresp_msg ( dut$host_icacheresp_msg ),
    .host_icacheresp_val ( dut$host_icacheresp_val ),
    .imemresp_rdy        ( dut$imemresp_rdy ),
    .host_mdureq_rdy     ( dut$host_mdureq_rdy ),
    .mngr2proc_2_rdy     ( dut$mngr2proc_2_rdy ),
    .mngr2proc_3_rdy     ( dut$mngr2proc_3_rdy ),
    .mngr2proc_0_rdy     ( dut$mngr2proc_0_rdy ),
    .mngr2proc_1_rdy     ( dut$mngr2proc_1_rdy ),
    .proc2mngr_3_msg     ( dut$proc2mngr_3_msg ),
    .proc2mngr_3_val     ( dut$proc2mngr_3_val ),
    .proc2mngr_0_msg     ( dut$proc2mngr_0_msg ),
    .proc2mngr_0_val     ( dut$proc2mngr_0_val ),
    .proc2mngr_1_msg     ( dut$proc2mngr_1_msg ),
    .proc2mngr_1_val     ( dut$proc2mngr_1_val ),
    .host_mduresp_msg    ( dut$host_mduresp_msg ),
    .host_mduresp_val    ( dut$host_mduresp_val ),
    .debug               ( dut$debug ),
    .ctrlregresp_msg     ( dut$ctrlregresp_msg ),
    .ctrlregresp_val     ( dut$ctrlregresp_val )
  );

  // in_split temporaries
  wire   [   0:0] in_split$out$000_rdy;
  wire   [   0:0] in_split$out$001_rdy;
  wire   [   0:0] in_split$out$002_rdy;
  wire   [   0:0] in_split$out$003_rdy;
  wire   [   0:0] in_split$out$004_rdy;
  wire   [   0:0] in_split$out$005_rdy;
  wire   [   0:0] in_split$out$006_rdy;
  wire   [   0:0] in_split$out$007_rdy;
  wire   [   0:0] in_split$out$008_rdy;
  wire   [   0:0] in_split$out$009_rdy;
  wire   [ 185:0] in_split$in__msg;
  wire   [   0:0] in_split$in__val;
  wire   [   0:0] in_split$clk;
  wire   [   0:0] in_split$reset;
  wire   [ 175:0] in_split$out$000_msg;
  wire   [   0:0] in_split$out$000_val;
  wire   [ 175:0] in_split$out$001_msg;
  wire   [   0:0] in_split$out$001_val;
  wire   [ 175:0] in_split$out$002_msg;
  wire   [   0:0] in_split$out$002_val;
  wire   [ 175:0] in_split$out$003_msg;
  wire   [   0:0] in_split$out$003_val;
  wire   [ 175:0] in_split$out$004_msg;
  wire   [   0:0] in_split$out$004_val;
  wire   [ 175:0] in_split$out$005_msg;
  wire   [   0:0] in_split$out$005_val;
  wire   [ 175:0] in_split$out$006_msg;
  wire   [   0:0] in_split$out$006_val;
  wire   [ 175:0] in_split$out$007_msg;
  wire   [   0:0] in_split$out$007_val;
  wire   [ 175:0] in_split$out$008_msg;
  wire   [   0:0] in_split$out$008_val;
  wire   [ 175:0] in_split$out$009_msg;
  wire   [   0:0] in_split$out$009_val;
  wire   [   0:0] in_split$in__rdy;

  ValRdySplit_0x3e9b0f76bc7cb9b3 in_split
  (
    .out$000_rdy ( in_split$out$000_rdy ),
    .out$001_rdy ( in_split$out$001_rdy ),
    .out$002_rdy ( in_split$out$002_rdy ),
    .out$003_rdy ( in_split$out$003_rdy ),
    .out$004_rdy ( in_split$out$004_rdy ),
    .out$005_rdy ( in_split$out$005_rdy ),
    .out$006_rdy ( in_split$out$006_rdy ),
    .out$007_rdy ( in_split$out$007_rdy ),
    .out$008_rdy ( in_split$out$008_rdy ),
    .out$009_rdy ( in_split$out$009_rdy ),
    .in__msg     ( in_split$in__msg ),
    .in__val     ( in_split$in__val ),
    .clk         ( in_split$clk ),
    .reset       ( in_split$reset ),
    .out$000_msg ( in_split$out$000_msg ),
    .out$000_val ( in_split$out$000_val ),
    .out$001_msg ( in_split$out$001_msg ),
    .out$001_val ( in_split$out$001_val ),
    .out$002_msg ( in_split$out$002_msg ),
    .out$002_val ( in_split$out$002_val ),
    .out$003_msg ( in_split$out$003_msg ),
    .out$003_val ( in_split$out$003_val ),
    .out$004_msg ( in_split$out$004_msg ),
    .out$004_val ( in_split$out$004_val ),
    .out$005_msg ( in_split$out$005_msg ),
    .out$005_val ( in_split$out$005_val ),
    .out$006_msg ( in_split$out$006_msg ),
    .out$006_val ( in_split$out$006_val ),
    .out$007_msg ( in_split$out$007_msg ),
    .out$007_val ( in_split$out$007_val ),
    .out$008_msg ( in_split$out$008_msg ),
    .out$008_val ( in_split$out$008_val ),
    .out$009_msg ( in_split$out$009_msg ),
    .out$009_val ( in_split$out$009_val ),
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
  assign dut$clk                        = clk;
  assign dut$ctrlregreq_msg             = dut_in_msg$002;
  assign dut$ctrlregreq_val             = dut_in_val$002;
  assign dut$ctrlregresp_rdy            = dut_out_rdy$009;
  assign dut$dmemreq_rdy                = dut_out_rdy$000;
  assign dut$dmemresp_msg               = dut_in_msg$000;
  assign dut$dmemresp_val               = dut_in_val$000;
  assign dut$host_dcachereq_msg         = dut_in_msg$003;
  assign dut$host_dcachereq_val         = dut_in_val$003;
  assign dut$host_dcacheresp_rdy        = dut_out_rdy$002;
  assign dut$host_icachereq_msg         = dut_in_msg$001;
  assign dut$host_icachereq_val         = dut_in_val$001;
  assign dut$host_icacheresp_rdy        = dut_out_rdy$004;
  assign dut$host_mdureq_msg            = dut_in_msg$005;
  assign dut$host_mdureq_val            = dut_in_val$005;
  assign dut$host_mduresp_rdy           = dut_out_rdy$008;
  assign dut$imemreq_rdy                = dut_out_rdy$001;
  assign dut$imemresp_msg               = dut_in_msg$004;
  assign dut$imemresp_val               = dut_in_val$004;
  assign dut$mngr2proc_0_msg            = dut_in_msg$008;
  assign dut$mngr2proc_0_val            = dut_in_val$008;
  assign dut$mngr2proc_1_msg            = dut_in_msg$009;
  assign dut$mngr2proc_1_val            = dut_in_val$009;
  assign dut$mngr2proc_2_msg            = dut_in_msg$006;
  assign dut$mngr2proc_2_val            = dut_in_val$006;
  assign dut$mngr2proc_3_msg            = dut_in_msg$007;
  assign dut$mngr2proc_3_val            = dut_in_val$007;
  assign dut$proc2mngr_0_rdy            = dut_out_rdy$006;
  assign dut$proc2mngr_1_rdy            = dut_out_rdy$007;
  assign dut$proc2mngr_2_rdy            = dut_out_rdy$003;
  assign dut$proc2mngr_3_rdy            = dut_out_rdy$005;
  assign dut$reset                      = reset;
  assign dut_in_msg$000                 = in_q$000$deq_msg;
  assign dut_in_msg$001                 = in_q$001$deq_msg;
  assign dut_in_msg$002                 = in_q$002$deq_msg;
  assign dut_in_msg$003                 = in_q$003$deq_msg;
  assign dut_in_msg$004                 = in_q$004$deq_msg;
  assign dut_in_msg$005                 = in_q$005$deq_msg;
  assign dut_in_msg$006                 = in_q$006$deq_msg;
  assign dut_in_msg$007                 = in_q$007$deq_msg;
  assign dut_in_msg$008                 = in_q$008$deq_msg;
  assign dut_in_msg$009                 = in_q$009$deq_msg;
  assign dut_in_rdy$000                 = dut$dmemresp_rdy;
  assign dut_in_rdy$001                 = dut$host_icachereq_rdy;
  assign dut_in_rdy$002                 = dut$ctrlregreq_rdy;
  assign dut_in_rdy$003                 = dut$host_dcachereq_rdy;
  assign dut_in_rdy$004                 = dut$imemresp_rdy;
  assign dut_in_rdy$005                 = dut$host_mdureq_rdy;
  assign dut_in_rdy$006                 = dut$mngr2proc_2_rdy;
  assign dut_in_rdy$007                 = dut$mngr2proc_3_rdy;
  assign dut_in_rdy$008                 = dut$mngr2proc_0_rdy;
  assign dut_in_rdy$009                 = dut$mngr2proc_1_rdy;
  assign dut_in_val$000                 = in_q$000$deq_val;
  assign dut_in_val$001                 = in_q$001$deq_val;
  assign dut_in_val$002                 = in_q$002$deq_val;
  assign dut_in_val$003                 = in_q$003$deq_val;
  assign dut_in_val$004                 = in_q$004$deq_val;
  assign dut_in_val$005                 = in_q$005$deq_val;
  assign dut_in_val$006                 = in_q$006$deq_val;
  assign dut_in_val$007                 = in_q$007$deq_val;
  assign dut_in_val$008                 = in_q$008$deq_val;
  assign dut_in_val$009                 = in_q$009$deq_val;
  assign dut_out_msg$000                = dut$dmemreq_msg;
  assign dut_out_msg$001                = dut$imemreq_msg;
  assign dut_out_msg$002                = dut$host_dcacheresp_msg;
  assign dut_out_msg$003                = dut$proc2mngr_2_msg;
  assign dut_out_msg$004                = dut$host_icacheresp_msg;
  assign dut_out_msg$005                = dut$proc2mngr_3_msg;
  assign dut_out_msg$006                = dut$proc2mngr_0_msg;
  assign dut_out_msg$007                = dut$proc2mngr_1_msg;
  assign dut_out_msg$008                = dut$host_mduresp_msg;
  assign dut_out_msg$009                = dut$ctrlregresp_msg;
  assign dut_out_rdy$000                = out_merge$in_$000_rdy;
  assign dut_out_rdy$001                = out_merge$in_$001_rdy;
  assign dut_out_rdy$002                = out_merge$in_$002_rdy;
  assign dut_out_rdy$003                = out_merge$in_$003_rdy;
  assign dut_out_rdy$004                = out_merge$in_$004_rdy;
  assign dut_out_rdy$005                = out_merge$in_$005_rdy;
  assign dut_out_rdy$006                = out_merge$in_$006_rdy;
  assign dut_out_rdy$007                = out_merge$in_$007_rdy;
  assign dut_out_rdy$008                = out_merge$in_$008_rdy;
  assign dut_out_rdy$009                = out_merge$in_$009_rdy;
  assign dut_out_val$000                = dut$dmemreq_val;
  assign dut_out_val$001                = dut$imemreq_val;
  assign dut_out_val$002                = dut$host_dcacheresp_val;
  assign dut_out_val$003                = dut$proc2mngr_2_val;
  assign dut_out_val$004                = dut$host_icacheresp_val;
  assign dut_out_val$005                = dut$proc2mngr_3_val;
  assign dut_out_val$006                = dut$proc2mngr_0_val;
  assign dut_out_val$007                = dut$proc2mngr_1_val;
  assign dut_out_val$008                = dut$host_mduresp_val;
  assign dut_out_val$009                = dut$ctrlregresp_val;
  assign in__ack                        = in_reqAckToValRdy$in__ack;
  assign in_deserialize$clk             = clk;
  assign in_deserialize$in__msg         = in_reqAckToValRdy$out_msg;
  assign in_deserialize$in__val         = in_reqAckToValRdy$out_val;
  assign in_deserialize$out_rdy         = in_split$in__rdy;
  assign in_deserialize$reset           = reset;
  assign in_q$000$clk                   = clk;
  assign in_q$000$deq_rdy               = dut_in_rdy$000;
  assign in_q$000$enq_msg               = in_split$out$000_msg[145:0];
  assign in_q$000$enq_val               = in_split$out$000_val;
  assign in_q$000$reset                 = reset;
  assign in_q$001$clk                   = clk;
  assign in_q$001$deq_rdy               = dut_in_rdy$001;
  assign in_q$001$enq_msg               = in_split$out$001_msg[175:0];
  assign in_q$001$enq_val               = in_split$out$001_val;
  assign in_q$001$reset                 = reset;
  assign in_q$002$clk                   = clk;
  assign in_q$002$deq_rdy               = dut_in_rdy$002;
  assign in_q$002$enq_msg               = in_split$out$002_msg[36:0];
  assign in_q$002$enq_val               = in_split$out$002_val;
  assign in_q$002$reset                 = reset;
  assign in_q$003$clk                   = clk;
  assign in_q$003$deq_rdy               = dut_in_rdy$003;
  assign in_q$003$enq_msg               = in_split$out$003_msg[77:0];
  assign in_q$003$enq_val               = in_split$out$003_val;
  assign in_q$003$reset                 = reset;
  assign in_q$004$clk                   = clk;
  assign in_q$004$deq_rdy               = dut_in_rdy$004;
  assign in_q$004$enq_msg               = in_split$out$004_msg[145:0];
  assign in_q$004$enq_val               = in_split$out$004_val;
  assign in_q$004$reset                 = reset;
  assign in_q$005$clk                   = clk;
  assign in_q$005$deq_rdy               = dut_in_rdy$005;
  assign in_q$005$enq_msg               = in_split$out$005_msg[69:0];
  assign in_q$005$enq_val               = in_split$out$005_val;
  assign in_q$005$reset                 = reset;
  assign in_q$006$clk                   = clk;
  assign in_q$006$deq_rdy               = dut_in_rdy$006;
  assign in_q$006$enq_msg               = in_split$out$006_msg[31:0];
  assign in_q$006$enq_val               = in_split$out$006_val;
  assign in_q$006$reset                 = reset;
  assign in_q$007$clk                   = clk;
  assign in_q$007$deq_rdy               = dut_in_rdy$007;
  assign in_q$007$enq_msg               = in_split$out$007_msg[31:0];
  assign in_q$007$enq_val               = in_split$out$007_val;
  assign in_q$007$reset                 = reset;
  assign in_q$008$clk                   = clk;
  assign in_q$008$deq_rdy               = dut_in_rdy$008;
  assign in_q$008$enq_msg               = in_split$out$008_msg[31:0];
  assign in_q$008$enq_val               = in_split$out$008_val;
  assign in_q$008$reset                 = reset;
  assign in_q$009$clk                   = clk;
  assign in_q$009$deq_rdy               = dut_in_rdy$009;
  assign in_q$009$enq_msg               = in_split$out$009_msg[31:0];
  assign in_q$009$enq_val               = in_split$out$009_val;
  assign in_q$009$reset                 = reset;
  assign in_reqAckToValRdy$clk          = clk;
  assign in_reqAckToValRdy$in__msg      = in__msg;
  assign in_reqAckToValRdy$in__req      = in__req;
  assign in_reqAckToValRdy$out_rdy      = in_deserialize$in__rdy;
  assign in_reqAckToValRdy$reset        = reset;
  assign in_split$clk                   = clk;
  assign in_split$in__msg               = in_deserialize$out_msg;
  assign in_split$in__val               = in_deserialize$out_val;
  assign in_split$out$000_rdy           = in_q$000$enq_rdy;
  assign in_split$out$001_rdy           = in_q$001$enq_rdy;
  assign in_split$out$002_rdy           = in_q$002$enq_rdy;
  assign in_split$out$003_rdy           = in_q$003$enq_rdy;
  assign in_split$out$004_rdy           = in_q$004$enq_rdy;
  assign in_split$out$005_rdy           = in_q$005$enq_rdy;
  assign in_split$out$006_rdy           = in_q$006$enq_rdy;
  assign in_split$out$007_rdy           = in_q$007$enq_rdy;
  assign in_split$out$008_rdy           = in_q$008$enq_rdy;
  assign in_split$out$009_rdy           = in_q$009$enq_rdy;
  assign in_split$reset                 = reset;
  assign out_merge$clk                  = clk;
  assign out_merge$in_$000_msg[175:0]   = dut_out_msg$000;
  assign out_merge$in_$000_val          = dut_out_val$000;
  assign out_merge$in_$001_msg[175:0]   = dut_out_msg$001;
  assign out_merge$in_$001_val          = dut_out_val$001;
  assign out_merge$in_$002_msg[175:48]  = 128'd0;
  assign out_merge$in_$002_msg[47:0]    = dut_out_msg$002;
  assign out_merge$in_$002_val          = dut_out_val$002;
  assign out_merge$in_$003_msg[175:32]  = 144'd0;
  assign out_merge$in_$003_msg[31:0]    = dut_out_msg$003;
  assign out_merge$in_$003_val          = dut_out_val$003;
  assign out_merge$in_$004_msg[145:0]   = dut_out_msg$004;
  assign out_merge$in_$004_msg[175:146] = 30'd0;
  assign out_merge$in_$004_val          = dut_out_val$004;
  assign out_merge$in_$005_msg[175:32]  = 144'd0;
  assign out_merge$in_$005_msg[31:0]    = dut_out_msg$005;
  assign out_merge$in_$005_val          = dut_out_val$005;
  assign out_merge$in_$006_msg[175:32]  = 144'd0;
  assign out_merge$in_$006_msg[31:0]    = dut_out_msg$006;
  assign out_merge$in_$006_val          = dut_out_val$006;
  assign out_merge$in_$007_msg[175:32]  = 144'd0;
  assign out_merge$in_$007_msg[31:0]    = dut_out_msg$007;
  assign out_merge$in_$007_val          = dut_out_val$007;
  assign out_merge$in_$008_msg[175:35]  = 141'd0;
  assign out_merge$in_$008_msg[34:0]    = dut_out_msg$008;
  assign out_merge$in_$008_val          = dut_out_val$008;
  assign out_merge$in_$009_msg[175:33]  = 143'd0;
  assign out_merge$in_$009_msg[32:0]    = dut_out_msg$009;
  assign out_merge$in_$009_val          = dut_out_val$009;
  assign out_merge$out_rdy              = out_serialize$in__rdy;
  assign out_merge$reset                = reset;
  assign out_msg                        = out_valRdyToReqAck$out_msg;
  assign out_req                        = out_valRdyToReqAck$out_req;
  assign out_serialize$clk              = clk;
  assign out_serialize$in__msg          = out_merge$out_msg;
  assign out_serialize$in__val          = out_merge$out_val;
  assign out_serialize$out_rdy          = out_valRdyToReqAck$in__rdy;
  assign out_serialize$reset            = reset;
  assign out_valRdyToReqAck$clk         = clk;
  assign out_valRdyToReqAck$in__msg     = out_serialize$out_msg;
  assign out_valRdyToReqAck$in__val     = out_serialize$out_val;
  assign out_valRdyToReqAck$out_ack     = out_ack;
  assign out_valRdyToReqAck$reset       = reset;



endmodule // HostButterfree
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdySerializer_0x4786b4d82317711b
//-----------------------------------------------------------------------------
// dtype_in: 186
// dtype_out: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySerializer_0x4786b4d82317711b
(
  input  wire [   0:0] clk,
  input  wire [ 185:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [   7:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [ 191:0] reg_out;
  wire   [ 191:0] reg_in;


  // register declarations
  reg    [   4:0] counter$in_;
  reg    [   0:0] reg_en;
  reg    [   0:0] state$in_;

  // localparam declarations
  localparam STATE_IDLE = 0;
  localparam STATE_SEND = 1;
  localparam p_nmsgs = 24;

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [   7:0] mux$in_$000;
  wire   [   7:0] mux$in_$001;
  wire   [   7:0] mux$in_$002;
  wire   [   7:0] mux$in_$003;
  wire   [   7:0] mux$in_$004;
  wire   [   7:0] mux$in_$005;
  wire   [   7:0] mux$in_$006;
  wire   [   7:0] mux$in_$007;
  wire   [   7:0] mux$in_$008;
  wire   [   7:0] mux$in_$009;
  wire   [   7:0] mux$in_$010;
  wire   [   7:0] mux$in_$011;
  wire   [   7:0] mux$in_$012;
  wire   [   7:0] mux$in_$013;
  wire   [   7:0] mux$in_$014;
  wire   [   7:0] mux$in_$015;
  wire   [   7:0] mux$in_$016;
  wire   [   7:0] mux$in_$017;
  wire   [   7:0] mux$in_$018;
  wire   [   7:0] mux$in_$019;
  wire   [   7:0] mux$in_$020;
  wire   [   7:0] mux$in_$021;
  wire   [   7:0] mux$in_$022;
  wire   [   7:0] mux$in_$023;
  wire   [   0:0] mux$clk;
  wire   [   4:0] mux$sel;
  wire   [   7:0] mux$out;

  Mux_0x38dea885888b8200 mux
  (
    .reset   ( mux$reset ),
    .in_$000 ( mux$in_$000 ),
    .in_$001 ( mux$in_$001 ),
    .in_$002 ( mux$in_$002 ),
    .in_$003 ( mux$in_$003 ),
    .in_$004 ( mux$in_$004 ),
    .in_$005 ( mux$in_$005 ),
    .in_$006 ( mux$in_$006 ),
    .in_$007 ( mux$in_$007 ),
    .in_$008 ( mux$in_$008 ),
    .in_$009 ( mux$in_$009 ),
    .in_$010 ( mux$in_$010 ),
    .in_$011 ( mux$in_$011 ),
    .in_$012 ( mux$in_$012 ),
    .in_$013 ( mux$in_$013 ),
    .in_$014 ( mux$in_$014 ),
    .in_$015 ( mux$in_$015 ),
    .in_$016 ( mux$in_$016 ),
    .in_$017 ( mux$in_$017 ),
    .in_$018 ( mux$in_$018 ),
    .in_$019 ( mux$in_$019 ),
    .in_$020 ( mux$in_$020 ),
    .in_$021 ( mux$in_$021 ),
    .in_$022 ( mux$in_$022 ),
    .in_$023 ( mux$in_$023 ),
    .clk     ( mux$clk ),
    .sel     ( mux$sel ),
    .out     ( mux$out )
  );

  // state temporaries
  wire   [   0:0] state$reset;
  wire   [   0:0] state$clk;
  wire   [   0:0] state$out;

  RegRst_0x2ce052f8c32c5c39 state
  (
    .reset ( state$reset ),
    .in_   ( state$in_ ),
    .clk   ( state$clk ),
    .out   ( state$out )
  );

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [ 191:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [ 191:0] reg_$out;

  RegEn_0x1a7aaf1e305d27ab reg_
  (
    .reset ( reg_$reset ),
    .in_   ( reg_$in_ ),
    .clk   ( reg_$clk ),
    .en    ( reg_$en ),
    .out   ( reg_$out )
  );

  // counter temporaries
  wire   [   0:0] counter$reset;
  wire   [   0:0] counter$clk;
  wire   [   4:0] counter$out;

  Reg_0x6962a37616d57c7e counter
  (
    .reset ( counter$reset ),
    .in_   ( counter$in_ ),
    .clk   ( counter$clk ),
    .out   ( counter$out )
  );

  // signal connections
  assign counter$clk     = clk;
  assign counter$reset   = reset;
  assign mux$clk         = clk;
  assign mux$in_$000     = reg_out[7:0];
  assign mux$in_$001     = reg_out[15:8];
  assign mux$in_$002     = reg_out[23:16];
  assign mux$in_$003     = reg_out[31:24];
  assign mux$in_$004     = reg_out[39:32];
  assign mux$in_$005     = reg_out[47:40];
  assign mux$in_$006     = reg_out[55:48];
  assign mux$in_$007     = reg_out[63:56];
  assign mux$in_$008     = reg_out[71:64];
  assign mux$in_$009     = reg_out[79:72];
  assign mux$in_$010     = reg_out[87:80];
  assign mux$in_$011     = reg_out[95:88];
  assign mux$in_$012     = reg_out[103:96];
  assign mux$in_$013     = reg_out[111:104];
  assign mux$in_$014     = reg_out[119:112];
  assign mux$in_$015     = reg_out[127:120];
  assign mux$in_$016     = reg_out[135:128];
  assign mux$in_$017     = reg_out[143:136];
  assign mux$in_$018     = reg_out[151:144];
  assign mux$in_$019     = reg_out[159:152];
  assign mux$in_$020     = reg_out[167:160];
  assign mux$in_$021     = reg_out[175:168];
  assign mux$in_$022     = reg_out[183:176];
  assign mux$in_$023     = reg_out[191:184];
  assign mux$reset       = reset;
  assign mux$sel         = counter$out;
  assign out_msg         = mux$out;
  assign reg_$clk        = clk;
  assign reg_$en         = reg_en;
  assign reg_$in_        = reg_in;
  assign reg_$reset      = reset;
  assign reg_in[185:0]   = in__msg;
  assign reg_in[191:186] = 6'd0;
  assign reg_out         = reg_$out;
  assign state$clk       = clk;
  assign state$reset     = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transition():
  //       s.state.in_.value = s.state.out
  //
  //       if   s.state.out == s.STATE_IDLE:
  //         if s.in_.val:
  //           s.state.in_.value = s.STATE_SEND
  //
  //       elif s.state.out == s.STATE_SEND:
  //         if s.out.rdy & (s.counter.out == p_nmsgs-1):
  //           s.state.in_.value = s.STATE_IDLE

  // logic for state_transition()
  always @ (*) begin
    state$in_ = state$out;
    if ((state$out == STATE_IDLE)) begin
      if (in__val) begin
        state$in_ = STATE_SEND;
      end
      else begin
      end
    end
    else begin
      if ((state$out == STATE_SEND)) begin
        if ((out_rdy&(counter$out == (p_nmsgs-1)))) begin
          state$in_ = STATE_IDLE;
        end
        else begin
        end
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_outputs():
  //       s.in_.rdy.value     = 0
  //       s.out.val.value     = 0
  //
  //       s.counter.in_.value = 0
  //       s.reg_en.value      = 0
  //
  //       if s.state.out == s.STATE_IDLE:
  //         s.in_.rdy.value = 1
  //         s.reg_en.value  = 1
  //
  //       elif s.state.out == s.STATE_SEND:
  //         s.out.val.value = 1
  //
  //         if s.out.rdy & (s.counter.out == p_nmsgs-1):
  //           s.counter.in_.value = 0
  //         else:
  //           s.counter.in_.value = s.counter.out + s.out.rdy

  // logic for state_outputs()
  always @ (*) begin
    in__rdy = 0;
    out_val = 0;
    counter$in_ = 0;
    reg_en = 0;
    if ((state$out == STATE_IDLE)) begin
      in__rdy = 1;
      reg_en = 1;
    end
    else begin
      if ((state$out == STATE_SEND)) begin
        out_val = 1;
        if ((out_rdy&(counter$out == (p_nmsgs-1)))) begin
          counter$in_ = 0;
        end
        else begin
          counter$in_ = (counter$out+out_rdy);
        end
      end
      else begin
      end
    end
  end


endmodule // ValRdySerializer_0x4786b4d82317711b
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x38dea885888b8200
//-----------------------------------------------------------------------------
// dtype: 8
// nports: 24
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x38dea885888b8200
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in_$000,
  input  wire [   7:0] in_$010,
  input  wire [   7:0] in_$011,
  input  wire [   7:0] in_$012,
  input  wire [   7:0] in_$013,
  input  wire [   7:0] in_$014,
  input  wire [   7:0] in_$015,
  input  wire [   7:0] in_$016,
  input  wire [   7:0] in_$017,
  input  wire [   7:0] in_$018,
  input  wire [   7:0] in_$019,
  input  wire [   7:0] in_$001,
  input  wire [   7:0] in_$020,
  input  wire [   7:0] in_$021,
  input  wire [   7:0] in_$022,
  input  wire [   7:0] in_$023,
  input  wire [   7:0] in_$002,
  input  wire [   7:0] in_$003,
  input  wire [   7:0] in_$004,
  input  wire [   7:0] in_$005,
  input  wire [   7:0] in_$006,
  input  wire [   7:0] in_$007,
  input  wire [   7:0] in_$008,
  input  wire [   7:0] in_$009,
  output reg  [   7:0] out,
  input  wire [   0:0] reset,
  input  wire [   4:0] sel
);

  // localparam declarations
  localparam nports = 24;


  // array declarations
  wire   [   7:0] in_[0:23];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;
  assign in_[  4] = in_$004;
  assign in_[  5] = in_$005;
  assign in_[  6] = in_$006;
  assign in_[  7] = in_$007;
  assign in_[  8] = in_$008;
  assign in_[  9] = in_$009;
  assign in_[ 10] = in_$010;
  assign in_[ 11] = in_$011;
  assign in_[ 12] = in_$012;
  assign in_[ 13] = in_$013;
  assign in_[ 14] = in_$014;
  assign in_[ 15] = in_$015;
  assign in_[ 16] = in_$016;
  assign in_[ 17] = in_$017;
  assign in_[ 18] = in_$018;
  assign in_[ 19] = in_$019;
  assign in_[ 20] = in_$020;
  assign in_[ 21] = in_$021;
  assign in_[ 22] = in_$022;
  assign in_[ 23] = in_$023;

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


endmodule // Mux_0x38dea885888b8200
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
// RegEn_0x1a7aaf1e305d27ab
//-----------------------------------------------------------------------------
// dtype: 192
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x1a7aaf1e305d27ab
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [ 191:0] in_,
  output reg  [ 191:0] out,
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


endmodule // RegEn_0x1a7aaf1e305d27ab
`default_nettype wire

//-----------------------------------------------------------------------------
// Reg_0x6962a37616d57c7e
//-----------------------------------------------------------------------------
// dtype: 5
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Reg_0x6962a37616d57c7e
(
  input  wire [   0:0] clk,
  input  wire [   4:0] in_,
  output reg  [   4:0] out,
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


endmodule // Reg_0x6962a37616d57c7e
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyDeserializer_0x3af46cc9f334024
//-----------------------------------------------------------------------------
// dtype_in: 8
// dtype_out: 186
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyDeserializer_0x3af46cc9f334024
(
  input  wire [   0:0] clk,
  input  wire [   7:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [ 185:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [ 191:0] reg_out;
  wire   [ 191:0] reg_in;


  // register declarations
  reg    [   4:0] counter$in_;
  reg    [   0:0] reg_en;
  reg    [   0:0] state$in_;

  // localparam declarations
  localparam STATE_RECV = 0;
  localparam STATE_SEND = 1;
  localparam p_nmsgs = 24;

  // state temporaries
  wire   [   0:0] state$reset;
  wire   [   0:0] state$clk;
  wire   [   0:0] state$out;

  RegRst_0x2ce052f8c32c5c39 state
  (
    .reset ( state$reset ),
    .in_   ( state$in_ ),
    .clk   ( state$clk ),
    .out   ( state$out )
  );

  // reg_ temporaries
  wire   [   0:0] reg_$reset;
  wire   [ 191:0] reg_$in_;
  wire   [   0:0] reg_$clk;
  wire   [   0:0] reg_$en;
  wire   [ 191:0] reg_$out;

  RegEn_0x1a7aaf1e305d27ab reg_
  (
    .reset ( reg_$reset ),
    .in_   ( reg_$in_ ),
    .clk   ( reg_$clk ),
    .en    ( reg_$en ),
    .out   ( reg_$out )
  );

  // counter temporaries
  wire   [   0:0] counter$reset;
  wire   [   0:0] counter$clk;
  wire   [   4:0] counter$out;

  RegRst_0x7595e02357c57db5 counter
  (
    .reset ( counter$reset ),
    .in_   ( counter$in_ ),
    .clk   ( counter$clk ),
    .out   ( counter$out )
  );

  // signal connections
  assign counter$clk       = clk;
  assign counter$reset     = reset;
  assign out_msg           = reg_out[185:0];
  assign reg_$clk          = clk;
  assign reg_$en           = reg_en;
  assign reg_$in_[183:0]   = reg_out[191:8];
  assign reg_$in_[191:184] = in__msg;
  assign reg_$reset        = reset;
  assign reg_out           = reg_$out;
  assign state$clk         = clk;
  assign state$reset       = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_transition():
  //       s.state.in_.value = s.state.out
  //
  //       if   s.state.out == s.STATE_RECV:
  //         if s.in_.val & (s.counter.out == p_nmsgs-1):
  //           s.state.in_.value = s.STATE_SEND
  //
  //       elif s.state.out == s.STATE_SEND:
  //         if s.out.rdy:
  //           s.state.in_.value = s.STATE_RECV

  // logic for state_transition()
  always @ (*) begin
    state$in_ = state$out;
    if ((state$out == STATE_RECV)) begin
      if ((in__val&(counter$out == (p_nmsgs-1)))) begin
        state$in_ = STATE_SEND;
      end
      else begin
      end
    end
    else begin
      if ((state$out == STATE_SEND)) begin
        if (out_rdy) begin
          state$in_ = STATE_RECV;
        end
        else begin
        end
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_outputs():
  //       s.in_.rdy.value     = 0
  //       s.out.val.value     = 0
  //
  //       s.counter.in_.value = 0
  //       s.reg_en.value      = 0
  //
  //       if s.state.out == s.STATE_RECV:
  //         s.in_.rdy.value = 1
  //         s.reg_en.value  = s.in_.val
  //
  //         if s.in_.val & (s.counter.out == p_nmsgs-1):
  //           s.counter.in_.value = 0
  //         else:
  //           s.counter.in_.value = s.counter.out + s.in_.val
  //
  //       elif s.state.out == s.STATE_SEND:
  //         s.out.val.value = 1
  //         if ~s.out.rdy:
  //           s.counter.in_.value = s.counter.out

  // logic for state_outputs()
  always @ (*) begin
    in__rdy = 0;
    out_val = 0;
    counter$in_ = 0;
    reg_en = 0;
    if ((state$out == STATE_RECV)) begin
      in__rdy = 1;
      reg_en = in__val;
      if ((in__val&(counter$out == (p_nmsgs-1)))) begin
        counter$in_ = 0;
      end
      else begin
        counter$in_ = (counter$out+in__val);
      end
    end
    else begin
      if ((state$out == STATE_SEND)) begin
        out_val = 1;
        if (~out_rdy) begin
          counter$in_ = counter$out;
        end
        else begin
        end
      end
      else begin
      end
    end
  end


endmodule // ValRdyDeserializer_0x3af46cc9f334024
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
// NormalQueue_0x2f40bb4fbe95aa17
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x2f40bb4fbe95aa17
(
  input  wire [   0:0] clk,
  output wire [ 145:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [ 145:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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
  wire   [ 145:0] dpath$enq_bits;
  wire   [ 145:0] dpath$deq_bits;

  NormalQueueDpath_0x2f40bb4fbe95aa17 dpath
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



endmodule // NormalQueue_0x2f40bb4fbe95aa17
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueCtrl_0x7e615dc0798cc6a5
//-----------------------------------------------------------------------------
// num_entries: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueCtrl_0x7e615dc0798cc6a5
(
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   4:0] num_free_entries,
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
  localparam last_idx = 15;
  localparam num_entries = 16;



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
  // synopsys sync_set_reset "reset"
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


endmodule // NormalQueueCtrl_0x7e615dc0798cc6a5
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x2f40bb4fbe95aa17
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x2f40bb4fbe95aa17
(
  input  wire [   0:0] clk,
  output wire [ 145:0] deq_bits,
  input  wire [ 145:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [ 145:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [ 145:0] queue$rd_data$000;

  RegisterFile_0x28967938e2af7d6c queue
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



endmodule // NormalQueueDpath_0x2f40bb4fbe95aa17
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x28967938e2af7d6c
//-----------------------------------------------------------------------------
// dtype: 146
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x28967938e2af7d6c
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [ 145:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
  input  wire [ 145:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [ 145:0] regs$000;
  wire   [ 145:0] regs$001;
  wire   [ 145:0] regs$002;
  wire   [ 145:0] regs$003;
  wire   [ 145:0] regs$004;
  wire   [ 145:0] regs$005;
  wire   [ 145:0] regs$006;
  wire   [ 145:0] regs$007;
  wire   [ 145:0] regs$008;
  wire   [ 145:0] regs$009;
  wire   [ 145:0] regs$010;
  wire   [ 145:0] regs$011;
  wire   [ 145:0] regs$012;
  wire   [ 145:0] regs$013;
  wire   [ 145:0] regs$014;
  wire   [ 145:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [ 145:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [ 145:0] regs[0:15];
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


endmodule // RegisterFile_0x28967938e2af7d6c
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x3ab90c4e3f034ee7
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x3ab90c4e3f034ee7
(
  input  wire [   0:0] clk,
  output wire [ 175:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [ 175:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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
  wire   [ 175:0] dpath$enq_bits;
  wire   [ 175:0] dpath$deq_bits;

  NormalQueueDpath_0x3ab90c4e3f034ee7 dpath
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



endmodule // NormalQueue_0x3ab90c4e3f034ee7
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x3ab90c4e3f034ee7
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x3ab90c4e3f034ee7
(
  input  wire [   0:0] clk,
  output wire [ 175:0] deq_bits,
  input  wire [ 175:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [ 175:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [ 175:0] queue$rd_data$000;

  RegisterFile_0x171965303b06399e queue
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



endmodule // NormalQueueDpath_0x3ab90c4e3f034ee7
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x171965303b06399e
//-----------------------------------------------------------------------------
// dtype: 176
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x171965303b06399e
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [ 175:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
  input  wire [ 175:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [ 175:0] regs$000;
  wire   [ 175:0] regs$001;
  wire   [ 175:0] regs$002;
  wire   [ 175:0] regs$003;
  wire   [ 175:0] regs$004;
  wire   [ 175:0] regs$005;
  wire   [ 175:0] regs$006;
  wire   [ 175:0] regs$007;
  wire   [ 175:0] regs$008;
  wire   [ 175:0] regs$009;
  wire   [ 175:0] regs$010;
  wire   [ 175:0] regs$011;
  wire   [ 175:0] regs$012;
  wire   [ 175:0] regs$013;
  wire   [ 175:0] regs$014;
  wire   [ 175:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [ 175:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [ 175:0] regs[0:15];
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


endmodule // RegisterFile_0x171965303b06399e
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x60e518ea8d2a340a
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x60e518ea8d2a340a
(
  input  wire [   0:0] clk,
  output wire [  36:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  36:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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
  wire   [  36:0] dpath$enq_bits;
  wire   [  36:0] dpath$deq_bits;

  NormalQueueDpath_0x60e518ea8d2a340a dpath
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



endmodule // NormalQueue_0x60e518ea8d2a340a
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x60e518ea8d2a340a
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x60e518ea8d2a340a
(
  input  wire [   0:0] clk,
  output wire [  36:0] deq_bits,
  input  wire [  36:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [  36:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  36:0] queue$rd_data$000;

  RegisterFile_0x4a0d880832ab3ee1 queue
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



endmodule // NormalQueueDpath_0x60e518ea8d2a340a
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x4a0d880832ab3ee1
//-----------------------------------------------------------------------------
// dtype: 37
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x4a0d880832ab3ee1
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [  36:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
  input  wire [  36:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  36:0] regs$000;
  wire   [  36:0] regs$001;
  wire   [  36:0] regs$002;
  wire   [  36:0] regs$003;
  wire   [  36:0] regs$004;
  wire   [  36:0] regs$005;
  wire   [  36:0] regs$006;
  wire   [  36:0] regs$007;
  wire   [  36:0] regs$008;
  wire   [  36:0] regs$009;
  wire   [  36:0] regs$010;
  wire   [  36:0] regs$011;
  wire   [  36:0] regs$012;
  wire   [  36:0] regs$013;
  wire   [  36:0] regs$014;
  wire   [  36:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  36:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  36:0] regs[0:15];
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


endmodule // RegisterFile_0x4a0d880832ab3ee1
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x591bd2093ecf65eb
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x591bd2093ecf65eb
(
  input  wire [   0:0] clk,
  output wire [  77:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  77:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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
  wire   [  77:0] dpath$enq_bits;
  wire   [  77:0] dpath$deq_bits;

  NormalQueueDpath_0x591bd2093ecf65eb dpath
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



endmodule // NormalQueue_0x591bd2093ecf65eb
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x591bd2093ecf65eb
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x591bd2093ecf65eb
(
  input  wire [   0:0] clk,
  output wire [  77:0] deq_bits,
  input  wire [  77:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [  77:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  77:0] queue$rd_data$000;

  RegisterFile_0x79085f268e4f7cd0 queue
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



endmodule // NormalQueueDpath_0x591bd2093ecf65eb
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x79085f268e4f7cd0
//-----------------------------------------------------------------------------
// dtype: 78
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x79085f268e4f7cd0
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [  77:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
  input  wire [  77:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  77:0] regs$000;
  wire   [  77:0] regs$001;
  wire   [  77:0] regs$002;
  wire   [  77:0] regs$003;
  wire   [  77:0] regs$004;
  wire   [  77:0] regs$005;
  wire   [  77:0] regs$006;
  wire   [  77:0] regs$007;
  wire   [  77:0] regs$008;
  wire   [  77:0] regs$009;
  wire   [  77:0] regs$010;
  wire   [  77:0] regs$011;
  wire   [  77:0] regs$012;
  wire   [  77:0] regs$013;
  wire   [  77:0] regs$014;
  wire   [  77:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  77:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  77:0] regs[0:15];
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


endmodule // RegisterFile_0x79085f268e4f7cd0
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x371e2f8d9e1182c3
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x371e2f8d9e1182c3
(
  input  wire [   0:0] clk,
  output wire [  69:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  69:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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
  wire   [  69:0] dpath$enq_bits;
  wire   [  69:0] dpath$deq_bits;

  NormalQueueDpath_0x371e2f8d9e1182c3 dpath
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



endmodule // NormalQueue_0x371e2f8d9e1182c3
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x371e2f8d9e1182c3
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x371e2f8d9e1182c3
(
  input  wire [   0:0] clk,
  output wire [  69:0] deq_bits,
  input  wire [  69:0] enq_bits,
  input  wire [   3:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   3:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   3:0] queue$rd_addr$000;
  wire   [  69:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   3:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  69:0] queue$rd_data$000;

  RegisterFile_0x70b372422056dcd8 queue
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



endmodule // NormalQueueDpath_0x371e2f8d9e1182c3
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x70b372422056dcd8
//-----------------------------------------------------------------------------
// dtype: 70
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x70b372422056dcd8
(
  input  wire [   0:0] clk,
  input  wire [   3:0] rd_addr$000,
  output wire [  69:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   3:0] wr_addr,
  input  wire [  69:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  69:0] regs$000;
  wire   [  69:0] regs$001;
  wire   [  69:0] regs$002;
  wire   [  69:0] regs$003;
  wire   [  69:0] regs$004;
  wire   [  69:0] regs$005;
  wire   [  69:0] regs$006;
  wire   [  69:0] regs$007;
  wire   [  69:0] regs$008;
  wire   [  69:0] regs$009;
  wire   [  69:0] regs$010;
  wire   [  69:0] regs$011;
  wire   [  69:0] regs$012;
  wire   [  69:0] regs$013;
  wire   [  69:0] regs$014;
  wire   [  69:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  69:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  69:0] regs[0:15];
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


endmodule // RegisterFile_0x70b372422056dcd8
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x761e6db39471549
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x761e6db39471549
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  31:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   4:0] num_free_entries,
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
  wire   [   4:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7e615dc0798cc6a5 ctrl
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

  NormalQueueDpath_0x761e6db39471549 dpath
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



endmodule // NormalQueue_0x761e6db39471549
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x761e6db39471549
//-----------------------------------------------------------------------------
// num_entries: 16
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x761e6db39471549
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

  RegisterFile_0x66d40fda46b4658e queue
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



endmodule // NormalQueueDpath_0x761e6db39471549
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x66d40fda46b4658e
//-----------------------------------------------------------------------------
// dtype: 32
// nregs: 16
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x66d40fda46b4658e
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
  wire   [  31:0] regs$010;
  wire   [  31:0] regs$011;
  wire   [  31:0] regs$012;
  wire   [  31:0] regs$013;
  wire   [  31:0] regs$014;
  wire   [  31:0] regs$015;


  // localparam declarations
  localparam nregs = 16;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  31:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  31:0] regs[0:15];
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


endmodule // RegisterFile_0x66d40fda46b4658e
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdyMerge_0x2543de4f552d5e2b
//-----------------------------------------------------------------------------
// p_nports: 10
// p_nbits: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdyMerge_0x2543de4f552d5e2b
(
  input  wire [   0:0] clk,
  input  wire [ 175:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  input  wire [ 175:0] in_$001_msg,
  output wire [   0:0] in_$001_rdy,
  input  wire [   0:0] in_$001_val,
  input  wire [ 175:0] in_$002_msg,
  output wire [   0:0] in_$002_rdy,
  input  wire [   0:0] in_$002_val,
  input  wire [ 175:0] in_$003_msg,
  output wire [   0:0] in_$003_rdy,
  input  wire [   0:0] in_$003_val,
  input  wire [ 175:0] in_$004_msg,
  output wire [   0:0] in_$004_rdy,
  input  wire [   0:0] in_$004_val,
  input  wire [ 175:0] in_$005_msg,
  output wire [   0:0] in_$005_rdy,
  input  wire [   0:0] in_$005_val,
  input  wire [ 175:0] in_$006_msg,
  output wire [   0:0] in_$006_rdy,
  input  wire [   0:0] in_$006_val,
  input  wire [ 175:0] in_$007_msg,
  output wire [   0:0] in_$007_rdy,
  input  wire [   0:0] in_$007_val,
  input  wire [ 175:0] in_$008_msg,
  output wire [   0:0] in_$008_rdy,
  input  wire [   0:0] in_$008_val,
  input  wire [ 175:0] in_$009_msg,
  output wire [   0:0] in_$009_rdy,
  input  wire [   0:0] in_$009_val,
  output wire [ 185:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   9:0] grants;
  wire   [   9:0] in_val;


  // register declarations
  reg    [   9:0] in_rdy;
  reg    [   9:0] reqs;

  // localparam declarations
  localparam p_nports = 10;

  // mux temporaries
  wire   [   0:0] mux$reset;
  wire   [ 175:0] mux$in_$000;
  wire   [ 175:0] mux$in_$001;
  wire   [ 175:0] mux$in_$002;
  wire   [ 175:0] mux$in_$003;
  wire   [ 175:0] mux$in_$004;
  wire   [ 175:0] mux$in_$005;
  wire   [ 175:0] mux$in_$006;
  wire   [ 175:0] mux$in_$007;
  wire   [ 175:0] mux$in_$008;
  wire   [ 175:0] mux$in_$009;
  wire   [   0:0] mux$clk;
  wire   [   9:0] mux$sel;
  wire   [ 175:0] mux$out;

  Mux_0x5c38b318cac8f45c mux
  (
    .reset   ( mux$reset ),
    .in_$000 ( mux$in_$000 ),
    .in_$001 ( mux$in_$001 ),
    .in_$002 ( mux$in_$002 ),
    .in_$003 ( mux$in_$003 ),
    .in_$004 ( mux$in_$004 ),
    .in_$005 ( mux$in_$005 ),
    .in_$006 ( mux$in_$006 ),
    .in_$007 ( mux$in_$007 ),
    .in_$008 ( mux$in_$008 ),
    .in_$009 ( mux$in_$009 ),
    .clk     ( mux$clk ),
    .sel     ( mux$sel ),
    .out     ( mux$out )
  );

  // arbiter temporaries
  wire   [   9:0] arbiter$reqs;
  wire   [   0:0] arbiter$clk;
  wire   [   0:0] arbiter$reset;
  wire   [   9:0] arbiter$grants;

  RoundRobinArbiter_0x3adf7ff6e05597a1 arbiter
  (
    .reqs   ( arbiter$reqs ),
    .clk    ( arbiter$clk ),
    .reset  ( arbiter$reset ),
    .grants ( arbiter$grants )
  );

  // signal connections
  assign arbiter$clk      = clk;
  assign arbiter$reqs     = reqs;
  assign arbiter$reset    = reset;
  assign grants           = arbiter$grants;
  assign in_$000_rdy      = in_rdy[0];
  assign in_$001_rdy      = in_rdy[1];
  assign in_$002_rdy      = in_rdy[2];
  assign in_$003_rdy      = in_rdy[3];
  assign in_$004_rdy      = in_rdy[4];
  assign in_$005_rdy      = in_rdy[5];
  assign in_$006_rdy      = in_rdy[6];
  assign in_$007_rdy      = in_rdy[7];
  assign in_$008_rdy      = in_rdy[8];
  assign in_$009_rdy      = in_rdy[9];
  assign in_val[0]        = in_$000_val;
  assign in_val[1]        = in_$001_val;
  assign in_val[2]        = in_$002_val;
  assign in_val[3]        = in_$003_val;
  assign in_val[4]        = in_$004_val;
  assign in_val[5]        = in_$005_val;
  assign in_val[6]        = in_$006_val;
  assign in_val[7]        = in_$007_val;
  assign in_val[8]        = in_$008_val;
  assign in_val[9]        = in_$009_val;
  assign mux$clk          = clk;
  assign mux$in_$000      = in_$000_msg;
  assign mux$in_$001      = in_$001_msg;
  assign mux$in_$002      = in_$002_msg;
  assign mux$in_$003      = in_$003_msg;
  assign mux$in_$004      = in_$004_msg;
  assign mux$in_$005      = in_$005_msg;
  assign mux$in_$006      = in_$006_msg;
  assign mux$in_$007      = in_$007_msg;
  assign mux$in_$008      = in_$008_msg;
  assign mux$in_$009      = in_$009_msg;
  assign mux$reset        = reset;
  assign mux$sel          = grants;
  assign out_msg[175:0]   = mux$out;
  assign out_msg[185:176] = grants;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //         s.reqs.value    = s.in_val & sext( s.out.rdy, p_nports )
  //         s.in_rdy.value  = s.grants & sext( s.out.rdy, p_nports )
  //         s.out.val.value = reduce_or( s.reqs & s.in_val )

  // logic for combinational_logic()
  always @ (*) begin
    reqs = (in_val&{ { p_nports-1 { out_rdy[0] } }, out_rdy[0:0] });
    in_rdy = (grants&{ { p_nports-1 { out_rdy[0] } }, out_rdy[0:0] });
    out_val = (|(reqs&in_val));
  end


endmodule // ValRdyMerge_0x2543de4f552d5e2b
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x5c38b318cac8f45c
//-----------------------------------------------------------------------------
// nports: 10
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x5c38b318cac8f45c
(
  input  wire [   0:0] clk,
  input  wire [ 175:0] in_$000,
  input  wire [ 175:0] in_$001,
  input  wire [ 175:0] in_$002,
  input  wire [ 175:0] in_$003,
  input  wire [ 175:0] in_$004,
  input  wire [ 175:0] in_$005,
  input  wire [ 175:0] in_$006,
  input  wire [ 175:0] in_$007,
  input  wire [ 175:0] in_$008,
  input  wire [ 175:0] in_$009,
  output reg  [ 175:0] out,
  input  wire [   0:0] reset,
  input  wire [   9:0] sel
);

  // localparam declarations
  localparam nports = 10;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [ 175:0] in_[0:9];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;
  assign in_[  4] = in_$004;
  assign in_[  5] = in_$005;
  assign in_[  6] = in_$006;
  assign in_[  7] = in_$007;
  assign in_[  8] = in_$008;
  assign in_[  9] = in_$009;

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


endmodule // Mux_0x5c38b318cac8f45c
`default_nettype wire

//-----------------------------------------------------------------------------
// RoundRobinArbiter_0x3adf7ff6e05597a1
//-----------------------------------------------------------------------------
// nreqs: 10
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RoundRobinArbiter_0x3adf7ff6e05597a1
(
  input  wire [   0:0] clk,
  output reg  [   9:0] grants,
  input  wire [   9:0] reqs,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  19:0] grants_int;
  reg    [  20:0] kills;
  reg    [   0:0] priority_en;
  reg    [  19:0] priority_int;
  reg    [  19:0] reqs_int;

  // localparam declarations
  localparam nreqs = 10;
  localparam nreqsX2 = 20;

  // loop variable declarations
  integer i;

  // priority_reg temporaries
  wire   [   0:0] priority_reg$reset;
  wire   [   0:0] priority_reg$en;
  wire   [   0:0] priority_reg$clk;
  wire   [   9:0] priority_reg$in_;
  wire   [   9:0] priority_reg$out;

  RegEnRst_0x3ec4cf214db81cc7 priority_reg
  (
    .reset ( priority_reg$reset ),
    .en    ( priority_reg$en ),
    .clk   ( priority_reg$clk ),
    .in_   ( priority_reg$in_ ),
    .out   ( priority_reg$out )
  );

  // signal connections
  assign priority_reg$clk      = clk;
  assign priority_reg$en       = priority_en;
  assign priority_reg$in_[0]   = grants[9];
  assign priority_reg$in_[9:1] = grants[8:0];
  assign priority_reg$reset    = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb():
  //
  //       s.kills[0].value = 1
  //
  //       s.priority_int[    0:nreqs  ].value = s.priority_reg.out
  //       s.priority_int[nreqs:nreqsX2].value = 0
  //       s.reqs_int    [    0:nreqs  ].value = s.reqs
  //       s.reqs_int    [nreqs:nreqsX2].value = s.reqs
  //
  //       # Calculate the kill chain
  //       for i in range( nreqsX2 ):
  //
  //         # Set internal grants
  //         if s.priority_int[i].value:
  //           s.grants_int[i].value = s.reqs_int[i]
  //         else:
  //           s.grants_int[i].value = ~s.kills[i] & s.reqs_int[i]
  //
  //         # Set kill signals
  //         if s.priority_int[i].value:
  //           s.kills[i+1].value = s.grants_int[i]
  //         else:
  //           s.kills[i+1].value = s.kills[i] | s.grants_int[i]
  //
  //       # Assign the output ports
  //       for i in range( nreqs ):
  //         s.grants[i].value = s.grants_int[i] | s.grants_int[nreqs+i]
  //
  //       # Set the priority enable
  //       s.priority_en.value = ( s.grants != 0 )

  // logic for comb()
  always @ (*) begin
    kills[0] = 1;
    priority_int[(nreqs)-1:0] = priority_reg$out;
    priority_int[(nreqsX2)-1:nreqs] = 0;
    reqs_int[(nreqs)-1:0] = reqs;
    reqs_int[(nreqsX2)-1:nreqs] = reqs;
    for (i=0; i < nreqsX2; i=i+1)
    begin
      if (priority_int[i]) begin
        grants_int[i] = reqs_int[i];
      end
      else begin
        grants_int[i] = (~kills[i]&reqs_int[i]);
      end
      if (priority_int[i]) begin
        kills[(i+1)] = grants_int[i];
      end
      else begin
        kills[(i+1)] = (kills[i]|grants_int[i]);
      end
    end
    for (i=0; i < nreqs; i=i+1)
    begin
      grants[i] = (grants_int[i]|grants_int[(nreqs+i)]);
    end
    priority_en = (grants != 0);
  end


endmodule // RoundRobinArbiter_0x3adf7ff6e05597a1
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x3ec4cf214db81cc7
//-----------------------------------------------------------------------------
// dtype: 10
// reset_value: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x3ec4cf214db81cc7
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   9:0] in_,
  output reg  [   9:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam reset_value = 1;



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


endmodule // RegEnRst_0x3ec4cf214db81cc7
`default_nettype wire

//-----------------------------------------------------------------------------
// Butterfree
//-----------------------------------------------------------------------------
// cacheline_nbits: 128
// word_nbits: 32
// addr_nbits: 32
// mopaque_nbits: 8
// num_cores: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Butterfree
(
  input  wire [   0:0] clk,
  input  wire [  36:0] ctrlregreq_msg,
  output wire [   0:0] ctrlregreq_rdy,
  input  wire [   0:0] ctrlregreq_val,
  output wire [  32:0] ctrlregresp_msg,
  input  wire [   0:0] ctrlregresp_rdy,
  output wire [   0:0] ctrlregresp_val,
  output wire [   0:0] debug,
  output wire [ 175:0] dmemreq_msg,
  input  wire [   0:0] dmemreq_rdy,
  output wire [   0:0] dmemreq_val,
  input  wire [ 145:0] dmemresp_msg,
  output wire [   0:0] dmemresp_rdy,
  input  wire [   0:0] dmemresp_val,
  input  wire [  77:0] host_dcachereq_msg,
  output wire [   0:0] host_dcachereq_rdy,
  input  wire [   0:0] host_dcachereq_val,
  output wire [  47:0] host_dcacheresp_msg,
  input  wire [   0:0] host_dcacheresp_rdy,
  output wire [   0:0] host_dcacheresp_val,
  input  wire [ 175:0] host_icachereq_msg,
  output wire [   0:0] host_icachereq_rdy,
  input  wire [   0:0] host_icachereq_val,
  output wire [ 145:0] host_icacheresp_msg,
  input  wire [   0:0] host_icacheresp_rdy,
  output wire [   0:0] host_icacheresp_val,
  input  wire [  69:0] host_mdureq_msg,
  output wire [   0:0] host_mdureq_rdy,
  input  wire [   0:0] host_mdureq_val,
  output wire [  34:0] host_mduresp_msg,
  input  wire [   0:0] host_mduresp_rdy,
  output wire [   0:0] host_mduresp_val,
  output wire [ 175:0] imemreq_msg,
  input  wire [   0:0] imemreq_rdy,
  output wire [   0:0] imemreq_val,
  input  wire [ 145:0] imemresp_msg,
  output wire [   0:0] imemresp_rdy,
  input  wire [   0:0] imemresp_val,
  input  wire [  31:0] mngr2proc_0_msg,
  output wire [   0:0] mngr2proc_0_rdy,
  input  wire [   0:0] mngr2proc_0_val,
  input  wire [  31:0] mngr2proc_1_msg,
  output wire [   0:0] mngr2proc_1_rdy,
  input  wire [   0:0] mngr2proc_1_val,
  input  wire [  31:0] mngr2proc_2_msg,
  output wire [   0:0] mngr2proc_2_rdy,
  input  wire [   0:0] mngr2proc_2_val,
  input  wire [  31:0] mngr2proc_3_msg,
  output wire [   0:0] mngr2proc_3_rdy,
  input  wire [   0:0] mngr2proc_3_val,
  output wire [  31:0] proc2mngr_0_msg,
  input  wire [   0:0] proc2mngr_0_rdy,
  output wire [   0:0] proc2mngr_0_val,
  output wire [  31:0] proc2mngr_1_msg,
  input  wire [   0:0] proc2mngr_1_rdy,
  output wire [   0:0] proc2mngr_1_val,
  output wire [  31:0] proc2mngr_2_msg,
  input  wire [   0:0] proc2mngr_2_rdy,
  output wire [   0:0] proc2mngr_2_val,
  output wire [  31:0] proc2mngr_3_msg,
  input  wire [   0:0] proc2mngr_3_rdy,
  output wire [   0:0] proc2mngr_3_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] cachereq_go;

  // dcache_adapter temporaries
  wire   [  77:0] dcache_adapter$realreq_msg;
  wire   [   0:0] dcache_adapter$realreq_val;
  wire   [  47:0] dcache_adapter$resp_msg;
  wire   [   0:0] dcache_adapter$resp_val;
  wire   [   0:0] dcache_adapter$clk;
  wire   [  77:0] dcache_adapter$hostreq_msg;
  wire   [   0:0] dcache_adapter$hostreq_val;
  wire   [   0:0] dcache_adapter$req_rdy;
  wire   [   0:0] dcache_adapter$reset;
  wire   [   0:0] dcache_adapter$realresp_rdy;
  wire   [   0:0] dcache_adapter$hostresp_rdy;
  wire   [   0:0] dcache_adapter$host_en;
  wire   [   0:0] dcache_adapter$realreq_rdy;
  wire   [   0:0] dcache_adapter$resp_rdy;
  wire   [   0:0] dcache_adapter$hostreq_rdy;
  wire   [  77:0] dcache_adapter$req_msg;
  wire   [   0:0] dcache_adapter$req_val;
  wire   [  47:0] dcache_adapter$realresp_msg;
  wire   [   0:0] dcache_adapter$realresp_val;
  wire   [  47:0] dcache_adapter$hostresp_msg;
  wire   [   0:0] dcache_adapter$hostresp_val;

  HostAdapter_MemReqMsg_8_32_32_MemRespMsg_8_32 dcache_adapter
  (
    .realreq_msg  ( dcache_adapter$realreq_msg ),
    .realreq_val  ( dcache_adapter$realreq_val ),
    .resp_msg     ( dcache_adapter$resp_msg ),
    .resp_val     ( dcache_adapter$resp_val ),
    .clk          ( dcache_adapter$clk ),
    .hostreq_msg  ( dcache_adapter$hostreq_msg ),
    .hostreq_val  ( dcache_adapter$hostreq_val ),
    .req_rdy      ( dcache_adapter$req_rdy ),
    .reset        ( dcache_adapter$reset ),
    .realresp_rdy ( dcache_adapter$realresp_rdy ),
    .hostresp_rdy ( dcache_adapter$hostresp_rdy ),
    .host_en      ( dcache_adapter$host_en ),
    .realreq_rdy  ( dcache_adapter$realreq_rdy ),
    .resp_rdy     ( dcache_adapter$resp_rdy ),
    .hostreq_rdy  ( dcache_adapter$hostreq_rdy ),
    .req_msg      ( dcache_adapter$req_msg ),
    .req_val      ( dcache_adapter$req_val ),
    .realresp_msg ( dcache_adapter$realresp_msg ),
    .realresp_val ( dcache_adapter$realresp_val ),
    .hostresp_msg ( dcache_adapter$hostresp_msg ),
    .hostresp_val ( dcache_adapter$hostresp_val )
  );

  // net_mdureq temporaries
  wire   [   0:0] net_mdureq$reset;
  wire   [  69:0] net_mdureq$in_$000_msg;
  wire   [   0:0] net_mdureq$in_$000_val;
  wire   [  69:0] net_mdureq$in_$001_msg;
  wire   [   0:0] net_mdureq$in_$001_val;
  wire   [  69:0] net_mdureq$in_$002_msg;
  wire   [   0:0] net_mdureq$in_$002_val;
  wire   [  69:0] net_mdureq$in_$003_msg;
  wire   [   0:0] net_mdureq$in_$003_val;
  wire   [   0:0] net_mdureq$clk;
  wire   [   0:0] net_mdureq$out_rdy;
  wire   [   0:0] net_mdureq$in_$000_rdy;
  wire   [   0:0] net_mdureq$in_$001_rdy;
  wire   [   0:0] net_mdureq$in_$002_rdy;
  wire   [   0:0] net_mdureq$in_$003_rdy;
  wire   [  69:0] net_mdureq$out_msg;
  wire   [   0:0] net_mdureq$out_val;

  Funnel_0x2e5b141dfdfa2078 net_mdureq
  (
    .reset       ( net_mdureq$reset ),
    .in_$000_msg ( net_mdureq$in_$000_msg ),
    .in_$000_val ( net_mdureq$in_$000_val ),
    .in_$001_msg ( net_mdureq$in_$001_msg ),
    .in_$001_val ( net_mdureq$in_$001_val ),
    .in_$002_msg ( net_mdureq$in_$002_msg ),
    .in_$002_val ( net_mdureq$in_$002_val ),
    .in_$003_msg ( net_mdureq$in_$003_msg ),
    .in_$003_val ( net_mdureq$in_$003_val ),
    .clk         ( net_mdureq$clk ),
    .out_rdy     ( net_mdureq$out_rdy ),
    .in_$000_rdy ( net_mdureq$in_$000_rdy ),
    .in_$001_rdy ( net_mdureq$in_$001_rdy ),
    .in_$002_rdy ( net_mdureq$in_$002_rdy ),
    .in_$003_rdy ( net_mdureq$in_$003_rdy ),
    .out_msg     ( net_mdureq$out_msg ),
    .out_val     ( net_mdureq$out_val )
  );

  // net_dcachereq temporaries
  wire   [   0:0] net_dcachereq$reset;
  wire   [  77:0] net_dcachereq$in_$000_msg;
  wire   [   0:0] net_dcachereq$in_$000_val;
  wire   [  77:0] net_dcachereq$in_$001_msg;
  wire   [   0:0] net_dcachereq$in_$001_val;
  wire   [  77:0] net_dcachereq$in_$002_msg;
  wire   [   0:0] net_dcachereq$in_$002_val;
  wire   [  77:0] net_dcachereq$in_$003_msg;
  wire   [   0:0] net_dcachereq$in_$003_val;
  wire   [   0:0] net_dcachereq$clk;
  wire   [   0:0] net_dcachereq$out_rdy;
  wire   [   0:0] net_dcachereq$in_$000_rdy;
  wire   [   0:0] net_dcachereq$in_$001_rdy;
  wire   [   0:0] net_dcachereq$in_$002_rdy;
  wire   [   0:0] net_dcachereq$in_$003_rdy;
  wire   [  77:0] net_dcachereq$out_msg;
  wire   [   0:0] net_dcachereq$out_val;

  Funnel_0x51643a8477790b10 net_dcachereq
  (
    .reset       ( net_dcachereq$reset ),
    .in_$000_msg ( net_dcachereq$in_$000_msg ),
    .in_$000_val ( net_dcachereq$in_$000_val ),
    .in_$001_msg ( net_dcachereq$in_$001_msg ),
    .in_$001_val ( net_dcachereq$in_$001_val ),
    .in_$002_msg ( net_dcachereq$in_$002_msg ),
    .in_$002_val ( net_dcachereq$in_$002_val ),
    .in_$003_msg ( net_dcachereq$in_$003_msg ),
    .in_$003_val ( net_dcachereq$in_$003_val ),
    .clk         ( net_dcachereq$clk ),
    .out_rdy     ( net_dcachereq$out_rdy ),
    .in_$000_rdy ( net_dcachereq$in_$000_rdy ),
    .in_$001_rdy ( net_dcachereq$in_$001_rdy ),
    .in_$002_rdy ( net_dcachereq$in_$002_rdy ),
    .in_$003_rdy ( net_dcachereq$in_$003_rdy ),
    .out_msg     ( net_dcachereq$out_msg ),
    .out_val     ( net_dcachereq$out_val )
  );

  // dcache temporaries
  wire   [ 145:0] dcache$memresp_msg;
  wire   [   0:0] dcache$memresp_val;
  wire   [  77:0] dcache$cachereq_msg;
  wire   [   0:0] dcache$cachereq_val;
  wire   [   0:0] dcache$clk;
  wire   [   0:0] dcache$cacheresp_rdy;
  wire   [   0:0] dcache$reset;
  wire   [   0:0] dcache$memreq_rdy;
  wire   [   0:0] dcache$memresp_rdy;
  wire   [   0:0] dcache$cachereq_rdy;
  wire   [  47:0] dcache$cacheresp_msg;
  wire   [   0:0] dcache$cacheresp_val;
  wire   [ 175:0] dcache$memreq_msg;
  wire   [   0:0] dcache$memreq_val;

  BlockingCachePRTL_0x588be82f2c2ad182 dcache
  (
    .memresp_msg   ( dcache$memresp_msg ),
    .memresp_val   ( dcache$memresp_val ),
    .cachereq_msg  ( dcache$cachereq_msg ),
    .cachereq_val  ( dcache$cachereq_val ),
    .clk           ( dcache$clk ),
    .cacheresp_rdy ( dcache$cacheresp_rdy ),
    .reset         ( dcache$reset ),
    .memreq_rdy    ( dcache$memreq_rdy ),
    .memresp_rdy   ( dcache$memresp_rdy ),
    .cachereq_rdy  ( dcache$cachereq_rdy ),
    .cacheresp_msg ( dcache$cacheresp_msg ),
    .cacheresp_val ( dcache$cacheresp_val ),
    .memreq_msg    ( dcache$memreq_msg ),
    .memreq_val    ( dcache$memreq_val )
  );

  // net_dcacheresp temporaries
  wire   [   0:0] net_dcacheresp$reset;
  wire   [  47:0] net_dcacheresp$in__msg;
  wire   [   0:0] net_dcacheresp$in__val;
  wire   [   0:0] net_dcacheresp$clk;
  wire   [   0:0] net_dcacheresp$out$000_rdy;
  wire   [   0:0] net_dcacheresp$out$001_rdy;
  wire   [   0:0] net_dcacheresp$out$002_rdy;
  wire   [   0:0] net_dcacheresp$out$003_rdy;
  wire   [   0:0] net_dcacheresp$in__rdy;
  wire   [  47:0] net_dcacheresp$out$000_msg;
  wire   [   0:0] net_dcacheresp$out$000_val;
  wire   [  47:0] net_dcacheresp$out$001_msg;
  wire   [   0:0] net_dcacheresp$out$001_val;
  wire   [  47:0] net_dcacheresp$out$002_msg;
  wire   [   0:0] net_dcacheresp$out$002_val;
  wire   [  47:0] net_dcacheresp$out$003_msg;
  wire   [   0:0] net_dcacheresp$out$003_val;

  Router_0x6c4e178e4038f207 net_dcacheresp
  (
    .reset       ( net_dcacheresp$reset ),
    .in__msg     ( net_dcacheresp$in__msg ),
    .in__val     ( net_dcacheresp$in__val ),
    .clk         ( net_dcacheresp$clk ),
    .out$000_rdy ( net_dcacheresp$out$000_rdy ),
    .out$001_rdy ( net_dcacheresp$out$001_rdy ),
    .out$002_rdy ( net_dcacheresp$out$002_rdy ),
    .out$003_rdy ( net_dcacheresp$out$003_rdy ),
    .in__rdy     ( net_dcacheresp$in__rdy ),
    .out$000_msg ( net_dcacheresp$out$000_msg ),
    .out$000_val ( net_dcacheresp$out$000_val ),
    .out$001_msg ( net_dcacheresp$out$001_msg ),
    .out$001_val ( net_dcacheresp$out$001_val ),
    .out$002_msg ( net_dcacheresp$out$002_msg ),
    .out$002_val ( net_dcacheresp$out$002_val ),
    .out$003_msg ( net_dcacheresp$out$003_msg ),
    .out$003_val ( net_dcacheresp$out$003_val )
  );

  // net_mduresp temporaries
  wire   [   0:0] net_mduresp$reset;
  wire   [  34:0] net_mduresp$in__msg;
  wire   [   0:0] net_mduresp$in__val;
  wire   [   0:0] net_mduresp$clk;
  wire   [   0:0] net_mduresp$out$000_rdy;
  wire   [   0:0] net_mduresp$out$001_rdy;
  wire   [   0:0] net_mduresp$out$002_rdy;
  wire   [   0:0] net_mduresp$out$003_rdy;
  wire   [   0:0] net_mduresp$in__rdy;
  wire   [  34:0] net_mduresp$out$000_msg;
  wire   [   0:0] net_mduresp$out$000_val;
  wire   [  34:0] net_mduresp$out$001_msg;
  wire   [   0:0] net_mduresp$out$001_val;
  wire   [  34:0] net_mduresp$out$002_msg;
  wire   [   0:0] net_mduresp$out$002_val;
  wire   [  34:0] net_mduresp$out$003_msg;
  wire   [   0:0] net_mduresp$out$003_val;

  Router_0x4c184f1ee5bd8508 net_mduresp
  (
    .reset       ( net_mduresp$reset ),
    .in__msg     ( net_mduresp$in__msg ),
    .in__val     ( net_mduresp$in__val ),
    .clk         ( net_mduresp$clk ),
    .out$000_rdy ( net_mduresp$out$000_rdy ),
    .out$001_rdy ( net_mduresp$out$001_rdy ),
    .out$002_rdy ( net_mduresp$out$002_rdy ),
    .out$003_rdy ( net_mduresp$out$003_rdy ),
    .in__rdy     ( net_mduresp$in__rdy ),
    .out$000_msg ( net_mduresp$out$000_msg ),
    .out$000_val ( net_mduresp$out$000_val ),
    .out$001_msg ( net_mduresp$out$001_msg ),
    .out$001_val ( net_mduresp$out$001_val ),
    .out$002_msg ( net_mduresp$out$002_msg ),
    .out$002_val ( net_mduresp$out$002_val ),
    .out$003_msg ( net_mduresp$out$003_msg ),
    .out$003_val ( net_mduresp$out$003_val )
  );

  // l0i$000 temporaries
  wire   [ 145:0] l0i$000$memresp_msg;
  wire   [   0:0] l0i$000$memresp_val;
  wire   [   0:0] l0i$000$L0_disable;
  wire   [   0:0] l0i$000$clk;
  wire   [   0:0] l0i$000$buffresp_rdy;
  wire   [   0:0] l0i$000$reset;
  wire   [   0:0] l0i$000$memreq_rdy;
  wire   [  77:0] l0i$000$buffreq_msg;
  wire   [   0:0] l0i$000$buffreq_val;
  wire   [   0:0] l0i$000$memresp_rdy;
  wire   [  47:0] l0i$000$buffresp_msg;
  wire   [   0:0] l0i$000$buffresp_val;
  wire   [ 175:0] l0i$000$memreq_msg;
  wire   [   0:0] l0i$000$memreq_val;
  wire   [   0:0] l0i$000$buffreq_rdy;

  InstBuffer_2_16B l0i$000
  (
    .memresp_msg  ( l0i$000$memresp_msg ),
    .memresp_val  ( l0i$000$memresp_val ),
    .L0_disable   ( l0i$000$L0_disable ),
    .clk          ( l0i$000$clk ),
    .buffresp_rdy ( l0i$000$buffresp_rdy ),
    .reset        ( l0i$000$reset ),
    .memreq_rdy   ( l0i$000$memreq_rdy ),
    .buffreq_msg  ( l0i$000$buffreq_msg ),
    .buffreq_val  ( l0i$000$buffreq_val ),
    .memresp_rdy  ( l0i$000$memresp_rdy ),
    .buffresp_msg ( l0i$000$buffresp_msg ),
    .buffresp_val ( l0i$000$buffresp_val ),
    .memreq_msg   ( l0i$000$memreq_msg ),
    .memreq_val   ( l0i$000$memreq_val ),
    .buffreq_rdy  ( l0i$000$buffreq_rdy )
  );

  // l0i$001 temporaries
  wire   [ 145:0] l0i$001$memresp_msg;
  wire   [   0:0] l0i$001$memresp_val;
  wire   [   0:0] l0i$001$L0_disable;
  wire   [   0:0] l0i$001$clk;
  wire   [   0:0] l0i$001$buffresp_rdy;
  wire   [   0:0] l0i$001$reset;
  wire   [   0:0] l0i$001$memreq_rdy;
  wire   [  77:0] l0i$001$buffreq_msg;
  wire   [   0:0] l0i$001$buffreq_val;
  wire   [   0:0] l0i$001$memresp_rdy;
  wire   [  47:0] l0i$001$buffresp_msg;
  wire   [   0:0] l0i$001$buffresp_val;
  wire   [ 175:0] l0i$001$memreq_msg;
  wire   [   0:0] l0i$001$memreq_val;
  wire   [   0:0] l0i$001$buffreq_rdy;

  InstBuffer_2_16B l0i$001
  (
    .memresp_msg  ( l0i$001$memresp_msg ),
    .memresp_val  ( l0i$001$memresp_val ),
    .L0_disable   ( l0i$001$L0_disable ),
    .clk          ( l0i$001$clk ),
    .buffresp_rdy ( l0i$001$buffresp_rdy ),
    .reset        ( l0i$001$reset ),
    .memreq_rdy   ( l0i$001$memreq_rdy ),
    .buffreq_msg  ( l0i$001$buffreq_msg ),
    .buffreq_val  ( l0i$001$buffreq_val ),
    .memresp_rdy  ( l0i$001$memresp_rdy ),
    .buffresp_msg ( l0i$001$buffresp_msg ),
    .buffresp_val ( l0i$001$buffresp_val ),
    .memreq_msg   ( l0i$001$memreq_msg ),
    .memreq_val   ( l0i$001$memreq_val ),
    .buffreq_rdy  ( l0i$001$buffreq_rdy )
  );

  // l0i$002 temporaries
  wire   [ 145:0] l0i$002$memresp_msg;
  wire   [   0:0] l0i$002$memresp_val;
  wire   [   0:0] l0i$002$L0_disable;
  wire   [   0:0] l0i$002$clk;
  wire   [   0:0] l0i$002$buffresp_rdy;
  wire   [   0:0] l0i$002$reset;
  wire   [   0:0] l0i$002$memreq_rdy;
  wire   [  77:0] l0i$002$buffreq_msg;
  wire   [   0:0] l0i$002$buffreq_val;
  wire   [   0:0] l0i$002$memresp_rdy;
  wire   [  47:0] l0i$002$buffresp_msg;
  wire   [   0:0] l0i$002$buffresp_val;
  wire   [ 175:0] l0i$002$memreq_msg;
  wire   [   0:0] l0i$002$memreq_val;
  wire   [   0:0] l0i$002$buffreq_rdy;

  InstBuffer_2_16B l0i$002
  (
    .memresp_msg  ( l0i$002$memresp_msg ),
    .memresp_val  ( l0i$002$memresp_val ),
    .L0_disable   ( l0i$002$L0_disable ),
    .clk          ( l0i$002$clk ),
    .buffresp_rdy ( l0i$002$buffresp_rdy ),
    .reset        ( l0i$002$reset ),
    .memreq_rdy   ( l0i$002$memreq_rdy ),
    .buffreq_msg  ( l0i$002$buffreq_msg ),
    .buffreq_val  ( l0i$002$buffreq_val ),
    .memresp_rdy  ( l0i$002$memresp_rdy ),
    .buffresp_msg ( l0i$002$buffresp_msg ),
    .buffresp_val ( l0i$002$buffresp_val ),
    .memreq_msg   ( l0i$002$memreq_msg ),
    .memreq_val   ( l0i$002$memreq_val ),
    .buffreq_rdy  ( l0i$002$buffreq_rdy )
  );

  // l0i$003 temporaries
  wire   [ 145:0] l0i$003$memresp_msg;
  wire   [   0:0] l0i$003$memresp_val;
  wire   [   0:0] l0i$003$L0_disable;
  wire   [   0:0] l0i$003$clk;
  wire   [   0:0] l0i$003$buffresp_rdy;
  wire   [   0:0] l0i$003$reset;
  wire   [   0:0] l0i$003$memreq_rdy;
  wire   [  77:0] l0i$003$buffreq_msg;
  wire   [   0:0] l0i$003$buffreq_val;
  wire   [   0:0] l0i$003$memresp_rdy;
  wire   [  47:0] l0i$003$buffresp_msg;
  wire   [   0:0] l0i$003$buffresp_val;
  wire   [ 175:0] l0i$003$memreq_msg;
  wire   [   0:0] l0i$003$memreq_val;
  wire   [   0:0] l0i$003$buffreq_rdy;

  InstBuffer_2_16B l0i$003
  (
    .memresp_msg  ( l0i$003$memresp_msg ),
    .memresp_val  ( l0i$003$memresp_val ),
    .L0_disable   ( l0i$003$L0_disable ),
    .clk          ( l0i$003$clk ),
    .buffresp_rdy ( l0i$003$buffresp_rdy ),
    .reset        ( l0i$003$reset ),
    .memreq_rdy   ( l0i$003$memreq_rdy ),
    .buffreq_msg  ( l0i$003$buffreq_msg ),
    .buffreq_val  ( l0i$003$buffreq_val ),
    .memresp_rdy  ( l0i$003$memresp_rdy ),
    .buffresp_msg ( l0i$003$buffresp_msg ),
    .buffresp_val ( l0i$003$buffresp_val ),
    .memreq_msg   ( l0i$003$memreq_msg ),
    .memreq_val   ( l0i$003$memreq_val ),
    .buffreq_rdy  ( l0i$003$buffreq_rdy )
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

  // proc$000 temporaries
  wire   [   0:0] proc$000$dmemreq_rdy;
  wire   [   0:0] proc$000$xcelreq_rdy;
  wire   [  34:0] proc$000$mduresp_msg;
  wire   [   0:0] proc$000$mduresp_val;
  wire   [   0:0] proc$000$imemreq_rdy;
  wire   [   0:0] proc$000$go;
  wire   [  47:0] proc$000$dmemresp_msg;
  wire   [   0:0] proc$000$dmemresp_val;
  wire   [   0:0] proc$000$clk;
  wire   [   0:0] proc$000$proc2mngr_rdy;
  wire   [  47:0] proc$000$imemresp_msg;
  wire   [   0:0] proc$000$imemresp_val;
  wire   [   0:0] proc$000$reset;
  wire   [  32:0] proc$000$xcelresp_msg;
  wire   [   0:0] proc$000$xcelresp_val;
  wire   [  31:0] proc$000$core_id;
  wire   [   0:0] proc$000$mdureq_rdy;
  wire   [  31:0] proc$000$mngr2proc_msg;
  wire   [   0:0] proc$000$mngr2proc_val;
  wire   [  77:0] proc$000$dmemreq_msg;
  wire   [   0:0] proc$000$dmemreq_val;
  wire   [  37:0] proc$000$xcelreq_msg;
  wire   [   0:0] proc$000$xcelreq_val;
  wire   [   0:0] proc$000$commit_inst;
  wire   [   0:0] proc$000$mduresp_rdy;
  wire   [  77:0] proc$000$imemreq_msg;
  wire   [   0:0] proc$000$imemreq_val;
  wire   [   0:0] proc$000$dmemresp_rdy;
  wire   [  31:0] proc$000$proc2mngr_msg;
  wire   [   0:0] proc$000$proc2mngr_val;
  wire   [   0:0] proc$000$imemresp_rdy;
  wire   [   0:0] proc$000$xcelresp_rdy;
  wire   [  69:0] proc$000$mdureq_msg;
  wire   [   0:0] proc$000$mdureq_val;
  wire   [   0:0] proc$000$mngr2proc_rdy;
  wire   [   0:0] proc$000$stats_en;

  ProcPRTL_0x1202655511af6cc5 proc$000
  (
    .dmemreq_rdy   ( proc$000$dmemreq_rdy ),
    .xcelreq_rdy   ( proc$000$xcelreq_rdy ),
    .mduresp_msg   ( proc$000$mduresp_msg ),
    .mduresp_val   ( proc$000$mduresp_val ),
    .imemreq_rdy   ( proc$000$imemreq_rdy ),
    .go            ( proc$000$go ),
    .dmemresp_msg  ( proc$000$dmemresp_msg ),
    .dmemresp_val  ( proc$000$dmemresp_val ),
    .clk           ( proc$000$clk ),
    .proc2mngr_rdy ( proc$000$proc2mngr_rdy ),
    .imemresp_msg  ( proc$000$imemresp_msg ),
    .imemresp_val  ( proc$000$imemresp_val ),
    .reset         ( proc$000$reset ),
    .xcelresp_msg  ( proc$000$xcelresp_msg ),
    .xcelresp_val  ( proc$000$xcelresp_val ),
    .core_id       ( proc$000$core_id ),
    .mdureq_rdy    ( proc$000$mdureq_rdy ),
    .mngr2proc_msg ( proc$000$mngr2proc_msg ),
    .mngr2proc_val ( proc$000$mngr2proc_val ),
    .dmemreq_msg   ( proc$000$dmemreq_msg ),
    .dmemreq_val   ( proc$000$dmemreq_val ),
    .xcelreq_msg   ( proc$000$xcelreq_msg ),
    .xcelreq_val   ( proc$000$xcelreq_val ),
    .commit_inst   ( proc$000$commit_inst ),
    .mduresp_rdy   ( proc$000$mduresp_rdy ),
    .imemreq_msg   ( proc$000$imemreq_msg ),
    .imemreq_val   ( proc$000$imemreq_val ),
    .dmemresp_rdy  ( proc$000$dmemresp_rdy ),
    .proc2mngr_msg ( proc$000$proc2mngr_msg ),
    .proc2mngr_val ( proc$000$proc2mngr_val ),
    .imemresp_rdy  ( proc$000$imemresp_rdy ),
    .xcelresp_rdy  ( proc$000$xcelresp_rdy ),
    .mdureq_msg    ( proc$000$mdureq_msg ),
    .mdureq_val    ( proc$000$mdureq_val ),
    .mngr2proc_rdy ( proc$000$mngr2proc_rdy ),
    .stats_en      ( proc$000$stats_en )
  );

  // proc$001 temporaries
  wire   [   0:0] proc$001$dmemreq_rdy;
  wire   [   0:0] proc$001$xcelreq_rdy;
  wire   [  34:0] proc$001$mduresp_msg;
  wire   [   0:0] proc$001$mduresp_val;
  wire   [   0:0] proc$001$imemreq_rdy;
  wire   [   0:0] proc$001$go;
  wire   [  47:0] proc$001$dmemresp_msg;
  wire   [   0:0] proc$001$dmemresp_val;
  wire   [   0:0] proc$001$clk;
  wire   [   0:0] proc$001$proc2mngr_rdy;
  wire   [  47:0] proc$001$imemresp_msg;
  wire   [   0:0] proc$001$imemresp_val;
  wire   [   0:0] proc$001$reset;
  wire   [  32:0] proc$001$xcelresp_msg;
  wire   [   0:0] proc$001$xcelresp_val;
  wire   [  31:0] proc$001$core_id;
  wire   [   0:0] proc$001$mdureq_rdy;
  wire   [  31:0] proc$001$mngr2proc_msg;
  wire   [   0:0] proc$001$mngr2proc_val;
  wire   [  77:0] proc$001$dmemreq_msg;
  wire   [   0:0] proc$001$dmemreq_val;
  wire   [  37:0] proc$001$xcelreq_msg;
  wire   [   0:0] proc$001$xcelreq_val;
  wire   [   0:0] proc$001$commit_inst;
  wire   [   0:0] proc$001$mduresp_rdy;
  wire   [  77:0] proc$001$imemreq_msg;
  wire   [   0:0] proc$001$imemreq_val;
  wire   [   0:0] proc$001$dmemresp_rdy;
  wire   [  31:0] proc$001$proc2mngr_msg;
  wire   [   0:0] proc$001$proc2mngr_val;
  wire   [   0:0] proc$001$imemresp_rdy;
  wire   [   0:0] proc$001$xcelresp_rdy;
  wire   [  69:0] proc$001$mdureq_msg;
  wire   [   0:0] proc$001$mdureq_val;
  wire   [   0:0] proc$001$mngr2proc_rdy;
  wire   [   0:0] proc$001$stats_en;

  ProcPRTL_0x1202655511af6cc5 proc$001
  (
    .dmemreq_rdy   ( proc$001$dmemreq_rdy ),
    .xcelreq_rdy   ( proc$001$xcelreq_rdy ),
    .mduresp_msg   ( proc$001$mduresp_msg ),
    .mduresp_val   ( proc$001$mduresp_val ),
    .imemreq_rdy   ( proc$001$imemreq_rdy ),
    .go            ( proc$001$go ),
    .dmemresp_msg  ( proc$001$dmemresp_msg ),
    .dmemresp_val  ( proc$001$dmemresp_val ),
    .clk           ( proc$001$clk ),
    .proc2mngr_rdy ( proc$001$proc2mngr_rdy ),
    .imemresp_msg  ( proc$001$imemresp_msg ),
    .imemresp_val  ( proc$001$imemresp_val ),
    .reset         ( proc$001$reset ),
    .xcelresp_msg  ( proc$001$xcelresp_msg ),
    .xcelresp_val  ( proc$001$xcelresp_val ),
    .core_id       ( proc$001$core_id ),
    .mdureq_rdy    ( proc$001$mdureq_rdy ),
    .mngr2proc_msg ( proc$001$mngr2proc_msg ),
    .mngr2proc_val ( proc$001$mngr2proc_val ),
    .dmemreq_msg   ( proc$001$dmemreq_msg ),
    .dmemreq_val   ( proc$001$dmemreq_val ),
    .xcelreq_msg   ( proc$001$xcelreq_msg ),
    .xcelreq_val   ( proc$001$xcelreq_val ),
    .commit_inst   ( proc$001$commit_inst ),
    .mduresp_rdy   ( proc$001$mduresp_rdy ),
    .imemreq_msg   ( proc$001$imemreq_msg ),
    .imemreq_val   ( proc$001$imemreq_val ),
    .dmemresp_rdy  ( proc$001$dmemresp_rdy ),
    .proc2mngr_msg ( proc$001$proc2mngr_msg ),
    .proc2mngr_val ( proc$001$proc2mngr_val ),
    .imemresp_rdy  ( proc$001$imemresp_rdy ),
    .xcelresp_rdy  ( proc$001$xcelresp_rdy ),
    .mdureq_msg    ( proc$001$mdureq_msg ),
    .mdureq_val    ( proc$001$mdureq_val ),
    .mngr2proc_rdy ( proc$001$mngr2proc_rdy ),
    .stats_en      ( proc$001$stats_en )
  );

  // proc$002 temporaries
  wire   [   0:0] proc$002$dmemreq_rdy;
  wire   [   0:0] proc$002$xcelreq_rdy;
  wire   [  34:0] proc$002$mduresp_msg;
  wire   [   0:0] proc$002$mduresp_val;
  wire   [   0:0] proc$002$imemreq_rdy;
  wire   [   0:0] proc$002$go;
  wire   [  47:0] proc$002$dmemresp_msg;
  wire   [   0:0] proc$002$dmemresp_val;
  wire   [   0:0] proc$002$clk;
  wire   [   0:0] proc$002$proc2mngr_rdy;
  wire   [  47:0] proc$002$imemresp_msg;
  wire   [   0:0] proc$002$imemresp_val;
  wire   [   0:0] proc$002$reset;
  wire   [  32:0] proc$002$xcelresp_msg;
  wire   [   0:0] proc$002$xcelresp_val;
  wire   [  31:0] proc$002$core_id;
  wire   [   0:0] proc$002$mdureq_rdy;
  wire   [  31:0] proc$002$mngr2proc_msg;
  wire   [   0:0] proc$002$mngr2proc_val;
  wire   [  77:0] proc$002$dmemreq_msg;
  wire   [   0:0] proc$002$dmemreq_val;
  wire   [  37:0] proc$002$xcelreq_msg;
  wire   [   0:0] proc$002$xcelreq_val;
  wire   [   0:0] proc$002$commit_inst;
  wire   [   0:0] proc$002$mduresp_rdy;
  wire   [  77:0] proc$002$imemreq_msg;
  wire   [   0:0] proc$002$imemreq_val;
  wire   [   0:0] proc$002$dmemresp_rdy;
  wire   [  31:0] proc$002$proc2mngr_msg;
  wire   [   0:0] proc$002$proc2mngr_val;
  wire   [   0:0] proc$002$imemresp_rdy;
  wire   [   0:0] proc$002$xcelresp_rdy;
  wire   [  69:0] proc$002$mdureq_msg;
  wire   [   0:0] proc$002$mdureq_val;
  wire   [   0:0] proc$002$mngr2proc_rdy;
  wire   [   0:0] proc$002$stats_en;

  ProcPRTL_0x1202655511af6cc5 proc$002
  (
    .dmemreq_rdy   ( proc$002$dmemreq_rdy ),
    .xcelreq_rdy   ( proc$002$xcelreq_rdy ),
    .mduresp_msg   ( proc$002$mduresp_msg ),
    .mduresp_val   ( proc$002$mduresp_val ),
    .imemreq_rdy   ( proc$002$imemreq_rdy ),
    .go            ( proc$002$go ),
    .dmemresp_msg  ( proc$002$dmemresp_msg ),
    .dmemresp_val  ( proc$002$dmemresp_val ),
    .clk           ( proc$002$clk ),
    .proc2mngr_rdy ( proc$002$proc2mngr_rdy ),
    .imemresp_msg  ( proc$002$imemresp_msg ),
    .imemresp_val  ( proc$002$imemresp_val ),
    .reset         ( proc$002$reset ),
    .xcelresp_msg  ( proc$002$xcelresp_msg ),
    .xcelresp_val  ( proc$002$xcelresp_val ),
    .core_id       ( proc$002$core_id ),
    .mdureq_rdy    ( proc$002$mdureq_rdy ),
    .mngr2proc_msg ( proc$002$mngr2proc_msg ),
    .mngr2proc_val ( proc$002$mngr2proc_val ),
    .dmemreq_msg   ( proc$002$dmemreq_msg ),
    .dmemreq_val   ( proc$002$dmemreq_val ),
    .xcelreq_msg   ( proc$002$xcelreq_msg ),
    .xcelreq_val   ( proc$002$xcelreq_val ),
    .commit_inst   ( proc$002$commit_inst ),
    .mduresp_rdy   ( proc$002$mduresp_rdy ),
    .imemreq_msg   ( proc$002$imemreq_msg ),
    .imemreq_val   ( proc$002$imemreq_val ),
    .dmemresp_rdy  ( proc$002$dmemresp_rdy ),
    .proc2mngr_msg ( proc$002$proc2mngr_msg ),
    .proc2mngr_val ( proc$002$proc2mngr_val ),
    .imemresp_rdy  ( proc$002$imemresp_rdy ),
    .xcelresp_rdy  ( proc$002$xcelresp_rdy ),
    .mdureq_msg    ( proc$002$mdureq_msg ),
    .mdureq_val    ( proc$002$mdureq_val ),
    .mngr2proc_rdy ( proc$002$mngr2proc_rdy ),
    .stats_en      ( proc$002$stats_en )
  );

  // proc$003 temporaries
  wire   [   0:0] proc$003$dmemreq_rdy;
  wire   [   0:0] proc$003$xcelreq_rdy;
  wire   [  34:0] proc$003$mduresp_msg;
  wire   [   0:0] proc$003$mduresp_val;
  wire   [   0:0] proc$003$imemreq_rdy;
  wire   [   0:0] proc$003$go;
  wire   [  47:0] proc$003$dmemresp_msg;
  wire   [   0:0] proc$003$dmemresp_val;
  wire   [   0:0] proc$003$clk;
  wire   [   0:0] proc$003$proc2mngr_rdy;
  wire   [  47:0] proc$003$imemresp_msg;
  wire   [   0:0] proc$003$imemresp_val;
  wire   [   0:0] proc$003$reset;
  wire   [  32:0] proc$003$xcelresp_msg;
  wire   [   0:0] proc$003$xcelresp_val;
  wire   [  31:0] proc$003$core_id;
  wire   [   0:0] proc$003$mdureq_rdy;
  wire   [  31:0] proc$003$mngr2proc_msg;
  wire   [   0:0] proc$003$mngr2proc_val;
  wire   [  77:0] proc$003$dmemreq_msg;
  wire   [   0:0] proc$003$dmemreq_val;
  wire   [  37:0] proc$003$xcelreq_msg;
  wire   [   0:0] proc$003$xcelreq_val;
  wire   [   0:0] proc$003$commit_inst;
  wire   [   0:0] proc$003$mduresp_rdy;
  wire   [  77:0] proc$003$imemreq_msg;
  wire   [   0:0] proc$003$imemreq_val;
  wire   [   0:0] proc$003$dmemresp_rdy;
  wire   [  31:0] proc$003$proc2mngr_msg;
  wire   [   0:0] proc$003$proc2mngr_val;
  wire   [   0:0] proc$003$imemresp_rdy;
  wire   [   0:0] proc$003$xcelresp_rdy;
  wire   [  69:0] proc$003$mdureq_msg;
  wire   [   0:0] proc$003$mdureq_val;
  wire   [   0:0] proc$003$mngr2proc_rdy;
  wire   [   0:0] proc$003$stats_en;

  ProcPRTL_0x1202655511af6cc5 proc$003
  (
    .dmemreq_rdy   ( proc$003$dmemreq_rdy ),
    .xcelreq_rdy   ( proc$003$xcelreq_rdy ),
    .mduresp_msg   ( proc$003$mduresp_msg ),
    .mduresp_val   ( proc$003$mduresp_val ),
    .imemreq_rdy   ( proc$003$imemreq_rdy ),
    .go            ( proc$003$go ),
    .dmemresp_msg  ( proc$003$dmemresp_msg ),
    .dmemresp_val  ( proc$003$dmemresp_val ),
    .clk           ( proc$003$clk ),
    .proc2mngr_rdy ( proc$003$proc2mngr_rdy ),
    .imemresp_msg  ( proc$003$imemresp_msg ),
    .imemresp_val  ( proc$003$imemresp_val ),
    .reset         ( proc$003$reset ),
    .xcelresp_msg  ( proc$003$xcelresp_msg ),
    .xcelresp_val  ( proc$003$xcelresp_val ),
    .core_id       ( proc$003$core_id ),
    .mdureq_rdy    ( proc$003$mdureq_rdy ),
    .mngr2proc_msg ( proc$003$mngr2proc_msg ),
    .mngr2proc_val ( proc$003$mngr2proc_val ),
    .dmemreq_msg   ( proc$003$dmemreq_msg ),
    .dmemreq_val   ( proc$003$dmemreq_val ),
    .xcelreq_msg   ( proc$003$xcelreq_msg ),
    .xcelreq_val   ( proc$003$xcelreq_val ),
    .commit_inst   ( proc$003$commit_inst ),
    .mduresp_rdy   ( proc$003$mduresp_rdy ),
    .imemreq_msg   ( proc$003$imemreq_msg ),
    .imemreq_val   ( proc$003$imemreq_val ),
    .dmemresp_rdy  ( proc$003$dmemresp_rdy ),
    .proc2mngr_msg ( proc$003$proc2mngr_msg ),
    .proc2mngr_val ( proc$003$proc2mngr_val ),
    .imemresp_rdy  ( proc$003$imemresp_rdy ),
    .xcelresp_rdy  ( proc$003$xcelresp_rdy ),
    .mdureq_msg    ( proc$003$mdureq_msg ),
    .mdureq_val    ( proc$003$mdureq_val ),
    .mngr2proc_rdy ( proc$003$mngr2proc_rdy ),
    .stats_en      ( proc$003$stats_en )
  );

  // icache temporaries
  wire   [ 145:0] icache$memresp_msg;
  wire   [   0:0] icache$memresp_val;
  wire   [ 175:0] icache$cachereq_msg;
  wire   [   0:0] icache$cachereq_val;
  wire   [   0:0] icache$clk;
  wire   [   0:0] icache$cacheresp_rdy;
  wire   [   0:0] icache$reset;
  wire   [   0:0] icache$memreq_rdy;
  wire   [   0:0] icache$memresp_rdy;
  wire   [   0:0] icache$cachereq_rdy;
  wire   [ 145:0] icache$cacheresp_msg;
  wire   [   0:0] icache$cacheresp_val;
  wire   [ 175:0] icache$memreq_msg;
  wire   [   0:0] icache$memreq_val;

  BlockingCachePRTL_0x26ef3bd22367566d icache
  (
    .memresp_msg   ( icache$memresp_msg ),
    .memresp_val   ( icache$memresp_val ),
    .cachereq_msg  ( icache$cachereq_msg ),
    .cachereq_val  ( icache$cachereq_val ),
    .clk           ( icache$clk ),
    .cacheresp_rdy ( icache$cacheresp_rdy ),
    .reset         ( icache$reset ),
    .memreq_rdy    ( icache$memreq_rdy ),
    .memresp_rdy   ( icache$memresp_rdy ),
    .cachereq_rdy  ( icache$cachereq_rdy ),
    .cacheresp_msg ( icache$cacheresp_msg ),
    .cacheresp_val ( icache$cacheresp_val ),
    .memreq_msg    ( icache$memreq_msg ),
    .memreq_val    ( icache$memreq_val )
  );

  // xcel$000 temporaries
  wire   [  37:0] xcel$000$xcelreq_msg;
  wire   [   0:0] xcel$000$xcelreq_val;
  wire   [   0:0] xcel$000$clk;
  wire   [   0:0] xcel$000$reset;
  wire   [   0:0] xcel$000$xcelresp_rdy;
  wire   [  77:0] xcel$000$memreq_snoop_msg;
  wire   [   0:0] xcel$000$memreq_snoop_val;
  wire   [   0:0] xcel$000$xcelreq_rdy;
  wire   [  32:0] xcel$000$xcelresp_msg;
  wire   [   0:0] xcel$000$xcelresp_val;
  wire   [   0:0] xcel$000$memreq_snoop_rdy;

  BloomFilterXcel_0x6aa8c82a20a95749 xcel$000
  (
    .xcelreq_msg      ( xcel$000$xcelreq_msg ),
    .xcelreq_val      ( xcel$000$xcelreq_val ),
    .clk              ( xcel$000$clk ),
    .reset            ( xcel$000$reset ),
    .xcelresp_rdy     ( xcel$000$xcelresp_rdy ),
    .memreq_snoop_msg ( xcel$000$memreq_snoop_msg ),
    .memreq_snoop_val ( xcel$000$memreq_snoop_val ),
    .xcelreq_rdy      ( xcel$000$xcelreq_rdy ),
    .xcelresp_msg     ( xcel$000$xcelresp_msg ),
    .xcelresp_val     ( xcel$000$xcelresp_val ),
    .memreq_snoop_rdy ( xcel$000$memreq_snoop_rdy )
  );

  // xcel$001 temporaries
  wire   [  37:0] xcel$001$xcelreq_msg;
  wire   [   0:0] xcel$001$xcelreq_val;
  wire   [   0:0] xcel$001$clk;
  wire   [   0:0] xcel$001$reset;
  wire   [   0:0] xcel$001$xcelresp_rdy;
  wire   [  77:0] xcel$001$memreq_snoop_msg;
  wire   [   0:0] xcel$001$memreq_snoop_val;
  wire   [   0:0] xcel$001$xcelreq_rdy;
  wire   [  32:0] xcel$001$xcelresp_msg;
  wire   [   0:0] xcel$001$xcelresp_val;
  wire   [   0:0] xcel$001$memreq_snoop_rdy;

  BloomFilterXcel_0x6aa8c82a20a95749 xcel$001
  (
    .xcelreq_msg      ( xcel$001$xcelreq_msg ),
    .xcelreq_val      ( xcel$001$xcelreq_val ),
    .clk              ( xcel$001$clk ),
    .reset            ( xcel$001$reset ),
    .xcelresp_rdy     ( xcel$001$xcelresp_rdy ),
    .memreq_snoop_msg ( xcel$001$memreq_snoop_msg ),
    .memreq_snoop_val ( xcel$001$memreq_snoop_val ),
    .xcelreq_rdy      ( xcel$001$xcelreq_rdy ),
    .xcelresp_msg     ( xcel$001$xcelresp_msg ),
    .xcelresp_val     ( xcel$001$xcelresp_val ),
    .memreq_snoop_rdy ( xcel$001$memreq_snoop_rdy )
  );

  // xcel$002 temporaries
  wire   [  37:0] xcel$002$xcelreq_msg;
  wire   [   0:0] xcel$002$xcelreq_val;
  wire   [   0:0] xcel$002$clk;
  wire   [   0:0] xcel$002$reset;
  wire   [   0:0] xcel$002$xcelresp_rdy;
  wire   [  77:0] xcel$002$memreq_snoop_msg;
  wire   [   0:0] xcel$002$memreq_snoop_val;
  wire   [   0:0] xcel$002$xcelreq_rdy;
  wire   [  32:0] xcel$002$xcelresp_msg;
  wire   [   0:0] xcel$002$xcelresp_val;
  wire   [   0:0] xcel$002$memreq_snoop_rdy;

  BloomFilterXcel_0x6aa8c82a20a95749 xcel$002
  (
    .xcelreq_msg      ( xcel$002$xcelreq_msg ),
    .xcelreq_val      ( xcel$002$xcelreq_val ),
    .clk              ( xcel$002$clk ),
    .reset            ( xcel$002$reset ),
    .xcelresp_rdy     ( xcel$002$xcelresp_rdy ),
    .memreq_snoop_msg ( xcel$002$memreq_snoop_msg ),
    .memreq_snoop_val ( xcel$002$memreq_snoop_val ),
    .xcelreq_rdy      ( xcel$002$xcelreq_rdy ),
    .xcelresp_msg     ( xcel$002$xcelresp_msg ),
    .xcelresp_val     ( xcel$002$xcelresp_val ),
    .memreq_snoop_rdy ( xcel$002$memreq_snoop_rdy )
  );

  // xcel$003 temporaries
  wire   [  37:0] xcel$003$xcelreq_msg;
  wire   [   0:0] xcel$003$xcelreq_val;
  wire   [   0:0] xcel$003$clk;
  wire   [   0:0] xcel$003$reset;
  wire   [   0:0] xcel$003$xcelresp_rdy;
  wire   [  77:0] xcel$003$memreq_snoop_msg;
  wire   [   0:0] xcel$003$memreq_snoop_val;
  wire   [   0:0] xcel$003$xcelreq_rdy;
  wire   [  32:0] xcel$003$xcelresp_msg;
  wire   [   0:0] xcel$003$xcelresp_val;
  wire   [   0:0] xcel$003$memreq_snoop_rdy;

  BloomFilterXcel_0x6aa8c82a20a95749 xcel$003
  (
    .xcelreq_msg      ( xcel$003$xcelreq_msg ),
    .xcelreq_val      ( xcel$003$xcelreq_val ),
    .clk              ( xcel$003$clk ),
    .reset            ( xcel$003$reset ),
    .xcelresp_rdy     ( xcel$003$xcelresp_rdy ),
    .memreq_snoop_msg ( xcel$003$memreq_snoop_msg ),
    .memreq_snoop_val ( xcel$003$memreq_snoop_val ),
    .xcelreq_rdy      ( xcel$003$xcelreq_rdy ),
    .xcelresp_msg     ( xcel$003$xcelresp_msg ),
    .xcelresp_val     ( xcel$003$xcelresp_val ),
    .memreq_snoop_rdy ( xcel$003$memreq_snoop_rdy )
  );

  // mdu_adapter temporaries
  wire   [  69:0] mdu_adapter$realreq_msg;
  wire   [   0:0] mdu_adapter$realreq_val;
  wire   [  34:0] mdu_adapter$resp_msg;
  wire   [   0:0] mdu_adapter$resp_val;
  wire   [   0:0] mdu_adapter$clk;
  wire   [  69:0] mdu_adapter$hostreq_msg;
  wire   [   0:0] mdu_adapter$hostreq_val;
  wire   [   0:0] mdu_adapter$req_rdy;
  wire   [   0:0] mdu_adapter$reset;
  wire   [   0:0] mdu_adapter$realresp_rdy;
  wire   [   0:0] mdu_adapter$hostresp_rdy;
  wire   [   0:0] mdu_adapter$host_en;
  wire   [   0:0] mdu_adapter$realreq_rdy;
  wire   [   0:0] mdu_adapter$resp_rdy;
  wire   [   0:0] mdu_adapter$hostreq_rdy;
  wire   [  69:0] mdu_adapter$req_msg;
  wire   [   0:0] mdu_adapter$req_val;
  wire   [  34:0] mdu_adapter$realresp_msg;
  wire   [   0:0] mdu_adapter$realresp_val;
  wire   [  34:0] mdu_adapter$hostresp_msg;
  wire   [   0:0] mdu_adapter$hostresp_val;

  HostAdapter_MduReqMsg_32_8_MduRespMsg_32 mdu_adapter
  (
    .realreq_msg  ( mdu_adapter$realreq_msg ),
    .realreq_val  ( mdu_adapter$realreq_val ),
    .resp_msg     ( mdu_adapter$resp_msg ),
    .resp_val     ( mdu_adapter$resp_val ),
    .clk          ( mdu_adapter$clk ),
    .hostreq_msg  ( mdu_adapter$hostreq_msg ),
    .hostreq_val  ( mdu_adapter$hostreq_val ),
    .req_rdy      ( mdu_adapter$req_rdy ),
    .reset        ( mdu_adapter$reset ),
    .realresp_rdy ( mdu_adapter$realresp_rdy ),
    .hostresp_rdy ( mdu_adapter$hostresp_rdy ),
    .host_en      ( mdu_adapter$host_en ),
    .realreq_rdy  ( mdu_adapter$realreq_rdy ),
    .resp_rdy     ( mdu_adapter$resp_rdy ),
    .hostreq_rdy  ( mdu_adapter$hostreq_rdy ),
    .req_msg      ( mdu_adapter$req_msg ),
    .req_val      ( mdu_adapter$req_val ),
    .realresp_msg ( mdu_adapter$realresp_msg ),
    .realresp_val ( mdu_adapter$realresp_val ),
    .hostresp_msg ( mdu_adapter$hostresp_msg ),
    .hostresp_val ( mdu_adapter$hostresp_val )
  );

  // net_icachereq temporaries
  wire   [   0:0] net_icachereq$reset;
  wire   [ 175:0] net_icachereq$in_$000_msg;
  wire   [   0:0] net_icachereq$in_$000_val;
  wire   [ 175:0] net_icachereq$in_$001_msg;
  wire   [   0:0] net_icachereq$in_$001_val;
  wire   [ 175:0] net_icachereq$in_$002_msg;
  wire   [   0:0] net_icachereq$in_$002_val;
  wire   [ 175:0] net_icachereq$in_$003_msg;
  wire   [   0:0] net_icachereq$in_$003_val;
  wire   [   0:0] net_icachereq$clk;
  wire   [   0:0] net_icachereq$out_rdy;
  wire   [   0:0] net_icachereq$in_$000_rdy;
  wire   [   0:0] net_icachereq$in_$001_rdy;
  wire   [   0:0] net_icachereq$in_$002_rdy;
  wire   [   0:0] net_icachereq$in_$003_rdy;
  wire   [ 175:0] net_icachereq$out_msg;
  wire   [   0:0] net_icachereq$out_val;

  Funnel_0x54e59faab4b44232 net_icachereq
  (
    .reset       ( net_icachereq$reset ),
    .in_$000_msg ( net_icachereq$in_$000_msg ),
    .in_$000_val ( net_icachereq$in_$000_val ),
    .in_$001_msg ( net_icachereq$in_$001_msg ),
    .in_$001_val ( net_icachereq$in_$001_val ),
    .in_$002_msg ( net_icachereq$in_$002_msg ),
    .in_$002_val ( net_icachereq$in_$002_val ),
    .in_$003_msg ( net_icachereq$in_$003_msg ),
    .in_$003_val ( net_icachereq$in_$003_val ),
    .clk         ( net_icachereq$clk ),
    .out_rdy     ( net_icachereq$out_rdy ),
    .in_$000_rdy ( net_icachereq$in_$000_rdy ),
    .in_$001_rdy ( net_icachereq$in_$001_rdy ),
    .in_$002_rdy ( net_icachereq$in_$002_rdy ),
    .in_$003_rdy ( net_icachereq$in_$003_rdy ),
    .out_msg     ( net_icachereq$out_msg ),
    .out_val     ( net_icachereq$out_val )
  );

  // ctrlreg temporaries
  wire   [   0:0] ctrlreg$resp_rdy;
  wire   [   3:0] ctrlreg$commit_inst;
  wire   [   0:0] ctrlreg$clk;
  wire   [  36:0] ctrlreg$req_msg;
  wire   [   0:0] ctrlreg$req_val;
  wire   [   0:0] ctrlreg$reset;
  wire   [   0:0] ctrlreg$stats_en;
  wire   [  32:0] ctrlreg$resp_msg;
  wire   [   0:0] ctrlreg$resp_val;
  wire   [   3:0] ctrlreg$go;
  wire   [   0:0] ctrlreg$req_rdy;
  wire   [   0:0] ctrlreg$debug;
  wire   [   2:0] ctrlreg$host_en;

  CtrlReg_0x2547fdfd5863c73b ctrlreg
  (
    .resp_rdy    ( ctrlreg$resp_rdy ),
    .commit_inst ( ctrlreg$commit_inst ),
    .clk         ( ctrlreg$clk ),
    .req_msg     ( ctrlreg$req_msg ),
    .req_val     ( ctrlreg$req_val ),
    .reset       ( ctrlreg$reset ),
    .stats_en    ( ctrlreg$stats_en ),
    .resp_msg    ( ctrlreg$resp_msg ),
    .resp_val    ( ctrlreg$resp_val ),
    .go          ( ctrlreg$go ),
    .req_rdy     ( ctrlreg$req_rdy ),
    .debug       ( ctrlreg$debug ),
    .host_en     ( ctrlreg$host_en )
  );

  // icache_adapter temporaries
  wire   [ 175:0] icache_adapter$realreq_msg;
  wire   [   0:0] icache_adapter$realreq_val;
  wire   [ 145:0] icache_adapter$resp_msg;
  wire   [   0:0] icache_adapter$resp_val;
  wire   [   0:0] icache_adapter$clk;
  wire   [ 175:0] icache_adapter$hostreq_msg;
  wire   [   0:0] icache_adapter$hostreq_val;
  wire   [   0:0] icache_adapter$req_rdy;
  wire   [   0:0] icache_adapter$reset;
  wire   [   0:0] icache_adapter$realresp_rdy;
  wire   [   0:0] icache_adapter$hostresp_rdy;
  wire   [   0:0] icache_adapter$host_en;
  wire   [   0:0] icache_adapter$realreq_rdy;
  wire   [   0:0] icache_adapter$resp_rdy;
  wire   [   0:0] icache_adapter$hostreq_rdy;
  wire   [ 175:0] icache_adapter$req_msg;
  wire   [   0:0] icache_adapter$req_val;
  wire   [ 145:0] icache_adapter$realresp_msg;
  wire   [   0:0] icache_adapter$realresp_val;
  wire   [ 145:0] icache_adapter$hostresp_msg;
  wire   [   0:0] icache_adapter$hostresp_val;

  HostAdapter_MemReqMsg_8_32_128_MemRespMsg_8_128 icache_adapter
  (
    .realreq_msg  ( icache_adapter$realreq_msg ),
    .realreq_val  ( icache_adapter$realreq_val ),
    .resp_msg     ( icache_adapter$resp_msg ),
    .resp_val     ( icache_adapter$resp_val ),
    .clk          ( icache_adapter$clk ),
    .hostreq_msg  ( icache_adapter$hostreq_msg ),
    .hostreq_val  ( icache_adapter$hostreq_val ),
    .req_rdy      ( icache_adapter$req_rdy ),
    .reset        ( icache_adapter$reset ),
    .realresp_rdy ( icache_adapter$realresp_rdy ),
    .hostresp_rdy ( icache_adapter$hostresp_rdy ),
    .host_en      ( icache_adapter$host_en ),
    .realreq_rdy  ( icache_adapter$realreq_rdy ),
    .resp_rdy     ( icache_adapter$resp_rdy ),
    .hostreq_rdy  ( icache_adapter$hostreq_rdy ),
    .req_msg      ( icache_adapter$req_msg ),
    .req_val      ( icache_adapter$req_val ),
    .realresp_msg ( icache_adapter$realresp_msg ),
    .realresp_val ( icache_adapter$realresp_val ),
    .hostresp_msg ( icache_adapter$hostresp_msg ),
    .hostresp_val ( icache_adapter$hostresp_val )
  );

  // net_icacheresp temporaries
  wire   [   0:0] net_icacheresp$reset;
  wire   [ 145:0] net_icacheresp$in__msg;
  wire   [   0:0] net_icacheresp$in__val;
  wire   [   0:0] net_icacheresp$clk;
  wire   [   0:0] net_icacheresp$out$000_rdy;
  wire   [   0:0] net_icacheresp$out$001_rdy;
  wire   [   0:0] net_icacheresp$out$002_rdy;
  wire   [   0:0] net_icacheresp$out$003_rdy;
  wire   [   0:0] net_icacheresp$in__rdy;
  wire   [ 145:0] net_icacheresp$out$000_msg;
  wire   [   0:0] net_icacheresp$out$000_val;
  wire   [ 145:0] net_icacheresp$out$001_msg;
  wire   [   0:0] net_icacheresp$out$001_val;
  wire   [ 145:0] net_icacheresp$out$002_msg;
  wire   [   0:0] net_icacheresp$out$002_val;
  wire   [ 145:0] net_icacheresp$out$003_msg;
  wire   [   0:0] net_icacheresp$out$003_val;

  Router_0x3fd90561b3d11051 net_icacheresp
  (
    .reset       ( net_icacheresp$reset ),
    .in__msg     ( net_icacheresp$in__msg ),
    .in__val     ( net_icacheresp$in__val ),
    .clk         ( net_icacheresp$clk ),
    .out$000_rdy ( net_icacheresp$out$000_rdy ),
    .out$001_rdy ( net_icacheresp$out$001_rdy ),
    .out$002_rdy ( net_icacheresp$out$002_rdy ),
    .out$003_rdy ( net_icacheresp$out$003_rdy ),
    .in__rdy     ( net_icacheresp$in__rdy ),
    .out$000_msg ( net_icacheresp$out$000_msg ),
    .out$000_val ( net_icacheresp$out$000_val ),
    .out$001_msg ( net_icacheresp$out$001_msg ),
    .out$001_val ( net_icacheresp$out$001_val ),
    .out$002_msg ( net_icacheresp$out$002_msg ),
    .out$002_val ( net_icacheresp$out$002_val ),
    .out$003_msg ( net_icacheresp$out$003_msg ),
    .out$003_val ( net_icacheresp$out$003_val )
  );

  // signal connections
  assign ctrlreg$clk                 = clk;
  assign ctrlreg$commit_inst[0]      = proc$000$commit_inst;
  assign ctrlreg$commit_inst[1]      = proc$001$commit_inst;
  assign ctrlreg$commit_inst[2]      = proc$002$commit_inst;
  assign ctrlreg$commit_inst[3]      = proc$003$commit_inst;
  assign ctrlreg$req_msg             = ctrlregreq_msg;
  assign ctrlreg$req_val             = ctrlregreq_val;
  assign ctrlreg$reset               = reset;
  assign ctrlreg$resp_rdy            = ctrlregresp_rdy;
  assign ctrlreg$stats_en            = proc$000$stats_en;
  assign ctrlregreq_rdy              = ctrlreg$req_rdy;
  assign ctrlregresp_msg             = ctrlreg$resp_msg;
  assign ctrlregresp_val             = ctrlreg$resp_val;
  assign dcache$cachereq_msg         = dcache_adapter$req_msg;
  assign dcache$cachereq_val         = dcache_adapter$req_val;
  assign dcache$cacheresp_rdy        = dcache_adapter$resp_rdy;
  assign dcache$clk                  = clk;
  assign dcache$memreq_rdy           = dmemreq_rdy;
  assign dcache$memresp_msg          = dmemresp_msg;
  assign dcache$memresp_val          = dmemresp_val;
  assign dcache$reset                = reset;
  assign dcache_adapter$clk          = clk;
  assign dcache_adapter$host_en      = ctrlreg$host_en[2];
  assign dcache_adapter$hostreq_msg  = host_dcachereq_msg;
  assign dcache_adapter$hostreq_val  = host_dcachereq_val;
  assign dcache_adapter$hostresp_rdy = host_dcacheresp_rdy;
  assign dcache_adapter$realreq_msg  = net_dcachereq$out_msg;
  assign dcache_adapter$realreq_val  = net_dcachereq$out_val;
  assign dcache_adapter$realresp_rdy = net_dcacheresp$in__rdy;
  assign dcache_adapter$req_rdy      = dcache$cachereq_rdy;
  assign dcache_adapter$reset        = reset;
  assign dcache_adapter$resp_msg     = dcache$cacheresp_msg;
  assign dcache_adapter$resp_val     = dcache$cacheresp_val;
  assign dmemreq_msg                 = dcache$memreq_msg;
  assign dmemreq_val                 = dcache$memreq_val;
  assign dmemresp_rdy                = dcache$memresp_rdy;
  assign host_dcachereq_rdy          = dcache_adapter$hostreq_rdy;
  assign host_dcacheresp_msg         = dcache_adapter$hostresp_msg;
  assign host_dcacheresp_val         = dcache_adapter$hostresp_val;
  assign host_icachereq_rdy          = icache_adapter$hostreq_rdy;
  assign host_icacheresp_msg         = icache_adapter$hostresp_msg;
  assign host_icacheresp_val         = icache_adapter$hostresp_val;
  assign host_mdureq_rdy             = mdu_adapter$hostreq_rdy;
  assign host_mduresp_msg            = mdu_adapter$hostresp_msg;
  assign host_mduresp_val            = mdu_adapter$hostresp_val;
  assign icache$cachereq_msg         = icache_adapter$req_msg;
  assign icache$cachereq_val         = icache_adapter$req_val;
  assign icache$cacheresp_rdy        = icache_adapter$resp_rdy;
  assign icache$clk                  = clk;
  assign icache$memreq_rdy           = imemreq_rdy;
  assign icache$memresp_msg          = imemresp_msg;
  assign icache$memresp_val          = imemresp_val;
  assign icache$reset                = reset;
  assign icache_adapter$clk          = clk;
  assign icache_adapter$host_en      = ctrlreg$host_en[1];
  assign icache_adapter$hostreq_msg  = host_icachereq_msg;
  assign icache_adapter$hostreq_val  = host_icachereq_val;
  assign icache_adapter$hostresp_rdy = host_icacheresp_rdy;
  assign icache_adapter$realreq_msg  = net_icachereq$out_msg;
  assign icache_adapter$realreq_val  = net_icachereq$out_val;
  assign icache_adapter$realresp_rdy = net_icacheresp$in__rdy;
  assign icache_adapter$req_rdy      = icache$cachereq_rdy;
  assign icache_adapter$reset        = reset;
  assign icache_adapter$resp_msg     = icache$cacheresp_msg;
  assign icache_adapter$resp_val     = icache$cacheresp_val;
  assign imemreq_msg                 = icache$memreq_msg;
  assign imemreq_val                 = icache$memreq_val;
  assign imemresp_rdy                = icache$memresp_rdy;
  assign l0i$000$L0_disable          = 1'd0;
  assign l0i$000$buffreq_msg         = proc$000$imemreq_msg;
  assign l0i$000$buffreq_val         = proc$000$imemreq_val;
  assign l0i$000$buffresp_rdy        = proc$000$imemresp_rdy;
  assign l0i$000$clk                 = clk;
  assign l0i$000$memreq_rdy          = net_icachereq$in_$000_rdy;
  assign l0i$000$memresp_msg         = net_icacheresp$out$000_msg;
  assign l0i$000$memresp_val         = net_icacheresp$out$000_val;
  assign l0i$000$reset               = reset;
  assign l0i$001$L0_disable          = 1'd0;
  assign l0i$001$buffreq_msg         = proc$001$imemreq_msg;
  assign l0i$001$buffreq_val         = proc$001$imemreq_val;
  assign l0i$001$buffresp_rdy        = proc$001$imemresp_rdy;
  assign l0i$001$clk                 = clk;
  assign l0i$001$memreq_rdy          = net_icachereq$in_$001_rdy;
  assign l0i$001$memresp_msg         = net_icacheresp$out$001_msg;
  assign l0i$001$memresp_val         = net_icacheresp$out$001_val;
  assign l0i$001$reset               = reset;
  assign l0i$002$L0_disable          = 1'd0;
  assign l0i$002$buffreq_msg         = proc$002$imemreq_msg;
  assign l0i$002$buffreq_val         = proc$002$imemreq_val;
  assign l0i$002$buffresp_rdy        = proc$002$imemresp_rdy;
  assign l0i$002$clk                 = clk;
  assign l0i$002$memreq_rdy          = net_icachereq$in_$002_rdy;
  assign l0i$002$memresp_msg         = net_icacheresp$out$002_msg;
  assign l0i$002$memresp_val         = net_icacheresp$out$002_val;
  assign l0i$002$reset               = reset;
  assign l0i$003$L0_disable          = 1'd0;
  assign l0i$003$buffreq_msg         = proc$003$imemreq_msg;
  assign l0i$003$buffreq_val         = proc$003$imemreq_val;
  assign l0i$003$buffresp_rdy        = proc$003$imemresp_rdy;
  assign l0i$003$clk                 = clk;
  assign l0i$003$memreq_rdy          = net_icachereq$in_$003_rdy;
  assign l0i$003$memresp_msg         = net_icacheresp$out$003_msg;
  assign l0i$003$memresp_val         = net_icacheresp$out$003_val;
  assign l0i$003$reset               = reset;
  assign mdu$clk                     = clk;
  assign mdu$req_msg                 = mdu_adapter$req_msg;
  assign mdu$req_val                 = mdu_adapter$req_val;
  assign mdu$reset                   = reset;
  assign mdu$resp_rdy                = mdu_adapter$resp_rdy;
  assign mdu_adapter$clk             = clk;
  assign mdu_adapter$host_en         = ctrlreg$host_en[0];
  assign mdu_adapter$hostreq_msg     = host_mdureq_msg;
  assign mdu_adapter$hostreq_val     = host_mdureq_val;
  assign mdu_adapter$hostresp_rdy    = host_mduresp_rdy;
  assign mdu_adapter$realreq_msg     = net_mdureq$out_msg;
  assign mdu_adapter$realreq_val     = net_mdureq$out_val;
  assign mdu_adapter$realresp_rdy    = net_mduresp$in__rdy;
  assign mdu_adapter$req_rdy         = mdu$req_rdy;
  assign mdu_adapter$reset           = reset;
  assign mdu_adapter$resp_msg        = mdu$resp_msg;
  assign mdu_adapter$resp_val        = mdu$resp_val;
  assign mngr2proc_0_rdy             = proc$000$mngr2proc_rdy;
  assign mngr2proc_1_rdy             = proc$001$mngr2proc_rdy;
  assign mngr2proc_2_rdy             = proc$002$mngr2proc_rdy;
  assign mngr2proc_3_rdy             = proc$003$mngr2proc_rdy;
  assign net_dcachereq$clk           = clk;
  assign net_dcachereq$in_$000_msg   = proc$000$dmemreq_msg;
  assign net_dcachereq$in_$000_val   = proc$000$dmemreq_val;
  assign net_dcachereq$in_$001_msg   = proc$001$dmemreq_msg;
  assign net_dcachereq$in_$001_val   = proc$001$dmemreq_val;
  assign net_dcachereq$in_$002_msg   = proc$002$dmemreq_msg;
  assign net_dcachereq$in_$002_val   = proc$002$dmemreq_val;
  assign net_dcachereq$in_$003_msg   = proc$003$dmemreq_msg;
  assign net_dcachereq$in_$003_val   = proc$003$dmemreq_val;
  assign net_dcachereq$out_rdy       = dcache_adapter$realreq_rdy;
  assign net_dcachereq$reset         = reset;
  assign net_dcacheresp$clk          = clk;
  assign net_dcacheresp$in__msg      = dcache_adapter$realresp_msg;
  assign net_dcacheresp$in__val      = dcache_adapter$realresp_val;
  assign net_dcacheresp$out$000_rdy  = proc$000$dmemresp_rdy;
  assign net_dcacheresp$out$001_rdy  = proc$001$dmemresp_rdy;
  assign net_dcacheresp$out$002_rdy  = proc$002$dmemresp_rdy;
  assign net_dcacheresp$out$003_rdy  = proc$003$dmemresp_rdy;
  assign net_dcacheresp$reset        = reset;
  assign net_icachereq$clk           = clk;
  assign net_icachereq$in_$000_msg   = l0i$000$memreq_msg;
  assign net_icachereq$in_$000_val   = l0i$000$memreq_val;
  assign net_icachereq$in_$001_msg   = l0i$001$memreq_msg;
  assign net_icachereq$in_$001_val   = l0i$001$memreq_val;
  assign net_icachereq$in_$002_msg   = l0i$002$memreq_msg;
  assign net_icachereq$in_$002_val   = l0i$002$memreq_val;
  assign net_icachereq$in_$003_msg   = l0i$003$memreq_msg;
  assign net_icachereq$in_$003_val   = l0i$003$memreq_val;
  assign net_icachereq$out_rdy       = icache_adapter$realreq_rdy;
  assign net_icachereq$reset         = reset;
  assign net_icacheresp$clk          = clk;
  assign net_icacheresp$in__msg      = icache_adapter$realresp_msg;
  assign net_icacheresp$in__val      = icache_adapter$realresp_val;
  assign net_icacheresp$out$000_rdy  = l0i$000$memresp_rdy;
  assign net_icacheresp$out$001_rdy  = l0i$001$memresp_rdy;
  assign net_icacheresp$out$002_rdy  = l0i$002$memresp_rdy;
  assign net_icacheresp$out$003_rdy  = l0i$003$memresp_rdy;
  assign net_icacheresp$reset        = reset;
  assign net_mdureq$clk              = clk;
  assign net_mdureq$in_$000_msg      = proc$000$mdureq_msg;
  assign net_mdureq$in_$000_val      = proc$000$mdureq_val;
  assign net_mdureq$in_$001_msg      = proc$001$mdureq_msg;
  assign net_mdureq$in_$001_val      = proc$001$mdureq_val;
  assign net_mdureq$in_$002_msg      = proc$002$mdureq_msg;
  assign net_mdureq$in_$002_val      = proc$002$mdureq_val;
  assign net_mdureq$in_$003_msg      = proc$003$mdureq_msg;
  assign net_mdureq$in_$003_val      = proc$003$mdureq_val;
  assign net_mdureq$out_rdy          = mdu_adapter$realreq_rdy;
  assign net_mdureq$reset            = reset;
  assign net_mduresp$clk             = clk;
  assign net_mduresp$in__msg         = mdu_adapter$realresp_msg;
  assign net_mduresp$in__val         = mdu_adapter$realresp_val;
  assign net_mduresp$out$000_rdy     = proc$000$mduresp_rdy;
  assign net_mduresp$out$001_rdy     = proc$001$mduresp_rdy;
  assign net_mduresp$out$002_rdy     = proc$002$mduresp_rdy;
  assign net_mduresp$out$003_rdy     = proc$003$mduresp_rdy;
  assign net_mduresp$reset           = reset;
  assign proc$000$clk                = clk;
  assign proc$000$core_id            = 32'd0;
  assign proc$000$dmemreq_rdy        = net_dcachereq$in_$000_rdy;
  assign proc$000$dmemresp_msg       = net_dcacheresp$out$000_msg;
  assign proc$000$dmemresp_val       = net_dcacheresp$out$000_val;
  assign proc$000$go                 = ctrlreg$go[0];
  assign proc$000$imemreq_rdy        = l0i$000$buffreq_rdy;
  assign proc$000$imemresp_msg       = l0i$000$buffresp_msg;
  assign proc$000$imemresp_val       = l0i$000$buffresp_val;
  assign proc$000$mdureq_rdy         = net_mdureq$in_$000_rdy;
  assign proc$000$mduresp_msg        = net_mduresp$out$000_msg;
  assign proc$000$mduresp_val        = net_mduresp$out$000_val;
  assign proc$000$mngr2proc_msg      = mngr2proc_0_msg;
  assign proc$000$mngr2proc_val      = mngr2proc_0_val;
  assign proc$000$proc2mngr_rdy      = proc2mngr_0_rdy;
  assign proc$000$reset              = reset;
  assign proc$000$xcelreq_rdy        = xcel$000$xcelreq_rdy;
  assign proc$000$xcelresp_msg       = xcel$000$xcelresp_msg;
  assign proc$000$xcelresp_val       = xcel$000$xcelresp_val;
  assign proc$001$clk                = clk;
  assign proc$001$core_id            = 32'd1;
  assign proc$001$dmemreq_rdy        = net_dcachereq$in_$001_rdy;
  assign proc$001$dmemresp_msg       = net_dcacheresp$out$001_msg;
  assign proc$001$dmemresp_val       = net_dcacheresp$out$001_val;
  assign proc$001$go                 = ctrlreg$go[1];
  assign proc$001$imemreq_rdy        = l0i$001$buffreq_rdy;
  assign proc$001$imemresp_msg       = l0i$001$buffresp_msg;
  assign proc$001$imemresp_val       = l0i$001$buffresp_val;
  assign proc$001$mdureq_rdy         = net_mdureq$in_$001_rdy;
  assign proc$001$mduresp_msg        = net_mduresp$out$001_msg;
  assign proc$001$mduresp_val        = net_mduresp$out$001_val;
  assign proc$001$mngr2proc_msg      = mngr2proc_1_msg;
  assign proc$001$mngr2proc_val      = mngr2proc_1_val;
  assign proc$001$proc2mngr_rdy      = proc2mngr_1_rdy;
  assign proc$001$reset              = reset;
  assign proc$001$xcelreq_rdy        = xcel$001$xcelreq_rdy;
  assign proc$001$xcelresp_msg       = xcel$001$xcelresp_msg;
  assign proc$001$xcelresp_val       = xcel$001$xcelresp_val;
  assign proc$002$clk                = clk;
  assign proc$002$core_id            = 32'd2;
  assign proc$002$dmemreq_rdy        = net_dcachereq$in_$002_rdy;
  assign proc$002$dmemresp_msg       = net_dcacheresp$out$002_msg;
  assign proc$002$dmemresp_val       = net_dcacheresp$out$002_val;
  assign proc$002$go                 = ctrlreg$go[2];
  assign proc$002$imemreq_rdy        = l0i$002$buffreq_rdy;
  assign proc$002$imemresp_msg       = l0i$002$buffresp_msg;
  assign proc$002$imemresp_val       = l0i$002$buffresp_val;
  assign proc$002$mdureq_rdy         = net_mdureq$in_$002_rdy;
  assign proc$002$mduresp_msg        = net_mduresp$out$002_msg;
  assign proc$002$mduresp_val        = net_mduresp$out$002_val;
  assign proc$002$mngr2proc_msg      = mngr2proc_2_msg;
  assign proc$002$mngr2proc_val      = mngr2proc_2_val;
  assign proc$002$proc2mngr_rdy      = proc2mngr_2_rdy;
  assign proc$002$reset              = reset;
  assign proc$002$xcelreq_rdy        = xcel$002$xcelreq_rdy;
  assign proc$002$xcelresp_msg       = xcel$002$xcelresp_msg;
  assign proc$002$xcelresp_val       = xcel$002$xcelresp_val;
  assign proc$003$clk                = clk;
  assign proc$003$core_id            = 32'd3;
  assign proc$003$dmemreq_rdy        = net_dcachereq$in_$003_rdy;
  assign proc$003$dmemresp_msg       = net_dcacheresp$out$003_msg;
  assign proc$003$dmemresp_val       = net_dcacheresp$out$003_val;
  assign proc$003$go                 = ctrlreg$go[3];
  assign proc$003$imemreq_rdy        = l0i$003$buffreq_rdy;
  assign proc$003$imemresp_msg       = l0i$003$buffresp_msg;
  assign proc$003$imemresp_val       = l0i$003$buffresp_val;
  assign proc$003$mdureq_rdy         = net_mdureq$in_$003_rdy;
  assign proc$003$mduresp_msg        = net_mduresp$out$003_msg;
  assign proc$003$mduresp_val        = net_mduresp$out$003_val;
  assign proc$003$mngr2proc_msg      = mngr2proc_3_msg;
  assign proc$003$mngr2proc_val      = mngr2proc_3_val;
  assign proc$003$proc2mngr_rdy      = proc2mngr_3_rdy;
  assign proc$003$reset              = reset;
  assign proc$003$xcelreq_rdy        = xcel$003$xcelreq_rdy;
  assign proc$003$xcelresp_msg       = xcel$003$xcelresp_msg;
  assign proc$003$xcelresp_val       = xcel$003$xcelresp_val;
  assign proc2mngr_0_msg             = proc$000$proc2mngr_msg;
  assign proc2mngr_0_val             = proc$000$proc2mngr_val;
  assign proc2mngr_1_msg             = proc$001$proc2mngr_msg;
  assign proc2mngr_1_val             = proc$001$proc2mngr_val;
  assign proc2mngr_2_msg             = proc$002$proc2mngr_msg;
  assign proc2mngr_2_val             = proc$002$proc2mngr_val;
  assign proc2mngr_3_msg             = proc$003$proc2mngr_msg;
  assign proc2mngr_3_val             = proc$003$proc2mngr_val;
  assign xcel$000$clk                = clk;
  assign xcel$000$memreq_snoop_msg   = dcache_adapter$req_msg;
  assign xcel$000$memreq_snoop_val   = cachereq_go;
  assign xcel$000$reset              = reset;
  assign xcel$000$xcelreq_msg        = proc$000$xcelreq_msg;
  assign xcel$000$xcelreq_val        = proc$000$xcelreq_val;
  assign xcel$000$xcelresp_rdy       = proc$000$xcelresp_rdy;
  assign xcel$001$clk                = clk;
  assign xcel$001$memreq_snoop_msg   = dcache_adapter$req_msg;
  assign xcel$001$memreq_snoop_val   = cachereq_go;
  assign xcel$001$reset              = reset;
  assign xcel$001$xcelreq_msg        = proc$001$xcelreq_msg;
  assign xcel$001$xcelreq_val        = proc$001$xcelreq_val;
  assign xcel$001$xcelresp_rdy       = proc$001$xcelresp_rdy;
  assign xcel$002$clk                = clk;
  assign xcel$002$memreq_snoop_msg   = dcache_adapter$req_msg;
  assign xcel$002$memreq_snoop_val   = cachereq_go;
  assign xcel$002$reset              = reset;
  assign xcel$002$xcelreq_msg        = proc$002$xcelreq_msg;
  assign xcel$002$xcelreq_val        = proc$002$xcelreq_val;
  assign xcel$002$xcelresp_rdy       = proc$002$xcelresp_rdy;
  assign xcel$003$clk                = clk;
  assign xcel$003$memreq_snoop_msg   = dcache_adapter$req_msg;
  assign xcel$003$memreq_snoop_val   = cachereq_go;
  assign xcel$003$reset              = reset;
  assign xcel$003$xcelreq_msg        = proc$003$xcelreq_msg;
  assign xcel$003$xcelreq_val        = proc$003$xcelreq_val;
  assign xcel$003$xcelresp_rdy       = proc$003$xcelresp_rdy;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_go():
  //       s.cachereq_go.value = s.dcache.cachereq.val and s.dcache.cachereq.rdy

  // logic for comb_cachereq_go()
  always @ (*) begin
    cachereq_go = (dcache$cachereq_val&&dcache$cachereq_rdy);
  end


endmodule // Butterfree
`default_nettype wire

//-----------------------------------------------------------------------------
// HostAdapter_MemReqMsg_8_32_32_MemRespMsg_8_32
//-----------------------------------------------------------------------------
// resp: <pymtl.model.signals.OutPort object at 0x7f9ba1ff6fd0>
// req: <pymtl.model.signals.InPort object at 0x7f9ba2005f10>
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostAdapter_MemReqMsg_8_32_32_MemRespMsg_8_32
(
  input  wire [   0:0] clk,
  input  wire [   0:0] host_en,
  input  wire [  77:0] hostreq_msg,
  output reg  [   0:0] hostreq_rdy,
  input  wire [   0:0] hostreq_val,
  output reg  [  47:0] hostresp_msg,
  input  wire [   0:0] hostresp_rdy,
  output reg  [   0:0] hostresp_val,
  input  wire [  77:0] realreq_msg,
  output reg  [   0:0] realreq_rdy,
  input  wire [   0:0] realreq_val,
  output reg  [  47:0] realresp_msg,
  input  wire [   0:0] realresp_rdy,
  output reg  [   0:0] realresp_val,
  output reg  [  77:0] req_msg,
  input  wire [   0:0] req_rdy,
  output reg  [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [  47:0] resp_msg,
  output reg  [   0:0] resp_rdy,
  input  wire [   0:0] resp_val
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_req_select():
  //
  //       if s.host_en:
  //         # Mute req
  //         s.realreq.rdy.value  = 0
  //         s.realresp.val.value = 0
  //         s.realresp.msg.value = 0
  //
  //         # instance.req <- hostreq
  //         s.req.val.value      = s.hostreq.val
  //         s.req.msg.value      = s.hostreq.msg
  //         s.hostreq.rdy.value  = s.req.rdy
  //
  //         # hostresp <- out_resp
  //         s.hostresp.val.value = s.resp.val
  //         s.hostresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.hostresp.rdy
  //
  //       else:
  //         # Mute host
  //         s.hostreq.rdy.value  = 0
  //         s.hostresp.val.value = 0
  //         s.hostresp.msg.value = 0
  //
  //         # req <- realreq
  //         s.req.val.value      = s.realreq.val
  //         s.req.msg.value      = s.realreq.msg
  //         s.realreq.rdy.value  = s.req.rdy
  //
  //         # realresp <- resp
  //         s.realresp.val.value = s.resp.val
  //         s.realresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.realresp.rdy

  // logic for comb_req_select()
  always @ (*) begin
    if (host_en) begin
      realreq_rdy = 0;
      realresp_val = 0;
      realresp_msg = 0;
      req_val = hostreq_val;
      req_msg = hostreq_msg;
      hostreq_rdy = req_rdy;
      hostresp_val = resp_val;
      hostresp_msg = resp_msg;
      resp_rdy = hostresp_rdy;
    end
    else begin
      hostreq_rdy = 0;
      hostresp_val = 0;
      hostresp_msg = 0;
      req_val = realreq_val;
      req_msg = realreq_msg;
      realreq_rdy = req_rdy;
      realresp_val = resp_val;
      realresp_msg = resp_msg;
      resp_rdy = realresp_rdy;
    end
  end


endmodule // HostAdapter_MemReqMsg_8_32_32_MemRespMsg_8_32
`default_nettype wire

//-----------------------------------------------------------------------------
// Funnel_0x2e5b141dfdfa2078
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Funnel_0x2e5b141dfdfa2078
(
  input  wire [   0:0] clk,
  input  wire [  69:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  input  wire [  69:0] in_$001_msg,
  output wire [   0:0] in_$001_rdy,
  input  wire [   0:0] in_$001_val,
  input  wire [  69:0] in_$002_msg,
  output wire [   0:0] in_$002_rdy,
  input  wire [   0:0] in_$002_val,
  input  wire [  69:0] in_$003_msg,
  output wire [   0:0] in_$003_rdy,
  input  wire [   0:0] in_$003_val,
  output reg  [  69:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] arbiter$en;

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;

  // arbiter temporaries
  wire   [   3:0] arbiter$reqs;
  wire   [   0:0] arbiter$clk;
  wire   [   0:0] arbiter$reset;
  wire   [   3:0] arbiter$grants;

  RoundRobinArbiterEn_0x77747397823e93e3 arbiter
  (
    .en     ( arbiter$en ),
    .reqs   ( arbiter$reqs ),
    .clk    ( arbiter$clk ),
    .reset  ( arbiter$reset ),
    .grants ( arbiter$grants )
  );

  // signal connections
  assign arbiter$clk     = clk;
  assign arbiter$reqs[0] = in_$000_val;
  assign arbiter$reqs[1] = in_$001_val;
  assign arbiter$reqs[2] = in_$002_val;
  assign arbiter$reqs[3] = in_$003_val;
  assign arbiter$reset   = reset;

  // array declarations
  wire   [  69:0] in__msg[0:3];
  assign in__msg[  0] = in_$000_msg;
  assign in__msg[  1] = in_$001_msg;
  assign in__msg[  2] = in_$002_msg;
  assign in__msg[  3] = in_$003_msg;
  reg    [   0:0] in__rdy[0:3];
  assign in_$000_rdy = in__rdy[  0];
  assign in_$001_rdy = in__rdy[  1];
  assign in_$002_rdy = in__rdy[  2];
  assign in_$003_rdy = in__rdy[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       for i in xrange( nports ):
  //         s.in_[i].rdy.value = s.arbiter.grants[i] & s.out.rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      in__rdy[i] = (arbiter$grants[i]&out_rdy);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_arbiter_en():
  //       s.arbiter.en.value = s.out.val & s.out.rdy

  // logic for comb_arbiter_en()
  always @ (*) begin
    arbiter$en = (out_val&out_rdy);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_output():
  //       s.out.val.value = ( s.arbiter.grants != 0 )
  //
  //       s.out.msg.value = 0
  //       for i in xrange( nports ):
  //         if s.arbiter.grants[i]:
  //           s.out.msg.value        = s.in_[i].msg
  //           s.out.msg.opaque.value = i

  // logic for comb_output()
  always @ (*) begin
    out_val = (arbiter$grants != 0);
    out_msg = 0;
    for (i=0; i < nports; i=i+1)
    begin
      if (arbiter$grants[i]) begin
        out_msg = in__msg[i];
        out_msg[(67)-1:64] = i;
      end
      else begin
      end
    end
  end


endmodule // Funnel_0x2e5b141dfdfa2078
`default_nettype wire

//-----------------------------------------------------------------------------
// RoundRobinArbiterEn_0x77747397823e93e3
//-----------------------------------------------------------------------------
// nreqs: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RoundRobinArbiterEn_0x77747397823e93e3
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  output reg  [   3:0] grants,
  input  wire [   3:0] reqs,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   7:0] grants_int;
  reg    [   8:0] kills;
  reg    [   0:0] priority_en;
  reg    [   7:0] priority_int;
  reg    [   7:0] reqs_int;

  // localparam declarations
  localparam nreqs = 4;
  localparam nreqsX2 = 8;

  // loop variable declarations
  integer i;

  // priority_reg temporaries
  wire   [   0:0] priority_reg$reset;
  wire   [   0:0] priority_reg$en;
  wire   [   0:0] priority_reg$clk;
  wire   [   3:0] priority_reg$in_;
  wire   [   3:0] priority_reg$out;

  RegEnRst_0x2e6a8ff89958929b priority_reg
  (
    .reset ( priority_reg$reset ),
    .en    ( priority_reg$en ),
    .clk   ( priority_reg$clk ),
    .in_   ( priority_reg$in_ ),
    .out   ( priority_reg$out )
  );

  // signal connections
  assign priority_reg$clk      = clk;
  assign priority_reg$en       = priority_en;
  assign priority_reg$in_[0]   = grants[3];
  assign priority_reg$in_[3:1] = grants[2:0];
  assign priority_reg$reset    = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_arbitrate():
  //
  //       s.kills[0].value = 1
  //
  //       s.priority_int[    0:nreqs  ].value = s.priority_reg.out
  //       s.priority_int[nreqs:nreqsX2].value = 0
  //       s.reqs_int    [    0:nreqs  ].value = s.reqs
  //       s.reqs_int    [nreqs:nreqsX2].value = s.reqs
  //
  //       # Calculate the kill chain
  //       for i in range( nreqsX2 ):
  //
  //         # Set internal grants
  //         if s.priority_int[i].value:
  //           s.grants_int[i].value = s.reqs_int[i]
  //         else:
  //           s.grants_int[i].value = ~s.kills[i] & s.reqs_int[i]
  //
  //         # Set kill signals
  //         if s.priority_int[i].value:
  //           s.kills[i+1].value = s.grants_int[i]
  //         else:
  //           s.kills[i+1].value = s.kills[i] | s.grants_int[i]
  //
  //       # Assign the output ports
  //       for i in range( nreqs ):
  //         s.grants[i].value = s.grants_int[i] | s.grants_int[nreqs+i]

  // logic for comb_arbitrate()
  always @ (*) begin
    kills[0] = 1;
    priority_int[(nreqs)-1:0] = priority_reg$out;
    priority_int[(nreqsX2)-1:nreqs] = 0;
    reqs_int[(nreqs)-1:0] = reqs;
    reqs_int[(nreqsX2)-1:nreqs] = reqs;
    for (i=0; i < nreqsX2; i=i+1)
    begin
      if (priority_int[i]) begin
        grants_int[i] = reqs_int[i];
      end
      else begin
        grants_int[i] = (~kills[i]&reqs_int[i]);
      end
      if (priority_int[i]) begin
        kills[(i+1)] = grants_int[i];
      end
      else begin
        kills[(i+1)] = (kills[i]|grants_int[i]);
      end
    end
    for (i=0; i < nreqs; i=i+1)
    begin
      grants[i] = (grants_int[i]|grants_int[(nreqs+i)]);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_feedback():
  //       s.priority_en.value = ( s.grants != 0 ) & s.en

  // logic for comb_feedback()
  always @ (*) begin
    priority_en = ((grants != 0)&en);
  end


endmodule // RoundRobinArbiterEn_0x77747397823e93e3
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x2e6a8ff89958929b
//-----------------------------------------------------------------------------
// dtype: 4
// reset_value: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x2e6a8ff89958929b
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   3:0] in_,
  output reg  [   3:0] out,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam reset_value = 1;



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


endmodule // RegEnRst_0x2e6a8ff89958929b
`default_nettype wire

//-----------------------------------------------------------------------------
// Funnel_0x51643a8477790b10
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Funnel_0x51643a8477790b10
(
  input  wire [   0:0] clk,
  input  wire [  77:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  input  wire [  77:0] in_$001_msg,
  output wire [   0:0] in_$001_rdy,
  input  wire [   0:0] in_$001_val,
  input  wire [  77:0] in_$002_msg,
  output wire [   0:0] in_$002_rdy,
  input  wire [   0:0] in_$002_val,
  input  wire [  77:0] in_$003_msg,
  output wire [   0:0] in_$003_rdy,
  input  wire [   0:0] in_$003_val,
  output reg  [  77:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] arbiter$en;

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;

  // arbiter temporaries
  wire   [   3:0] arbiter$reqs;
  wire   [   0:0] arbiter$clk;
  wire   [   0:0] arbiter$reset;
  wire   [   3:0] arbiter$grants;

  RoundRobinArbiterEn_0x77747397823e93e3 arbiter
  (
    .en     ( arbiter$en ),
    .reqs   ( arbiter$reqs ),
    .clk    ( arbiter$clk ),
    .reset  ( arbiter$reset ),
    .grants ( arbiter$grants )
  );

  // signal connections
  assign arbiter$clk     = clk;
  assign arbiter$reqs[0] = in_$000_val;
  assign arbiter$reqs[1] = in_$001_val;
  assign arbiter$reqs[2] = in_$002_val;
  assign arbiter$reqs[3] = in_$003_val;
  assign arbiter$reset   = reset;

  // array declarations
  wire   [  77:0] in__msg[0:3];
  assign in__msg[  0] = in_$000_msg;
  assign in__msg[  1] = in_$001_msg;
  assign in__msg[  2] = in_$002_msg;
  assign in__msg[  3] = in_$003_msg;
  reg    [   0:0] in__rdy[0:3];
  assign in_$000_rdy = in__rdy[  0];
  assign in_$001_rdy = in__rdy[  1];
  assign in_$002_rdy = in__rdy[  2];
  assign in_$003_rdy = in__rdy[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       for i in xrange( nports ):
  //         s.in_[i].rdy.value = s.arbiter.grants[i] & s.out.rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      in__rdy[i] = (arbiter$grants[i]&out_rdy);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_arbiter_en():
  //       s.arbiter.en.value = s.out.val & s.out.rdy

  // logic for comb_arbiter_en()
  always @ (*) begin
    arbiter$en = (out_val&out_rdy);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_output():
  //       s.out.val.value = ( s.arbiter.grants != 0 )
  //
  //       s.out.msg.value = 0
  //       for i in xrange( nports ):
  //         if s.arbiter.grants[i]:
  //           s.out.msg.value        = s.in_[i].msg
  //           s.out.msg.opaque.value = i

  // logic for comb_output()
  always @ (*) begin
    out_val = (arbiter$grants != 0);
    out_msg = 0;
    for (i=0; i < nports; i=i+1)
    begin
      if (arbiter$grants[i]) begin
        out_msg = in__msg[i];
        out_msg[(74)-1:66] = i;
      end
      else begin
      end
    end
  end


endmodule // Funnel_0x51643a8477790b10
`default_nettype wire

//-----------------------------------------------------------------------------
// BlockingCachePRTL_0x588be82f2c2ad182
//-----------------------------------------------------------------------------
// num_banks: 0
// wide_access: False
// CacheRespMsgType: 48
// CacheReqMsgType: 78
// MemRespMsgType: 146
// MemReqMsgType: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCachePRTL_0x588be82f2c2ad182
(
  input  wire [  77:0] cachereq_msg,
  output wire [   0:0] cachereq_rdy,
  input  wire [   0:0] cachereq_val,
  output wire [  47:0] cacheresp_msg,
  input  wire [   0:0] cacheresp_rdy,
  output wire [   0:0] cacheresp_val,
  input  wire [   0:0] clk,
  output wire [ 175:0] memreq_msg,
  input  wire [   0:0] memreq_rdy,
  output wire [   0:0] memreq_val,
  input  wire [ 145:0] memresp_msg,
  output wire [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$tag_match_0;
  wire   [   0:0] ctrl$tag_match_1;
  wire   [  31:0] ctrl$read_data_word;
  wire   [   0:0] ctrl$cacheresp_rdy;
  wire   [   3:0] ctrl$cachereq_type;
  wire   [   0:0] ctrl$memresp_val;
  wire   [   0:0] ctrl$reset;
  wire   [  31:0] ctrl$cachereq_data_word;
  wire   [   1:0] ctrl$cachereq_len_reg_out;
  wire   [  31:0] ctrl$cachereq_addr;
  wire   [   0:0] ctrl$memreq_rdy;
  wire   [   0:0] ctrl$cachereq_val;
  wire   [  31:0] ctrl$cachereq_data_reg_out;
  wire   [   0:0] ctrl$data_array_wen;
  wire   [   0:0] ctrl$skip_read_data_reg;
  wire   [   0:0] ctrl$memresp_en;
  wire   [   0:0] ctrl$tag_array_0_ren;
  wire   [   0:0] ctrl$way_sel_current;
  wire   [   0:0] ctrl$amo_maxu_sel;
  wire   [   0:0] ctrl$cachereq_rdy;
  wire   [   0:0] ctrl$amo_min_sel;
  wire   [   0:0] ctrl$read_tag_reg_en;
  wire   [   0:0] ctrl$is_amo;
  wire   [   3:0] ctrl$memreq_type;
  wire   [   1:0] ctrl$byte_offset;
  wire   [   0:0] ctrl$data_array_ren;
  wire   [   0:0] ctrl$cacheresp_val;
  wire   [   0:0] ctrl$amo_max_sel;
  wire   [  15:0] ctrl$data_array_wben;
  wire   [   0:0] ctrl$read_data_reg_en;
  wire   [   0:0] ctrl$tag_array_1_ren;
  wire   [   0:0] ctrl$tag_array_1_wen;
  wire   [   0:0] ctrl$memreq_val;
  wire   [   0:0] ctrl$memresp_rdy;
  wire   [   0:0] ctrl$way_sel;
  wire   [   3:0] ctrl$cacheresp_type;
  wire   [   0:0] ctrl$cachereq_en;
  wire   [   0:0] ctrl$amo_minu_sel;
  wire   [   0:0] ctrl$cacheresp_hit;
  wire   [   0:0] ctrl$is_refill;
  wire   [   3:0] ctrl$amo_sel;
  wire   [   0:0] ctrl$tag_array_0_wen;

  BlockingCacheCtrlPRTL_0x6ca49c37af2f92fc ctrl
  (
    .clk                   ( ctrl$clk ),
    .tag_match_0           ( ctrl$tag_match_0 ),
    .tag_match_1           ( ctrl$tag_match_1 ),
    .read_data_word        ( ctrl$read_data_word ),
    .cacheresp_rdy         ( ctrl$cacheresp_rdy ),
    .cachereq_type         ( ctrl$cachereq_type ),
    .memresp_val           ( ctrl$memresp_val ),
    .reset                 ( ctrl$reset ),
    .cachereq_data_word    ( ctrl$cachereq_data_word ),
    .cachereq_len_reg_out  ( ctrl$cachereq_len_reg_out ),
    .cachereq_addr         ( ctrl$cachereq_addr ),
    .memreq_rdy            ( ctrl$memreq_rdy ),
    .cachereq_val          ( ctrl$cachereq_val ),
    .cachereq_data_reg_out ( ctrl$cachereq_data_reg_out ),
    .data_array_wen        ( ctrl$data_array_wen ),
    .skip_read_data_reg    ( ctrl$skip_read_data_reg ),
    .memresp_en            ( ctrl$memresp_en ),
    .tag_array_0_ren       ( ctrl$tag_array_0_ren ),
    .way_sel_current       ( ctrl$way_sel_current ),
    .amo_maxu_sel          ( ctrl$amo_maxu_sel ),
    .cachereq_rdy          ( ctrl$cachereq_rdy ),
    .amo_min_sel           ( ctrl$amo_min_sel ),
    .read_tag_reg_en       ( ctrl$read_tag_reg_en ),
    .is_amo                ( ctrl$is_amo ),
    .memreq_type           ( ctrl$memreq_type ),
    .byte_offset           ( ctrl$byte_offset ),
    .data_array_ren        ( ctrl$data_array_ren ),
    .cacheresp_val         ( ctrl$cacheresp_val ),
    .amo_max_sel           ( ctrl$amo_max_sel ),
    .data_array_wben       ( ctrl$data_array_wben ),
    .read_data_reg_en      ( ctrl$read_data_reg_en ),
    .tag_array_1_ren       ( ctrl$tag_array_1_ren ),
    .tag_array_1_wen       ( ctrl$tag_array_1_wen ),
    .memreq_val            ( ctrl$memreq_val ),
    .memresp_rdy           ( ctrl$memresp_rdy ),
    .way_sel               ( ctrl$way_sel ),
    .cacheresp_type        ( ctrl$cacheresp_type ),
    .cachereq_en           ( ctrl$cachereq_en ),
    .amo_minu_sel          ( ctrl$amo_minu_sel ),
    .cacheresp_hit         ( ctrl$cacheresp_hit ),
    .is_refill             ( ctrl$is_refill ),
    .amo_sel               ( ctrl$amo_sel ),
    .tag_array_0_wen       ( ctrl$tag_array_0_wen )
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
  wire   [   0:0] dpath$data_array_wen;
  wire   [   0:0] dpath$memresp_en;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$skip_read_data_reg;
  wire   [   0:0] dpath$tag_array_0_ren;
  wire   [  77:0] dpath$cachereq_msg;
  wire   [   0:0] dpath$way_sel_current;
  wire   [   0:0] dpath$amo_maxu_sel;
  wire   [   0:0] dpath$amo_min_sel;
  wire   [   0:0] dpath$read_tag_reg_en;
  wire   [   0:0] dpath$is_amo;
  wire   [   3:0] dpath$memreq_type;
  wire   [   1:0] dpath$byte_offset;
  wire   [   0:0] dpath$data_array_ren;
  wire   [ 145:0] dpath$memresp_msg;
  wire   [   0:0] dpath$amo_max_sel;
  wire   [  15:0] dpath$data_array_wben;
  wire   [   0:0] dpath$read_data_reg_en;
  wire   [   0:0] dpath$tag_array_1_ren;
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$tag_array_1_wen;
  wire   [   0:0] dpath$way_sel;
  wire   [   3:0] dpath$cacheresp_type;
  wire   [   0:0] dpath$cachereq_en;
  wire   [   0:0] dpath$amo_minu_sel;
  wire   [   0:0] dpath$is_refill;
  wire   [   3:0] dpath$amo_sel;
  wire   [   0:0] dpath$cacheresp_hit;
  wire   [   0:0] dpath$tag_array_0_wen;
  wire   [   0:0] dpath$tag_match_0;
  wire   [   0:0] dpath$tag_match_1;
  wire   [  31:0] dpath$read_data_word;
  wire   [   3:0] dpath$cachereq_type;
  wire   [ 175:0] dpath$memreq_msg;
  wire   [  31:0] dpath$cachereq_data_word;
  wire   [  31:0] dpath$cachereq_data_reg_out;
  wire   [   1:0] dpath$cachereq_len_reg_out;
  wire   [  31:0] dpath$cachereq_addr;
  wire   [  47:0] dpath$cacheresp_msg;

  BlockingCacheDpathPRTL_0x499835e454a1a1cd dpath
  (
    .data_array_wen        ( dpath$data_array_wen ),
    .memresp_en            ( dpath$memresp_en ),
    .clk                   ( dpath$clk ),
    .skip_read_data_reg    ( dpath$skip_read_data_reg ),
    .tag_array_0_ren       ( dpath$tag_array_0_ren ),
    .cachereq_msg          ( dpath$cachereq_msg ),
    .way_sel_current       ( dpath$way_sel_current ),
    .amo_maxu_sel          ( dpath$amo_maxu_sel ),
    .amo_min_sel           ( dpath$amo_min_sel ),
    .read_tag_reg_en       ( dpath$read_tag_reg_en ),
    .is_amo                ( dpath$is_amo ),
    .memreq_type           ( dpath$memreq_type ),
    .byte_offset           ( dpath$byte_offset ),
    .data_array_ren        ( dpath$data_array_ren ),
    .memresp_msg           ( dpath$memresp_msg ),
    .amo_max_sel           ( dpath$amo_max_sel ),
    .data_array_wben       ( dpath$data_array_wben ),
    .read_data_reg_en      ( dpath$read_data_reg_en ),
    .tag_array_1_ren       ( dpath$tag_array_1_ren ),
    .reset                 ( dpath$reset ),
    .tag_array_1_wen       ( dpath$tag_array_1_wen ),
    .way_sel               ( dpath$way_sel ),
    .cacheresp_type        ( dpath$cacheresp_type ),
    .cachereq_en           ( dpath$cachereq_en ),
    .amo_minu_sel          ( dpath$amo_minu_sel ),
    .is_refill             ( dpath$is_refill ),
    .amo_sel               ( dpath$amo_sel ),
    .cacheresp_hit         ( dpath$cacheresp_hit ),
    .tag_array_0_wen       ( dpath$tag_array_0_wen ),
    .tag_match_0           ( dpath$tag_match_0 ),
    .tag_match_1           ( dpath$tag_match_1 ),
    .read_data_word        ( dpath$read_data_word ),
    .cachereq_type         ( dpath$cachereq_type ),
    .memreq_msg            ( dpath$memreq_msg ),
    .cachereq_data_word    ( dpath$cachereq_data_word ),
    .cachereq_data_reg_out ( dpath$cachereq_data_reg_out ),
    .cachereq_len_reg_out  ( dpath$cachereq_len_reg_out ),
    .cachereq_addr         ( dpath$cachereq_addr ),
    .cacheresp_msg         ( dpath$cacheresp_msg )
  );

  // signal connections
  assign cachereq_rdy               = ctrl$cachereq_rdy;
  assign cacheresp_msg              = resp_bypass$deq_msg;
  assign cacheresp_val              = resp_bypass$deq_val;
  assign ctrl$cachereq_addr         = dpath$cachereq_addr;
  assign ctrl$cachereq_data_reg_out = dpath$cachereq_data_reg_out;
  assign ctrl$cachereq_data_word    = dpath$cachereq_data_word;
  assign ctrl$cachereq_len_reg_out  = dpath$cachereq_len_reg_out;
  assign ctrl$cachereq_type         = dpath$cachereq_type;
  assign ctrl$cachereq_val          = cachereq_val;
  assign ctrl$cacheresp_rdy         = resp_bypass$enq_rdy;
  assign ctrl$clk                   = clk;
  assign ctrl$memreq_rdy            = memreq_rdy;
  assign ctrl$memresp_val           = memresp_val;
  assign ctrl$read_data_word        = dpath$read_data_word;
  assign ctrl$reset                 = reset;
  assign ctrl$tag_match_0           = dpath$tag_match_0;
  assign ctrl$tag_match_1           = dpath$tag_match_1;
  assign dpath$amo_max_sel          = ctrl$amo_max_sel;
  assign dpath$amo_maxu_sel         = ctrl$amo_maxu_sel;
  assign dpath$amo_min_sel          = ctrl$amo_min_sel;
  assign dpath$amo_minu_sel         = ctrl$amo_minu_sel;
  assign dpath$amo_sel              = ctrl$amo_sel;
  assign dpath$byte_offset          = ctrl$byte_offset;
  assign dpath$cachereq_en          = ctrl$cachereq_en;
  assign dpath$cachereq_msg         = cachereq_msg;
  assign dpath$cacheresp_hit        = ctrl$cacheresp_hit;
  assign dpath$cacheresp_type       = ctrl$cacheresp_type;
  assign dpath$clk                  = clk;
  assign dpath$data_array_ren       = ctrl$data_array_ren;
  assign dpath$data_array_wben      = ctrl$data_array_wben;
  assign dpath$data_array_wen       = ctrl$data_array_wen;
  assign dpath$is_amo               = ctrl$is_amo;
  assign dpath$is_refill            = ctrl$is_refill;
  assign dpath$memreq_type          = ctrl$memreq_type;
  assign dpath$memresp_en           = ctrl$memresp_en;
  assign dpath$memresp_msg          = memresp_msg;
  assign dpath$read_data_reg_en     = ctrl$read_data_reg_en;
  assign dpath$read_tag_reg_en      = ctrl$read_tag_reg_en;
  assign dpath$reset                = reset;
  assign dpath$skip_read_data_reg   = ctrl$skip_read_data_reg;
  assign dpath$tag_array_0_ren      = ctrl$tag_array_0_ren;
  assign dpath$tag_array_0_wen      = ctrl$tag_array_0_wen;
  assign dpath$tag_array_1_ren      = ctrl$tag_array_1_ren;
  assign dpath$tag_array_1_wen      = ctrl$tag_array_1_wen;
  assign dpath$way_sel              = ctrl$way_sel;
  assign dpath$way_sel_current      = ctrl$way_sel_current;
  assign memreq_msg                 = dpath$memreq_msg;
  assign memreq_val                 = ctrl$memreq_val;
  assign memresp_rdy                = ctrl$memresp_rdy;
  assign resp_bypass$clk            = clk;
  assign resp_bypass$deq_rdy        = cacheresp_rdy;
  assign resp_bypass$enq_msg        = dpath$cacheresp_msg;
  assign resp_bypass$enq_val        = ctrl$cacheresp_val;
  assign resp_bypass$reset          = reset;



endmodule // BlockingCachePRTL_0x588be82f2c2ad182
`default_nettype wire

//-----------------------------------------------------------------------------
// BlockingCacheCtrlPRTL_0x6ca49c37af2f92fc
//-----------------------------------------------------------------------------
// idx_shamt: 0
// MemReqMsgType: 176
// MemRespMsgType: 146
// CacheReqMsgType: 78
// CacheRespMsgType: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCacheCtrlPRTL_0x6ca49c37af2f92fc
(
  output reg  [   0:0] amo_max_sel,
  output reg  [   0:0] amo_maxu_sel,
  output reg  [   0:0] amo_min_sel,
  output reg  [   0:0] amo_minu_sel,
  output reg  [   3:0] amo_sel,
  output wire [   1:0] byte_offset,
  input  wire [  31:0] cachereq_addr,
  input  wire [  31:0] cachereq_data_reg_out,
  input  wire [  31:0] cachereq_data_word,
  output reg  [   0:0] cachereq_en,
  input  wire [   1:0] cachereq_len_reg_out,
  output reg  [   0:0] cachereq_rdy,
  input  wire [   3:0] cachereq_type,
  input  wire [   0:0] cachereq_val,
  output reg  [   0:0] cacheresp_hit,
  input  wire [   0:0] cacheresp_rdy,
  output reg  [   3:0] cacheresp_type,
  output reg  [   0:0] cacheresp_val,
  input  wire [   0:0] clk,
  output reg  [   0:0] data_array_ren,
  output reg  [  15:0] data_array_wben,
  output reg  [   0:0] data_array_wen,
  output reg  [   0:0] is_amo,
  output reg  [   0:0] is_refill,
  input  wire [   0:0] memreq_rdy,
  output reg  [   3:0] memreq_type,
  output reg  [   0:0] memreq_val,
  output reg  [   0:0] memresp_en,
  output reg  [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  output reg  [   0:0] read_data_reg_en,
  input  wire [  31:0] read_data_word,
  output reg  [   0:0] read_tag_reg_en,
  input  wire [   0:0] reset,
  output reg  [   0:0] skip_read_data_reg,
  output reg  [   0:0] tag_array_0_ren,
  output reg  [   0:0] tag_array_0_wen,
  output reg  [   0:0] tag_array_1_ren,
  output reg  [   0:0] tag_array_1_wen,
  input  wire [   0:0] tag_match_0,
  input  wire [   0:0] tag_match_1,
  output wire [   0:0] way_sel,
  output reg  [   0:0] way_sel_current
);

  // wire declarations
  wire   [   0:0] raw_dirty_bit_1;
  wire   [   0:0] raw_dirty_bit_0;
  wire   [ 255:0] valid_bits_1_out;
  wire   [   0:0] raw_lru_way;
  wire   [  15:0] wben_decoder_out;
  wire   [ 255:0] valid_bits_0_out;


  // register declarations
  reg    [   0:0] amo_hit;
  reg    [   7:0] cachereq_idx;
  reg    [   3:0] cachereq_offset;
  reg    [   3:0] cachereq_type__5;
  reg    [  20:0] cs;
  reg    [   0:0] dirty_bit_in;
  reg    [   0:0] dirty_bits_write_en;
  reg    [   0:0] dirty_bits_write_en_0;
  reg    [   0:0] dirty_bits_write_en_1;
  reg    [   0:0] evict;
  reg    [   0:0] hit;
  reg    [   0:0] hit_0;
  reg    [   0:0] hit_1;
  reg    [   0:0] in_go;
  reg    [   0:0] is_dirty_0;
  reg    [   0:0] is_dirty_1;
  reg    [   0:0] is_init;
  reg    [   0:0] is_read;
  reg    [   0:0] is_valid_0;
  reg    [   0:0] is_valid_1;
  reg    [   0:0] is_write;
  reg    [   0:0] lru_bit_in;
  reg    [   0:0] lru_bits_write_en;
  reg    [   0:0] lru_way;
  reg    [   0:0] miss_0;
  reg    [   0:0] miss_1;
  reg    [   3:0] ns;
  reg    [   0:0] out_go;
  reg    [   0:0] read_hit;
  reg    [   0:0] refill;
  reg    [   4:0] sn__13;
  reg    [   4:0] sr__12;
  reg    [   4:0] state_next;
  reg    [   4:0] state_reg;
  reg    [   0:0] tag_array_ren;
  reg    [   0:0] tag_array_wen;
  reg    [  32:0] tmp_min;
  reg    [   0:0] valid_bit_in;
  reg    [ 255:0] valid_bits_0_in;
  reg    [ 255:0] valid_bits_1_in;
  reg    [   0:0] valid_bits_write_en;
  reg    [   0:0] valid_bits_write_en_0;
  reg    [   0:0] valid_bits_write_en_1;
  reg    [   0:0] way_record_en;
  reg    [   0:0] way_record_in;
  reg    [   0:0] write_hit;

  // localparam declarations
  localparam STATE_AMO_READ_DATA_ACCESS_HIT = 5'd14;
  localparam STATE_AMO_READ_DATA_ACCESS_MISS = 5'd16;
  localparam STATE_AMO_WRITE_DATA_ACCESS_HIT = 5'd15;
  localparam STATE_AMO_WRITE_DATA_ACCESS_MISS = 5'd17;
  localparam STATE_EVICT_PREPARE = 5'd11;
  localparam STATE_EVICT_REQUEST = 5'd12;
  localparam STATE_EVICT_WAIT = 5'd13;
  localparam STATE_IDLE = 5'd0;
  localparam STATE_INIT_DATA_ACCESS = 5'd18;
  localparam STATE_READ_DATA_ACCESS_MISS = 5'd4;
  localparam STATE_REFILL_REQUEST = 5'd8;
  localparam STATE_REFILL_UPDATE = 5'd10;
  localparam STATE_REFILL_WAIT = 5'd9;
  localparam STATE_TAG_CHECK = 5'd1;
  localparam STATE_WAIT_HIT = 5'd6;
  localparam STATE_WAIT_MISS = 5'd7;
  localparam STATE_WRITE_CACHE_RESP_HIT = 5'd2;
  localparam STATE_WRITE_DATA_ACCESS_HIT = 5'd3;
  localparam STATE_WRITE_DATA_ACCESS_MISS = 5'd5;
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
  localparam TYPE_WRITE_INIT = 2;
  localparam dbw = 32;
  localparam left_idx = 4;
  localparam m_e = 4'd1;
  localparam m_len_bw = 4;
  localparam m_r = 4'd0;
  localparam m_x = 4'd0;
  localparam n = 1'd0;
  localparam r_c = 1'd0;
  localparam r_m = 1'd1;
  localparam r_x = 1'd0;
  localparam right_idx = 12;
  localparam x = 1'd0;
  localparam y = 1'd1;

  // lru_bits temporaries
  wire   [   7:0] lru_bits$rd_addr$000;
  wire   [   0:0] lru_bits$wr_data;
  wire   [   0:0] lru_bits$clk;
  wire   [   7:0] lru_bits$wr_addr;
  wire   [   0:0] lru_bits$wr_en;
  wire   [   0:0] lru_bits$reset;
  wire   [   0:0] lru_bits$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b lru_bits
  (
    .rd_addr$000 ( lru_bits$rd_addr$000 ),
    .wr_data     ( lru_bits$wr_data ),
    .clk         ( lru_bits$clk ),
    .wr_addr     ( lru_bits$wr_addr ),
    .wr_en       ( lru_bits$wr_en ),
    .reset       ( lru_bits$reset ),
    .rd_data$000 ( lru_bits$rd_data$000 )
  );

  // wben_decoder temporaries
  wire   [   0:0] wben_decoder$reset;
  wire   [   3:0] wben_decoder$idx;
  wire   [   0:0] wben_decoder$clk;
  wire   [   1:0] wben_decoder$len;
  wire   [  15:0] wben_decoder$out;

  DecodeWbenPRTL_0x284d798dca7f4f70 wben_decoder
  (
    .reset ( wben_decoder$reset ),
    .idx   ( wben_decoder$idx ),
    .clk   ( wben_decoder$clk ),
    .len   ( wben_decoder$len ),
    .out   ( wben_decoder$out )
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

  // dirty_bits_0 temporaries
  wire   [   7:0] dirty_bits_0$rd_addr$000;
  wire   [   0:0] dirty_bits_0$wr_data;
  wire   [   0:0] dirty_bits_0$clk;
  wire   [   7:0] dirty_bits_0$wr_addr;
  wire   [   0:0] dirty_bits_0$wr_en;
  wire   [   0:0] dirty_bits_0$reset;
  wire   [   0:0] dirty_bits_0$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b dirty_bits_0
  (
    .rd_addr$000 ( dirty_bits_0$rd_addr$000 ),
    .wr_data     ( dirty_bits_0$wr_data ),
    .clk         ( dirty_bits_0$clk ),
    .wr_addr     ( dirty_bits_0$wr_addr ),
    .wr_en       ( dirty_bits_0$wr_en ),
    .reset       ( dirty_bits_0$reset ),
    .rd_data$000 ( dirty_bits_0$rd_data$000 )
  );

  // dirty_bits_1 temporaries
  wire   [   7:0] dirty_bits_1$rd_addr$000;
  wire   [   0:0] dirty_bits_1$wr_data;
  wire   [   0:0] dirty_bits_1$clk;
  wire   [   7:0] dirty_bits_1$wr_addr;
  wire   [   0:0] dirty_bits_1$wr_en;
  wire   [   0:0] dirty_bits_1$reset;
  wire   [   0:0] dirty_bits_1$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b dirty_bits_1
  (
    .rd_addr$000 ( dirty_bits_1$rd_addr$000 ),
    .wr_data     ( dirty_bits_1$wr_data ),
    .clk         ( dirty_bits_1$clk ),
    .wr_addr     ( dirty_bits_1$wr_addr ),
    .wr_en       ( dirty_bits_1$wr_en ),
    .reset       ( dirty_bits_1$reset ),
    .rd_data$000 ( dirty_bits_1$rd_data$000 )
  );

  // valid_bits_0 temporaries
  wire   [   0:0] valid_bits_0$reset;
  wire   [   0:0] valid_bits_0$en;
  wire   [   0:0] valid_bits_0$clk;
  wire   [ 255:0] valid_bits_0$in_;
  wire   [ 255:0] valid_bits_0$out;

  RegEnRst_0x1c65c01affad8788 valid_bits_0
  (
    .reset ( valid_bits_0$reset ),
    .en    ( valid_bits_0$en ),
    .clk   ( valid_bits_0$clk ),
    .in_   ( valid_bits_0$in_ ),
    .out   ( valid_bits_0$out )
  );

  // valid_bits_1 temporaries
  wire   [   0:0] valid_bits_1$reset;
  wire   [   0:0] valid_bits_1$en;
  wire   [   0:0] valid_bits_1$clk;
  wire   [ 255:0] valid_bits_1$in_;
  wire   [ 255:0] valid_bits_1$out;

  RegEnRst_0x1c65c01affad8788 valid_bits_1
  (
    .reset ( valid_bits_1$reset ),
    .en    ( valid_bits_1$en ),
    .clk   ( valid_bits_1$clk ),
    .in_   ( valid_bits_1$in_ ),
    .out   ( valid_bits_1$out )
  );

  // signal connections
  assign dirty_bits_0$clk         = clk;
  assign dirty_bits_0$rd_addr$000 = cachereq_idx;
  assign dirty_bits_0$reset       = reset;
  assign dirty_bits_0$wr_addr     = cachereq_idx;
  assign dirty_bits_0$wr_data     = dirty_bit_in;
  assign dirty_bits_0$wr_en       = dirty_bits_write_en_0;
  assign dirty_bits_1$clk         = clk;
  assign dirty_bits_1$rd_addr$000 = cachereq_idx;
  assign dirty_bits_1$reset       = reset;
  assign dirty_bits_1$wr_addr     = cachereq_idx;
  assign dirty_bits_1$wr_data     = dirty_bit_in;
  assign dirty_bits_1$wr_en       = dirty_bits_write_en_1;
  assign lru_bits$clk             = clk;
  assign lru_bits$rd_addr$000     = cachereq_idx;
  assign lru_bits$reset           = reset;
  assign lru_bits$wr_addr         = cachereq_idx;
  assign lru_bits$wr_data         = lru_bit_in;
  assign lru_bits$wr_en           = lru_bits_write_en;
  assign raw_dirty_bit_0          = dirty_bits_0$rd_data$000;
  assign raw_dirty_bit_1          = dirty_bits_1$rd_data$000;
  assign raw_lru_way              = lru_bits$rd_data$000;
  assign valid_bits_0$clk         = clk;
  assign valid_bits_0$en          = valid_bits_write_en_0;
  assign valid_bits_0$in_         = valid_bits_0_in;
  assign valid_bits_0$reset       = reset;
  assign valid_bits_0_out         = valid_bits_0$out;
  assign valid_bits_1$clk         = clk;
  assign valid_bits_1$en          = valid_bits_write_en_1;
  assign valid_bits_1$in_         = valid_bits_1_in;
  assign valid_bits_1$reset       = reset;
  assign valid_bits_1_out         = valid_bits_1$out;
  assign way_record$clk           = clk;
  assign way_record$en            = way_record_en;
  assign way_record$in_           = way_record_in;
  assign way_record$reset         = reset;
  assign way_sel                  = way_record$out;
  assign wben_decoder$clk         = clk;
  assign wben_decoder$idx         = cachereq_offset;
  assign wben_decoder$len         = cachereq_len_reg_out;
  assign wben_decoder$reset       = reset;
  assign wben_decoder_out         = wben_decoder$out;


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
  // def gen_ctrl_signals():
  //       # Generate dirty bits
  //       s.is_dirty_0.value = s.is_valid_0 & s.raw_dirty_bit_0
  //       s.is_dirty_1.value = s.is_valid_1 & s.raw_dirty_bit_1
  //
  //       # LRU
  //       s.lru_way   .value = ( s.is_valid_0 | s.is_valid_1 ) & \
  //                              s.raw_lru_way

  // logic for gen_ctrl_signals()
  always @ (*) begin
    is_dirty_0 = (is_valid_0&raw_dirty_bit_0);
    is_dirty_1 = (is_valid_1&raw_dirty_bit_1);
    lru_way = ((is_valid_0|is_valid_1)&raw_lru_way);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_state_transition():
  //       s.in_go.value     = s.cachereq_val  & s.cachereq_rdy
  //       s.out_go.value    = s.cacheresp_val & s.cacheresp_rdy
  //       s.hit_0.value     = s.is_valid_0 & s.tag_match_0
  //       s.hit_1.value     = s.is_valid_1 & s.tag_match_1
  //       s.hit.value       = s.hit_0 | s.hit_1
  //       s.is_read.value   = s.cachereq_type == MemReqMsg.TYPE_READ
  //       s.is_write.value  = s.cachereq_type == MemReqMsg.TYPE_WRITE
  //       s.is_init.value   = s.cachereq_type == MemReqMsg.TYPE_WRITE_INIT
  //       s.read_hit.value  = s.is_read & s.hit
  //       s.write_hit.value = s.is_write & s.hit
  //       s.amo_hit.value   = s.is_amo & s.hit
  //       s.miss_0.value    = ~s.hit_0
  //       s.miss_1.value    = ~s.hit_1
  //       s.refill.value    = (s.miss_0 & ~s.is_dirty_0 & ~s.lru_way) | \
  //                           (s.miss_1 & ~s.is_dirty_1 &  s.lru_way)
  //       s.evict.value     = (s.miss_0 &  s.is_dirty_0 & ~s.lru_way) | \
  //                           (s.miss_1 &  s.is_dirty_1 &  s.lru_way)

  // logic for comb_state_transition()
  always @ (*) begin
    in_go = (cachereq_val&cachereq_rdy);
    out_go = (cacheresp_val&cacheresp_rdy);
    hit_0 = (is_valid_0&tag_match_0);
    hit_1 = (is_valid_1&tag_match_1);
    hit = (hit_0|hit_1);
    is_read = (cachereq_type == TYPE_READ);
    is_write = (cachereq_type == TYPE_WRITE);
    is_init = (cachereq_type == TYPE_WRITE_INIT);
    read_hit = (is_read&hit);
    write_hit = (is_write&hit);
    amo_hit = (is_amo&hit);
    miss_0 = ~hit_0;
    miss_1 = ~hit_1;
    refill = (((miss_0&~is_dirty_0)&~lru_way)|((miss_1&~is_dirty_1)&lru_way));
    evict = (((miss_0&is_dirty_0)&~lru_way)|((miss_1&is_dirty_1)&lru_way));
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_min():
  //       s.tmp_min.value = concat( s.cachereq_data_word[dbw-1], s.cachereq_data_word ) \
  //                          - concat( s.read_data_word[dbw-1], s.read_data_word )
  //
  //       s.amo_min_sel.value  = s.tmp_min[dbw]
  //       s.amo_minu_sel.value = s.cachereq_data_word < s.read_data_word

  // logic for comb_amo_min()
  always @ (*) begin
    tmp_min = ({ cachereq_data_word[(dbw-1)],cachereq_data_word }-{ read_data_word[(dbw-1)],read_data_word });
    amo_min_sel = tmp_min[dbw];
    amo_minu_sel = (cachereq_data_word < read_data_word);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_max():
  //       s.amo_max_sel.value  = ~s.amo_min_sel
  //       s.amo_maxu_sel.value = ~s.amo_minu_sel

  // logic for comb_amo_max()
  always @ (*) begin
    amo_max_sel = ~amo_min_sel;
    amo_maxu_sel = ~amo_minu_sel;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_type():
  //       cachereq_type = s.cachereq_type
  //       if   cachereq_type == MemReqMsg.TYPE_AMO_ADD  : s.amo_sel.value =  0; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_AND  : s.amo_sel.value =  1; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_OR   : s.amo_sel.value =  2; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_SWAP : s.amo_sel.value =  3; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MIN  : s.amo_sel.value =  4; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MINU : s.amo_sel.value =  5; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MAX  : s.amo_sel.value =  6; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MAXU : s.amo_sel.value =  7; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_XOR  : s.amo_sel.value =  8; s.is_amo.value = 1;
  //       else                                          : s.amo_sel.value =  0; s.is_amo.value = 0;

  // logic for comb_amo_type()
  always @ (*) begin
    cachereq_type__5 = cachereq_type;
    if ((cachereq_type__5 == TYPE_AMO_ADD)) begin
      amo_sel = 0;
      is_amo = 1;
    end
    else begin
      if ((cachereq_type__5 == TYPE_AMO_AND)) begin
        amo_sel = 1;
        is_amo = 1;
      end
      else begin
        if ((cachereq_type__5 == TYPE_AMO_OR)) begin
          amo_sel = 2;
          is_amo = 1;
        end
        else begin
          if ((cachereq_type__5 == TYPE_AMO_SWAP)) begin
            amo_sel = 3;
            is_amo = 1;
          end
          else begin
            if ((cachereq_type__5 == TYPE_AMO_MIN)) begin
              amo_sel = 4;
              is_amo = 1;
            end
            else begin
              if ((cachereq_type__5 == TYPE_AMO_MINU)) begin
                amo_sel = 5;
                is_amo = 1;
              end
              else begin
                if ((cachereq_type__5 == TYPE_AMO_MAX)) begin
                  amo_sel = 6;
                  is_amo = 1;
                end
                else begin
                  if ((cachereq_type__5 == TYPE_AMO_MAXU)) begin
                    amo_sel = 7;
                    is_amo = 1;
                  end
                  else begin
                    if ((cachereq_type__5 == TYPE_AMO_XOR)) begin
                      amo_sel = 8;
                      is_amo = 1;
                    end
                    else begin
                      amo_sel = 0;
                      is_amo = 0;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_next_state():
  //       s.state_next.value = s.state_reg
  //       if s.state_reg == s.STATE_IDLE:
  //         if ( s.in_go ) : s.state_next.value = s.STATE_TAG_CHECK
  //
  //       elif s.state_reg == s.STATE_TAG_CHECK:
  //         if   ( s.is_init      )                                   : s.state_next.value = s.STATE_INIT_DATA_ACCESS
  //         elif ( s.read_hit  &  s.cacheresp_rdy &  s.cachereq_val ) : s.state_next.value = s.STATE_TAG_CHECK
  //         elif ( s.read_hit  &  s.cacheresp_rdy & ~s.cachereq_val ) : s.state_next.value = s.STATE_IDLE
  //         elif ( s.read_hit  & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WAIT_HIT
  //         elif ( s.write_hit &  s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT
  //         elif ( s.write_hit & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_CACHE_RESP_HIT
  //         elif ( s.amo_hit      )                                   : s.state_next.value = s.STATE_AMO_READ_DATA_ACCESS_HIT
  //         elif ( s.refill       )                                   : s.state_next.value = s.STATE_REFILL_REQUEST
  //         elif ( s.evict        )                                   : s.state_next.value = s.STATE_EVICT_PREPARE
  //
  //       elif s.state_reg == s.STATE_WRITE_CACHE_RESP_HIT:
  //         if (s.cacheresp_rdy):   s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT
  //
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
  //         if (s.cachereq_val):    s.state_next.value = s.STATE_TAG_CHECK
  //         else:                   s.state_next.value = s.STATE_IDLE
  //
  //       elif s.state_reg == s.STATE_READ_DATA_ACCESS_MISS:
  //         s.state_next.value =    s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_MISS:
  //         if (s.cacheresp_rdy):   s.state_next.value = s.STATE_IDLE
  //         else:                   s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_INIT_DATA_ACCESS:
  //         s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_AMO_READ_DATA_ACCESS_HIT:
  //         s.state_next.value = s.STATE_AMO_WRITE_DATA_ACCESS_HIT
  //
  //       elif s.state_reg == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:
  //         s.state_next.value = s.STATE_WAIT_HIT
  //
  //       elif s.state_reg == s.STATE_AMO_READ_DATA_ACCESS_MISS:
  //         s.state_next.value = s.STATE_AMO_WRITE_DATA_ACCESS_MISS
  //
  //       elif s.state_reg == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:
  //         s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_REFILL_REQUEST:
  //         if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_REFILL_WAIT
  //         elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_REFILL_REQUEST
  //
  //       elif s.state_reg == s.STATE_REFILL_WAIT:
  //         if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_UPDATE
  //         elif ( ~s.memresp_val ): s.state_next.value = s.STATE_REFILL_WAIT
  //
  //       elif s.state_reg == s.STATE_REFILL_UPDATE:
  //         if   ( s.is_read      ): s.state_next.value = s.STATE_READ_DATA_ACCESS_MISS
  //         elif ( s.is_write     ): s.state_next.value = s.STATE_WRITE_DATA_ACCESS_MISS
  //         elif ( s.is_amo       ): s.state_next.value = s.STATE_AMO_READ_DATA_ACCESS_MISS
  //
  //       elif s.state_reg == s.STATE_EVICT_PREPARE:
  //         s.state_next.value = s.STATE_EVICT_REQUEST
  //
  //       elif s.state_reg == s.STATE_EVICT_REQUEST:
  //         if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_EVICT_WAIT
  //         elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_EVICT_REQUEST
  //
  //       elif s.state_reg == s.STATE_EVICT_WAIT:
  //         if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_REQUEST
  //         elif ( ~s.memresp_val ): s.state_next.value = s.STATE_EVICT_WAIT
  //
  //       elif s.state_reg == s.STATE_WAIT_HIT:
  //         if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE
  //
  //       elif s.state_reg == s.STATE_WAIT_MISS:
  //         if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE
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
        if (is_init) begin
          state_next = STATE_INIT_DATA_ACCESS;
        end
        else begin
          if (((read_hit&cacheresp_rdy)&cachereq_val)) begin
            state_next = STATE_TAG_CHECK;
          end
          else begin
            if (((read_hit&cacheresp_rdy)&~cachereq_val)) begin
              state_next = STATE_IDLE;
            end
            else begin
              if ((read_hit&~cacheresp_rdy)) begin
                state_next = STATE_WAIT_HIT;
              end
              else begin
                if ((write_hit&cacheresp_rdy)) begin
                  state_next = STATE_WRITE_DATA_ACCESS_HIT;
                end
                else begin
                  if ((write_hit&~cacheresp_rdy)) begin
                    state_next = STATE_WRITE_CACHE_RESP_HIT;
                  end
                  else begin
                    if (amo_hit) begin
                      state_next = STATE_AMO_READ_DATA_ACCESS_HIT;
                    end
                    else begin
                      if (refill) begin
                        state_next = STATE_REFILL_REQUEST;
                      end
                      else begin
                        if (evict) begin
                          state_next = STATE_EVICT_PREPARE;
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
        if ((state_reg == STATE_WRITE_CACHE_RESP_HIT)) begin
          if (cacheresp_rdy) begin
            state_next = STATE_WRITE_DATA_ACCESS_HIT;
          end
          else begin
          end
        end
        else begin
          if ((state_reg == STATE_WRITE_DATA_ACCESS_HIT)) begin
            if (cachereq_val) begin
              state_next = STATE_TAG_CHECK;
            end
            else begin
              state_next = STATE_IDLE;
            end
          end
          else begin
            if ((state_reg == STATE_READ_DATA_ACCESS_MISS)) begin
              state_next = STATE_WAIT_MISS;
            end
            else begin
              if ((state_reg == STATE_WRITE_DATA_ACCESS_MISS)) begin
                if (cacheresp_rdy) begin
                  state_next = STATE_IDLE;
                end
                else begin
                  state_next = STATE_WAIT_MISS;
                end
              end
              else begin
                if ((state_reg == STATE_INIT_DATA_ACCESS)) begin
                  state_next = STATE_WAIT_MISS;
                end
                else begin
                  if ((state_reg == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    state_next = STATE_AMO_WRITE_DATA_ACCESS_HIT;
                  end
                  else begin
                    if ((state_reg == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      state_next = STATE_WAIT_HIT;
                    end
                    else begin
                      if ((state_reg == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        state_next = STATE_AMO_WRITE_DATA_ACCESS_MISS;
                      end
                      else begin
                        if ((state_reg == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          state_next = STATE_WAIT_MISS;
                        end
                        else begin
                          if ((state_reg == STATE_REFILL_REQUEST)) begin
                            if (memreq_rdy) begin
                              state_next = STATE_REFILL_WAIT;
                            end
                            else begin
                              if (~memreq_rdy) begin
                                state_next = STATE_REFILL_REQUEST;
                              end
                              else begin
                              end
                            end
                          end
                          else begin
                            if ((state_reg == STATE_REFILL_WAIT)) begin
                              if (memresp_val) begin
                                state_next = STATE_REFILL_UPDATE;
                              end
                              else begin
                                if (~memresp_val) begin
                                  state_next = STATE_REFILL_WAIT;
                                end
                                else begin
                                end
                              end
                            end
                            else begin
                              if ((state_reg == STATE_REFILL_UPDATE)) begin
                                if (is_read) begin
                                  state_next = STATE_READ_DATA_ACCESS_MISS;
                                end
                                else begin
                                  if (is_write) begin
                                    state_next = STATE_WRITE_DATA_ACCESS_MISS;
                                  end
                                  else begin
                                    if (is_amo) begin
                                      state_next = STATE_AMO_READ_DATA_ACCESS_MISS;
                                    end
                                    else begin
                                    end
                                  end
                                end
                              end
                              else begin
                                if ((state_reg == STATE_EVICT_PREPARE)) begin
                                  state_next = STATE_EVICT_REQUEST;
                                end
                                else begin
                                  if ((state_reg == STATE_EVICT_REQUEST)) begin
                                    if (memreq_rdy) begin
                                      state_next = STATE_EVICT_WAIT;
                                    end
                                    else begin
                                      if (~memreq_rdy) begin
                                        state_next = STATE_EVICT_REQUEST;
                                      end
                                      else begin
                                      end
                                    end
                                  end
                                  else begin
                                    if ((state_reg == STATE_EVICT_WAIT)) begin
                                      if (memresp_val) begin
                                        state_next = STATE_REFILL_REQUEST;
                                      end
                                      else begin
                                        if (~memresp_val) begin
                                          state_next = STATE_EVICT_WAIT;
                                        end
                                        else begin
                                        end
                                      end
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_idx():
  //       s.cachereq_idx.value          = s.cachereq_addr[left_idx:right_idx]
  //       s.valid_bits_write_en_0.value = s.valid_bits_write_en & ~s.way_sel_current
  //       s.valid_bits_write_en_1.value = s.valid_bits_write_en &  s.way_sel_current

  // logic for comb_cachereq_idx()
  always @ (*) begin
    cachereq_idx = cachereq_addr[(right_idx)-1:left_idx];
    valid_bits_write_en_0 = (valid_bits_write_en&~way_sel_current);
    valid_bits_write_en_1 = (valid_bits_write_en&way_sel_current);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_valid_0():
  //       # Generate valids for writes
  //       s.valid_bits_0_in                .value = s.valid_bits_0_out
  //       s.valid_bits_0_in[s.cachereq_idx].value = s.valid_bit_in
  //
  //       # Read valids
  //       s.is_valid_0                     .value = s.valid_bits_0_out[s.cachereq_idx]

  // logic for gen_valid_0()
  always @ (*) begin
    valid_bits_0_in = valid_bits_0_out;
    valid_bits_0_in[cachereq_idx] = valid_bit_in;
    is_valid_0 = valid_bits_0_out[cachereq_idx];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_valid_1():
  //       # Generate valids for writes
  //       s.valid_bits_1_in                .value = s.valid_bits_1_out
  //       s.valid_bits_1_in[s.cachereq_idx].value = s.valid_bit_in
  //
  //       # Read valids
  //       s.is_valid_1                     .value = s.valid_bits_1_out[s.cachereq_idx]

  // logic for gen_valid_1()
  always @ (*) begin
    valid_bits_1_in = valid_bits_1_out;
    valid_bits_1_in[cachereq_idx] = valid_bit_in;
    is_valid_1 = valid_bits_1_out[cachereq_idx];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_idx():
  //       s.dirty_bits_write_en_0.value = s.dirty_bits_write_en & ~s.way_sel_current
  //       s.dirty_bits_write_en_1.value = s.dirty_bits_write_en &  s.way_sel_current

  // logic for comb_cachereq_idx()
  always @ (*) begin
    dirty_bits_write_en_0 = (dirty_bits_write_en&~way_sel_current);
    dirty_bits_write_en_1 = (dirty_bits_write_en&way_sel_current);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_way_select():
  //       if (s.hit) :
  //         if (s.hit_0) :
  //           s.way_record_in.value = Bits( 1, 0 )
  //         else :
  //           if (s.hit_1) :
  //             s.way_record_in.value = Bits( 1, 1 )
  //           else :
  //             s.way_record_in.value = Bits( 1, 0 )
  //       else :
  //         s.way_record_in.value = s.lru_way
  //
  //       if s.state_reg == s.STATE_TAG_CHECK:
  //         s.way_sel_current.value = s.way_record_in
  //       else:
  //         s.way_sel_current.value = s.way_sel

  // logic for comb_way_select()
  always @ (*) begin
    if (hit) begin
      if (hit_0) begin
        way_record_in = 1'd0;
      end
      else begin
        if (hit_1) begin
          way_record_in = 1'd1;
        end
        else begin
          way_record_in = 1'd0;
        end
      end
    end
    else begin
      way_record_in = lru_way;
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
  // def comb_control_table():
  //       sr = s.state_reg
  //
  //       #                                                                    $    $    mem mem  $    mem         read read mem  valid valid dirty dirty lru   way    $    skip
  //       #                                                                    req  resp req resp req  resp is     data tag  req  bit   write bit   write write record resp data
  //       #                                                                    rdy  val  val rdy  en   en   refill en   en   type in    en    in    en    en    en     hit  reg
  //       s.cs.value                                                 = concat( n,   n,   n,  n,   x,   x,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       if   sr == s.STATE_IDLE:                        s.cs.value = concat( y,   n,   n,  n,   y,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_TAG_CHECK:                   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    y,     n,   y    )
  //       elif sr == s.STATE_WRITE_CACHE_RESP_HIT:        s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    y,    n,     y,   n    )
  //       elif sr == s.STATE_WRITE_DATA_ACCESS_HIT:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     y,   n    )
  //       elif sr == s.STATE_READ_DATA_ACCESS_MISS:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   n    )
  //       elif sr == s.STATE_WRITE_DATA_ACCESS_MISS:      s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_INIT_DATA_ACCESS:            s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    n,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_AMO_READ_DATA_ACCESS_HIT:    s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   y    )
  //       elif sr == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_AMO_READ_DATA_ACCESS_MISS:   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   y    )
  //       elif sr == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:  s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_REQUEST:              s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_r, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_WAIT:                 s.cs.value = concat( n,   n,   n,  y,   n,   y,   r_m,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_UPDATE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, y,    y,    n,    y,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_PREPARE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   y,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_REQUEST:               s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_e, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_WAIT:                  s.cs.value = concat( n,   n,   n,  y,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_WAIT_HIT:                    s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     y,   n    )
  //       elif sr == s.STATE_WAIT_MISS:                   s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       else :                                          s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //
  //       # Unpack signals
  //
  //       s.cachereq_rdy.value        = s.cs[ CS_cachereq_rdy        ]
  //       s.cacheresp_val.value       = s.cs[ CS_cacheresp_val       ]
  //       s.memreq_val.value          = s.cs[ CS_memreq_val          ]
  //       s.memresp_rdy.value         = s.cs[ CS_memresp_rdy         ]
  //       s.cachereq_en.value         = s.cs[ CS_cachereq_en         ]
  //       s.memresp_en.value          = s.cs[ CS_memresp_en          ]
  //       s.is_refill.value           = s.cs[ CS_is_refill           ]
  //       s.read_data_reg_en.value    = s.cs[ CS_read_data_reg_en    ]
  //       s.read_tag_reg_en.value     = s.cs[ CS_read_tag_reg_en     ]
  //       s.memreq_type.value         = s.cs[ CS_memreq_type         ]
  //       s.valid_bit_in.value        = s.cs[ CS_valid_bit_in        ]
  //       s.valid_bits_write_en.value = s.cs[ CS_valid_bits_write_en ]
  //       s.dirty_bit_in.value        = s.cs[ CS_dirty_bit_in        ]
  //       s.dirty_bits_write_en.value = s.cs[ CS_dirty_bits_write_en ]
  //       s.lru_bits_write_en.value   = s.cs[ CS_lru_bits_write_en   ]
  //       s.way_record_en.value       = s.cs[ CS_way_record_en       ]
  //       s.cacheresp_hit.value       = s.cs[ CS_cacheresp_hit       ]
  //       s.skip_read_data_reg.value  = s.cs[ CS_skip_read_data_reg  ]
  //
  //       # set cacheresp_val when there is a hit for one hit latency
  //       if (s.read_hit | s.write_hit) and (s.state_reg == s.STATE_TAG_CHECK):
  //         s.cacheresp_val.value = 1
  //         s.cacheresp_hit.value = 1
  //
  //         # if read hit, if can send response, immediately take new cachereq
  //         if s.read_hit:
  //           s.cachereq_rdy.value  = s.cacheresp_rdy
  //           s.cachereq_en.value   = s.cacheresp_rdy
  //
  //       # since cacheresp already handled, can immediately take new cachereq
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
  //         s.cachereq_rdy.value  = 1
  //         s.cachereq_en.value   = 1

  // logic for comb_control_table()
  always @ (*) begin
    sr__12 = state_reg;
    cs = { n,n,n,n,x,x,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
    if ((sr__12 == STATE_IDLE)) begin
      cs = { y,n,n,n,y,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
    end
    else begin
      if ((sr__12 == STATE_TAG_CHECK)) begin
        cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,y,n,y };
      end
      else begin
        if ((sr__12 == STATE_WRITE_CACHE_RESP_HIT)) begin
          cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,y,n,y,n };
        end
        else begin
          if ((sr__12 == STATE_WRITE_DATA_ACCESS_HIT)) begin
            cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,y,n };
          end
          else begin
            if ((sr__12 == STATE_READ_DATA_ACCESS_MISS)) begin
              cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,n };
            end
            else begin
              if ((sr__12 == STATE_WRITE_DATA_ACCESS_MISS)) begin
                cs = { n,y,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
              end
              else begin
                if ((sr__12 == STATE_INIT_DATA_ACCESS)) begin
                  cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,n,y,y,n,n,n };
                end
                else begin
                  if ((sr__12 == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,y };
                  end
                  else begin
                    if ((sr__12 == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
                    end
                    else begin
                      if ((sr__12 == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,y };
                      end
                      else begin
                        if ((sr__12 == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
                        end
                        else begin
                          if ((sr__12 == STATE_REFILL_REQUEST)) begin
                            cs = { n,n,y,n,n,n,r_x,n,n,m_r,x,n,x,n,n,n,n,n };
                          end
                          else begin
                            if ((sr__12 == STATE_REFILL_WAIT)) begin
                              cs = { n,n,n,y,n,y,r_m,n,n,m_x,x,n,x,n,n,n,n,n };
                            end
                            else begin
                              if ((sr__12 == STATE_REFILL_UPDATE)) begin
                                cs = { n,n,n,n,n,n,r_x,n,n,m_x,y,y,n,y,n,n,n,n };
                              end
                              else begin
                                if ((sr__12 == STATE_EVICT_PREPARE)) begin
                                  cs = { n,n,n,n,n,n,r_x,y,y,m_x,x,n,x,n,n,n,n,n };
                                end
                                else begin
                                  if ((sr__12 == STATE_EVICT_REQUEST)) begin
                                    cs = { n,n,y,n,n,n,r_x,n,n,m_e,x,n,x,n,n,n,n,n };
                                  end
                                  else begin
                                    if ((sr__12 == STATE_EVICT_WAIT)) begin
                                      cs = { n,n,n,y,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
                                    end
                                    else begin
                                      if ((sr__12 == STATE_WAIT_HIT)) begin
                                        cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,y,n };
                                      end
                                      else begin
                                        if ((sr__12 == STATE_WAIT_MISS)) begin
                                          cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
                                        end
                                        else begin
                                          cs = { n,n,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
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
    cachereq_rdy = cs[(21)-1:20];
    cacheresp_val = cs[(20)-1:19];
    memreq_val = cs[(19)-1:18];
    memresp_rdy = cs[(18)-1:17];
    cachereq_en = cs[(17)-1:16];
    memresp_en = cs[(16)-1:15];
    is_refill = cs[(15)-1:14];
    read_data_reg_en = cs[(14)-1:13];
    read_tag_reg_en = cs[(13)-1:12];
    memreq_type = cs[(12)-1:8];
    valid_bit_in = cs[(8)-1:7];
    valid_bits_write_en = cs[(7)-1:6];
    dirty_bit_in = cs[(6)-1:5];
    dirty_bits_write_en = cs[(5)-1:4];
    lru_bits_write_en = cs[(4)-1:3];
    way_record_en = cs[(3)-1:2];
    cacheresp_hit = cs[(2)-1:1];
    skip_read_data_reg = cs[(1)-1:0];
    if (((read_hit|write_hit)&&(state_reg == STATE_TAG_CHECK))) begin
      cacheresp_val = 1;
      cacheresp_hit = 1;
      if (read_hit) begin
        cachereq_rdy = cacheresp_rdy;
        cachereq_en = cacheresp_rdy;
      end
      else begin
      end
    end
    else begin
      if ((state_reg == STATE_WRITE_DATA_ACCESS_HIT)) begin
        cachereq_rdy = 1;
        cachereq_en = 1;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_control_table():
  //
  //       # set enable for tag_array and data_array one cycle early (dependant on next_state)
  //       sn = s.state_next
  //       s.ns.value = concat( n,   n,    n,  n )
  //       #                                                                   tag   tag   data  data
  //       #                                                                   array array array array
  //       #                                                                   wen   ren   wen   ren
  //       if   sn == s.STATE_IDLE:                        s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_TAG_CHECK:                   s.ns.value = concat( n,    y,    n,    y,   )
  //       elif sn == s.STATE_WRITE_CACHE_RESP_HIT:        s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WRITE_DATA_ACCESS_HIT:       s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_READ_DATA_ACCESS_MISS:       s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_WRITE_DATA_ACCESS_MISS:      s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_INIT_DATA_ACCESS:            s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_AMO_READ_DATA_ACCESS_HIT:    s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:   s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_AMO_READ_DATA_ACCESS_MISS:   s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:  s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_REFILL_REQUEST:              s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_REFILL_WAIT:                 s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_REFILL_UPDATE:               s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_EVICT_PREPARE:               s.ns.value = concat( n,    y,    n,    y,   )
  //       elif sn == s.STATE_EVICT_REQUEST:               s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_EVICT_WAIT:                  s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WAIT_HIT:                    s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WAIT_MISS:                   s.ns.value = concat( n,    n,    n,    n,   )
  //       else :                                          s.ns.value = concat( n,    n,    n,    n,   )
  //
  //       # Unpack signals
  //
  //       s.tag_array_wen.value  = s.ns[ NS_tag_array_wen  ]
  //       s.tag_array_ren.value  = s.ns[ NS_tag_array_ren  ]
  //       s.data_array_wen.value = s.ns[ NS_data_array_wen ]
  //       s.data_array_ren.value = s.ns[ NS_data_array_ren ]

  // logic for comb_control_table()
  always @ (*) begin
    sn__13 = state_next;
    ns = { n,n,n,n };
    if ((sn__13 == STATE_IDLE)) begin
      ns = { n,n,n,n };
    end
    else begin
      if ((sn__13 == STATE_TAG_CHECK)) begin
        ns = { n,y,n,y };
      end
      else begin
        if ((sn__13 == STATE_WRITE_CACHE_RESP_HIT)) begin
          ns = { n,n,n,n };
        end
        else begin
          if ((sn__13 == STATE_WRITE_DATA_ACCESS_HIT)) begin
            ns = { y,n,y,n };
          end
          else begin
            if ((sn__13 == STATE_READ_DATA_ACCESS_MISS)) begin
              ns = { n,n,n,y };
            end
            else begin
              if ((sn__13 == STATE_WRITE_DATA_ACCESS_MISS)) begin
                ns = { y,n,y,n };
              end
              else begin
                if ((sn__13 == STATE_INIT_DATA_ACCESS)) begin
                  ns = { y,n,y,n };
                end
                else begin
                  if ((sn__13 == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    ns = { n,n,n,y };
                  end
                  else begin
                    if ((sn__13 == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      ns = { y,n,y,n };
                    end
                    else begin
                      if ((sn__13 == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        ns = { n,n,n,y };
                      end
                      else begin
                        if ((sn__13 == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          ns = { y,n,y,n };
                        end
                        else begin
                          if ((sn__13 == STATE_REFILL_REQUEST)) begin
                            ns = { n,n,n,n };
                          end
                          else begin
                            if ((sn__13 == STATE_REFILL_WAIT)) begin
                              ns = { n,n,n,n };
                            end
                            else begin
                              if ((sn__13 == STATE_REFILL_UPDATE)) begin
                                ns = { y,n,y,n };
                              end
                              else begin
                                if ((sn__13 == STATE_EVICT_PREPARE)) begin
                                  ns = { n,y,n,y };
                                end
                                else begin
                                  if ((sn__13 == STATE_EVICT_REQUEST)) begin
                                    ns = { n,n,n,n };
                                  end
                                  else begin
                                    if ((sn__13 == STATE_EVICT_WAIT)) begin
                                      ns = { n,n,n,n };
                                    end
                                    else begin
                                      if ((sn__13 == STATE_WAIT_HIT)) begin
                                        ns = { n,n,n,n };
                                      end
                                      else begin
                                        if ((sn__13 == STATE_WAIT_MISS)) begin
                                          ns = { n,n,n,n };
                                        end
                                        else begin
                                          ns = { n,n,n,n };
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
    tag_array_wen = ns[(4)-1:3];
    tag_array_ren = ns[(3)-1:2];
    data_array_wen = ns[(2)-1:1];
    data_array_ren = ns[(1)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_lru_bit_in():
  //       s.lru_bit_in.value = ~s.way_sel_current

  // logic for comb_lru_bit_in()
  always @ (*) begin
    lru_bit_in = ~way_sel_current;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_tag_arry_en():
  //       s.tag_array_0_wen.value = s.tag_array_wen & ~s.way_sel_current
  //       s.tag_array_0_ren.value = s.tag_array_ren
  //       s.tag_array_1_wen.value = s.tag_array_wen &  s.way_sel_current
  //       s.tag_array_1_ren.value = s.tag_array_ren

  // logic for comb_tag_arry_en()
  always @ (*) begin
    tag_array_0_wen = (tag_array_wen&~way_sel_current);
    tag_array_0_ren = tag_array_ren;
    tag_array_1_wen = (tag_array_wen&way_sel_current);
    tag_array_1_ren = tag_array_ren;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_offset():
  //       s.cachereq_offset.value = s.cachereq_addr[0:m_len_bw]

  // logic for comb_cachereq_offset()
  always @ (*) begin
    cachereq_offset = cachereq_addr[(m_len_bw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_enable_writing():
  //
  //       # Logic to enable writing of the entire cacheline in case of refill
  //       # and just one word for writes and init
  //
  //       if ( s.is_refill ) : s.data_array_wben.value = Bits( 16, 0xffff )
  //       else               : s.data_array_wben.value = s.wben_decoder_out
  //
  //       # Managing the cache response type based on cache request type
  //
  //       s.cacheresp_type.value = s.cachereq_type

  // logic for comb_enable_writing()
  always @ (*) begin
    if (is_refill) begin
      data_array_wben = 16'd65535;
    end
    else begin
      data_array_wben = wben_decoder_out;
    end
    cacheresp_type = cachereq_type;
  end


endmodule // BlockingCacheCtrlPRTL_0x6ca49c37af2f92fc
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x282b3c6d2858fe2b
//-----------------------------------------------------------------------------
// dtype: 1
// nregs: 256
// rd_ports: 1
// wr_ports: 1
// const_zero: False
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x282b3c6d2858fe2b
(
  input  wire [   0:0] clk,
  input  wire [   7:0] rd_addr$000,
  output wire [   0:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   7:0] wr_addr,
  input  wire [   0:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [   0:0] regs$000;
  wire   [   0:0] regs$001;
  wire   [   0:0] regs$002;
  wire   [   0:0] regs$003;
  wire   [   0:0] regs$004;
  wire   [   0:0] regs$005;
  wire   [   0:0] regs$006;
  wire   [   0:0] regs$007;
  wire   [   0:0] regs$008;
  wire   [   0:0] regs$009;
  wire   [   0:0] regs$010;
  wire   [   0:0] regs$011;
  wire   [   0:0] regs$012;
  wire   [   0:0] regs$013;
  wire   [   0:0] regs$014;
  wire   [   0:0] regs$015;
  wire   [   0:0] regs$016;
  wire   [   0:0] regs$017;
  wire   [   0:0] regs$018;
  wire   [   0:0] regs$019;
  wire   [   0:0] regs$020;
  wire   [   0:0] regs$021;
  wire   [   0:0] regs$022;
  wire   [   0:0] regs$023;
  wire   [   0:0] regs$024;
  wire   [   0:0] regs$025;
  wire   [   0:0] regs$026;
  wire   [   0:0] regs$027;
  wire   [   0:0] regs$028;
  wire   [   0:0] regs$029;
  wire   [   0:0] regs$030;
  wire   [   0:0] regs$031;
  wire   [   0:0] regs$032;
  wire   [   0:0] regs$033;
  wire   [   0:0] regs$034;
  wire   [   0:0] regs$035;
  wire   [   0:0] regs$036;
  wire   [   0:0] regs$037;
  wire   [   0:0] regs$038;
  wire   [   0:0] regs$039;
  wire   [   0:0] regs$040;
  wire   [   0:0] regs$041;
  wire   [   0:0] regs$042;
  wire   [   0:0] regs$043;
  wire   [   0:0] regs$044;
  wire   [   0:0] regs$045;
  wire   [   0:0] regs$046;
  wire   [   0:0] regs$047;
  wire   [   0:0] regs$048;
  wire   [   0:0] regs$049;
  wire   [   0:0] regs$050;
  wire   [   0:0] regs$051;
  wire   [   0:0] regs$052;
  wire   [   0:0] regs$053;
  wire   [   0:0] regs$054;
  wire   [   0:0] regs$055;
  wire   [   0:0] regs$056;
  wire   [   0:0] regs$057;
  wire   [   0:0] regs$058;
  wire   [   0:0] regs$059;
  wire   [   0:0] regs$060;
  wire   [   0:0] regs$061;
  wire   [   0:0] regs$062;
  wire   [   0:0] regs$063;
  wire   [   0:0] regs$064;
  wire   [   0:0] regs$065;
  wire   [   0:0] regs$066;
  wire   [   0:0] regs$067;
  wire   [   0:0] regs$068;
  wire   [   0:0] regs$069;
  wire   [   0:0] regs$070;
  wire   [   0:0] regs$071;
  wire   [   0:0] regs$072;
  wire   [   0:0] regs$073;
  wire   [   0:0] regs$074;
  wire   [   0:0] regs$075;
  wire   [   0:0] regs$076;
  wire   [   0:0] regs$077;
  wire   [   0:0] regs$078;
  wire   [   0:0] regs$079;
  wire   [   0:0] regs$080;
  wire   [   0:0] regs$081;
  wire   [   0:0] regs$082;
  wire   [   0:0] regs$083;
  wire   [   0:0] regs$084;
  wire   [   0:0] regs$085;
  wire   [   0:0] regs$086;
  wire   [   0:0] regs$087;
  wire   [   0:0] regs$088;
  wire   [   0:0] regs$089;
  wire   [   0:0] regs$090;
  wire   [   0:0] regs$091;
  wire   [   0:0] regs$092;
  wire   [   0:0] regs$093;
  wire   [   0:0] regs$094;
  wire   [   0:0] regs$095;
  wire   [   0:0] regs$096;
  wire   [   0:0] regs$097;
  wire   [   0:0] regs$098;
  wire   [   0:0] regs$099;
  wire   [   0:0] regs$100;
  wire   [   0:0] regs$101;
  wire   [   0:0] regs$102;
  wire   [   0:0] regs$103;
  wire   [   0:0] regs$104;
  wire   [   0:0] regs$105;
  wire   [   0:0] regs$106;
  wire   [   0:0] regs$107;
  wire   [   0:0] regs$108;
  wire   [   0:0] regs$109;
  wire   [   0:0] regs$110;
  wire   [   0:0] regs$111;
  wire   [   0:0] regs$112;
  wire   [   0:0] regs$113;
  wire   [   0:0] regs$114;
  wire   [   0:0] regs$115;
  wire   [   0:0] regs$116;
  wire   [   0:0] regs$117;
  wire   [   0:0] regs$118;
  wire   [   0:0] regs$119;
  wire   [   0:0] regs$120;
  wire   [   0:0] regs$121;
  wire   [   0:0] regs$122;
  wire   [   0:0] regs$123;
  wire   [   0:0] regs$124;
  wire   [   0:0] regs$125;
  wire   [   0:0] regs$126;
  wire   [   0:0] regs$127;
  wire   [   0:0] regs$128;
  wire   [   0:0] regs$129;
  wire   [   0:0] regs$130;
  wire   [   0:0] regs$131;
  wire   [   0:0] regs$132;
  wire   [   0:0] regs$133;
  wire   [   0:0] regs$134;
  wire   [   0:0] regs$135;
  wire   [   0:0] regs$136;
  wire   [   0:0] regs$137;
  wire   [   0:0] regs$138;
  wire   [   0:0] regs$139;
  wire   [   0:0] regs$140;
  wire   [   0:0] regs$141;
  wire   [   0:0] regs$142;
  wire   [   0:0] regs$143;
  wire   [   0:0] regs$144;
  wire   [   0:0] regs$145;
  wire   [   0:0] regs$146;
  wire   [   0:0] regs$147;
  wire   [   0:0] regs$148;
  wire   [   0:0] regs$149;
  wire   [   0:0] regs$150;
  wire   [   0:0] regs$151;
  wire   [   0:0] regs$152;
  wire   [   0:0] regs$153;
  wire   [   0:0] regs$154;
  wire   [   0:0] regs$155;
  wire   [   0:0] regs$156;
  wire   [   0:0] regs$157;
  wire   [   0:0] regs$158;
  wire   [   0:0] regs$159;
  wire   [   0:0] regs$160;
  wire   [   0:0] regs$161;
  wire   [   0:0] regs$162;
  wire   [   0:0] regs$163;
  wire   [   0:0] regs$164;
  wire   [   0:0] regs$165;
  wire   [   0:0] regs$166;
  wire   [   0:0] regs$167;
  wire   [   0:0] regs$168;
  wire   [   0:0] regs$169;
  wire   [   0:0] regs$170;
  wire   [   0:0] regs$171;
  wire   [   0:0] regs$172;
  wire   [   0:0] regs$173;
  wire   [   0:0] regs$174;
  wire   [   0:0] regs$175;
  wire   [   0:0] regs$176;
  wire   [   0:0] regs$177;
  wire   [   0:0] regs$178;
  wire   [   0:0] regs$179;
  wire   [   0:0] regs$180;
  wire   [   0:0] regs$181;
  wire   [   0:0] regs$182;
  wire   [   0:0] regs$183;
  wire   [   0:0] regs$184;
  wire   [   0:0] regs$185;
  wire   [   0:0] regs$186;
  wire   [   0:0] regs$187;
  wire   [   0:0] regs$188;
  wire   [   0:0] regs$189;
  wire   [   0:0] regs$190;
  wire   [   0:0] regs$191;
  wire   [   0:0] regs$192;
  wire   [   0:0] regs$193;
  wire   [   0:0] regs$194;
  wire   [   0:0] regs$195;
  wire   [   0:0] regs$196;
  wire   [   0:0] regs$197;
  wire   [   0:0] regs$198;
  wire   [   0:0] regs$199;
  wire   [   0:0] regs$200;
  wire   [   0:0] regs$201;
  wire   [   0:0] regs$202;
  wire   [   0:0] regs$203;
  wire   [   0:0] regs$204;
  wire   [   0:0] regs$205;
  wire   [   0:0] regs$206;
  wire   [   0:0] regs$207;
  wire   [   0:0] regs$208;
  wire   [   0:0] regs$209;
  wire   [   0:0] regs$210;
  wire   [   0:0] regs$211;
  wire   [   0:0] regs$212;
  wire   [   0:0] regs$213;
  wire   [   0:0] regs$214;
  wire   [   0:0] regs$215;
  wire   [   0:0] regs$216;
  wire   [   0:0] regs$217;
  wire   [   0:0] regs$218;
  wire   [   0:0] regs$219;
  wire   [   0:0] regs$220;
  wire   [   0:0] regs$221;
  wire   [   0:0] regs$222;
  wire   [   0:0] regs$223;
  wire   [   0:0] regs$224;
  wire   [   0:0] regs$225;
  wire   [   0:0] regs$226;
  wire   [   0:0] regs$227;
  wire   [   0:0] regs$228;
  wire   [   0:0] regs$229;
  wire   [   0:0] regs$230;
  wire   [   0:0] regs$231;
  wire   [   0:0] regs$232;
  wire   [   0:0] regs$233;
  wire   [   0:0] regs$234;
  wire   [   0:0] regs$235;
  wire   [   0:0] regs$236;
  wire   [   0:0] regs$237;
  wire   [   0:0] regs$238;
  wire   [   0:0] regs$239;
  wire   [   0:0] regs$240;
  wire   [   0:0] regs$241;
  wire   [   0:0] regs$242;
  wire   [   0:0] regs$243;
  wire   [   0:0] regs$244;
  wire   [   0:0] regs$245;
  wire   [   0:0] regs$246;
  wire   [   0:0] regs$247;
  wire   [   0:0] regs$248;
  wire   [   0:0] regs$249;
  wire   [   0:0] regs$250;
  wire   [   0:0] regs$251;
  wire   [   0:0] regs$252;
  wire   [   0:0] regs$253;
  wire   [   0:0] regs$254;
  wire   [   0:0] regs$255;


  // localparam declarations
  localparam nregs = 256;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   7:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [   0:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [   0:0] regs[0:255];
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
  assign regs$032 = regs[ 32];
  assign regs$033 = regs[ 33];
  assign regs$034 = regs[ 34];
  assign regs$035 = regs[ 35];
  assign regs$036 = regs[ 36];
  assign regs$037 = regs[ 37];
  assign regs$038 = regs[ 38];
  assign regs$039 = regs[ 39];
  assign regs$040 = regs[ 40];
  assign regs$041 = regs[ 41];
  assign regs$042 = regs[ 42];
  assign regs$043 = regs[ 43];
  assign regs$044 = regs[ 44];
  assign regs$045 = regs[ 45];
  assign regs$046 = regs[ 46];
  assign regs$047 = regs[ 47];
  assign regs$048 = regs[ 48];
  assign regs$049 = regs[ 49];
  assign regs$050 = regs[ 50];
  assign regs$051 = regs[ 51];
  assign regs$052 = regs[ 52];
  assign regs$053 = regs[ 53];
  assign regs$054 = regs[ 54];
  assign regs$055 = regs[ 55];
  assign regs$056 = regs[ 56];
  assign regs$057 = regs[ 57];
  assign regs$058 = regs[ 58];
  assign regs$059 = regs[ 59];
  assign regs$060 = regs[ 60];
  assign regs$061 = regs[ 61];
  assign regs$062 = regs[ 62];
  assign regs$063 = regs[ 63];
  assign regs$064 = regs[ 64];
  assign regs$065 = regs[ 65];
  assign regs$066 = regs[ 66];
  assign regs$067 = regs[ 67];
  assign regs$068 = regs[ 68];
  assign regs$069 = regs[ 69];
  assign regs$070 = regs[ 70];
  assign regs$071 = regs[ 71];
  assign regs$072 = regs[ 72];
  assign regs$073 = regs[ 73];
  assign regs$074 = regs[ 74];
  assign regs$075 = regs[ 75];
  assign regs$076 = regs[ 76];
  assign regs$077 = regs[ 77];
  assign regs$078 = regs[ 78];
  assign regs$079 = regs[ 79];
  assign regs$080 = regs[ 80];
  assign regs$081 = regs[ 81];
  assign regs$082 = regs[ 82];
  assign regs$083 = regs[ 83];
  assign regs$084 = regs[ 84];
  assign regs$085 = regs[ 85];
  assign regs$086 = regs[ 86];
  assign regs$087 = regs[ 87];
  assign regs$088 = regs[ 88];
  assign regs$089 = regs[ 89];
  assign regs$090 = regs[ 90];
  assign regs$091 = regs[ 91];
  assign regs$092 = regs[ 92];
  assign regs$093 = regs[ 93];
  assign regs$094 = regs[ 94];
  assign regs$095 = regs[ 95];
  assign regs$096 = regs[ 96];
  assign regs$097 = regs[ 97];
  assign regs$098 = regs[ 98];
  assign regs$099 = regs[ 99];
  assign regs$100 = regs[100];
  assign regs$101 = regs[101];
  assign regs$102 = regs[102];
  assign regs$103 = regs[103];
  assign regs$104 = regs[104];
  assign regs$105 = regs[105];
  assign regs$106 = regs[106];
  assign regs$107 = regs[107];
  assign regs$108 = regs[108];
  assign regs$109 = regs[109];
  assign regs$110 = regs[110];
  assign regs$111 = regs[111];
  assign regs$112 = regs[112];
  assign regs$113 = regs[113];
  assign regs$114 = regs[114];
  assign regs$115 = regs[115];
  assign regs$116 = regs[116];
  assign regs$117 = regs[117];
  assign regs$118 = regs[118];
  assign regs$119 = regs[119];
  assign regs$120 = regs[120];
  assign regs$121 = regs[121];
  assign regs$122 = regs[122];
  assign regs$123 = regs[123];
  assign regs$124 = regs[124];
  assign regs$125 = regs[125];
  assign regs$126 = regs[126];
  assign regs$127 = regs[127];
  assign regs$128 = regs[128];
  assign regs$129 = regs[129];
  assign regs$130 = regs[130];
  assign regs$131 = regs[131];
  assign regs$132 = regs[132];
  assign regs$133 = regs[133];
  assign regs$134 = regs[134];
  assign regs$135 = regs[135];
  assign regs$136 = regs[136];
  assign regs$137 = regs[137];
  assign regs$138 = regs[138];
  assign regs$139 = regs[139];
  assign regs$140 = regs[140];
  assign regs$141 = regs[141];
  assign regs$142 = regs[142];
  assign regs$143 = regs[143];
  assign regs$144 = regs[144];
  assign regs$145 = regs[145];
  assign regs$146 = regs[146];
  assign regs$147 = regs[147];
  assign regs$148 = regs[148];
  assign regs$149 = regs[149];
  assign regs$150 = regs[150];
  assign regs$151 = regs[151];
  assign regs$152 = regs[152];
  assign regs$153 = regs[153];
  assign regs$154 = regs[154];
  assign regs$155 = regs[155];
  assign regs$156 = regs[156];
  assign regs$157 = regs[157];
  assign regs$158 = regs[158];
  assign regs$159 = regs[159];
  assign regs$160 = regs[160];
  assign regs$161 = regs[161];
  assign regs$162 = regs[162];
  assign regs$163 = regs[163];
  assign regs$164 = regs[164];
  assign regs$165 = regs[165];
  assign regs$166 = regs[166];
  assign regs$167 = regs[167];
  assign regs$168 = regs[168];
  assign regs$169 = regs[169];
  assign regs$170 = regs[170];
  assign regs$171 = regs[171];
  assign regs$172 = regs[172];
  assign regs$173 = regs[173];
  assign regs$174 = regs[174];
  assign regs$175 = regs[175];
  assign regs$176 = regs[176];
  assign regs$177 = regs[177];
  assign regs$178 = regs[178];
  assign regs$179 = regs[179];
  assign regs$180 = regs[180];
  assign regs$181 = regs[181];
  assign regs$182 = regs[182];
  assign regs$183 = regs[183];
  assign regs$184 = regs[184];
  assign regs$185 = regs[185];
  assign regs$186 = regs[186];
  assign regs$187 = regs[187];
  assign regs$188 = regs[188];
  assign regs$189 = regs[189];
  assign regs$190 = regs[190];
  assign regs$191 = regs[191];
  assign regs$192 = regs[192];
  assign regs$193 = regs[193];
  assign regs$194 = regs[194];
  assign regs$195 = regs[195];
  assign regs$196 = regs[196];
  assign regs$197 = regs[197];
  assign regs$198 = regs[198];
  assign regs$199 = regs[199];
  assign regs$200 = regs[200];
  assign regs$201 = regs[201];
  assign regs$202 = regs[202];
  assign regs$203 = regs[203];
  assign regs$204 = regs[204];
  assign regs$205 = regs[205];
  assign regs$206 = regs[206];
  assign regs$207 = regs[207];
  assign regs$208 = regs[208];
  assign regs$209 = regs[209];
  assign regs$210 = regs[210];
  assign regs$211 = regs[211];
  assign regs$212 = regs[212];
  assign regs$213 = regs[213];
  assign regs$214 = regs[214];
  assign regs$215 = regs[215];
  assign regs$216 = regs[216];
  assign regs$217 = regs[217];
  assign regs$218 = regs[218];
  assign regs$219 = regs[219];
  assign regs$220 = regs[220];
  assign regs$221 = regs[221];
  assign regs$222 = regs[222];
  assign regs$223 = regs[223];
  assign regs$224 = regs[224];
  assign regs$225 = regs[225];
  assign regs$226 = regs[226];
  assign regs$227 = regs[227];
  assign regs$228 = regs[228];
  assign regs$229 = regs[229];
  assign regs$230 = regs[230];
  assign regs$231 = regs[231];
  assign regs$232 = regs[232];
  assign regs$233 = regs[233];
  assign regs$234 = regs[234];
  assign regs$235 = regs[235];
  assign regs$236 = regs[236];
  assign regs$237 = regs[237];
  assign regs$238 = regs[238];
  assign regs$239 = regs[239];
  assign regs$240 = regs[240];
  assign regs$241 = regs[241];
  assign regs$242 = regs[242];
  assign regs$243 = regs[243];
  assign regs$244 = regs[244];
  assign regs$245 = regs[245];
  assign regs$246 = regs[246];
  assign regs$247 = regs[247];
  assign regs$248 = regs[248];
  assign regs$249 = regs[249];
  assign regs$250 = regs[250];
  assign regs$251 = regs[251];
  assign regs$252 = regs[252];
  assign regs$253 = regs[253];
  assign regs$254 = regs[254];
  assign regs$255 = regs[255];

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


endmodule // RegisterFile_0x282b3c6d2858fe2b
`default_nettype wire

//-----------------------------------------------------------------------------
// DecodeWbenPRTL_0x284d798dca7f4f70
//-----------------------------------------------------------------------------
// num_bytes: 16
// mask_num_bytes: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DecodeWbenPRTL_0x284d798dca7f4f70
(
  input  wire [   0:0] clk,
  input  wire [   3:0] idx,
  input  wire [   1:0] len,
  output reg  [  15:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   1:0] len_d;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       # Adjusted length
  //       s.len_d.value = s.len - 1
  //
  //       # Construct a mask
  //       s.out  .value = 0
  //       s.out  .value = ~s.out
  //       s.out  .value = s.out << 1
  //       s.out  .value = s.out << s.len_d
  //       s.out  .value = ~s.out
  //
  //       # Shift to starting index
  //       s.out  .value = s.out.value << s.idx

  // logic for comb_logic()
  always @ (*) begin
    len_d = (len-1);
    out = 0;
    out = ~out;
    out = (out<<1);
    out = (out<<len_d);
    out = ~out;
    out = (out<<idx);
  end


endmodule // DecodeWbenPRTL_0x284d798dca7f4f70
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
// BlockingCacheDpathPRTL_0x499835e454a1a1cd
//-----------------------------------------------------------------------------
// idx_shamt: 0
// MemReqMsgType: 176
// MemRespMsgType: 146
// CacheReqMsgType: 78
// CacheRespMsgType: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCacheDpathPRTL_0x499835e454a1a1cd
(
  input  wire [   0:0] amo_max_sel,
  input  wire [   0:0] amo_maxu_sel,
  input  wire [   0:0] amo_min_sel,
  input  wire [   0:0] amo_minu_sel,
  input  wire [   3:0] amo_sel,
  input  wire [   1:0] byte_offset,
  output wire [  31:0] cachereq_addr,
  output wire [  31:0] cachereq_data_reg_out,
  output reg  [  31:0] cachereq_data_word,
  input  wire [   0:0] cachereq_en,
  output wire [   1:0] cachereq_len_reg_out,
  input  wire [  77:0] cachereq_msg,
  output wire [   3:0] cachereq_type,
  input  wire [   0:0] cacheresp_hit,
  output reg  [  47:0] cacheresp_msg,
  input  wire [   3:0] cacheresp_type,
  input  wire [   0:0] clk,
  input  wire [   0:0] data_array_ren,
  input  wire [  15:0] data_array_wben,
  input  wire [   0:0] data_array_wen,
  input  wire [   0:0] is_amo,
  input  wire [   0:0] is_refill,
  output reg  [ 175:0] memreq_msg,
  input  wire [   3:0] memreq_type,
  input  wire [   0:0] memresp_en,
  input  wire [ 145:0] memresp_msg,
  input  wire [   0:0] read_data_reg_en,
  output reg  [  31:0] read_data_word,
  input  wire [   0:0] read_tag_reg_en,
  input  wire [   0:0] reset,
  input  wire [   0:0] skip_read_data_reg,
  input  wire [   0:0] tag_array_0_ren,
  input  wire [   0:0] tag_array_0_wen,
  input  wire [   0:0] tag_array_1_ren,
  input  wire [   0:0] tag_array_1_wen,
  output wire [   0:0] tag_match_0,
  output wire [   0:0] tag_match_1,
  input  wire [   0:0] way_sel,
  input  wire [   0:0] way_sel_current
);

  // wire declarations
  wire   [  31:0] read_data;
  wire   [  27:0] memreq_type_mux_out;
  wire   [ 127:0] int_read_data;
  wire   [ 127:0] data_array_1_read_out;
  wire   [  31:0] cacheresp_data_out;
  wire   [  31:0] tag_array_0_read_out;
  wire   [  31:0] tag_array_1_read_out;
  wire   [ 127:0] data_array_0_read_out;


  // register declarations
  reg    [  31:0] amo_out;
  reg    [  31:0] cachereq_data_reg_out_add;
  reg    [  31:0] cachereq_data_reg_out_and;
  reg    [  31:0] cachereq_data_reg_out_max;
  reg    [  31:0] cachereq_data_reg_out_maxu;
  reg    [  31:0] cachereq_data_reg_out_min;
  reg    [  31:0] cachereq_data_reg_out_minu;
  reg    [  31:0] cachereq_data_reg_out_or;
  reg    [  31:0] cachereq_data_reg_out_swap;
  reg    [  31:0] cachereq_data_reg_out_xor;
  reg    [   9:0] cachereq_idx;
  reg    [  31:0] cachereq_msg_addr;
  reg    [   3:0] cachereq_offset;
  reg    [  27:0] cachereq_tag;
  reg    [   9:0] cur_cachereq_idx;
  reg    [   0:0] data_array_0_wen;
  reg    [   0:0] data_array_1_wen;
  reg    [  31:0] memreq_addr;
  reg    [   0:0] sram_data_0_en;
  reg    [   0:0] sram_data_1_en;
  reg    [   0:0] sram_tag_0_en;
  reg    [   0:0] sram_tag_1_en;
  reg    [  31:0] temp_cachereq_tag;

  // localparam declarations
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
  localparam abw = 32;
  localparam dbw = 32;
  localparam idw_off = 14;
  localparam m_len_bw = 4;

  // read_tag_reg temporaries
  wire   [   0:0] read_tag_reg$reset;
  wire   [   0:0] read_tag_reg$en;
  wire   [   0:0] read_tag_reg$clk;
  wire   [  27:0] read_tag_reg$in_;
  wire   [  27:0] read_tag_reg$out;

  RegEnRst_0x35d76e7a8821f894 read_tag_reg
  (
    .reset ( read_tag_reg$reset ),
    .en    ( read_tag_reg$en ),
    .clk   ( read_tag_reg$clk ),
    .in_   ( read_tag_reg$in_ ),
    .out   ( read_tag_reg$out )
  );

  // cachereq_data_reg temporaries
  wire   [   0:0] cachereq_data_reg$reset;
  wire   [   0:0] cachereq_data_reg$en;
  wire   [   0:0] cachereq_data_reg$clk;
  wire   [  31:0] cachereq_data_reg$in_;
  wire   [  31:0] cachereq_data_reg$out;

  RegEnRst_0x3857337130dc0828 cachereq_data_reg
  (
    .reset ( cachereq_data_reg$reset ),
    .en    ( cachereq_data_reg$en ),
    .clk   ( cachereq_data_reg$clk ),
    .in_   ( cachereq_data_reg$in_ ),
    .out   ( cachereq_data_reg$out )
  );

  // cachereq_len_reg temporaries
  wire   [   0:0] cachereq_len_reg$reset;
  wire   [   0:0] cachereq_len_reg$en;
  wire   [   0:0] cachereq_len_reg$clk;
  wire   [   1:0] cachereq_len_reg$in_;
  wire   [   1:0] cachereq_len_reg$out;

  RegEnRst_0x9f365fdf6c8998a cachereq_len_reg
  (
    .reset ( cachereq_len_reg$reset ),
    .en    ( cachereq_len_reg$en ),
    .clk   ( cachereq_len_reg$clk ),
    .in_   ( cachereq_len_reg$in_ ),
    .out   ( cachereq_len_reg$out )
  );

  // amo_minu_mux temporaries
  wire   [   0:0] amo_minu_mux$reset;
  wire   [  31:0] amo_minu_mux$in_$000;
  wire   [  31:0] amo_minu_mux$in_$001;
  wire   [   0:0] amo_minu_mux$clk;
  wire   [   0:0] amo_minu_mux$sel;
  wire   [  31:0] amo_minu_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_minu_mux
  (
    .reset   ( amo_minu_mux$reset ),
    .in_$000 ( amo_minu_mux$in_$000 ),
    .in_$001 ( amo_minu_mux$in_$001 ),
    .clk     ( amo_minu_mux$clk ),
    .sel     ( amo_minu_mux$sel ),
    .out     ( amo_minu_mux$out )
  );

  // amo_sel_mux temporaries
  wire   [   0:0] amo_sel_mux$reset;
  wire   [  31:0] amo_sel_mux$in_$000;
  wire   [  31:0] amo_sel_mux$in_$001;
  wire   [  31:0] amo_sel_mux$in_$002;
  wire   [  31:0] amo_sel_mux$in_$003;
  wire   [  31:0] amo_sel_mux$in_$004;
  wire   [  31:0] amo_sel_mux$in_$005;
  wire   [  31:0] amo_sel_mux$in_$006;
  wire   [  31:0] amo_sel_mux$in_$007;
  wire   [  31:0] amo_sel_mux$in_$008;
  wire   [   0:0] amo_sel_mux$clk;
  wire   [   3:0] amo_sel_mux$sel;
  wire   [  31:0] amo_sel_mux$out;

  Mux_0x1256f43349e9a82f amo_sel_mux
  (
    .reset   ( amo_sel_mux$reset ),
    .in_$000 ( amo_sel_mux$in_$000 ),
    .in_$001 ( amo_sel_mux$in_$001 ),
    .in_$002 ( amo_sel_mux$in_$002 ),
    .in_$003 ( amo_sel_mux$in_$003 ),
    .in_$004 ( amo_sel_mux$in_$004 ),
    .in_$005 ( amo_sel_mux$in_$005 ),
    .in_$006 ( amo_sel_mux$in_$006 ),
    .in_$007 ( amo_sel_mux$in_$007 ),
    .in_$008 ( amo_sel_mux$in_$008 ),
    .clk     ( amo_sel_mux$clk ),
    .sel     ( amo_sel_mux$sel ),
    .out     ( amo_sel_mux$out )
  );

  // tag_compare_0 temporaries
  wire   [   0:0] tag_compare_0$reset;
  wire   [   0:0] tag_compare_0$clk;
  wire   [  27:0] tag_compare_0$in0;
  wire   [  27:0] tag_compare_0$in1;
  wire   [   0:0] tag_compare_0$out;

  EqComparator_0x4b38e35357dbd1ff tag_compare_0
  (
    .reset ( tag_compare_0$reset ),
    .clk   ( tag_compare_0$clk ),
    .in0   ( tag_compare_0$in0 ),
    .in1   ( tag_compare_0$in1 ),
    .out   ( tag_compare_0$out )
  );

  // tag_compare_1 temporaries
  wire   [   0:0] tag_compare_1$reset;
  wire   [   0:0] tag_compare_1$clk;
  wire   [  27:0] tag_compare_1$in0;
  wire   [  27:0] tag_compare_1$in1;
  wire   [   0:0] tag_compare_1$out;

  EqComparator_0x4b38e35357dbd1ff tag_compare_1
  (
    .reset ( tag_compare_1$reset ),
    .clk   ( tag_compare_1$clk ),
    .in0   ( tag_compare_1$in0 ),
    .in1   ( tag_compare_1$in1 ),
    .out   ( tag_compare_1$out )
  );

  // skip_read_data_mux temporaries
  wire   [   0:0] skip_read_data_mux$reset;
  wire   [ 127:0] skip_read_data_mux$in_$000;
  wire   [ 127:0] skip_read_data_mux$in_$001;
  wire   [   0:0] skip_read_data_mux$clk;
  wire   [   0:0] skip_read_data_mux$sel;
  wire   [ 127:0] skip_read_data_mux$out;

  Mux_0x5af2f539a1a7deea skip_read_data_mux
  (
    .reset   ( skip_read_data_mux$reset ),
    .in_$000 ( skip_read_data_mux$in_$000 ),
    .in_$001 ( skip_read_data_mux$in_$001 ),
    .clk     ( skip_read_data_mux$clk ),
    .sel     ( skip_read_data_mux$sel ),
    .out     ( skip_read_data_mux$out )
  );

  // tag_array_0 temporaries
  wire   [   0:0] tag_array_0$ce;
  wire   [  31:0] tag_array_0$in_;
  wire   [   9:0] tag_array_0$addr;
  wire   [   3:0] tag_array_0$wmask;
  wire   [   0:0] tag_array_0$clk;
  wire   [   0:0] tag_array_0$we;
  wire   [   0:0] tag_array_0$reset;
  wire   [  31:0] tag_array_0$out;

  SramRTL_0x1d0877c36bd105f4 tag_array_0
  (
    .ce    ( tag_array_0$ce ),
    .in_   ( tag_array_0$in_ ),
    .addr  ( tag_array_0$addr ),
    .wmask ( tag_array_0$wmask ),
    .clk   ( tag_array_0$clk ),
    .we    ( tag_array_0$we ),
    .reset ( tag_array_0$reset ),
    .out   ( tag_array_0$out )
  );

  // tag_array_1 temporaries
  wire   [   0:0] tag_array_1$ce;
  wire   [  31:0] tag_array_1$in_;
  wire   [   9:0] tag_array_1$addr;
  wire   [   3:0] tag_array_1$wmask;
  wire   [   0:0] tag_array_1$clk;
  wire   [   0:0] tag_array_1$we;
  wire   [   0:0] tag_array_1$reset;
  wire   [  31:0] tag_array_1$out;

  SramRTL_0x1d0877c36bd105f4 tag_array_1
  (
    .ce    ( tag_array_1$ce ),
    .in_   ( tag_array_1$in_ ),
    .addr  ( tag_array_1$addr ),
    .wmask ( tag_array_1$wmask ),
    .clk   ( tag_array_1$clk ),
    .we    ( tag_array_1$we ),
    .reset ( tag_array_1$reset ),
    .out   ( tag_array_1$out )
  );

  // refill_mux temporaries
  wire   [   0:0] refill_mux$reset;
  wire   [ 127:0] refill_mux$in_$000;
  wire   [ 127:0] refill_mux$in_$001;
  wire   [   0:0] refill_mux$clk;
  wire   [   0:0] refill_mux$sel;
  wire   [ 127:0] refill_mux$out;

  Mux_0x5af2f539a1a7deea refill_mux
  (
    .reset   ( refill_mux$reset ),
    .in_$000 ( refill_mux$in_$000 ),
    .in_$001 ( refill_mux$in_$001 ),
    .clk     ( refill_mux$clk ),
    .sel     ( refill_mux$sel ),
    .out     ( refill_mux$out )
  );

  // way_sel_mux temporaries
  wire   [   0:0] way_sel_mux$reset;
  wire   [  27:0] way_sel_mux$in_$000;
  wire   [  27:0] way_sel_mux$in_$001;
  wire   [   0:0] way_sel_mux$clk;
  wire   [   0:0] way_sel_mux$sel;
  wire   [  27:0] way_sel_mux$out;

  Mux_0xb6e139e9f208756 way_sel_mux
  (
    .reset   ( way_sel_mux$reset ),
    .in_$000 ( way_sel_mux$in_$000 ),
    .in_$001 ( way_sel_mux$in_$001 ),
    .clk     ( way_sel_mux$clk ),
    .sel     ( way_sel_mux$sel ),
    .out     ( way_sel_mux$out )
  );

  // amo_min_mux temporaries
  wire   [   0:0] amo_min_mux$reset;
  wire   [  31:0] amo_min_mux$in_$000;
  wire   [  31:0] amo_min_mux$in_$001;
  wire   [   0:0] amo_min_mux$clk;
  wire   [   0:0] amo_min_mux$sel;
  wire   [  31:0] amo_min_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_min_mux
  (
    .reset   ( amo_min_mux$reset ),
    .in_$000 ( amo_min_mux$in_$000 ),
    .in_$001 ( amo_min_mux$in_$001 ),
    .clk     ( amo_min_mux$clk ),
    .sel     ( amo_min_mux$sel ),
    .out     ( amo_min_mux$out )
  );

  // data_array_1 temporaries
  wire   [   0:0] data_array_1$ce;
  wire   [ 127:0] data_array_1$in_;
  wire   [   9:0] data_array_1$addr;
  wire   [  15:0] data_array_1$wmask;
  wire   [   0:0] data_array_1$clk;
  wire   [   0:0] data_array_1$we;
  wire   [   0:0] data_array_1$reset;
  wire   [ 127:0] data_array_1$out;

  SramRTL_0x2d6938eb96dccb54 data_array_1
  (
    .ce    ( data_array_1$ce ),
    .in_   ( data_array_1$in_ ),
    .addr  ( data_array_1$addr ),
    .wmask ( data_array_1$wmask ),
    .clk   ( data_array_1$clk ),
    .we    ( data_array_1$we ),
    .reset ( data_array_1$reset ),
    .out   ( data_array_1$out )
  );

  // data_array_0 temporaries
  wire   [   0:0] data_array_0$ce;
  wire   [ 127:0] data_array_0$in_;
  wire   [   9:0] data_array_0$addr;
  wire   [  15:0] data_array_0$wmask;
  wire   [   0:0] data_array_0$clk;
  wire   [   0:0] data_array_0$we;
  wire   [   0:0] data_array_0$reset;
  wire   [ 127:0] data_array_0$out;

  SramRTL_0x2d6938eb96dccb54 data_array_0
  (
    .ce    ( data_array_0$ce ),
    .in_   ( data_array_0$in_ ),
    .addr  ( data_array_0$addr ),
    .wmask ( data_array_0$wmask ),
    .clk   ( data_array_0$clk ),
    .we    ( data_array_0$we ),
    .reset ( data_array_0$reset ),
    .out   ( data_array_0$out )
  );

  // cachresp_mux temporaries
  wire   [   0:0] cachresp_mux$reset;
  wire   [  31:0] cachresp_mux$in_$000;
  wire   [  31:0] cachresp_mux$in_$001;
  wire   [   0:0] cachresp_mux$clk;
  wire   [   0:0] cachresp_mux$sel;
  wire   [  31:0] cachresp_mux$out;

  Mux_0x7e8c65f0610ab9ca cachresp_mux
  (
    .reset   ( cachresp_mux$reset ),
    .in_$000 ( cachresp_mux$in_$000 ),
    .in_$001 ( cachresp_mux$in_$001 ),
    .clk     ( cachresp_mux$clk ),
    .sel     ( cachresp_mux$sel ),
    .out     ( cachresp_mux$out )
  );

  // slice_n_dice temporaries
  wire   [ 127:0] slice_n_dice$in_;
  wire   [   0:0] slice_n_dice$clk;
  wire   [   1:0] slice_n_dice$len;
  wire   [   3:0] slice_n_dice$offset;
  wire   [   0:0] slice_n_dice$reset;
  wire   [  31:0] slice_n_dice$out;

  SliceNDicePRTL_0x3637de7713a13a73 slice_n_dice
  (
    .in_    ( slice_n_dice$in_ ),
    .clk    ( slice_n_dice$clk ),
    .len    ( slice_n_dice$len ),
    .offset ( slice_n_dice$offset ),
    .reset  ( slice_n_dice$reset ),
    .out    ( slice_n_dice$out )
  );

  // cachereq_addr_reg temporaries
  wire   [   0:0] cachereq_addr_reg$reset;
  wire   [   0:0] cachereq_addr_reg$en;
  wire   [   0:0] cachereq_addr_reg$clk;
  wire   [  31:0] cachereq_addr_reg$in_;
  wire   [  31:0] cachereq_addr_reg$out;

  RegEnRst_0x3857337130dc0828 cachereq_addr_reg
  (
    .reset ( cachereq_addr_reg$reset ),
    .en    ( cachereq_addr_reg$en ),
    .clk   ( cachereq_addr_reg$clk ),
    .in_   ( cachereq_addr_reg$in_ ),
    .out   ( cachereq_addr_reg$out )
  );

  // data_read_mux temporaries
  wire   [   0:0] data_read_mux$reset;
  wire   [ 127:0] data_read_mux$in_$000;
  wire   [ 127:0] data_read_mux$in_$001;
  wire   [   0:0] data_read_mux$clk;
  wire   [   0:0] data_read_mux$sel;
  wire   [ 127:0] data_read_mux$out;

  Mux_0x5af2f539a1a7deea data_read_mux
  (
    .reset   ( data_read_mux$reset ),
    .in_$000 ( data_read_mux$in_$000 ),
    .in_$001 ( data_read_mux$in_$001 ),
    .clk     ( data_read_mux$clk ),
    .sel     ( data_read_mux$sel ),
    .out     ( data_read_mux$out )
  );

  // cachereq_opaque_reg temporaries
  wire   [   0:0] cachereq_opaque_reg$reset;
  wire   [   0:0] cachereq_opaque_reg$en;
  wire   [   0:0] cachereq_opaque_reg$clk;
  wire   [   7:0] cachereq_opaque_reg$in_;
  wire   [   7:0] cachereq_opaque_reg$out;

  RegEnRst_0x513e5624ff809260 cachereq_opaque_reg
  (
    .reset ( cachereq_opaque_reg$reset ),
    .en    ( cachereq_opaque_reg$en ),
    .clk   ( cachereq_opaque_reg$clk ),
    .in_   ( cachereq_opaque_reg$in_ ),
    .out   ( cachereq_opaque_reg$out )
  );

  // gen_write_data temporaries
  wire   [  31:0] gen_write_data$in_;
  wire   [   0:0] gen_write_data$clk;
  wire   [   3:0] gen_write_data$offset;
  wire   [   0:0] gen_write_data$reset;
  wire   [ 127:0] gen_write_data$out;

  GenWriteDataPRTL_0x76bcc5bbe4a1bc5d gen_write_data
  (
    .in_    ( gen_write_data$in_ ),
    .clk    ( gen_write_data$clk ),
    .offset ( gen_write_data$offset ),
    .reset  ( gen_write_data$reset ),
    .out    ( gen_write_data$out )
  );

  // read_data_reg temporaries
  wire   [   0:0] read_data_reg$reset;
  wire   [   0:0] read_data_reg$en;
  wire   [   0:0] read_data_reg$clk;
  wire   [ 127:0] read_data_reg$in_;
  wire   [ 127:0] read_data_reg$out;

  RegEnRst_0x150bbb1e4e9ba308 read_data_reg
  (
    .reset ( read_data_reg$reset ),
    .en    ( read_data_reg$en ),
    .clk   ( read_data_reg$clk ),
    .in_   ( read_data_reg$in_ ),
    .out   ( read_data_reg$out )
  );

  // amo_max_mux temporaries
  wire   [   0:0] amo_max_mux$reset;
  wire   [  31:0] amo_max_mux$in_$000;
  wire   [  31:0] amo_max_mux$in_$001;
  wire   [   0:0] amo_max_mux$clk;
  wire   [   0:0] amo_max_mux$sel;
  wire   [  31:0] amo_max_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_max_mux
  (
    .reset   ( amo_max_mux$reset ),
    .in_$000 ( amo_max_mux$in_$000 ),
    .in_$001 ( amo_max_mux$in_$001 ),
    .clk     ( amo_max_mux$clk ),
    .sel     ( amo_max_mux$sel ),
    .out     ( amo_max_mux$out )
  );

  // cachereq_type_reg temporaries
  wire   [   0:0] cachereq_type_reg$reset;
  wire   [   0:0] cachereq_type_reg$en;
  wire   [   0:0] cachereq_type_reg$clk;
  wire   [   3:0] cachereq_type_reg$in_;
  wire   [   3:0] cachereq_type_reg$out;

  RegEnRst_0x1c9f2c4521ce0fbc cachereq_type_reg
  (
    .reset ( cachereq_type_reg$reset ),
    .en    ( cachereq_type_reg$en ),
    .clk   ( cachereq_type_reg$clk ),
    .in_   ( cachereq_type_reg$in_ ),
    .out   ( cachereq_type_reg$out )
  );

  // tag_mux temporaries
  wire   [   0:0] tag_mux$reset;
  wire   [  27:0] tag_mux$in_$000;
  wire   [  27:0] tag_mux$in_$001;
  wire   [   0:0] tag_mux$clk;
  wire   [   0:0] tag_mux$sel;
  wire   [  27:0] tag_mux$out;

  Mux_0xb6e139e9f208756 tag_mux
  (
    .reset   ( tag_mux$reset ),
    .in_$000 ( tag_mux$in_$000 ),
    .in_$001 ( tag_mux$in_$001 ),
    .clk     ( tag_mux$clk ),
    .sel     ( tag_mux$sel ),
    .out     ( tag_mux$out )
  );

  // memresp_data_reg temporaries
  wire   [   0:0] memresp_data_reg$reset;
  wire   [   0:0] memresp_data_reg$en;
  wire   [   0:0] memresp_data_reg$clk;
  wire   [ 127:0] memresp_data_reg$in_;
  wire   [ 127:0] memresp_data_reg$out;

  RegEnRst_0x150bbb1e4e9ba308 memresp_data_reg
  (
    .reset ( memresp_data_reg$reset ),
    .en    ( memresp_data_reg$en ),
    .clk   ( memresp_data_reg$clk ),
    .in_   ( memresp_data_reg$in_ ),
    .out   ( memresp_data_reg$out )
  );

  // amo_maxu_mux temporaries
  wire   [   0:0] amo_maxu_mux$reset;
  wire   [  31:0] amo_maxu_mux$in_$000;
  wire   [  31:0] amo_maxu_mux$in_$001;
  wire   [   0:0] amo_maxu_mux$clk;
  wire   [   0:0] amo_maxu_mux$sel;
  wire   [  31:0] amo_maxu_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_maxu_mux
  (
    .reset   ( amo_maxu_mux$reset ),
    .in_$000 ( amo_maxu_mux$in_$000 ),
    .in_$001 ( amo_maxu_mux$in_$001 ),
    .clk     ( amo_maxu_mux$clk ),
    .sel     ( amo_maxu_mux$sel ),
    .out     ( amo_maxu_mux$out )
  );

  // signal connections
  assign amo_max_mux$clk            = clk;
  assign amo_max_mux$in_$000        = read_data_word;
  assign amo_max_mux$in_$001        = cachereq_data_word;
  assign amo_max_mux$reset          = reset;
  assign amo_max_mux$sel            = amo_max_sel;
  assign amo_maxu_mux$clk           = clk;
  assign amo_maxu_mux$in_$000       = read_data_word;
  assign amo_maxu_mux$in_$001       = cachereq_data_word;
  assign amo_maxu_mux$reset         = reset;
  assign amo_maxu_mux$sel           = amo_maxu_sel;
  assign amo_min_mux$clk            = clk;
  assign amo_min_mux$in_$000        = read_data_word;
  assign amo_min_mux$in_$001        = cachereq_data_word;
  assign amo_min_mux$reset          = reset;
  assign amo_min_mux$sel            = amo_min_sel;
  assign amo_minu_mux$clk           = clk;
  assign amo_minu_mux$in_$000       = read_data_word;
  assign amo_minu_mux$in_$001       = cachereq_data_word;
  assign amo_minu_mux$reset         = reset;
  assign amo_minu_mux$sel           = amo_minu_sel;
  assign amo_sel_mux$clk            = clk;
  assign amo_sel_mux$in_$000        = cachereq_data_reg_out_add;
  assign amo_sel_mux$in_$001        = cachereq_data_reg_out_and;
  assign amo_sel_mux$in_$002        = cachereq_data_reg_out_or;
  assign amo_sel_mux$in_$003        = cachereq_data_reg_out_swap;
  assign amo_sel_mux$in_$004        = cachereq_data_reg_out_min;
  assign amo_sel_mux$in_$005        = cachereq_data_reg_out_minu;
  assign amo_sel_mux$in_$006        = cachereq_data_reg_out_max;
  assign amo_sel_mux$in_$007        = cachereq_data_reg_out_maxu;
  assign amo_sel_mux$in_$008        = cachereq_data_reg_out_xor;
  assign amo_sel_mux$reset          = reset;
  assign amo_sel_mux$sel            = amo_sel;
  assign cachereq_addr              = cachereq_addr_reg$out;
  assign cachereq_addr_reg$clk      = clk;
  assign cachereq_addr_reg$en       = cachereq_en;
  assign cachereq_addr_reg$in_      = cachereq_msg[65:34];
  assign cachereq_addr_reg$reset    = reset;
  assign cachereq_data_reg$clk      = clk;
  assign cachereq_data_reg$en       = cachereq_en;
  assign cachereq_data_reg$in_      = cachereq_msg[31:0];
  assign cachereq_data_reg$reset    = reset;
  assign cachereq_data_reg_out      = cachereq_data_reg$out;
  assign cachereq_len_reg$clk       = clk;
  assign cachereq_len_reg$en        = cachereq_en;
  assign cachereq_len_reg$in_       = cachereq_msg[33:32];
  assign cachereq_len_reg$reset     = reset;
  assign cachereq_len_reg_out       = cachereq_len_reg$out;
  assign cachereq_opaque_reg$clk    = clk;
  assign cachereq_opaque_reg$en     = cachereq_en;
  assign cachereq_opaque_reg$in_    = cachereq_msg[73:66];
  assign cachereq_opaque_reg$reset  = reset;
  assign cachereq_type              = cachereq_type_reg$out;
  assign cachereq_type_reg$clk      = clk;
  assign cachereq_type_reg$en       = cachereq_en;
  assign cachereq_type_reg$in_      = cachereq_msg[77:74];
  assign cachereq_type_reg$reset    = reset;
  assign cacheresp_msg[43:36]       = cachereq_opaque_reg$out;
  assign cachresp_mux$clk           = clk;
  assign cachresp_mux$in_$000       = cachereq_data_reg_out;
  assign cachresp_mux$in_$001       = amo_out;
  assign cachresp_mux$reset         = reset;
  assign cachresp_mux$sel           = is_amo;
  assign data_array_0$addr          = cur_cachereq_idx;
  assign data_array_0$ce            = sram_data_0_en;
  assign data_array_0$clk           = clk;
  assign data_array_0$in_           = refill_mux$out;
  assign data_array_0$reset         = reset;
  assign data_array_0$we            = data_array_0_wen;
  assign data_array_0$wmask         = data_array_wben;
  assign data_array_0_read_out      = data_array_0$out;
  assign data_array_1$addr          = cur_cachereq_idx;
  assign data_array_1$ce            = sram_data_1_en;
  assign data_array_1$clk           = clk;
  assign data_array_1$in_           = refill_mux$out;
  assign data_array_1$reset         = reset;
  assign data_array_1$we            = data_array_1_wen;
  assign data_array_1$wmask         = data_array_wben;
  assign data_array_1_read_out      = data_array_1$out;
  assign data_read_mux$clk          = clk;
  assign data_read_mux$in_$000      = data_array_0_read_out;
  assign data_read_mux$in_$001      = data_array_1_read_out;
  assign data_read_mux$reset        = reset;
  assign data_read_mux$sel          = way_sel_current;
  assign gen_write_data$clk         = clk;
  assign gen_write_data$in_         = cachresp_mux$out;
  assign gen_write_data$offset      = cachereq_offset;
  assign gen_write_data$reset       = reset;
  assign int_read_data              = skip_read_data_mux$out;
  assign memreq_msg[127:0]          = read_data_reg$out;
  assign memreq_type_mux_out        = tag_mux$out;
  assign memresp_data_reg$clk       = clk;
  assign memresp_data_reg$en        = memresp_en;
  assign memresp_data_reg$in_       = memresp_msg[127:0];
  assign memresp_data_reg$reset     = reset;
  assign read_data                  = slice_n_dice$out;
  assign read_data_reg$clk          = clk;
  assign read_data_reg$en           = read_data_reg_en;
  assign read_data_reg$in_          = data_read_mux$out;
  assign read_data_reg$reset        = reset;
  assign read_tag_reg$clk           = clk;
  assign read_tag_reg$en            = read_tag_reg_en;
  assign read_tag_reg$in_           = way_sel_mux$out;
  assign read_tag_reg$reset         = reset;
  assign refill_mux$clk             = clk;
  assign refill_mux$in_$000         = gen_write_data$out;
  assign refill_mux$in_$001         = memresp_msg[127:0];
  assign refill_mux$reset           = reset;
  assign refill_mux$sel             = is_refill;
  assign skip_read_data_mux$clk     = clk;
  assign skip_read_data_mux$in_$000 = read_data_reg$out;
  assign skip_read_data_mux$in_$001 = data_read_mux$out;
  assign skip_read_data_mux$reset   = reset;
  assign skip_read_data_mux$sel     = skip_read_data_reg;
  assign slice_n_dice$clk           = clk;
  assign slice_n_dice$in_           = int_read_data;
  assign slice_n_dice$len           = cachereq_len_reg_out;
  assign slice_n_dice$offset        = cachereq_offset;
  assign slice_n_dice$reset         = reset;
  assign tag_array_0$addr           = cur_cachereq_idx;
  assign tag_array_0$ce             = sram_tag_0_en;
  assign tag_array_0$clk            = clk;
  assign tag_array_0$in_            = temp_cachereq_tag;
  assign tag_array_0$reset          = reset;
  assign tag_array_0$we             = tag_array_0_wen;
  assign tag_array_0$wmask          = 4'd15;
  assign tag_array_0_read_out       = tag_array_0$out;
  assign tag_array_1$addr           = cur_cachereq_idx;
  assign tag_array_1$ce             = sram_tag_1_en;
  assign tag_array_1$clk            = clk;
  assign tag_array_1$in_            = temp_cachereq_tag;
  assign tag_array_1$reset          = reset;
  assign tag_array_1$we             = tag_array_1_wen;
  assign tag_array_1$wmask          = 4'd15;
  assign tag_array_1_read_out       = tag_array_1$out;
  assign tag_compare_0$clk          = clk;
  assign tag_compare_0$in0          = cachereq_tag;
  assign tag_compare_0$in1          = tag_array_0_read_out[27:0];
  assign tag_compare_0$reset        = reset;
  assign tag_compare_1$clk          = clk;
  assign tag_compare_1$in0          = cachereq_tag;
  assign tag_compare_1$in1          = tag_array_1_read_out[27:0];
  assign tag_compare_1$reset        = reset;
  assign tag_match_0                = tag_compare_0$out;
  assign tag_match_1                = tag_compare_1$out;
  assign tag_mux$clk                = clk;
  assign tag_mux$in_$000            = cachereq_tag;
  assign tag_mux$in_$001            = read_tag_reg$out;
  assign tag_mux$reset              = reset;
  assign tag_mux$sel                = memreq_type[0];
  assign way_sel_mux$clk            = clk;
  assign way_sel_mux$in_$000        = tag_array_0_read_out[27:0];
  assign way_sel_mux$in_$001        = tag_array_1_read_out[27:0];
  assign way_sel_mux$reset          = reset;
  assign way_sel_mux$sel            = way_sel_current;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_amo_data():
  //       s.cachereq_data_word.value = s.cachereq_data_reg_out[0:dbw]
  //       s.read_data_word    .value = s.read_data            [0:dbw]

  // logic for gen_amo_data()
  always @ (*) begin
    cachereq_data_word = cachereq_data_reg_out[(dbw)-1:0];
    read_data_word = read_data[(dbw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_connect_wires():
  //       s.cachereq_data_reg_out_add.value   = s.cachereq_data_word + s.read_data_word
  //       s.cachereq_data_reg_out_and.value   = s.cachereq_data_word & s.read_data_word
  //       s.cachereq_data_reg_out_or.value    = s.cachereq_data_word | s.read_data_word
  //       s.cachereq_data_reg_out_swap.value  = s.cachereq_data_word
  //       s.cachereq_data_reg_out_min.value   = s.amo_min_mux.out
  //       s.cachereq_data_reg_out_minu.value  = s.amo_minu_mux.out
  //       s.cachereq_data_reg_out_max.value   = s.amo_max_mux.out
  //       s.cachereq_data_reg_out_maxu.value  = s.amo_maxu_mux.out
  //       s.cachereq_data_reg_out_xor.value   = s.cachereq_data_word ^ s.read_data_word

  // logic for comb_connect_wires()
  always @ (*) begin
    cachereq_data_reg_out_add = (cachereq_data_word+read_data_word);
    cachereq_data_reg_out_and = (cachereq_data_word&read_data_word);
    cachereq_data_reg_out_or = (cachereq_data_word|read_data_word);
    cachereq_data_reg_out_swap = cachereq_data_word;
    cachereq_data_reg_out_min = amo_min_mux$out;
    cachereq_data_reg_out_minu = amo_minu_mux$out;
    cachereq_data_reg_out_max = amo_max_mux$out;
    cachereq_data_reg_out_maxu = amo_maxu_mux$out;
    cachereq_data_reg_out_xor = (cachereq_data_word^read_data_word);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_gen_amo_output():
  //       s.amo_out       .value = 0
  //       s.amo_out[0:dbw].value = s.amo_sel_mux.out

  // logic for comb_gen_amo_output()
  always @ (*) begin
    amo_out = 0;
    amo_out[(dbw)-1:0] = amo_sel_mux$out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_offset():
  //       s.cachereq_offset.value = s.cachereq_addr[0:m_len_bw]

  // logic for comb_cachereq_offset()
  always @ (*) begin
    cachereq_offset = cachereq_addr[(m_len_bw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_replicate():
  //       s.cachereq_tag.value = s.cachereq_addr_reg.out[4:abw]
  //       s.cachereq_idx.value = s.cachereq_addr_reg.out[4:idw_off]

  // logic for comb_replicate()
  always @ (*) begin
    cachereq_tag = cachereq_addr_reg$out[(abw)-1:4];
    cachereq_idx = cachereq_addr_reg$out[(idw_off)-1:4];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_tag():
  //       s.cachereq_msg_addr.value = s.cachereq_msg.addr
  //       s.temp_cachereq_tag.value = concat( Bits(4, 0), s.cachereq_tag )
  //       if s.cachereq_en:
  //         s.cur_cachereq_idx.value = s.cachereq_msg_addr[4:idw_off]
  //       else:
  //         s.cur_cachereq_idx.value  = s.cachereq_idx
  //
  //       # Shunning: This data_array_x_wen is built up in the same way as
  //       #           tag_array_x_wen. Why is this guy here, but the tag one is in ctrl?
  //       s.data_array_0_wen.value =  (s.data_array_wen & (s.way_sel_current == 0))
  //       s.data_array_1_wen.value =  (s.data_array_wen & (s.way_sel_current == 1))
  //       s.sram_tag_0_en.value    =  (s.tag_array_0_wen | s.tag_array_0_ren)
  //       s.sram_tag_1_en.value    =  (s.tag_array_1_wen | s.tag_array_1_ren)
  //       s.sram_data_0_en.value   =  ((s.data_array_wen & (s.way_sel_current==0)) | s.data_array_ren)
  //       s.sram_data_1_en.value   =  ((s.data_array_wen & (s.way_sel_current==1)) | s.data_array_ren)

  // logic for comb_tag()
  always @ (*) begin
    cachereq_msg_addr = cachereq_msg[(66)-1:34];
    temp_cachereq_tag = { 4'd0,cachereq_tag };
    if (cachereq_en) begin
      cur_cachereq_idx = cachereq_msg_addr[(idw_off)-1:4];
    end
    else begin
      cur_cachereq_idx = cachereq_idx;
    end
    data_array_0_wen = (data_array_wen&(way_sel_current == 0));
    data_array_1_wen = (data_array_wen&(way_sel_current == 1));
    sram_tag_0_en = (tag_array_0_wen|tag_array_0_ren);
    sram_tag_1_en = (tag_array_1_wen|tag_array_1_ren);
    sram_data_0_en = ((data_array_wen&(way_sel_current == 0))|data_array_ren);
    sram_data_1_en = ((data_array_wen&(way_sel_current == 1))|data_array_ren);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_addr_evict():
  //       s.memreq_addr.value = concat(s.memreq_type_mux_out, Bits(4, 0))

  // logic for comb_addr_evict()
  always @ (*) begin
    memreq_addr = { memreq_type_mux_out,4'd0 };
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_addr_refill():
  //
  //       if   s.cacheresp_type == MemReqMsg.TYPE_READ      : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_ADD   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_AND   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_OR    : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_SWAP  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MIN   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MINU  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAX   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAXU  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_XOR   : s.cacheresp_msg.data.value = s.read_data
  //       else                                              : s.cacheresp_msg.data.value = 0

  // logic for comb_addr_refill()
  always @ (*) begin
    if ((cacheresp_type == TYPE_READ)) begin
      cacheresp_msg[(32)-1:0] = read_data;
    end
    else begin
      if ((cacheresp_type == TYPE_AMO_ADD)) begin
        cacheresp_msg[(32)-1:0] = read_data;
      end
      else begin
        if ((cacheresp_type == TYPE_AMO_AND)) begin
          cacheresp_msg[(32)-1:0] = read_data;
        end
        else begin
          if ((cacheresp_type == TYPE_AMO_OR)) begin
            cacheresp_msg[(32)-1:0] = read_data;
          end
          else begin
            if ((cacheresp_type == TYPE_AMO_SWAP)) begin
              cacheresp_msg[(32)-1:0] = read_data;
            end
            else begin
              if ((cacheresp_type == TYPE_AMO_MIN)) begin
                cacheresp_msg[(32)-1:0] = read_data;
              end
              else begin
                if ((cacheresp_type == TYPE_AMO_MINU)) begin
                  cacheresp_msg[(32)-1:0] = read_data;
                end
                else begin
                  if ((cacheresp_type == TYPE_AMO_MAX)) begin
                    cacheresp_msg[(32)-1:0] = read_data;
                  end
                  else begin
                    if ((cacheresp_type == TYPE_AMO_MAXU)) begin
                      cacheresp_msg[(32)-1:0] = read_data;
                    end
                    else begin
                      if ((cacheresp_type == TYPE_AMO_XOR)) begin
                        cacheresp_msg[(32)-1:0] = read_data;
                      end
                      else begin
                        cacheresp_msg[(32)-1:0] = 0;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cacherespmsgpack():
  //       s.cacheresp_msg.type_.value = s.cacheresp_type
  //       s.cacheresp_msg.test.value  = concat( Bits( 1, 0 ), s.cacheresp_hit )
  //       s.cacheresp_msg.len.value   = s.cachereq_len_reg_out

  // logic for comb_cacherespmsgpack()
  always @ (*) begin
    cacheresp_msg[(48)-1:44] = cacheresp_type;
    cacheresp_msg[(36)-1:34] = { 1'd0,cacheresp_hit };
    cacheresp_msg[(34)-1:32] = cachereq_len_reg_out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_memrespmsgpack():
  //       s.memreq_msg.type_.value    = s.memreq_type
  //       s.memreq_msg.opaque.value   = 0
  //       s.memreq_msg.addr.value     = s.memreq_addr
  //       s.memreq_msg.len.value      = 0

  // logic for comb_memrespmsgpack()
  always @ (*) begin
    memreq_msg[(176)-1:172] = memreq_type;
    memreq_msg[(172)-1:164] = 0;
    memreq_msg[(164)-1:132] = memreq_addr;
    memreq_msg[(132)-1:128] = 0;
  end


endmodule // BlockingCacheDpathPRTL_0x499835e454a1a1cd
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x35d76e7a8821f894
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 28
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x35d76e7a8821f894
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  27:0] in_,
  output reg  [  27:0] out,
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


endmodule // RegEnRst_0x35d76e7a8821f894
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
// RegEnRst_0x9f365fdf6c8998a
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x9f365fdf6c8998a
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
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


endmodule // RegEnRst_0x9f365fdf6c8998a
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x7e8c65f0610ab9ca
//-----------------------------------------------------------------------------
// nports: 2
// dtype: 32
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
// Mux_0x1256f43349e9a82f
//-----------------------------------------------------------------------------
// nports: 9
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x1256f43349e9a82f
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
  input  wire [  31:0] in_$008,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   3:0] sel
);

  // localparam declarations
  localparam nports = 9;


  // array declarations
  wire   [  31:0] in_[0:8];
  assign in_[  0] = in_$000;
  assign in_[  1] = in_$001;
  assign in_[  2] = in_$002;
  assign in_[  3] = in_$003;
  assign in_[  4] = in_$004;
  assign in_[  5] = in_$005;
  assign in_[  6] = in_$006;
  assign in_[  7] = in_$007;
  assign in_[  8] = in_$008;

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


endmodule // Mux_0x1256f43349e9a82f
`default_nettype wire

//-----------------------------------------------------------------------------
// EqComparator_0x4b38e35357dbd1ff
//-----------------------------------------------------------------------------
// nbits: 28
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module EqComparator_0x4b38e35357dbd1ff
(
  input  wire [   0:0] clk,
  input  wire [  27:0] in0,
  input  wire [  27:0] in1,
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


endmodule // EqComparator_0x4b38e35357dbd1ff
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x5af2f539a1a7deea
//-----------------------------------------------------------------------------
// nports: 2
// dtype: 128
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x5af2f539a1a7deea
(
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_$000,
  input  wire [ 127:0] in_$001,
  output reg  [ 127:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [ 127:0] in_[0:1];
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


endmodule // Mux_0x5af2f539a1a7deea
`default_nettype wire

//-----------------------------------------------------------------------------
// SramRTL_0x1d0877c36bd105f4
//-----------------------------------------------------------------------------
// num_bits: 32
// tech_node: 28nm
// num_words: 1024
// module_name: 
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SramRTL_0x1d0877c36bd105f4
(
  input  wire [   9:0] addr,
  input  wire [   0:0] ce,
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output wire [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] we,
  input  wire [   3:0] wmask
);

  // sram temporaries
  wire   [   0:0] sram$ce;
  wire   [  31:0] sram$in_;
  wire   [   9:0] sram$addr;
  wire   [   3:0] sram$wmask;
  wire   [   0:0] sram$clk;
  wire   [   0:0] sram$we;
  wire   [   0:0] sram$reset;
  wire   [  31:0] sram$out;

  SramWrapper28nmPRTL_0x79c097bc28415054 sram
  (
    .ce    ( sram$ce ),
    .in_   ( sram$in_ ),
    .addr  ( sram$addr ),
    .wmask ( sram$wmask ),
    .clk   ( sram$clk ),
    .we    ( sram$we ),
    .reset ( sram$reset ),
    .out   ( sram$out )
  );

  // signal connections
  assign out        = sram$out;
  assign sram$addr  = addr;
  assign sram$ce    = ce;
  assign sram$clk   = clk;
  assign sram$in_   = in_;
  assign sram$reset = reset;
  assign sram$we    = we;
  assign sram$wmask = wmask;



endmodule // SramRTL_0x1d0877c36bd105f4
`default_nettype wire

//-----------------------------------------------------------------------------
// SramWrapper28nmPRTL_0x79c097bc28415054
//-----------------------------------------------------------------------------
// num_bits: 32
// num_words: 1024
// module_name: 
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SramWrapper28nmPRTL_0x79c097bc28415054
(
  input  wire [   9:0] addr,
  input  wire [   0:0] ce,
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [  31:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] we,
  input  wire [   3:0] wmask
);

  // wire declarations
  wire   [   0:0] emas;
  wire   [   1:0] emaw;
  wire   [   0:0] ret1n;
  wire   [   9:0] ay;
  wire   [   0:0] tcen;
  wire   [   0:0] gweny;
  wire   [   1:0] si;
  wire   [  31:0] td;
  wire   [   0:0] dftrambyp;
  wire   [   9:0] ta;
  wire   [   0:0] tgwen;
  wire   [   0:0] ceny;
  wire   [  31:0] twen;
  wire   [   2:0] ema;
  wire   [  31:0] q;
  wire   [   0:0] ten;
  wire   [   1:0] so;
  wire   [  31:0] weny;
  wire   [   0:0] se;


  // register declarations
  reg    [   9:0] a;
  reg    [   0:0] cen;
  reg    [  31:0] d;
  reg    [   0:0] gwen;
  reg    [  31:0] wen;

  // localparam declarations
  localparam nb = 4;

  // loop variable declarations
  integer b;
  integer i;

  // mem$000$000 temporaries
  wire   [   0:0] mem$000$000$emas;
  wire   [   0:0] mem$000$000$gwen;
  wire   [   1:0] mem$000$000$emaw;
  wire   [   0:0] mem$000$000$ret1n;
  wire   [   0:0] mem$000$000$tcen;
  wire   [   0:0] mem$000$000$ten;
  wire   [   0:0] mem$000$000$dftrambyp;
  wire   [   0:0] mem$000$000$clk;
  wire   [  31:0] mem$000$000$wen;
  wire   [  31:0] mem$000$000$td;
  wire   [   9:0] mem$000$000$ta;
  wire   [   9:0] mem$000$000$a;
  wire   [   0:0] mem$000$000$cen;
  wire   [   0:0] mem$000$000$tgwen;
  wire   [  31:0] mem$000$000$twen;
  wire   [   0:0] mem$000$000$reset;
  wire   [   2:0] mem$000$000$ema;
  wire   [  31:0] mem$000$000$d;
  wire   [   1:0] mem$000$000$si;
  wire   [   0:0] mem$000$000$se;
  wire   [   9:0] mem$000$000$ay;
  wire   [   0:0] mem$000$000$ceny;
  wire   [   0:0] mem$000$000$gweny;
  wire   [  31:0] mem$000$000$q;
  wire   [   1:0] mem$000$000$so;
  wire   [  31:0] mem$000$000$weny;

  sram_28nm_1024x32_SP mem$000$000
  (
    .emas      ( mem$000$000$emas ),
    .gwen      ( mem$000$000$gwen ),
    .emaw      ( mem$000$000$emaw ),
    .ret1n     ( mem$000$000$ret1n ),
    .tcen      ( mem$000$000$tcen ),
    .ten       ( mem$000$000$ten ),
    .dftrambyp ( mem$000$000$dftrambyp ),
    .clk       ( mem$000$000$clk ),
    .wen       ( mem$000$000$wen ),
    .td        ( mem$000$000$td ),
    .ta        ( mem$000$000$ta ),
    .a         ( mem$000$000$a ),
    .cen       ( mem$000$000$cen ),
    .tgwen     ( mem$000$000$tgwen ),
    .twen      ( mem$000$000$twen ),
    .ema       ( mem$000$000$ema ),
    .d         ( mem$000$000$d ),
    .si        ( mem$000$000$si ),
    .se        ( mem$000$000$se ),
    .ay        ( mem$000$000$ay ),
    .ceny      ( mem$000$000$ceny ),
    .gweny     ( mem$000$000$gweny ),
    .q         ( mem$000$000$q ),
    .so        ( mem$000$000$so ),
    .weny      ( mem$000$000$weny )
  );

  // signal connections
  assign ay                    = mem$000$000$ay;
  assign ceny                  = mem$000$000$ceny;
  assign mem$000$000$a         = a;
  assign mem$000$000$cen       = cen;
  assign mem$000$000$clk       = clk;
  assign mem$000$000$d         = d[31:0];
  assign mem$000$000$dftrambyp = 1'd0;
  assign mem$000$000$ema       = 3'd3;
  assign mem$000$000$emas      = 1'd0;
  assign mem$000$000$emaw      = 2'd1;
  assign mem$000$000$gwen      = gwen;
  assign mem$000$000$reset     = reset;
  assign mem$000$000$ret1n     = 1'd0;
  assign mem$000$000$se        = 1'd0;
  assign mem$000$000$si        = 2'd0;
  assign mem$000$000$ta        = 10'd0;
  assign mem$000$000$tcen      = 1'd0;
  assign mem$000$000$td        = 32'd0;
  assign mem$000$000$ten       = 1'd0;
  assign mem$000$000$tgwen     = 1'd0;
  assign mem$000$000$twen      = 32'd0;
  assign mem$000$000$wen       = wen[31:0];
  assign q[31:0]               = mem$000$000$q;
  assign so                    = mem$000$000$so;
  assign weny                  = mem$000$000$weny;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb():
  //
  //       # Output request
  //       s.out.value = s.q
  //
  //       # Input request
  //       s.cen .value = ~s.ce
  //       s.gwen.value = ~s.we
  //       s.a   .value =  s.addr
  //       s.d   .value =  s.in_
  //
  //       # Mask
  //       for i in xrange(nb):
  //         for b in xrange(8):
  //           s.wen[i*8 + b].value = ~s.wmask[i]

  // logic for comb()
  always @ (*) begin
    out = q;
    cen = ~ce;
    gwen = ~we;
    a = addr;
    d = in_;
    for (i=0; i < nb; i=i+1)
    begin
      for (b=0; b < 8; b=b+1)
      begin
        wen[((i*8)+b)] = ~wmask[i];
      end
    end
  end


endmodule // SramWrapper28nmPRTL_0x79c097bc28415054
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0xb6e139e9f208756
//-----------------------------------------------------------------------------
// nports: 2
// dtype: 28
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0xb6e139e9f208756
(
  input  wire [   0:0] clk,
  input  wire [  27:0] in_$000,
  input  wire [  27:0] in_$001,
  output reg  [  27:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  27:0] in_[0:1];
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


endmodule // Mux_0xb6e139e9f208756
`default_nettype wire

//-----------------------------------------------------------------------------
// SramRTL_0x2d6938eb96dccb54
//-----------------------------------------------------------------------------
// num_bits: 128
// tech_node: 28nm
// num_words: 1024
// module_name: 
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SramRTL_0x2d6938eb96dccb54
(
  input  wire [   9:0] addr,
  input  wire [   0:0] ce,
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_,
  output wire [ 127:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] we,
  input  wire [  15:0] wmask
);

  // sram temporaries
  wire   [   0:0] sram$ce;
  wire   [ 127:0] sram$in_;
  wire   [   9:0] sram$addr;
  wire   [  15:0] sram$wmask;
  wire   [   0:0] sram$clk;
  wire   [   0:0] sram$we;
  wire   [   0:0] sram$reset;
  wire   [ 127:0] sram$out;

  SramWrapper28nmPRTL_0x6865ae273cdbc0f4 sram
  (
    .ce    ( sram$ce ),
    .in_   ( sram$in_ ),
    .addr  ( sram$addr ),
    .wmask ( sram$wmask ),
    .clk   ( sram$clk ),
    .we    ( sram$we ),
    .reset ( sram$reset ),
    .out   ( sram$out )
  );

  // signal connections
  assign out        = sram$out;
  assign sram$addr  = addr;
  assign sram$ce    = ce;
  assign sram$clk   = clk;
  assign sram$in_   = in_;
  assign sram$reset = reset;
  assign sram$we    = we;
  assign sram$wmask = wmask;



endmodule // SramRTL_0x2d6938eb96dccb54
`default_nettype wire

//-----------------------------------------------------------------------------
// SramWrapper28nmPRTL_0x6865ae273cdbc0f4
//-----------------------------------------------------------------------------
// num_bits: 128
// num_words: 1024
// module_name: 
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SramWrapper28nmPRTL_0x6865ae273cdbc0f4
(
  input  wire [   9:0] addr,
  input  wire [   0:0] ce,
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_,
  output reg  [ 127:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] we,
  input  wire [  15:0] wmask
);

  // wire declarations
  wire   [   0:0] emas;
  wire   [   1:0] emaw;
  wire   [   0:0] ret1n;
  wire   [   9:0] ay;
  wire   [   0:0] tcen;
  wire   [   0:0] gweny;
  wire   [   1:0] si;
  wire   [ 127:0] td;
  wire   [   0:0] dftrambyp;
  wire   [   9:0] ta;
  wire   [   0:0] tgwen;
  wire   [   0:0] ceny;
  wire   [ 127:0] twen;
  wire   [   2:0] ema;
  wire   [ 127:0] q;
  wire   [   0:0] ten;
  wire   [   1:0] so;
  wire   [ 127:0] weny;
  wire   [   0:0] se;


  // register declarations
  reg    [   9:0] a;
  reg    [   0:0] cen;
  reg    [ 127:0] d;
  reg    [   0:0] gwen;
  reg    [ 127:0] wen;

  // localparam declarations
  localparam nb = 16;

  // loop variable declarations
  integer b;
  integer i;

  // mem$000$000 temporaries
  wire   [   0:0] mem$000$000$emas;
  wire   [   0:0] mem$000$000$gwen;
  wire   [   1:0] mem$000$000$emaw;
  wire   [   0:0] mem$000$000$ret1n;
  wire   [   0:0] mem$000$000$tcen;
  wire   [   0:0] mem$000$000$ten;
  wire   [   0:0] mem$000$000$dftrambyp;
  wire   [   0:0] mem$000$000$clk;
  wire   [ 127:0] mem$000$000$wen;
  wire   [ 127:0] mem$000$000$td;
  wire   [   9:0] mem$000$000$ta;
  wire   [   9:0] mem$000$000$a;
  wire   [   0:0] mem$000$000$cen;
  wire   [   0:0] mem$000$000$tgwen;
  wire   [ 127:0] mem$000$000$twen;
  wire   [   0:0] mem$000$000$reset;
  wire   [   2:0] mem$000$000$ema;
  wire   [ 127:0] mem$000$000$d;
  wire   [   1:0] mem$000$000$si;
  wire   [   0:0] mem$000$000$se;
  wire   [   9:0] mem$000$000$ay;
  wire   [   0:0] mem$000$000$ceny;
  wire   [   0:0] mem$000$000$gweny;
  wire   [ 127:0] mem$000$000$q;
  wire   [   1:0] mem$000$000$so;
  wire   [ 127:0] mem$000$000$weny;

  sram_28nm_1024x128_SP mem$000$000
  (
    .emas      ( mem$000$000$emas ),
    .gwen      ( mem$000$000$gwen ),
    .emaw      ( mem$000$000$emaw ),
    .ret1n     ( mem$000$000$ret1n ),
    .tcen      ( mem$000$000$tcen ),
    .ten       ( mem$000$000$ten ),
    .dftrambyp ( mem$000$000$dftrambyp ),
    .clk       ( mem$000$000$clk ),
    .wen       ( mem$000$000$wen ),
    .td        ( mem$000$000$td ),
    .ta        ( mem$000$000$ta ),
    .a         ( mem$000$000$a ),
    .cen       ( mem$000$000$cen ),
    .tgwen     ( mem$000$000$tgwen ),
    .twen      ( mem$000$000$twen ),
    .ema       ( mem$000$000$ema ),
    .d         ( mem$000$000$d ),
    .si        ( mem$000$000$si ),
    .se        ( mem$000$000$se ),
    .ay        ( mem$000$000$ay ),
    .ceny      ( mem$000$000$ceny ),
    .gweny     ( mem$000$000$gweny ),
    .q         ( mem$000$000$q ),
    .so        ( mem$000$000$so ),
    .weny      ( mem$000$000$weny )
  );

  // signal connections
  assign ay                    = mem$000$000$ay;
  assign ceny                  = mem$000$000$ceny;
  assign mem$000$000$a         = a;
  assign mem$000$000$cen       = cen;
  assign mem$000$000$clk       = clk;
  assign mem$000$000$d         = d[127:0];
  assign mem$000$000$dftrambyp = 1'd0;
  assign mem$000$000$ema       = 3'd3;
  assign mem$000$000$emas      = 1'd0;
  assign mem$000$000$emaw      = 2'd1;
  assign mem$000$000$gwen      = gwen;
  assign mem$000$000$reset     = reset;
  assign mem$000$000$ret1n     = 1'd0;
  assign mem$000$000$se        = 1'd0;
  assign mem$000$000$si        = 2'd0;
  assign mem$000$000$ta        = 10'd0;
  assign mem$000$000$tcen      = 1'd0;
  assign mem$000$000$td        = 128'd0;
  assign mem$000$000$ten       = 1'd0;
  assign mem$000$000$tgwen     = 1'd0;
  assign mem$000$000$twen      = 128'd0;
  assign mem$000$000$wen       = wen[127:0];
  assign q[127:0]              = mem$000$000$q;
  assign so                    = mem$000$000$so;
  assign weny                  = mem$000$000$weny;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb():
  //
  //       # Output request
  //       s.out.value = s.q
  //
  //       # Input request
  //       s.cen .value = ~s.ce
  //       s.gwen.value = ~s.we
  //       s.a   .value =  s.addr
  //       s.d   .value =  s.in_
  //
  //       # Mask
  //       for i in xrange(nb):
  //         for b in xrange(8):
  //           s.wen[i*8 + b].value = ~s.wmask[i]

  // logic for comb()
  always @ (*) begin
    out = q;
    cen = ~ce;
    gwen = ~we;
    a = addr;
    d = in_;
    for (i=0; i < nb; i=i+1)
    begin
      for (b=0; b < 8; b=b+1)
      begin
        wen[((i*8)+b)] = ~wmask[i];
      end
    end
  end


endmodule // SramWrapper28nmPRTL_0x6865ae273cdbc0f4
`default_nettype wire

//-----------------------------------------------------------------------------
// SliceNDicePRTL_0x3637de7713a13a73
//-----------------------------------------------------------------------------
// num_in_bytes: 16
// num_out_bytes: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SliceNDicePRTL_0x3637de7713a13a73
(
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_,
  input  wire [   1:0] len,
  input  wire [   3:0] offset,
  output reg  [  31:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [ 127:0] int_in_;
  reg    [ 127:0] int_mask;
  reg    [ 127:0] int_out;
  reg    [   1:0] len_d;
  reg    [   4:0] len_shft;
  reg    [   6:0] offset_shft;

  // localparam declarations
  localparam in_lnb = 4;
  localparam num_out_bits = 32;
  localparam out_lnb = 2;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_mask():
  //
  //       # Force ones in all bits
  //       s.int_mask.value = 0
  //       s.int_mask.value = s.int_mask - 1
  //
  //       # Shift the mask left by one byte
  //       s.int_mask.value = s.int_mask << 8
  //
  //       # Decrement the len and shift by the resulting value
  //       s.len_d.value = s.len - 1
  //
  //       # Multiply the shift amount by 8
  //       s.len_shft           .value = 0
  //       s.len_shft[0:out_lnb].value = s.len_d
  //       s.len_shft           .value = s.len_shft << 3
  //
  //       # Generate Offset
  //       s.offset_shft          .value = 0
  //       s.offset_shft[0:in_lnb].value = s.offset
  //       s.offset_shft          .value = s.offset_shft << 3
  //
  //       # Re-orient the input bits based on the offset
  //       s.int_in_.value = s.in_ >> s.offset_shft
  //
  //       # Shift by the resulting value
  //       s.int_mask.value = s.int_mask << ( s.len_shft )
  //
  //       # Generate output
  //       s.int_out.value = (~s.int_mask) & s.int_in_
  //
  //       # Slice to the output
  //       s.out.value = s.int_out[0:num_out_bits]

  // logic for gen_mask()
  always @ (*) begin
    int_mask = 0;
    int_mask = (int_mask-1);
    int_mask = (int_mask<<8);
    len_d = (len-1);
    len_shft = 0;
    len_shft[(out_lnb)-1:0] = len_d;
    len_shft = (len_shft<<3);
    offset_shft = 0;
    offset_shft[(in_lnb)-1:0] = offset;
    offset_shft = (offset_shft<<3);
    int_in_ = (in_>>offset_shft);
    int_mask = (int_mask<<len_shft);
    int_out = (~int_mask&int_in_);
    out = int_out[(num_out_bits)-1:0];
  end


endmodule // SliceNDicePRTL_0x3637de7713a13a73
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
// GenWriteDataPRTL_0x76bcc5bbe4a1bc5d
//-----------------------------------------------------------------------------
// num_in_bytes: 4
// num_out_bytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module GenWriteDataPRTL_0x76bcc5bbe4a1bc5d
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  input  wire [   3:0] offset,
  output reg  [ 127:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [ 127:0] int_in_;
  reg    [ 127:0] int_out;
  reg    [   6:0] offset_shft;

  // localparam declarations
  localparam num_in_bits = 32;
  localparam out_lnb = 4;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_out():
  //
  //       # Get input in a more spacier wire
  //       s.int_in_               .value = 0
  //       s.int_in_[0:num_in_bits].value = s.in_
  //
  //       # Offset generation
  //       s.offset_shft           .value = 0
  //       s.offset_shft[0:out_lnb].value = s.offset
  //
  //       # Re-orient the input bits based on the offset
  //       s.int_out.value = s.int_in_ << (s.offset_shft << 3)
  //
  //       # Assign the output
  //       s.out.value = s.int_out

  // logic for gen_out()
  always @ (*) begin
    int_in_ = 0;
    int_in_[(num_in_bits)-1:0] = in_;
    offset_shft = 0;
    offset_shft[(out_lnb)-1:0] = offset;
    int_out = (int_in_<<(offset_shft<<3));
    out = int_out;
  end


endmodule // GenWriteDataPRTL_0x76bcc5bbe4a1bc5d
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x150bbb1e4e9ba308
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 128
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x150bbb1e4e9ba308
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [ 127:0] in_,
  output reg  [ 127:0] out,
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


endmodule // RegEnRst_0x150bbb1e4e9ba308
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEnRst_0x1c9f2c4521ce0fbc
//-----------------------------------------------------------------------------
// reset_value: 0
// dtype: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEnRst_0x1c9f2c4521ce0fbc
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [   3:0] in_,
  output reg  [   3:0] out,
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


endmodule // RegEnRst_0x1c9f2c4521ce0fbc
`default_nettype wire

//-----------------------------------------------------------------------------
// Router_0x6c4e178e4038f207
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 48
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Router_0x6c4e178e4038f207
(
  input  wire [   0:0] clk,
  input  wire [  47:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  47:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  output wire [  47:0] out$001_msg,
  input  wire [   0:0] out$001_rdy,
  output wire [   0:0] out$001_val,
  output wire [  47:0] out$002_msg,
  input  wire [   0:0] out$002_rdy,
  output wire [   0:0] out$002_val,
  output wire [  47:0] out$003_msg,
  input  wire [   0:0] out$003_rdy,
  output wire [   0:0] out$003_val,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [  47:0] out_msg[0:3];
  assign out$000_msg = out_msg[  0];
  assign out$001_msg = out_msg[  1];
  assign out$002_msg = out_msg[  2];
  assign out$003_msg = out_msg[  3];
  wire   [   0:0] out_rdy[0:3];
  assign out_rdy[  0] = out$000_rdy;
  assign out_rdy[  1] = out$001_rdy;
  assign out_rdy[  2] = out$002_rdy;
  assign out_rdy[  3] = out$003_rdy;
  reg    [   0:0] out_val[0:3];
  assign out$000_val = out_val[  0];
  assign out$001_val = out_val[  1];
  assign out$002_val = out_val[  2];
  assign out$003_val = out_val[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_out_val():
  //       for i in xrange( nports ):
  //         s.out[i].val.value = 0
  //         s.out[i].msg.value = 0
  //
  //       if s.in_.val:
  //         s.out[ s.in_.msg.opaque ].val.value = s.in_.val
  //         s.out[ s.in_.msg.opaque ].msg.value = s.in_.msg

  // logic for comb_out_val()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      out_val[i] = 0;
      out_msg[i] = 0;
    end
    if (in__val) begin
      out_val[in__msg[(44)-1:36]] = in__val;
      out_msg[in__msg[(44)-1:36]] = in__msg;
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       # in_rdy is the rdy status of the opaque-th output
  //       s.in_.rdy.value = s.out[ s.in_.msg.opaque ].rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    in__rdy = out_rdy[in__msg[(44)-1:36]];
  end


endmodule // Router_0x6c4e178e4038f207
`default_nettype wire

//-----------------------------------------------------------------------------
// Router_0x4c184f1ee5bd8508
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 35
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Router_0x4c184f1ee5bd8508
(
  input  wire [   0:0] clk,
  input  wire [  34:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [  34:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  output wire [  34:0] out$001_msg,
  input  wire [   0:0] out$001_rdy,
  output wire [   0:0] out$001_val,
  output wire [  34:0] out$002_msg,
  input  wire [   0:0] out$002_rdy,
  output wire [   0:0] out$002_val,
  output wire [  34:0] out$003_msg,
  input  wire [   0:0] out$003_rdy,
  output wire [   0:0] out$003_val,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [  34:0] out_msg[0:3];
  assign out$000_msg = out_msg[  0];
  assign out$001_msg = out_msg[  1];
  assign out$002_msg = out_msg[  2];
  assign out$003_msg = out_msg[  3];
  wire   [   0:0] out_rdy[0:3];
  assign out_rdy[  0] = out$000_rdy;
  assign out_rdy[  1] = out$001_rdy;
  assign out_rdy[  2] = out$002_rdy;
  assign out_rdy[  3] = out$003_rdy;
  reg    [   0:0] out_val[0:3];
  assign out$000_val = out_val[  0];
  assign out$001_val = out_val[  1];
  assign out$002_val = out_val[  2];
  assign out$003_val = out_val[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_out_val():
  //       for i in xrange( nports ):
  //         s.out[i].val.value = 0
  //         s.out[i].msg.value = 0
  //
  //       if s.in_.val:
  //         s.out[ s.in_.msg.opaque ].val.value = s.in_.val
  //         s.out[ s.in_.msg.opaque ].msg.value = s.in_.msg

  // logic for comb_out_val()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      out_val[i] = 0;
      out_msg[i] = 0;
    end
    if (in__val) begin
      out_val[in__msg[(35)-1:32]] = in__val;
      out_msg[in__msg[(35)-1:32]] = in__msg;
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       # in_rdy is the rdy status of the opaque-th output
  //       s.in_.rdy.value = s.out[ s.in_.msg.opaque ].rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    in__rdy = out_rdy[in__msg[(35)-1:32]];
  end


endmodule // Router_0x4c184f1ee5bd8508
`default_nettype wire

//-----------------------------------------------------------------------------
// InstBuffer_2_16B
//-----------------------------------------------------------------------------
// num_entries: 2
// line_nbytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module InstBuffer_2_16B
(
  input  wire [   0:0] L0_disable,
  input  wire [  77:0] buffreq_msg,
  output reg  [   0:0] buffreq_rdy,
  input  wire [   0:0] buffreq_val,
  output reg  [  47:0] buffresp_msg,
  input  wire [   0:0] buffresp_rdy,
  output reg  [   0:0] buffresp_val,
  input  wire [   0:0] clk,
  output reg  [ 175:0] memreq_msg,
  input  wire [   0:0] memreq_rdy,
  output reg  [   0:0] memreq_val,
  input  wire [ 145:0] memresp_msg,
  output reg  [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  77:0] inner$buffreq_msg;
  reg    [   0:0] inner$buffreq_val;
  reg    [   0:0] inner$buffresp_rdy;
  reg    [   0:0] inner$memreq_rdy;
  reg    [ 145:0] inner$memresp_msg;
  reg    [   0:0] inner$memresp_val;

  // localparam declarations
  localparam data_len = 4;
  localparam data_nbits = 32;
  localparam zero_nbits = 96;

  // inner temporaries
  wire   [   0:0] inner$clk;
  wire   [   0:0] inner$reset;
  wire   [   0:0] inner$memresp_rdy;
  wire   [  47:0] inner$buffresp_msg;
  wire   [   0:0] inner$buffresp_val;
  wire   [ 175:0] inner$memreq_msg;
  wire   [   0:0] inner$memreq_val;
  wire   [   0:0] inner$buffreq_rdy;

  DirectMappedInstBuffer_2_16B inner
  (
    .memresp_msg  ( inner$memresp_msg ),
    .memresp_val  ( inner$memresp_val ),
    .clk          ( inner$clk ),
    .buffresp_rdy ( inner$buffresp_rdy ),
    .reset        ( inner$reset ),
    .memreq_rdy   ( inner$memreq_rdy ),
    .buffreq_msg  ( inner$buffreq_msg ),
    .buffreq_val  ( inner$buffreq_val ),
    .memresp_rdy  ( inner$memresp_rdy ),
    .buffresp_msg ( inner$buffresp_msg ),
    .buffresp_val ( inner$buffresp_val ),
    .memreq_msg   ( inner$memreq_msg ),
    .memreq_val   ( inner$memreq_val ),
    .buffreq_rdy  ( inner$buffreq_rdy )
  );

  // signal connections
  assign inner$clk   = clk;
  assign inner$reset = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_proc_side():
  //
  //       if s.L0_disable: # host turns the l0 off, proc <-> mem
  //
  //         # Mute inner.buffreq
  //         s.inner.buffreq.val.value  = 0
  //         s.inner.buffreq.msg.value  = 0
  //
  //         # Mute inner.buffresp
  //         s.inner.buffresp.rdy.value = 0
  //
  //         # Mute inner.memreq
  //         s.inner.memreq.rdy.value   = 0
  //
  //         # Mute inner.memresp
  //         s.inner.memresp.val.value  = 0
  //         s.inner.memresp.msg.value  = 0
  //
  //         # memreq <- buffreq
  //         s.memreq.val.value         = s.buffreq.val
  //
  //         s.memreq.msg.type_.value   = s.buffreq.msg.type_
  //         s.memreq.msg.opaque.value  = s.buffreq.msg.opaque
  //         s.memreq.msg.addr.value    = s.buffreq.msg.addr
  //         s.memreq.msg.len.value     = data_len
  //         s.memreq.msg.data.value    = concat( Bits(zero_nbits, 0), s.buffreq.msg.data )
  //
  //         s.buffreq.rdy.value        = s.memreq.rdy
  //
  //         # buffresp <- memresp
  //         s.buffresp.val.value        = s.memresp.val
  //
  //         s.buffresp.msg.type_.value  = s.memresp.msg.type_
  //         s.buffresp.msg.opaque.value = s.memresp.msg.opaque
  //         s.buffresp.msg.test.value   = s.memresp.msg.test
  //         s.buffresp.msg.len.value    = 0
  //         s.buffresp.msg.data.value   = s.memresp.msg[0:data_nbits]
  //
  //         s.memresp.rdy.value         = s.buffresp.rdy
  //
  //       else: # otherwise proc <-> inner <-> mem
  //
  //         # inner.buffreq <- buffreq
  //         s.inner.buffreq.val.value  = s.buffreq.val
  //         s.inner.buffreq.msg.value  = s.buffreq.msg
  //         s.buffreq.rdy.value        = s.inner.buffreq.rdy
  //
  //         # buffresp <- inner.buffresp
  //         s.buffresp.val.value       = s.inner.buffresp.val
  //         s.buffresp.msg.value       = s.inner.buffresp.msg
  //         s.inner.buffresp.rdy.value = s.buffresp.rdy
  //
  //         # memreq <- inner.memreq
  //         s.memreq.val.value         = s.inner.memreq.val
  //         s.memreq.msg.value         = s.inner.memreq.msg
  //         s.inner.memreq.rdy.value   = s.memreq.rdy
  //
  //         # inner.memresp <- memresp
  //         s.inner.memresp.val.value  = s.memresp.val
  //         s.inner.memresp.msg.value  = s.memresp.msg
  //         s.memresp.rdy.value        = s.inner.memresp.rdy

  // logic for comb_proc_side()
  always @ (*) begin
    if (L0_disable) begin
      inner$buffreq_val = 0;
      inner$buffreq_msg = 0;
      inner$buffresp_rdy = 0;
      inner$memreq_rdy = 0;
      inner$memresp_val = 0;
      inner$memresp_msg = 0;
      memreq_val = buffreq_val;
      memreq_msg[(176)-1:172] = buffreq_msg[(78)-1:74];
      memreq_msg[(172)-1:164] = buffreq_msg[(74)-1:66];
      memreq_msg[(164)-1:132] = buffreq_msg[(66)-1:34];
      memreq_msg[(132)-1:128] = data_len;
      memreq_msg[(128)-1:0] = { 96'd0,buffreq_msg[(32)-1:0] };
      buffreq_rdy = memreq_rdy;
      buffresp_val = memresp_val;
      buffresp_msg[(48)-1:44] = memresp_msg[(146)-1:142];
      buffresp_msg[(44)-1:36] = memresp_msg[(142)-1:134];
      buffresp_msg[(36)-1:34] = memresp_msg[(134)-1:132];
      buffresp_msg[(34)-1:32] = 0;
      buffresp_msg[(32)-1:0] = memresp_msg[(data_nbits)-1:0];
      memresp_rdy = buffresp_rdy;
    end
    else begin
      inner$buffreq_val = buffreq_val;
      inner$buffreq_msg = buffreq_msg;
      buffreq_rdy = inner$buffreq_rdy;
      buffresp_val = inner$buffresp_val;
      buffresp_msg = inner$buffresp_msg;
      inner$buffresp_rdy = buffresp_rdy;
      memreq_val = inner$memreq_val;
      memreq_msg = inner$memreq_msg;
      inner$memreq_rdy = memreq_rdy;
      inner$memresp_val = memresp_val;
      inner$memresp_msg = memresp_msg;
      memresp_rdy = inner$memresp_rdy;
    end
  end


endmodule // InstBuffer_2_16B
`default_nettype wire

//-----------------------------------------------------------------------------
// DirectMappedInstBuffer_2_16B
//-----------------------------------------------------------------------------
// num_entries: 2
// line_nbytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DirectMappedInstBuffer_2_16B
(
  input  wire [  77:0] buffreq_msg,
  output wire [   0:0] buffreq_rdy,
  input  wire [   0:0] buffreq_val,
  output wire [  47:0] buffresp_msg,
  input  wire [   0:0] buffresp_rdy,
  output wire [   0:0] buffresp_val,
  input  wire [   0:0] clk,
  output wire [ 175:0] memreq_msg,
  input  wire [   0:0] memreq_rdy,
  output wire [   0:0] memreq_val,
  input  wire [ 145:0] memresp_msg,
  output wire [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$is_valid;
  wire   [   0:0] ctrl$memreq_rdy;
  wire   [   0:0] ctrl$memresp_val;
  wire   [   0:0] ctrl$buffresp_rdy;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$buffreq_val;
  wire   [   0:0] ctrl$tag_match;
  wire   [   0:0] ctrl$buffresp_val;
  wire   [   0:0] ctrl$memresp_rdy;
  wire   [   0:0] ctrl$buffreq_rdy;
  wire   [   0:0] ctrl$buffresp_hit;
  wire   [   0:0] ctrl$buffreq_en;
  wire   [   0:0] ctrl$arrays_wen;
  wire   [   0:0] ctrl$memreq_val;

  DirectMappedInstBufferCtrl_0x7df7f9ab2d93368c ctrl
  (
    .clk          ( ctrl$clk ),
    .is_valid     ( ctrl$is_valid ),
    .memreq_rdy   ( ctrl$memreq_rdy ),
    .memresp_val  ( ctrl$memresp_val ),
    .buffresp_rdy ( ctrl$buffresp_rdy ),
    .reset        ( ctrl$reset ),
    .buffreq_val  ( ctrl$buffreq_val ),
    .tag_match    ( ctrl$tag_match ),
    .buffresp_val ( ctrl$buffresp_val ),
    .memresp_rdy  ( ctrl$memresp_rdy ),
    .buffreq_rdy  ( ctrl$buffreq_rdy ),
    .buffresp_hit ( ctrl$buffresp_hit ),
    .buffreq_en   ( ctrl$buffreq_en ),
    .arrays_wen   ( ctrl$arrays_wen ),
    .memreq_val   ( ctrl$memreq_val )
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
  wire   [ 145:0] dpath$memresp_msg;
  wire   [   0:0] dpath$buffresp_hit;
  wire   [   0:0] dpath$buffreq_en;
  wire   [   0:0] dpath$arrays_wen;
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$clk;
  wire   [  77:0] dpath$buffreq_msg;
  wire   [  47:0] dpath$buffresp_msg;
  wire   [ 175:0] dpath$memreq_msg;
  wire   [   0:0] dpath$is_valid;
  wire   [   0:0] dpath$tag_match;

  DirectMappedInstBufferDpath_0x75920d747bf52bfe dpath
  (
    .memresp_msg  ( dpath$memresp_msg ),
    .buffresp_hit ( dpath$buffresp_hit ),
    .buffreq_en   ( dpath$buffreq_en ),
    .arrays_wen   ( dpath$arrays_wen ),
    .reset        ( dpath$reset ),
    .clk          ( dpath$clk ),
    .buffreq_msg  ( dpath$buffreq_msg ),
    .buffresp_msg ( dpath$buffresp_msg ),
    .memreq_msg   ( dpath$memreq_msg ),
    .is_valid     ( dpath$is_valid ),
    .tag_match    ( dpath$tag_match )
  );

  // signal connections
  assign buffreq_rdy         = ctrl$buffreq_rdy;
  assign buffresp_msg        = resp_bypass$deq_msg;
  assign buffresp_val        = resp_bypass$deq_val;
  assign ctrl$buffreq_val    = buffreq_val;
  assign ctrl$buffresp_rdy   = resp_bypass$enq_rdy;
  assign ctrl$clk            = clk;
  assign ctrl$is_valid       = dpath$is_valid;
  assign ctrl$memreq_rdy     = memreq_rdy;
  assign ctrl$memresp_val    = memresp_val;
  assign ctrl$reset          = reset;
  assign ctrl$tag_match      = dpath$tag_match;
  assign dpath$arrays_wen    = ctrl$arrays_wen;
  assign dpath$buffreq_en    = ctrl$buffreq_en;
  assign dpath$buffreq_msg   = buffreq_msg;
  assign dpath$buffresp_hit  = ctrl$buffresp_hit;
  assign dpath$clk           = clk;
  assign dpath$memresp_msg   = memresp_msg;
  assign dpath$reset         = reset;
  assign memreq_msg          = dpath$memreq_msg;
  assign memreq_val          = ctrl$memreq_val;
  assign memresp_rdy         = ctrl$memresp_rdy;
  assign resp_bypass$clk     = clk;
  assign resp_bypass$deq_rdy = buffresp_rdy;
  assign resp_bypass$enq_msg = dpath$buffresp_msg;
  assign resp_bypass$enq_val = ctrl$buffresp_val;
  assign resp_bypass$reset   = reset;



endmodule // DirectMappedInstBuffer_2_16B
`default_nettype wire

//-----------------------------------------------------------------------------
// DirectMappedInstBufferCtrl_0x7df7f9ab2d93368c
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DirectMappedInstBufferCtrl_0x7df7f9ab2d93368c
(
  output reg  [   0:0] arrays_wen,
  output reg  [   0:0] buffreq_en,
  output reg  [   0:0] buffreq_rdy,
  input  wire [   0:0] buffreq_val,
  output reg  [   0:0] buffresp_hit,
  input  wire [   0:0] buffresp_rdy,
  output reg  [   0:0] buffresp_val,
  input  wire [   0:0] clk,
  input  wire [   0:0] is_valid,
  input  wire [   0:0] memreq_rdy,
  output reg  [   0:0] memreq_val,
  output reg  [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset,
  input  wire [   0:0] tag_match
);

  // register declarations
  reg    [   6:0] cs;
  reg    [   0:0] hit;
  reg    [   0:0] in_go;
  reg    [   0:0] out_go;
  reg    [   2:0] sr__3;
  reg    [   2:0] state_next;
  reg    [   2:0] state_reg;

  // localparam declarations
  localparam STATE_IDLE = 3'd0;
  localparam STATE_REFILL_REQUEST = 3'd2;
  localparam STATE_REFILL_WAIT = 3'd3;
  localparam STATE_TAG_CHECK = 3'd1;
  localparam STATE_WAIT_HIT = 3'd4;
  localparam STATE_WAIT_MISS = 3'd5;
  localparam n = 1'd0;
  localparam x = 1'd0;
  localparam y = 1'd1;



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
  //       s.in_go.value  = s.buffreq_val  & s.buffreq_rdy
  //       s.out_go.value = s.buffresp_val & s.buffresp_rdy
  //       s.hit.value    = s.is_valid & s.tag_match

  // logic for comb_state_transition()
  always @ (*) begin
    in_go = (buffreq_val&buffreq_rdy);
    out_go = (buffresp_val&buffresp_rdy);
    hit = (is_valid&tag_match);
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
  //         if s.memresp_val: s.state_next.value = s.STATE_WAIT_MISS
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
              state_next = STATE_WAIT_MISS;
            end
            else begin
            end
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_control_table():
  //       sr = s.state_reg
  //
  //       #                                                       $   $    mem mem  $   $    arrays
  //       #                                                       req resp req resp req resp wen
  //       #                                                       rdy val  val rdy  en  hit  
  //       s.cs.value                                    = concat( n,  n,   n,  n,   x,  n,   n  )
  //       if   sr == s.STATE_IDLE:           s.cs.value = concat( y,  n,   n,  n,   y,  n,   n  )
  //       elif sr == s.STATE_TAG_CHECK:      s.cs.value = concat( n,  n,   n,  n,   n,  n,   n  )
  //       elif sr == s.STATE_REFILL_REQUEST: s.cs.value = concat( n,  n,   y,  n,   n,  n,   n  )
  //       elif sr == s.STATE_REFILL_WAIT:    s.cs.value = concat( n,  n,   n,  y,   n,  n,   y  )
  //       elif sr == s.STATE_WAIT_HIT:       s.cs.value = concat( n,  y,   n,  n,   n,  y,   n  )
  //       elif sr == s.STATE_WAIT_MISS:      s.cs.value = concat( n,  y,   n,  n,   n,  n,   n  )
  //       else:                              s.cs.value = concat( n,  n,   n,  n,   n,  n,   n  )
  //
  //       # Unpack signals
  //
  //       s.buffreq_rdy.value    = s.cs[ CS_buffreq_rdy    ]
  //       s.buffresp_val.value   = s.cs[ CS_buffresp_val   ]
  //       s.memreq_val.value     = s.cs[ CS_memreq_val     ]
  //       s.memresp_rdy.value    = s.cs[ CS_memresp_rdy    ]
  //       s.buffreq_en.value     = s.cs[ CS_buffreq_en     ]
  //       s.buffresp_hit.value   = s.cs[ CS_buffresp_hit   ]
  //       s.arrays_wen.value     = s.cs[ CS_arrays_wen     ]
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
  //
  //       if (s.state_reg == s.STATE_REFILL_WAIT) & ~s.memresp_val:
  //         s.arrays_wen.value = 0

  // logic for comb_control_table()
  always @ (*) begin
    sr__3 = state_reg;
    cs = { n,n,n,n,x,n,n };
    if ((sr__3 == STATE_IDLE)) begin
      cs = { y,n,n,n,y,n,n };
    end
    else begin
      if ((sr__3 == STATE_TAG_CHECK)) begin
        cs = { n,n,n,n,n,n,n };
      end
      else begin
        if ((sr__3 == STATE_REFILL_REQUEST)) begin
          cs = { n,n,y,n,n,n,n };
        end
        else begin
          if ((sr__3 == STATE_REFILL_WAIT)) begin
            cs = { n,n,n,y,n,n,y };
          end
          else begin
            if ((sr__3 == STATE_WAIT_HIT)) begin
              cs = { n,y,n,n,n,y,n };
            end
            else begin
              if ((sr__3 == STATE_WAIT_MISS)) begin
                cs = { n,y,n,n,n,n,n };
              end
              else begin
                cs = { n,n,n,n,n,n,n };
              end
            end
          end
        end
      end
    end
    buffreq_rdy = cs[(7)-1:6];
    buffresp_val = cs[(6)-1:5];
    memreq_val = cs[(5)-1:4];
    memresp_rdy = cs[(4)-1:3];
    buffreq_en = cs[(3)-1:2];
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
    if (((state_reg == STATE_REFILL_WAIT)&~memresp_val)) begin
      arrays_wen = 0;
    end
    else begin
    end
  end


endmodule // DirectMappedInstBufferCtrl_0x7df7f9ab2d93368c
`default_nettype wire

//-----------------------------------------------------------------------------
// DirectMappedInstBufferDpath_0x75920d747bf52bfe
//-----------------------------------------------------------------------------
// num_entries: 2
// line_nbytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DirectMappedInstBufferDpath_0x75920d747bf52bfe
(
  input  wire [   0:0] arrays_wen,
  input  wire [   0:0] buffreq_en,
  input  wire [  77:0] buffreq_msg,
  input  wire [   0:0] buffresp_hit,
  output reg  [  47:0] buffresp_msg,
  input  wire [   0:0] clk,
  output reg  [   0:0] is_valid,
  output reg  [ 175:0] memreq_msg,
  input  wire [ 145:0] memresp_msg,
  input  wire [   0:0] reset,
  output wire [   0:0] tag_match
);

  // wire declarations
  wire   [   1:0] buffreq_offset;
  wire   [   0:0] buffreq_idx;
  wire   [ 127:0] data_read_out;
  wire   [  26:0] buffreq_tag;
  wire   [  26:0] tag_read_out;


  // register declarations
  reg    [   1:0] valid_array$in_;

  // localparam declarations
  localparam TYPE_READ = 0;
  localparam line_bw = 4;

  // tag_array temporaries
  wire   [   0:0] tag_array$rd_addr$000;
  wire   [  26:0] tag_array$wr_data;
  wire   [   0:0] tag_array$clk;
  wire   [   0:0] tag_array$wr_addr;
  wire   [   0:0] tag_array$wr_en;
  wire   [   0:0] tag_array$reset;
  wire   [  26:0] tag_array$rd_data$000;

  RegisterFile_0x2e2ef9fd0efc0b3d tag_array
  (
    .rd_addr$000 ( tag_array$rd_addr$000 ),
    .wr_data     ( tag_array$wr_data ),
    .clk         ( tag_array$clk ),
    .wr_addr     ( tag_array$wr_addr ),
    .wr_en       ( tag_array$wr_en ),
    .reset       ( tag_array$reset ),
    .rd_data$000 ( tag_array$rd_data$000 )
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

  // valid_array temporaries
  wire   [   0:0] valid_array$reset;
  wire   [   0:0] valid_array$en;
  wire   [   0:0] valid_array$clk;
  wire   [   1:0] valid_array$out;

  RegEnRst_0x9f365fdf6c8998a valid_array
  (
    .reset ( valid_array$reset ),
    .en    ( valid_array$en ),
    .clk   ( valid_array$clk ),
    .in_   ( valid_array$in_ ),
    .out   ( valid_array$out )
  );

  // read_word_sel_mux temporaries
  wire   [   0:0] read_word_sel_mux$reset;
  wire   [  31:0] read_word_sel_mux$in_$000;
  wire   [  31:0] read_word_sel_mux$in_$001;
  wire   [  31:0] read_word_sel_mux$in_$002;
  wire   [  31:0] read_word_sel_mux$in_$003;
  wire   [   0:0] read_word_sel_mux$clk;
  wire   [   1:0] read_word_sel_mux$sel;
  wire   [  31:0] read_word_sel_mux$out;

  Mux_0x7be03e4007003adc read_word_sel_mux
  (
    .reset   ( read_word_sel_mux$reset ),
    .in_$000 ( read_word_sel_mux$in_$000 ),
    .in_$001 ( read_word_sel_mux$in_$001 ),
    .in_$002 ( read_word_sel_mux$in_$002 ),
    .in_$003 ( read_word_sel_mux$in_$003 ),
    .clk     ( read_word_sel_mux$clk ),
    .sel     ( read_word_sel_mux$sel ),
    .out     ( read_word_sel_mux$out )
  );

  // tag_compare temporaries
  wire   [   0:0] tag_compare$reset;
  wire   [   0:0] tag_compare$clk;
  wire   [  26:0] tag_compare$in0;
  wire   [  26:0] tag_compare$in1;
  wire   [   0:0] tag_compare$out;

  EqComparator_0x4c7a718b2f9234c tag_compare
  (
    .reset ( tag_compare$reset ),
    .clk   ( tag_compare$clk ),
    .in0   ( tag_compare$in0 ),
    .in1   ( tag_compare$in1 ),
    .out   ( tag_compare$out )
  );

  // data_array temporaries
  wire   [   0:0] data_array$rd_addr$000;
  wire   [ 127:0] data_array$wr_data;
  wire   [   0:0] data_array$clk;
  wire   [   0:0] data_array$wr_addr;
  wire   [   0:0] data_array$wr_en;
  wire   [   0:0] data_array$reset;
  wire   [ 127:0] data_array$rd_data$000;

  RegisterFile_0x2474419f459a86ac data_array
  (
    .rd_addr$000 ( data_array$rd_addr$000 ),
    .wr_data     ( data_array$wr_data ),
    .clk         ( data_array$clk ),
    .wr_addr     ( data_array$wr_addr ),
    .wr_en       ( data_array$wr_en ),
    .reset       ( data_array$reset ),
    .rd_data$000 ( data_array$rd_data$000 )
  );

  // signal connections
  assign buffreq_addr_reg$clk      = clk;
  assign buffreq_addr_reg$en       = buffreq_en;
  assign buffreq_addr_reg$in_      = buffreq_msg[65:34];
  assign buffreq_addr_reg$reset    = reset;
  assign buffreq_idx               = buffreq_addr_reg$out[4:4];
  assign buffreq_offset            = buffreq_addr_reg$out[3:2];
  assign buffreq_opaque_reg$clk    = clk;
  assign buffreq_opaque_reg$en     = buffreq_en;
  assign buffreq_opaque_reg$in_    = buffreq_msg[73:66];
  assign buffreq_opaque_reg$reset  = reset;
  assign buffreq_tag               = buffreq_addr_reg$out[31:5];
  assign buffresp_msg[43:36]       = buffreq_opaque_reg$out;
  assign data_array$clk            = clk;
  assign data_array$rd_addr$000    = buffreq_idx;
  assign data_array$reset          = reset;
  assign data_array$wr_addr        = buffreq_idx;
  assign data_array$wr_data        = memresp_msg[127:0];
  assign data_array$wr_en          = arrays_wen;
  assign data_read_out             = data_array$rd_data$000;
  assign read_word_sel_mux$clk     = clk;
  assign read_word_sel_mux$in_$000 = data_read_out[31:0];
  assign read_word_sel_mux$in_$001 = data_read_out[63:32];
  assign read_word_sel_mux$in_$002 = data_read_out[95:64];
  assign read_word_sel_mux$in_$003 = data_read_out[127:96];
  assign read_word_sel_mux$reset   = reset;
  assign read_word_sel_mux$sel     = buffreq_offset;
  assign tag_array$clk             = clk;
  assign tag_array$rd_addr$000     = buffreq_idx;
  assign tag_array$reset           = reset;
  assign tag_array$wr_addr         = buffreq_idx;
  assign tag_array$wr_data         = buffreq_tag;
  assign tag_array$wr_en           = arrays_wen;
  assign tag_compare$clk           = clk;
  assign tag_compare$in0           = tag_read_out;
  assign tag_compare$in1           = buffreq_tag;
  assign tag_compare$reset         = reset;
  assign tag_match                 = tag_compare$out;
  assign tag_read_out              = tag_array$rd_data$000;
  assign valid_array$clk           = clk;
  assign valid_array$en            = arrays_wen;
  assign valid_array$reset         = reset;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_valid_read():
  //       s.is_valid.value = s.valid_array.out[ s.buffreq_idx ] # effectively a huge mux

  // logic for comb_valid_read()
  always @ (*) begin
    is_valid = valid_array$out[buffreq_idx];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_valid_write():
  //       s.valid_array.in_.value = s.valid_array.out  # hawajkm: avoid latches :)
  //       s.valid_array.in_[ s.buffreq_idx ].value = 1 # effectively a huge demux

  // logic for comb_valid_write()
  always @ (*) begin
    valid_array$in_ = valid_array$out;
    valid_array$in_[buffreq_idx] = 1;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_buffresp_msg_pack():
  //       s.buffresp_msg.type_.value = MemRespMsg.TYPE_READ
  //       s.buffresp_msg.test.value  = concat( Bits( 1, 0 ), s.buffresp_hit )
  //       s.buffresp_msg.len.value   = 0
  //       s.buffresp_msg.data.value  = s.read_word_sel_mux.out

  // logic for comb_buffresp_msg_pack()
  always @ (*) begin
    buffresp_msg[(48)-1:44] = TYPE_READ;
    buffresp_msg[(36)-1:34] = { 1'd0,buffresp_hit };
    buffresp_msg[(34)-1:32] = 0;
    buffresp_msg[(32)-1:0] = read_word_sel_mux$out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_memreq_msg_pack():
  //       s.memreq_msg.type_.value  = MemReqMsg.TYPE_READ
  //       s.memreq_msg.opaque.value = 0
  //       # No need to select/register the tag from tag array since there is no eviction!
  //       s.memreq_msg.addr.value   = concat(s.buffreq_tag, s.buffreq_idx, Bits(line_bw, 0))
  //       s.memreq_msg.len.value    = 0
  //       s.memreq_msg.data.value   = 0

  // logic for comb_memreq_msg_pack()
  always @ (*) begin
    memreq_msg[(176)-1:172] = TYPE_READ;
    memreq_msg[(172)-1:164] = 0;
    memreq_msg[(164)-1:132] = { buffreq_tag,buffreq_idx,4'd0 };
    memreq_msg[(132)-1:128] = 0;
    memreq_msg[(128)-1:0] = 0;
  end


endmodule // DirectMappedInstBufferDpath_0x75920d747bf52bfe
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x2e2ef9fd0efc0b3d
//-----------------------------------------------------------------------------
// dtype: 27
// nregs: 2
// rd_ports: 1
// wr_ports: 1
// const_zero: False
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x2e2ef9fd0efc0b3d
(
  input  wire [   0:0] clk,
  input  wire [   0:0] rd_addr$000,
  output wire [  26:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] wr_addr,
  input  wire [  26:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  26:0] regs$000;
  wire   [  26:0] regs$001;


  // localparam declarations
  localparam nregs = 2;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   0:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  26:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  26:0] regs[0:1];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];

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


endmodule // RegisterFile_0x2e2ef9fd0efc0b3d
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
// RegisterFile_0x2474419f459a86ac
//-----------------------------------------------------------------------------
// dtype: 128
// nregs: 2
// rd_ports: 1
// wr_ports: 1
// const_zero: False
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x2474419f459a86ac
(
  input  wire [   0:0] clk,
  input  wire [   0:0] rd_addr$000,
  output wire [ 127:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] wr_addr,
  input  wire [ 127:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [ 127:0] regs$000;
  wire   [ 127:0] regs$001;


  // localparam declarations
  localparam nregs = 2;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   0:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [ 127:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [ 127:0] regs[0:1];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];

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


endmodule // RegisterFile_0x2474419f459a86ac
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

  IntMulPipelined_2Stage imul
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

  IntDivRem4RegIn_0x59e69d2f49a6706a idiv
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
// IntMulPipelined_2Stage
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// nstages: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntMulPipelined_2Stage
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

  // wire declarations
  wire   [  31:0] opa;
  wire   [  31:0] opb;
  wire   [   2:0] typ;


  // register declarations
  reg    [  63:0] a_mulh_negate;
  reg    [  63:0] ext_opa;
  reg    [  95:0] mul_result;
  reg    [  31:0] resp_result;

  // localparam declarations
  localparam TYPE_MUL = 0;
  localparam TYPE_MULH = 1;
  localparam TYPE_MULHSU = 2;
  localparam nbits = 32;
  localparam nbitsx2 = 64;

  // regs_resp_val$000 temporaries
  wire   [   0:0] regs_resp_val$000$reset;
  wire   [   0:0] regs_resp_val$000$en;
  wire   [   0:0] regs_resp_val$000$clk;
  wire   [   0:0] regs_resp_val$000$in_;
  wire   [   0:0] regs_resp_val$000$out;

  RegEnRst_0x2ce052f8c32c5c39 regs_resp_val$000
  (
    .reset ( regs_resp_val$000$reset ),
    .en    ( regs_resp_val$000$en ),
    .clk   ( regs_resp_val$000$clk ),
    .in_   ( regs_resp_val$000$in_ ),
    .out   ( regs_resp_val$000$out )
  );

  // reg_req_val temporaries
  wire   [   0:0] reg_req_val$reset;
  wire   [   0:0] reg_req_val$en;
  wire   [   0:0] reg_req_val$clk;
  wire   [   0:0] reg_req_val$in_;
  wire   [   0:0] reg_req_val$out;

  RegEnRst_0x2ce052f8c32c5c39 reg_req_val
  (
    .reset ( reg_req_val$reset ),
    .en    ( reg_req_val$en ),
    .clk   ( reg_req_val$clk ),
    .in_   ( reg_req_val$in_ ),
    .out   ( reg_req_val$out )
  );

  // regs_resp_msg$000 temporaries
  wire   [   0:0] regs_resp_msg$000$reset;
  wire   [  34:0] regs_resp_msg$000$in_;
  wire   [   0:0] regs_resp_msg$000$clk;
  wire   [   0:0] regs_resp_msg$000$en;
  wire   [  34:0] regs_resp_msg$000$out;

  RegEn_0x48bd4b6ec5ffe974 regs_resp_msg$000
  (
    .reset ( regs_resp_msg$000$reset ),
    .in_   ( regs_resp_msg$000$in_ ),
    .clk   ( regs_resp_msg$000$clk ),
    .en    ( regs_resp_msg$000$en ),
    .out   ( regs_resp_msg$000$out )
  );

  // reg_req_msg temporaries
  wire   [   0:0] reg_req_msg$reset;
  wire   [  69:0] reg_req_msg$in_;
  wire   [   0:0] reg_req_msg$clk;
  wire   [   0:0] reg_req_msg$en;
  wire   [  69:0] reg_req_msg$out;

  RegEn_0x33e44399f27afd57 reg_req_msg
  (
    .reset ( reg_req_msg$reset ),
    .in_   ( reg_req_msg$in_ ),
    .clk   ( reg_req_msg$clk ),
    .en    ( reg_req_msg$en ),
    .out   ( reg_req_msg$out )
  );

  // resp_q temporaries
  wire   [   0:0] resp_q$clk;
  wire   [  34:0] resp_q$enq_msg;
  wire   [   0:0] resp_q$enq_val;
  wire   [   0:0] resp_q$reset;
  wire   [   0:0] resp_q$deq_rdy;
  wire   [   0:0] resp_q$enq_rdy;
  wire   [   0:0] resp_q$full;
  wire   [  34:0] resp_q$deq_msg;
  wire   [   0:0] resp_q$deq_val;

  SingleElementBypassQueue_0x6d029bebd254ac61 resp_q
  (
    .clk     ( resp_q$clk ),
    .enq_msg ( resp_q$enq_msg ),
    .enq_val ( resp_q$enq_val ),
    .reset   ( resp_q$reset ),
    .deq_rdy ( resp_q$deq_rdy ),
    .enq_rdy ( resp_q$enq_rdy ),
    .full    ( resp_q$full ),
    .deq_msg ( resp_q$deq_msg ),
    .deq_val ( resp_q$deq_val )
  );

  // signal connections
  assign opa                          = reg_req_msg$out[63:32];
  assign opb                          = reg_req_msg$out[31:0];
  assign reg_req_msg$clk              = clk;
  assign reg_req_msg$en               = resp_q$enq_rdy;
  assign reg_req_msg$in_              = req_msg;
  assign reg_req_msg$reset            = reset;
  assign reg_req_val$clk              = clk;
  assign reg_req_val$en               = resp_q$enq_rdy;
  assign reg_req_val$in_              = req_val;
  assign reg_req_val$reset            = reset;
  assign regs_resp_msg$000$clk        = clk;
  assign regs_resp_msg$000$en         = resp_q$enq_rdy;
  assign regs_resp_msg$000$in_[31:0]  = resp_result;
  assign regs_resp_msg$000$in_[34:32] = reg_req_msg$out[66:64];
  assign regs_resp_msg$000$reset      = reset;
  assign regs_resp_val$000$clk        = clk;
  assign regs_resp_val$000$en         = resp_q$enq_rdy;
  assign regs_resp_val$000$in_        = reg_req_val$out;
  assign regs_resp_val$000$reset      = reset;
  assign req_rdy                      = resp_q$enq_rdy;
  assign resp_msg                     = resp_q$deq_msg;
  assign resp_q$clk                   = clk;
  assign resp_q$deq_rdy               = resp_rdy;
  assign resp_q$enq_msg               = regs_resp_msg$000$out;
  assign resp_q$enq_val               = regs_resp_val$000$out;
  assign resp_q$reset                 = reset;
  assign resp_val                     = resp_q$deq_val;
  assign typ                          = reg_req_msg$out[69:67];


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_opa():
  //       if s.typ == MduReqMsg.TYPE_MULHSU or s.typ == MduReqMsg.TYPE_MULH:
  //         s.ext_opa.value = sext( s.opa, nbitsx2 )
  //       else:
  //         s.ext_opa.value = zext( s.opa, nbitsx2 )

  // logic for comb_opa()
  always @ (*) begin
    if (((typ == TYPE_MULHSU)||(typ == TYPE_MULH))) begin
      ext_opa = { { nbitsx2-32 { opa[31] } }, opa[31:0] };
    end
    else begin
      ext_opa = { { nbitsx2-32 { 1'b0 } }, opa[31:0] };
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_a_mulh_negate():
  //       s.a_mulh_negate[0:nbits].value = 0
  //       s.a_mulh_negate[nbits:].value  = ~s.opa + 1

  // logic for comb_a_mulh_negate()
  always @ (*) begin
    a_mulh_negate[(nbits)-1:0] = 0;
    a_mulh_negate[(64)-1:nbits] = (~opa+1);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_multiply():
  //       if s.typ == MduReqMsg.TYPE_MULH and s.opb[nbits-1]:
  //         s.mul_result.value = s.ext_opa * s.opb + s.a_mulh_negate
  //       else:
  //         s.mul_result.value = s.ext_opa * s.opb

  // logic for comb_multiply()
  always @ (*) begin
    if (((typ == TYPE_MULH)&&opb[(nbits-1)])) begin
      mul_result = ((ext_opa*opb)+a_mulh_negate);
    end
    else begin
      mul_result = (ext_opa*opb);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_select_hilo():
  //       if s.typ == MduReqMsg.TYPE_MUL:
  //         s.resp_result.value = s.mul_result[0:nbits]
  //       else:
  //         s.resp_result.value = s.mul_result[nbits:nbitsx2]

  // logic for comb_select_hilo()
  always @ (*) begin
    if ((typ == TYPE_MUL)) begin
      resp_result = mul_result[(nbits)-1:0];
    end
    else begin
      resp_result = mul_result[(nbitsx2)-1:nbits];
    end
  end


endmodule // IntMulPipelined_2Stage
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x48bd4b6ec5ffe974
//-----------------------------------------------------------------------------
// dtype: 35
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x48bd4b6ec5ffe974
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  34:0] in_,
  output reg  [  34:0] out,
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


endmodule // RegEn_0x48bd4b6ec5ffe974
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x33e44399f27afd57
//-----------------------------------------------------------------------------
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x33e44399f27afd57
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  69:0] in_,
  output reg  [  69:0] out,
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


endmodule // RegEn_0x33e44399f27afd57
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x6d029bebd254ac61
//-----------------------------------------------------------------------------
// dtype: 35
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x6d029bebd254ac61
(
  input  wire [   0:0] clk,
  output wire [  34:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  34:0] enq_msg,
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
  wire   [  34:0] dpath$enq_bits;
  wire   [  34:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x6d029bebd254ac61 dpath
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



endmodule // SingleElementBypassQueue_0x6d029bebd254ac61
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x6d029bebd254ac61
//-----------------------------------------------------------------------------
// dtype: 35
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x6d029bebd254ac61
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  34:0] deq_bits,
  input  wire [  34:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  34:0] bypass_mux$in_$000;
  wire   [  34:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  34:0] bypass_mux$out;

  Mux_0xefbd361882188ff bypass_mux
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
  wire   [  34:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  34:0] queue$out;

  RegEn_0x48bd4b6ec5ffe974 queue
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



endmodule // SingleElementBypassQueueDpath_0x6d029bebd254ac61
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0xefbd361882188ff
//-----------------------------------------------------------------------------
// dtype: 35
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0xefbd361882188ff
(
  input  wire [   0:0] clk,
  input  wire [  34:0] in_$000,
  input  wire [  34:0] in_$001,
  output reg  [  34:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  34:0] in_[0:1];
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


endmodule // Mux_0xefbd361882188ff
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4RegIn_0x59e69d2f49a6706a
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4RegIn_0x59e69d2f49a6706a
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
  wire   [   0:0] ctrl$input_reg_en;
  wire   [   0:0] ctrl$req_rdy;
  wire   [   0:0] ctrl$buffers_en;

  IntDivRem4RegInCtrl_0x59e69d2f49a6706a ctrl
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
    .input_reg_en      ( ctrl$input_reg_en ),
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
  wire   [  69:0] dpath$req_msg;
  wire   [   1:0] dpath$remainder_mux_sel;
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$input_reg_en;
  wire   [   0:0] dpath$buffers_en;
  wire   [   0:0] dpath$divisor_mux_sel;
  wire   [   0:0] dpath$sub_negative1;
  wire   [   0:0] dpath$sub_negative2;
  wire   [   2:0] dpath$req_type;
  wire   [  34:0] dpath$resp_msg;

  IntDivRem4RegInDpath_0x59e69d2f49a6706a dpath
  (
    .remainder_reg_en  ( dpath$remainder_reg_en ),
    .quotient_mux_sel  ( dpath$quotient_mux_sel ),
    .is_div            ( dpath$is_div ),
    .quotient_reg_en   ( dpath$quotient_reg_en ),
    .clk               ( dpath$clk ),
    .is_signed         ( dpath$is_signed ),
    .req_msg           ( dpath$req_msg ),
    .remainder_mux_sel ( dpath$remainder_mux_sel ),
    .reset             ( dpath$reset ),
    .input_reg_en      ( dpath$input_reg_en ),
    .buffers_en        ( dpath$buffers_en ),
    .divisor_mux_sel   ( dpath$divisor_mux_sel ),
    .sub_negative1     ( dpath$sub_negative1 ),
    .sub_negative2     ( dpath$sub_negative2 ),
    .req_type          ( dpath$req_type ),
    .resp_msg          ( dpath$resp_msg )
  );

  // signal connections
  assign ctrl$clk                = clk;
  assign ctrl$req_type           = dpath$req_type;
  assign ctrl$req_val            = req_val;
  assign ctrl$reset              = reset;
  assign ctrl$resp_rdy           = resp_rdy;
  assign ctrl$sub_negative1      = dpath$sub_negative1;
  assign ctrl$sub_negative2      = dpath$sub_negative2;
  assign dpath$buffers_en        = ctrl$buffers_en;
  assign dpath$clk               = clk;
  assign dpath$divisor_mux_sel   = ctrl$divisor_mux_sel;
  assign dpath$input_reg_en      = ctrl$input_reg_en;
  assign dpath$is_div            = ctrl$is_div;
  assign dpath$is_signed         = ctrl$is_signed;
  assign dpath$quotient_mux_sel  = ctrl$quotient_mux_sel;
  assign dpath$quotient_reg_en   = ctrl$quotient_reg_en;
  assign dpath$remainder_mux_sel = ctrl$remainder_mux_sel;
  assign dpath$remainder_reg_en  = ctrl$remainder_reg_en;
  assign dpath$req_msg           = req_msg;
  assign dpath$reset             = reset;
  assign req_rdy                 = ctrl$req_rdy;
  assign resp_msg                = dpath$resp_msg;
  assign resp_val                = ctrl$resp_val;



endmodule // IntDivRem4RegIn_0x59e69d2f49a6706a
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4RegInCtrl_0x59e69d2f49a6706a
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4RegInCtrl_0x59e69d2f49a6706a
(
  output reg  [   0:0] buffers_en,
  input  wire [   0:0] clk,
  output reg  [   0:0] divisor_mux_sel,
  output reg  [   0:0] input_reg_en,
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
  localparam STATE_WAIT = 18;

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
  //         if s.req_val:
  //           s.state.in_.value = s.STATE_WAIT
  //
  //       elif curr_state == s.STATE_WAIT: # Register input
  //         s.state.in_.value = s.STATE_CALC
  //
  //       elif curr_state == s.STATE_DONE:
  //         if s.resp_rdy:
  //           s.state.in_.value = s.STATE_IDLE
  //
  //       else:
  //         s.state.in_.value = curr_state - 1

  // logic for state_transitions()
  always @ (*) begin
    curr_state__0 = state$out;
    state$in_ = state$out;
    if ((curr_state__0 == STATE_IDLE)) begin
      if (req_val) begin
        state$in_ = STATE_WAIT;
      end
      else begin
      end
    end
    else begin
      if ((curr_state__0 == STATE_WAIT)) begin
        state$in_ = STATE_CALC;
      end
      else begin
        if ((curr_state__0 == STATE_DONE)) begin
          if (resp_rdy) begin
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
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def state_outputs():
  //
  //       curr_state = s.state.out
  //
  //       s.req_rdy.value  = 0
  //       s.resp_val.value = 0
  //
  //       s.buffers_en.value   = 0
  //       s.is_div.value       = 0
  //       s.is_signed.value    = 0
  //       s.input_reg_en.value = 0
  //
  //       if   curr_state == s.STATE_IDLE:
  //         s.req_rdy.value = 1
  //
  //         s.remainder_mux_sel.value = R_MUX_SEL_IN
  //         s.remainder_reg_en.value  = 0
  //
  //         s.quotient_mux_sel.value  = Q_MUX_SEL_0
  //         s.quotient_reg_en.value   = 0
  //
  //         s.divisor_mux_sel.value   = D_MUX_SEL_IN
  //
  //         s.input_reg_en.value = 1
  //
  //       elif   curr_state == s.STATE_WAIT:
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
  //         s.resp_val.value    = 1
  //
  //         s.remainder_mux_sel.value = R_MUX_SEL_IN
  //         s.remainder_reg_en.value  = 0
  //
  //         s.quotient_mux_sel.value  = Q_MUX_SEL_0
  //         s.quotient_reg_en.value   = 0
  //
  //         s.divisor_mux_sel.value   = D_MUX_SEL_IN
  //
  //       else: # calculating
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
    req_rdy = 0;
    resp_val = 0;
    buffers_en = 0;
    is_div = 0;
    is_signed = 0;
    input_reg_en = 0;
    if ((curr_state__1 == STATE_IDLE)) begin
      req_rdy = 1;
      remainder_mux_sel = R_MUX_SEL_IN;
      remainder_reg_en = 0;
      quotient_mux_sel = Q_MUX_SEL_0;
      quotient_reg_en = 0;
      divisor_mux_sel = D_MUX_SEL_IN;
      input_reg_en = 1;
    end
    else begin
      if ((curr_state__1 == STATE_WAIT)) begin
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
          resp_val = 1;
          remainder_mux_sel = R_MUX_SEL_IN;
          remainder_reg_en = 0;
          quotient_mux_sel = Q_MUX_SEL_0;
          quotient_reg_en = 0;
          divisor_mux_sel = D_MUX_SEL_IN;
        end
        else begin
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
  end


endmodule // IntDivRem4RegInCtrl_0x59e69d2f49a6706a
`default_nettype wire

//-----------------------------------------------------------------------------
// IntDivRem4RegInDpath_0x59e69d2f49a6706a
//-----------------------------------------------------------------------------
// nbits: 32
// ntypes: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module IntDivRem4RegInDpath_0x59e69d2f49a6706a
(
  input  wire [   0:0] buffers_en,
  input  wire [   0:0] clk,
  input  wire [   0:0] divisor_mux_sel,
  input  wire [   0:0] input_reg_en,
  input  wire [   0:0] is_div,
  input  wire [   0:0] is_signed,
  input  wire [   0:0] quotient_mux_sel,
  input  wire [   0:0] quotient_reg_en,
  input  wire [   1:0] remainder_mux_sel,
  input  wire [   0:0] remainder_reg_en,
  input  wire [  69:0] req_msg,
  output wire [   2:0] req_type,
  input  wire [   0:0] reset,
  output wire [  34:0] resp_msg,
  output wire [   0:0] sub_negative1,
  output wire [   0:0] sub_negative2
);

  // wire declarations
  wire   [  31:0] req_msg_b;
  wire   [  31:0] req_msg_a;
  wire   [   2:0] req_msg_opaque;


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

  // input_reg temporaries
  wire   [   0:0] input_reg$reset;
  wire   [  69:0] input_reg$in_;
  wire   [   0:0] input_reg$clk;
  wire   [   0:0] input_reg$en;
  wire   [  69:0] input_reg$out;

  RegEn_0x33e44399f27afd57 input_reg
  (
    .reset ( input_reg$reset ),
    .in_   ( input_reg$in_ ),
    .clk   ( input_reg$clk ),
    .en    ( input_reg$en ),
    .out   ( input_reg$out )
  );

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
  assign input_reg$clk                = clk;
  assign input_reg$en                 = input_reg_en;
  assign input_reg$in_                = req_msg;
  assign input_reg$reset              = reset;
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
  assign req_msg_a                    = input_reg$out[63:32];
  assign req_msg_b                    = input_reg$out[31:0];
  assign req_msg_opaque               = input_reg$out[66:64];
  assign req_type                     = input_reg$out[69:67];
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
  assign resp_msg[31:0]               = res_divrem_mux$out;
  assign resp_msg[34:32]              = opaque_reg$out;
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


endmodule // IntDivRem4RegInDpath_0x59e69d2f49a6706a
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
// ProcPRTL_0x1202655511af6cc5
//-----------------------------------------------------------------------------
// num_cores: 4
// reset_freeze: True
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcPRTL_0x1202655511af6cc5
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
  input  wire [   0:0] go,
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


  // mdureq_queue temporaries
  wire   [   0:0] mdureq_queue$clk;
  wire   [  69:0] mdureq_queue$enq_msg;
  wire   [   0:0] mdureq_queue$enq_val;
  wire   [   0:0] mdureq_queue$reset;
  wire   [   0:0] mdureq_queue$deq_rdy;
  wire   [   0:0] mdureq_queue$enq_rdy;
  wire   [   0:0] mdureq_queue$full;
  wire   [  69:0] mdureq_queue$deq_msg;
  wire   [   0:0] mdureq_queue$deq_val;

  SingleElementBypassQueue_0x4aaa519439aa3cbc mdureq_queue
  (
    .clk     ( mdureq_queue$clk ),
    .enq_msg ( mdureq_queue$enq_msg ),
    .enq_val ( mdureq_queue$enq_val ),
    .reset   ( mdureq_queue$reset ),
    .deq_rdy ( mdureq_queue$deq_rdy ),
    .enq_rdy ( mdureq_queue$enq_rdy ),
    .full    ( mdureq_queue$full ),
    .deq_msg ( mdureq_queue$deq_msg ),
    .deq_val ( mdureq_queue$deq_val )
  );

  // ctrl temporaries
  wire   [   0:0] ctrl$go;
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

  ProcCtrlPRTL_0x202e2b8309fdc725 ctrl
  (
    .go               ( ctrl$go ),
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

  ProcDpathPRTL_0x6258b32b7d2224ce dpath
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
  assign ctrl$go                      = go;
  assign ctrl$go                      = go;
  assign ctrl$imemreq_rdy             = imemreq_queue$enq_rdy;
  assign ctrl$imemresp_val            = imemresp_drop_unit$out_val;
  assign ctrl$inst_D                  = dpath$inst_D;
  assign ctrl$mdureq_rdy              = mdureq_queue$enq_rdy;
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
  assign dmemreq_queue$enq_msg[73:66] = 8'd0;
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
  assign mdureq_msg                   = mdureq_queue$deq_msg;
  assign mdureq_queue$clk             = clk;
  assign mdureq_queue$deq_rdy         = mdureq_rdy;
  assign mdureq_queue$enq_msg[31:0]   = dpath$mdureq_msg_op_b;
  assign mdureq_queue$enq_msg[63:32]  = dpath$mdureq_msg_op_a;
  assign mdureq_queue$enq_msg[69:67]  = ctrl$mdureq_msg_type;
  assign mdureq_queue$enq_val         = ctrl$mdureq_val;
  assign mdureq_queue$reset           = reset;
  assign mdureq_val                   = mdureq_queue$deq_val;
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



endmodule // ProcPRTL_0x1202655511af6cc5
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x4aaa519439aa3cbc
//-----------------------------------------------------------------------------
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x4aaa519439aa3cbc
(
  input  wire [   0:0] clk,
  output wire [  69:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  69:0] enq_msg,
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
  wire   [  69:0] dpath$enq_bits;
  wire   [  69:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x4aaa519439aa3cbc dpath
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



endmodule // SingleElementBypassQueue_0x4aaa519439aa3cbc
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x4aaa519439aa3cbc
//-----------------------------------------------------------------------------
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x4aaa519439aa3cbc
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [  69:0] deq_bits,
  input  wire [  69:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [  69:0] bypass_mux$in_$000;
  wire   [  69:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [  69:0] bypass_mux$out;

  Mux_0x24c8697bb85c081c bypass_mux
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
  wire   [  69:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  69:0] queue$out;

  RegEn_0x33e44399f27afd57 queue
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



endmodule // SingleElementBypassQueueDpath_0x4aaa519439aa3cbc
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x24c8697bb85c081c
//-----------------------------------------------------------------------------
// dtype: 70
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x24c8697bb85c081c
(
  input  wire [   0:0] clk,
  input  wire [  69:0] in_$000,
  input  wire [  69:0] in_$001,
  output reg  [  69:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [  69:0] in_[0:1];
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


endmodule // Mux_0x24c8697bb85c081c
`default_nettype wire

//-----------------------------------------------------------------------------
// ProcCtrlPRTL_0x202e2b8309fdc725
//-----------------------------------------------------------------------------
// reset_freeze: True
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcCtrlPRTL_0x202e2b8309fdc725
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
  input  wire [   0:0] go,
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
  reg    [   7:0] inst__10;
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
  reg    [   0:0] pre_stall_F;
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
  // def comb_freeze_F():
  //           s.stall_F.value = s.pre_stall_F | ~s.go

  // logic for comb_freeze_F()
  always @ (*) begin
    stall_F = (pre_stall_F|~go);
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
  //       s.pre_stall_F.value   = s.val_F & ( s.ostall_F  | s.ostall_D |
  //                                           s.ostall_X  | s.ostall_M |
  //                                           s.ostall_W                 )
  //
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
    pre_stall_F = (val_F&((((ostall_F|ostall_D)|ostall_X)|ostall_M)|ostall_W));
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
  //       else:                 s.cs.value = concat( n, br_x,  n, am_x,  n, imm_x, bm_x,   n, alu_x,   mem_nr,  mlen_x, xm_x, dm_x,  wm_x, n,  md_x,    n, n )
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
    inst__10 = inst_type_decoder_D$out;
    if ((inst__10 == NOP)) begin
      cs = { y,br_na,n,am_x,n,imm_x,bm_x,n,alu_x,mem_nr,mlen_x,xm_x,dm_x,wm_a,n,md_x,n,n };
    end
    else begin
      if ((inst__10 == CSRRX)) begin
        cs = { y,br_na,n,am_x,n,imm_i,bm_imm,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_c,y,md_x,y,n };
      end
      else begin
        if ((inst__10 == CSRR)) begin
          cs = { y,br_na,n,am_x,n,imm_i,bm_csr,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,y,n };
        end
        else begin
          if ((inst__10 == CSRW)) begin
            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_cp0,mem_nr,mlen_x,xm_a,dm_x,wm_a,n,md_x,n,y };
          end
          else begin
            if ((inst__10 == ADD)) begin
              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
            end
            else begin
              if ((inst__10 == SUB)) begin
                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sub,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
              end
              else begin
                if ((inst__10 == AND)) begin
                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_and,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                end
                else begin
                  if ((inst__10 == OR)) begin
                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_or,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                  end
                  else begin
                    if ((inst__10 == XOR)) begin
                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_xor,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                    end
                    else begin
                      if ((inst__10 == SLT)) begin
                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                      end
                      else begin
                        if ((inst__10 == SLTU)) begin
                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                        end
                        else begin
                          if ((inst__10 == SRA)) begin
                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sra,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                          end
                          else begin
                            if ((inst__10 == SRL)) begin
                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_srl,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                            end
                            else begin
                              if ((inst__10 == SLL)) begin
                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_sll,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                              end
                              else begin
                                if ((inst__10 == ADDI)) begin
                                  cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                end
                                else begin
                                  if ((inst__10 == ANDI)) begin
                                    cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_and,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                  end
                                  else begin
                                    if ((inst__10 == ORI)) begin
                                      cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_or,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                    end
                                    else begin
                                      if ((inst__10 == XORI)) begin
                                        cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_xor,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                      end
                                      else begin
                                        if ((inst__10 == SLTI)) begin
                                          cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                        end
                                        else begin
                                          if ((inst__10 == SLTIU)) begin
                                            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                          end
                                          else begin
                                            if ((inst__10 == SRAI)) begin
                                              cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_sra,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                            end
                                            else begin
                                              if ((inst__10 == SRLI)) begin
                                                cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_srl,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                              end
                                              else begin
                                                if ((inst__10 == SLLI)) begin
                                                  cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_sll,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                end
                                                else begin
                                                  if ((inst__10 == LUI)) begin
                                                    cs = { y,br_na,n,am_x,n,imm_u,bm_imm,n,alu_cp1,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                  end
                                                  else begin
                                                    if ((inst__10 == AUIPC)) begin
                                                      cs = { y,br_na,n,am_pc,n,imm_u,bm_imm,n,alu_add,mem_nr,mlen_x,xm_a,dm_x,wm_a,y,md_x,n,n };
                                                    end
                                                    else begin
                                                      if ((inst__10 == BNE)) begin
                                                        cs = { y,br_ne,n,am_rf,y,imm_b,bm_rf,y,alu_x,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                      end
                                                      else begin
                                                        if ((inst__10 == BEQ)) begin
                                                          cs = { y,br_eq,n,am_rf,y,imm_b,bm_rf,y,alu_x,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                        end
                                                        else begin
                                                          if ((inst__10 == BLT)) begin
                                                            cs = { y,br_lt,n,am_rf,y,imm_b,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                          end
                                                          else begin
                                                            if ((inst__10 == BLTU)) begin
                                                              cs = { y,br_lu,n,am_rf,y,imm_b,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                            end
                                                            else begin
                                                              if ((inst__10 == BGE)) begin
                                                                cs = { y,br_ge,n,am_rf,y,imm_b,bm_rf,y,alu_lt,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                              end
                                                              else begin
                                                                if ((inst__10 == BGEU)) begin
                                                                  cs = { y,br_gu,n,am_rf,y,imm_b,bm_rf,y,alu_ltu,mem_nr,mlen_x,xm_a,dm_x,wm_x,n,md_x,n,n };
                                                                end
                                                                else begin
                                                                  if ((inst__10 == JAL)) begin
                                                                    cs = { y,br_na,y,am_x,n,imm_j,bm_x,n,alu_x,mem_nr,mlen_x,xm_p,dm_x,wm_a,y,md_x,n,n };
                                                                  end
                                                                  else begin
                                                                    if ((inst__10 == JALR)) begin
                                                                      cs = { y,jalr,n,am_rf,y,imm_i,bm_imm,n,alu_adz,mem_nr,mlen_x,xm_p,dm_x,wm_a,y,md_x,n,n };
                                                                    end
                                                                    else begin
                                                                      if ((inst__10 == LB)) begin
                                                                        cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_b,xm_a,dm_b,wm_m,y,md_x,n,n };
                                                                      end
                                                                      else begin
                                                                        if ((inst__10 == LH)) begin
                                                                          cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_h,xm_a,dm_h,wm_m,y,md_x,n,n };
                                                                        end
                                                                        else begin
                                                                          if ((inst__10 == LW)) begin
                                                                            cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                          end
                                                                          else begin
                                                                            if ((inst__10 == LBU)) begin
                                                                              cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_b,xm_a,dm_bu,wm_m,y,md_x,n,n };
                                                                            end
                                                                            else begin
                                                                              if ((inst__10 == LHU)) begin
                                                                                cs = { y,br_na,n,am_rf,y,imm_i,bm_imm,n,alu_add,mem_ld,mlen_h,xm_a,dm_hu,wm_m,y,md_x,n,n };
                                                                              end
                                                                              else begin
                                                                                if ((inst__10 == SB)) begin
                                                                                  cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_b,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                end
                                                                                else begin
                                                                                  if ((inst__10 == SH)) begin
                                                                                    cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_h,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                  end
                                                                                  else begin
                                                                                    if ((inst__10 == SW)) begin
                                                                                      cs = { y,br_na,n,am_rf,y,imm_s,bm_imm,y,alu_add,mem_st,mlen_w,xm_a,dm_x,wm_m,n,md_x,n,n };
                                                                                    end
                                                                                    else begin
                                                                                      if ((inst__10 == AMOADD)) begin
                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_ad,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                      end
                                                                                      else begin
                                                                                        if ((inst__10 == AMOAND)) begin
                                                                                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_an,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                        end
                                                                                        else begin
                                                                                          if ((inst__10 == AMOOR)) begin
                                                                                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_or,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                          end
                                                                                          else begin
                                                                                            if ((inst__10 == AMOSWAP)) begin
                                                                                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_sp,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                            end
                                                                                            else begin
                                                                                              if ((inst__10 == AMOMIN)) begin
                                                                                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mn,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                              end
                                                                                              else begin
                                                                                                if ((inst__10 == AMOMINU)) begin
                                                                                                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mnu,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                end
                                                                                                else begin
                                                                                                  if ((inst__10 == AMOMAX)) begin
                                                                                                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mx,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                  end
                                                                                                  else begin
                                                                                                    if ((inst__10 == AMOMAXU)) begin
                                                                                                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_mxu,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                    end
                                                                                                    else begin
                                                                                                      if ((inst__10 == AMOXOR)) begin
                                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_cp0,mem_xr,mlen_w,xm_a,dm_w,wm_m,y,md_x,n,n };
                                                                                                      end
                                                                                                      else begin
                                                                                                        if ((inst__10 == MUL)) begin
                                                                                                          cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mul,n,n };
                                                                                                        end
                                                                                                        else begin
                                                                                                          if ((inst__10 == MULH)) begin
                                                                                                            cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mh,n,n };
                                                                                                          end
                                                                                                          else begin
                                                                                                            if ((inst__10 == MULHSU)) begin
                                                                                                              cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mhsu,n,n };
                                                                                                            end
                                                                                                            else begin
                                                                                                              if ((inst__10 == MULHU)) begin
                                                                                                                cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_mhu,n,n };
                                                                                                              end
                                                                                                              else begin
                                                                                                                if ((inst__10 == DIV)) begin
                                                                                                                  cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_div,n,n };
                                                                                                                end
                                                                                                                else begin
                                                                                                                  if ((inst__10 == DIVU)) begin
                                                                                                                    cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_divu,n,n };
                                                                                                                  end
                                                                                                                  else begin
                                                                                                                    if ((inst__10 == REM)) begin
                                                                                                                      cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_rem,n,n };
                                                                                                                    end
                                                                                                                    else begin
                                                                                                                      if ((inst__10 == REMU)) begin
                                                                                                                        cs = { y,br_na,n,am_rf,y,imm_x,bm_rf,y,alu_x,mem_nr,mlen_x,xm_m,dm_x,wm_a,y,md_remu,n,n };
                                                                                                                      end
                                                                                                                      else begin
                                                                                                                        cs = { n,br_x,n,am_x,n,imm_x,bm_x,n,alu_x,mem_nr,mlen_x,xm_x,dm_x,wm_x,n,md_x,n,n };
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


endmodule // ProcCtrlPRTL_0x202e2b8309fdc725
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
// ProcDpathPRTL_0x6258b32b7d2224ce
//-----------------------------------------------------------------------------
// num_cores: 4
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ProcDpathPRTL_0x6258b32b7d2224ce
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

  // localparam declarations
  localparam TYPE_READ = 0;

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
  assign csrr_sel_mux_D$in_$001      = 32'd4;
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
  assign pc_plus_imm_D$cin           = 1'd0;
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
  //       s.imemreq_msg.type_.value  = MemReqMsg4B.TYPE_READ
  //       s.imemreq_msg.len.value    = 0
  //       s.imemreq_msg.addr.value   = s.pc_sel_mux_F.out
  //       s.imemreq_msg.data.value   = 0
  //       s.imemreq_msg.opaque.value = 0

  // logic for imem_req_F()
  always @ (*) begin
    imemreq_msg[(78)-1:74] = TYPE_READ;
    imemreq_msg[(34)-1:32] = 0;
    imemreq_msg[(66)-1:34] = pc_sel_mux_F$out;
    imemreq_msg[(32)-1:0] = 0;
    imemreq_msg[(74)-1:66] = 0;
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


endmodule // ProcDpathPRTL_0x6258b32b7d2224ce
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

//-----------------------------------------------------------------------------
// BlockingCachePRTL_0x26ef3bd22367566d
//-----------------------------------------------------------------------------
// num_banks: 0
// wide_access: True
// CacheRespMsgType: 48
// CacheReqMsgType: 78
// MemRespMsgType: 146
// MemReqMsgType: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCachePRTL_0x26ef3bd22367566d
(
  input  wire [ 175:0] cachereq_msg,
  output wire [   0:0] cachereq_rdy,
  input  wire [   0:0] cachereq_val,
  output wire [ 145:0] cacheresp_msg,
  input  wire [   0:0] cacheresp_rdy,
  output wire [   0:0] cacheresp_val,
  input  wire [   0:0] clk,
  output wire [ 175:0] memreq_msg,
  input  wire [   0:0] memreq_rdy,
  output wire [   0:0] memreq_val,
  input  wire [ 145:0] memresp_msg,
  output wire [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$tag_match_0;
  wire   [   0:0] ctrl$tag_match_1;
  wire   [  31:0] ctrl$read_data_word;
  wire   [   0:0] ctrl$cacheresp_rdy;
  wire   [   3:0] ctrl$cachereq_type;
  wire   [   0:0] ctrl$memresp_val;
  wire   [   0:0] ctrl$reset;
  wire   [  31:0] ctrl$cachereq_data_word;
  wire   [   3:0] ctrl$cachereq_len_reg_out;
  wire   [  31:0] ctrl$cachereq_addr;
  wire   [   0:0] ctrl$memreq_rdy;
  wire   [   0:0] ctrl$cachereq_val;
  wire   [ 127:0] ctrl$cachereq_data_reg_out;
  wire   [   0:0] ctrl$data_array_wen;
  wire   [   0:0] ctrl$skip_read_data_reg;
  wire   [   0:0] ctrl$memresp_en;
  wire   [   0:0] ctrl$tag_array_0_ren;
  wire   [   0:0] ctrl$way_sel_current;
  wire   [   0:0] ctrl$amo_maxu_sel;
  wire   [   0:0] ctrl$cachereq_rdy;
  wire   [   0:0] ctrl$amo_min_sel;
  wire   [   0:0] ctrl$read_tag_reg_en;
  wire   [   0:0] ctrl$is_amo;
  wire   [   3:0] ctrl$memreq_type;
  wire   [   1:0] ctrl$byte_offset;
  wire   [   0:0] ctrl$data_array_ren;
  wire   [   0:0] ctrl$cacheresp_val;
  wire   [   0:0] ctrl$amo_max_sel;
  wire   [  15:0] ctrl$data_array_wben;
  wire   [   0:0] ctrl$read_data_reg_en;
  wire   [   0:0] ctrl$tag_array_1_ren;
  wire   [   0:0] ctrl$tag_array_1_wen;
  wire   [   0:0] ctrl$memreq_val;
  wire   [   0:0] ctrl$memresp_rdy;
  wire   [   0:0] ctrl$way_sel;
  wire   [   3:0] ctrl$cacheresp_type;
  wire   [   0:0] ctrl$cachereq_en;
  wire   [   0:0] ctrl$amo_minu_sel;
  wire   [   0:0] ctrl$cacheresp_hit;
  wire   [   0:0] ctrl$is_refill;
  wire   [   3:0] ctrl$amo_sel;
  wire   [   0:0] ctrl$tag_array_0_wen;

  BlockingCacheCtrlPRTL_0x2673bbb0e0f7d38 ctrl
  (
    .clk                   ( ctrl$clk ),
    .tag_match_0           ( ctrl$tag_match_0 ),
    .tag_match_1           ( ctrl$tag_match_1 ),
    .read_data_word        ( ctrl$read_data_word ),
    .cacheresp_rdy         ( ctrl$cacheresp_rdy ),
    .cachereq_type         ( ctrl$cachereq_type ),
    .memresp_val           ( ctrl$memresp_val ),
    .reset                 ( ctrl$reset ),
    .cachereq_data_word    ( ctrl$cachereq_data_word ),
    .cachereq_len_reg_out  ( ctrl$cachereq_len_reg_out ),
    .cachereq_addr         ( ctrl$cachereq_addr ),
    .memreq_rdy            ( ctrl$memreq_rdy ),
    .cachereq_val          ( ctrl$cachereq_val ),
    .cachereq_data_reg_out ( ctrl$cachereq_data_reg_out ),
    .data_array_wen        ( ctrl$data_array_wen ),
    .skip_read_data_reg    ( ctrl$skip_read_data_reg ),
    .memresp_en            ( ctrl$memresp_en ),
    .tag_array_0_ren       ( ctrl$tag_array_0_ren ),
    .way_sel_current       ( ctrl$way_sel_current ),
    .amo_maxu_sel          ( ctrl$amo_maxu_sel ),
    .cachereq_rdy          ( ctrl$cachereq_rdy ),
    .amo_min_sel           ( ctrl$amo_min_sel ),
    .read_tag_reg_en       ( ctrl$read_tag_reg_en ),
    .is_amo                ( ctrl$is_amo ),
    .memreq_type           ( ctrl$memreq_type ),
    .byte_offset           ( ctrl$byte_offset ),
    .data_array_ren        ( ctrl$data_array_ren ),
    .cacheresp_val         ( ctrl$cacheresp_val ),
    .amo_max_sel           ( ctrl$amo_max_sel ),
    .data_array_wben       ( ctrl$data_array_wben ),
    .read_data_reg_en      ( ctrl$read_data_reg_en ),
    .tag_array_1_ren       ( ctrl$tag_array_1_ren ),
    .tag_array_1_wen       ( ctrl$tag_array_1_wen ),
    .memreq_val            ( ctrl$memreq_val ),
    .memresp_rdy           ( ctrl$memresp_rdy ),
    .way_sel               ( ctrl$way_sel ),
    .cacheresp_type        ( ctrl$cacheresp_type ),
    .cachereq_en           ( ctrl$cachereq_en ),
    .amo_minu_sel          ( ctrl$amo_minu_sel ),
    .cacheresp_hit         ( ctrl$cacheresp_hit ),
    .is_refill             ( ctrl$is_refill ),
    .amo_sel               ( ctrl$amo_sel ),
    .tag_array_0_wen       ( ctrl$tag_array_0_wen )
  );

  // resp_bypass temporaries
  wire   [   0:0] resp_bypass$clk;
  wire   [ 145:0] resp_bypass$enq_msg;
  wire   [   0:0] resp_bypass$enq_val;
  wire   [   0:0] resp_bypass$reset;
  wire   [   0:0] resp_bypass$deq_rdy;
  wire   [   0:0] resp_bypass$enq_rdy;
  wire   [   0:0] resp_bypass$full;
  wire   [ 145:0] resp_bypass$deq_msg;
  wire   [   0:0] resp_bypass$deq_val;

  SingleElementBypassQueue_0x5a7f0a6588025dd8 resp_bypass
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
  wire   [   0:0] dpath$data_array_wen;
  wire   [   0:0] dpath$memresp_en;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$skip_read_data_reg;
  wire   [   0:0] dpath$tag_array_0_ren;
  wire   [ 175:0] dpath$cachereq_msg;
  wire   [   0:0] dpath$way_sel_current;
  wire   [   0:0] dpath$amo_maxu_sel;
  wire   [   0:0] dpath$amo_min_sel;
  wire   [   0:0] dpath$read_tag_reg_en;
  wire   [   0:0] dpath$is_amo;
  wire   [   3:0] dpath$memreq_type;
  wire   [   1:0] dpath$byte_offset;
  wire   [   0:0] dpath$data_array_ren;
  wire   [ 145:0] dpath$memresp_msg;
  wire   [   0:0] dpath$amo_max_sel;
  wire   [  15:0] dpath$data_array_wben;
  wire   [   0:0] dpath$read_data_reg_en;
  wire   [   0:0] dpath$tag_array_1_ren;
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$tag_array_1_wen;
  wire   [   0:0] dpath$way_sel;
  wire   [   3:0] dpath$cacheresp_type;
  wire   [   0:0] dpath$cachereq_en;
  wire   [   0:0] dpath$amo_minu_sel;
  wire   [   0:0] dpath$is_refill;
  wire   [   3:0] dpath$amo_sel;
  wire   [   0:0] dpath$cacheresp_hit;
  wire   [   0:0] dpath$tag_array_0_wen;
  wire   [   0:0] dpath$tag_match_0;
  wire   [   0:0] dpath$tag_match_1;
  wire   [  31:0] dpath$read_data_word;
  wire   [   3:0] dpath$cachereq_type;
  wire   [ 175:0] dpath$memreq_msg;
  wire   [  31:0] dpath$cachereq_data_word;
  wire   [ 127:0] dpath$cachereq_data_reg_out;
  wire   [   3:0] dpath$cachereq_len_reg_out;
  wire   [  31:0] dpath$cachereq_addr;
  wire   [ 145:0] dpath$cacheresp_msg;

  BlockingCacheDpathPRTL_0x6b511b3b41602acf dpath
  (
    .data_array_wen        ( dpath$data_array_wen ),
    .memresp_en            ( dpath$memresp_en ),
    .clk                   ( dpath$clk ),
    .skip_read_data_reg    ( dpath$skip_read_data_reg ),
    .tag_array_0_ren       ( dpath$tag_array_0_ren ),
    .cachereq_msg          ( dpath$cachereq_msg ),
    .way_sel_current       ( dpath$way_sel_current ),
    .amo_maxu_sel          ( dpath$amo_maxu_sel ),
    .amo_min_sel           ( dpath$amo_min_sel ),
    .read_tag_reg_en       ( dpath$read_tag_reg_en ),
    .is_amo                ( dpath$is_amo ),
    .memreq_type           ( dpath$memreq_type ),
    .byte_offset           ( dpath$byte_offset ),
    .data_array_ren        ( dpath$data_array_ren ),
    .memresp_msg           ( dpath$memresp_msg ),
    .amo_max_sel           ( dpath$amo_max_sel ),
    .data_array_wben       ( dpath$data_array_wben ),
    .read_data_reg_en      ( dpath$read_data_reg_en ),
    .tag_array_1_ren       ( dpath$tag_array_1_ren ),
    .reset                 ( dpath$reset ),
    .tag_array_1_wen       ( dpath$tag_array_1_wen ),
    .way_sel               ( dpath$way_sel ),
    .cacheresp_type        ( dpath$cacheresp_type ),
    .cachereq_en           ( dpath$cachereq_en ),
    .amo_minu_sel          ( dpath$amo_minu_sel ),
    .is_refill             ( dpath$is_refill ),
    .amo_sel               ( dpath$amo_sel ),
    .cacheresp_hit         ( dpath$cacheresp_hit ),
    .tag_array_0_wen       ( dpath$tag_array_0_wen ),
    .tag_match_0           ( dpath$tag_match_0 ),
    .tag_match_1           ( dpath$tag_match_1 ),
    .read_data_word        ( dpath$read_data_word ),
    .cachereq_type         ( dpath$cachereq_type ),
    .memreq_msg            ( dpath$memreq_msg ),
    .cachereq_data_word    ( dpath$cachereq_data_word ),
    .cachereq_data_reg_out ( dpath$cachereq_data_reg_out ),
    .cachereq_len_reg_out  ( dpath$cachereq_len_reg_out ),
    .cachereq_addr         ( dpath$cachereq_addr ),
    .cacheresp_msg         ( dpath$cacheresp_msg )
  );

  // signal connections
  assign cachereq_rdy               = ctrl$cachereq_rdy;
  assign cacheresp_msg              = resp_bypass$deq_msg;
  assign cacheresp_val              = resp_bypass$deq_val;
  assign ctrl$cachereq_addr         = dpath$cachereq_addr;
  assign ctrl$cachereq_data_reg_out = dpath$cachereq_data_reg_out;
  assign ctrl$cachereq_data_word    = dpath$cachereq_data_word;
  assign ctrl$cachereq_len_reg_out  = dpath$cachereq_len_reg_out;
  assign ctrl$cachereq_type         = dpath$cachereq_type;
  assign ctrl$cachereq_val          = cachereq_val;
  assign ctrl$cacheresp_rdy         = resp_bypass$enq_rdy;
  assign ctrl$clk                   = clk;
  assign ctrl$memreq_rdy            = memreq_rdy;
  assign ctrl$memresp_val           = memresp_val;
  assign ctrl$read_data_word        = dpath$read_data_word;
  assign ctrl$reset                 = reset;
  assign ctrl$tag_match_0           = dpath$tag_match_0;
  assign ctrl$tag_match_1           = dpath$tag_match_1;
  assign dpath$amo_max_sel          = ctrl$amo_max_sel;
  assign dpath$amo_maxu_sel         = ctrl$amo_maxu_sel;
  assign dpath$amo_min_sel          = ctrl$amo_min_sel;
  assign dpath$amo_minu_sel         = ctrl$amo_minu_sel;
  assign dpath$amo_sel              = ctrl$amo_sel;
  assign dpath$byte_offset          = ctrl$byte_offset;
  assign dpath$cachereq_en          = ctrl$cachereq_en;
  assign dpath$cachereq_msg         = cachereq_msg;
  assign dpath$cacheresp_hit        = ctrl$cacheresp_hit;
  assign dpath$cacheresp_type       = ctrl$cacheresp_type;
  assign dpath$clk                  = clk;
  assign dpath$data_array_ren       = ctrl$data_array_ren;
  assign dpath$data_array_wben      = ctrl$data_array_wben;
  assign dpath$data_array_wen       = ctrl$data_array_wen;
  assign dpath$is_amo               = ctrl$is_amo;
  assign dpath$is_refill            = ctrl$is_refill;
  assign dpath$memreq_type          = ctrl$memreq_type;
  assign dpath$memresp_en           = ctrl$memresp_en;
  assign dpath$memresp_msg          = memresp_msg;
  assign dpath$read_data_reg_en     = ctrl$read_data_reg_en;
  assign dpath$read_tag_reg_en      = ctrl$read_tag_reg_en;
  assign dpath$reset                = reset;
  assign dpath$skip_read_data_reg   = ctrl$skip_read_data_reg;
  assign dpath$tag_array_0_ren      = ctrl$tag_array_0_ren;
  assign dpath$tag_array_0_wen      = ctrl$tag_array_0_wen;
  assign dpath$tag_array_1_ren      = ctrl$tag_array_1_ren;
  assign dpath$tag_array_1_wen      = ctrl$tag_array_1_wen;
  assign dpath$way_sel              = ctrl$way_sel;
  assign dpath$way_sel_current      = ctrl$way_sel_current;
  assign memreq_msg                 = dpath$memreq_msg;
  assign memreq_val                 = ctrl$memreq_val;
  assign memresp_rdy                = ctrl$memresp_rdy;
  assign resp_bypass$clk            = clk;
  assign resp_bypass$deq_rdy        = cacheresp_rdy;
  assign resp_bypass$enq_msg        = dpath$cacheresp_msg;
  assign resp_bypass$enq_val        = ctrl$cacheresp_val;
  assign resp_bypass$reset          = reset;



endmodule // BlockingCachePRTL_0x26ef3bd22367566d
`default_nettype wire

//-----------------------------------------------------------------------------
// BlockingCacheCtrlPRTL_0x2673bbb0e0f7d38
//-----------------------------------------------------------------------------
// idx_shamt: 0
// MemReqMsgType: 176
// MemRespMsgType: 146
// CacheReqMsgType: 176
// CacheRespMsgType: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCacheCtrlPRTL_0x2673bbb0e0f7d38
(
  output reg  [   0:0] amo_max_sel,
  output reg  [   0:0] amo_maxu_sel,
  output reg  [   0:0] amo_min_sel,
  output reg  [   0:0] amo_minu_sel,
  output reg  [   3:0] amo_sel,
  output wire [   1:0] byte_offset,
  input  wire [  31:0] cachereq_addr,
  input  wire [ 127:0] cachereq_data_reg_out,
  input  wire [  31:0] cachereq_data_word,
  output reg  [   0:0] cachereq_en,
  input  wire [   3:0] cachereq_len_reg_out,
  output reg  [   0:0] cachereq_rdy,
  input  wire [   3:0] cachereq_type,
  input  wire [   0:0] cachereq_val,
  output reg  [   0:0] cacheresp_hit,
  input  wire [   0:0] cacheresp_rdy,
  output reg  [   3:0] cacheresp_type,
  output reg  [   0:0] cacheresp_val,
  input  wire [   0:0] clk,
  output reg  [   0:0] data_array_ren,
  output reg  [  15:0] data_array_wben,
  output reg  [   0:0] data_array_wen,
  output reg  [   0:0] is_amo,
  output reg  [   0:0] is_refill,
  input  wire [   0:0] memreq_rdy,
  output reg  [   3:0] memreq_type,
  output reg  [   0:0] memreq_val,
  output reg  [   0:0] memresp_en,
  output reg  [   0:0] memresp_rdy,
  input  wire [   0:0] memresp_val,
  output reg  [   0:0] read_data_reg_en,
  input  wire [  31:0] read_data_word,
  output reg  [   0:0] read_tag_reg_en,
  input  wire [   0:0] reset,
  output reg  [   0:0] skip_read_data_reg,
  output reg  [   0:0] tag_array_0_ren,
  output reg  [   0:0] tag_array_0_wen,
  output reg  [   0:0] tag_array_1_ren,
  output reg  [   0:0] tag_array_1_wen,
  input  wire [   0:0] tag_match_0,
  input  wire [   0:0] tag_match_1,
  output wire [   0:0] way_sel,
  output reg  [   0:0] way_sel_current
);

  // wire declarations
  wire   [   0:0] raw_dirty_bit_1;
  wire   [   0:0] raw_dirty_bit_0;
  wire   [ 255:0] valid_bits_1_out;
  wire   [   0:0] raw_lru_way;
  wire   [  15:0] wben_decoder_out;
  wire   [ 255:0] valid_bits_0_out;


  // register declarations
  reg    [   0:0] amo_hit;
  reg    [   7:0] cachereq_idx;
  reg    [   3:0] cachereq_offset;
  reg    [   3:0] cachereq_type__5;
  reg    [  20:0] cs;
  reg    [   0:0] dirty_bit_in;
  reg    [   0:0] dirty_bits_write_en;
  reg    [   0:0] dirty_bits_write_en_0;
  reg    [   0:0] dirty_bits_write_en_1;
  reg    [   0:0] evict;
  reg    [   0:0] hit;
  reg    [   0:0] hit_0;
  reg    [   0:0] hit_1;
  reg    [   0:0] in_go;
  reg    [   0:0] is_dirty_0;
  reg    [   0:0] is_dirty_1;
  reg    [   0:0] is_init;
  reg    [   0:0] is_read;
  reg    [   0:0] is_valid_0;
  reg    [   0:0] is_valid_1;
  reg    [   0:0] is_write;
  reg    [   0:0] lru_bit_in;
  reg    [   0:0] lru_bits_write_en;
  reg    [   0:0] lru_way;
  reg    [   0:0] miss_0;
  reg    [   0:0] miss_1;
  reg    [   3:0] ns;
  reg    [   0:0] out_go;
  reg    [   0:0] read_hit;
  reg    [   0:0] refill;
  reg    [   4:0] sn__13;
  reg    [   4:0] sr__12;
  reg    [   4:0] state_next;
  reg    [   4:0] state_reg;
  reg    [   0:0] tag_array_ren;
  reg    [   0:0] tag_array_wen;
  reg    [  32:0] tmp_min;
  reg    [   0:0] valid_bit_in;
  reg    [ 255:0] valid_bits_0_in;
  reg    [ 255:0] valid_bits_1_in;
  reg    [   0:0] valid_bits_write_en;
  reg    [   0:0] valid_bits_write_en_0;
  reg    [   0:0] valid_bits_write_en_1;
  reg    [   0:0] way_record_en;
  reg    [   0:0] way_record_in;
  reg    [   0:0] write_hit;

  // localparam declarations
  localparam STATE_AMO_READ_DATA_ACCESS_HIT = 5'd14;
  localparam STATE_AMO_READ_DATA_ACCESS_MISS = 5'd16;
  localparam STATE_AMO_WRITE_DATA_ACCESS_HIT = 5'd15;
  localparam STATE_AMO_WRITE_DATA_ACCESS_MISS = 5'd17;
  localparam STATE_EVICT_PREPARE = 5'd11;
  localparam STATE_EVICT_REQUEST = 5'd12;
  localparam STATE_EVICT_WAIT = 5'd13;
  localparam STATE_IDLE = 5'd0;
  localparam STATE_INIT_DATA_ACCESS = 5'd18;
  localparam STATE_READ_DATA_ACCESS_MISS = 5'd4;
  localparam STATE_REFILL_REQUEST = 5'd8;
  localparam STATE_REFILL_UPDATE = 5'd10;
  localparam STATE_REFILL_WAIT = 5'd9;
  localparam STATE_TAG_CHECK = 5'd1;
  localparam STATE_WAIT_HIT = 5'd6;
  localparam STATE_WAIT_MISS = 5'd7;
  localparam STATE_WRITE_CACHE_RESP_HIT = 5'd2;
  localparam STATE_WRITE_DATA_ACCESS_HIT = 5'd3;
  localparam STATE_WRITE_DATA_ACCESS_MISS = 5'd5;
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
  localparam TYPE_WRITE_INIT = 2;
  localparam dbw = 32;
  localparam left_idx = 4;
  localparam m_e = 4'd1;
  localparam m_len_bw = 4;
  localparam m_r = 4'd0;
  localparam m_x = 4'd0;
  localparam n = 1'd0;
  localparam r_c = 1'd0;
  localparam r_m = 1'd1;
  localparam r_x = 1'd0;
  localparam right_idx = 12;
  localparam x = 1'd0;
  localparam y = 1'd1;

  // lru_bits temporaries
  wire   [   7:0] lru_bits$rd_addr$000;
  wire   [   0:0] lru_bits$wr_data;
  wire   [   0:0] lru_bits$clk;
  wire   [   7:0] lru_bits$wr_addr;
  wire   [   0:0] lru_bits$wr_en;
  wire   [   0:0] lru_bits$reset;
  wire   [   0:0] lru_bits$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b lru_bits
  (
    .rd_addr$000 ( lru_bits$rd_addr$000 ),
    .wr_data     ( lru_bits$wr_data ),
    .clk         ( lru_bits$clk ),
    .wr_addr     ( lru_bits$wr_addr ),
    .wr_en       ( lru_bits$wr_en ),
    .reset       ( lru_bits$reset ),
    .rd_data$000 ( lru_bits$rd_data$000 )
  );

  // wben_decoder temporaries
  wire   [   0:0] wben_decoder$reset;
  wire   [   3:0] wben_decoder$idx;
  wire   [   0:0] wben_decoder$clk;
  wire   [   3:0] wben_decoder$len;
  wire   [  15:0] wben_decoder$out;

  DecodeWbenPRTL_0x18c15822932d5d24 wben_decoder
  (
    .reset ( wben_decoder$reset ),
    .idx   ( wben_decoder$idx ),
    .clk   ( wben_decoder$clk ),
    .len   ( wben_decoder$len ),
    .out   ( wben_decoder$out )
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

  // dirty_bits_0 temporaries
  wire   [   7:0] dirty_bits_0$rd_addr$000;
  wire   [   0:0] dirty_bits_0$wr_data;
  wire   [   0:0] dirty_bits_0$clk;
  wire   [   7:0] dirty_bits_0$wr_addr;
  wire   [   0:0] dirty_bits_0$wr_en;
  wire   [   0:0] dirty_bits_0$reset;
  wire   [   0:0] dirty_bits_0$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b dirty_bits_0
  (
    .rd_addr$000 ( dirty_bits_0$rd_addr$000 ),
    .wr_data     ( dirty_bits_0$wr_data ),
    .clk         ( dirty_bits_0$clk ),
    .wr_addr     ( dirty_bits_0$wr_addr ),
    .wr_en       ( dirty_bits_0$wr_en ),
    .reset       ( dirty_bits_0$reset ),
    .rd_data$000 ( dirty_bits_0$rd_data$000 )
  );

  // dirty_bits_1 temporaries
  wire   [   7:0] dirty_bits_1$rd_addr$000;
  wire   [   0:0] dirty_bits_1$wr_data;
  wire   [   0:0] dirty_bits_1$clk;
  wire   [   7:0] dirty_bits_1$wr_addr;
  wire   [   0:0] dirty_bits_1$wr_en;
  wire   [   0:0] dirty_bits_1$reset;
  wire   [   0:0] dirty_bits_1$rd_data$000;

  RegisterFile_0x282b3c6d2858fe2b dirty_bits_1
  (
    .rd_addr$000 ( dirty_bits_1$rd_addr$000 ),
    .wr_data     ( dirty_bits_1$wr_data ),
    .clk         ( dirty_bits_1$clk ),
    .wr_addr     ( dirty_bits_1$wr_addr ),
    .wr_en       ( dirty_bits_1$wr_en ),
    .reset       ( dirty_bits_1$reset ),
    .rd_data$000 ( dirty_bits_1$rd_data$000 )
  );

  // valid_bits_0 temporaries
  wire   [   0:0] valid_bits_0$reset;
  wire   [   0:0] valid_bits_0$en;
  wire   [   0:0] valid_bits_0$clk;
  wire   [ 255:0] valid_bits_0$in_;
  wire   [ 255:0] valid_bits_0$out;

  RegEnRst_0x1c65c01affad8788 valid_bits_0
  (
    .reset ( valid_bits_0$reset ),
    .en    ( valid_bits_0$en ),
    .clk   ( valid_bits_0$clk ),
    .in_   ( valid_bits_0$in_ ),
    .out   ( valid_bits_0$out )
  );

  // valid_bits_1 temporaries
  wire   [   0:0] valid_bits_1$reset;
  wire   [   0:0] valid_bits_1$en;
  wire   [   0:0] valid_bits_1$clk;
  wire   [ 255:0] valid_bits_1$in_;
  wire   [ 255:0] valid_bits_1$out;

  RegEnRst_0x1c65c01affad8788 valid_bits_1
  (
    .reset ( valid_bits_1$reset ),
    .en    ( valid_bits_1$en ),
    .clk   ( valid_bits_1$clk ),
    .in_   ( valid_bits_1$in_ ),
    .out   ( valid_bits_1$out )
  );

  // signal connections
  assign dirty_bits_0$clk         = clk;
  assign dirty_bits_0$rd_addr$000 = cachereq_idx;
  assign dirty_bits_0$reset       = reset;
  assign dirty_bits_0$wr_addr     = cachereq_idx;
  assign dirty_bits_0$wr_data     = dirty_bit_in;
  assign dirty_bits_0$wr_en       = dirty_bits_write_en_0;
  assign dirty_bits_1$clk         = clk;
  assign dirty_bits_1$rd_addr$000 = cachereq_idx;
  assign dirty_bits_1$reset       = reset;
  assign dirty_bits_1$wr_addr     = cachereq_idx;
  assign dirty_bits_1$wr_data     = dirty_bit_in;
  assign dirty_bits_1$wr_en       = dirty_bits_write_en_1;
  assign lru_bits$clk             = clk;
  assign lru_bits$rd_addr$000     = cachereq_idx;
  assign lru_bits$reset           = reset;
  assign lru_bits$wr_addr         = cachereq_idx;
  assign lru_bits$wr_data         = lru_bit_in;
  assign lru_bits$wr_en           = lru_bits_write_en;
  assign raw_dirty_bit_0          = dirty_bits_0$rd_data$000;
  assign raw_dirty_bit_1          = dirty_bits_1$rd_data$000;
  assign raw_lru_way              = lru_bits$rd_data$000;
  assign valid_bits_0$clk         = clk;
  assign valid_bits_0$en          = valid_bits_write_en_0;
  assign valid_bits_0$in_         = valid_bits_0_in;
  assign valid_bits_0$reset       = reset;
  assign valid_bits_0_out         = valid_bits_0$out;
  assign valid_bits_1$clk         = clk;
  assign valid_bits_1$en          = valid_bits_write_en_1;
  assign valid_bits_1$in_         = valid_bits_1_in;
  assign valid_bits_1$reset       = reset;
  assign valid_bits_1_out         = valid_bits_1$out;
  assign way_record$clk           = clk;
  assign way_record$en            = way_record_en;
  assign way_record$in_           = way_record_in;
  assign way_record$reset         = reset;
  assign way_sel                  = way_record$out;
  assign wben_decoder$clk         = clk;
  assign wben_decoder$idx         = cachereq_offset;
  assign wben_decoder$len         = cachereq_len_reg_out;
  assign wben_decoder$reset       = reset;
  assign wben_decoder_out         = wben_decoder$out;


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
  // def gen_ctrl_signals():
  //       # Generate dirty bits
  //       s.is_dirty_0.value = s.is_valid_0 & s.raw_dirty_bit_0
  //       s.is_dirty_1.value = s.is_valid_1 & s.raw_dirty_bit_1
  //
  //       # LRU
  //       s.lru_way   .value = ( s.is_valid_0 | s.is_valid_1 ) & \
  //                              s.raw_lru_way

  // logic for gen_ctrl_signals()
  always @ (*) begin
    is_dirty_0 = (is_valid_0&raw_dirty_bit_0);
    is_dirty_1 = (is_valid_1&raw_dirty_bit_1);
    lru_way = ((is_valid_0|is_valid_1)&raw_lru_way);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_state_transition():
  //       s.in_go.value     = s.cachereq_val  & s.cachereq_rdy
  //       s.out_go.value    = s.cacheresp_val & s.cacheresp_rdy
  //       s.hit_0.value     = s.is_valid_0 & s.tag_match_0
  //       s.hit_1.value     = s.is_valid_1 & s.tag_match_1
  //       s.hit.value       = s.hit_0 | s.hit_1
  //       s.is_read.value   = s.cachereq_type == MemReqMsg.TYPE_READ
  //       s.is_write.value  = s.cachereq_type == MemReqMsg.TYPE_WRITE
  //       s.is_init.value   = s.cachereq_type == MemReqMsg.TYPE_WRITE_INIT
  //       s.read_hit.value  = s.is_read & s.hit
  //       s.write_hit.value = s.is_write & s.hit
  //       s.amo_hit.value   = s.is_amo & s.hit
  //       s.miss_0.value    = ~s.hit_0
  //       s.miss_1.value    = ~s.hit_1
  //       s.refill.value    = (s.miss_0 & ~s.is_dirty_0 & ~s.lru_way) | \
  //                           (s.miss_1 & ~s.is_dirty_1 &  s.lru_way)
  //       s.evict.value     = (s.miss_0 &  s.is_dirty_0 & ~s.lru_way) | \
  //                           (s.miss_1 &  s.is_dirty_1 &  s.lru_way)

  // logic for comb_state_transition()
  always @ (*) begin
    in_go = (cachereq_val&cachereq_rdy);
    out_go = (cacheresp_val&cacheresp_rdy);
    hit_0 = (is_valid_0&tag_match_0);
    hit_1 = (is_valid_1&tag_match_1);
    hit = (hit_0|hit_1);
    is_read = (cachereq_type == TYPE_READ);
    is_write = (cachereq_type == TYPE_WRITE);
    is_init = (cachereq_type == TYPE_WRITE_INIT);
    read_hit = (is_read&hit);
    write_hit = (is_write&hit);
    amo_hit = (is_amo&hit);
    miss_0 = ~hit_0;
    miss_1 = ~hit_1;
    refill = (((miss_0&~is_dirty_0)&~lru_way)|((miss_1&~is_dirty_1)&lru_way));
    evict = (((miss_0&is_dirty_0)&~lru_way)|((miss_1&is_dirty_1)&lru_way));
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_min():
  //       s.tmp_min.value = concat( s.cachereq_data_word[dbw-1], s.cachereq_data_word ) \
  //                          - concat( s.read_data_word[dbw-1], s.read_data_word )
  //
  //       s.amo_min_sel.value  = s.tmp_min[dbw]
  //       s.amo_minu_sel.value = s.cachereq_data_word < s.read_data_word

  // logic for comb_amo_min()
  always @ (*) begin
    tmp_min = ({ cachereq_data_word[(dbw-1)],cachereq_data_word }-{ read_data_word[(dbw-1)],read_data_word });
    amo_min_sel = tmp_min[dbw];
    amo_minu_sel = (cachereq_data_word < read_data_word);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_max():
  //       s.amo_max_sel.value  = ~s.amo_min_sel
  //       s.amo_maxu_sel.value = ~s.amo_minu_sel

  // logic for comb_amo_max()
  always @ (*) begin
    amo_max_sel = ~amo_min_sel;
    amo_maxu_sel = ~amo_minu_sel;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_amo_type():
  //       cachereq_type = s.cachereq_type
  //       if   cachereq_type == MemReqMsg.TYPE_AMO_ADD  : s.amo_sel.value =  0; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_AND  : s.amo_sel.value =  1; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_OR   : s.amo_sel.value =  2; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_SWAP : s.amo_sel.value =  3; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MIN  : s.amo_sel.value =  4; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MINU : s.amo_sel.value =  5; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MAX  : s.amo_sel.value =  6; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_MAXU : s.amo_sel.value =  7; s.is_amo.value = 1;
  //       elif cachereq_type == MemReqMsg.TYPE_AMO_XOR  : s.amo_sel.value =  8; s.is_amo.value = 1;
  //       else                                          : s.amo_sel.value =  0; s.is_amo.value = 0;

  // logic for comb_amo_type()
  always @ (*) begin
    cachereq_type__5 = cachereq_type;
    if ((cachereq_type__5 == TYPE_AMO_ADD)) begin
      amo_sel = 0;
      is_amo = 1;
    end
    else begin
      if ((cachereq_type__5 == TYPE_AMO_AND)) begin
        amo_sel = 1;
        is_amo = 1;
      end
      else begin
        if ((cachereq_type__5 == TYPE_AMO_OR)) begin
          amo_sel = 2;
          is_amo = 1;
        end
        else begin
          if ((cachereq_type__5 == TYPE_AMO_SWAP)) begin
            amo_sel = 3;
            is_amo = 1;
          end
          else begin
            if ((cachereq_type__5 == TYPE_AMO_MIN)) begin
              amo_sel = 4;
              is_amo = 1;
            end
            else begin
              if ((cachereq_type__5 == TYPE_AMO_MINU)) begin
                amo_sel = 5;
                is_amo = 1;
              end
              else begin
                if ((cachereq_type__5 == TYPE_AMO_MAX)) begin
                  amo_sel = 6;
                  is_amo = 1;
                end
                else begin
                  if ((cachereq_type__5 == TYPE_AMO_MAXU)) begin
                    amo_sel = 7;
                    is_amo = 1;
                  end
                  else begin
                    if ((cachereq_type__5 == TYPE_AMO_XOR)) begin
                      amo_sel = 8;
                      is_amo = 1;
                    end
                    else begin
                      amo_sel = 0;
                      is_amo = 0;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_next_state():
  //       s.state_next.value = s.state_reg
  //       if s.state_reg == s.STATE_IDLE:
  //         if ( s.in_go ) : s.state_next.value = s.STATE_TAG_CHECK
  //
  //       elif s.state_reg == s.STATE_TAG_CHECK:
  //         if   ( s.is_init      )                                   : s.state_next.value = s.STATE_INIT_DATA_ACCESS
  //         elif ( s.read_hit  &  s.cacheresp_rdy &  s.cachereq_val ) : s.state_next.value = s.STATE_TAG_CHECK
  //         elif ( s.read_hit  &  s.cacheresp_rdy & ~s.cachereq_val ) : s.state_next.value = s.STATE_IDLE
  //         elif ( s.read_hit  & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WAIT_HIT
  //         elif ( s.write_hit &  s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT
  //         elif ( s.write_hit & ~s.cacheresp_rdy )                   : s.state_next.value = s.STATE_WRITE_CACHE_RESP_HIT
  //         elif ( s.amo_hit      )                                   : s.state_next.value = s.STATE_AMO_READ_DATA_ACCESS_HIT
  //         elif ( s.refill       )                                   : s.state_next.value = s.STATE_REFILL_REQUEST
  //         elif ( s.evict        )                                   : s.state_next.value = s.STATE_EVICT_PREPARE
  //
  //       elif s.state_reg == s.STATE_WRITE_CACHE_RESP_HIT:
  //         if (s.cacheresp_rdy):   s.state_next.value = s.STATE_WRITE_DATA_ACCESS_HIT
  //
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
  //         if (s.cachereq_val):    s.state_next.value = s.STATE_TAG_CHECK
  //         else:                   s.state_next.value = s.STATE_IDLE
  //
  //       elif s.state_reg == s.STATE_READ_DATA_ACCESS_MISS:
  //         s.state_next.value =    s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_MISS:
  //         if (s.cacheresp_rdy):   s.state_next.value = s.STATE_IDLE
  //         else:                   s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_INIT_DATA_ACCESS:
  //         s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_AMO_READ_DATA_ACCESS_HIT:
  //         s.state_next.value = s.STATE_AMO_WRITE_DATA_ACCESS_HIT
  //
  //       elif s.state_reg == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:
  //         s.state_next.value = s.STATE_WAIT_HIT
  //
  //       elif s.state_reg == s.STATE_AMO_READ_DATA_ACCESS_MISS:
  //         s.state_next.value = s.STATE_AMO_WRITE_DATA_ACCESS_MISS
  //
  //       elif s.state_reg == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:
  //         s.state_next.value = s.STATE_WAIT_MISS
  //
  //       elif s.state_reg == s.STATE_REFILL_REQUEST:
  //         if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_REFILL_WAIT
  //         elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_REFILL_REQUEST
  //
  //       elif s.state_reg == s.STATE_REFILL_WAIT:
  //         if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_UPDATE
  //         elif ( ~s.memresp_val ): s.state_next.value = s.STATE_REFILL_WAIT
  //
  //       elif s.state_reg == s.STATE_REFILL_UPDATE:
  //         if   ( s.is_read      ): s.state_next.value = s.STATE_READ_DATA_ACCESS_MISS
  //         elif ( s.is_write     ): s.state_next.value = s.STATE_WRITE_DATA_ACCESS_MISS
  //         elif ( s.is_amo       ): s.state_next.value = s.STATE_AMO_READ_DATA_ACCESS_MISS
  //
  //       elif s.state_reg == s.STATE_EVICT_PREPARE:
  //         s.state_next.value = s.STATE_EVICT_REQUEST
  //
  //       elif s.state_reg == s.STATE_EVICT_REQUEST:
  //         if   ( s.memreq_rdy   ): s.state_next.value = s.STATE_EVICT_WAIT
  //         elif ( ~s.memreq_rdy  ): s.state_next.value = s.STATE_EVICT_REQUEST
  //
  //       elif s.state_reg == s.STATE_EVICT_WAIT:
  //         if   ( s.memresp_val  ): s.state_next.value = s.STATE_REFILL_REQUEST
  //         elif ( ~s.memresp_val ): s.state_next.value = s.STATE_EVICT_WAIT
  //
  //       elif s.state_reg == s.STATE_WAIT_HIT:
  //         if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE
  //
  //       elif s.state_reg == s.STATE_WAIT_MISS:
  //         if   ( s.out_go       ): s.state_next.value = s.STATE_IDLE
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
        if (is_init) begin
          state_next = STATE_INIT_DATA_ACCESS;
        end
        else begin
          if (((read_hit&cacheresp_rdy)&cachereq_val)) begin
            state_next = STATE_TAG_CHECK;
          end
          else begin
            if (((read_hit&cacheresp_rdy)&~cachereq_val)) begin
              state_next = STATE_IDLE;
            end
            else begin
              if ((read_hit&~cacheresp_rdy)) begin
                state_next = STATE_WAIT_HIT;
              end
              else begin
                if ((write_hit&cacheresp_rdy)) begin
                  state_next = STATE_WRITE_DATA_ACCESS_HIT;
                end
                else begin
                  if ((write_hit&~cacheresp_rdy)) begin
                    state_next = STATE_WRITE_CACHE_RESP_HIT;
                  end
                  else begin
                    if (amo_hit) begin
                      state_next = STATE_AMO_READ_DATA_ACCESS_HIT;
                    end
                    else begin
                      if (refill) begin
                        state_next = STATE_REFILL_REQUEST;
                      end
                      else begin
                        if (evict) begin
                          state_next = STATE_EVICT_PREPARE;
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
        if ((state_reg == STATE_WRITE_CACHE_RESP_HIT)) begin
          if (cacheresp_rdy) begin
            state_next = STATE_WRITE_DATA_ACCESS_HIT;
          end
          else begin
          end
        end
        else begin
          if ((state_reg == STATE_WRITE_DATA_ACCESS_HIT)) begin
            if (cachereq_val) begin
              state_next = STATE_TAG_CHECK;
            end
            else begin
              state_next = STATE_IDLE;
            end
          end
          else begin
            if ((state_reg == STATE_READ_DATA_ACCESS_MISS)) begin
              state_next = STATE_WAIT_MISS;
            end
            else begin
              if ((state_reg == STATE_WRITE_DATA_ACCESS_MISS)) begin
                if (cacheresp_rdy) begin
                  state_next = STATE_IDLE;
                end
                else begin
                  state_next = STATE_WAIT_MISS;
                end
              end
              else begin
                if ((state_reg == STATE_INIT_DATA_ACCESS)) begin
                  state_next = STATE_WAIT_MISS;
                end
                else begin
                  if ((state_reg == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    state_next = STATE_AMO_WRITE_DATA_ACCESS_HIT;
                  end
                  else begin
                    if ((state_reg == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      state_next = STATE_WAIT_HIT;
                    end
                    else begin
                      if ((state_reg == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        state_next = STATE_AMO_WRITE_DATA_ACCESS_MISS;
                      end
                      else begin
                        if ((state_reg == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          state_next = STATE_WAIT_MISS;
                        end
                        else begin
                          if ((state_reg == STATE_REFILL_REQUEST)) begin
                            if (memreq_rdy) begin
                              state_next = STATE_REFILL_WAIT;
                            end
                            else begin
                              if (~memreq_rdy) begin
                                state_next = STATE_REFILL_REQUEST;
                              end
                              else begin
                              end
                            end
                          end
                          else begin
                            if ((state_reg == STATE_REFILL_WAIT)) begin
                              if (memresp_val) begin
                                state_next = STATE_REFILL_UPDATE;
                              end
                              else begin
                                if (~memresp_val) begin
                                  state_next = STATE_REFILL_WAIT;
                                end
                                else begin
                                end
                              end
                            end
                            else begin
                              if ((state_reg == STATE_REFILL_UPDATE)) begin
                                if (is_read) begin
                                  state_next = STATE_READ_DATA_ACCESS_MISS;
                                end
                                else begin
                                  if (is_write) begin
                                    state_next = STATE_WRITE_DATA_ACCESS_MISS;
                                  end
                                  else begin
                                    if (is_amo) begin
                                      state_next = STATE_AMO_READ_DATA_ACCESS_MISS;
                                    end
                                    else begin
                                    end
                                  end
                                end
                              end
                              else begin
                                if ((state_reg == STATE_EVICT_PREPARE)) begin
                                  state_next = STATE_EVICT_REQUEST;
                                end
                                else begin
                                  if ((state_reg == STATE_EVICT_REQUEST)) begin
                                    if (memreq_rdy) begin
                                      state_next = STATE_EVICT_WAIT;
                                    end
                                    else begin
                                      if (~memreq_rdy) begin
                                        state_next = STATE_EVICT_REQUEST;
                                      end
                                      else begin
                                      end
                                    end
                                  end
                                  else begin
                                    if ((state_reg == STATE_EVICT_WAIT)) begin
                                      if (memresp_val) begin
                                        state_next = STATE_REFILL_REQUEST;
                                      end
                                      else begin
                                        if (~memresp_val) begin
                                          state_next = STATE_EVICT_WAIT;
                                        end
                                        else begin
                                        end
                                      end
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_idx():
  //       s.cachereq_idx.value          = s.cachereq_addr[left_idx:right_idx]
  //       s.valid_bits_write_en_0.value = s.valid_bits_write_en & ~s.way_sel_current
  //       s.valid_bits_write_en_1.value = s.valid_bits_write_en &  s.way_sel_current

  // logic for comb_cachereq_idx()
  always @ (*) begin
    cachereq_idx = cachereq_addr[(right_idx)-1:left_idx];
    valid_bits_write_en_0 = (valid_bits_write_en&~way_sel_current);
    valid_bits_write_en_1 = (valid_bits_write_en&way_sel_current);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_valid_0():
  //       # Generate valids for writes
  //       s.valid_bits_0_in                .value = s.valid_bits_0_out
  //       s.valid_bits_0_in[s.cachereq_idx].value = s.valid_bit_in
  //
  //       # Read valids
  //       s.is_valid_0                     .value = s.valid_bits_0_out[s.cachereq_idx]

  // logic for gen_valid_0()
  always @ (*) begin
    valid_bits_0_in = valid_bits_0_out;
    valid_bits_0_in[cachereq_idx] = valid_bit_in;
    is_valid_0 = valid_bits_0_out[cachereq_idx];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_valid_1():
  //       # Generate valids for writes
  //       s.valid_bits_1_in                .value = s.valid_bits_1_out
  //       s.valid_bits_1_in[s.cachereq_idx].value = s.valid_bit_in
  //
  //       # Read valids
  //       s.is_valid_1                     .value = s.valid_bits_1_out[s.cachereq_idx]

  // logic for gen_valid_1()
  always @ (*) begin
    valid_bits_1_in = valid_bits_1_out;
    valid_bits_1_in[cachereq_idx] = valid_bit_in;
    is_valid_1 = valid_bits_1_out[cachereq_idx];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_idx():
  //       s.dirty_bits_write_en_0.value = s.dirty_bits_write_en & ~s.way_sel_current
  //       s.dirty_bits_write_en_1.value = s.dirty_bits_write_en &  s.way_sel_current

  // logic for comb_cachereq_idx()
  always @ (*) begin
    dirty_bits_write_en_0 = (dirty_bits_write_en&~way_sel_current);
    dirty_bits_write_en_1 = (dirty_bits_write_en&way_sel_current);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_way_select():
  //       if (s.hit) :
  //         if (s.hit_0) :
  //           s.way_record_in.value = Bits( 1, 0 )
  //         else :
  //           if (s.hit_1) :
  //             s.way_record_in.value = Bits( 1, 1 )
  //           else :
  //             s.way_record_in.value = Bits( 1, 0 )
  //       else :
  //         s.way_record_in.value = s.lru_way
  //
  //       if s.state_reg == s.STATE_TAG_CHECK:
  //         s.way_sel_current.value = s.way_record_in
  //       else:
  //         s.way_sel_current.value = s.way_sel

  // logic for comb_way_select()
  always @ (*) begin
    if (hit) begin
      if (hit_0) begin
        way_record_in = 1'd0;
      end
      else begin
        if (hit_1) begin
          way_record_in = 1'd1;
        end
        else begin
          way_record_in = 1'd0;
        end
      end
    end
    else begin
      way_record_in = lru_way;
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
  // def comb_control_table():
  //       sr = s.state_reg
  //
  //       #                                                                    $    $    mem mem  $    mem         read read mem  valid valid dirty dirty lru   way    $    skip
  //       #                                                                    req  resp req resp req  resp is     data tag  req  bit   write bit   write write record resp data
  //       #                                                                    rdy  val  val rdy  en   en   refill en   en   type in    en    in    en    en    en     hit  reg
  //       s.cs.value                                                 = concat( n,   n,   n,  n,   x,   x,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       if   sr == s.STATE_IDLE:                        s.cs.value = concat( y,   n,   n,  n,   y,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_TAG_CHECK:                   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    y,     n,   y    )
  //       elif sr == s.STATE_WRITE_CACHE_RESP_HIT:        s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    y,    n,     y,   n    )
  //       elif sr == s.STATE_WRITE_DATA_ACCESS_HIT:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     y,   n    )
  //       elif sr == s.STATE_READ_DATA_ACCESS_MISS:       s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   n    )
  //       elif sr == s.STATE_WRITE_DATA_ACCESS_MISS:      s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_INIT_DATA_ACCESS:            s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    n,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_AMO_READ_DATA_ACCESS_HIT:    s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   y    )
  //       elif sr == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_AMO_READ_DATA_ACCESS_MISS:   s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   n,   m_x, x,    n,    x,    n,    y,    n,     n,   y    )
  //       elif sr == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:  s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_c,   n,   n,   m_x, y,    y,    y,    y,    y,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_REQUEST:              s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_r, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_WAIT:                 s.cs.value = concat( n,   n,   n,  y,   n,   y,   r_m,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_REFILL_UPDATE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, y,    y,    n,    y,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_PREPARE:               s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   y,   y,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_REQUEST:               s.cs.value = concat( n,   n,   y,  n,   n,   n,   r_x,   n,   n,   m_e, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_EVICT_WAIT:                  s.cs.value = concat( n,   n,   n,  y,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       elif sr == s.STATE_WAIT_HIT:                    s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     y,   n    )
  //       elif sr == s.STATE_WAIT_MISS:                   s.cs.value = concat( n,   y,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //       else :                                          s.cs.value = concat( n,   n,   n,  n,   n,   n,   r_x,   n,   n,   m_x, x,    n,    x,    n,    n,    n,     n,   n    )
  //
  //       # Unpack signals
  //
  //       s.cachereq_rdy.value        = s.cs[ CS_cachereq_rdy        ]
  //       s.cacheresp_val.value       = s.cs[ CS_cacheresp_val       ]
  //       s.memreq_val.value          = s.cs[ CS_memreq_val          ]
  //       s.memresp_rdy.value         = s.cs[ CS_memresp_rdy         ]
  //       s.cachereq_en.value         = s.cs[ CS_cachereq_en         ]
  //       s.memresp_en.value          = s.cs[ CS_memresp_en          ]
  //       s.is_refill.value           = s.cs[ CS_is_refill           ]
  //       s.read_data_reg_en.value    = s.cs[ CS_read_data_reg_en    ]
  //       s.read_tag_reg_en.value     = s.cs[ CS_read_tag_reg_en     ]
  //       s.memreq_type.value         = s.cs[ CS_memreq_type         ]
  //       s.valid_bit_in.value        = s.cs[ CS_valid_bit_in        ]
  //       s.valid_bits_write_en.value = s.cs[ CS_valid_bits_write_en ]
  //       s.dirty_bit_in.value        = s.cs[ CS_dirty_bit_in        ]
  //       s.dirty_bits_write_en.value = s.cs[ CS_dirty_bits_write_en ]
  //       s.lru_bits_write_en.value   = s.cs[ CS_lru_bits_write_en   ]
  //       s.way_record_en.value       = s.cs[ CS_way_record_en       ]
  //       s.cacheresp_hit.value       = s.cs[ CS_cacheresp_hit       ]
  //       s.skip_read_data_reg.value  = s.cs[ CS_skip_read_data_reg  ]
  //
  //       # set cacheresp_val when there is a hit for one hit latency
  //       if (s.read_hit | s.write_hit) and (s.state_reg == s.STATE_TAG_CHECK):
  //         s.cacheresp_val.value = 1
  //         s.cacheresp_hit.value = 1
  //
  //         # if read hit, if can send response, immediately take new cachereq
  //         if s.read_hit:
  //           s.cachereq_rdy.value  = s.cacheresp_rdy
  //           s.cachereq_en.value   = s.cacheresp_rdy
  //
  //       # since cacheresp already handled, can immediately take new cachereq
  //       elif s.state_reg == s.STATE_WRITE_DATA_ACCESS_HIT:
  //         s.cachereq_rdy.value  = 1
  //         s.cachereq_en.value   = 1

  // logic for comb_control_table()
  always @ (*) begin
    sr__12 = state_reg;
    cs = { n,n,n,n,x,x,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
    if ((sr__12 == STATE_IDLE)) begin
      cs = { y,n,n,n,y,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
    end
    else begin
      if ((sr__12 == STATE_TAG_CHECK)) begin
        cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,y,n,y };
      end
      else begin
        if ((sr__12 == STATE_WRITE_CACHE_RESP_HIT)) begin
          cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,y,n,y,n };
        end
        else begin
          if ((sr__12 == STATE_WRITE_DATA_ACCESS_HIT)) begin
            cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,y,n };
          end
          else begin
            if ((sr__12 == STATE_READ_DATA_ACCESS_MISS)) begin
              cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,n };
            end
            else begin
              if ((sr__12 == STATE_WRITE_DATA_ACCESS_MISS)) begin
                cs = { n,y,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
              end
              else begin
                if ((sr__12 == STATE_INIT_DATA_ACCESS)) begin
                  cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,n,y,y,n,n,n };
                end
                else begin
                  if ((sr__12 == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,y };
                  end
                  else begin
                    if ((sr__12 == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
                    end
                    else begin
                      if ((sr__12 == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        cs = { n,n,n,n,n,n,r_x,y,n,m_x,x,n,x,n,y,n,n,y };
                      end
                      else begin
                        if ((sr__12 == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          cs = { n,n,n,n,n,n,r_c,n,n,m_x,y,y,y,y,y,n,n,n };
                        end
                        else begin
                          if ((sr__12 == STATE_REFILL_REQUEST)) begin
                            cs = { n,n,y,n,n,n,r_x,n,n,m_r,x,n,x,n,n,n,n,n };
                          end
                          else begin
                            if ((sr__12 == STATE_REFILL_WAIT)) begin
                              cs = { n,n,n,y,n,y,r_m,n,n,m_x,x,n,x,n,n,n,n,n };
                            end
                            else begin
                              if ((sr__12 == STATE_REFILL_UPDATE)) begin
                                cs = { n,n,n,n,n,n,r_x,n,n,m_x,y,y,n,y,n,n,n,n };
                              end
                              else begin
                                if ((sr__12 == STATE_EVICT_PREPARE)) begin
                                  cs = { n,n,n,n,n,n,r_x,y,y,m_x,x,n,x,n,n,n,n,n };
                                end
                                else begin
                                  if ((sr__12 == STATE_EVICT_REQUEST)) begin
                                    cs = { n,n,y,n,n,n,r_x,n,n,m_e,x,n,x,n,n,n,n,n };
                                  end
                                  else begin
                                    if ((sr__12 == STATE_EVICT_WAIT)) begin
                                      cs = { n,n,n,y,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
                                    end
                                    else begin
                                      if ((sr__12 == STATE_WAIT_HIT)) begin
                                        cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,y,n };
                                      end
                                      else begin
                                        if ((sr__12 == STATE_WAIT_MISS)) begin
                                          cs = { n,y,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
                                        end
                                        else begin
                                          cs = { n,n,n,n,n,n,r_x,n,n,m_x,x,n,x,n,n,n,n,n };
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
    cachereq_rdy = cs[(21)-1:20];
    cacheresp_val = cs[(20)-1:19];
    memreq_val = cs[(19)-1:18];
    memresp_rdy = cs[(18)-1:17];
    cachereq_en = cs[(17)-1:16];
    memresp_en = cs[(16)-1:15];
    is_refill = cs[(15)-1:14];
    read_data_reg_en = cs[(14)-1:13];
    read_tag_reg_en = cs[(13)-1:12];
    memreq_type = cs[(12)-1:8];
    valid_bit_in = cs[(8)-1:7];
    valid_bits_write_en = cs[(7)-1:6];
    dirty_bit_in = cs[(6)-1:5];
    dirty_bits_write_en = cs[(5)-1:4];
    lru_bits_write_en = cs[(4)-1:3];
    way_record_en = cs[(3)-1:2];
    cacheresp_hit = cs[(2)-1:1];
    skip_read_data_reg = cs[(1)-1:0];
    if (((read_hit|write_hit)&&(state_reg == STATE_TAG_CHECK))) begin
      cacheresp_val = 1;
      cacheresp_hit = 1;
      if (read_hit) begin
        cachereq_rdy = cacheresp_rdy;
        cachereq_en = cacheresp_rdy;
      end
      else begin
      end
    end
    else begin
      if ((state_reg == STATE_WRITE_DATA_ACCESS_HIT)) begin
        cachereq_rdy = 1;
        cachereq_en = 1;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_control_table():
  //
  //       # set enable for tag_array and data_array one cycle early (dependant on next_state)
  //       sn = s.state_next
  //       s.ns.value = concat( n,   n,    n,  n )
  //       #                                                                   tag   tag   data  data
  //       #                                                                   array array array array
  //       #                                                                   wen   ren   wen   ren
  //       if   sn == s.STATE_IDLE:                        s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_TAG_CHECK:                   s.ns.value = concat( n,    y,    n,    y,   )
  //       elif sn == s.STATE_WRITE_CACHE_RESP_HIT:        s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WRITE_DATA_ACCESS_HIT:       s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_READ_DATA_ACCESS_MISS:       s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_WRITE_DATA_ACCESS_MISS:      s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_INIT_DATA_ACCESS:            s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_AMO_READ_DATA_ACCESS_HIT:    s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_AMO_WRITE_DATA_ACCESS_HIT:   s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_AMO_READ_DATA_ACCESS_MISS:   s.ns.value = concat( n,    n,    n,    y,   )
  //       elif sn == s.STATE_AMO_WRITE_DATA_ACCESS_MISS:  s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_REFILL_REQUEST:              s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_REFILL_WAIT:                 s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_REFILL_UPDATE:               s.ns.value = concat( y,    n,    y,    n,   )
  //       elif sn == s.STATE_EVICT_PREPARE:               s.ns.value = concat( n,    y,    n,    y,   )
  //       elif sn == s.STATE_EVICT_REQUEST:               s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_EVICT_WAIT:                  s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WAIT_HIT:                    s.ns.value = concat( n,    n,    n,    n,   )
  //       elif sn == s.STATE_WAIT_MISS:                   s.ns.value = concat( n,    n,    n,    n,   )
  //       else :                                          s.ns.value = concat( n,    n,    n,    n,   )
  //
  //       # Unpack signals
  //
  //       s.tag_array_wen.value  = s.ns[ NS_tag_array_wen  ]
  //       s.tag_array_ren.value  = s.ns[ NS_tag_array_ren  ]
  //       s.data_array_wen.value = s.ns[ NS_data_array_wen ]
  //       s.data_array_ren.value = s.ns[ NS_data_array_ren ]

  // logic for comb_control_table()
  always @ (*) begin
    sn__13 = state_next;
    ns = { n,n,n,n };
    if ((sn__13 == STATE_IDLE)) begin
      ns = { n,n,n,n };
    end
    else begin
      if ((sn__13 == STATE_TAG_CHECK)) begin
        ns = { n,y,n,y };
      end
      else begin
        if ((sn__13 == STATE_WRITE_CACHE_RESP_HIT)) begin
          ns = { n,n,n,n };
        end
        else begin
          if ((sn__13 == STATE_WRITE_DATA_ACCESS_HIT)) begin
            ns = { y,n,y,n };
          end
          else begin
            if ((sn__13 == STATE_READ_DATA_ACCESS_MISS)) begin
              ns = { n,n,n,y };
            end
            else begin
              if ((sn__13 == STATE_WRITE_DATA_ACCESS_MISS)) begin
                ns = { y,n,y,n };
              end
              else begin
                if ((sn__13 == STATE_INIT_DATA_ACCESS)) begin
                  ns = { y,n,y,n };
                end
                else begin
                  if ((sn__13 == STATE_AMO_READ_DATA_ACCESS_HIT)) begin
                    ns = { n,n,n,y };
                  end
                  else begin
                    if ((sn__13 == STATE_AMO_WRITE_DATA_ACCESS_HIT)) begin
                      ns = { y,n,y,n };
                    end
                    else begin
                      if ((sn__13 == STATE_AMO_READ_DATA_ACCESS_MISS)) begin
                        ns = { n,n,n,y };
                      end
                      else begin
                        if ((sn__13 == STATE_AMO_WRITE_DATA_ACCESS_MISS)) begin
                          ns = { y,n,y,n };
                        end
                        else begin
                          if ((sn__13 == STATE_REFILL_REQUEST)) begin
                            ns = { n,n,n,n };
                          end
                          else begin
                            if ((sn__13 == STATE_REFILL_WAIT)) begin
                              ns = { n,n,n,n };
                            end
                            else begin
                              if ((sn__13 == STATE_REFILL_UPDATE)) begin
                                ns = { y,n,y,n };
                              end
                              else begin
                                if ((sn__13 == STATE_EVICT_PREPARE)) begin
                                  ns = { n,y,n,y };
                                end
                                else begin
                                  if ((sn__13 == STATE_EVICT_REQUEST)) begin
                                    ns = { n,n,n,n };
                                  end
                                  else begin
                                    if ((sn__13 == STATE_EVICT_WAIT)) begin
                                      ns = { n,n,n,n };
                                    end
                                    else begin
                                      if ((sn__13 == STATE_WAIT_HIT)) begin
                                        ns = { n,n,n,n };
                                      end
                                      else begin
                                        if ((sn__13 == STATE_WAIT_MISS)) begin
                                          ns = { n,n,n,n };
                                        end
                                        else begin
                                          ns = { n,n,n,n };
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
    tag_array_wen = ns[(4)-1:3];
    tag_array_ren = ns[(3)-1:2];
    data_array_wen = ns[(2)-1:1];
    data_array_ren = ns[(1)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_lru_bit_in():
  //       s.lru_bit_in.value = ~s.way_sel_current

  // logic for comb_lru_bit_in()
  always @ (*) begin
    lru_bit_in = ~way_sel_current;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_tag_arry_en():
  //       s.tag_array_0_wen.value = s.tag_array_wen & ~s.way_sel_current
  //       s.tag_array_0_ren.value = s.tag_array_ren
  //       s.tag_array_1_wen.value = s.tag_array_wen &  s.way_sel_current
  //       s.tag_array_1_ren.value = s.tag_array_ren

  // logic for comb_tag_arry_en()
  always @ (*) begin
    tag_array_0_wen = (tag_array_wen&~way_sel_current);
    tag_array_0_ren = tag_array_ren;
    tag_array_1_wen = (tag_array_wen&way_sel_current);
    tag_array_1_ren = tag_array_ren;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_offset():
  //       s.cachereq_offset.value = s.cachereq_addr[0:m_len_bw]

  // logic for comb_cachereq_offset()
  always @ (*) begin
    cachereq_offset = cachereq_addr[(m_len_bw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_enable_writing():
  //
  //       # Logic to enable writing of the entire cacheline in case of refill
  //       # and just one word for writes and init
  //
  //       if ( s.is_refill ) : s.data_array_wben.value = Bits( 16, 0xffff )
  //       else               : s.data_array_wben.value = s.wben_decoder_out
  //
  //       # Managing the cache response type based on cache request type
  //
  //       s.cacheresp_type.value = s.cachereq_type

  // logic for comb_enable_writing()
  always @ (*) begin
    if (is_refill) begin
      data_array_wben = 16'd65535;
    end
    else begin
      data_array_wben = wben_decoder_out;
    end
    cacheresp_type = cachereq_type;
  end


endmodule // BlockingCacheCtrlPRTL_0x2673bbb0e0f7d38
`default_nettype wire

//-----------------------------------------------------------------------------
// DecodeWbenPRTL_0x18c15822932d5d24
//-----------------------------------------------------------------------------
// num_bytes: 16
// mask_num_bytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module DecodeWbenPRTL_0x18c15822932d5d24
(
  input  wire [   0:0] clk,
  input  wire [   3:0] idx,
  input  wire [   3:0] len,
  output reg  [  15:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   3:0] len_d;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_logic():
  //
  //       # Adjusted length
  //       s.len_d.value = s.len - 1
  //
  //       # Construct a mask
  //       s.out  .value = 0
  //       s.out  .value = ~s.out
  //       s.out  .value = s.out << 1
  //       s.out  .value = s.out << s.len_d
  //       s.out  .value = ~s.out
  //
  //       # Shift to starting index
  //       s.out  .value = s.out.value << s.idx

  // logic for comb_logic()
  always @ (*) begin
    len_d = (len-1);
    out = 0;
    out = ~out;
    out = (out<<1);
    out = (out<<len_d);
    out = ~out;
    out = (out<<idx);
  end


endmodule // DecodeWbenPRTL_0x18c15822932d5d24
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueue_0x5a7f0a6588025dd8
//-----------------------------------------------------------------------------
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueue_0x5a7f0a6588025dd8
(
  input  wire [   0:0] clk,
  output wire [ 145:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [ 145:0] enq_msg,
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
  wire   [ 145:0] dpath$enq_bits;
  wire   [ 145:0] dpath$deq_bits;

  SingleElementBypassQueueDpath_0x5a7f0a6588025dd8 dpath
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



endmodule // SingleElementBypassQueue_0x5a7f0a6588025dd8
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementBypassQueueDpath_0x5a7f0a6588025dd8
//-----------------------------------------------------------------------------
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementBypassQueueDpath_0x5a7f0a6588025dd8
(
  input  wire [   0:0] bypass_mux_sel,
  input  wire [   0:0] clk,
  output wire [ 145:0] deq_bits,
  input  wire [ 145:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // bypass_mux temporaries
  wire   [   0:0] bypass_mux$reset;
  wire   [ 145:0] bypass_mux$in_$000;
  wire   [ 145:0] bypass_mux$in_$001;
  wire   [   0:0] bypass_mux$clk;
  wire   [   0:0] bypass_mux$sel;
  wire   [ 145:0] bypass_mux$out;

  Mux_0x45e00ad6230c4538 bypass_mux
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
  wire   [ 145:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [ 145:0] queue$out;

  RegEn_0x1c3ed81872982f83 queue
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



endmodule // SingleElementBypassQueueDpath_0x5a7f0a6588025dd8
`default_nettype wire

//-----------------------------------------------------------------------------
// Mux_0x45e00ad6230c4538
//-----------------------------------------------------------------------------
// dtype: 146
// nports: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Mux_0x45e00ad6230c4538
(
  input  wire [   0:0] clk,
  input  wire [ 145:0] in_$000,
  input  wire [ 145:0] in_$001,
  output reg  [ 145:0] out,
  input  wire [   0:0] reset,
  input  wire [   0:0] sel
);

  // localparam declarations
  localparam nports = 2;


  // array declarations
  wire   [ 145:0] in_[0:1];
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


endmodule // Mux_0x45e00ad6230c4538
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x1c3ed81872982f83
//-----------------------------------------------------------------------------
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x1c3ed81872982f83
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [ 145:0] in_,
  output reg  [ 145:0] out,
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


endmodule // RegEn_0x1c3ed81872982f83
`default_nettype wire

//-----------------------------------------------------------------------------
// BlockingCacheDpathPRTL_0x6b511b3b41602acf
//-----------------------------------------------------------------------------
// idx_shamt: 0
// MemReqMsgType: 176
// MemRespMsgType: 146
// CacheReqMsgType: 176
// CacheRespMsgType: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BlockingCacheDpathPRTL_0x6b511b3b41602acf
(
  input  wire [   0:0] amo_max_sel,
  input  wire [   0:0] amo_maxu_sel,
  input  wire [   0:0] amo_min_sel,
  input  wire [   0:0] amo_minu_sel,
  input  wire [   3:0] amo_sel,
  input  wire [   1:0] byte_offset,
  output wire [  31:0] cachereq_addr,
  output wire [ 127:0] cachereq_data_reg_out,
  output reg  [  31:0] cachereq_data_word,
  input  wire [   0:0] cachereq_en,
  output wire [   3:0] cachereq_len_reg_out,
  input  wire [ 175:0] cachereq_msg,
  output wire [   3:0] cachereq_type,
  input  wire [   0:0] cacheresp_hit,
  output reg  [ 145:0] cacheresp_msg,
  input  wire [   3:0] cacheresp_type,
  input  wire [   0:0] clk,
  input  wire [   0:0] data_array_ren,
  input  wire [  15:0] data_array_wben,
  input  wire [   0:0] data_array_wen,
  input  wire [   0:0] is_amo,
  input  wire [   0:0] is_refill,
  output reg  [ 175:0] memreq_msg,
  input  wire [   3:0] memreq_type,
  input  wire [   0:0] memresp_en,
  input  wire [ 145:0] memresp_msg,
  input  wire [   0:0] read_data_reg_en,
  output reg  [  31:0] read_data_word,
  input  wire [   0:0] read_tag_reg_en,
  input  wire [   0:0] reset,
  input  wire [   0:0] skip_read_data_reg,
  input  wire [   0:0] tag_array_0_ren,
  input  wire [   0:0] tag_array_0_wen,
  input  wire [   0:0] tag_array_1_ren,
  input  wire [   0:0] tag_array_1_wen,
  output wire [   0:0] tag_match_0,
  output wire [   0:0] tag_match_1,
  input  wire [   0:0] way_sel,
  input  wire [   0:0] way_sel_current
);

  // wire declarations
  wire   [ 127:0] read_data;
  wire   [  27:0] memreq_type_mux_out;
  wire   [ 127:0] int_read_data;
  wire   [ 127:0] data_array_1_read_out;
  wire   [  31:0] cacheresp_data_out;
  wire   [  31:0] tag_array_0_read_out;
  wire   [  31:0] tag_array_1_read_out;
  wire   [ 127:0] data_array_0_read_out;


  // register declarations
  reg    [ 127:0] amo_out;
  reg    [  31:0] cachereq_data_reg_out_add;
  reg    [  31:0] cachereq_data_reg_out_and;
  reg    [  31:0] cachereq_data_reg_out_max;
  reg    [  31:0] cachereq_data_reg_out_maxu;
  reg    [  31:0] cachereq_data_reg_out_min;
  reg    [  31:0] cachereq_data_reg_out_minu;
  reg    [  31:0] cachereq_data_reg_out_or;
  reg    [  31:0] cachereq_data_reg_out_swap;
  reg    [  31:0] cachereq_data_reg_out_xor;
  reg    [   9:0] cachereq_idx;
  reg    [  31:0] cachereq_msg_addr;
  reg    [   3:0] cachereq_offset;
  reg    [  27:0] cachereq_tag;
  reg    [   9:0] cur_cachereq_idx;
  reg    [   0:0] data_array_0_wen;
  reg    [   0:0] data_array_1_wen;
  reg    [  31:0] memreq_addr;
  reg    [   0:0] sram_data_0_en;
  reg    [   0:0] sram_data_1_en;
  reg    [   0:0] sram_tag_0_en;
  reg    [   0:0] sram_tag_1_en;
  reg    [  31:0] temp_cachereq_tag;

  // localparam declarations
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
  localparam abw = 32;
  localparam dbw = 32;
  localparam idw_off = 14;
  localparam m_len_bw = 4;

  // read_tag_reg temporaries
  wire   [   0:0] read_tag_reg$reset;
  wire   [   0:0] read_tag_reg$en;
  wire   [   0:0] read_tag_reg$clk;
  wire   [  27:0] read_tag_reg$in_;
  wire   [  27:0] read_tag_reg$out;

  RegEnRst_0x35d76e7a8821f894 read_tag_reg
  (
    .reset ( read_tag_reg$reset ),
    .en    ( read_tag_reg$en ),
    .clk   ( read_tag_reg$clk ),
    .in_   ( read_tag_reg$in_ ),
    .out   ( read_tag_reg$out )
  );

  // cachereq_data_reg temporaries
  wire   [   0:0] cachereq_data_reg$reset;
  wire   [   0:0] cachereq_data_reg$en;
  wire   [   0:0] cachereq_data_reg$clk;
  wire   [ 127:0] cachereq_data_reg$in_;
  wire   [ 127:0] cachereq_data_reg$out;

  RegEnRst_0x150bbb1e4e9ba308 cachereq_data_reg
  (
    .reset ( cachereq_data_reg$reset ),
    .en    ( cachereq_data_reg$en ),
    .clk   ( cachereq_data_reg$clk ),
    .in_   ( cachereq_data_reg$in_ ),
    .out   ( cachereq_data_reg$out )
  );

  // cachereq_len_reg temporaries
  wire   [   0:0] cachereq_len_reg$reset;
  wire   [   0:0] cachereq_len_reg$en;
  wire   [   0:0] cachereq_len_reg$clk;
  wire   [   3:0] cachereq_len_reg$in_;
  wire   [   3:0] cachereq_len_reg$out;

  RegEnRst_0x1c9f2c4521ce0fbc cachereq_len_reg
  (
    .reset ( cachereq_len_reg$reset ),
    .en    ( cachereq_len_reg$en ),
    .clk   ( cachereq_len_reg$clk ),
    .in_   ( cachereq_len_reg$in_ ),
    .out   ( cachereq_len_reg$out )
  );

  // amo_minu_mux temporaries
  wire   [   0:0] amo_minu_mux$reset;
  wire   [  31:0] amo_minu_mux$in_$000;
  wire   [  31:0] amo_minu_mux$in_$001;
  wire   [   0:0] amo_minu_mux$clk;
  wire   [   0:0] amo_minu_mux$sel;
  wire   [  31:0] amo_minu_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_minu_mux
  (
    .reset   ( amo_minu_mux$reset ),
    .in_$000 ( amo_minu_mux$in_$000 ),
    .in_$001 ( amo_minu_mux$in_$001 ),
    .clk     ( amo_minu_mux$clk ),
    .sel     ( amo_minu_mux$sel ),
    .out     ( amo_minu_mux$out )
  );

  // amo_sel_mux temporaries
  wire   [   0:0] amo_sel_mux$reset;
  wire   [  31:0] amo_sel_mux$in_$000;
  wire   [  31:0] amo_sel_mux$in_$001;
  wire   [  31:0] amo_sel_mux$in_$002;
  wire   [  31:0] amo_sel_mux$in_$003;
  wire   [  31:0] amo_sel_mux$in_$004;
  wire   [  31:0] amo_sel_mux$in_$005;
  wire   [  31:0] amo_sel_mux$in_$006;
  wire   [  31:0] amo_sel_mux$in_$007;
  wire   [  31:0] amo_sel_mux$in_$008;
  wire   [   0:0] amo_sel_mux$clk;
  wire   [   3:0] amo_sel_mux$sel;
  wire   [  31:0] amo_sel_mux$out;

  Mux_0x1256f43349e9a82f amo_sel_mux
  (
    .reset   ( amo_sel_mux$reset ),
    .in_$000 ( amo_sel_mux$in_$000 ),
    .in_$001 ( amo_sel_mux$in_$001 ),
    .in_$002 ( amo_sel_mux$in_$002 ),
    .in_$003 ( amo_sel_mux$in_$003 ),
    .in_$004 ( amo_sel_mux$in_$004 ),
    .in_$005 ( amo_sel_mux$in_$005 ),
    .in_$006 ( amo_sel_mux$in_$006 ),
    .in_$007 ( amo_sel_mux$in_$007 ),
    .in_$008 ( amo_sel_mux$in_$008 ),
    .clk     ( amo_sel_mux$clk ),
    .sel     ( amo_sel_mux$sel ),
    .out     ( amo_sel_mux$out )
  );

  // tag_compare_0 temporaries
  wire   [   0:0] tag_compare_0$reset;
  wire   [   0:0] tag_compare_0$clk;
  wire   [  27:0] tag_compare_0$in0;
  wire   [  27:0] tag_compare_0$in1;
  wire   [   0:0] tag_compare_0$out;

  EqComparator_0x4b38e35357dbd1ff tag_compare_0
  (
    .reset ( tag_compare_0$reset ),
    .clk   ( tag_compare_0$clk ),
    .in0   ( tag_compare_0$in0 ),
    .in1   ( tag_compare_0$in1 ),
    .out   ( tag_compare_0$out )
  );

  // tag_compare_1 temporaries
  wire   [   0:0] tag_compare_1$reset;
  wire   [   0:0] tag_compare_1$clk;
  wire   [  27:0] tag_compare_1$in0;
  wire   [  27:0] tag_compare_1$in1;
  wire   [   0:0] tag_compare_1$out;

  EqComparator_0x4b38e35357dbd1ff tag_compare_1
  (
    .reset ( tag_compare_1$reset ),
    .clk   ( tag_compare_1$clk ),
    .in0   ( tag_compare_1$in0 ),
    .in1   ( tag_compare_1$in1 ),
    .out   ( tag_compare_1$out )
  );

  // skip_read_data_mux temporaries
  wire   [   0:0] skip_read_data_mux$reset;
  wire   [ 127:0] skip_read_data_mux$in_$000;
  wire   [ 127:0] skip_read_data_mux$in_$001;
  wire   [   0:0] skip_read_data_mux$clk;
  wire   [   0:0] skip_read_data_mux$sel;
  wire   [ 127:0] skip_read_data_mux$out;

  Mux_0x5af2f539a1a7deea skip_read_data_mux
  (
    .reset   ( skip_read_data_mux$reset ),
    .in_$000 ( skip_read_data_mux$in_$000 ),
    .in_$001 ( skip_read_data_mux$in_$001 ),
    .clk     ( skip_read_data_mux$clk ),
    .sel     ( skip_read_data_mux$sel ),
    .out     ( skip_read_data_mux$out )
  );

  // tag_array_0 temporaries
  wire   [   0:0] tag_array_0$ce;
  wire   [  31:0] tag_array_0$in_;
  wire   [   9:0] tag_array_0$addr;
  wire   [   3:0] tag_array_0$wmask;
  wire   [   0:0] tag_array_0$clk;
  wire   [   0:0] tag_array_0$we;
  wire   [   0:0] tag_array_0$reset;
  wire   [  31:0] tag_array_0$out;

  SramRTL_0x1d0877c36bd105f4 tag_array_0
  (
    .ce    ( tag_array_0$ce ),
    .in_   ( tag_array_0$in_ ),
    .addr  ( tag_array_0$addr ),
    .wmask ( tag_array_0$wmask ),
    .clk   ( tag_array_0$clk ),
    .we    ( tag_array_0$we ),
    .reset ( tag_array_0$reset ),
    .out   ( tag_array_0$out )
  );

  // tag_array_1 temporaries
  wire   [   0:0] tag_array_1$ce;
  wire   [  31:0] tag_array_1$in_;
  wire   [   9:0] tag_array_1$addr;
  wire   [   3:0] tag_array_1$wmask;
  wire   [   0:0] tag_array_1$clk;
  wire   [   0:0] tag_array_1$we;
  wire   [   0:0] tag_array_1$reset;
  wire   [  31:0] tag_array_1$out;

  SramRTL_0x1d0877c36bd105f4 tag_array_1
  (
    .ce    ( tag_array_1$ce ),
    .in_   ( tag_array_1$in_ ),
    .addr  ( tag_array_1$addr ),
    .wmask ( tag_array_1$wmask ),
    .clk   ( tag_array_1$clk ),
    .we    ( tag_array_1$we ),
    .reset ( tag_array_1$reset ),
    .out   ( tag_array_1$out )
  );

  // refill_mux temporaries
  wire   [   0:0] refill_mux$reset;
  wire   [ 127:0] refill_mux$in_$000;
  wire   [ 127:0] refill_mux$in_$001;
  wire   [   0:0] refill_mux$clk;
  wire   [   0:0] refill_mux$sel;
  wire   [ 127:0] refill_mux$out;

  Mux_0x5af2f539a1a7deea refill_mux
  (
    .reset   ( refill_mux$reset ),
    .in_$000 ( refill_mux$in_$000 ),
    .in_$001 ( refill_mux$in_$001 ),
    .clk     ( refill_mux$clk ),
    .sel     ( refill_mux$sel ),
    .out     ( refill_mux$out )
  );

  // way_sel_mux temporaries
  wire   [   0:0] way_sel_mux$reset;
  wire   [  27:0] way_sel_mux$in_$000;
  wire   [  27:0] way_sel_mux$in_$001;
  wire   [   0:0] way_sel_mux$clk;
  wire   [   0:0] way_sel_mux$sel;
  wire   [  27:0] way_sel_mux$out;

  Mux_0xb6e139e9f208756 way_sel_mux
  (
    .reset   ( way_sel_mux$reset ),
    .in_$000 ( way_sel_mux$in_$000 ),
    .in_$001 ( way_sel_mux$in_$001 ),
    .clk     ( way_sel_mux$clk ),
    .sel     ( way_sel_mux$sel ),
    .out     ( way_sel_mux$out )
  );

  // amo_min_mux temporaries
  wire   [   0:0] amo_min_mux$reset;
  wire   [  31:0] amo_min_mux$in_$000;
  wire   [  31:0] amo_min_mux$in_$001;
  wire   [   0:0] amo_min_mux$clk;
  wire   [   0:0] amo_min_mux$sel;
  wire   [  31:0] amo_min_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_min_mux
  (
    .reset   ( amo_min_mux$reset ),
    .in_$000 ( amo_min_mux$in_$000 ),
    .in_$001 ( amo_min_mux$in_$001 ),
    .clk     ( amo_min_mux$clk ),
    .sel     ( amo_min_mux$sel ),
    .out     ( amo_min_mux$out )
  );

  // data_array_1 temporaries
  wire   [   0:0] data_array_1$ce;
  wire   [ 127:0] data_array_1$in_;
  wire   [   9:0] data_array_1$addr;
  wire   [  15:0] data_array_1$wmask;
  wire   [   0:0] data_array_1$clk;
  wire   [   0:0] data_array_1$we;
  wire   [   0:0] data_array_1$reset;
  wire   [ 127:0] data_array_1$out;

  SramRTL_0x2d6938eb96dccb54 data_array_1
  (
    .ce    ( data_array_1$ce ),
    .in_   ( data_array_1$in_ ),
    .addr  ( data_array_1$addr ),
    .wmask ( data_array_1$wmask ),
    .clk   ( data_array_1$clk ),
    .we    ( data_array_1$we ),
    .reset ( data_array_1$reset ),
    .out   ( data_array_1$out )
  );

  // data_array_0 temporaries
  wire   [   0:0] data_array_0$ce;
  wire   [ 127:0] data_array_0$in_;
  wire   [   9:0] data_array_0$addr;
  wire   [  15:0] data_array_0$wmask;
  wire   [   0:0] data_array_0$clk;
  wire   [   0:0] data_array_0$we;
  wire   [   0:0] data_array_0$reset;
  wire   [ 127:0] data_array_0$out;

  SramRTL_0x2d6938eb96dccb54 data_array_0
  (
    .ce    ( data_array_0$ce ),
    .in_   ( data_array_0$in_ ),
    .addr  ( data_array_0$addr ),
    .wmask ( data_array_0$wmask ),
    .clk   ( data_array_0$clk ),
    .we    ( data_array_0$we ),
    .reset ( data_array_0$reset ),
    .out   ( data_array_0$out )
  );

  // cachresp_mux temporaries
  wire   [   0:0] cachresp_mux$reset;
  wire   [ 127:0] cachresp_mux$in_$000;
  wire   [ 127:0] cachresp_mux$in_$001;
  wire   [   0:0] cachresp_mux$clk;
  wire   [   0:0] cachresp_mux$sel;
  wire   [ 127:0] cachresp_mux$out;

  Mux_0x5af2f539a1a7deea cachresp_mux
  (
    .reset   ( cachresp_mux$reset ),
    .in_$000 ( cachresp_mux$in_$000 ),
    .in_$001 ( cachresp_mux$in_$001 ),
    .clk     ( cachresp_mux$clk ),
    .sel     ( cachresp_mux$sel ),
    .out     ( cachresp_mux$out )
  );

  // slice_n_dice temporaries
  wire   [ 127:0] slice_n_dice$in_;
  wire   [   0:0] slice_n_dice$clk;
  wire   [   3:0] slice_n_dice$len;
  wire   [   3:0] slice_n_dice$offset;
  wire   [   0:0] slice_n_dice$reset;
  wire   [ 127:0] slice_n_dice$out;

  SliceNDicePRTL_0x2eda6214b7c9539 slice_n_dice
  (
    .in_    ( slice_n_dice$in_ ),
    .clk    ( slice_n_dice$clk ),
    .len    ( slice_n_dice$len ),
    .offset ( slice_n_dice$offset ),
    .reset  ( slice_n_dice$reset ),
    .out    ( slice_n_dice$out )
  );

  // cachereq_addr_reg temporaries
  wire   [   0:0] cachereq_addr_reg$reset;
  wire   [   0:0] cachereq_addr_reg$en;
  wire   [   0:0] cachereq_addr_reg$clk;
  wire   [  31:0] cachereq_addr_reg$in_;
  wire   [  31:0] cachereq_addr_reg$out;

  RegEnRst_0x3857337130dc0828 cachereq_addr_reg
  (
    .reset ( cachereq_addr_reg$reset ),
    .en    ( cachereq_addr_reg$en ),
    .clk   ( cachereq_addr_reg$clk ),
    .in_   ( cachereq_addr_reg$in_ ),
    .out   ( cachereq_addr_reg$out )
  );

  // data_read_mux temporaries
  wire   [   0:0] data_read_mux$reset;
  wire   [ 127:0] data_read_mux$in_$000;
  wire   [ 127:0] data_read_mux$in_$001;
  wire   [   0:0] data_read_mux$clk;
  wire   [   0:0] data_read_mux$sel;
  wire   [ 127:0] data_read_mux$out;

  Mux_0x5af2f539a1a7deea data_read_mux
  (
    .reset   ( data_read_mux$reset ),
    .in_$000 ( data_read_mux$in_$000 ),
    .in_$001 ( data_read_mux$in_$001 ),
    .clk     ( data_read_mux$clk ),
    .sel     ( data_read_mux$sel ),
    .out     ( data_read_mux$out )
  );

  // cachereq_opaque_reg temporaries
  wire   [   0:0] cachereq_opaque_reg$reset;
  wire   [   0:0] cachereq_opaque_reg$en;
  wire   [   0:0] cachereq_opaque_reg$clk;
  wire   [   7:0] cachereq_opaque_reg$in_;
  wire   [   7:0] cachereq_opaque_reg$out;

  RegEnRst_0x513e5624ff809260 cachereq_opaque_reg
  (
    .reset ( cachereq_opaque_reg$reset ),
    .en    ( cachereq_opaque_reg$en ),
    .clk   ( cachereq_opaque_reg$clk ),
    .in_   ( cachereq_opaque_reg$in_ ),
    .out   ( cachereq_opaque_reg$out )
  );

  // gen_write_data temporaries
  wire   [ 127:0] gen_write_data$in_;
  wire   [   0:0] gen_write_data$clk;
  wire   [   3:0] gen_write_data$offset;
  wire   [   0:0] gen_write_data$reset;
  wire   [ 127:0] gen_write_data$out;

  GenWriteDataPRTL_0x472c29e762348c17 gen_write_data
  (
    .in_    ( gen_write_data$in_ ),
    .clk    ( gen_write_data$clk ),
    .offset ( gen_write_data$offset ),
    .reset  ( gen_write_data$reset ),
    .out    ( gen_write_data$out )
  );

  // read_data_reg temporaries
  wire   [   0:0] read_data_reg$reset;
  wire   [   0:0] read_data_reg$en;
  wire   [   0:0] read_data_reg$clk;
  wire   [ 127:0] read_data_reg$in_;
  wire   [ 127:0] read_data_reg$out;

  RegEnRst_0x150bbb1e4e9ba308 read_data_reg
  (
    .reset ( read_data_reg$reset ),
    .en    ( read_data_reg$en ),
    .clk   ( read_data_reg$clk ),
    .in_   ( read_data_reg$in_ ),
    .out   ( read_data_reg$out )
  );

  // amo_max_mux temporaries
  wire   [   0:0] amo_max_mux$reset;
  wire   [  31:0] amo_max_mux$in_$000;
  wire   [  31:0] amo_max_mux$in_$001;
  wire   [   0:0] amo_max_mux$clk;
  wire   [   0:0] amo_max_mux$sel;
  wire   [  31:0] amo_max_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_max_mux
  (
    .reset   ( amo_max_mux$reset ),
    .in_$000 ( amo_max_mux$in_$000 ),
    .in_$001 ( amo_max_mux$in_$001 ),
    .clk     ( amo_max_mux$clk ),
    .sel     ( amo_max_mux$sel ),
    .out     ( amo_max_mux$out )
  );

  // cachereq_type_reg temporaries
  wire   [   0:0] cachereq_type_reg$reset;
  wire   [   0:0] cachereq_type_reg$en;
  wire   [   0:0] cachereq_type_reg$clk;
  wire   [   3:0] cachereq_type_reg$in_;
  wire   [   3:0] cachereq_type_reg$out;

  RegEnRst_0x1c9f2c4521ce0fbc cachereq_type_reg
  (
    .reset ( cachereq_type_reg$reset ),
    .en    ( cachereq_type_reg$en ),
    .clk   ( cachereq_type_reg$clk ),
    .in_   ( cachereq_type_reg$in_ ),
    .out   ( cachereq_type_reg$out )
  );

  // tag_mux temporaries
  wire   [   0:0] tag_mux$reset;
  wire   [  27:0] tag_mux$in_$000;
  wire   [  27:0] tag_mux$in_$001;
  wire   [   0:0] tag_mux$clk;
  wire   [   0:0] tag_mux$sel;
  wire   [  27:0] tag_mux$out;

  Mux_0xb6e139e9f208756 tag_mux
  (
    .reset   ( tag_mux$reset ),
    .in_$000 ( tag_mux$in_$000 ),
    .in_$001 ( tag_mux$in_$001 ),
    .clk     ( tag_mux$clk ),
    .sel     ( tag_mux$sel ),
    .out     ( tag_mux$out )
  );

  // memresp_data_reg temporaries
  wire   [   0:0] memresp_data_reg$reset;
  wire   [   0:0] memresp_data_reg$en;
  wire   [   0:0] memresp_data_reg$clk;
  wire   [ 127:0] memresp_data_reg$in_;
  wire   [ 127:0] memresp_data_reg$out;

  RegEnRst_0x150bbb1e4e9ba308 memresp_data_reg
  (
    .reset ( memresp_data_reg$reset ),
    .en    ( memresp_data_reg$en ),
    .clk   ( memresp_data_reg$clk ),
    .in_   ( memresp_data_reg$in_ ),
    .out   ( memresp_data_reg$out )
  );

  // amo_maxu_mux temporaries
  wire   [   0:0] amo_maxu_mux$reset;
  wire   [  31:0] amo_maxu_mux$in_$000;
  wire   [  31:0] amo_maxu_mux$in_$001;
  wire   [   0:0] amo_maxu_mux$clk;
  wire   [   0:0] amo_maxu_mux$sel;
  wire   [  31:0] amo_maxu_mux$out;

  Mux_0x7e8c65f0610ab9ca amo_maxu_mux
  (
    .reset   ( amo_maxu_mux$reset ),
    .in_$000 ( amo_maxu_mux$in_$000 ),
    .in_$001 ( amo_maxu_mux$in_$001 ),
    .clk     ( amo_maxu_mux$clk ),
    .sel     ( amo_maxu_mux$sel ),
    .out     ( amo_maxu_mux$out )
  );

  // signal connections
  assign amo_max_mux$clk            = clk;
  assign amo_max_mux$in_$000        = read_data_word;
  assign amo_max_mux$in_$001        = cachereq_data_word;
  assign amo_max_mux$reset          = reset;
  assign amo_max_mux$sel            = amo_max_sel;
  assign amo_maxu_mux$clk           = clk;
  assign amo_maxu_mux$in_$000       = read_data_word;
  assign amo_maxu_mux$in_$001       = cachereq_data_word;
  assign amo_maxu_mux$reset         = reset;
  assign amo_maxu_mux$sel           = amo_maxu_sel;
  assign amo_min_mux$clk            = clk;
  assign amo_min_mux$in_$000        = read_data_word;
  assign amo_min_mux$in_$001        = cachereq_data_word;
  assign amo_min_mux$reset          = reset;
  assign amo_min_mux$sel            = amo_min_sel;
  assign amo_minu_mux$clk           = clk;
  assign amo_minu_mux$in_$000       = read_data_word;
  assign amo_minu_mux$in_$001       = cachereq_data_word;
  assign amo_minu_mux$reset         = reset;
  assign amo_minu_mux$sel           = amo_minu_sel;
  assign amo_sel_mux$clk            = clk;
  assign amo_sel_mux$in_$000        = cachereq_data_reg_out_add;
  assign amo_sel_mux$in_$001        = cachereq_data_reg_out_and;
  assign amo_sel_mux$in_$002        = cachereq_data_reg_out_or;
  assign amo_sel_mux$in_$003        = cachereq_data_reg_out_swap;
  assign amo_sel_mux$in_$004        = cachereq_data_reg_out_min;
  assign amo_sel_mux$in_$005        = cachereq_data_reg_out_minu;
  assign amo_sel_mux$in_$006        = cachereq_data_reg_out_max;
  assign amo_sel_mux$in_$007        = cachereq_data_reg_out_maxu;
  assign amo_sel_mux$in_$008        = cachereq_data_reg_out_xor;
  assign amo_sel_mux$reset          = reset;
  assign amo_sel_mux$sel            = amo_sel;
  assign cachereq_addr              = cachereq_addr_reg$out;
  assign cachereq_addr_reg$clk      = clk;
  assign cachereq_addr_reg$en       = cachereq_en;
  assign cachereq_addr_reg$in_      = cachereq_msg[163:132];
  assign cachereq_addr_reg$reset    = reset;
  assign cachereq_data_reg$clk      = clk;
  assign cachereq_data_reg$en       = cachereq_en;
  assign cachereq_data_reg$in_      = cachereq_msg[127:0];
  assign cachereq_data_reg$reset    = reset;
  assign cachereq_data_reg_out      = cachereq_data_reg$out;
  assign cachereq_len_reg$clk       = clk;
  assign cachereq_len_reg$en        = cachereq_en;
  assign cachereq_len_reg$in_       = cachereq_msg[131:128];
  assign cachereq_len_reg$reset     = reset;
  assign cachereq_len_reg_out       = cachereq_len_reg$out;
  assign cachereq_opaque_reg$clk    = clk;
  assign cachereq_opaque_reg$en     = cachereq_en;
  assign cachereq_opaque_reg$in_    = cachereq_msg[171:164];
  assign cachereq_opaque_reg$reset  = reset;
  assign cachereq_type              = cachereq_type_reg$out;
  assign cachereq_type_reg$clk      = clk;
  assign cachereq_type_reg$en       = cachereq_en;
  assign cachereq_type_reg$in_      = cachereq_msg[175:172];
  assign cachereq_type_reg$reset    = reset;
  assign cacheresp_msg[141:134]     = cachereq_opaque_reg$out;
  assign cachresp_mux$clk           = clk;
  assign cachresp_mux$in_$000       = cachereq_data_reg_out;
  assign cachresp_mux$in_$001       = amo_out;
  assign cachresp_mux$reset         = reset;
  assign cachresp_mux$sel           = is_amo;
  assign data_array_0$addr          = cur_cachereq_idx;
  assign data_array_0$ce            = sram_data_0_en;
  assign data_array_0$clk           = clk;
  assign data_array_0$in_           = refill_mux$out;
  assign data_array_0$reset         = reset;
  assign data_array_0$we            = data_array_0_wen;
  assign data_array_0$wmask         = data_array_wben;
  assign data_array_0_read_out      = data_array_0$out;
  assign data_array_1$addr          = cur_cachereq_idx;
  assign data_array_1$ce            = sram_data_1_en;
  assign data_array_1$clk           = clk;
  assign data_array_1$in_           = refill_mux$out;
  assign data_array_1$reset         = reset;
  assign data_array_1$we            = data_array_1_wen;
  assign data_array_1$wmask         = data_array_wben;
  assign data_array_1_read_out      = data_array_1$out;
  assign data_read_mux$clk          = clk;
  assign data_read_mux$in_$000      = data_array_0_read_out;
  assign data_read_mux$in_$001      = data_array_1_read_out;
  assign data_read_mux$reset        = reset;
  assign data_read_mux$sel          = way_sel_current;
  assign gen_write_data$clk         = clk;
  assign gen_write_data$in_         = cachresp_mux$out;
  assign gen_write_data$offset      = cachereq_offset;
  assign gen_write_data$reset       = reset;
  assign int_read_data              = skip_read_data_mux$out;
  assign memreq_msg[127:0]          = read_data_reg$out;
  assign memreq_type_mux_out        = tag_mux$out;
  assign memresp_data_reg$clk       = clk;
  assign memresp_data_reg$en        = memresp_en;
  assign memresp_data_reg$in_       = memresp_msg[127:0];
  assign memresp_data_reg$reset     = reset;
  assign read_data                  = slice_n_dice$out;
  assign read_data_reg$clk          = clk;
  assign read_data_reg$en           = read_data_reg_en;
  assign read_data_reg$in_          = data_read_mux$out;
  assign read_data_reg$reset        = reset;
  assign read_tag_reg$clk           = clk;
  assign read_tag_reg$en            = read_tag_reg_en;
  assign read_tag_reg$in_           = way_sel_mux$out;
  assign read_tag_reg$reset         = reset;
  assign refill_mux$clk             = clk;
  assign refill_mux$in_$000         = gen_write_data$out;
  assign refill_mux$in_$001         = memresp_msg[127:0];
  assign refill_mux$reset           = reset;
  assign refill_mux$sel             = is_refill;
  assign skip_read_data_mux$clk     = clk;
  assign skip_read_data_mux$in_$000 = read_data_reg$out;
  assign skip_read_data_mux$in_$001 = data_read_mux$out;
  assign skip_read_data_mux$reset   = reset;
  assign skip_read_data_mux$sel     = skip_read_data_reg;
  assign slice_n_dice$clk           = clk;
  assign slice_n_dice$in_           = int_read_data;
  assign slice_n_dice$len           = cachereq_len_reg_out;
  assign slice_n_dice$offset        = cachereq_offset;
  assign slice_n_dice$reset         = reset;
  assign tag_array_0$addr           = cur_cachereq_idx;
  assign tag_array_0$ce             = sram_tag_0_en;
  assign tag_array_0$clk            = clk;
  assign tag_array_0$in_            = temp_cachereq_tag;
  assign tag_array_0$reset          = reset;
  assign tag_array_0$we             = tag_array_0_wen;
  assign tag_array_0$wmask          = 4'd15;
  assign tag_array_0_read_out       = tag_array_0$out;
  assign tag_array_1$addr           = cur_cachereq_idx;
  assign tag_array_1$ce             = sram_tag_1_en;
  assign tag_array_1$clk            = clk;
  assign tag_array_1$in_            = temp_cachereq_tag;
  assign tag_array_1$reset          = reset;
  assign tag_array_1$we             = tag_array_1_wen;
  assign tag_array_1$wmask          = 4'd15;
  assign tag_array_1_read_out       = tag_array_1$out;
  assign tag_compare_0$clk          = clk;
  assign tag_compare_0$in0          = cachereq_tag;
  assign tag_compare_0$in1          = tag_array_0_read_out[27:0];
  assign tag_compare_0$reset        = reset;
  assign tag_compare_1$clk          = clk;
  assign tag_compare_1$in0          = cachereq_tag;
  assign tag_compare_1$in1          = tag_array_1_read_out[27:0];
  assign tag_compare_1$reset        = reset;
  assign tag_match_0                = tag_compare_0$out;
  assign tag_match_1                = tag_compare_1$out;
  assign tag_mux$clk                = clk;
  assign tag_mux$in_$000            = cachereq_tag;
  assign tag_mux$in_$001            = read_tag_reg$out;
  assign tag_mux$reset              = reset;
  assign tag_mux$sel                = memreq_type[0];
  assign way_sel_mux$clk            = clk;
  assign way_sel_mux$in_$000        = tag_array_0_read_out[27:0];
  assign way_sel_mux$in_$001        = tag_array_1_read_out[27:0];
  assign way_sel_mux$reset          = reset;
  assign way_sel_mux$sel            = way_sel_current;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_amo_data():
  //       s.cachereq_data_word.value = s.cachereq_data_reg_out[0:dbw]
  //       s.read_data_word    .value = s.read_data            [0:dbw]

  // logic for gen_amo_data()
  always @ (*) begin
    cachereq_data_word = cachereq_data_reg_out[(dbw)-1:0];
    read_data_word = read_data[(dbw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_connect_wires():
  //       s.cachereq_data_reg_out_add.value   = s.cachereq_data_word + s.read_data_word
  //       s.cachereq_data_reg_out_and.value   = s.cachereq_data_word & s.read_data_word
  //       s.cachereq_data_reg_out_or.value    = s.cachereq_data_word | s.read_data_word
  //       s.cachereq_data_reg_out_swap.value  = s.cachereq_data_word
  //       s.cachereq_data_reg_out_min.value   = s.amo_min_mux.out
  //       s.cachereq_data_reg_out_minu.value  = s.amo_minu_mux.out
  //       s.cachereq_data_reg_out_max.value   = s.amo_max_mux.out
  //       s.cachereq_data_reg_out_maxu.value  = s.amo_maxu_mux.out
  //       s.cachereq_data_reg_out_xor.value   = s.cachereq_data_word ^ s.read_data_word

  // logic for comb_connect_wires()
  always @ (*) begin
    cachereq_data_reg_out_add = (cachereq_data_word+read_data_word);
    cachereq_data_reg_out_and = (cachereq_data_word&read_data_word);
    cachereq_data_reg_out_or = (cachereq_data_word|read_data_word);
    cachereq_data_reg_out_swap = cachereq_data_word;
    cachereq_data_reg_out_min = amo_min_mux$out;
    cachereq_data_reg_out_minu = amo_minu_mux$out;
    cachereq_data_reg_out_max = amo_max_mux$out;
    cachereq_data_reg_out_maxu = amo_maxu_mux$out;
    cachereq_data_reg_out_xor = (cachereq_data_word^read_data_word);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_gen_amo_output():
  //       s.amo_out       .value = 0
  //       s.amo_out[0:dbw].value = s.amo_sel_mux.out

  // logic for comb_gen_amo_output()
  always @ (*) begin
    amo_out = 0;
    amo_out[(dbw)-1:0] = amo_sel_mux$out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cachereq_offset():
  //       s.cachereq_offset.value = s.cachereq_addr[0:m_len_bw]

  // logic for comb_cachereq_offset()
  always @ (*) begin
    cachereq_offset = cachereq_addr[(m_len_bw)-1:0];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_replicate():
  //       s.cachereq_tag.value = s.cachereq_addr_reg.out[4:abw]
  //       s.cachereq_idx.value = s.cachereq_addr_reg.out[4:idw_off]

  // logic for comb_replicate()
  always @ (*) begin
    cachereq_tag = cachereq_addr_reg$out[(abw)-1:4];
    cachereq_idx = cachereq_addr_reg$out[(idw_off)-1:4];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_tag():
  //       s.cachereq_msg_addr.value = s.cachereq_msg.addr
  //       s.temp_cachereq_tag.value = concat( Bits(4, 0), s.cachereq_tag )
  //       if s.cachereq_en:
  //         s.cur_cachereq_idx.value = s.cachereq_msg_addr[4:idw_off]
  //       else:
  //         s.cur_cachereq_idx.value  = s.cachereq_idx
  //
  //       # Shunning: This data_array_x_wen is built up in the same way as
  //       #           tag_array_x_wen. Why is this guy here, but the tag one is in ctrl?
  //       s.data_array_0_wen.value =  (s.data_array_wen & (s.way_sel_current == 0))
  //       s.data_array_1_wen.value =  (s.data_array_wen & (s.way_sel_current == 1))
  //       s.sram_tag_0_en.value    =  (s.tag_array_0_wen | s.tag_array_0_ren)
  //       s.sram_tag_1_en.value    =  (s.tag_array_1_wen | s.tag_array_1_ren)
  //       s.sram_data_0_en.value   =  ((s.data_array_wen & (s.way_sel_current==0)) | s.data_array_ren)
  //       s.sram_data_1_en.value   =  ((s.data_array_wen & (s.way_sel_current==1)) | s.data_array_ren)

  // logic for comb_tag()
  always @ (*) begin
    cachereq_msg_addr = cachereq_msg[(164)-1:132];
    temp_cachereq_tag = { 4'd0,cachereq_tag };
    if (cachereq_en) begin
      cur_cachereq_idx = cachereq_msg_addr[(idw_off)-1:4];
    end
    else begin
      cur_cachereq_idx = cachereq_idx;
    end
    data_array_0_wen = (data_array_wen&(way_sel_current == 0));
    data_array_1_wen = (data_array_wen&(way_sel_current == 1));
    sram_tag_0_en = (tag_array_0_wen|tag_array_0_ren);
    sram_tag_1_en = (tag_array_1_wen|tag_array_1_ren);
    sram_data_0_en = ((data_array_wen&(way_sel_current == 0))|data_array_ren);
    sram_data_1_en = ((data_array_wen&(way_sel_current == 1))|data_array_ren);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_addr_evict():
  //       s.memreq_addr.value = concat(s.memreq_type_mux_out, Bits(4, 0))

  // logic for comb_addr_evict()
  always @ (*) begin
    memreq_addr = { memreq_type_mux_out,4'd0 };
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_addr_refill():
  //
  //       if   s.cacheresp_type == MemReqMsg.TYPE_READ      : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_ADD   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_AND   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_OR    : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_SWAP  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MIN   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MINU  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAX   : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_MAXU  : s.cacheresp_msg.data.value = s.read_data
  //       elif s.cacheresp_type == MemReqMsg.TYPE_AMO_XOR   : s.cacheresp_msg.data.value = s.read_data
  //       else                                              : s.cacheresp_msg.data.value = 0

  // logic for comb_addr_refill()
  always @ (*) begin
    if ((cacheresp_type == TYPE_READ)) begin
      cacheresp_msg[(128)-1:0] = read_data;
    end
    else begin
      if ((cacheresp_type == TYPE_AMO_ADD)) begin
        cacheresp_msg[(128)-1:0] = read_data;
      end
      else begin
        if ((cacheresp_type == TYPE_AMO_AND)) begin
          cacheresp_msg[(128)-1:0] = read_data;
        end
        else begin
          if ((cacheresp_type == TYPE_AMO_OR)) begin
            cacheresp_msg[(128)-1:0] = read_data;
          end
          else begin
            if ((cacheresp_type == TYPE_AMO_SWAP)) begin
              cacheresp_msg[(128)-1:0] = read_data;
            end
            else begin
              if ((cacheresp_type == TYPE_AMO_MIN)) begin
                cacheresp_msg[(128)-1:0] = read_data;
              end
              else begin
                if ((cacheresp_type == TYPE_AMO_MINU)) begin
                  cacheresp_msg[(128)-1:0] = read_data;
                end
                else begin
                  if ((cacheresp_type == TYPE_AMO_MAX)) begin
                    cacheresp_msg[(128)-1:0] = read_data;
                  end
                  else begin
                    if ((cacheresp_type == TYPE_AMO_MAXU)) begin
                      cacheresp_msg[(128)-1:0] = read_data;
                    end
                    else begin
                      if ((cacheresp_type == TYPE_AMO_XOR)) begin
                        cacheresp_msg[(128)-1:0] = read_data;
                      end
                      else begin
                        cacheresp_msg[(128)-1:0] = 0;
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

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cacherespmsgpack():
  //       s.cacheresp_msg.type_.value = s.cacheresp_type
  //       s.cacheresp_msg.test.value  = concat( Bits( 1, 0 ), s.cacheresp_hit )
  //       s.cacheresp_msg.len.value   = s.cachereq_len_reg_out

  // logic for comb_cacherespmsgpack()
  always @ (*) begin
    cacheresp_msg[(146)-1:142] = cacheresp_type;
    cacheresp_msg[(134)-1:132] = { 1'd0,cacheresp_hit };
    cacheresp_msg[(132)-1:128] = cachereq_len_reg_out;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_memrespmsgpack():
  //       s.memreq_msg.type_.value    = s.memreq_type
  //       s.memreq_msg.opaque.value   = 0
  //       s.memreq_msg.addr.value     = s.memreq_addr
  //       s.memreq_msg.len.value      = 0

  // logic for comb_memrespmsgpack()
  always @ (*) begin
    memreq_msg[(176)-1:172] = memreq_type;
    memreq_msg[(172)-1:164] = 0;
    memreq_msg[(164)-1:132] = memreq_addr;
    memreq_msg[(132)-1:128] = 0;
  end


endmodule // BlockingCacheDpathPRTL_0x6b511b3b41602acf
`default_nettype wire

//-----------------------------------------------------------------------------
// SliceNDicePRTL_0x2eda6214b7c9539
//-----------------------------------------------------------------------------
// num_in_bytes: 16
// num_out_bytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SliceNDicePRTL_0x2eda6214b7c9539
(
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_,
  input  wire [   3:0] len,
  input  wire [   3:0] offset,
  output reg  [ 127:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [ 127:0] int_in_;
  reg    [ 127:0] int_mask;
  reg    [ 127:0] int_out;
  reg    [   3:0] len_d;
  reg    [   6:0] len_shft;
  reg    [   6:0] offset_shft;

  // localparam declarations
  localparam in_lnb = 4;
  localparam num_out_bits = 128;
  localparam out_lnb = 4;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_mask():
  //
  //       # Force ones in all bits
  //       s.int_mask.value = 0
  //       s.int_mask.value = s.int_mask - 1
  //
  //       # Shift the mask left by one byte
  //       s.int_mask.value = s.int_mask << 8
  //
  //       # Decrement the len and shift by the resulting value
  //       s.len_d.value = s.len - 1
  //
  //       # Multiply the shift amount by 8
  //       s.len_shft           .value = 0
  //       s.len_shft[0:out_lnb].value = s.len_d
  //       s.len_shft           .value = s.len_shft << 3
  //
  //       # Generate Offset
  //       s.offset_shft          .value = 0
  //       s.offset_shft[0:in_lnb].value = s.offset
  //       s.offset_shft          .value = s.offset_shft << 3
  //
  //       # Re-orient the input bits based on the offset
  //       s.int_in_.value = s.in_ >> s.offset_shft
  //
  //       # Shift by the resulting value
  //       s.int_mask.value = s.int_mask << ( s.len_shft )
  //
  //       # Generate output
  //       s.int_out.value = (~s.int_mask) & s.int_in_
  //
  //       # Slice to the output
  //       s.out.value = s.int_out[0:num_out_bits]

  // logic for gen_mask()
  always @ (*) begin
    int_mask = 0;
    int_mask = (int_mask-1);
    int_mask = (int_mask<<8);
    len_d = (len-1);
    len_shft = 0;
    len_shft[(out_lnb)-1:0] = len_d;
    len_shft = (len_shft<<3);
    offset_shft = 0;
    offset_shft[(in_lnb)-1:0] = offset;
    offset_shft = (offset_shft<<3);
    int_in_ = (in_>>offset_shft);
    int_mask = (int_mask<<len_shft);
    int_out = (~int_mask&int_in_);
    out = int_out[(num_out_bits)-1:0];
  end


endmodule // SliceNDicePRTL_0x2eda6214b7c9539
`default_nettype wire

//-----------------------------------------------------------------------------
// GenWriteDataPRTL_0x472c29e762348c17
//-----------------------------------------------------------------------------
// num_in_bytes: 16
// num_out_bytes: 16
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module GenWriteDataPRTL_0x472c29e762348c17
(
  input  wire [   0:0] clk,
  input  wire [ 127:0] in_,
  input  wire [   3:0] offset,
  output reg  [ 127:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [ 127:0] int_in_;
  reg    [ 127:0] int_out;
  reg    [   6:0] offset_shft;

  // localparam declarations
  localparam num_in_bits = 128;
  localparam out_lnb = 4;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def gen_out():
  //
  //       # Get input in a more spacier wire
  //       s.int_in_               .value = 0
  //       s.int_in_[0:num_in_bits].value = s.in_
  //
  //       # Offset generation
  //       s.offset_shft           .value = 0
  //       s.offset_shft[0:out_lnb].value = s.offset
  //
  //       # Re-orient the input bits based on the offset
  //       s.int_out.value = s.int_in_ << (s.offset_shft << 3)
  //
  //       # Assign the output
  //       s.out.value = s.int_out

  // logic for gen_out()
  always @ (*) begin
    int_in_ = 0;
    int_in_[(num_in_bits)-1:0] = in_;
    offset_shft = 0;
    offset_shft[(out_lnb)-1:0] = offset;
    int_out = (int_in_<<(offset_shft<<3));
    out = int_out;
  end


endmodule // GenWriteDataPRTL_0x472c29e762348c17
`default_nettype wire

//-----------------------------------------------------------------------------
// BloomFilterXcel_0x6aa8c82a20a95749
//-----------------------------------------------------------------------------
// snoop_mem_msg: <ifcs.MemMsg.MemMsg object at 0x7f9ba259c4d0>
// csr_begin: 0
// num_hash_funs: 3
// num_bits_exponent: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BloomFilterXcel_0x6aa8c82a20a95749
(
  input  wire [   0:0] clk,
  input  wire [  77:0] memreq_snoop_msg,
  output wire [   0:0] memreq_snoop_rdy,
  input  wire [   0:0] memreq_snoop_val,
  input  wire [   0:0] reset,
  input  wire [  37:0] xcelreq_msg,
  output wire [   0:0] xcelreq_rdy,
  input  wire [   0:0] xcelreq_val,
  output reg  [  32:0] xcelresp_msg,
  input  wire [   0:0] xcelresp_rdy,
  output wire [   0:0] xcelresp_val
);

  // register declarations
  reg    [   0:0] bloom_filter$check_out_rdy;
  reg    [  33:0] bloomreq_q$enq_msg;
  reg    [   0:0] bloomreq_q$enq_val;
  reg    [  31:0] check_res$in_;
  reg    [  31:0] check_val$in_;
  reg    [  31:0] clear$in_;
  reg    [   0:0] snoop_q$deq_rdy;
  reg    [  31:0] snoop_q$enq_msg;
  reg    [   0:0] snoop_q$enq_val;
  reg    [  31:0] status$in_;

  // localparam declarations
  localparam CHECK_RESULT_INV = 0;
  localparam CHECK_RESULT_NO = 2;
  localparam CHECK_RESULT_YES = 1;
  localparam CHECK_VALUE_DONE = 0;
  localparam CLEAR_DONE = 0;
  localparam CLEAR_REQUESTED = 1;
  localparam CSR_OFFSET_CHECK_RES = 2;
  localparam CSR_OFFSET_CHECK_VAL = 1;
  localparam CSR_OFFSET_CLEAR = 3;
  localparam CSR_OFFSET_STATUS = 0;
  localparam STATUS_ENABLED_R = 1;
  localparam STATUS_ENABLED_RW = 3;
  localparam STATUS_ENABLED_W = 2;
  localparam STATUS_EXCEPTION = 4;
  localparam TYPE_CHECK = 1;
  localparam TYPE_CLEAR = 2;
  localparam TYPE_INSERT = 0;
  localparam TYPE_READ = 0;
  localparam TYPE_WRITE = 1;
  localparam csr_begin = 0;

  // check_val temporaries
  wire   [   0:0] check_val$reset;
  wire   [   0:0] check_val$clk;
  wire   [  31:0] check_val$out;

  RegRst_0x3857337130dc0828 check_val
  (
    .reset ( check_val$reset ),
    .in_   ( check_val$in_ ),
    .clk   ( check_val$clk ),
    .out   ( check_val$out )
  );

  // snoop_q temporaries
  wire   [   0:0] snoop_q$clk;
  wire   [   0:0] snoop_q$reset;
  wire   [   0:0] snoop_q$enq_rdy;
  wire   [   1:0] snoop_q$num_free_entries;
  wire   [  31:0] snoop_q$deq_msg;
  wire   [   0:0] snoop_q$deq_val;

  NormalQueue_0x284a9040bb906fd0 snoop_q
  (
    .clk              ( snoop_q$clk ),
    .enq_msg          ( snoop_q$enq_msg ),
    .enq_val          ( snoop_q$enq_val ),
    .reset            ( snoop_q$reset ),
    .deq_rdy          ( snoop_q$deq_rdy ),
    .enq_rdy          ( snoop_q$enq_rdy ),
    .num_free_entries ( snoop_q$num_free_entries ),
    .deq_msg          ( snoop_q$deq_msg ),
    .deq_val          ( snoop_q$deq_val )
  );

  // check_res temporaries
  wire   [   0:0] check_res$reset;
  wire   [   0:0] check_res$clk;
  wire   [  31:0] check_res$out;

  RegRst_0x3857337130dc0828 check_res
  (
    .reset ( check_res$reset ),
    .in_   ( check_res$in_ ),
    .clk   ( check_res$clk ),
    .out   ( check_res$out )
  );

  // status temporaries
  wire   [   0:0] status$reset;
  wire   [   0:0] status$clk;
  wire   [  31:0] status$out;

  RegRst_0x3857337130dc0828 status
  (
    .reset ( status$reset ),
    .in_   ( status$in_ ),
    .clk   ( status$clk ),
    .out   ( status$out )
  );

  // bloomreq_q temporaries
  wire   [   0:0] bloomreq_q$clk;
  wire   [   0:0] bloomreq_q$reset;
  wire   [   0:0] bloomreq_q$deq_rdy;
  wire   [   0:0] bloomreq_q$enq_rdy;
  wire   [   1:0] bloomreq_q$num_free_entries;
  wire   [  33:0] bloomreq_q$deq_msg;
  wire   [   0:0] bloomreq_q$deq_val;

  NormalQueue_0x7aacac805eb4ec3f bloomreq_q
  (
    .clk              ( bloomreq_q$clk ),
    .enq_msg          ( bloomreq_q$enq_msg ),
    .enq_val          ( bloomreq_q$enq_val ),
    .reset            ( bloomreq_q$reset ),
    .deq_rdy          ( bloomreq_q$deq_rdy ),
    .enq_rdy          ( bloomreq_q$enq_rdy ),
    .num_free_entries ( bloomreq_q$num_free_entries ),
    .deq_msg          ( bloomreq_q$deq_msg ),
    .deq_val          ( bloomreq_q$deq_val )
  );

  // clear temporaries
  wire   [   0:0] clear$reset;
  wire   [   0:0] clear$clk;
  wire   [  31:0] clear$out;

  RegRst_0x3857337130dc0828 clear
  (
    .reset ( clear$reset ),
    .in_   ( clear$in_ ),
    .clk   ( clear$clk ),
    .out   ( clear$out )
  );

  // xcelreq_q temporaries
  wire   [   0:0] xcelreq_q$clk;
  wire   [  37:0] xcelreq_q$enq_msg;
  wire   [   0:0] xcelreq_q$enq_val;
  wire   [   0:0] xcelreq_q$reset;
  wire   [   0:0] xcelreq_q$deq_rdy;
  wire   [   0:0] xcelreq_q$enq_rdy;
  wire   [   1:0] xcelreq_q$num_free_entries;
  wire   [  37:0] xcelreq_q$deq_msg;
  wire   [   0:0] xcelreq_q$deq_val;

  NormalQueue_0x37f180039b40e5fd xcelreq_q
  (
    .clk              ( xcelreq_q$clk ),
    .enq_msg          ( xcelreq_q$enq_msg ),
    .enq_val          ( xcelreq_q$enq_val ),
    .reset            ( xcelreq_q$reset ),
    .deq_rdy          ( xcelreq_q$deq_rdy ),
    .enq_rdy          ( xcelreq_q$enq_rdy ),
    .num_free_entries ( xcelreq_q$num_free_entries ),
    .deq_msg          ( xcelreq_q$deq_msg ),
    .deq_val          ( xcelreq_q$deq_val )
  );

  // bloom_filter temporaries
  wire   [  33:0] bloom_filter$in__msg;
  wire   [   0:0] bloom_filter$in__val;
  wire   [   0:0] bloom_filter$clk;
  wire   [   0:0] bloom_filter$reset;
  wire   [   0:0] bloom_filter$in__rdy;
  wire   [   0:0] bloom_filter$check_out_msg;
  wire   [   0:0] bloom_filter$check_out_val;

  BloomFilterParallel_0x12ed5f3412fae46f bloom_filter
  (
    .in__msg       ( bloom_filter$in__msg ),
    .in__val       ( bloom_filter$in__val ),
    .clk           ( bloom_filter$clk ),
    .check_out_rdy ( bloom_filter$check_out_rdy ),
    .reset         ( bloom_filter$reset ),
    .in__rdy       ( bloom_filter$in__rdy ),
    .check_out_msg ( bloom_filter$check_out_msg ),
    .check_out_val ( bloom_filter$check_out_val )
  );

  // signal connections
  assign bloom_filter$clk     = clk;
  assign bloom_filter$in__msg = bloomreq_q$deq_msg;
  assign bloom_filter$in__val = bloomreq_q$deq_val;
  assign bloom_filter$reset   = reset;
  assign bloomreq_q$clk       = clk;
  assign bloomreq_q$deq_rdy   = bloom_filter$in__rdy;
  assign bloomreq_q$reset     = reset;
  assign check_res$clk        = clk;
  assign check_res$reset      = reset;
  assign check_val$clk        = clk;
  assign check_val$reset      = reset;
  assign clear$clk            = clk;
  assign clear$reset          = reset;
  assign memreq_snoop_rdy     = 1'd1;
  assign snoop_q$clk          = clk;
  assign snoop_q$reset        = reset;
  assign status$clk           = clk;
  assign status$reset         = reset;
  assign xcelreq_q$clk        = clk;
  assign xcelreq_q$deq_rdy    = xcelresp_rdy;
  assign xcelreq_q$enq_msg    = xcelreq_msg;
  assign xcelreq_q$enq_val    = xcelreq_val;
  assign xcelreq_q$reset      = reset;
  assign xcelreq_rdy          = xcelreq_q$enq_rdy;
  assign xcelresp_msg[32:32]  = xcelreq_q$deq_msg[37:37];
  assign xcelresp_val         = xcelreq_q$deq_val;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb():
  //       s.status.in_.value = s.status.out
  //       s.check_val.in_.value = s.check_val.out
  //       s.check_res.in_.value = s.check_res.out
  //       s.clear.in_.value = s.clear.out
  //       s.xcelresp.msg.data.value = 0
  //       s.bloomreq_q.enq.val.value = 0
  //       s.bloomreq_q.enq.msg.value = 0
  //       s.snoop_q.deq.rdy.value = 0
  //       s.snoop_q.enq.val.value = 0
  //       s.snoop_q.enq.msg.value = 0
  //       s.bloom_filter.check_out.rdy.value = 1
  //
  //       # Enqueueing the Bloom Request Queue
  //
  //       if s.bloomreq_q.enq.rdy:
  //         if s.clear.out == s.CLEAR_REQUESTED:
  //           s.bloomreq_q.enq.val.value = 1
  //           s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_CLEAR
  //           s.bloomreq_q.enq.msg.word.value = 0
  //           s.clear.in_.value = s.CLEAR_DONE
  //
  //         elif s.check_val.out != s.CHECK_VALUE_DONE:
  //           s.bloomreq_q.enq.val.value = 1
  //           s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_CHECK
  //           s.bloomreq_q.enq.msg.word.value = s.check_val.out
  //           s.check_val.in_.value = s.CHECK_VALUE_DONE
  //
  //         elif s.snoop_q.deq.val:
  //           s.bloomreq_q.enq.val.value = 1
  //           s.snoop_q.deq.rdy.value = 1
  //           s.bloomreq_q.enq.msg.type_.value = BloomFilterMsg.TYPE_INSERT
  //           s.bloomreq_q.enq.msg.word.value = s.snoop_q.deq.msg
  //
  //       # Enqueueing the Snoop Queue
  //
  //       # XXX: memreq_snoop.val should be tied to memreq.val AND memreq.rdy
  //       if s.memreq_snoop.val:
  //
  //         # Filter out the memory requests based on the status we're in.
  //         if ( (s.status.out == s.STATUS_ENABLED_R and
  //               s.memreq_snoop.msg.type_ == snoop_mem_msg.req.TYPE_READ) or
  //              (s.status.out == s.STATUS_ENABLED_W and
  //               s.memreq_snoop.msg.type_ != snoop_mem_msg.req.TYPE_READ) or
  //              s.status.out == s.STATUS_ENABLED_RW ):
  //           s.snoop_q.enq.val.value = 1
  //           s.snoop_q.enq.msg.value = s.memreq_snoop.msg.addr
  //
  //           if not s.snoop_q.enq.rdy:
  //             # We can't put the item to the snoop q, so we need to throw
  //             # an exception!
  //             s.status.in_.value = s.STATUS_EXCEPTION
  //
  //       # Check value
  //
  //       if s.bloom_filter.check_out.val:
  //         if s.bloom_filter.check_out.msg == 1:
  //           s.check_res.in_.value = s.CHECK_RESULT_YES
  //         else:
  //           s.check_res.in_.value = s.CHECK_RESULT_NO
  //
  //       # Accelerator register access. Note that this is at the bottom of
  //       # the combinational block to ensure the writes to the registers are
  //       # prioritized from the processor side.
  //
  //       if s.xcelreq_q.deq.val and s.xcelreq_q.deq.rdy:
  //         if s.xcelreq_q.deq.msg.type_ == XcelReqMsg.TYPE_WRITE:
  //
  //           if s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_STATUS:
  //             s.status.in_.value = s.xcelreq_q.deq.msg.data
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_VAL:
  //             s.check_val.in_.value = s.xcelreq_q.deq.msg.data
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_RES:
  //             s.check_res.in_.value = s.xcelreq_q.deq.msg.data
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CLEAR:
  //             s.clear.in_.value = s.xcelreq_q.deq.msg.data
  //
  //         else:  # TYPE_READ
  //
  //           if s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_STATUS:
  //             s.xcelresp.msg.data.value = s.status.out
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_VAL:
  //             s.xcelresp.msg.data.value = s.check_val.out
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CHECK_RES:
  //             s.xcelresp.msg.data.value = s.check_res.out
  //
  //             # If the check result is available, reset the check result so
  //             # that the processor doesn't have to reset it.
  //
  //             if s.check_res.out != s.CHECK_RESULT_INV:
  //               s.check_res.in_.value = s.CHECK_RESULT_INV
  //
  //           elif s.xcelreq_q.deq.msg.raddr == csr_begin + s.CSR_OFFSET_CLEAR:
  //             s.xcelresp.msg.data.value = s.clear.out

  // logic for comb()
  always @ (*) begin
    status$in_ = status$out;
    check_val$in_ = check_val$out;
    check_res$in_ = check_res$out;
    clear$in_ = clear$out;
    xcelresp_msg[(32)-1:0] = 0;
    bloomreq_q$enq_val = 0;
    bloomreq_q$enq_msg = 0;
    snoop_q$deq_rdy = 0;
    snoop_q$enq_val = 0;
    snoop_q$enq_msg = 0;
    bloom_filter$check_out_rdy = 1;
    if (bloomreq_q$enq_rdy) begin
      if ((clear$out == CLEAR_REQUESTED)) begin
        bloomreq_q$enq_val = 1;
        bloomreq_q$enq_msg[(34)-1:32] = TYPE_CLEAR;
        bloomreq_q$enq_msg[(32)-1:0] = 0;
        clear$in_ = CLEAR_DONE;
      end
      else begin
        if ((check_val$out != CHECK_VALUE_DONE)) begin
          bloomreq_q$enq_val = 1;
          bloomreq_q$enq_msg[(34)-1:32] = TYPE_CHECK;
          bloomreq_q$enq_msg[(32)-1:0] = check_val$out;
          check_val$in_ = CHECK_VALUE_DONE;
        end
        else begin
          if (snoop_q$deq_val) begin
            bloomreq_q$enq_val = 1;
            snoop_q$deq_rdy = 1;
            bloomreq_q$enq_msg[(34)-1:32] = TYPE_INSERT;
            bloomreq_q$enq_msg[(32)-1:0] = snoop_q$deq_msg;
          end
          else begin
          end
        end
      end
    end
    else begin
    end
    if (memreq_snoop_val) begin
      if ((((status$out == STATUS_ENABLED_R)&&(memreq_snoop_msg[(78)-1:74] == TYPE_READ))||((status$out == STATUS_ENABLED_W)&&(memreq_snoop_msg[(78)-1:74] != TYPE_READ))||(status$out == STATUS_ENABLED_RW))) begin
        snoop_q$enq_val = 1;
        snoop_q$enq_msg = memreq_snoop_msg[(66)-1:34];
        if (!snoop_q$enq_rdy) begin
          status$in_ = STATUS_EXCEPTION;
        end
        else begin
        end
      end
      else begin
      end
    end
    else begin
    end
    if (bloom_filter$check_out_val) begin
      if ((bloom_filter$check_out_msg == 1)) begin
        check_res$in_ = CHECK_RESULT_YES;
      end
      else begin
        check_res$in_ = CHECK_RESULT_NO;
      end
    end
    else begin
    end
    if ((xcelreq_q$deq_val&&xcelreq_q$deq_rdy)) begin
      if ((xcelreq_q$deq_msg[(38)-1:37] == TYPE_WRITE)) begin
        if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_STATUS))) begin
          status$in_ = xcelreq_q$deq_msg[(32)-1:0];
        end
        else begin
          if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CHECK_VAL))) begin
            check_val$in_ = xcelreq_q$deq_msg[(32)-1:0];
          end
          else begin
            if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CHECK_RES))) begin
              check_res$in_ = xcelreq_q$deq_msg[(32)-1:0];
            end
            else begin
              if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CLEAR))) begin
                clear$in_ = xcelreq_q$deq_msg[(32)-1:0];
              end
              else begin
              end
            end
          end
        end
      end
      else begin
        if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_STATUS))) begin
          xcelresp_msg[(32)-1:0] = status$out;
        end
        else begin
          if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CHECK_VAL))) begin
            xcelresp_msg[(32)-1:0] = check_val$out;
          end
          else begin
            if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CHECK_RES))) begin
              xcelresp_msg[(32)-1:0] = check_res$out;
              if ((check_res$out != CHECK_RESULT_INV)) begin
                check_res$in_ = CHECK_RESULT_INV;
              end
              else begin
              end
            end
            else begin
              if ((xcelreq_q$deq_msg[(37)-1:32] == (csr_begin+CSR_OFFSET_CLEAR))) begin
                xcelresp_msg[(32)-1:0] = clear$out;
              end
              else begin
              end
            end
          end
        end
      end
    end
    else begin
    end
  end


endmodule // BloomFilterXcel_0x6aa8c82a20a95749
`default_nettype wire

//-----------------------------------------------------------------------------
// RegRst_0x3857337130dc0828
//-----------------------------------------------------------------------------
// dtype: 32
// reset_value: 0
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegRst_0x3857337130dc0828
(
  input  wire [   0:0] clk,
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


endmodule // RegRst_0x3857337130dc0828
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x284a9040bb906fd0
//-----------------------------------------------------------------------------
// num_entries: 3
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x284a9040bb906fd0
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  31:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   1:0] num_free_entries,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   1:0] ctrl$waddr;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   1:0] ctrl$raddr;
  wire   [   1:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x4c319dcf628a6cd4 ctrl
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
  wire   [   1:0] dpath$waddr;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$wen;
  wire   [   1:0] dpath$raddr;
  wire   [   0:0] dpath$reset;
  wire   [  31:0] dpath$enq_bits;
  wire   [  31:0] dpath$deq_bits;

  NormalQueueDpath_0x284a9040bb906fd0 dpath
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



endmodule // NormalQueue_0x284a9040bb906fd0
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueCtrl_0x4c319dcf628a6cd4
//-----------------------------------------------------------------------------
// num_entries: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueCtrl_0x4c319dcf628a6cd4
(
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   1:0] num_free_entries,
  output reg  [   1:0] raddr,
  input  wire [   0:0] reset,
  output reg  [   1:0] waddr,
  output reg  [   0:0] wen
);

  // register declarations
  reg    [   1:0] deq_ptr;
  reg    [   1:0] deq_ptr_inc;
  reg    [   1:0] deq_ptr_next;
  reg    [   0:0] do_deq;
  reg    [   0:0] do_enq;
  reg    [   0:0] empty;
  reg    [   1:0] enq_ptr;
  reg    [   1:0] enq_ptr_inc;
  reg    [   1:0] enq_ptr_next;
  reg    [   0:0] full;
  reg    [   0:0] full_next_cycle;

  // localparam declarations
  localparam last_idx = 2;
  localparam num_entries = 3;



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
  // synopsys sync_set_reset "reset"
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


endmodule // NormalQueueCtrl_0x4c319dcf628a6cd4
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x284a9040bb906fd0
//-----------------------------------------------------------------------------
// num_entries: 3
// dtype: 32
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x284a9040bb906fd0
(
  input  wire [   0:0] clk,
  output wire [  31:0] deq_bits,
  input  wire [  31:0] enq_bits,
  input  wire [   1:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   1:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   1:0] queue$rd_addr$000;
  wire   [  31:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   1:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  31:0] queue$rd_data$000;

  RegisterFile_0x22453370c64e3f2d queue
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



endmodule // NormalQueueDpath_0x284a9040bb906fd0
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x22453370c64e3f2d
//-----------------------------------------------------------------------------
// dtype: 32
// nregs: 3
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x22453370c64e3f2d
(
  input  wire [   0:0] clk,
  input  wire [   1:0] rd_addr$000,
  output wire [  31:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   1:0] wr_addr,
  input  wire [  31:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  31:0] regs$000;
  wire   [  31:0] regs$001;
  wire   [  31:0] regs$002;


  // localparam declarations
  localparam nregs = 3;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   1:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  31:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  31:0] regs[0:2];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];
  assign regs$002 = regs[  2];

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


endmodule // RegisterFile_0x22453370c64e3f2d
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x7aacac805eb4ec3f
//-----------------------------------------------------------------------------
// num_entries: 2
// dtype: 34
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x7aacac805eb4ec3f
(
  input  wire [   0:0] clk,
  output wire [  33:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  33:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   1:0] num_free_entries,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$waddr;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$raddr;
  wire   [   1:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7a42a348c9205b5 ctrl
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
  wire   [   0:0] dpath$waddr;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$raddr;
  wire   [   0:0] dpath$reset;
  wire   [  33:0] dpath$enq_bits;
  wire   [  33:0] dpath$deq_bits;

  NormalQueueDpath_0x7aacac805eb4ec3f dpath
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



endmodule // NormalQueue_0x7aacac805eb4ec3f
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueCtrl_0x7a42a348c9205b5
//-----------------------------------------------------------------------------
// num_entries: 2
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueCtrl_0x7a42a348c9205b5
(
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output reg  [   1:0] num_free_entries,
  output reg  [   0:0] raddr,
  input  wire [   0:0] reset,
  output reg  [   0:0] waddr,
  output reg  [   0:0] wen
);

  // register declarations
  reg    [   0:0] deq_ptr;
  reg    [   0:0] deq_ptr_inc;
  reg    [   0:0] deq_ptr_next;
  reg    [   0:0] do_deq;
  reg    [   0:0] do_enq;
  reg    [   0:0] empty;
  reg    [   0:0] enq_ptr;
  reg    [   0:0] enq_ptr_inc;
  reg    [   0:0] enq_ptr_next;
  reg    [   0:0] full;
  reg    [   0:0] full_next_cycle;

  // localparam declarations
  localparam last_idx = 1;
  localparam num_entries = 2;



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
  // synopsys sync_set_reset "reset"
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


endmodule // NormalQueueCtrl_0x7a42a348c9205b5
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x7aacac805eb4ec3f
//-----------------------------------------------------------------------------
// num_entries: 2
// dtype: 34
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x7aacac805eb4ec3f
(
  input  wire [   0:0] clk,
  output wire [  33:0] deq_bits,
  input  wire [  33:0] enq_bits,
  input  wire [   0:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   0:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   0:0] queue$rd_addr$000;
  wire   [  33:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  33:0] queue$rd_data$000;

  RegisterFile_0x6644f9589377deea queue
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



endmodule // NormalQueueDpath_0x7aacac805eb4ec3f
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x6644f9589377deea
//-----------------------------------------------------------------------------
// dtype: 34
// nregs: 2
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x6644f9589377deea
(
  input  wire [   0:0] clk,
  input  wire [   0:0] rd_addr$000,
  output wire [  33:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] wr_addr,
  input  wire [  33:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  33:0] regs$000;
  wire   [  33:0] regs$001;


  // localparam declarations
  localparam nregs = 2;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   0:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  33:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  33:0] regs[0:1];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];

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


endmodule // RegisterFile_0x6644f9589377deea
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x37f180039b40e5fd
//-----------------------------------------------------------------------------
// num_entries: 2
// dtype: 38
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x37f180039b40e5fd
(
  input  wire [   0:0] clk,
  output wire [  37:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  37:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  output wire [   1:0] num_free_entries,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$waddr;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$raddr;
  wire   [   1:0] ctrl$num_free_entries;
  wire   [   0:0] ctrl$enq_rdy;

  NormalQueueCtrl_0x7a42a348c9205b5 ctrl
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
  wire   [   0:0] dpath$waddr;
  wire   [   0:0] dpath$clk;
  wire   [   0:0] dpath$wen;
  wire   [   0:0] dpath$raddr;
  wire   [   0:0] dpath$reset;
  wire   [  37:0] dpath$enq_bits;
  wire   [  37:0] dpath$deq_bits;

  NormalQueueDpath_0x37f180039b40e5fd dpath
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



endmodule // NormalQueue_0x37f180039b40e5fd
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x37f180039b40e5fd
//-----------------------------------------------------------------------------
// num_entries: 2
// dtype: 38
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x37f180039b40e5fd
(
  input  wire [   0:0] clk,
  output wire [  37:0] deq_bits,
  input  wire [  37:0] enq_bits,
  input  wire [   0:0] raddr,
  input  wire [   0:0] reset,
  input  wire [   0:0] waddr,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   0:0] queue$rd_addr$000;
  wire   [  37:0] queue$wr_data;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$wr_addr;
  wire   [   0:0] queue$wr_en;
  wire   [   0:0] queue$reset;
  wire   [  37:0] queue$rd_data$000;

  RegisterFile_0x2b946260b0c1bfae queue
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



endmodule // NormalQueueDpath_0x37f180039b40e5fd
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x2b946260b0c1bfae
//-----------------------------------------------------------------------------
// dtype: 38
// nregs: 2
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x2b946260b0c1bfae
(
  input  wire [   0:0] clk,
  input  wire [   0:0] rd_addr$000,
  output wire [  37:0] rd_data$000,
  input  wire [   0:0] reset,
  input  wire [   0:0] wr_addr,
  input  wire [  37:0] wr_data,
  input  wire [   0:0] wr_en
);

  // wire declarations
  wire   [  37:0] regs$000;
  wire   [  37:0] regs$001;


  // localparam declarations
  localparam nregs = 2;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   0:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  37:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  37:0] regs[0:1];
  assign regs$000 = regs[  0];
  assign regs$001 = regs[  1];

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


endmodule // RegisterFile_0x2b946260b0c1bfae
`default_nettype wire

//-----------------------------------------------------------------------------
// BloomFilterParallel_0x12ed5f3412fae46f
//-----------------------------------------------------------------------------
// num_bits_exponent: 8
// num_hash_funs: 3
// msg_type: 34
// seed: 3735928559
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module BloomFilterParallel_0x12ed5f3412fae46f
(
  output reg  [   0:0] check_out_msg,
  input  wire [   0:0] check_out_rdy,
  output reg  [   0:0] check_out_val,
  input  wire [   0:0] clk,
  input  wire [  33:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [ 255:0] bits_out;


  // register declarations
  reg    [ 255:0] bits_in;
  reg    [   1:0] state$in_;

  // localparam declarations
  localparam STATE_CHECK = 2;
  localparam STATE_CLEAR = 3;
  localparam STATE_IDLE = 0;
  localparam STATE_INSERT = 1;
  localparam TYPE_CHECK = 1;
  localparam TYPE_CLEAR = 2;
  localparam TYPE_INSERT = 0;
  localparam num_hash_funs = 3;

  // loop variable declarations
  integer i;

  // hash_funs$000 temporaries
  wire   [   0:0] hash_funs$000$reset;
  wire   [  31:0] hash_funs$000$in_;
  wire   [   0:0] hash_funs$000$clk;
  wire   [   7:0] hash_funs$000$out;

  HashFunction_0xde3df3b14ef2781 hash_funs$000
  (
    .reset ( hash_funs$000$reset ),
    .in_   ( hash_funs$000$in_ ),
    .clk   ( hash_funs$000$clk ),
    .out   ( hash_funs$000$out )
  );

  // hash_funs$001 temporaries
  wire   [   0:0] hash_funs$001$reset;
  wire   [  31:0] hash_funs$001$in_;
  wire   [   0:0] hash_funs$001$clk;
  wire   [   7:0] hash_funs$001$out;

  HashFunction_0x7c773afa6cd85577 hash_funs$001
  (
    .reset ( hash_funs$001$reset ),
    .in_   ( hash_funs$001$in_ ),
    .clk   ( hash_funs$001$clk ),
    .out   ( hash_funs$001$out )
  );

  // hash_funs$002 temporaries
  wire   [   0:0] hash_funs$002$reset;
  wire   [  31:0] hash_funs$002$in_;
  wire   [   0:0] hash_funs$002$clk;
  wire   [   7:0] hash_funs$002$out;

  HashFunction_0x2d56ccb9a14a2de9 hash_funs$002
  (
    .reset ( hash_funs$002$reset ),
    .in_   ( hash_funs$002$in_ ),
    .clk   ( hash_funs$002$clk ),
    .out   ( hash_funs$002$out )
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

  // bits temporaries
  wire   [   0:0] bits$reset;
  wire   [ 255:0] bits$in_;
  wire   [   0:0] bits$clk;
  wire   [ 255:0] bits$out;

  Reg_0x20dfe5f222b87beb bits
  (
    .reset ( bits$reset ),
    .in_   ( bits$in_ ),
    .clk   ( bits$clk ),
    .out   ( bits$out )
  );

  // word temporaries
  wire   [   0:0] word$reset;
  wire   [  31:0] word$in_;
  wire   [   0:0] word$clk;
  wire   [   0:0] word$en;
  wire   [  31:0] word$out;

  RegEn_0x1eed677bd3b5c175 word
  (
    .reset ( word$reset ),
    .in_   ( word$in_ ),
    .clk   ( word$clk ),
    .en    ( word$en ),
    .out   ( word$out )
  );

  // signal connections
  assign bits$clk            = clk;
  assign bits$in_            = bits_in;
  assign bits$reset          = reset;
  assign bits_out            = bits$out;
  assign hash_funs$000$clk   = clk;
  assign hash_funs$000$in_   = word$out;
  assign hash_funs$000$reset = reset;
  assign hash_funs$001$clk   = clk;
  assign hash_funs$001$in_   = word$out;
  assign hash_funs$001$reset = reset;
  assign hash_funs$002$clk   = clk;
  assign hash_funs$002$in_   = word$out;
  assign hash_funs$002$reset = reset;
  assign state$clk           = clk;
  assign state$reset         = reset;
  assign word$clk            = clk;
  assign word$en             = in__val;
  assign word$in_            = in__msg[31:0];
  assign word$reset          = reset;

  // array declarations
  wire   [   7:0] hash_funs$out[0:2];
  assign hash_funs$out[  0] = hash_funs$000$out;
  assign hash_funs$out[  1] = hash_funs$001$out;
  assign hash_funs$out[  2] = hash_funs$002$out;

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_state():
  //       s.state.in_.value = s.state.out
  //
  //       if s.state.out == s.STATE_IDLE or s.state.out == s.STATE_INSERT or \
  //            s.state.out == s.STATE_CLEAR:
  //         s.state.in_.value = s.STATE_IDLE
  //         if s.in_.val:
  //           if s.in_.msg.type_ == BloomFilterMsg.TYPE_INSERT:
  //             s.state.in_.value = s.STATE_INSERT
  //           elif s.in_.msg.type_ == BloomFilterMsg.TYPE_CHECK:
  //             s.state.in_.value = s.STATE_CHECK
  //           elif s.in_.msg.type_ == BloomFilterMsg.TYPE_CLEAR:
  //             s.state.in_.value = s.STATE_CLEAR
  //
  //       elif s.state.out == s.STATE_CHECK and s.check_out.rdy:
  //         s.state.in_.value = s.STATE_IDLE

  // logic for comb_state()
  always @ (*) begin
    state$in_ = state$out;
    if (((state$out == STATE_IDLE)||(state$out == STATE_INSERT)||(state$out == STATE_CLEAR))) begin
      state$in_ = STATE_IDLE;
      if (in__val) begin
        if ((in__msg[(34)-1:32] == TYPE_INSERT)) begin
          state$in_ = STATE_INSERT;
        end
        else begin
          if ((in__msg[(34)-1:32] == TYPE_CHECK)) begin
            state$in_ = STATE_CHECK;
          end
          else begin
            if ((in__msg[(34)-1:32] == TYPE_CLEAR)) begin
              state$in_ = STATE_CLEAR;
            end
            else begin
            end
          end
        end
      end
      else begin
      end
    end
    else begin
      if (((state$out == STATE_CHECK)&&check_out_rdy)) begin
        state$in_ = STATE_IDLE;
      end
      else begin
      end
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_bits():
  //       s.in_.rdy.value       = 0
  //       s.check_out.val.value = 0
  //       s.check_out.msg.value = 0
  //       s.bits_in.value       = s.bits_out
  //
  //       if s.state.out == s.STATE_IDLE:
  //         s.in_.rdy.value = 1
  //
  //       elif s.state.out == s.STATE_CLEAR:
  //         s.in_.rdy.value = 1
  //         s.bits_in.value = 0
  //
  //       elif s.state.out == s.STATE_INSERT:
  //         s.in_.rdy.value = 1
  //
  //         for i in range( num_hash_funs ):
  //           s.bits_in[ s.hash_funs[i].out ].value |= 1
  //
  //       elif s.state.out == s.STATE_CHECK:
  //         s.check_out.val.value = 1
  //         s.check_out.msg.value = 1
  //
  //         for i in range( num_hash_funs ):
  //           s.check_out.msg.value = s.check_out.msg & s.bits_out[ s.hash_funs[i].out ]

  // logic for comb_bits()
  always @ (*) begin
    in__rdy = 0;
    check_out_val = 0;
    check_out_msg = 0;
    bits_in = bits_out;
    if ((state$out == STATE_IDLE)) begin
      in__rdy = 1;
    end
    else begin
      if ((state$out == STATE_CLEAR)) begin
        in__rdy = 1;
        bits_in = 0;
      end
      else begin
        if ((state$out == STATE_INSERT)) begin
          in__rdy = 1;
          for (i=0; i < num_hash_funs; i=i+1)
          begin
            bits_in[hash_funs$out[i]] = bits_in[hash_funs$out[i]] | 1;
          end
        end
        else begin
          if ((state$out == STATE_CHECK)) begin
            check_out_val = 1;
            check_out_msg = 1;
            for (i=0; i < num_hash_funs; i=i+1)
            begin
              check_out_msg = (check_out_msg&bits_out[hash_funs$out[i]]);
            end
          end
          else begin
          end
        end
      end
    end
  end


endmodule // BloomFilterParallel_0x12ed5f3412fae46f
`default_nettype wire

//-----------------------------------------------------------------------------
// HashFunction_0xde3df3b14ef2781
//-----------------------------------------------------------------------------
// num_bits_exponent: 8
// nbits: 32
// const_hash_key: 41089190
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HashFunction_0xde3df3b14ef2781
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [   7:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  31:0] addition;

  // localparam declarations
  localparam const_hash_key = 41089190;
  localparam nbits = 32;
  localparam num_bits_exponent = 8;

  // loop variable declarations
  integer i;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_hash_val():
  //       s.addition.value = s.in_
  //
  //       for i in range( 1, nbits ):
  //         if (const_hash_key >> i) & 1:
  //           s.addition.value += s.in_ << i
  //
  //       s.out.value = s.addition[ nbits - num_bits_exponent : nbits ]

  // logic for comb_hash_val()
  always @ (*) begin
    addition = in_;
    for (i=1; i < nbits; i=i+1)
    begin
      if (((const_hash_key>>i)&1)) begin
        addition = addition + (in_<<i);
      end
      else begin
      end
    end
    out = addition[(nbits)-1:(nbits-num_bits_exponent)];
  end


endmodule // HashFunction_0xde3df3b14ef2781
`default_nettype wire

//-----------------------------------------------------------------------------
// HashFunction_0x7c773afa6cd85577
//-----------------------------------------------------------------------------
// num_bits_exponent: 8
// nbits: 32
// const_hash_key: 1008527998
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HashFunction_0x7c773afa6cd85577
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [   7:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  31:0] addition;

  // localparam declarations
  localparam const_hash_key = 1008527998;
  localparam nbits = 32;
  localparam num_bits_exponent = 8;

  // loop variable declarations
  integer i;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_hash_val():
  //       s.addition.value = s.in_
  //
  //       for i in range( 1, nbits ):
  //         if (const_hash_key >> i) & 1:
  //           s.addition.value += s.in_ << i
  //
  //       s.out.value = s.addition[ nbits - num_bits_exponent : nbits ]

  // logic for comb_hash_val()
  always @ (*) begin
    addition = in_;
    for (i=1; i < nbits; i=i+1)
    begin
      if (((const_hash_key>>i)&1)) begin
        addition = addition + (in_<<i);
      end
      else begin
      end
    end
    out = addition[(nbits)-1:(nbits-num_bits_exponent)];
  end


endmodule // HashFunction_0x7c773afa6cd85577
`default_nettype wire

//-----------------------------------------------------------------------------
// HashFunction_0x2d56ccb9a14a2de9
//-----------------------------------------------------------------------------
// num_bits_exponent: 8
// nbits: 32
// const_hash_key: 1286953758
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HashFunction_0x2d56ccb9a14a2de9
(
  input  wire [   0:0] clk,
  input  wire [  31:0] in_,
  output reg  [   7:0] out,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [  31:0] addition;

  // localparam declarations
  localparam const_hash_key = 1286953758;
  localparam nbits = 32;
  localparam num_bits_exponent = 8;

  // loop variable declarations
  integer i;



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_hash_val():
  //       s.addition.value = s.in_
  //
  //       for i in range( 1, nbits ):
  //         if (const_hash_key >> i) & 1:
  //           s.addition.value += s.in_ << i
  //
  //       s.out.value = s.addition[ nbits - num_bits_exponent : nbits ]

  // logic for comb_hash_val()
  always @ (*) begin
    addition = in_;
    for (i=1; i < nbits; i=i+1)
    begin
      if (((const_hash_key>>i)&1)) begin
        addition = addition + (in_<<i);
      end
      else begin
      end
    end
    out = addition[(nbits)-1:(nbits-num_bits_exponent)];
  end


endmodule // HashFunction_0x2d56ccb9a14a2de9
`default_nettype wire

//-----------------------------------------------------------------------------
// Reg_0x20dfe5f222b87beb
//-----------------------------------------------------------------------------
// dtype: 256
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Reg_0x20dfe5f222b87beb
(
  input  wire [   0:0] clk,
  input  wire [ 255:0] in_,
  output reg  [ 255:0] out,
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


endmodule // Reg_0x20dfe5f222b87beb
`default_nettype wire

//-----------------------------------------------------------------------------
// HostAdapter_MduReqMsg_32_8_MduRespMsg_32
//-----------------------------------------------------------------------------
// resp: <pymtl.model.signals.OutPort object at 0x7f9ba1ac8fd0>
// req: <pymtl.model.signals.InPort object at 0x7f9ba1a616d0>
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostAdapter_MduReqMsg_32_8_MduRespMsg_32
(
  input  wire [   0:0] clk,
  input  wire [   0:0] host_en,
  input  wire [  69:0] hostreq_msg,
  output reg  [   0:0] hostreq_rdy,
  input  wire [   0:0] hostreq_val,
  output reg  [  34:0] hostresp_msg,
  input  wire [   0:0] hostresp_rdy,
  output reg  [   0:0] hostresp_val,
  input  wire [  69:0] realreq_msg,
  output reg  [   0:0] realreq_rdy,
  input  wire [   0:0] realreq_val,
  output reg  [  34:0] realresp_msg,
  input  wire [   0:0] realresp_rdy,
  output reg  [   0:0] realresp_val,
  output reg  [  69:0] req_msg,
  input  wire [   0:0] req_rdy,
  output reg  [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [  34:0] resp_msg,
  output reg  [   0:0] resp_rdy,
  input  wire [   0:0] resp_val
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_req_select():
  //
  //       if s.host_en:
  //         # Mute req
  //         s.realreq.rdy.value  = 0
  //         s.realresp.val.value = 0
  //         s.realresp.msg.value = 0
  //
  //         # instance.req <- hostreq
  //         s.req.val.value      = s.hostreq.val
  //         s.req.msg.value      = s.hostreq.msg
  //         s.hostreq.rdy.value  = s.req.rdy
  //
  //         # hostresp <- out_resp
  //         s.hostresp.val.value = s.resp.val
  //         s.hostresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.hostresp.rdy
  //
  //       else:
  //         # Mute host
  //         s.hostreq.rdy.value  = 0
  //         s.hostresp.val.value = 0
  //         s.hostresp.msg.value = 0
  //
  //         # req <- realreq
  //         s.req.val.value      = s.realreq.val
  //         s.req.msg.value      = s.realreq.msg
  //         s.realreq.rdy.value  = s.req.rdy
  //
  //         # realresp <- resp
  //         s.realresp.val.value = s.resp.val
  //         s.realresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.realresp.rdy

  // logic for comb_req_select()
  always @ (*) begin
    if (host_en) begin
      realreq_rdy = 0;
      realresp_val = 0;
      realresp_msg = 0;
      req_val = hostreq_val;
      req_msg = hostreq_msg;
      hostreq_rdy = req_rdy;
      hostresp_val = resp_val;
      hostresp_msg = resp_msg;
      resp_rdy = hostresp_rdy;
    end
    else begin
      hostreq_rdy = 0;
      hostresp_val = 0;
      hostresp_msg = 0;
      req_val = realreq_val;
      req_msg = realreq_msg;
      realreq_rdy = req_rdy;
      realresp_val = resp_val;
      realresp_msg = resp_msg;
      resp_rdy = realresp_rdy;
    end
  end


endmodule // HostAdapter_MduReqMsg_32_8_MduRespMsg_32
`default_nettype wire

//-----------------------------------------------------------------------------
// Funnel_0x54e59faab4b44232
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Funnel_0x54e59faab4b44232
(
  input  wire [   0:0] clk,
  input  wire [ 175:0] in_$000_msg,
  output wire [   0:0] in_$000_rdy,
  input  wire [   0:0] in_$000_val,
  input  wire [ 175:0] in_$001_msg,
  output wire [   0:0] in_$001_rdy,
  input  wire [   0:0] in_$001_val,
  input  wire [ 175:0] in_$002_msg,
  output wire [   0:0] in_$002_rdy,
  input  wire [   0:0] in_$002_val,
  input  wire [ 175:0] in_$003_msg,
  output wire [   0:0] in_$003_rdy,
  input  wire [   0:0] in_$003_val,
  output reg  [ 175:0] out_msg,
  input  wire [   0:0] out_rdy,
  output reg  [   0:0] out_val,
  input  wire [   0:0] reset
);

  // register declarations
  reg    [   0:0] arbiter$en;

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;

  // arbiter temporaries
  wire   [   3:0] arbiter$reqs;
  wire   [   0:0] arbiter$clk;
  wire   [   0:0] arbiter$reset;
  wire   [   3:0] arbiter$grants;

  RoundRobinArbiterEn_0x77747397823e93e3 arbiter
  (
    .en     ( arbiter$en ),
    .reqs   ( arbiter$reqs ),
    .clk    ( arbiter$clk ),
    .reset  ( arbiter$reset ),
    .grants ( arbiter$grants )
  );

  // signal connections
  assign arbiter$clk     = clk;
  assign arbiter$reqs[0] = in_$000_val;
  assign arbiter$reqs[1] = in_$001_val;
  assign arbiter$reqs[2] = in_$002_val;
  assign arbiter$reqs[3] = in_$003_val;
  assign arbiter$reset   = reset;

  // array declarations
  wire   [ 175:0] in__msg[0:3];
  assign in__msg[  0] = in_$000_msg;
  assign in__msg[  1] = in_$001_msg;
  assign in__msg[  2] = in_$002_msg;
  assign in__msg[  3] = in_$003_msg;
  reg    [   0:0] in__rdy[0:3];
  assign in_$000_rdy = in__rdy[  0];
  assign in_$001_rdy = in__rdy[  1];
  assign in_$002_rdy = in__rdy[  2];
  assign in_$003_rdy = in__rdy[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       for i in xrange( nports ):
  //         s.in_[i].rdy.value = s.arbiter.grants[i] & s.out.rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      in__rdy[i] = (arbiter$grants[i]&out_rdy);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_arbiter_en():
  //       s.arbiter.en.value = s.out.val & s.out.rdy

  // logic for comb_arbiter_en()
  always @ (*) begin
    arbiter$en = (out_val&out_rdy);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_output():
  //       s.out.val.value = ( s.arbiter.grants != 0 )
  //
  //       s.out.msg.value = 0
  //       for i in xrange( nports ):
  //         if s.arbiter.grants[i]:
  //           s.out.msg.value        = s.in_[i].msg
  //           s.out.msg.opaque.value = i

  // logic for comb_output()
  always @ (*) begin
    out_val = (arbiter$grants != 0);
    out_msg = 0;
    for (i=0; i < nports; i=i+1)
    begin
      if (arbiter$grants[i]) begin
        out_msg = in__msg[i];
        out_msg[(172)-1:164] = i;
      end
      else begin
      end
    end
  end


endmodule // Funnel_0x54e59faab4b44232
`default_nettype wire

//-----------------------------------------------------------------------------
// CtrlReg_0x2547fdfd5863c73b
//-----------------------------------------------------------------------------
// num_cores: 4
// valrdy_ifcs: 3
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module CtrlReg_0x2547fdfd5863c73b
(
  input  wire [   0:0] clk,
  input  wire [   3:0] commit_inst,
  output wire [   0:0] debug,
  output wire [   3:0] go,
  output wire [   2:0] host_en,
  input  wire [  36:0] req_msg,
  output wire [   0:0] req_rdy,
  input  wire [   0:0] req_val,
  input  wire [   0:0] reset,
  output wire [  32:0] resp_msg,
  input  wire [   0:0] resp_rdy,
  output wire [   0:0] resp_val,
  input  wire [   0:0] stats_en
);

  // wire declarations
  wire   [  31:0] instcounters_in$000;
  wire   [  31:0] instcounters_in$001;
  wire   [  31:0] instcounters_in$002;
  wire   [  31:0] instcounters_in$003;
  wire   [  31:0] instcounters_out$000;
  wire   [  31:0] instcounters_out$001;
  wire   [  31:0] instcounters_out$002;
  wire   [  31:0] instcounters_out$003;
  wire   [  31:0] cyclecounters_out;


  // register declarations
  reg    [   0:0] cr_debug_en;
  reg    [  31:0] cr_debug_in;
  reg    [   0:0] cr_go_en;
  reg    [  31:0] cr_go_in;
  reg    [   0:0] cyclecounters_en;
  reg    [  31:0] cyclecounters_in;
  reg    [   3:0] instcounters_en;
  reg    [  32:0] out_q$enq_msg;
  reg    [   3:0] rf_raddr;
  reg    [  31:0] rf_rdata;
  reg    [   3:0] rf_waddr;
  reg    [  31:0] rf_wdata;
  reg    [   0:0] rf_wen;
  reg    [   2:0] wire_host_en;

  // localparam declarations
  localparam TYPE_WRITE = 1;
  localparam cr_debug = 1;
  localparam cr_go = 0;
  localparam cr_host_en = 7;
  localparam num_cores = 4;
  localparam valrdy_ifcs = 3;

  // loop variable declarations
  integer core_idx;
  integer idx;

  // in_q temporaries
  wire   [   0:0] in_q$reset;
  wire   [   0:0] in_q$clk;
  wire   [   0:0] in_q$deq_rdy;
  wire   [  36:0] in_q$enq_msg;
  wire   [   0:0] in_q$enq_val;
  wire   [  36:0] in_q$deq_msg;
  wire   [   0:0] in_q$deq_val;
  wire   [   0:0] in_q$enq_rdy;

  SingleElementNormalQueue_0x5cdd7a7d31cf6b7d in_q
  (
    .reset   ( in_q$reset ),
    .clk     ( in_q$clk ),
    .deq_rdy ( in_q$deq_rdy ),
    .enq_msg ( in_q$enq_msg ),
    .enq_val ( in_q$enq_val ),
    .deq_msg ( in_q$deq_msg ),
    .deq_val ( in_q$deq_val ),
    .enq_rdy ( in_q$enq_rdy )
  );

  // ctrlregs$000 temporaries
  wire   [   0:0] ctrlregs$000$reset;
  wire   [   0:0] ctrlregs$000$en;
  wire   [   0:0] ctrlregs$000$clk;
  wire   [  31:0] ctrlregs$000$in_;
  wire   [  31:0] ctrlregs$000$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$000
  (
    .reset ( ctrlregs$000$reset ),
    .en    ( ctrlregs$000$en ),
    .clk   ( ctrlregs$000$clk ),
    .in_   ( ctrlregs$000$in_ ),
    .out   ( ctrlregs$000$out )
  );

  // ctrlregs$001 temporaries
  wire   [   0:0] ctrlregs$001$reset;
  wire   [   0:0] ctrlregs$001$en;
  wire   [   0:0] ctrlregs$001$clk;
  wire   [  31:0] ctrlregs$001$in_;
  wire   [  31:0] ctrlregs$001$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$001
  (
    .reset ( ctrlregs$001$reset ),
    .en    ( ctrlregs$001$en ),
    .clk   ( ctrlregs$001$clk ),
    .in_   ( ctrlregs$001$in_ ),
    .out   ( ctrlregs$001$out )
  );

  // ctrlregs$002 temporaries
  wire   [   0:0] ctrlregs$002$reset;
  wire   [   0:0] ctrlregs$002$en;
  wire   [   0:0] ctrlregs$002$clk;
  wire   [  31:0] ctrlregs$002$in_;
  wire   [  31:0] ctrlregs$002$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$002
  (
    .reset ( ctrlregs$002$reset ),
    .en    ( ctrlregs$002$en ),
    .clk   ( ctrlregs$002$clk ),
    .in_   ( ctrlregs$002$in_ ),
    .out   ( ctrlregs$002$out )
  );

  // ctrlregs$003 temporaries
  wire   [   0:0] ctrlregs$003$reset;
  wire   [   0:0] ctrlregs$003$en;
  wire   [   0:0] ctrlregs$003$clk;
  wire   [  31:0] ctrlregs$003$in_;
  wire   [  31:0] ctrlregs$003$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$003
  (
    .reset ( ctrlregs$003$reset ),
    .en    ( ctrlregs$003$en ),
    .clk   ( ctrlregs$003$clk ),
    .in_   ( ctrlregs$003$in_ ),
    .out   ( ctrlregs$003$out )
  );

  // ctrlregs$004 temporaries
  wire   [   0:0] ctrlregs$004$reset;
  wire   [   0:0] ctrlregs$004$en;
  wire   [   0:0] ctrlregs$004$clk;
  wire   [  31:0] ctrlregs$004$in_;
  wire   [  31:0] ctrlregs$004$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$004
  (
    .reset ( ctrlregs$004$reset ),
    .en    ( ctrlregs$004$en ),
    .clk   ( ctrlregs$004$clk ),
    .in_   ( ctrlregs$004$in_ ),
    .out   ( ctrlregs$004$out )
  );

  // ctrlregs$005 temporaries
  wire   [   0:0] ctrlregs$005$reset;
  wire   [   0:0] ctrlregs$005$en;
  wire   [   0:0] ctrlregs$005$clk;
  wire   [  31:0] ctrlregs$005$in_;
  wire   [  31:0] ctrlregs$005$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$005
  (
    .reset ( ctrlregs$005$reset ),
    .en    ( ctrlregs$005$en ),
    .clk   ( ctrlregs$005$clk ),
    .in_   ( ctrlregs$005$in_ ),
    .out   ( ctrlregs$005$out )
  );

  // ctrlregs$006 temporaries
  wire   [   0:0] ctrlregs$006$reset;
  wire   [   0:0] ctrlregs$006$en;
  wire   [   0:0] ctrlregs$006$clk;
  wire   [  31:0] ctrlregs$006$in_;
  wire   [  31:0] ctrlregs$006$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$006
  (
    .reset ( ctrlregs$006$reset ),
    .en    ( ctrlregs$006$en ),
    .clk   ( ctrlregs$006$clk ),
    .in_   ( ctrlregs$006$in_ ),
    .out   ( ctrlregs$006$out )
  );

  // ctrlregs$007 temporaries
  wire   [   0:0] ctrlregs$007$reset;
  wire   [   0:0] ctrlregs$007$en;
  wire   [   0:0] ctrlregs$007$clk;
  wire   [  31:0] ctrlregs$007$in_;
  wire   [  31:0] ctrlregs$007$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$007
  (
    .reset ( ctrlregs$007$reset ),
    .en    ( ctrlregs$007$en ),
    .clk   ( ctrlregs$007$clk ),
    .in_   ( ctrlregs$007$in_ ),
    .out   ( ctrlregs$007$out )
  );

  // ctrlregs$008 temporaries
  wire   [   0:0] ctrlregs$008$reset;
  wire   [   0:0] ctrlregs$008$en;
  wire   [   0:0] ctrlregs$008$clk;
  wire   [  31:0] ctrlregs$008$in_;
  wire   [  31:0] ctrlregs$008$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$008
  (
    .reset ( ctrlregs$008$reset ),
    .en    ( ctrlregs$008$en ),
    .clk   ( ctrlregs$008$clk ),
    .in_   ( ctrlregs$008$in_ ),
    .out   ( ctrlregs$008$out )
  );

  // ctrlregs$009 temporaries
  wire   [   0:0] ctrlregs$009$reset;
  wire   [   0:0] ctrlregs$009$en;
  wire   [   0:0] ctrlregs$009$clk;
  wire   [  31:0] ctrlregs$009$in_;
  wire   [  31:0] ctrlregs$009$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$009
  (
    .reset ( ctrlregs$009$reset ),
    .en    ( ctrlregs$009$en ),
    .clk   ( ctrlregs$009$clk ),
    .in_   ( ctrlregs$009$in_ ),
    .out   ( ctrlregs$009$out )
  );

  // ctrlregs$010 temporaries
  wire   [   0:0] ctrlregs$010$reset;
  wire   [   0:0] ctrlregs$010$en;
  wire   [   0:0] ctrlregs$010$clk;
  wire   [  31:0] ctrlregs$010$in_;
  wire   [  31:0] ctrlregs$010$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$010
  (
    .reset ( ctrlregs$010$reset ),
    .en    ( ctrlregs$010$en ),
    .clk   ( ctrlregs$010$clk ),
    .in_   ( ctrlregs$010$in_ ),
    .out   ( ctrlregs$010$out )
  );

  // ctrlregs$011 temporaries
  wire   [   0:0] ctrlregs$011$reset;
  wire   [   0:0] ctrlregs$011$en;
  wire   [   0:0] ctrlregs$011$clk;
  wire   [  31:0] ctrlregs$011$in_;
  wire   [  31:0] ctrlregs$011$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$011
  (
    .reset ( ctrlregs$011$reset ),
    .en    ( ctrlregs$011$en ),
    .clk   ( ctrlregs$011$clk ),
    .in_   ( ctrlregs$011$in_ ),
    .out   ( ctrlregs$011$out )
  );

  // ctrlregs$012 temporaries
  wire   [   0:0] ctrlregs$012$reset;
  wire   [   0:0] ctrlregs$012$en;
  wire   [   0:0] ctrlregs$012$clk;
  wire   [  31:0] ctrlregs$012$in_;
  wire   [  31:0] ctrlregs$012$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$012
  (
    .reset ( ctrlregs$012$reset ),
    .en    ( ctrlregs$012$en ),
    .clk   ( ctrlregs$012$clk ),
    .in_   ( ctrlregs$012$in_ ),
    .out   ( ctrlregs$012$out )
  );

  // ctrlregs$013 temporaries
  wire   [   0:0] ctrlregs$013$reset;
  wire   [   0:0] ctrlregs$013$en;
  wire   [   0:0] ctrlregs$013$clk;
  wire   [  31:0] ctrlregs$013$in_;
  wire   [  31:0] ctrlregs$013$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$013
  (
    .reset ( ctrlregs$013$reset ),
    .en    ( ctrlregs$013$en ),
    .clk   ( ctrlregs$013$clk ),
    .in_   ( ctrlregs$013$in_ ),
    .out   ( ctrlregs$013$out )
  );

  // ctrlregs$014 temporaries
  wire   [   0:0] ctrlregs$014$reset;
  wire   [   0:0] ctrlregs$014$en;
  wire   [   0:0] ctrlregs$014$clk;
  wire   [  31:0] ctrlregs$014$in_;
  wire   [  31:0] ctrlregs$014$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$014
  (
    .reset ( ctrlregs$014$reset ),
    .en    ( ctrlregs$014$en ),
    .clk   ( ctrlregs$014$clk ),
    .in_   ( ctrlregs$014$in_ ),
    .out   ( ctrlregs$014$out )
  );

  // ctrlregs$015 temporaries
  wire   [   0:0] ctrlregs$015$reset;
  wire   [   0:0] ctrlregs$015$en;
  wire   [   0:0] ctrlregs$015$clk;
  wire   [  31:0] ctrlregs$015$in_;
  wire   [  31:0] ctrlregs$015$out;

  RegEnRst_0x3857337130dc0828 ctrlregs$015
  (
    .reset ( ctrlregs$015$reset ),
    .en    ( ctrlregs$015$en ),
    .clk   ( ctrlregs$015$clk ),
    .in_   ( ctrlregs$015$in_ ),
    .out   ( ctrlregs$015$out )
  );

  // out_q temporaries
  wire   [   0:0] out_q$reset;
  wire   [   0:0] out_q$clk;
  wire   [   0:0] out_q$deq_rdy;
  wire   [   0:0] out_q$enq_val;
  wire   [  32:0] out_q$deq_msg;
  wire   [   0:0] out_q$deq_val;
  wire   [   0:0] out_q$enq_rdy;

  SingleElementNormalQueue_0x79667c2fcd82f209 out_q
  (
    .reset   ( out_q$reset ),
    .clk     ( out_q$clk ),
    .deq_rdy ( out_q$deq_rdy ),
    .enq_msg ( out_q$enq_msg ),
    .enq_val ( out_q$enq_val ),
    .deq_msg ( out_q$deq_msg ),
    .deq_val ( out_q$deq_val ),
    .enq_rdy ( out_q$enq_rdy )
  );

  // signal connections
  assign ctrlregs$000$clk     = clk;
  assign ctrlregs$000$en      = cr_go_en;
  assign ctrlregs$000$in_     = cr_go_in;
  assign ctrlregs$000$reset   = reset;
  assign ctrlregs$001$clk     = clk;
  assign ctrlregs$001$en      = cr_debug_en;
  assign ctrlregs$001$in_     = cr_debug_in;
  assign ctrlregs$001$reset   = reset;
  assign ctrlregs$002$clk     = clk;
  assign ctrlregs$002$en      = cyclecounters_en;
  assign ctrlregs$002$in_     = cyclecounters_in;
  assign ctrlregs$002$reset   = reset;
  assign ctrlregs$003$clk     = clk;
  assign ctrlregs$003$en      = instcounters_en[0];
  assign ctrlregs$003$in_     = instcounters_in$000;
  assign ctrlregs$003$reset   = reset;
  assign ctrlregs$004$clk     = clk;
  assign ctrlregs$004$en      = instcounters_en[1];
  assign ctrlregs$004$in_     = instcounters_in$001;
  assign ctrlregs$004$reset   = reset;
  assign ctrlregs$005$clk     = clk;
  assign ctrlregs$005$en      = instcounters_en[2];
  assign ctrlregs$005$in_     = instcounters_in$002;
  assign ctrlregs$005$reset   = reset;
  assign ctrlregs$006$clk     = clk;
  assign ctrlregs$006$en      = instcounters_en[3];
  assign ctrlregs$006$in_     = instcounters_in$003;
  assign ctrlregs$006$reset   = reset;
  assign ctrlregs$007$clk     = clk;
  assign ctrlregs$007$en      = wire_host_en[0];
  assign ctrlregs$007$in_     = rf_wdata;
  assign ctrlregs$007$reset   = reset;
  assign ctrlregs$008$clk     = clk;
  assign ctrlregs$008$en      = wire_host_en[1];
  assign ctrlregs$008$in_     = rf_wdata;
  assign ctrlregs$008$reset   = reset;
  assign ctrlregs$009$clk     = clk;
  assign ctrlregs$009$en      = wire_host_en[2];
  assign ctrlregs$009$in_     = rf_wdata;
  assign ctrlregs$009$reset   = reset;
  assign ctrlregs$010$clk     = clk;
  assign ctrlregs$010$reset   = reset;
  assign ctrlregs$011$clk     = clk;
  assign ctrlregs$011$reset   = reset;
  assign ctrlregs$012$clk     = clk;
  assign ctrlregs$012$reset   = reset;
  assign ctrlregs$013$clk     = clk;
  assign ctrlregs$013$reset   = reset;
  assign ctrlregs$014$clk     = clk;
  assign ctrlregs$014$reset   = reset;
  assign ctrlregs$015$clk     = clk;
  assign ctrlregs$015$reset   = reset;
  assign cyclecounters_out    = ctrlregs$002$out;
  assign debug                = ctrlregs$001$out[0];
  assign go[0]                = ctrlregs$000$out[0];
  assign go[1]                = ctrlregs$000$out[0];
  assign go[2]                = ctrlregs$000$out[0];
  assign go[3]                = ctrlregs$000$out[0];
  assign host_en[0]           = ctrlregs$007$out[0];
  assign host_en[1]           = ctrlregs$008$out[0];
  assign host_en[2]           = ctrlregs$009$out[0];
  assign in_q$clk             = clk;
  assign in_q$deq_rdy         = out_q$enq_rdy;
  assign in_q$enq_msg         = req_msg;
  assign in_q$enq_val         = req_val;
  assign in_q$reset           = reset;
  assign instcounters_out$000 = ctrlregs$003$out;
  assign instcounters_out$001 = ctrlregs$004$out;
  assign instcounters_out$002 = ctrlregs$005$out;
  assign instcounters_out$003 = ctrlregs$006$out;
  assign out_q$clk            = clk;
  assign out_q$deq_rdy        = resp_rdy;
  assign out_q$enq_val        = in_q$deq_val;
  assign out_q$reset          = reset;
  assign req_rdy              = in_q$enq_rdy;
  assign resp_msg             = out_q$deq_msg;
  assign resp_val             = out_q$deq_val;

  // array declarations
  wire   [  31:0] ctrlregs$out[0:15];
  assign ctrlregs$out[  0] = ctrlregs$000$out;
  assign ctrlregs$out[  1] = ctrlregs$001$out;
  assign ctrlregs$out[  2] = ctrlregs$002$out;
  assign ctrlregs$out[  3] = ctrlregs$003$out;
  assign ctrlregs$out[  4] = ctrlregs$004$out;
  assign ctrlregs$out[  5] = ctrlregs$005$out;
  assign ctrlregs$out[  6] = ctrlregs$006$out;
  assign ctrlregs$out[  7] = ctrlregs$007$out;
  assign ctrlregs$out[  8] = ctrlregs$008$out;
  assign ctrlregs$out[  9] = ctrlregs$009$out;
  assign ctrlregs$out[ 10] = ctrlregs$010$out;
  assign ctrlregs$out[ 11] = ctrlregs$011$out;
  assign ctrlregs$out[ 12] = ctrlregs$012$out;
  assign ctrlregs$out[ 13] = ctrlregs$013$out;
  assign ctrlregs$out[ 14] = ctrlregs$014$out;
  assign ctrlregs$out[ 15] = ctrlregs$015$out;
  reg    [  31:0] instcounters_in[0:3];
  assign instcounters_in$000 = instcounters_in[  0];
  assign instcounters_in$001 = instcounters_in[  1];
  assign instcounters_in$002 = instcounters_in[  2];
  assign instcounters_in$003 = instcounters_in[  3];
  wire   [  31:0] instcounters_out[0:3];
  assign instcounters_out[  0] = instcounters_out$000;
  assign instcounters_out[  1] = instcounters_out$001;
  assign instcounters_out[  2] = instcounters_out$002;
  assign instcounters_out[  3] = instcounters_out$003;

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_rf_read_interface():
  //       s.rf_raddr.value = s.in_q.deq.msg.addr
  //       s.rf_rdata.value = s.ctrlregs[ s.rf_raddr ].out

  // logic for comb_rf_read_interface()
  always @ (*) begin
    rf_raddr = in_q$deq_msg[(36)-1:32];
    rf_rdata = ctrlregs$out[rf_raddr];
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_rf_write_interface():
  //       s.rf_waddr.value = s.in_q.deq.msg.addr
  //       s.rf_wdata.value = s.in_q.deq.msg.data
  //       s.rf_wen.value   = s.in_q.deq.val & \
  //           ( s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE )

  // logic for comb_rf_write_interface()
  always @ (*) begin
    rf_waddr = in_q$deq_msg[(36)-1:32];
    rf_wdata = in_q$deq_msg[(32)-1:0];
    rf_wen = (in_q$deq_val&(in_q$deq_msg[(37)-1:36] == TYPE_WRITE));
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cr_go_logic():
  //       s.cr_go_en.value = s.rf_wen & ( s.rf_waddr == cr_go )
  //       s.cr_go_in.value = s.rf_wdata

  // logic for comb_cr_go_logic()
  always @ (*) begin
    cr_go_en = (rf_wen&(rf_waddr == cr_go));
    cr_go_in = rf_wdata;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cr_debug_logic():
  //       s.cr_debug_en.value = s.rf_wen & ( s.rf_waddr == cr_debug )
  //       s.cr_debug_in.value = s.rf_wdata

  // logic for comb_cr_debug_logic()
  always @ (*) begin
    cr_debug_en = (rf_wen&(rf_waddr == cr_debug));
    cr_debug_in = rf_wdata;
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cr_instcounter_logic():
  //       for core_idx in xrange(num_cores):
  //         s.instcounters_en[core_idx].value = s.commit_inst[core_idx] & s.stats_en
  //         s.instcounters_in[core_idx].value = s.instcounters_out[core_idx] + 1

  // logic for comb_cr_instcounter_logic()
  always @ (*) begin
    for (core_idx=0; core_idx < num_cores; core_idx=core_idx+1)
    begin
      instcounters_en[core_idx] = (commit_inst[core_idx]&stats_en);
      instcounters_in[core_idx] = (instcounters_out[core_idx]+1);
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cr_cyclecounter_logic():
  //       s.cyclecounters_en.value = s.stats_en
  //       s.cyclecounters_in.value = s.cyclecounters_out + 1

  // logic for comb_cr_cyclecounter_logic()
  always @ (*) begin
    cyclecounters_en = stats_en;
    cyclecounters_in = (cyclecounters_out+1);
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_cr_hosten_logic():
  //       for idx in xrange(valrdy_ifcs):
  //         s.wire_host_en[idx].value = s.rf_wen & ( s.rf_waddr == ( idx + cr_host_en ) )

  // logic for comb_cr_hosten_logic()
  always @ (*) begin
    for (idx=0; idx < valrdy_ifcs; idx=idx+1)
    begin
      wire_host_en[idx] = (rf_wen&(rf_waddr == (idx+cr_host_en)));
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_resp_msg():
  //       s.out_q.enq.msg.type_.value  = s.in_q.deq.msg.type_
  //
  //       if s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE:
  //         s.out_q.enq.msg.data.value = 0
  //       else:
  //         s.out_q.enq.msg.data.value = s.rf_rdata

  // logic for comb_resp_msg()
  always @ (*) begin
    out_q$enq_msg[(33)-1:32] = in_q$deq_msg[(37)-1:36];
    if ((in_q$deq_msg[(37)-1:36] == TYPE_WRITE)) begin
      out_q$enq_msg[(32)-1:0] = 0;
    end
    else begin
      out_q$enq_msg[(32)-1:0] = rf_rdata;
    end
  end


endmodule // CtrlReg_0x2547fdfd5863c73b
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementNormalQueue_0x5cdd7a7d31cf6b7d
//-----------------------------------------------------------------------------
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementNormalQueue_0x5cdd7a7d31cf6b7d
(
  input  wire [   0:0] clk,
  output wire [  36:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  36:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementNormalQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk     ( ctrl$clk ),
    .enq_val ( ctrl$enq_val ),
    .reset   ( ctrl$reset ),
    .deq_rdy ( ctrl$deq_rdy ),
    .wen     ( ctrl$wen ),
    .deq_val ( ctrl$deq_val ),
    .enq_rdy ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$clk;
  wire   [  36:0] dpath$enq_bits;
  wire   [   0:0] dpath$wen;
  wire   [  36:0] dpath$deq_bits;

  SingleElementNormalQueueDpath_0x5cdd7a7d31cf6b7d dpath
  (
    .reset    ( dpath$reset ),
    .clk      ( dpath$clk ),
    .enq_bits ( dpath$enq_bits ),
    .wen      ( dpath$wen ),
    .deq_bits ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk       = clk;
  assign ctrl$deq_rdy   = deq_rdy;
  assign ctrl$enq_val   = enq_val;
  assign ctrl$reset     = reset;
  assign deq_msg        = dpath$deq_bits;
  assign deq_val        = ctrl$deq_val;
  assign dpath$clk      = clk;
  assign dpath$enq_bits = enq_msg;
  assign dpath$reset    = reset;
  assign dpath$wen      = ctrl$wen;
  assign enq_rdy        = ctrl$enq_rdy;



endmodule // SingleElementNormalQueue_0x5cdd7a7d31cf6b7d
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementNormalQueueCtrl_0x2a979dc5ff91cb88
//-----------------------------------------------------------------------------
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementNormalQueueCtrl_0x2a979dc5ff91cb88
(
  input  wire [   0:0] clk,
  input  wire [   0:0] deq_rdy,
  output reg  [   0:0] deq_val,
  output reg  [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  input  wire [   0:0] reset,
  output reg  [   0:0] wen
);

  // register declarations
  reg    [   0:0] full;



  // PYMTL SOURCE:
  //
  // @s.posedge_clk
  // def seq():
  //
  //       # full bit calculation: the full bit is cleared when a dequeue
  //       # transaction occurs, the full bit is set when the queue storage is
  //       # empty and a enqueue transaction occurs
  //
  //       if   s.reset:                 s.full.next = 0
  //       elif s.deq_rdy and s.deq_val: s.full.next = 0
  //       elif s.enq_rdy and s.enq_val: s.full.next = 1
  //       else:                         s.full.next = s.full

  // logic for seq()
  always @ (posedge clk) begin
    if (reset) begin
      full <= 0;
    end
    else begin
      if ((deq_rdy&&deq_val)) begin
        full <= 0;
      end
      else begin
        if ((enq_rdy&&enq_val)) begin
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
  //       # full
  //
  //       s.deq_val.value = s.full

  // logic for comb()
  always @ (*) begin
    wen = (~full&enq_val);
    enq_rdy = ~full;
    deq_val = full;
  end


endmodule // SingleElementNormalQueueCtrl_0x2a979dc5ff91cb88
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementNormalQueueDpath_0x5cdd7a7d31cf6b7d
//-----------------------------------------------------------------------------
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementNormalQueueDpath_0x5cdd7a7d31cf6b7d
(
  input  wire [   0:0] clk,
  output wire [  36:0] deq_bits,
  input  wire [  36:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  36:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  36:0] queue$out;

  RegEn_0x3ed9fadb7a785162 queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign deq_bits    = queue$out;
  assign queue$clk   = clk;
  assign queue$en    = wen;
  assign queue$in_   = enq_bits;
  assign queue$reset = reset;



endmodule // SingleElementNormalQueueDpath_0x5cdd7a7d31cf6b7d
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x3ed9fadb7a785162
//-----------------------------------------------------------------------------
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x3ed9fadb7a785162
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  36:0] in_,
  output reg  [  36:0] out,
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


endmodule // RegEn_0x3ed9fadb7a785162
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementNormalQueue_0x79667c2fcd82f209
//-----------------------------------------------------------------------------
// dtype: 33
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementNormalQueue_0x79667c2fcd82f209
(
  input  wire [   0:0] clk,
  output wire [  32:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  32:0] enq_msg,
  output wire [   0:0] enq_rdy,
  input  wire [   0:0] enq_val,
  input  wire [   0:0] reset
);

  // ctrl temporaries
  wire   [   0:0] ctrl$clk;
  wire   [   0:0] ctrl$enq_val;
  wire   [   0:0] ctrl$reset;
  wire   [   0:0] ctrl$deq_rdy;
  wire   [   0:0] ctrl$wen;
  wire   [   0:0] ctrl$deq_val;
  wire   [   0:0] ctrl$enq_rdy;

  SingleElementNormalQueueCtrl_0x2a979dc5ff91cb88 ctrl
  (
    .clk     ( ctrl$clk ),
    .enq_val ( ctrl$enq_val ),
    .reset   ( ctrl$reset ),
    .deq_rdy ( ctrl$deq_rdy ),
    .wen     ( ctrl$wen ),
    .deq_val ( ctrl$deq_val ),
    .enq_rdy ( ctrl$enq_rdy )
  );

  // dpath temporaries
  wire   [   0:0] dpath$reset;
  wire   [   0:0] dpath$clk;
  wire   [  32:0] dpath$enq_bits;
  wire   [   0:0] dpath$wen;
  wire   [  32:0] dpath$deq_bits;

  SingleElementNormalQueueDpath_0x79667c2fcd82f209 dpath
  (
    .reset    ( dpath$reset ),
    .clk      ( dpath$clk ),
    .enq_bits ( dpath$enq_bits ),
    .wen      ( dpath$wen ),
    .deq_bits ( dpath$deq_bits )
  );

  // signal connections
  assign ctrl$clk       = clk;
  assign ctrl$deq_rdy   = deq_rdy;
  assign ctrl$enq_val   = enq_val;
  assign ctrl$reset     = reset;
  assign deq_msg        = dpath$deq_bits;
  assign deq_val        = ctrl$deq_val;
  assign dpath$clk      = clk;
  assign dpath$enq_bits = enq_msg;
  assign dpath$reset    = reset;
  assign dpath$wen      = ctrl$wen;
  assign enq_rdy        = ctrl$enq_rdy;



endmodule // SingleElementNormalQueue_0x79667c2fcd82f209
`default_nettype wire

//-----------------------------------------------------------------------------
// SingleElementNormalQueueDpath_0x79667c2fcd82f209
//-----------------------------------------------------------------------------
// dtype: 33
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module SingleElementNormalQueueDpath_0x79667c2fcd82f209
(
  input  wire [   0:0] clk,
  output wire [  32:0] deq_bits,
  input  wire [  32:0] enq_bits,
  input  wire [   0:0] reset,
  input  wire [   0:0] wen
);

  // queue temporaries
  wire   [   0:0] queue$reset;
  wire   [  32:0] queue$in_;
  wire   [   0:0] queue$clk;
  wire   [   0:0] queue$en;
  wire   [  32:0] queue$out;

  RegEn_0x77783ba1bb4fce3e queue
  (
    .reset ( queue$reset ),
    .in_   ( queue$in_ ),
    .clk   ( queue$clk ),
    .en    ( queue$en ),
    .out   ( queue$out )
  );

  // signal connections
  assign deq_bits    = queue$out;
  assign queue$clk   = clk;
  assign queue$en    = wen;
  assign queue$in_   = enq_bits;
  assign queue$reset = reset;



endmodule // SingleElementNormalQueueDpath_0x79667c2fcd82f209
`default_nettype wire

//-----------------------------------------------------------------------------
// RegEn_0x77783ba1bb4fce3e
//-----------------------------------------------------------------------------
// dtype: 33
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegEn_0x77783ba1bb4fce3e
(
  input  wire [   0:0] clk,
  input  wire [   0:0] en,
  input  wire [  32:0] in_,
  output reg  [  32:0] out,
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


endmodule // RegEn_0x77783ba1bb4fce3e
`default_nettype wire

//-----------------------------------------------------------------------------
// HostAdapter_MemReqMsg_8_32_128_MemRespMsg_8_128
//-----------------------------------------------------------------------------
// resp: <pymtl.model.signals.OutPort object at 0x7f9ba2539050>
// req: <pymtl.model.signals.InPort object at 0x7f9ba2531b50>
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostAdapter_MemReqMsg_8_32_128_MemRespMsg_8_128
(
  input  wire [   0:0] clk,
  input  wire [   0:0] host_en,
  input  wire [ 175:0] hostreq_msg,
  output reg  [   0:0] hostreq_rdy,
  input  wire [   0:0] hostreq_val,
  output reg  [ 145:0] hostresp_msg,
  input  wire [   0:0] hostresp_rdy,
  output reg  [   0:0] hostresp_val,
  input  wire [ 175:0] realreq_msg,
  output reg  [   0:0] realreq_rdy,
  input  wire [   0:0] realreq_val,
  output reg  [ 145:0] realresp_msg,
  input  wire [   0:0] realresp_rdy,
  output reg  [   0:0] realresp_val,
  output reg  [ 175:0] req_msg,
  input  wire [   0:0] req_rdy,
  output reg  [   0:0] req_val,
  input  wire [   0:0] reset,
  input  wire [ 145:0] resp_msg,
  output reg  [   0:0] resp_rdy,
  input  wire [   0:0] resp_val
);



  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_req_select():
  //
  //       if s.host_en:
  //         # Mute req
  //         s.realreq.rdy.value  = 0
  //         s.realresp.val.value = 0
  //         s.realresp.msg.value = 0
  //
  //         # instance.req <- hostreq
  //         s.req.val.value      = s.hostreq.val
  //         s.req.msg.value      = s.hostreq.msg
  //         s.hostreq.rdy.value  = s.req.rdy
  //
  //         # hostresp <- out_resp
  //         s.hostresp.val.value = s.resp.val
  //         s.hostresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.hostresp.rdy
  //
  //       else:
  //         # Mute host
  //         s.hostreq.rdy.value  = 0
  //         s.hostresp.val.value = 0
  //         s.hostresp.msg.value = 0
  //
  //         # req <- realreq
  //         s.req.val.value      = s.realreq.val
  //         s.req.msg.value      = s.realreq.msg
  //         s.realreq.rdy.value  = s.req.rdy
  //
  //         # realresp <- resp
  //         s.realresp.val.value = s.resp.val
  //         s.realresp.msg.value = s.resp.msg
  //         s.resp.rdy.value     = s.realresp.rdy

  // logic for comb_req_select()
  always @ (*) begin
    if (host_en) begin
      realreq_rdy = 0;
      realresp_val = 0;
      realresp_msg = 0;
      req_val = hostreq_val;
      req_msg = hostreq_msg;
      hostreq_rdy = req_rdy;
      hostresp_val = resp_val;
      hostresp_msg = resp_msg;
      resp_rdy = hostresp_rdy;
    end
    else begin
      hostreq_rdy = 0;
      hostresp_val = 0;
      hostresp_msg = 0;
      req_val = realreq_val;
      req_msg = realreq_msg;
      realreq_rdy = req_rdy;
      realresp_val = resp_val;
      realresp_msg = resp_msg;
      resp_rdy = realresp_rdy;
    end
  end


endmodule // HostAdapter_MemReqMsg_8_32_128_MemRespMsg_8_128
`default_nettype wire

//-----------------------------------------------------------------------------
// Router_0x3fd90561b3d11051
//-----------------------------------------------------------------------------
// nports: 4
// MsgType: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Router_0x3fd90561b3d11051
(
  input  wire [   0:0] clk,
  input  wire [ 145:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [ 145:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  output wire [ 145:0] out$001_msg,
  input  wire [   0:0] out$001_rdy,
  output wire [   0:0] out$001_val,
  output wire [ 145:0] out$002_msg,
  input  wire [   0:0] out$002_rdy,
  output wire [   0:0] out$002_val,
  output wire [ 145:0] out$003_msg,
  input  wire [   0:0] out$003_rdy,
  output wire [   0:0] out$003_val,
  input  wire [   0:0] reset
);

  // localparam declarations
  localparam nports = 4;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [ 145:0] out_msg[0:3];
  assign out$000_msg = out_msg[  0];
  assign out$001_msg = out_msg[  1];
  assign out$002_msg = out_msg[  2];
  assign out$003_msg = out_msg[  3];
  wire   [   0:0] out_rdy[0:3];
  assign out_rdy[  0] = out$000_rdy;
  assign out_rdy[  1] = out$001_rdy;
  assign out_rdy[  2] = out$002_rdy;
  assign out_rdy[  3] = out$003_rdy;
  reg    [   0:0] out_val[0:3];
  assign out$000_val = out_val[  0];
  assign out$001_val = out_val[  1];
  assign out$002_val = out_val[  2];
  assign out$003_val = out_val[  3];

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_out_val():
  //       for i in xrange( nports ):
  //         s.out[i].val.value = 0
  //         s.out[i].msg.value = 0
  //
  //       if s.in_.val:
  //         s.out[ s.in_.msg.opaque ].val.value = s.in_.val
  //         s.out[ s.in_.msg.opaque ].msg.value = s.in_.msg

  // logic for comb_out_val()
  always @ (*) begin
    for (i=0; i < nports; i=i+1)
    begin
      out_val[i] = 0;
      out_msg[i] = 0;
    end
    if (in__val) begin
      out_val[in__msg[(142)-1:134]] = in__val;
      out_msg[in__msg[(142)-1:134]] = in__msg;
    end
    else begin
    end
  end

  // PYMTL SOURCE:
  //
  // @s.combinational
  // def comb_in_rdy():
  //       # in_rdy is the rdy status of the opaque-th output
  //       s.in_.rdy.value = s.out[ s.in_.msg.opaque ].rdy

  // logic for comb_in_rdy()
  always @ (*) begin
    in__rdy = out_rdy[in__msg[(142)-1:134]];
  end


endmodule // Router_0x3fd90561b3d11051
`default_nettype wire

//-----------------------------------------------------------------------------
// ValRdySplit_0x3e9b0f76bc7cb9b3
//-----------------------------------------------------------------------------
// p_nports: 10
// p_nbits: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module ValRdySplit_0x3e9b0f76bc7cb9b3
(
  input  wire [   0:0] clk,
  input  wire [ 185:0] in__msg,
  output reg  [   0:0] in__rdy,
  input  wire [   0:0] in__val,
  output wire [ 175:0] out$000_msg,
  input  wire [   0:0] out$000_rdy,
  output wire [   0:0] out$000_val,
  output wire [ 175:0] out$001_msg,
  input  wire [   0:0] out$001_rdy,
  output wire [   0:0] out$001_val,
  output wire [ 175:0] out$002_msg,
  input  wire [   0:0] out$002_rdy,
  output wire [   0:0] out$002_val,
  output wire [ 175:0] out$003_msg,
  input  wire [   0:0] out$003_rdy,
  output wire [   0:0] out$003_val,
  output wire [ 175:0] out$004_msg,
  input  wire [   0:0] out$004_rdy,
  output wire [   0:0] out$004_val,
  output wire [ 175:0] out$005_msg,
  input  wire [   0:0] out$005_rdy,
  output wire [   0:0] out$005_val,
  output wire [ 175:0] out$006_msg,
  input  wire [   0:0] out$006_rdy,
  output wire [   0:0] out$006_val,
  output wire [ 175:0] out$007_msg,
  input  wire [   0:0] out$007_rdy,
  output wire [   0:0] out$007_val,
  output wire [ 175:0] out$008_msg,
  input  wire [   0:0] out$008_rdy,
  output wire [   0:0] out$008_val,
  output wire [ 175:0] out$009_msg,
  input  wire [   0:0] out$009_rdy,
  output wire [   0:0] out$009_val,
  input  wire [   0:0] reset
);

  // wire declarations
  wire   [   9:0] channel;
  wire   [   9:0] out_rdy;


  // register declarations
  reg    [   9:0] out_val;

  // localparam declarations
  localparam p_nports = 10;

  // demux temporaries
  wire   [   0:0] demux$reset;
  wire   [ 175:0] demux$in_;
  wire   [   0:0] demux$clk;
  wire   [   9:0] demux$sel;
  wire   [ 175:0] demux$out$000;
  wire   [ 175:0] demux$out$001;
  wire   [ 175:0] demux$out$002;
  wire   [ 175:0] demux$out$003;
  wire   [ 175:0] demux$out$004;
  wire   [ 175:0] demux$out$005;
  wire   [ 175:0] demux$out$006;
  wire   [ 175:0] demux$out$007;
  wire   [ 175:0] demux$out$008;
  wire   [ 175:0] demux$out$009;

  Demux_0x5c38b318cac8f45c demux
  (
    .reset   ( demux$reset ),
    .in_     ( demux$in_ ),
    .clk     ( demux$clk ),
    .sel     ( demux$sel ),
    .out$000 ( demux$out$000 ),
    .out$001 ( demux$out$001 ),
    .out$002 ( demux$out$002 ),
    .out$003 ( demux$out$003 ),
    .out$004 ( demux$out$004 ),
    .out$005 ( demux$out$005 ),
    .out$006 ( demux$out$006 ),
    .out$007 ( demux$out$007 ),
    .out$008 ( demux$out$008 ),
    .out$009 ( demux$out$009 )
  );

  // signal connections
  assign channel     = in__msg[185:176];
  assign demux$clk   = clk;
  assign demux$in_   = in__msg[175:0];
  assign demux$reset = reset;
  assign demux$sel   = channel;
  assign out$000_msg = demux$out$000;
  assign out$000_val = out_val[0];
  assign out$001_msg = demux$out$001;
  assign out$001_val = out_val[1];
  assign out$002_msg = demux$out$002;
  assign out$002_val = out_val[2];
  assign out$003_msg = demux$out$003;
  assign out$003_val = out_val[3];
  assign out$004_msg = demux$out$004;
  assign out$004_val = out_val[4];
  assign out$005_msg = demux$out$005;
  assign out$005_val = out_val[5];
  assign out$006_msg = demux$out$006;
  assign out$006_val = out_val[6];
  assign out$007_msg = demux$out$007;
  assign out$007_val = out_val[7];
  assign out$008_msg = demux$out$008;
  assign out$008_val = out_val[8];
  assign out$009_msg = demux$out$009;
  assign out$009_val = out_val[9];
  assign out_rdy[0]  = out$000_rdy;
  assign out_rdy[1]  = out$001_rdy;
  assign out_rdy[2]  = out$002_rdy;
  assign out_rdy[3]  = out$003_rdy;
  assign out_rdy[4]  = out$004_rdy;
  assign out_rdy[5]  = out$005_rdy;
  assign out_rdy[6]  = out$006_rdy;
  assign out_rdy[7]  = out$007_rdy;
  assign out_rdy[8]  = out$008_rdy;
  assign out_rdy[9]  = out$009_rdy;


  // PYMTL SOURCE:
  //
  // @s.combinational
  // def combinational_logic():
  //         s.out_val.value = sext( s.in_.val, p_nports ) & s.channel
  //         s.in_.rdy.value = reduce_or( s.channel & s.out_rdy )

  // logic for combinational_logic()
  always @ (*) begin
    out_val = ({ { p_nports-1 { in__val[0] } }, in__val[0:0] }&channel);
    in__rdy = (|(channel&out_rdy));
  end


endmodule // ValRdySplit_0x3e9b0f76bc7cb9b3
`default_nettype wire

//-----------------------------------------------------------------------------
// Demux_0x5c38b318cac8f45c
//-----------------------------------------------------------------------------
// nports: 10
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module Demux_0x5c38b318cac8f45c
(
  input  wire [   0:0] clk,
  input  wire [ 175:0] in_,
  output wire [ 175:0] out$000,
  output wire [ 175:0] out$001,
  output wire [ 175:0] out$002,
  output wire [ 175:0] out$003,
  output wire [ 175:0] out$004,
  output wire [ 175:0] out$005,
  output wire [ 175:0] out$006,
  output wire [ 175:0] out$007,
  output wire [ 175:0] out$008,
  output wire [ 175:0] out$009,
  input  wire [   0:0] reset,
  input  wire [   9:0] sel
);

  // localparam declarations
  localparam nports = 10;

  // loop variable declarations
  integer i;


  // array declarations
  reg    [ 175:0] out[0:9];
  assign out$000 = out[  0];
  assign out$001 = out[  1];
  assign out$002 = out[  2];
  assign out$003 = out[  3];
  assign out$004 = out[  4];
  assign out$005 = out[  5];
  assign out$006 = out[  6];
  assign out$007 = out[  7];
  assign out$008 = out[  8];
  assign out$009 = out[  9];

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


endmodule // Demux_0x5c38b318cac8f45c
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

