//=========================================================================
// 5-Stage Stalling Pipelined Processor Control
//=========================================================================

`ifndef PROC_PROC_CTRL_V
`define PROC_PROC_CTRL_V

`include "vc/mem-msgs.v"
`include "vc/trace.v"

`include "proc/TinyRV2InstVRTL.v"
`include "proc/XcelMsg.v"

module proc_ProcCtrlVRTL
(
  input  logic        clk,
  input  logic        reset,

  // Instruction Memory Port

  output logic        imemreq_val,
  input  logic        imemreq_rdy,

  input  logic        imemresp_val,
  output logic        imemresp_rdy,

  output logic        imemresp_drop,

  // Data Memory Port

  output logic        dmemreq_val,
  input  logic        dmemreq_rdy,
  output logic [2:0]  dmemreq_msg_type,

  input  logic        dmemresp_val,
  output logic        dmemresp_rdy,

  // mngr communication port

  input  logic        mngr2proc_val,
  output logic        mngr2proc_rdy,

  output logic        proc2mngr_val,
  input  logic        proc2mngr_rdy,

  // xcel ports

  output logic        xcelreq_val,
  input  logic        xcelreq_rdy,
  output logic        xcelreq_msg_type,

  input  logic        xcelresp_val,
  output logic        xcelresp_rdy,

  // control signals (ctrl->dpath)

  output logic        reg_en_F,
  output logic [1:0]  pc_sel_F,

  output logic        reg_en_D,
  output logic [1:0]  op1_byp_sel_D,
  output logic [1:0]  op2_byp_sel_D,
  output logic        op1_sel_D,
  output logic [1:0]  op2_sel_D,
  output logic [1:0]  csrr_sel_D,
  output logic [2:0]  imm_type_D,
  output logic        imul_req_val_D,

  output logic        reg_en_X,
  output logic [3:0]  alu_fn_X,
  output logic [1:0]  ex_result_sel_X,
  output logic        imul_resp_rdy_X,

  output logic        reg_en_M,
  output logic [1:0]  wb_result_sel_M,

  output logic        reg_en_W,
  output logic [4:0]  rf_waddr_W,
  output logic        rf_wen_W,

  // status signals (dpath->ctrl)

  input  logic [31:0] inst_D,
  input  logic        imul_req_rdy_D,

  input  logic        imul_resp_val_X,
  input  logic        br_cond_eq_X,
  input  logic        br_cond_lt_X,
  input  logic        br_cond_ltu_X,

  output logic        stats_en_wen_W,

  output logic        commit_inst

);

  //----------------------------------------------------------------------
  // Notes
  //----------------------------------------------------------------------
  // We follow this principle to organize code for each pipeline stage in
  // the control unit.  Register enable logics should always at the
  // beginning. It followed by pipeline registers. Then logic that is not
  // dependent on stall or squash signals. Then logic that is dependent
  // on stall or squash signals. At the end there should be signals meant
  // to be passed to the next stage in the pipeline.

  //----------------------------------------------------------------------
  // Valid, stall, and squash signals
  // ----------------------------------------------------------------------
  // We use valid signal to indicate if the instruction is valid.  An
  // instruction can become invalid because of being squashed or
  // stalled. Notice that invalid instructions are microarchitectural
  // events, they are different from archtectural no-ops. We must be
  // careful about control signals that might change the state of the
  // processor. We should always AND outgoing control signals with valid
  // signal.

  logic val_F;
  logic val_D;
  logic val_X;
  logic val_M;
  logic val_W;

  // Managing the stall and squash signals is one of the most important,
  // yet also one of the most complex, aspects of designing a pipelined
  // processor. We will carefully use four signals per stage to manage
  // stalling and squashing: ostall_A, osquash_A, stall_A, and squash_A.
  //
  // We denote the stall signals _originating_ from stage A as
  // ostall_A. For example, if stage A can stall due to a pipeline
  // harzard, then ostall_A would need to factor in the stalling
  // condition for this pipeline harzard.

  logic ostall_F;  // can ostall due to imemresp_val
  logic ostall_D;  // can ostall due to mngr2proc_val or other hazards
  logic ostall_X;  // can ostall due to dmemreq_rdy
  logic ostall_M;  // can ostall due to dmemresp_val
  logic ostall_W;  // can ostall due to proc2mngr_rdy

  // The stall_A signal should be used to indicate when stage A is indeed
  // stalling. stall_A will be a function of ostall_A and all the ostall
  // signals of stages in front of it in the pipeline.

  logic stall_F;
  logic stall_D;
  logic stall_X;
  logic stall_M;
  logic stall_W;

  // We denote the squash signals _originating_ from stage A as
  // osquash_A. For example, if stage A needs to squash the stages behind
  // A in the pipeline, then osquash_A would need to factor in this
  // squash condition.

  logic osquash_D; // can osquash due to unconditional jumps
  logic osquash_X; // can osquash due to taken branches

  // The squash_A signal should be used to indicate when stage A is being
  // squashed. squash_A will _not_ be a function of osquash_A, since
  // osquash_A means to squash the stages _behind_ A in the pipeline, but
  // not to squash A itself.

  logic squash_F;
  logic squash_D;

  //----------------------------------------------------------------------
  // F stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_F = !stall_F || squash_F;

  // Pipeline registers

  always_ff @( posedge clk ) begin
    if ( reset )
      val_F <= 1'b0;
    else if ( reg_en_F )
      val_F <= 1'b1;
  end

  // forward declaration for PC sel

  logic       pc_redirect_D;
  logic       pc_redirect_X;

  logic [2:0]  br_type_X;
  localparam jalr     = 3'd7;
  // PC select logic

  always_comb begin
    if ( pc_redirect_X )       // If a branch is taken in X stage
      if ( br_type_X == jalr )
        pc_sel_F = 2'd3;       // Use jalr target from ALU
      else
        pc_sel_F = 2'd1;       // Use branch target
    else if ( pc_redirect_D )
      pc_sel_F = 2'd2;         // Use jal target
    else
      pc_sel_F = 2'b0;         // Use pc+4
  end

  // ostall due to the imem response not valid.

  assign ostall_F = val_F && !imemresp_val;

  // stall and squash in F

  assign stall_F  = val_F && ( ostall_F  || ostall_D || ostall_X || ostall_M || ostall_W );
  assign squash_F = val_F && ( osquash_D || osquash_X );

  // We drop the mem response when we are getting squashed

  assign imemresp_drop = squash_F;

  // imem is very special. Actually imem requests are sent before the F
  // stage. Note that we need to factor in reset to the imemreq_val
  // signal because we don't want to send out imem request when we are
  // resetting.

  assign imemreq_val  = ( !stall_F || squash_F ) && !reset;
  assign imemresp_rdy = !stall_F || squash_F;

  // Valid signal for the next stage (stage D)

  logic  next_val_F;
  assign next_val_F = val_F && !stall_F && !squash_F;

  //----------------------------------------------------------------------
  // D stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_D = !stall_D || squash_D;

  // Pipline registers

  always_ff @( posedge clk ) begin
    if ( reset )
      val_D <= 1'b0;
    else if ( reg_en_D )
      val_D <= next_val_F;
  end

  // Parse instruction fields

  logic   [4:0] inst_rd_D;
  logic   [4:0] inst_rs1_D;
  logic   [4:0] inst_rs2_D;
  logic   [11:0] inst_csr_D;

  rv2isa_InstUnpack inst_unpack
  (
    .inst     (inst_D),
    .opcode   (),
    .rd       (inst_rd_D),
    .rs1      (inst_rs1_D),
    .rs2      (inst_rs2_D),
    .funct3   (),
    .funct7   (),
    .csr      (inst_csr_D)
  );

  // Generic Parameters -- yes or no

  localparam n = 1'd0;
  localparam y = 1'd1;

  // Register specifiers

  localparam rx = 5'bx;   // don't care
  localparam r0 = 5'd0;   // zero
  localparam rL = 5'd31;  // for jal

  // Branch type

  localparam br_x     = 3'bx; // Don't care
  localparam br_na    = 3'b0; // No branch
  localparam br_ne    = 3'b1; // bne
  localparam br_lt    = 3'd2;
  localparam br_lu    = 3'd3;
  localparam br_eq    = 3'd4;
  localparam br_ge    = 3'd5;
  localparam br_gu    = 3'd6;

  // Op1 mux select
  localparam am_x     = 1'bx;
  localparam am_rf    = 1'b0;
  localparam am_pc    = 1'b1;

  // Op2 Mux Select

  localparam bm_x     = 2'bx; // Don't care
  localparam bm_rf    = 2'd0; // Use data from register file
  localparam bm_imm   = 2'd1; // Use sign-extended immediate
  localparam bm_csr   = 2'd2; // Use from mngr data

  // ALU Function

  localparam alu_x    = 4'bx;
  localparam alu_add  = 4'd0;
  localparam alu_sub  = 4'd1;
  localparam alu_sll  = 4'd2;
  localparam alu_or   = 4'd3;
  localparam alu_lt   = 4'd4;
  localparam alu_ltu  = 4'd5;
  localparam alu_and  = 4'd6;
  localparam alu_xor  = 4'd7;
  localparam alu_nor  = 4'd8;
  localparam alu_srl  = 4'd9;
  localparam alu_sra  = 4'd10;
  localparam alu_cp0  = 4'd11; // copy in0
  localparam alu_cp1  = 4'd12; // copy in1
  localparam alu_adz  = 4'd13; // special case for JALR

  // Immediate Type
  localparam imm_x    = 3'bx;
  localparam imm_i    = 3'd0;
  localparam imm_s    = 3'd1;
  localparam imm_b    = 3'd2;
  localparam imm_u    = 3'd3;
  localparam imm_j    = 3'd4;

  // Memory Request Type

  localparam nr       = 2'd0; // No request
  localparam ld       = 2'd1; // Load
  localparam st       = 2'd2; // Store

  // X stage result mux select
  localparam xm_x     = 2'bx;
  localparam xm_a     = 2'd0;
  localparam xm_m     = 2'd1;
  localparam xm_p     = 2'd2;

  // Writeback Mux Select

  localparam wm_x     = 2'bx; // Don't care
  localparam wm_a     = 2'd0; // Use ALU output
  localparam wm_m     = 2'd1; // Use data memory response
  localparam wm_c     = 2'd2; // Use xcel response

  // Instruction Decode

  logic       inst_val_D;
  logic [2:0] br_type_D;
  logic       jal_D;
  logic       rs1_en_D;
  logic       rs2_en_D;
  logic [3:0] alu_fn_D;
  logic [1:0] dmemreq_type_D;
  logic [1:0] ex_result_sel_D;
  logic [1:0] wb_result_sel_D;
  logic       rf_wen_pending_D;
  logic       mul_D;
  logic       csrr_D;
  logic       csrw_D;
  logic       xcelreq_D;
  logic       xcelreq_type_D;

  logic       proc2mngr_val_D;
  logic       mngr2proc_rdy_D;
  logic       stats_en_wen_D;

  task cs
  (
    input logic       cs_inst_val,
    input logic [2:0] cs_br_type,
    input logic       cs_jal,
    input logic [2:0] cs_imm_type,
    input logic       cs_op1_sel,
    input logic       cs_rs1_en,
    input logic [1:0] cs_op2_sel,
    input logic       cs_rs2_en,
    input logic [3:0] cs_alu_fn,
    input logic [1:0] cs_dmemreq_type,
    input logic [1:0] cs_ex_result_sel,
    input logic [1:0] cs_wb_result_sel,
    input logic       cs_rf_wen_pending,
    input logic       cs_mul,
    input logic       cs_csrr,
    input logic       cs_csrw
  );
  begin
    inst_val_D            = cs_inst_val;
    br_type_D             = cs_br_type;
    jal_D                 = cs_jal;
    imm_type_D            = cs_imm_type;
    op1_sel_D             = cs_op1_sel;
    rs1_en_D              = cs_rs1_en;
    op2_sel_D             = cs_op2_sel;
    rs2_en_D              = cs_rs2_en;
    alu_fn_D              = cs_alu_fn;
    dmemreq_type_D        = cs_dmemreq_type;
    ex_result_sel_D       = cs_ex_result_sel;
    wb_result_sel_D       = cs_wb_result_sel;
    rf_wen_pending_D      = cs_rf_wen_pending;
    mul_D                 = cs_mul;
    csrr_D                = cs_csrr;
    csrw_D                = cs_csrw;
  end
  endtask

  // Control signals table

  always_comb begin

    casez ( inst_D )

      //                           br     jal  imm    op1   rs1 op2    rs2 alu      dmm xres  wbmux rf      cs cs
      //                       val type    D   type  muxsel  en muxsel  en fn       typ sel   sel   wen mul rr rw 
      `RV2ISA_INST_NOP     :cs( y, br_na,  n,  imm_x, am_x,  n, bm_x,   n, alu_x,   nr, xm_x, wm_a, n,  n,  n, n  );
      `RV2ISA_INST_BNE     :cs( y, br_ne,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_x, wm_a, n,  n,  n, n  );
      `RV2ISA_INST_CSRRX   :cs( y, br_na,  n,  imm_i, am_x,  n, bm_imm, n, alu_cp1, nr, xm_a, wm_c, y,  n,  y, n  );
      `RV2ISA_INST_CSRR    :cs( y, br_na,  n,  imm_i, am_x,  n, bm_csr, n, alu_cp1, nr, xm_a, wm_a, y,  n,  y, n  );
      `RV2ISA_INST_CSRW    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_cp0, nr, xm_a, wm_a, n,  n,  n, y  );

      // reg-reg
      `RV2ISA_INST_ADD     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_add, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SUB     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_sub, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_MUL     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_x,   nr, xm_m, wm_a, y,  y,  n, n  );
      `RV2ISA_INST_AND     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_and, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_OR      :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_or,  nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_XOR     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_xor, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLT     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_lt,  nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLTU    :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_ltu, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SRA     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_sra, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SRL     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_srl, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLL     :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_sll, nr, xm_a, wm_a, y,  n,  n, n  );

      // reg-imm
      `RV2ISA_INST_ADDI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_add, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_ANDI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_and, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_ORI     :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_or,  nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_XORI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_xor, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLTI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_lt,  nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLTIU   :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_ltu, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SRAI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_sra, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SRLI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_srl, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_SLLI    :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_sll, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_LUI     :cs( y, br_na,  n,  imm_u, am_x,  n, bm_imm, n, alu_cp1, nr, xm_a, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_AUIPC   :cs( y, br_na,  n,  imm_u, am_pc, n, bm_imm, n, alu_add, nr, xm_a, wm_a, y,  n,  n, n  );

      // mem
      `RV2ISA_INST_LW      :cs( y, br_na,  n,  imm_i, am_rf, y, bm_imm, n, alu_add, ld, xm_a, wm_m, y,  n,  n, n  );
      `RV2ISA_INST_SW      :cs( y, br_na,  n,  imm_s, am_rf, y, bm_imm, y, alu_add, st, xm_a, wm_x, n,  n,  n, n  );

      // branch
      `RV2ISA_INST_BNE     :cs( y, br_ne,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );
      `RV2ISA_INST_BEQ     :cs( y, br_eq,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );
      `RV2ISA_INST_BLT     :cs( y, br_lt,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );
      `RV2ISA_INST_BLTU    :cs( y, br_lu,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );
      `RV2ISA_INST_BGE     :cs( y, br_ge,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );
      `RV2ISA_INST_BGEU    :cs( y, br_gu,  n,  imm_b, am_rf, y, bm_rf,  y, alu_x,   nr, xm_a, wm_x, n,  n,  n, n  );

      // jump
      `RV2ISA_INST_JAL     :cs( y, br_na,  y,  imm_j, am_x,  n, bm_x,   n, alu_x,   nr, xm_p, wm_a, y,  n,  n, n  );
      `RV2ISA_INST_JALR    :cs( y, jalr,   n,  imm_i, am_rf, y, bm_imm, n, alu_adz, nr, xm_p, wm_a, y,  n,  n, n  );

      // accelerator
      `RV2ISA_INST_CUST0   :cs( y, br_na,  n,  imm_x, am_rf, y, bm_rf,  y, alu_x,   nr, xm_x, wm_c, y,  n,  n, n  );

      default              :cs( n, br_x,   n,  imm_x, am_x,  n, bm_x,   n, alu_x,   nr, xm_x, wm_x, n,  n,  n, n  );

    endcase
  end // always_comb

  logic [4:0] rf_waddr_D;
  assign rf_waddr_D = inst_rd_D;

  // csrr and csrw logic

  always_comb begin
    proc2mngr_val_D  = 1'b0;
    mngr2proc_rdy_D  = 1'b0;
    csrr_sel_D       = 2'h0;
    stats_en_wen_D   = 1'b0;
    xcelreq_D        = 1'b0;
    xcelreq_type_D   = 1'b0;

    if ( csrr_D ) begin
      if ( inst_csr_D == `RV2ISA_CPR_MNGR2PROC )
        mngr2proc_rdy_D  = 1'b1;
      else if ( inst_csr_D == `RV2ISA_CPR_NUMCORES )
        csrr_sel_D       = 2'h1;
      else if ( inst_csr_D == `RV2ISA_CPR_COREID )
        csrr_sel_D       = 2'h2;
      else begin
      // FIXME
        xcelreq_type_D  = `XcelReqMsg_TYPE_READ;
        xcelreq_D       = 1'b1;
      end
    end

    if ( csrw_D ) begin
      if ( inst_csr_D == `RV2ISA_CPR_PROC2MNGR )
        proc2mngr_val_D    = 1'b1;
      else if ( inst_csr_D == `RV2ISA_CPR_STATS_EN )
        stats_en_wen_D  = 1'b1;
      else begin
      // FIXME
        xcelreq_type_D  = `XcelReqMsg_TYPE_WRITE;
        xcelreq_D       = 1'b1;
      end
    end
  end

  assign pc_redirect_D  = val_D && jal_D;

  // mngr2proc_rdy signal for csrr instruction

  assign mngr2proc_rdy  = val_D && !stall_D && mngr2proc_rdy_D;

  // multiply request valid signal
  assign imul_req_val_D = val_D && !stall_D && !squash_D && mul_D;

  logic  ostall_mngr2proc_D;
  assign ostall_mngr2proc_D = val_D && mngr2proc_rdy_D && !mngr2proc_val;

  // bypassing logic

  localparam byp_d    = 2'b0;
  localparam byp_x    = 2'd1;
  localparam byp_m    = 2'd2;
  localparam byp_w    = 2'd3;

  logic        rf_wen_pending_X;
  logic [4:0]  rf_waddr_X;
  logic [1:0]  dmemreq_type_X;
  logic        rf_wen_pending_M;
  logic [4:0]  rf_waddr_M;
  logic        rf_wen_pending_W;

  always_comb begin

    op1_byp_sel_D = byp_d;

    if ( rs1_en_D ) begin
      if      ( val_X && ( inst_rs1_D == rf_waddr_X )
                && ( rf_waddr_X != 5'd0 ) && rf_wen_pending_X )
        op1_byp_sel_D = byp_x;
      else if ( val_M && ( inst_rs1_D == rf_waddr_M )
                && ( rf_waddr_M != 5'd0 ) && rf_wen_pending_M )
        op1_byp_sel_D = byp_m;
      else if ( val_W && ( inst_rs1_D == rf_waddr_W )
                && ( rf_waddr_W != 5'd0 ) && rf_wen_pending_W )
        op1_byp_sel_D = byp_w;
    end

    op2_byp_sel_D = byp_d;

    if ( rs2_en_D ) begin
      if      ( val_X && ( inst_rs2_D == rf_waddr_X )
                && ( rf_waddr_X != 5'd0 ) && rf_wen_pending_X )
        op2_byp_sel_D = byp_x;
      else if ( val_M && ( inst_rs2_D == rf_waddr_M )
                && ( rf_waddr_M != 5'd0 ) && rf_wen_pending_M )
        op2_byp_sel_D = byp_m;
      else if ( val_W && ( inst_rs2_D == rf_waddr_W )
                && ( rf_waddr_W != 5'd0 ) && rf_wen_pending_W )
        op2_byp_sel_D = byp_w;
    end

  end

  // Although bypassing is added, we might still have RAW when there is
  // lw instruction in X stage

  // ostall if lw address in X matches rs1 in D

  logic  ostall_ld_X_rs1_D;
  assign ostall_ld_X_rs1_D
    = rs1_en_D && val_X && rf_wen_pending_X
      && ( inst_rs1_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && (dmemreq_type_X == ld);

  // ostall if lw address in X matches rs2 in D

  logic  ostall_ld_X_rs2_D;
  assign ostall_ld_X_rs2_D
    = rs2_en_D && val_X && rf_wen_pending_X
      && ( inst_rs2_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && (dmemreq_type_X == ld);

  // We also need to add a stall for CSRRX since the value will not be
  // returned from the accelerator until the M stage.

  logic  ostall_csrrx_X_rs1_D;
  logic  ostall_csrrx_X_rs2_D;

  assign ostall_csrrx_X_rs1_D
    = rs1_en_D && val_X && rf_wen_pending_X
      && ( inst_rs1_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && xcelreq_X && (xcelreq_type_X == `XcelReqMsg_TYPE_READ);

  assign ostall_csrrx_X_rs2_D
    = rs2_en_D && val_X && rf_wen_pending_X
      && ( inst_rs2_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && xcelreq_X && (xcelreq_type_X == `XcelReqMsg_TYPE_READ);

  // Put together ostall signal due to hazards

  logic  ostall_hazard_D;
  assign ostall_hazard_D = ostall_ld_X_rs1_D || ostall_ld_X_rs2_D
                        || ostall_csrrx_X_rs1_D || ostall_csrrx_X_rs2_D;

  // stall if imul not ready
  logic ostall_imul_D;
  assign ostall_imul_D = mul_D && !imul_req_rdy_D;

  // Final ostall signal

  assign ostall_D = val_D && ( ostall_mngr2proc_D || ostall_hazard_D || ostall_imul_D );

  // osquash due to jump instruction in D stage

  assign osquash_D = val_D && !stall_D && pc_redirect_D;

  // stall and squash in D

  assign stall_D  = val_D && ( ostall_D || ostall_X || ostall_M || ostall_W );
  assign squash_D = val_D && osquash_X;

  // Valid signal for the next stage

  logic  next_val_D;
  assign next_val_D = val_D && !stall_D && !squash_D;

  //----------------------------------------------------------------------
  // X stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_X = !stall_X;

  logic [31:0] inst_X;
  logic [1:0]  wb_result_sel_X;
  logic        proc2mngr_val_X;
  logic        stats_en_wen_X;
  logic        mul_X;
  logic        xcelreq_X;
  logic [4:0]  xcelreq_raddr_X;
  logic        xcelreq_type_X;

  // Pipeline registers

  always_ff @( posedge clk )
    if (reset) begin
      val_X           <= 1'b0;
      stats_en_wen_X  <= 1'b0;
    end else if (reg_en_X) begin
      val_X           <= next_val_D;
      rf_wen_pending_X<= rf_wen_pending_D;
      inst_X          <= inst_D;
      alu_fn_X        <= alu_fn_D;
      rf_waddr_X      <= rf_waddr_D;
      proc2mngr_val_X <= proc2mngr_val_D;
      dmemreq_type_X  <= dmemreq_type_D;
      wb_result_sel_X <= wb_result_sel_D;
      stats_en_wen_X  <= stats_en_wen_D;
      br_type_X       <= br_type_D;
      mul_X           <= mul_D;
      ex_result_sel_X <= ex_result_sel_D;
      xcelreq_X       <= xcelreq_D;
      xcelreq_type_X  <= xcelreq_type_D;
    end

  // branch logic, redirect PC in F if branch is taken

  always_comb begin
    pc_redirect_X = 1'b0;
    if ( val_X ) begin
      case (br_type_X)
        br_eq:
          pc_redirect_X = br_cond_eq_X;
        br_lt:
          pc_redirect_X = br_cond_lt_X;
        br_lu:
          pc_redirect_X = br_cond_ltu_X;
        br_ne:
          pc_redirect_X = !br_cond_eq_X;
        br_ge:
          pc_redirect_X = !br_cond_lt_X;
        br_gu:
          pc_redirect_X = !br_cond_ltu_X;
        jalr:
          pc_redirect_X = 1'b1;
        default:
          pc_redirect_X = 1'b0;
      endcase
    end
  end

  // ostall due to dmemreq not ready.
  logic ostall_dmem_X;
  assign ostall_dmem_X = ( dmemreq_type_X != nr ) && !dmemreq_rdy;

  // ostall due to imul
  logic ostall_imul_X;
  assign ostall_imul_X = mul_X && !imul_resp_val_X;

  // ostall due to xcelreq
  logic ostall_xcel_X;
  assign ostall_xcel_X = xcelreq_X && !xcelreq_rdy;

  assign ostall_X = val_X && ( ostall_dmem_X || ostall_imul_X || ostall_xcel_X );

  // osquash due to taken branch, notice we can't osquash if current
  // stage stalls, otherwise we will send osquash twice.

  assign osquash_X = val_X && !stall_X && pc_redirect_X;

  // stall and squash used in X stage

  assign stall_X = val_X && ( ostall_X || ostall_M || ostall_W );

  // set dmemreq_val only if not stalling

  assign dmemreq_val = val_X && !stall_X && ( dmemreq_type_X != nr );
  assign dmemreq_msg_type = (dmemreq_type_X == st) ?
                                `VC_MEM_REQ_MSG_TYPE_WRITE :
                                `VC_MEM_REQ_MSG_TYPE_READ;

  // send xecl req if not stalling

  assign xcelreq_val = val_X && !stall_X && xcelreq_X;
  assign xcelreq_msg_type  = xcelreq_type_X;

  // multiplier response ready signal
  assign imul_resp_rdy_X = val_X && !stall_X && mul_X;

  // Valid signal for the next stage

  logic  next_val_X;
  assign next_val_X = val_X && !stall_X;

  //----------------------------------------------------------------------
  // M stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_M  = !stall_M;

  logic [31:0] inst_M;
  logic [1:0]  dmemreq_type_M;
  logic        proc2mngr_val_M;
  logic        stats_en_wen_M;
  logic        xcelreq_M;

  // Pipeline register

  always_ff @( posedge clk )
    if (reset) begin
      val_M            <= 1'b0;
      stats_en_wen_M   <= 1'b0;
    end else if (reg_en_M) begin
      val_M            <= next_val_X;
      rf_wen_pending_M <= rf_wen_pending_X;
      inst_M           <= inst_X;
      rf_waddr_M       <= rf_waddr_X;
      proc2mngr_val_M  <= proc2mngr_val_X;
      dmemreq_type_M   <= dmemreq_type_X;
      wb_result_sel_M  <= wb_result_sel_X;
      stats_en_wen_M   <= stats_en_wen_X;
      xcelreq_M        <= xcelreq_X;
    end

  // ostall due to dmemresp not valid

  logic ostall_dmem_M;
  assign ostall_dmem_M = ( dmemreq_type_M != nr ) && !dmemresp_val;

  logic ostall_xcel_M;
  assign ostall_xcel_M = xcelreq_M && !xcelresp_val;

  assign ostall_M = val_M && ( ostall_dmem_M || ostall_xcel_M );

  // stall M

  assign stall_M = val_M && ( ostall_M || ostall_W );

  // Set dmemresp_rdy if valid and not stalling and this is a lw/sw

  assign dmemresp_rdy = val_M && !stall_M && ( dmemreq_type_M != nr );

  // Set xrelresp_rdy if not stalling

  assign xcelresp_rdy = val_M && !stall_M && xcelreq_M;

  // Valid signal for the next stage

  logic  next_val_M;
  assign next_val_M = val_M && !stall_M;

  //----------------------------------------------------------------------
  // W stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_W = !stall_W;

  logic [31:0] inst_W;
  logic        proc2mngr_val_W;
  logic        stats_en_wen_pending_W;

  // Pipeline registers

  always_ff @( posedge clk ) begin
    if (reset) begin
      val_W            <= 1'b0;
      stats_en_wen_pending_W   <= 1'b0;
    end else if (reg_en_W) begin
      val_W            <= next_val_M;
      rf_wen_pending_W <= rf_wen_pending_M;
      inst_W           <= inst_M;
      rf_waddr_W       <= rf_waddr_M;
      proc2mngr_val_W  <= proc2mngr_val_M;
      stats_en_wen_pending_W   <= stats_en_wen_M;
    end
  end

  // write enable

  assign rf_wen_W       = val_W && rf_wen_pending_W;
  assign stats_en_wen_W = val_W && stats_en_wen_pending_W;

  // ostall due to proc2mngr

  assign ostall_W = val_W && proc2mngr_val_W && !proc2mngr_rdy;

  // stall and squash signal used in W stage

  assign stall_W = val_W && ostall_W;

  // proc2mngr port

  assign proc2mngr_val = val_W && !stall_W && proc2mngr_val_W;

  assign commit_inst = val_W && !stall_W;

endmodule

`endif /* PROC_PROC_CTRL_V */

