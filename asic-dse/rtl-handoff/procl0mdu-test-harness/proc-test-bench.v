//=========================================================================
// Processor Simulator Harness
//=========================================================================

`include "vc/vc-TestRandDelayMemory_1i1d.v"
`include "vc/vc-TestRandDelaySource.v"
`include "vc/vc-TestRandDelaySink.v"

`define CLK_PERIOD 10

// We provide the source that defines ProcL0Mdu in the Makefile
// `include "ProcL0Mdu.v"

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
  output logic        stats_en,
  output logic        done
);

  assign mdu_host_en = 1'b0;

  // Signals related to host
  logic        L0_disable;
  logic [69:0] host_mdureq0_msg;
  logic        host_mdureq0_rdy;
  logic        host_mdureq0_val;
  logic [34:0] host_mduresp0_msg;
  logic        host_mduresp0_rdy;
  logic        host_mduresp0_val;

  logic        stats0_en;
  logic        commit_inst0;
  logic [31:0] mngr2proc0_msg;
  logic        mngr2proc0_val;
  logic        mngr2proc0_rdy;
  logic [31:0] proc2mngr0_msg;
  logic        proc2mngr0_val;
  logic        proc2mngr0_rdy;

  logic        imemreq0_val;
  logic        imemreq0_rdy;
  logic [`REQ_NBITS(256)-1:0] imemreq0_msg;
  logic        imemresp0_val;
  logic        imemresp0_rdy;
  logic [`RESP_NBITS(256)-1:0] imemresp0_msg;
  logic        dmemreq0_val;
  logic        dmemreq0_rdy;
  logic [`REQ_NBITS(32)-1:0] dmemreq0_msg;
  logic        dmemresp0_val;
  logic        dmemresp0_rdy;
  logic [`RESP_NBITS(32)-1:0] dmemresp0_msg;

  assign stats_en = stats0_en;

  ProcL0Mdu dut
  (
    .clk           (clk),
    .reset         (reset),

    .L0_disable       (0),
    .mdu_host_en      (mdu_host_en),
    .host_mdureq_val  (host_mdureq0_val),
    .host_mdureq_rdy  (host_mdureq0_rdy),
    .host_mdureq_msg  (host_mdureq0_msg),
    .host_mduresp_val (host_mduresp0_val),
    .host_mduresp_rdy (host_mduresp0_rdy),
    .host_mduresp_msg (host_mduresp0_msg),

    .stats_en      (stats0_en),
    .commit_inst   (commit_inst0),

    .mngr2proc_msg (mngr2proc0_msg),
    .mngr2proc_val (mngr2proc0_val),
    .mngr2proc_rdy (mngr2proc0_rdy),

    .proc2mngr_msg (proc2mngr0_msg),
    .proc2mngr_val (proc2mngr0_val),
    .proc2mngr_rdy (proc2mngr0_rdy),

    .imemreq_val   (imemreq0_val),
    .imemreq_rdy   (imemreq0_rdy),
    .imemreq_msg   (imemreq0_msg),

    .imemresp_val  (imemresp0_val),
    .imemresp_rdy  (imemresp0_rdy),
    .imemresp_msg  (imemresp0_msg),

    .dmemreq_val   (dmemreq0_val),
    .dmemreq_rdy   (dmemreq0_rdy),
    .dmemreq_msg   (dmemreq0_msg),

    .dmemresp_val  (dmemresp0_val),
    .dmemresp_rdy  (dmemresp0_rdy),
    .dmemresp_msg  (dmemresp0_msg)
  );

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (mngr2proc0_val),
    .rdy       (mngr2proc0_rdy),
    .msg       (mngr2proc0_msg),
    .done      (src0_done)
  );

  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (proc2mngr0_val),
    .rdy       (proc2mngr0_rdy),
    .msg       (proc2mngr0_msg),
    .done      (sink0_done)
  );

  assign done = src0_done && sink0_done;

  vc_TestRandDelayMemory_1i1d #(
    .p_mem_nbytes (p_mem_nbytes),
    .p_i_nbits    (256),
    .p_d_nbits    (32)
  )
  mem
  (
    .clk          (clk),
    .reset        (reset),
    .clear        (clear),

    .max_delay    (mem_max_delay),

    .imemreq0_val  (imemreq0_val),
    .imemreq0_rdy  (imemreq0_rdy),
    .imemreq0_msg  (imemreq0_msg),

    .imemresp0_val (imemresp0_val),
    .imemresp0_rdy (imemresp0_rdy),
    .imemresp0_msg (imemresp0_msg),

    .dmemreq0_val  (dmemreq0_val),
    .dmemreq0_rdy  (dmemreq0_rdy),
    .dmemreq0_msg  (dmemreq0_msg),

    .dmemresp0_val (dmemresp0_val),
    .dmemresp0_rdy (dmemresp0_rdy),
    .dmemresp0_msg (dmemresp0_msg)
  );

  `VC_TRACE_BEGIN
  begin
    src0.line_trace( trace_str );
    vc_trace.append_str( trace_str, " | " );
    sink0.line_trace( trace_str );
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

  logic        th_reset = 1'b1;
  logic        th_clear;
  logic [31:0] th_src_max_delay;
  logic [31:0] th_mem_max_delay;
  logic [31:0] th_sink_max_delay;
  logic        th_stats_en;
  logic        th_done;

  logic [31:0] th_src0_idx;
  logic [31:0] th_sink0_idx;

  TestHarness#(1<<28) th // 256MB
  (
    .clk            (clk),
    .reset          (th_reset),
    .clear          (th_clear),
    .stats_en       (th_stats_en),
    .src_max_delay  (th_src_max_delay),
    .mem_max_delay  (th_mem_max_delay),
    .sink_max_delay (th_sink_max_delay),
    .done           (th_done)
  );

  // Shunning: Helper tasks for loading/unloading messages to src/sink/memory

  task load_mem
  (
    input logic [31:0] addr,
    input logic [31:0] data
  );
  begin
    th.mem.mem.m[ addr ] = data;
  end
  endtask

  task load_src0
  (
    input logic [31:0] msg
  );
  begin
    th.src0.src.m[th_src0_idx] = msg;
    th_src0_idx = th_src0_idx + 1;
    th.src0.src.m[th_src0_idx] = 32'hxxxxxxxx;
  end
  endtask

  task load_sink0
  (
    input logic [31:0] msg
  );
  begin
    th.sink0.sink.m[th_sink0_idx] = msg;
    th_sink0_idx = th_sink0_idx + 1;
    th.sink0.sink.m[th_sink0_idx] = 32'hxxxxxxxx;
  end
  endtask

  logic [799:0] test_name;

  `include "ProcL0Mdu_all_tests.v"

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
    // $vcdpluson;
    #1;  th_clear = 1'b1;
    #20; th_clear = 1'b0;
    #1;  th_reset = 1'b1;
    #20; th_reset = 1'b0;
    #8;

    th_src0_idx = 0;
    th_sink0_idx = 0;

    // call the dispatch function in the generated all_tests.v

    procl0mdu_testcase_dispatch( test_name );

    while ( !th_done && total_cycles < 5000 ) begin
      $display("%d:",total_cycles);
      $display("  L0i valid    : %b", th.dut.l0i.inner.dpath.valid_array.out);
      $display("  L0i tag check: %x %x %d", th.dut.l0i.inner.dpath.tag_compare.in0,
      top.th.dut.l0i.inner.dpath.tag_compare.in1, top.th.dut.l0i.inner.dpath.tag_compare.out);
      // $display("%x",th.mem.imemreq0_val);
      // $display("%x",th.mem.imemreq0_msg);
      // $display("%x",th.mem.imemreq0_rdy);

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
    end
    // $vcdplusoff;
    // Check that the simulation actually finished

    if ( !th_done ) begin
      $display( "" );
      $display( "    [BRG] ERROR: Test did not finish in 5000 cycles." );
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
