#=========================================================================
# ProcCtrlPRTL.py
#=========================================================================

from pymtl        import *

from TinyRV2InstPRTL import *
from XcelMsg import XcelReqMsg, XcelRespMsg

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg

class ProcCtrlPRTL( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # imem ports

    s.imemreq_val      = OutPort( 1 )
    s.imemreq_rdy      = InPort ( 1 )

    s.imemresp_val     = InPort ( 1 )
    s.imemresp_rdy     = OutPort( 1 )

    s.imemresp_drop    = OutPort( 1 )

    # dmem ports

    s.dmemreq_val      = OutPort( 1 )
    s.dmemreq_rdy      = InPort ( 1 )
    s.dmemreq_msg_type = OutPort( 4 )

    s.dmemresp_val     = InPort ( 1 )
    s.dmemresp_rdy     = OutPort( 1 )

    # mngr ports

    s.mngr2proc_val    = InPort ( 1 )
    s.mngr2proc_rdy    = OutPort( 1 )

    s.proc2mngr_val    = OutPort( 1 )
    s.proc2mngr_rdy    = InPort ( 1 )

    # Control signals (ctrl->dpath)

    s.reg_en_F         = OutPort( 1 )
    s.pc_sel_F         = OutPort( 2 )

    s.reg_en_D         = OutPort( 1 )
    s.op1_byp_sel_D    = OutPort( 2 )
    s.op2_byp_sel_D    = OutPort( 2 )
    s.op1_sel_D        = OutPort( 1 )
    s.op2_sel_D        = OutPort( 2 )
    s.csrr_sel_D       = OutPort( 2 )
    s.imm_type_D       = OutPort( 3 )
    s.mdu_req_val      = OutPort( 1 )
    s.mdu_req_rdy      = InPort ( 1 )
    s.mdu_req_typ      = OutPort( 3 )

    s.reg_en_X         = OutPort( 1 )
    s.alu_fn_X         = OutPort( 4 )
    s.ex_result_sel_X  = OutPort( 2 )
    s.mdu_resp_rdy     = OutPort( 1 )
    s.mdu_resp_val     = InPort ( 1 )

    s.reg_en_M         = OutPort( 1 )
    s.wb_result_sel_M  = OutPort( 2 )

    s.reg_en_W         = OutPort( 1 )
    s.rf_waddr_W       = OutPort( 5 )
    s.rf_wen_W         = OutPort( 1 )

    # Status signals (dpath->ctrl)

    s.inst_D           = InPort ( 32 )
    s.br_cond_eq_X     = InPort ( 1 )
    s.br_cond_lt_X     = InPort ( 1 )
    s.br_cond_ltu_X    = InPort ( 1 )

    # Output val_W for counting

    s.commit_inst      = OutPort( 1 )

    s.stats_en_wen_W   = OutPort( 1 )

    #-----------------------------------------------------------------------
    # Control unit logic
    #-----------------------------------------------------------------------
    # We follow this principle to organize code for each pipeline stage in
    # the control unit.  Register enable logics should always at the
    # beginning. It followed by pipeline registers. Then logic that is not
    # dependent on stall or squash signals. Then logic that is dependent on
    # stall or squash signals. At the end there should be signals meant to
    # be passed to the next stage in the pipeline.

    #---------------------------------------------------------------------
    # Valid, stall, and squash signals
    #---------------------------------------------------------------------
    # We use valid signal to indicate if the instruction is valid.  An
    # instruction can become invalid because of being squashed or
    # stalled. Notice that invalid instructions are microarchitectural
    # events, they are different from archtectural no-ops. We must be
    # careful about control signals that might change the state of the
    # processor. We should always AND outgoing control signals with valid
    # signal.

    s.val_F = Wire( 1 )
    s.val_D = Wire( 1 )
    s.val_X = Wire( 1 )
    s.val_M = Wire( 1 )
    s.val_W = Wire( 1 )

    # Managing the stall and squash signals is one of the most important,
    # yet also one of the most complex, aspects of designing a pipelined
    # processor. We will carefully use four signals per stage to manage
    # stalling and squashing: ostall_A, osquash_A, stall_A, and squash_A.

    # We denote the stall signals _originating_ from stage A as
    # ostall_A. For example, if stage A can stall due to a pipeline
    # harzard, then ostall_A would need to factor in the stalling
    # condition for this pipeline harzard.

    s.ostall_F = Wire( 1 )  # can ostall due to imemresp_val
    s.ostall_D = Wire( 1 )  # can ostall due to mngr2proc_val or other hazards
    s.ostall_X = Wire( 1 )  # can ostall due to dmemreq_rdy
    s.ostall_M = Wire( 1 )  # can ostall due to dmemresp_val
    s.ostall_W = Wire( 1 )  # can ostall due to proc2mngr_rdy

    # The stall_A signal should be used to indicate when stage A is indeed
    # stalling. stall_A will be a function of ostall_A and all the ostall
    # signals of stages in front of it in the pipeline.

    s.stall_F = Wire( 1 )
    s.stall_D = Wire( 1 )
    s.stall_X = Wire( 1 )
    s.stall_M = Wire( 1 )
    s.stall_W = Wire( 1 )

    # We denote the squash signals _originating_ from stage A as
    # osquash_A. For example, if stage A needs to squash the stages behind
    # A in the pipeline, then osquash_A would need to factor in this
    # squash condition.

    s.osquash_D = Wire( 1 ) # can osquash due to unconditional jumps
    s.osquash_X = Wire( 1 ) # can osquash due to taken branches

    # The squash_A signal should be used to indicate when stage A is being
    # squashed. squash_A will _not_ be a function of osquash_A, since
    # osquash_A means to squash the stages _behind_ A in the pipeline, but
    # not to squash A itself.

    s.squash_F = Wire( 1 )
    s.squash_D = Wire( 1 )

    # Shunning: IMPORTANT (FIXME?)
    # Signals related to accelerators. I centralize it to make it easier
    # to switch between Proc and the original ProcAlt

    # ports
    s.xcelreq_val       = OutPort( 1 )
    s.xcelreq_rdy       = InPort ( 1 )
    s.xcelreq_msg_type  = OutPort( 1 )

    s.xcelresp_val  = InPort ( 1 )
    s.xcelresp_rdy  = OutPort( 1 )

    # signals
    s.xcelreq_type_D  = Wire( 1 )
    s.xcelreq_type_X  = Wire( 1 )

    s.xcelreq_D     = Wire( 1 )
    s.xcelreq_X     = Wire( 1 )
    s.xcelreq_M     = Wire( 1 )
    s.ostall_xcel_X = Wire( 1 )
    s.ostall_xcel_M = Wire( 1 )

    #---------------------------------------------------------------------
    # F stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_reg_en_F():
      s.reg_en_F.value = ~s.stall_F | s.squash_F

    @s.posedge_clk
    def reg_F():
      if s.reset:
        s.val_F.next = 0
      elif s.reg_en_F:
        s.val_F.next = 1

    # forward declaration of branch/jump logic

    s.pc_redirect_D = Wire( 1 )
    s.pc_redirect_X = Wire( 1 )

    # pc sel logic

    @s.combinational
    def comb_PC_sel_F():
      if   s.pc_redirect_X:

        if s.br_type_X == jalr:
          s.pc_sel_F.value = 3 # jalr target from ALU
        else:
          s.pc_sel_F.value = 1 # branch target

      elif s.pc_redirect_D:
        s.pc_sel_F.value = 2 # use jal target
      else:
        s.pc_sel_F.value = 0 # use pc+4

    s.next_val_F = Wire( 1 )

    @s.combinational
    def comb_F():
      # ostall due to imemresp

      s.ostall_F.value      = s.val_F & ~s.imemresp_val

      # stall and squash in F stage

      s.stall_F.value       = s.val_F & ( s.ostall_F  | s.ostall_D |
                                          s.ostall_X  | s.ostall_M |
                                          s.ostall_W                 )
      s.squash_F.value      = s.val_F & ( s.osquash_D | s.osquash_X  )

      # imem req is special, it actually be sent out _before_ the F
      # stage, we need to send memreq everytime we are getting squashed
      # because we need to redirect the PC. We also need to factor in
      # reset. When we are resetting we shouldn't send out imem req.

      s.imemreq_val.value   =  ~s.reset & (~s.stall_F | s.squash_F)
      s.imemresp_rdy.value  =  ~s.stall_F | s.squash_F

      # We drop the mem response when we are getting squashed

      s.imemresp_drop.value = s.squash_F

      s.next_val_F.value    = s.val_F & ~s.stall_F & ~s.squash_F

    #---------------------------------------------------------------------
    # D stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_reg_en_D():
      s.reg_en_D.value = ~s.stall_D | s.squash_D

    @s.posedge_clk
    def reg_D():
      if s.reset:
        s.val_D.next = 0
      elif s.reg_en_D:
        s.val_D.next = s.next_val_F

    # Decoder, translate 32-bit instructions to symbols

    s.inst_type_decoder_D = m = DecodeInstType()

    s.connect( m.in_, s.inst_D )

    # Signals generated by control signal table

    s.inst_val_D            = Wire( 1 )
    s.br_type_D             = Wire( 3 )
    s.jal_D                 = Wire( 1 )
    s.rs1_en_D              = Wire( 1 )
    s.rs2_en_D              = Wire( 1 )
    s.alu_fn_D              = Wire( 4 )
    s.dmemreq_type_D        = Wire( 4 )
    s.wb_result_sel_D       = Wire( 2 )
    s.rf_wen_pending_D      = Wire( 1 )
    s.rf_waddr_sel_D        = Wire( 3 )
    s.csrw_D                = Wire( 1 )
    s.csrr_D                = Wire( 1 )
    s.proc2mngr_val_D       = Wire( 1 )
    s.mngr2proc_rdy_D       = Wire( 1 )
    s.stats_en_wen_D        = Wire( 1 )
    s.ex_result_sel_D       = Wire( 2 )
    s.mdu_D                 = Wire( 4 )

    # actual waddr, selected base on rf_waddr_sel_D

    s.rf_waddr_D = Wire( 5 )

    # Control signal table

    # Y/N parameters

    n = Bits( 1, 0 )
    y = Bits( 1, 1 )

    # Branch type
    # I add jalr here because it is also resolved at X stage

    br_x  = Bits( 3, 0 ) # don't care
    br_na = Bits( 3, 0 ) # N/A, not branch
    br_ne = Bits( 3, 1 ) # branch not equal
    br_lt = Bits( 3, 2 ) # branch less than
    br_lu = Bits( 3, 3 ) # branch less than, unsigned
    br_eq = Bits( 3, 4 ) # branch equal
    br_ge = Bits( 3, 5 ) # branch greater than or equal to
    br_gu = Bits( 3, 6 ) # branch greater than or equal to, unsigned
    jalr  = Bits( 3, 7 ) # branch greater than or equal to, unsigned

    # Op1 mux select

    am_x  = Bits( 1, 0 ) # don't care
    am_rf = Bits( 1, 0 ) # use data from RF
    am_pc = Bits( 1, 1 ) # use PC

    # Op2 mux select

    bm_x   = Bits( 2, 0 ) # don't care
    bm_rf  = Bits( 2, 0 ) # use data from RF
    bm_imm = Bits( 2, 1 ) # use imm
    bm_csr = Bits( 2, 2 ) # use mngr2proc/numcores/coreid based on csrnum

    # IMM type

    imm_x = Bits( 3, 0 ) # don't care
    imm_i = Bits( 3, 0 ) # I-imm
    imm_s = Bits( 3, 1 ) # S-imm
    imm_b = Bits( 3, 2 ) # B-imm
    imm_u = Bits( 3, 3 ) # U-imm
    imm_j = Bits( 3, 4 ) # J-imm

    # ALU func

    alu_x   = Bits( 4, 0  )
    alu_add = Bits( 4, 0  )
    alu_sub = Bits( 4, 1  )
    alu_sll = Bits( 4, 2  )
    alu_or  = Bits( 4, 3  )
    alu_lt  = Bits( 4, 4  )
    alu_ltu = Bits( 4, 5  )
    alu_and = Bits( 4, 6  )
    alu_xor = Bits( 4, 7  )
    alu_nor = Bits( 4, 8  )
    alu_srl = Bits( 4, 9  )
    alu_sra = Bits( 4, 10 )
    alu_cp0 = Bits( 4, 11 ) # copy in0
    alu_cp1 = Bits( 4, 12 ) # copy in1
    alu_adz = Bits( 4, 13 ) # special case for JALR

    # Memory request type

    mem_nr  = Bits( 4,  0 )
    mem_ld  = Bits( 4,  1 )
    mem_st  = Bits( 4,  2 )
    mem_ad  = Bits( 4,  3 ) # AMO_ADD
    mem_an  = Bits( 4,  4 ) # AMO_AND
    mem_or  = Bits( 4,  5 ) # AMO_OR
    mem_sp  = Bits( 4,  6 ) # AMO_SWAP
    mem_mn  = Bits( 4,  7 ) # AMO_MIN
    mem_mnu = Bits( 4,  8 ) # AMO_MINU
    mem_mx  = Bits( 4,  9 ) # AMO_MAX
    mem_mxu = Bits( 4, 10 ) # AMO_MAXU
    mem_xr  = Bits( 4, 11 ) # AMO_XOR

    # RV32M request type
    # Set don't care to 8 to simplify everything, e.g. mdu.msg.typ = mdu_D

    md_x    = Bits( 4,  8 ) # not mdu
    md_mul  = Bits( 4,  0 ) # mul
    md_mh   = Bits( 4,  1 ) # mulh
    md_mhsu = Bits( 4,  2 ) # mulhsu
    md_mhu  = Bits( 4,  3 ) # mulhu
    md_div  = Bits( 4,  4 ) # div
    md_divu = Bits( 4,  5 ) # divu
    md_rem  = Bits( 4,  6 ) # rem
    md_remu = Bits( 4,  7 ) # remu

    # X stage result mux select

    xm_x = Bits( 2, 0 ) # don't care
    xm_a = Bits( 2, 0 ) # Arithmetic
    xm_m = Bits( 2, 1 ) # Multiplier
    xm_p = Bits( 2, 2 ) # Pc+4

    # Write-back mux select

    wm_x = Bits( 2, 0 )
    wm_a = Bits( 2, 0 )
    wm_m = Bits( 2, 1 )
    wm_c = Bits( 2, 2 ) # xCel

    # control signal table

    # control signal table
    # csr: csrr, csrw
    # rr: add, sub, mul, and, or, xor, slt, sltu, sra, srl, sll
    # rimm: addi, andi, ori, xori, slti, sltiu, srai, srli, slli, lui, auipc
    # mem: lw, sw
    # jump: jal, jalr
    # branch: beq, bne, blt, bge, bltu, bgeu

    s.cs = Wire( 32 )

    @s.combinational
    def comb_control_table_D():
      inst = s.inst_type_decoder_D.out.value
      #                                             br    jal op1   rs1 imm    op2    rs2 alu      dmm      xres  wbmux rf  rv32m    cs cs
      #                                         val type   D  muxsel en type   muxsel  en fn       typ      sel   sel   wen          rr rw
      if   inst == NOP    : s.cs.value = concat( y, br_na, n, am_x,  n, imm_x, bm_x,   n, alu_x,   mem_nr,  xm_x, wm_a, n,  md_x,    n, n )
      # RV32I
      # xcel/csrr/csrw
      elif inst == CSRRX  : s.cs.value = concat( y, br_na, n, am_x,  n, imm_i, bm_imm, n, alu_cp1, mem_nr,  xm_a, wm_c, y,  md_x,    y, n )
      elif inst == CSRR   : s.cs.value = concat( y, br_na, n, am_x,  n, imm_i, bm_csr, n, alu_cp1, mem_nr,  xm_a, wm_a, y,  md_x,    y, n )
      elif inst == CSRW   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_cp0, mem_nr,  xm_a, wm_a, n,  md_x,    n, y )
      # reg-reg
      elif inst == ADD    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_add, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SUB    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sub, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == AND    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_and, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == OR     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_or , mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == XOR    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_xor, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLT    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_lt , mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLTU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_ltu, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SRA    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sra, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SRL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_srl, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_sll, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      # reg-imm
      elif inst == ADDI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == ANDI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_and, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == ORI    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_or , mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == XORI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_xor, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLTI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_lt , mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLTIU  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_ltu, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SRAI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_sra, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SRLI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_srl, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == SLLI   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_sll, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == LUI    : s.cs.value = concat( y, br_na, n, am_x,  n, imm_u, bm_imm, n, alu_cp1, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      elif inst == AUIPC  : s.cs.value = concat( y, br_na, n, am_pc, n, imm_u, bm_imm, n, alu_add, mem_nr,  xm_a, wm_a, y,  md_x,    n, n )
      # branch
      elif inst == BNE    : s.cs.value = concat( y, br_ne, n, am_rf, y, imm_b, bm_rf,  y, alu_x,   mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      elif inst == BEQ    : s.cs.value = concat( y, br_eq, n, am_rf, y, imm_b, bm_rf,  y, alu_x,   mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      elif inst == BLT    : s.cs.value = concat( y, br_lt, n, am_rf, y, imm_b, bm_rf,  y, alu_lt,  mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      elif inst == BLTU   : s.cs.value = concat( y, br_lu, n, am_rf, y, imm_b, bm_rf,  y, alu_ltu, mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      elif inst == BGE    : s.cs.value = concat( y, br_ge, n, am_rf, y, imm_b, bm_rf,  y, alu_lt,  mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      elif inst == BGEU   : s.cs.value = concat( y, br_gu, n, am_rf, y, imm_b, bm_rf,  y, alu_ltu, mem_nr,  xm_a, wm_x, n,  md_x,    n, n )
      # jump
      elif inst == JAL    : s.cs.value = concat( y, br_na, y, am_x,  n, imm_j, bm_x,   n, alu_x,   mem_nr,  xm_p, wm_a, y,  md_x,    n, n )
      elif inst == JALR   : s.cs.value = concat( y, jalr , n, am_rf, y, imm_i, bm_imm, n, alu_adz, mem_nr,  xm_p, wm_a, y,  md_x,    n, n )
      # mem
      elif inst == LW     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_i, bm_imm, n, alu_add, mem_ld,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == SW     : s.cs.value = concat( y, br_na, n, am_rf, y, imm_s, bm_imm, y, alu_add, mem_st,  xm_a, wm_m, n,  md_x,    n, n )
      # RV32A
      elif inst == AMOADD : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_ad,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOAND : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_an,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOOR  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_or,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOSWAP: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_sp,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOMIN : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mn,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOMINU: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mnu, xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOMAX : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mx,  xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOMAXU: s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_mxu, xm_a, wm_m, y,  md_x,    n, n )
      elif inst == AMOXOR : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_cp0, mem_xr,  xm_a, wm_m, y,  md_x,    n, n )
      # RV32M
      elif inst == MUL    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_mul,  n, n )
      elif inst == MULH   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_mh,   n, n )
      elif inst == MULHSU : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_mhsu, n, n )
      elif inst == MULHU  : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_mhu,  n, n )
      elif inst == DIV    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_div,  n, n )
      elif inst == DIVU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_divu, n, n )
      elif inst == REM    : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_rem,  n, n )
      elif inst == REMU   : s.cs.value = concat( y, br_na, n, am_rf, y, imm_x, bm_rf,  y, alu_x  , mem_nr,  xm_m, wm_a, y,  md_remu, n, n )
      else:                 s.cs.value = concat( n, br_x,  n, am_x,  n, imm_x, bm_x,   n, alu_x,   mem_nr,  xm_x, wm_x, n,  n,       n, n )

      s.inst_val_D.value       = s.cs[31:32]
      s.br_type_D.value        = s.cs[28:31]
      s.jal_D.value            = s.cs[27:28]
      s.op1_sel_D.value        = s.cs[26:27]
      s.rs1_en_D.value         = s.cs[25:26]
      s.imm_type_D.value       = s.cs[22:25]
      s.op2_sel_D.value        = s.cs[20:22]
      s.rs2_en_D.value         = s.cs[19:20]
      s.alu_fn_D.value         = s.cs[15:19]
      s.dmemreq_type_D.value   = s.cs[11:15]
      s.ex_result_sel_D.value  = s.cs[9:11]
      s.wb_result_sel_D.value  = s.cs[7:9]
      s.rf_wen_pending_D.value = s.cs[6:7]
      s.mdu_D.value            = s.cs[2:6]
      s.csrr_D.value           = s.cs[1:2]
      s.csrw_D.value           = s.cs[0:1]

      # setting the actual write address

      s.rf_waddr_D.value = s.inst_D[RD]

      # csrr/csrw logic

      s.csrr_sel_D.value      = 0
      s.xcelreq_type_D.value  = 0
      s.xcelreq_D.value       = 0
      s.mngr2proc_rdy_D.value = 0
      s.proc2mngr_val_D.value = 0
      s.stats_en_wen_D.value  = 0

      if s.csrr_D:
        if   s.inst_D[CSRNUM] == CSR_NUMCORES:
          s.csrr_sel_D.value = 1
        elif s.inst_D[CSRNUM] == CSR_COREID:
          s.csrr_sel_D.value = 2
        elif s.inst_D[CSRNUM] == CSR_MNGR2PROC:
          s.mngr2proc_rdy_D.value = 1

        else:
          # FIXME
          s.xcelreq_type_D.value = XcelReqMsg.TYPE_READ
          s.xcelreq_D.value = 1

      if s.csrw_D:
        if   s.inst_D[CSRNUM] == CSR_PROC2MNGR:
          s.proc2mngr_val_D.value = 1
        elif s.inst_D[CSRNUM] == CSR_STATS_EN:
          s.stats_en_wen_D.value = 1

        # In this case we handle accelerator registers requests.
        else:
          # FIXME
          s.xcelreq_type_D.value = XcelReqMsg.TYPE_WRITE
          s.xcelreq_D.value = 1

    # Jump logic

    @s.combinational
    def comb_jump_D():

      if s.val_D and s.jal_D:
        s.pc_redirect_D.value = 1
      else:
        s.pc_redirect_D.value = 0

    # forward wire declaration for hazard checking

    s.rf_waddr_X = Wire( 5 )
    s.rf_waddr_M = Wire( 5 )

    # bypassing logic

    byp_d = Bits( 2, 0 )
    byp_x = Bits( 2, 1 )
    byp_m = Bits( 2, 2 )
    byp_w = Bits( 2, 3 )

    @s.combinational
    def comb_bypass_D():

      s.op1_byp_sel_D.value = byp_d

      if s.rs1_en_D:

        if   s.val_X & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
                     & s.rf_wen_pending_X:    s.op1_byp_sel_D.value = byp_x
        elif s.val_M & ( s.inst_D[ RS1 ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ) \
                     & s.rf_wen_pending_M:    s.op1_byp_sel_D.value = byp_m
        elif s.val_W & ( s.inst_D[ RS1 ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ) \
                     & s.rf_wen_pending_W:    s.op1_byp_sel_D.value = byp_w

      s.op2_byp_sel_D.value = byp_d

      if s.rs2_en_D:

        if   s.val_X & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
                     & s.rf_wen_pending_X:    s.op2_byp_sel_D.value = byp_x
        elif s.val_M & ( s.inst_D[ RS2 ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ) \
                     & s.rf_wen_pending_M:    s.op2_byp_sel_D.value = byp_m
        elif s.val_W & ( s.inst_D[ RS2 ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ) \
                     & s.rf_wen_pending_W:    s.op2_byp_sel_D.value = byp_w

    # hazards checking logic
    # Although bypassing is added, we might still have RAW when there is
    # lw instruction in X stage

    # We also need to add a stall for CSRRX since the value will not be
    # returned from the accelerator until the M stage.

    s.ostall_ld_X_rs1_D    = Wire( 1 )
    s.ostall_ld_X_rs2_D    = Wire( 1 )
    s.ostall_amo_X_rs1_D   = Wire( 1 )
    s.ostall_amo_X_rs2_D   = Wire( 1 )
    s.ostall_csrrx_X_rs1_D = Wire( 1 )
    s.ostall_csrrx_X_rs2_D = Wire( 1 )

    s.ostall_hazard_D      = Wire( 1 )

    @s.combinational
    def comb_hazard_D():

      s.ostall_ld_X_rs1_D.value =\
          s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & ( s.dmemreq_type_X == mem_ld )

      s.ostall_ld_X_rs2_D.value =\
          s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & ( s.dmemreq_type_X == mem_ld )

      s.ostall_amo_X_rs1_D.value =\
          s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & (   ( s.dmemreq_type_X == mem_ad  ) \
            | ( s.dmemreq_type_X == mem_an  ) \
            | ( s.dmemreq_type_X == mem_or  ) \
            | ( s.dmemreq_type_X == mem_sp  ) \
            | ( s.dmemreq_type_X == mem_mn  ) \
            | ( s.dmemreq_type_X == mem_mnu ) \
            | ( s.dmemreq_type_X == mem_mx  ) \
            | ( s.dmemreq_type_X == mem_mxu ) \
            | ( s.dmemreq_type_X == mem_xr  ) )

      s.ostall_amo_X_rs2_D.value =\
          s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & (   ( s.dmemreq_type_X == mem_ad  ) \
            | ( s.dmemreq_type_X == mem_an  ) \
            | ( s.dmemreq_type_X == mem_or  ) \
            | ( s.dmemreq_type_X == mem_sp  ) \
            | ( s.dmemreq_type_X == mem_mn  ) \
            | ( s.dmemreq_type_X == mem_mnu ) \
            | ( s.dmemreq_type_X == mem_mx  ) \
            | ( s.dmemreq_type_X == mem_mxu ) \
            | ( s.dmemreq_type_X == mem_xr  ) )

      s.ostall_csrrx_X_rs1_D.value =\
          s.rs1_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS1 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & s.xcelreq_X & (s.xcelreq_type_X == XcelReqMsg.TYPE_READ)

      s.ostall_csrrx_X_rs2_D.value =\
          s.rs2_en_D & s.val_X & s.rf_wen_pending_X \
        & ( s.inst_D[ RS2 ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ) \
        & s.xcelreq_X & (s.xcelreq_type_X == XcelReqMsg.TYPE_READ)

      s.ostall_hazard_D.value =\
          s.ostall_ld_X_rs1_D    | s.ostall_ld_X_rs2_D \
        | s.ostall_amo_X_rs1_D   | s.ostall_amo_X_rs2_D \
        | s.ostall_csrrx_X_rs1_D | s.ostall_csrrx_X_rs2_D


    # ostall due to mngr2proc

    s.ostall_mngr_D       = Wire( 1 )

    # ostall due to mdu

    s.ostall_mdu_D       = Wire( 1 )

    s.next_val_D = Wire( 1 )

    @s.combinational
    def comb_D():

      # ostall due to mngr2proc
      s.ostall_mngr_D.value = s.mngr2proc_rdy_D & ~s.mngr2proc_val

      # ostall due to mdu
      s.ostall_mdu_D.value  = s.val_D & ~s.mdu_D[3] & ~s.mdu_req_rdy

      # put together all ostall conditions

      s.ostall_D.value = s.val_D & ( s.ostall_mngr_D | s.ostall_hazard_D | s.ostall_mdu_D );

      # stall in D stage

      s.stall_D.value = s.val_D & ( s.ostall_D | s.ostall_X |
                                    s.ostall_M | s.ostall_W   )

      # osquash due to jumps
      # Note that, in the same combinational block, we have to calculate
      # s.stall_D first then use it in osquash_D. Several people have
      # stuck here just because they calculate osquash_D before stall_D!

      s.osquash_D.value = s.val_D & ~s.stall_D & s.pc_redirect_D

      # squash in D stage

      s.squash_D.value = s.val_D & s.osquash_X

      # mngr2proc port

      s.mngr2proc_rdy.value = s.val_D & ~s.stall_D & s.mngr2proc_rdy_D

      # mdu request valid signal

      s.mdu_req_val.value = s.val_D & ~s.stall_D & ~s.squash_D & ~s.mdu_D[3]

      s.mdu_req_typ.value = s.mdu_D[0:3]

      # next valid bit

      s.next_val_D.value = s.val_D & ~s.stall_D & ~s.squash_D

    #---------------------------------------------------------------------
    # X stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_reg_en_X():
      s.reg_en_X.value  = ~s.stall_X

    s.inst_type_X      = Wire( 8 )
    s.rf_wen_pending_X = Wire( 1 )
    s.proc2mngr_val_X  = Wire( 1 )
    s.dmemreq_type_X   = Wire( 4 )
    s.wb_result_sel_X  = Wire( 2 )
    s.stats_en_wen_X   = Wire( 1 )
    s.br_type_X        = Wire( 3 )
    s.mdu_X            = Wire( 4 )

    @s.posedge_clk
    def reg_X():
      if s.reset:
        s.val_X.next            = 0
        s.stats_en_wen_X.next   = 0
      elif s.reg_en_X:
        s.val_X.next            = s.next_val_D
        s.rf_wen_pending_X.next = s.rf_wen_pending_D
        s.inst_type_X.next      = s.inst_type_decoder_D.out
        s.alu_fn_X.next         = s.alu_fn_D
        s.rf_waddr_X.next       = s.rf_waddr_D
        s.proc2mngr_val_X.next  = s.proc2mngr_val_D
        s.dmemreq_type_X.next   = s.dmemreq_type_D
        s.wb_result_sel_X.next  = s.wb_result_sel_D
        s.stats_en_wen_X.next   = s.stats_en_wen_D
        s.br_type_X.next        = s.br_type_D
        s.mdu_X.next            = s.mdu_D
        s.ex_result_sel_X.next  = s.ex_result_sel_D
        s.xcelreq_X.next        = s.xcelreq_D
        s.xcelreq_type_X.next   = s.xcelreq_type_D

    # Branch logic

    @s.combinational
    def comb_br_X():
      s.pc_redirect_X.value = 0

      if s.val_X:
        if   s.br_type_X == br_eq: s.pc_redirect_X.value = s.br_cond_eq_X
        elif s.br_type_X == br_lt: s.pc_redirect_X.value = s.br_cond_lt_X
        elif s.br_type_X == br_lu: s.pc_redirect_X.value = s.br_cond_ltu_X
        elif s.br_type_X == br_ne: s.pc_redirect_X.value = ~s.br_cond_eq_X
        elif s.br_type_X == br_ge: s.pc_redirect_X.value = ~s.br_cond_lt_X
        elif s.br_type_X == br_gu: s.pc_redirect_X.value = ~s.br_cond_ltu_X
        elif s.br_type_X == jalr : s.pc_redirect_X.value = 1

    s.ostall_dmem_X = Wire( 1 )
    s.ostall_mdu_X  = Wire( 1 )
    s.ostall_xcel_X = Wire( 1 )
    s.next_val_X    = Wire( 1 )

    @s.combinational
    def comb_X():

      # ostall due to xcelreq
      s.ostall_xcel_X.value = s.xcelreq_X & ~s.xcelreq_rdy

      # ostall due to dmemreq
      s.ostall_dmem_X.value = ( s.dmemreq_type_X != mem_nr ) & ~s.dmemreq_rdy

      # ostall due to mdu
      s.ostall_mdu_X.value = ~s.mdu_X[3] & ~s.mdu_resp_val

      s.ostall_X.value = s.val_X & ( s.ostall_dmem_X | s.ostall_mdu_X | s.ostall_xcel_X )

      # stall in X stage

      s.stall_X.value  = s.val_X & ( s.ostall_X | s.ostall_M | s.ostall_W )

      # osquash due to taken branches
      # Note that, in the same combinational block, we have to calculate
      # s.stall_X first then use it in osquash_X. Several people have
      # stuck here just because they calculate osquash_X before stall_X!

      s.osquash_X.value   = s.val_X & ~s.stall_X & s.pc_redirect_X

      # send dmemreq if not stalling

      s.dmemreq_val.value = s.val_X & ~s.stall_X & ( s.dmemreq_type_X != mem_nr )

      # set dmemreq type, with MemReqMsg.TYPE_READ as "don't care / load"

      if   s.dmemreq_type_X == mem_st  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_WRITE
      elif s.dmemreq_type_X == mem_ad  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_ADD
      elif s.dmemreq_type_X == mem_an  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_AND
      elif s.dmemreq_type_X == mem_or  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_OR
      elif s.dmemreq_type_X == mem_sp  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_SWAP
      elif s.dmemreq_type_X == mem_mn  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MIN
      elif s.dmemreq_type_X == mem_mnu : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MINU
      elif s.dmemreq_type_X == mem_mx  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MAX
      elif s.dmemreq_type_X == mem_mxu : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_MAXU
      elif s.dmemreq_type_X == mem_xr  : s.dmemreq_msg_type.value = MemReqMsg.TYPE_AMO_XOR
      else                             : s.dmemreq_msg_type.value = MemReqMsg.TYPE_READ

      # send xcelreq if not stalling

      s.xcelreq_val.value = s.val_X & ~s.stall_X & s.xcelreq_X
      s.xcelreq_msg_type.value  = s.xcelreq_type_X

      # mdu resp ready signal

      s.mdu_resp_rdy.value = s.val_X & ~s.stall_X & ~s.mdu_X[3]

      # next valid bit

      s.next_val_X.value  = s.val_X & ~s.stall_X

    #---------------------------------------------------------------------
    # M stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_reg_en_M():
      s.reg_en_M.value = ~s.stall_M

    s.inst_type_M      = Wire( 8 )
    s.rf_wen_pending_M = Wire( 1 )
    s.proc2mngr_val_M  = Wire( 1 )
    s.dmemreq_type_M   = Wire( 4 )
    s.stats_en_wen_M   = Wire( 1 )

    @s.posedge_clk
    def reg_M():
      if s.reset:
        s.val_M.next            = 0
        s.stats_en_wen_M.next   = 0
      elif s.reg_en_M:
        s.val_M.next            = s.next_val_X
        s.rf_wen_pending_M.next = s.rf_wen_pending_X
        s.inst_type_M.next      = s.inst_type_X
        s.rf_waddr_M.next       = s.rf_waddr_X
        s.proc2mngr_val_M.next  = s.proc2mngr_val_X
        s.dmemreq_type_M.next   = s.dmemreq_type_X
        s.wb_result_sel_M.next  = s.wb_result_sel_X
        s.stats_en_wen_M.next   = s.stats_en_wen_X
        # xcel
        s.xcelreq_M.next        = s.xcelreq_X

    s.ostall_dmem_M = Wire( 1 )
    s.next_val_M    = Wire( 1 )

    @s.combinational
    def comb_M():

      # ostall due to xcel resp
      s.ostall_xcel_M.value = s.xcelreq_M & ~s.xcelresp_val

      # ostall due to dmem resp
      s.ostall_dmem_M.value = ( s.dmemreq_type_M != mem_nr ) & ~s.dmemresp_val

      s.ostall_M.value = s.val_M & ( s.ostall_dmem_M | s.ostall_xcel_M )

      # stall in M stage

      s.stall_M.value  = s.val_M & ( s.ostall_M | s.ostall_W )

      # set dmemresp ready if not stalling

      s.dmemresp_rdy.value = s.val_M & ~s.stall_M & ( s.dmemreq_type_M != mem_nr )

      # set xcelresp ready if not stalling

      s.xcelresp_rdy.value = s.val_M & ~s.stall_M & s.xcelreq_M

      # next valid bit

      s.next_val_M.value   = s.val_M & ~s.stall_M

    #---------------------------------------------------------------------
    # W stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_W():
      s.reg_en_W.value = ~s.stall_W

    s.inst_type_W            = Wire( 8 )
    s.proc2mngr_val_W        = Wire( 1 )
    s.rf_wen_pending_W       = Wire( 1 )
    s.stats_en_wen_pending_W = Wire( 1 )

    @s.posedge_clk
    def reg_W():

      if s.reset:
        s.val_W.next            = 0
        s.stats_en_wen_pending_W.next   = 0
      elif s.reg_en_W:
        s.val_W.next                  = s.next_val_M
        s.rf_wen_pending_W.next       = s.rf_wen_pending_M
        s.inst_type_W.next            = s.inst_type_M
        s.rf_waddr_W.next             = s.rf_waddr_M
        s.proc2mngr_val_W.next        = s.proc2mngr_val_M
        s.stats_en_wen_pending_W.next = s.stats_en_wen_M

    s.ostall_proc2mngr_W = Wire( 1 )

    @s.combinational
    def comb_W():
      # set RF write enable if valid

      s.rf_wen_W.value       = s.val_W & s.rf_wen_pending_W
      s.stats_en_wen_W.value = s.val_W & s.stats_en_wen_pending_W

      # ostall due to proc2mngr

      s.ostall_W.value      = s.val_W & s.proc2mngr_val_W & ~s.proc2mngr_rdy

      # stall in W stage

      s.stall_W.value       = s.val_W & s.ostall_W

      # set proc2mngr val if not stalling

      s.proc2mngr_val.value = s.val_W & ~s.stall_W & s.proc2mngr_val_W

      s.commit_inst.value   = s.val_W & ~s.stall_W
