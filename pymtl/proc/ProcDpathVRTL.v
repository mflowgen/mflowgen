//=========================================================================
// 5-Stage Stalling Pipelined Processor Datapath
//=========================================================================

`ifndef PROC_PROC_DPATH_V
`define PROC_PROC_DPATH_V

`include "vc/arithmetic.v"
`include "vc/mem-msgs.v"
`include "vc/muxes.v"
`include "vc/regs.v"
`include "vc/regfiles.v"

`include "lab1_imul/IntMulVarLatVRTL.v"

`include "proc/TinyRV2InstVRTL.v"
`include "proc/ProcDpathComponentsVRTL.v"

module proc_ProcDpathVRTL
#(
  parameter p_num_cores = 1
)
(
  input  logic        clk,
  input  logic        reset,

  input  logic [31:0] core_id,

  // Instruction Memory Port

  output logic [31:0]  imemreq_msg_addr,
  input  mem_resp_4B_t imemresp_msg,

  // Data Memory Port

  output logic [31:0] dmemreq_msg_addr,
  output logic [31:0] dmemreq_msg_data,
  input  logic [31:0] dmemresp_msg_data,

  // mngr communication ports

  input  logic [31:0] mngr2proc_data,
  output logic [31:0] proc2mngr_data,

  // xcel communication ports

  output logic [31:0] xcelreq_msg_data,
  output logic [4:0]  xcelreq_msg_raddr,
  input  logic [31:0] xcelresp_msg_data,

  // control signals (ctrl->dpath)

  output logic        imemresp_val_drop,
  input  logic        imemresp_rdy_drop,
  input  logic        imemresp_drop,

  input  logic        reg_en_F,
  input  logic [1:0]  pc_sel_F,

  input  logic        reg_en_D,
  input  logic [1:0]  op1_byp_sel_D,
  input  logic [1:0]  op2_byp_sel_D,
  input  logic        op1_sel_D,
  input  logic [1:0]  op2_sel_D,
  input  logic [1:0]  csrr_sel_D,
  input  logic [2:0]  imm_type_D,
  input  logic        imul_req_val_D,

  input  logic        reg_en_X,
  input  logic [3:0]  alu_fn_X,
  input  logic [1:0]  ex_result_sel_X,
  input  logic        imul_resp_rdy_X,

  input  logic        reg_en_M,
  input  logic [1:0]  wb_result_sel_M,

  input  logic        reg_en_W,
  input  logic [4:0]  rf_waddr_W,
  input  logic        rf_wen_W,
  input  logic        stats_en_wen_W,

  // status signals (dpath->ctrl)

  output logic [31:0] inst_D,
  output logic        imul_req_rdy_D,

  output logic        imul_resp_val_X,
  output logic        br_cond_eq_X,
  output logic        br_cond_lt_X,
  output logic        br_cond_ltu_X,

  // stats output

  output logic        stats_en

);

  localparam c_reset_vector = 32'h200;
  localparam c_reset_inst   = 32'h00000000;

  // Fetch address
  logic [31:0] pc_next_F;

  assign imemreq_msg_addr = pc_next_F;

  //--------------------------------------------------------------------
  // F stage
  //--------------------------------------------------------------------

  logic [31:0] pc_F;
  logic [31:0] pc_plus4_F;
  logic [31:0] br_target_X;
  logic [31:0] jal_target_D;
  logic [31:0] jalr_target_X;

  vc_EnResetReg #(32, c_reset_vector - 32'd4) pc_reg_F
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_F),
    .d      (pc_next_F),
    .q      (pc_F)
  );

  vc_Incrementer #(32, 4) pc_incr_F
  (
    .in   (pc_F),
    .out  (pc_plus4_F)
  );

  vc_Mux4 #(32) pc_sel_mux_F
  (
    .in0  (pc_plus4_F),
    .in1  (br_target_X),
    .in2  (jal_target_D),
    .in3  (jalr_target_X),
    .sel  (pc_sel_F),
    .out  (pc_next_F)
  );

  //--------------------------------------------------------------------
  // D stage
  //--------------------------------------------------------------------

  logic  [31:0] pc_D;
  logic   [4:0] inst_rd_D;
  logic   [4:0] inst_rs1_D;
  logic   [4:0] inst_rs2_D;
  logic  [31:0] imm_D;

  vc_EnResetReg #(32) pc_reg_D
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_D),
    .d      (pc_F),
    .q      (pc_D)
  );

  vc_EnResetReg #(32, c_reset_inst) inst_D_reg
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_D),
    .d      (imemresp_msg.data),
    .q      (inst_D)
  );

  rv2isa_InstUnpack inst_unpack
  (
    .opcode   (),
    .inst     (inst_D),
    .rs1      (inst_rs1_D),
    .rs2      (inst_rs2_D),
    .rd       (inst_rd_D),
    .funct3   (),
    .funct7   (),
    .csr      ()
  );

  proc_ImmGenVRTL imm_gen_D
  (
    .imm_type (imm_type_D),
    .inst     (inst_D),
    .imm      (imm_D)
  );

  logic [31:0] rf_rdata0_D;
  logic [31:0] rf_rdata1_D;

  logic [31:0] rf_wdata_W;

  vc_Regfile_2r1w_zero rf
  (
    .clk      (clk),
    .reset    (reset),
    .rd_addr0 (inst_rs1_D),
    .rd_data0 (rf_rdata0_D),
    .rd_addr1 (inst_rs2_D),
    .rd_data1 (rf_rdata1_D),
    .wr_en    (rf_wen_W),
    .wr_addr  (rf_waddr_W),
    .wr_data  (rf_wdata_W)
  );

  logic [31:0] byp_data_X;
  logic [31:0] byp_data_M;
  logic [31:0] byp_data_W;

  logic [31:0] op1_byp_D;
  logic [31:0] op1_D;

  // op1 bypass mux
  vc_Mux4 #(32) op1_byp_mux_D
  (
    .in0  (rf_rdata0_D),
    .in1  (byp_data_X),
    .in2  (byp_data_M),
    .in3  (byp_data_W),
    .sel  (op1_byp_sel_D),
    .out  (op1_byp_D)
  );

  // op1 select mux
  vc_Mux2 #(32) op1_sel_mux_D
  (
    .in0  (op1_byp_D),
    .in1  (pc_D),
    .sel  (op1_sel_D),
    .out  (op1_D)
  );

  logic [31:0] op2_byp_D;

  // op2 bypass mux
  vc_Mux4 #(32) op2_byp_mux_D
  (
    .in0  (rf_rdata1_D),
    .in1  (byp_data_X),
    .in2  (byp_data_M),
    .in3  (byp_data_W),
    .sel  (op2_byp_sel_D),
    .out  (op2_byp_D)
  );

  logic [31:0] op2_D;

  logic [31:0] csrr_data_D;

  logic [31:0] num_cores;
  assign num_cores = p_num_cores;

  // csrr data select mux
  vc_Mux3 #(32) csrr_sel_mux_D
  (
   .in0  (mngr2proc_data),
   .in1  (num_cores),
   .in2  (core_id),
   .sel  (csrr_sel_D),
   .out  (csrr_data_D)
  );

  // op2 select mux
  // This mux chooses among RS2, imm, and the output of the above csrr
  // csrr sel mux. Basically we are using two muxes here for pedagogy.
  vc_Mux3 #(32) op2_sel_mux_D
  (
    .in0  (op2_byp_D),
    .in1  (imm_D),
    .in2  (csrr_data_D),
    .sel  (op2_sel_D),
    .out  (op2_D)
  );

  vc_Adder #(32) pc_plus_imm_D
  (
    .in0      (pc_D),
    .in1      (imm_D),
    .cin      (1'b0),
    .out      (jal_target_D),
    .cout     ()
  );

  logic [63:0] imul_req_msg_D;
  assign imul_req_msg_D = {op1_D, op2_D};

  logic [31:0] imul_resp_msg_X;

  lab1_imul_IntMulVarLatVRTL imul
  (
    .clk       (clk),
    .reset     (reset),

    .req_val   (imul_req_val_D),
    .req_rdy   (imul_req_rdy_D),
    .req_msg   (imul_req_msg_D),

    .resp_val  (imul_resp_val_X),
    .resp_rdy  (imul_resp_rdy_X),
    .resp_msg  (imul_resp_msg_X)
  );

  //--------------------------------------------------------------------
  // X stage
  //--------------------------------------------------------------------

  logic [31:0] pc_X;
  vc_EnResetReg #(32) pc_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (pc_D),
    .q      (pc_X)
  );

  logic [31:0] op1_X;
  logic [31:0] op2_X;

  vc_EnResetReg #(32, 0) op1_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op1_D),
    .q      (op1_X)
  );

  vc_EnResetReg #(32, 0) op2_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op2_D),
    .q      (op2_X)
  );

  vc_EnResetReg #(32, 0) br_target_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (jal_target_D),
    .q      (br_target_X)
  );

  vc_EnResetReg #(32, 0) dmem_write_data_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op2_byp_D),
    .q      (dmemreq_msg_data)
  );

  assign xcelreq_msg_data  = op1_X;
  assign xcelreq_msg_raddr = op2_X[4:0];

  // ALU

  logic [31:0] alu_result_X;
  logic [31:0] ex_result_X;

  proc_AluVRTL alu
  (
    .in0      (op1_X),
    .in1      (op2_X),
    .fn       (alu_fn_X),
    .out      (alu_result_X),
    .ops_eq   (br_cond_eq_X),
    .ops_lt   (br_cond_lt_X),
    .ops_ltu  (br_cond_ltu_X)
  );

  assign jalr_target_X = alu_result_X;

  // PC+4 Incrementer, used for jalr instruction
  logic [31:0] pc_plus4_X;
  vc_Incrementer #(32, 4) pc_incr_X
  (
    .in   (pc_X),
    .out  (pc_plus4_X)
  );

  // Select the output of the X stage
  vc_Mux3 #(32) ex_result_sel_mux_X
  (
    .in0      (alu_result_X),
    .in1      (imul_resp_msg_X),
    .in2      (pc_plus4_X),
    .sel      (ex_result_sel_X),
    .out      (ex_result_X)
  );

  assign byp_data_X = ex_result_X;

  assign dmemreq_msg_addr = alu_result_X;

  //--------------------------------------------------------------------
  // M stage
  //--------------------------------------------------------------------

  logic [31:0] ex_result_M;

  vc_EnResetReg #(32, 0) ex_result_reg_M
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_M),
    .d      (ex_result_X),
    .q      (ex_result_M)
  );

  logic [31:0] dmem_result_M;
  logic [31:0] wb_result_M;

  assign dmem_result_M = dmemresp_msg_data;

  vc_Mux3 #(32) wb_result_sel_mux_M
  (
    .in0    (ex_result_M),
    .in1    (dmem_result_M),
    .in2    (xcelresp_msg_data),
    .sel    (wb_result_sel_M),
    .out    (wb_result_M)
  );

  assign byp_data_M = wb_result_M;

  //--------------------------------------------------------------------
  // W stage
  //--------------------------------------------------------------------

  logic [31:0] wb_result_W;

  vc_EnResetReg #(32, 0) wb_result_reg_W
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_W),
    .d      (wb_result_M),
    .q      (wb_result_W)
  );

  assign proc2mngr_data = wb_result_W;

  assign rf_wdata_W = wb_result_W;

  assign byp_data_W = wb_result_W;

  // stats output
  // note the stats en is full 32-bit here but the outside port is one
  // bit.

  logic [31:0] stats_en_W;

  assign stats_en = | stats_en_W;

  vc_EnResetReg #(32, 0) stats_en_reg_W
  (
   .clk    (clk),
   .reset  (reset),
   .en     (stats_en_wen_W),
   .d      (wb_result_W),
   .q      (stats_en_W)
  );


endmodule

`endif /* PROC_PROC_DPATH_V */

