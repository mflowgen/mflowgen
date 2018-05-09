//-----------------------------------------------------------------------------
// HostButterfree
//-----------------------------------------------------------------------------
// asynch_bitwidth: 8
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module HostButterfree
(
  input  wire [   0:0] clk,
  output wire [   0:0] in__ack,
  input  wire [   7:0] in__msg,
  input  wire [   0:0] in__req,
  input  wire [   0:0] out_ack,
  output wire [   7:0] out_msg,
  output wire [   0:0] out_req,
  input  wire [   0:0] reset
);

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
  wire   [   3:0] in_q$000$num_free_entries;
  wire   [ 145:0] in_q$000$deq_msg;
  wire   [   0:0] in_q$000$deq_val;

  NormalQueue_0x13101d59dbd845e9 in_q$000
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
  wire   [   3:0] in_q$001$num_free_entries;
  wire   [ 175:0] in_q$001$deq_msg;
  wire   [   0:0] in_q$001$deq_val;

  NormalQueue_0x693d9fdf75eefee7 in_q$001
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
  wire   [   3:0] in_q$002$num_free_entries;
  wire   [  36:0] in_q$002$deq_msg;
  wire   [   0:0] in_q$002$deq_val;

  NormalQueue_0x2f5639163bab99dc in_q$002
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
  wire   [   3:0] in_q$003$num_free_entries;
  wire   [  77:0] in_q$003$deq_msg;
  wire   [   0:0] in_q$003$deq_val;

  NormalQueue_0x1d47c7c731267113 in_q$003
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
  wire   [   3:0] in_q$004$num_free_entries;
  wire   [ 145:0] in_q$004$deq_msg;
  wire   [   0:0] in_q$004$deq_val;

  NormalQueue_0x13101d59dbd845e9 in_q$004
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
  wire   [   3:0] in_q$005$num_free_entries;
  wire   [  69:0] in_q$005$deq_msg;
  wire   [   0:0] in_q$005$deq_val;

  NormalQueue_0x79370f78d0d01895 in_q$005
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
  wire   [   3:0] in_q$006$num_free_entries;
  wire   [  31:0] in_q$006$deq_msg;
  wire   [   0:0] in_q$006$deq_val;

  NormalQueue_0x5d6b3b47697c8177 in_q$006
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
  wire   [   3:0] in_q$007$num_free_entries;
  wire   [  31:0] in_q$007$deq_msg;
  wire   [   0:0] in_q$007$deq_val;

  NormalQueue_0x5d6b3b47697c8177 in_q$007
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
  wire   [   3:0] in_q$008$num_free_entries;
  wire   [  31:0] in_q$008$deq_msg;
  wire   [   0:0] in_q$008$deq_val;

  NormalQueue_0x5d6b3b47697c8177 in_q$008
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
  wire   [   3:0] in_q$009$num_free_entries;
  wire   [  31:0] in_q$009$deq_msg;
  wire   [   0:0] in_q$009$deq_val;

  NormalQueue_0x5d6b3b47697c8177 in_q$009
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
// NormalQueue_0x13101d59dbd845e9
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x13101d59dbd845e9
(
  input  wire [   0:0] clk,
  output wire [ 145:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [ 145:0] enq_msg,
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
  wire   [ 145:0] dpath$enq_bits;
  wire   [ 145:0] dpath$deq_bits;

  NormalQueueDpath_0x13101d59dbd845e9 dpath
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



endmodule // NormalQueue_0x13101d59dbd845e9
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
// NormalQueueDpath_0x13101d59dbd845e9
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 146
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x13101d59dbd845e9
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

  RegisterFile_0x7d76b6747bf51d1e queue
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



endmodule // NormalQueueDpath_0x13101d59dbd845e9
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x7d76b6747bf51d1e
//-----------------------------------------------------------------------------
// dtype: 146
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x7d76b6747bf51d1e
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [ 145:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [ 145:0] regs[0:9];
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


endmodule // RegisterFile_0x7d76b6747bf51d1e
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x693d9fdf75eefee7
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x693d9fdf75eefee7
(
  input  wire [   0:0] clk,
  output wire [ 175:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [ 175:0] enq_msg,
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
  wire   [ 175:0] dpath$enq_bits;
  wire   [ 175:0] dpath$deq_bits;

  NormalQueueDpath_0x693d9fdf75eefee7 dpath
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



endmodule // NormalQueue_0x693d9fdf75eefee7
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x693d9fdf75eefee7
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 176
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x693d9fdf75eefee7
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

  RegisterFile_0x540da3782093b314 queue
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



endmodule // NormalQueueDpath_0x693d9fdf75eefee7
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x540da3782093b314
//-----------------------------------------------------------------------------
// dtype: 176
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x540da3782093b314
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [ 175:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [ 175:0] regs[0:9];
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


endmodule // RegisterFile_0x540da3782093b314
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x2f5639163bab99dc
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x2f5639163bab99dc
(
  input  wire [   0:0] clk,
  output wire [  36:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  36:0] enq_msg,
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
  wire   [  36:0] dpath$enq_bits;
  wire   [  36:0] dpath$deq_bits;

  NormalQueueDpath_0x2f5639163bab99dc dpath
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



endmodule // NormalQueue_0x2f5639163bab99dc
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x2f5639163bab99dc
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 37
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x2f5639163bab99dc
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

  RegisterFile_0x7aa13ae1703f6c2f queue
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



endmodule // NormalQueueDpath_0x2f5639163bab99dc
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x7aa13ae1703f6c2f
//-----------------------------------------------------------------------------
// dtype: 37
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x7aa13ae1703f6c2f
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  36:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  36:0] regs[0:9];
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


endmodule // RegisterFile_0x7aa13ae1703f6c2f
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x1d47c7c731267113
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x1d47c7c731267113
(
  input  wire [   0:0] clk,
  output wire [  77:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  77:0] enq_msg,
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
  wire   [  77:0] dpath$enq_bits;
  wire   [  77:0] dpath$deq_bits;

  NormalQueueDpath_0x1d47c7c731267113 dpath
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



endmodule // NormalQueue_0x1d47c7c731267113
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x1d47c7c731267113
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 78
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x1d47c7c731267113
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

  RegisterFile_0x4037074424b65b2 queue
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



endmodule // NormalQueueDpath_0x1d47c7c731267113
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x4037074424b65b2
//-----------------------------------------------------------------------------
// dtype: 78
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x4037074424b65b2
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  77:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  77:0] regs[0:9];
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


endmodule // RegisterFile_0x4037074424b65b2
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueue_0x79370f78d0d01895
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueue_0x79370f78d0d01895
(
  input  wire [   0:0] clk,
  output wire [  69:0] deq_msg,
  input  wire [   0:0] deq_rdy,
  output wire [   0:0] deq_val,
  input  wire [  69:0] enq_msg,
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
  wire   [  69:0] dpath$enq_bits;
  wire   [  69:0] dpath$deq_bits;

  NormalQueueDpath_0x79370f78d0d01895 dpath
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



endmodule // NormalQueue_0x79370f78d0d01895
`default_nettype wire

//-----------------------------------------------------------------------------
// NormalQueueDpath_0x79370f78d0d01895
//-----------------------------------------------------------------------------
// num_entries: 10
// dtype: 70
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module NormalQueueDpath_0x79370f78d0d01895
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

  RegisterFile_0x3dd46087af21d76 queue
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



endmodule // NormalQueueDpath_0x79370f78d0d01895
`default_nettype wire

//-----------------------------------------------------------------------------
// RegisterFile_0x3dd46087af21d76
//-----------------------------------------------------------------------------
// dtype: 70
// nregs: 10
// const_zero: False
// wr_ports: 1
// rd_ports: 1
// dump-vcd: False
// verilator-xinit: zeros
`default_nettype none
module RegisterFile_0x3dd46087af21d76
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


  // localparam declarations
  localparam nregs = 10;
  localparam rd_ports = 1;

  // loop variable declarations
  integer i;


  // array declarations
  wire   [   3:0] rd_addr[0:0];
  assign rd_addr[  0] = rd_addr$000;
  reg    [  69:0] rd_data[0:0];
  assign rd_data$000 = rd_data[  0];
  reg    [  69:0] regs[0:9];
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


endmodule // RegisterFile_0x3dd46087af21d76
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

  BloomFilterXcel_0x4924e7298338bd96 xcel$000
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

  BloomFilterXcel_0x4924e7298338bd96 xcel$001
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

  BloomFilterXcel_0x4924e7298338bd96 xcel$002
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

  BloomFilterXcel_0x4924e7298338bd96 xcel$003
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
  assign dcache$cachereq_msg         = xcel$000$memreq_snoop_msg;
  assign dcache$cachereq_msg         = xcel$001$memreq_snoop_msg;
  assign dcache$cachereq_msg         = xcel$002$memreq_snoop_msg;
  assign dcache$cachereq_msg         = xcel$003$memreq_snoop_msg;
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
  assign xcel$000$memreq_snoop_val   = cachereq_go;
  assign xcel$000$reset              = reset;
  assign xcel$000$xcelreq_msg        = proc$000$xcelreq_msg;
  assign xcel$000$xcelreq_val        = proc$000$xcelreq_val;
  assign xcel$000$xcelresp_rdy       = proc$000$xcelresp_rdy;
  assign xcel$001$clk                = clk;
  assign xcel$001$memreq_snoop_val   = cachereq_go;
  assign xcel$001$reset              = reset;
  assign xcel$001$xcelreq_msg        = proc$001$xcelreq_msg;
  assign xcel$001$xcelreq_val        = proc$001$xcelreq_val;
  assign xcel$001$xcelresp_rdy       = proc$001$xcelresp_rdy;
  assign xcel$002$clk                = clk;
  assign xcel$002$memreq_snoop_val   = cachereq_go;
  assign xcel$002$reset              = reset;
  assign xcel$002$xcelreq_msg        = proc$002$xcelreq_msg;
  assign xcel$002$xcelreq_val        = proc$002$xcelreq_val;
  assign xcel$002$xcelresp_rdy       = proc$002$xcelresp_rdy;
  assign xcel$003$clk                = clk;
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
// resp: <pymtl.model.signals.OutPort object at 0x7f6d48f886d0>
// req: <pymtl.model.signals.InPort object at 0x7f6d48f880d0>
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

