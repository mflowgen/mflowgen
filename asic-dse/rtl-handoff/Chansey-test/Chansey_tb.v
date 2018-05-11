//=========================================================================
// Processor Simulator Harness
//=========================================================================

`include "vc/vc-TestRandDelayMemory_1i1d.v"
`include "vc/vc-TestRandDelaySource.v"
`include "vc/vc-TestRandDelaySink.v"

`define CLK_PERIOD 10

//------------------------------------------------------------------------
// Helper Module
//------------------------------------------------------------------------

module TestHarness
#(
  parameter p_mem_nbytes  = 1 << 28 // size of physical memory in bytes
)(
  input  logic        clk,
  input  logic        reset,
  input  logic        clear,
  input  logic [31:0] src_max_delay,
  input  logic [31:0] mem_max_delay,
  input  logic [31:0] sink_max_delay,
  output logic        done
);

  //----------------------------------------------------------------------
  // Signals of CtrlReg
  //----------------------------------------------------------------------

  logic [36:0] ctrlregreq_msg;
  logic [ 0:0] ctrlregreq_rdy;
  logic [ 0:0] ctrlregreq_val;
  logic [32:0] ctrlregresp_msg;
  logic [ 0:0] ctrlregresp_rdy;
  logic [ 0:0] ctrlregresp_val;

  //----------------------------------------------------------------------
  // Signals related to host isolation testing
  //----------------------------------------------------------------------

  logic [`REQ_NBITS(32)-1:0]   host_dcachereq_msg;
  logic [  0:0]                host_dcachereq_rdy;
  logic [  0:0]                host_dcachereq_val;
  logic [`RESP_NBITS(32)-1:0]  host_dcacheresp_msg;
  logic [  0:0]                host_dcacheresp_rdy;
  logic [  0:0]                host_dcacheresp_val;

  logic [`REQ_NBITS(128)-1:0]  host_icachereq_msg;
  logic [  0:0]                host_icachereq_rdy;
  logic [  0:0]                host_icachereq_val;
  logic [`RESP_NBITS(128)-1:0] host_icacheresp_msg;
  logic [  0:0]                host_icacheresp_rdy;
  logic [  0:0]                host_icacheresp_val;

  logic [ 69:0] host_mdureq_msg;
  logic [  0:0] host_mdureq_rdy;
  logic [  0:0] host_mdureq_val;
  logic [ 34:0] host_mduresp_msg;
  logic [  0:0] host_mduresp_rdy;
  logic [  0:0] host_mduresp_val;

  //----------------------------------------------------------------------
  // Signals to Procs
  //----------------------------------------------------------------------

  logic [ 31:0] mngr2proc_0_msg;
  logic [  0:0] mngr2proc_0_rdy;
  logic [  0:0] mngr2proc_0_val;
  logic [ 31:0] mngr2proc_1_msg;
  logic [  0:0] mngr2proc_1_rdy;
  logic [  0:0] mngr2proc_1_val;
  logic [ 31:0] mngr2proc_2_msg;
  logic [  0:0] mngr2proc_2_rdy;
  logic [  0:0] mngr2proc_2_val;
  logic [ 31:0] mngr2proc_3_msg;
  logic [  0:0] mngr2proc_3_rdy;
  logic [  0:0] mngr2proc_3_val;

  logic [ 31:0] proc2mngr_0_msg;
  logic [  0:0] proc2mngr_0_rdy;
  logic [  0:0] proc2mngr_0_val;
  logic [ 31:0] proc2mngr_1_msg;
  logic [  0:0] proc2mngr_1_rdy;
  logic [  0:0] proc2mngr_1_val;
  logic [ 31:0] proc2mngr_2_msg;
  logic [  0:0] proc2mngr_2_rdy;
  logic [  0:0] proc2mngr_2_val;
  logic [ 31:0] proc2mngr_3_msg;
  logic [  0:0] proc2mngr_3_rdy;
  logic [  0:0] proc2mngr_3_val;

  //----------------------------------------------------------------------
  // Signals to icache/dcache
  //----------------------------------------------------------------------

  logic                        imemreq_val;
  logic                        imemreq_rdy;
  logic [`REQ_NBITS(128)-1:0]  imemreq_msg;
  logic                        imemresp_val;
  logic                        imemresp_rdy;
  logic [`RESP_NBITS(128)-1:0] imemresp_msg;
  logic                        dmemreq_val;
  logic                        dmemreq_rdy;
  logic [`REQ_NBITS(128)-1:0]  dmemreq_msg;
  logic                        dmemresp_val;
  logic                        dmemresp_rdy;
  logic [`RESP_NBITS(128)-1:0] dmemresp_msg;

  //----------------------------------------------------------------------
  // src/sink done signals
  //----------------------------------------------------------------------

  logic src_ctrlreg_done, sink_ctrlreg_done;
  logic src_proc0_done, sink_proc0_done;
  logic src_proc1_done, sink_proc1_done;
  logic src_proc2_done, sink_proc2_done;
  logic src_proc3_done, sink_proc3_done;
  logic src_mdu_done, sink_mdu_done;
  logic src_icache_done, sink_icache_done;
  logic src_dcache_done, sink_dcache_done;

  //----------------------------------------------------------------------
  // DUT instantiation
  //----------------------------------------------------------------------

  HostChansey_SwShim dut
  (
    .clk                 (clk),
    .reset               (reset),
    .ctrlregreq_msg      (ctrlregreq_msg),
    .ctrlregreq_rdy      (ctrlregreq_rdy),
    .ctrlregreq_val      (ctrlregreq_val),
    .ctrlregresp_msg     (ctrlregresp_msg),
    .ctrlregresp_rdy     (ctrlregresp_rdy),
    .ctrlregresp_val     (ctrlregresp_val),
//    .debug               (debug),
    .dmemreq_msg         (dmemreq_msg),
    .dmemreq_rdy         (dmemreq_rdy),
    .dmemreq_val         (dmemreq_val),
    .dmemresp_msg        (dmemresp_msg),
    .dmemresp_rdy        (dmemresp_rdy),
    .dmemresp_val        (dmemresp_val),
    .host_dcachereq_msg  (host_dcachereq_msg),
    .host_dcachereq_rdy  (host_dcachereq_rdy),
    .host_dcachereq_val  (host_dcachereq_val),
    .host_dcacheresp_msg (host_dcacheresp_msg),
    .host_dcacheresp_rdy (host_dcacheresp_rdy),
    .host_dcacheresp_val (host_dcacheresp_val),
    .host_icachereq_msg  (host_icachereq_msg),
    .host_icachereq_rdy  (host_icachereq_rdy),
    .host_icachereq_val  (host_icachereq_val),
    .host_icacheresp_msg (host_icacheresp_msg),
    .host_icacheresp_rdy (host_icacheresp_rdy),
    .host_icacheresp_val (host_icacheresp_val),
    .host_mdureq_msg     (host_mdureq_msg),
    .host_mdureq_rdy     (host_mdureq_rdy),
    .host_mdureq_val     (host_mdureq_val),
    .host_mduresp_msg    (host_mduresp_msg),
    .host_mduresp_rdy    (host_mduresp_rdy),
    .host_mduresp_val    (host_mduresp_val),
    .imemreq_msg         (imemreq_msg),
    .imemreq_rdy         (imemreq_rdy),
    .imemreq_val         (imemreq_val),
    .imemresp_msg        (imemresp_msg),
    .imemresp_rdy        (imemresp_rdy),
    .imemresp_val        (imemresp_val),
    .mngr2proc_0_msg     (mngr2proc_0_msg),
    .mngr2proc_0_rdy     (mngr2proc_0_rdy),
    .mngr2proc_0_val     (mngr2proc_0_val),
    .mngr2proc_1_msg     (mngr2proc_1_msg),
    .mngr2proc_1_rdy     (mngr2proc_1_rdy),
    .mngr2proc_1_val     (mngr2proc_1_val),
    .mngr2proc_2_msg     (mngr2proc_2_msg),
    .mngr2proc_2_rdy     (mngr2proc_2_rdy),
    .mngr2proc_2_val     (mngr2proc_2_val),
    .mngr2proc_3_msg     (mngr2proc_3_msg),
    .mngr2proc_3_rdy     (mngr2proc_3_rdy),
    .mngr2proc_3_val     (mngr2proc_3_val),
    .proc2mngr_0_msg     (proc2mngr_0_msg),
    .proc2mngr_0_rdy     (proc2mngr_0_rdy),
    .proc2mngr_0_val     (proc2mngr_0_val),
    .proc2mngr_1_msg     (proc2mngr_1_msg),
    .proc2mngr_1_rdy     (proc2mngr_1_rdy),
    .proc2mngr_1_val     (proc2mngr_1_val),
    .proc2mngr_2_msg     (proc2mngr_2_msg),
    .proc2mngr_2_rdy     (proc2mngr_2_rdy),
    .proc2mngr_2_val     (proc2mngr_2_val),
    .proc2mngr_3_msg     (proc2mngr_3_msg),
    .proc2mngr_3_rdy     (proc2mngr_3_rdy),
    .proc2mngr_3_val     (proc2mngr_3_val)
  );

  //----------------------------------------------------------------------
  // Eight source/sink pairs
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  // ctrlreg
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(37),
    .p_num_msgs (1000)
  )
  src_ctrlreg
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (ctrlregreq_val),
    .rdy       (ctrlregreq_rdy),
    .msg       (ctrlregreq_msg),
    .done      (src_ctrlreg_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(33),
    .p_num_msgs (1000)
  )
  sink_ctrlreg
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (ctrlregresp_val),
    .rdy       (ctrlregresp_rdy),
    .msg       (ctrlregresp_msg),
    .done      (sink_ctrlreg_done)
  );

  //----------------------------------------------------------------------
  // Proc 0
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src_proc0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (mngr2proc_0_val),
    .rdy       (mngr2proc_0_rdy),
    .msg       (mngr2proc_0_msg),
    .done      (src_proc0_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink_proc0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (proc2mngr_0_val),
    .rdy       (proc2mngr_0_rdy),
    .msg       (proc2mngr_0_msg),
    .done      (sink_proc0_done)
  );

  //----------------------------------------------------------------------
  // Proc 1
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src_proc1
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (mngr2proc_1_val),
    .rdy       (mngr2proc_1_rdy),
    .msg       (mngr2proc_1_msg),
    .done      (src_proc1_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink_proc1
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (proc2mngr_1_val),
    .rdy       (proc2mngr_1_rdy),
    .msg       (proc2mngr_1_msg),
    .done      (sink_proc1_done)
  );

  //----------------------------------------------------------------------
  // Proc 2
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src_proc2
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (mngr2proc_2_val),
    .rdy       (mngr2proc_2_rdy),
    .msg       (mngr2proc_2_msg),
    .done      (src_proc2_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink_proc2
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (proc2mngr_2_val),
    .rdy       (proc2mngr_2_rdy),
    .msg       (proc2mngr_2_msg),
    .done      (sink_proc2_done)
  );

  //----------------------------------------------------------------------
  // Proc 3
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src_proc3
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (mngr2proc_3_val),
    .rdy       (mngr2proc_3_rdy),
    .msg       (mngr2proc_3_msg),
    .done      (src_proc3_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink_proc3
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (proc2mngr_3_val),
    .rdy       (proc2mngr_3_rdy),
    .msg       (proc2mngr_3_msg),
    .done      (sink_proc3_done)
  );

  //----------------------------------------------------------------------
  // Host's mdu
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(70),
    .p_num_msgs (1000)
  )
  src_mdu
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (host_mdureq_val),
    .rdy       (host_mdureq_rdy),
    .msg       (host_mdureq_msg),
    .done      (src_mdu_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(35),
    .p_num_msgs (1000)
  )
  sink_mdu
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (host_mduresp_val),
    .rdy       (host_mduresp_rdy),
    .msg       (host_mduresp_msg),
    .done      (sink_mdu_done)
  );

  //----------------------------------------------------------------------
  // Host's icache
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(`REQ_NBITS(128)),
    .p_num_msgs (1000)
  )
  src_icache
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (host_icachereq_val),
    .rdy       (host_icachereq_rdy),
    .msg       (host_icachereq_msg),
    .done      (src_icache_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(`RESP_NBITS(128)),
    .p_num_msgs (1000)
  )
  sink_icache
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (host_icacheresp_val),
    .rdy       (host_icacheresp_rdy),
    .msg       (host_icacheresp_msg),
    .done      (sink_icache_done)
  );

  //----------------------------------------------------------------------
  // Host's dcache
  //----------------------------------------------------------------------

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(`REQ_NBITS(32)),
    .p_num_msgs (1000)
  )
  src_dcache
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (host_dcachereq_val),
    .rdy       (host_dcachereq_rdy),
    .msg       (host_dcachereq_msg),
    .done      (src_dcache_done)
  );
  vc_TestRandDelaySink
  #(
    .p_msg_nbits(`RESP_NBITS(32)),
    .p_num_msgs (1000)
  )
  sink_dcache
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (host_dcacheresp_val),
    .rdy       (host_dcacheresp_rdy),
    .msg       (host_dcacheresp_msg),
    .done      (sink_dcache_done)
  );

  assign done = src_ctrlreg_done && sink_ctrlreg_done &&
                src_proc0_done && sink_proc0_done && src_proc1_done && sink_proc1_done &&
                src_proc2_done && sink_proc2_done && src_proc3_done && sink_proc3_done &&
                src_mdu_done && sink_mdu_done && src_icache_done && sink_icache_done &&
                src_dcache_done && sink_dcache_done;

  vc_TestRandDelayMemory_1i1d #(
    .p_mem_nbytes (p_mem_nbytes),
    .p_i_nbits    (128),
    .p_d_nbits    (32)
  )
  mem
  (
    .clk          (clk),
    .reset        (reset),
    .clear        (clear),

    .max_delay    (mem_max_delay),

    .imemreq0_val  (imemreq_val),
    .imemreq0_rdy  (imemreq_rdy),
    .imemreq0_msg  (imemreq_msg),

    .imemresp0_val (imemresp_val),
    .imemresp0_rdy (imemresp_rdy),
    .imemresp0_msg (imemresp_msg),

    .dmemreq0_val  (dmemreq_val),
    .dmemreq0_rdy  (dmemreq_rdy),
    .dmemreq0_msg  (dmemreq_msg),

    .dmemresp0_val (dmemresp_val),
    .dmemresp0_rdy (dmemresp_rdy),
    .dmemresp0_msg (dmemresp_msg)
  );

  `VC_TRACE_BEGIN
  begin
    src_ctrlreg.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_proc0.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_proc1.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_proc2.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_proc3.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_mdu.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_icache.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    src_dcache.line_trace( trace_str );

    vc_trace.append_str( trace_str, "| <dut> |" );

    sink_ctrlreg.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_proc0.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_proc1.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_proc2.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_proc3.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_mdu.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_icache.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    sink_dcache.line_trace( trace_str );
  end
  `VC_TRACE_END

endmodule

//------------------------------------------------------------------------
// Simulation driver
//------------------------------------------------------------------------

module top;

  logic clk = 1'b1;
  always #5 clk = ~clk;

  //----------------------------------------------------------------------
  // Instantiate the harness
  //----------------------------------------------------------------------

  logic        th_reset;
  logic        th_clear;
  logic [31:0] th_src_max_delay;
  logic [31:0] th_mem_max_delay;
  logic [31:0] th_sink_max_delay;
  logic        th_done;

  logic [31:0] th_src_ctrlreg_idx;
  logic [31:0] th_sink_ctrlreg_idx;
  logic [31:0] th_src_proc0_idx;
  logic [31:0] th_sink_proc0_idx;
  logic [31:0] th_src_proc1_idx;
  logic [31:0] th_sink_proc1_idx;
  logic [31:0] th_src_proc2_idx;
  logic [31:0] th_sink_proc2_idx;
  logic [31:0] th_src_proc3_idx;
  logic [31:0] th_sink_proc3_idx;
  logic [31:0] th_src_mdu_idx;
  logic [31:0] th_sink_mdu_idx;
  logic [31:0] th_src_icache_idx;
  logic [31:0] th_sink_icache_idx;
  logic [31:0] th_src_dcache_idx;
  logic [31:0] th_sink_dcache_idx;

  TestHarness#(1<<28) th // 256MB
  (
    .clk            (clk),
    .reset          (th_reset),
    .clear          (th_clear),
    .src_max_delay  (th_src_max_delay),
    .mem_max_delay  (th_mem_max_delay),
    .sink_max_delay (th_sink_max_delay),
    .done           (th_done)
  );

  // Shunning: Helper tasks for loading messages to 8 srcs, 8 sink, and memory

  task load_mem( input logic [31:0] addr, input logic [31:0] data);
  begin
    th.mem.mem.m[ addr ] = data;
  end
  endtask

  task load_src_ctrlreg ( input logic [36:0] msg );
  begin
    th.src_ctrlreg.src.m[th_src_ctrlreg_idx] = msg;
    th_src_ctrlreg_idx = th_src_ctrlreg_idx + 1;
    th.src_ctrlreg.src.m[th_src_ctrlreg_idx] = {37{1'bx}};
  end
  endtask

  task load_sink_ctrlreg ( input logic [32:0] msg );
  begin
    th.sink_ctrlreg.sink.m[th_sink_ctrlreg_idx] = msg;
    th_sink_ctrlreg_idx = th_sink_ctrlreg_idx + 1;
    th.sink_ctrlreg.sink.m[th_sink_ctrlreg_idx] = {33{1'bx}};
  end
  endtask

  task load_src_proc0 ( input logic [31:0] msg );
  begin
    th.src_proc0.src.m[th_src_proc0_idx] = msg;
    th_src_proc0_idx = th_src_proc0_idx + 1;
    th.src_proc0.src.m[th_src_proc0_idx] = {32{1'bx}};
  end
  endtask

  task load_sink_proc0 ( input logic [31:0] msg );
  begin
    th.sink_proc0.sink.m[th_sink_proc0_idx] = msg;
    th_sink_proc0_idx = th_sink_proc0_idx + 1;
    th.sink_proc0.sink.m[th_sink_proc0_idx] = {32{1'bx}};
  end
  endtask

  task load_src_proc1 ( input logic [31:0] msg );
  begin
    th.src_proc1.src.m[th_src_proc1_idx] = msg;
    th_src_proc1_idx = th_src_proc1_idx + 1;
    th.src_proc1.src.m[th_src_proc1_idx] = {32{1'bx}};
  end
  endtask

  task load_sink_proc1 ( input logic [31:0] msg );
  begin
    th.sink_proc1.sink.m[th_sink_proc1_idx] = msg;
    th_sink_proc1_idx = th_sink_proc1_idx + 1;
    th.sink_proc1.sink.m[th_sink_proc1_idx] = {32{1'bx}};
  end
  endtask

  task load_src_proc2 ( input logic [31:0] msg );
  begin
    th.src_proc2.src.m[th_src_proc2_idx] = msg;
    th_src_proc2_idx = th_src_proc2_idx + 1;
    th.src_proc2.src.m[th_src_proc2_idx] = {32{1'bx}};
  end
  endtask

  task load_sink_proc2 ( input logic [31:0] msg );
  begin
    th.sink_proc2.sink.m[th_sink_proc2_idx] = msg;
    th_sink_proc2_idx = th_sink_proc2_idx + 1;
    th.sink_proc2.sink.m[th_sink_proc2_idx] = {32{1'bx}};
  end
  endtask

  task load_src_proc3 ( input logic [31:0] msg );
  begin
    th.src_proc3.src.m[th_src_proc3_idx] = msg;
    th_src_proc3_idx = th_src_proc3_idx + 1;
    th.src_proc3.src.m[th_src_proc3_idx] = {32{1'bx}};
  end
  endtask

  task load_sink_proc3 ( input logic [31:0] msg );
  begin
    th.sink_proc3.sink.m[th_sink_proc3_idx] = msg;
    th_sink_proc3_idx = th_sink_proc3_idx + 1;
    th.sink_proc3.sink.m[th_sink_proc3_idx] = {32{1'bx}};
  end
  endtask

  task load_src_mdu ( input logic [69:0] msg );
  begin
    th.src_mdu.src.m[th_src_mdu_idx] = msg;
    th_src_mdu_idx = th_src_mdu_idx + 1;
    th.src_mdu.src.m[th_src_mdu_idx] = {70{1'bx}};
  end
  endtask

  task load_sink_mdu ( input logic [34:0] msg );
  begin
    th.sink_mdu.sink.m[th_sink_mdu_idx] = msg;
    th_sink_mdu_idx = th_sink_mdu_idx + 1;
    th.sink_mdu.sink.m[th_sink_mdu_idx] = {35{1'bx}};
  end
  endtask

  task load_src_icache ( input logic [`REQ_NBITS(128)-1:0] msg );
  begin
    th.src_icache.src.m[th_src_icache_idx] = msg;
    th_src_icache_idx = th_src_icache_idx + 1;
    th.src_icache.src.m[th_src_icache_idx] = {`REQ_NBITS(128){1'bx}};
  end
  endtask

  task load_sink_icache ( input logic [`RESP_NBITS(128)-1:0] msg );
  begin
    th.sink_icache.sink.m[th_sink_icache_idx] = msg;
    th_sink_icache_idx = th_sink_icache_idx + 1;
    th.sink_icache.sink.m[th_sink_icache_idx] = {`RESP_NBITS(128){1'bx}};
  end
  endtask

  task load_src_dcache ( input logic [`REQ_NBITS(32)-1:0] msg );
  begin
    th.src_dcache.src.m[th_src_dcache_idx] = msg;
    th_src_dcache_idx = th_src_dcache_idx + 1;
    th.src_dcache.src.m[th_src_dcache_idx] = {`REQ_NBITS(32){1'bx}};
  end
  endtask

  task load_sink_dcache ( input logic [`RESP_NBITS(32)-1:0] msg );
  begin
    th.sink_dcache.sink.m[th_sink_dcache_idx] = msg;
    th_sink_dcache_idx = th_sink_dcache_idx + 1;
    th.sink_dcache.sink.m[th_sink_dcache_idx] = {`RESP_NBITS(32){1'bx}};
  end
  endtask

  logic [799:0] test_name;

  `include "Chansey_all_tests.v"

  initial begin
    if ( !$value$plusargs( "test=%s", test_name ) ) begin
      $display( "" );
      $display( "    [BRG] ERROR: No test specified" );
      $display( "" );
      $finish(1);
    end
  end
  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------

  // number of instructions and cycles for stats

  integer total_cycles = 0;

  initial begin
    $vcdpluson;
    th_clear = 1'b0;
    th_reset = 1'b0;
    #3;   th_clear = 1'b1;
    #20; th_clear = 1'b0;
    #2;   th_reset = 1'b1;
    #20; th_reset = 1'b0;
    #5;

    th_src_ctrlreg_idx = 0;
    th_sink_ctrlreg_idx = 0;
    th_src_proc0_idx = 0;
    th_sink_proc0_idx = 0;
    th_src_proc1_idx = 0;
    th_sink_proc1_idx = 0;
    th_src_proc2_idx = 0;
    th_sink_proc2_idx = 0;
    th_src_proc3_idx = 0;
    th_sink_proc3_idx = 0;
    th_src_mdu_idx = 0;
    th_sink_mdu_idx = 0;
    th_src_icache_idx = 0;
    th_sink_icache_idx = 0;
    th_src_dcache_idx = 0;
    th_sink_dcache_idx = 0;

    // call the dispatch function in the generated all_tests.v

    Chansey_testcase_dispatch( test_name );

    while ( !th_done && total_cycles < 200000 ) begin
      // $display("%d:",total_cycles);
      // $display("  L0i valid    : %b", th.dut.l0i.inner.dpath.valid_array.out);
      // $display("  L0i tag check: %x %x %d", th.dut.l0i.inner.dpath.tag_compare.in0,
      // top.th.dut.l0i.inner.dpath.tag_compare.in1, top.th.dut.l0i.inner.dpath.tag_compare.out);
      // $display("%x",th.mem.imemreq0_val);
      // $display("%x",th.mem.imemreq0_msg);
      // $display("%x",th.mem.imemreq0_rdy);
      // $display("memresp msg data %x",th.dut.l0i.inner.dpath.memresp_msg);

      // $display("proc.imemreq_val %x",th.dut.proc.imemreq_val);
      // $display("proc.imemreq_msg %x",th.dut.proc.imemreq_msg);
      // $display("proc.imemreq_rdy %x",th.dut.proc.imemreq_rdy);
      // $display("  L0i state_reg  %d",th.dut.l0i.inner.ctrl.state_reg);
      // $display("%x",th.dut.l0i.inner.dpath.buffreq_addr_reg.out);

      // $display("%x",th.dut.proc2mngr_rdy);
      // $display("%x",th.mem.mem.imemresp0_queue.enq_msg);
      // $display("%x",th.mem.mem.imemresp0_queue.deq_msg);
      // $display("F's pc: %x | D's inst: %x",th.dut.proc.dpath.pc_reg_F.out, th.dut.proc.ctrl.inst_D);
      // $display("pc_mux_F 0:%x 1:%x 2:%x 3:%x sel:%d", th.dut.proc.dpath.pc_sel_mux_F.in__000,
      // th.dut.proc.dpath.pc_sel_mux_F.in__001,th.dut.proc.dpath.pc_sel_mux_F.in__002,th.dut.proc.dpath.pc_sel_mux_F.in__003,
      // th.dut.proc.dpath.pc_sel_mux_F.sel);
      #10;
      total_cycles = total_cycles + 1;
      th.display_trace();
      // $display("%x + %x + %x = %x", th.dut.proc.dpath.pc_plus_imm_D.in0, th.dut.proc.dpath.pc_plus_imm_D.in1,
      // th.dut.proc.dpath.pc_plus_imm_D.cin, th.dut.proc.dpath.pc_plus_imm_D.out);

      // ctorng debug trace

      // // L1 icache memreq
      // if ( top.th.dut.dut.dut.icache.memreq_val & top.th.dut.dut.dut.icache.memreq_rdy ) begin
      //   $display( "%d: icache memreq  : %h", total_cycles, top.th.dut.dut.dut.icache.dpath.memreq_addr );
      // end
      // if ( top.th.dut.dut.dut.icache.memresp_val & top.th.dut.dut.dut.icache.memresp_rdy ) begin
      //   $display( "%d: icache memresp", total_cycles );
      // end
      // // L1 icache req
      // if ( top.th.dut.dut.dut.icache.cachereq_val & top.th.dut.dut.dut.icache.cachereq_rdy ) begin
      //   $display( "%d: icache req  : %h", total_cycles, top.th.dut.dut.dut.icache.dpath.cachereq_addr_reg$in_ );
      // end
      // if ( top.th.dut.dut.dut.icache.cacheresp_val & top.th.dut.dut.dut.icache.cacheresp_rdy ) begin
      //   $display( "%d: icache resp", total_cycles );
      // end
      // // L0i cachereq
      // if ( top.th.dut.dut.dut.l0i$000.memreq_val & top.th.dut.dut.dut.l0i$000.memreq_rdy ) begin
      //   $display( "%d: L0i cachereq  : %h", total_cycles, top.th.dut.dut.dut.l0i$000.inner.dpath.memreq_msg[(164)-1:132] );
      // end
      // if ( top.th.dut.dut.dut.l0i$000.memresp_val & top.th.dut.dut.dut.l0i$000.memresp_rdy ) begin
      //   $display( "%d: L0i cacheresp", total_cycles );
      // end
      // if ( top.th.dut.dut.dut.l0i$000.memreq_val ) begin
      //   $display( "%d: L0i cachereq val: %h", total_cycles, top.th.dut.dut.dut.l0i$000.inner.dpath.memreq_msg[(164)-1:132] );
      // end
      // // L0i req
      // if ( top.th.dut.dut.dut.l0i$000.buffreq_val & top.th.dut.dut.dut.l0i$000.buffreq_rdy ) begin
      //   $display( "%d: L0i req  : %h", total_cycles, top.th.dut.dut.dut.l0i$000.inner.dpath.buffreq_addr_reg$in_ );
      // end
      // if ( top.th.dut.dut.dut.l0i$000.buffresp_val & top.th.dut.dut.dut.l0i$000.buffresp_rdy ) begin
      //   $display( "%d: L0i resp", total_cycles );
      // end
      // // Proc
      // if ( top.th.dut.dut.dut.proc$000.imemresp_val & top.th.dut.dut.dut.proc$000.imemresp_rdy ) begin
      //   $display( "%d: proc0 imemresp", total_cycles );
      // end
      // if ( top.th.dut.dut.dut.proc$000.imemreq_val & top.th.dut.dut.dut.proc$000.imemreq_rdy ) begin
      //   $display( "%d: proc0 imemreq  : %h", total_cycles, top.th.dut.dut.dut.proc$000.dpath.pc_sel_mux_F$out );
      // end
      // // Proc F
      // if ( top.th.dut.dut.dut.proc$000.ctrl.val_F & ~top.th.dut.dut.dut.proc$000.ctrl.stall_F) begin
      //   $display( "%d: proc0 F : %h", total_cycles, top.th.dut.dut.dut.proc$000.dpath.pc_F );
      // end

    end
    $vcdplusoff;
    // Check that the simulation actually finished

    if ( !th_done ) begin
      $display( "" );
      $display( "    [BRG] ERROR: Test did not finish in 200000 cycles." );
      $display( "" );
      $finish(1);
    end


    if ( th_done ) begin
      $display( "" );
      $display( "    [BRG] Passed test in %d cycles ", total_cycles );
      $display( "" );
      $finish(0);
    end

  end

endmodule
