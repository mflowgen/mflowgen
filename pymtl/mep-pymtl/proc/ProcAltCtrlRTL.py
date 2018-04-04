#=========================================================================
# ProcBaseCtrlRTL.py
#=========================================================================

from pymtl       import *

from PARCInstRTL import *

class ProcAltCtrlRTL( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # go bit

    s.go               = InPort ( 1 )

    # imem ports

    s.imemreq_val      = OutPort( 1 )
    s.imemreq_rdy      = InPort ( 1 )

    s.imemresp_val     = InPort ( 1 )
    s.imemresp_rdy     = OutPort( 1 )

    s.imemresp_drop    = OutPort( 1 )

    # dmem ports

    s.dmemreq_val      = OutPort( 1 )
    s.dmemreq_rdy      = InPort ( 1 )
    s.dmemreq_msg_type = OutPort( 3 )

    s.dmemresp_val     = InPort ( 1 )
    s.dmemresp_rdy     = OutPort( 1 )

    # xcel ports

    s.xcelreq_val      = OutPort( 1 )
    s.xcelreq_rdy      = InPort ( 1 )
    s.xcelresp_val     = InPort ( 1 )
    s.xcelresp_rdy     = OutPort( 1 )

    s.xcelreq_msg_type = OutPort( 1 )

    # mngr ports

    s.mngr2proc_val    = InPort ( 1 )
    s.mngr2proc_rdy    = OutPort( 1 )

    s.proc2mngr_val    = OutPort( 1 )
    s.proc2mngr_rdy    = InPort ( 1 )

    # Control signals (ctrl->dpath)

    s.reg_en_F         = OutPort( 1 )
    s.pc_sel_F         = OutPort( 2 )

    s.reg_en_D         = OutPort( 1 )
    s.op0_sel_D        = OutPort( 2 )
    s.op1_sel_D        = OutPort( 3 )
    s.op0_byp_sel_D    = OutPort( 2 )
    s.op1_byp_sel_D    = OutPort( 2 )

    s.reg_en_X         = OutPort( 1 )
    s.alu_fn_X         = OutPort( 4 )
    s.ex_result_sel_X  = OutPort( 1 )

    s.reg_en_M         = OutPort( 1 )
    s.wb_result_sel_M  = OutPort( 2 )

    s.reg_en_W         = OutPort( 1 )
    s.rf_waddr_W       = OutPort( 5 )
    s.rf_wen_W         = OutPort( 1 )
    s.stats_en_wen_W   = OutPort( 1 )

    # imul

    s.mul_req_val_D    = OutPort( 1 )
    s.mul_req_rdy_D    = InPort ( 1 )

    s.mul_resp_val_X   = InPort ( 1 )
    s.mul_resp_rdy_X   = OutPort( 1 )

    # output val_W for counting committed insts

    s.commit_inst      = OutPort( 1 )

    # Status signals (dpath->ctrl)

    s.inst_D           = InPort ( 32 )
    s.br_cond_eq_X     = InPort ( 1 )
    s.br_cond_neg_X    = InPort ( 1 )
    s.br_cond_zero_X   = InPort ( 1 )

    #----------------------------------------------------------------------
    # Control unit logic
    #----------------------------------------------------------------------
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

    #---------------------------------------------------------------------
    # F stage
    #---------------------------------------------------------------------

    # register for go bit

    s.go_reg_F = Wire( 1 )

    @s.posedge_clk
    def go_reg():
      if s.reset:
        s.go_reg_F.next = 0
      elif s.go:
        s.go_reg_F.next = s.go
      else:
        s.go_reg_F.next = s.go_reg_F

    @s.combinational
    def comb_reg_en_F():
      s.reg_en_F.value = ( ~s.stall_F | s.squash_F )

    @s.posedge_clk
    def reg_F():
      if s.reset:
        s.val_F.next = 0
      elif s.reg_en_F:
        s.val_F.next = 1

    # forward declaration of branch logic

    s.pc_redirect_X = Wire( 1 )
    s.pc_sel_X      = Wire( 2 )

    # pc sel logic

    s.pc_redirect_D = Wire( 1 )
    s.pc_sel_D      = Wire( 2 )

    @s.combinational
    def comb_PC_sel_F():
      if not s.go_reg_F:
        s.pc_sel_F.value = 0           # go bit not valid
      elif s.pc_redirect_X:
        s.pc_sel_F.value = s.pc_sel_X  # use branch target (if taken)
      elif s.pc_redirect_D:
        s.pc_sel_F.value = s.pc_sel_D  # use jump target
      else:
        s.pc_sel_F.value = 0           # use pc+4

    s.next_val_F = Wire( 1 )

    @s.combinational
    def comb_F():
      # ostall due to imemresp

      s.ostall_F.value      = s.val_F & ~s.imemresp_val

      # stall and squash in F stage

      s.stall_F.value       = ~s.go_reg_F | ( s.val_F & ( s.ostall_F  | s.ostall_D | s.ostall_X | s.ostall_M | s.ostall_W ) )
      s.squash_F.value      = s.val_F & ( s.osquash_D | s.osquash_X )

      # imem req is speical, it actually be sent out _before_ the F
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
    s.j_type_D              = Wire( 2 )
    s.br_type_D             = Wire( 3 )
    s.rs_en_D               = Wire( 1 )
    s.rt_en_D               = Wire( 1 )
    s.alu_fn_D              = Wire( 4 )
    s.dmemreq_type_D        = Wire( 2 )
    s.xcelreq_D             = Wire( 1 )
    s.wb_result_sel_D       = Wire( 2 )
    s.rf_wen_pending_D      = Wire( 1 )
    s.rf_waddr_sel_D        = Wire( 3 )
    s.proc2mngr_val_D       = Wire( 1 )
    s.mngr2proc_rdy_D       = Wire( 1 )
    s.mul_D                 = Wire( 1 )
    s.ex_result_sel_D       = Wire( 1 )
    s.stats_en_wen_D        = Wire( 1 )

    # actual waddr, selected base on rf_waddr_sel_D

    s.rf_waddr_D = Wire( 5 )

    # Control signal table

    # Y/N parameters

    n = Bits( 1, 0 )
    y = Bits( 1, 1 )

    # Register specifiers

    rx = Bits( 3, 0 )      # don't care
    rs = Bits( 3, 1 )      # rs
    rt = Bits( 3, 2 )      # rt
    rd = Bits( 3, 3 )      # rd
    rL = Bits( 3, 4 )      # r31

    # Branch type

    br_x    = Bits( 3, 0 ) # don't care
    br_none = Bits( 3, 0 ) # not branch
    br_bne  = Bits( 3, 1 ) # branch not equal
    br_beq  = Bits( 3, 2 ) # branch equal
    br_bgez = Bits( 3, 3 ) # branch >= 0
    br_bgtz = Bits( 3, 4 ) # branch > 0
    br_blez = Bits( 3, 5 ) # branch <= 0
    br_bltz = Bits( 3, 6 ) # branch < 0

    # jump type

    j_x     = Bits( 2, 0 ) # don't care
    j_n     = Bits( 2, 0 ) # not jump
    j_i     = Bits( 2, 1 ) # jump to imm
    j_r     = Bits( 2, 2 ) # jump to reg

    # Op0 mux select

    am_x    = Bits( 2, 0 ) # don't care
    am_rdat = Bits( 2, 0 ) # use data from RF
    am_samt = Bits( 2, 1 ) # use shift amount immediate
    am_16   = Bits( 2, 2 ) # use constant 16
    am_xcel = Bits( 2, 3 ) # use for mtx, mfx

    # Op1 mux select

    bm_x    = Bits( 3, 0 ) # don't care
    bm_rdat = Bits( 3, 0 ) # use data from RF
    bm_si   = Bits( 3, 1 ) # use imm_sext
    bm_zi   = Bits( 3, 2 ) # use imm_zext
    bm_pc   = Bits( 3, 3 ) # use imm_zext
    bm_fhst = Bits( 3, 4 ) # use mngr2proc data

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
    alu_cp0 = Bits( 4, 11 )
    alu_cp1 = Bits( 4, 12 )

    # Memory request type

    nr = Bits( 2, 0 )
    ld = Bits( 2, 1 )
    st = Bits( 2, 2 )

    # Write-back mux select

    wm_x = Bits( 2, 0 )
    wm_a = Bits( 2, 0 )
    wm_m = Bits( 2, 1 )
    wm_o = Bits( 2, 2 )

    # Control signal bit slices

    CS_INST_VAL       = slice( 28, 29 ) # 1
    CS_J_TYPE         = slice( 26, 28 ) # 2
    CS_BR_TYPE        = slice( 23, 26 ) # 3
    CS_OP0_SEL        = slice( 21, 23 ) # 2
    CS_RS_EN          = slice( 20, 21 ) # 1
    CS_OP1_SEL        = slice( 17, 20 ) # 3
    CS_RT_EN          = slice( 16, 17 ) # 1
    CS_ALU_FN         = slice( 12, 16 ) # 4
    CS_XCELREQ_VALUE  = slice( 11, 12 ) # 1
    CS_DMEMREQ_TYPE   = slice( 9,  11 ) # 2
    CS_WB_RESULT_SEL  = slice( 7,  9  ) # 2
    CS_RF_WEN_PENDING = slice( 6,  7  ) # 1
    CS_RF_WADDR_SEL   = slice( 3,  6  ) # 3
    CS_MUL            = slice( 2,  3  ) # 1
    CS_PROC2MNGR_VAL  = slice( 1,  2  ) # 1
    CS_MNGR2PROC_RDY  = slice( 0,  1  ) # 1

    s.cs_D = Wire( 29 )

    # control signal table

    @s.combinational
    def comb_control_table_D():
      inst = s.inst_type_decoder_D.out.value
      #                                              j    br       op0      rs op1      rt alu      xcel dmm wbmux rf  wa      thst fhst
      #                                          val type type     muxsel   en muxsel   en fn       val  typ sel   wen sel mul val  rdy
      if   inst == NOP  : s.cs_D.value = concat( y,  j_n, br_none, am_x,    n, bm_x,    n, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )

      # reg-to-reg instruction

      elif inst == MUL  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_x,   n,   nr, wm_a, y,  rd, y,  n,   n    )

      elif inst == ADDU : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_add, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SUBU : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_sub, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SLT  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_lt,  n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SLTU : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_ltu, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == AND  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_and, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == OR   : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_or,  n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == NOR  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_nor, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == XOR  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_xor, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SRAV : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_sra, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SRLV : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_srl, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SLLV : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_rdat, y, alu_sll, n,   nr, wm_a, y,  rd, n,  n,   n    )

      # reg-to-imm instruction

      elif inst == ADDIU: s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_si,   n, alu_add, n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == SLTI : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_si,   n, alu_lt,  n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == SLTIU: s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_si,   n, alu_ltu, n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == ORI  : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_zi,   n, alu_or,  n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == ANDI : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_zi,   n, alu_and, n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == XORI : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_zi,   n, alu_xor, n,   nr, wm_a, y,  rt, n,  n,   n    )
      elif inst == SRA  : s.cs_D.value = concat( y,  j_n, br_none, am_samt, n, bm_rdat, y, alu_sra, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SRL  : s.cs_D.value = concat( y,  j_n, br_none, am_samt, n, bm_rdat, y, alu_srl, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == SLL  : s.cs_D.value = concat( y,  j_n, br_none, am_samt, n, bm_rdat, y, alu_sll, n,   nr, wm_a, y,  rd, n,  n,   n    )
      elif inst == LUI  : s.cs_D.value = concat( y,  j_n, br_none, am_16,   y, bm_si,   y, alu_sll, n,   nr, wm_a, y,  rt, n,  n,   n    )

      # dmem instruction

      elif inst == LW   : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_si,   n, alu_add, n,   ld, wm_m, y,  rt, n,  n,   n    )
      elif inst == SW   : s.cs_D.value = concat( y,  j_n, br_none, am_rdat, y, bm_si,   y, alu_add, n,   st, wm_x, n,  rx, n,  n,   n    )

      elif inst == MTX  : s.cs_D.value = concat( y,  j_n, br_none, am_xcel, y, bm_rdat, y, alu_x,   y,   nr, wm_x, n,  rx, n,  n,   n    )
      elif inst == MFX  : s.cs_D.value = concat( y,  j_n, br_none, am_xcel, y, bm_rdat, y, alu_x,   y,   nr, wm_o, y,  rt, n,  n,   n    )

      # branch instruction

      elif inst == BNE  : s.cs_D.value = concat( y,  j_n, br_bne,  am_rdat, y, bm_rdat, y, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )
      elif inst == BEQ  : s.cs_D.value = concat( y,  j_n, br_beq,  am_rdat, y, bm_rdat, y, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )
      elif inst == BGEZ : s.cs_D.value = concat( y,  j_n, br_bgez, am_rdat, y, bm_x,    n, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )
      elif inst == BGTZ : s.cs_D.value = concat( y,  j_n, br_bgtz, am_rdat, y, bm_x,    n, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )
      elif inst == BLEZ : s.cs_D.value = concat( y,  j_n, br_blez, am_rdat, y, bm_x,    n, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )
      elif inst == BLTZ : s.cs_D.value = concat( y,  j_n, br_bltz, am_rdat, y, bm_x,    n, alu_x,   n,   nr, wm_a, n,  rx, n,  n,   n    )

      # jump instruction

      elif inst == J    : s.cs_D.value = concat( y,  j_i, br_none, am_x,    n, bm_x,    n, alu_x,   n,   nr, wm_x, n,  rx, n,  n,   n    )
      elif inst == JR   : s.cs_D.value = concat( y,  j_r, br_none, am_x,    y, bm_x,    n, alu_x,   n,   nr, wm_x, n,  rx, n,  n,   n    )
      elif inst == JALR : s.cs_D.value = concat( y,  j_r, br_none, am_x,    y, bm_pc,   n, alu_cp1, n,   nr, wm_x, y,  rd, n,  n,   n    )
      elif inst == JAL  : s.cs_D.value = concat( y,  j_i, br_none, am_x,    n, bm_pc,   n, alu_cp1, n,   nr, wm_x, y,  rL, n,  n,   n    )

      # mngr instruction

      elif inst == MFC0 : s.cs_D.value = concat( y,  j_n, br_none, am_x,    n, bm_fhst, n, alu_cp1, n,   nr, wm_a, y,  rt, n,  n,   y    )
      elif inst == MTC0 : s.cs_D.value = concat( y,  j_n, br_none, am_x,    n, bm_rdat, y, alu_cp1, n,   nr, wm_a, n,  rx, n,  y,   n    )

      else:               s.cs_D.value = concat( n,  j_x, br_x,    am_x,    n, bm_x,    n, alu_x,   n,   nr, wm_x, n,  rx, n,  n,   n    )

      # Unpack control signals

      s.inst_val_D.value       = s.cs_D[ CS_INST_VAL       ]
      s.j_type_D.value         = s.cs_D[ CS_J_TYPE         ]
      s.br_type_D.value        = s.cs_D[ CS_BR_TYPE        ]
      s.op0_sel_D.value        = s.cs_D[ CS_OP0_SEL        ]
      s.rs_en_D.value          = s.cs_D[ CS_RS_EN          ]
      s.op1_sel_D.value        = s.cs_D[ CS_OP1_SEL        ]
      s.rt_en_D.value          = s.cs_D[ CS_RT_EN          ]
      s.alu_fn_D.value         = s.cs_D[ CS_ALU_FN         ]
      s.xcelreq_D.value        = s.cs_D[ CS_XCELREQ_VALUE  ]
      s.dmemreq_type_D.value   = s.cs_D[ CS_DMEMREQ_TYPE   ]
      s.wb_result_sel_D.value  = s.cs_D[ CS_WB_RESULT_SEL  ]
      s.rf_wen_pending_D.value = s.cs_D[ CS_RF_WEN_PENDING ]
      s.rf_waddr_sel_D.value   = s.cs_D[ CS_RF_WADDR_SEL   ]
      s.mul_D.value            = s.cs_D[ CS_MUL            ]
      s.mngr2proc_rdy_D.value  = s.cs_D[ CS_MNGR2PROC_RDY  ]

      # Handle mtc0, mfc0, stats_en

      s.proc2mngr_val_D.value = 0
      s.stats_en_wen_D.value  = 0

      if s.cs_D[ CS_PROC2MNGR_VAL ] == y:
        if   s.inst_D[ RD ] == PISA_CPR_PROC2MNGR:
          s.proc2mngr_val_D.value = 1
        elif s.inst_D[ RD ] == PISA_CPR_STATS_EN:
          s.stats_en_wen_D.value = 1

      # setting the actual write address

      if   s.rf_waddr_sel_D == 0: s.rf_waddr_D.value = 0
      elif s.rf_waddr_sel_D == 1: s.rf_waddr_D.value = s.inst_D[ RS ]
      elif s.rf_waddr_sel_D == 2: s.rf_waddr_D.value = s.inst_D[ RT ]
      elif s.rf_waddr_sel_D == 3: s.rf_waddr_D.value = s.inst_D[ RD ]
      elif s.rf_waddr_sel_D == 4: s.rf_waddr_D.value = 31
      else:                       s.rf_waddr_D.value = 0

      # jump logic

      if s.val_D:
        if   s.j_type_D == j_i:
          s.pc_redirect_D.value = 1
          s.pc_sel_D.value      = 2
        elif s.j_type_D == j_r:
          s.pc_redirect_D.value = 1
          s.pc_sel_D.value      = 3
        else:
          s.pc_redirect_D.value = 0
          s.pc_sel_D.value      = 0
      else:
        s.pc_redirect_D.value   = 0
        s.pc_sel_D.value        = 0

      # imul result sel

      if s.mul_D : s.ex_result_sel_D.value = 1
      else       : s.ex_result_sel_D.value = 0

    # forward wire declaration for hazard checking

    s.rf_waddr_X      = Wire( 5 )
    s.rf_waddr_M      = Wire( 5 )

    # ostall due to hazards

    s.ostall_waddr_X_rs_D = Wire( 1 )
    s.ostall_waddr_M_rs_D = Wire( 1 )
    s.ostall_waddr_W_rs_D = Wire( 1 )
    s.ostall_waddr_X_rt_D = Wire( 1 )
    s.ostall_waddr_M_rt_D = Wire( 1 )
    s.ostall_waddr_W_rt_D = Wire( 1 )

    s.ostall_hazard_D     = Wire( 1 )

    # ostall due to mngr2proc, imul

    s.ostall_mngr_D       = Wire( 1 )
    s.ostall_mul_D        = Wire( 1 )

    # bypassing logic

    byp_r = Bits( 2, 0 ) # no bypassing
    byp_x = Bits( 2, 1 ) # bypass from X
    byp_m = Bits( 2, 2 ) # bypass from M
    byp_w = Bits( 2, 3 ) # bypass from W

    @s.combinational
    def comb_bypass_D():
      if   s.rs_en_D & s.val_X & s.rf_wen_pending_X & ( s.inst_D[ RS ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ):
        s.op0_byp_sel_D.value = byp_x;
      elif s.rs_en_D & s.val_M & s.rf_wen_pending_M & ( s.inst_D[ RS ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ):
        s.op0_byp_sel_D.value = byp_m;
      elif s.rs_en_D & s.val_W & s.rf_wen_pending_W & ( s.inst_D[ RS ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ):
        s.op0_byp_sel_D.value = byp_w;
      else:
        s.op0_byp_sel_D.value = byp_r;

      if   s.rt_en_D & s.val_X & s.rf_wen_pending_X & ( s.inst_D[ RT ] == s.rf_waddr_X ) & ( s.rf_waddr_X != 0 ):
        s.op1_byp_sel_D.value = byp_x;
      elif s.rt_en_D & s.val_M & s.rf_wen_pending_M & ( s.inst_D[ RT ] == s.rf_waddr_M ) & ( s.rf_waddr_M != 0 ):
        s.op1_byp_sel_D.value = byp_m;
      elif s.rt_en_D & s.val_W & s.rf_wen_pending_W & ( s.inst_D[ RT ] == s.rf_waddr_W ) & ( s.rf_waddr_W != 0 ):
        s.op1_byp_sel_D.value = byp_w;
      else:
        s.op1_byp_sel_D.value = byp_r;

    # stalling logic

    s.ostall_load_use_X_rs_D = Wire( 1 )
    s.ostall_load_use_X_rt_D = Wire( 1 )
    s.ostall_mfx_use_X_rs_D  = Wire( 1 )
    s.ostall_mfx_use_X_rt_D  = Wire( 1 )

    # forward declaration

    s.dmemreq_type_X   = Wire( 2 )
    s.xcelreq_X        = Wire( 1 )

    @s.combinational
    def comb_stall_D():
      s.ostall_load_use_X_rs_D.value = ( s.rs_en_D & s.val_X & s.rf_wen_pending_X &
                                      ( s.inst_D[ RS ] == s.rf_waddr_X ) &
                                      ( s.rf_waddr_X != 0 ) & ( s.dmemreq_type_X == ld ) )
      s.ostall_load_use_X_rt_D.value = ( s.rt_en_D & s.val_X & s.rf_wen_pending_X &
                                      ( s.inst_D[ RT ] == s.rf_waddr_X ) &
                                      ( s.rf_waddr_X != 0 ) & ( s.dmemreq_type_X == ld ) )
      s.ostall_mfx_use_X_rs_D.value = ( s.rs_en_D & s.val_X & s.rf_wen_pending_X &
                                      ( s.inst_D[ RS ] == s.rf_waddr_X ) &
                                      ( s.rf_waddr_X != 0 ) & ( s.inst_type_X == MFX ) )
      s.ostall_mfx_use_X_rt_D.value = ( s.rt_en_D & s.val_X & s.rf_wen_pending_X &
                                      ( s.inst_D[ RT ] == s.rf_waddr_X ) &
                                      ( s.rf_waddr_X != 0 ) & ( s.inst_type_X == MFX ) )

      s.ostall_hazard_D.value        = s.ostall_load_use_X_rs_D | s.ostall_load_use_X_rt_D | \
                                       s.ostall_mfx_use_X_rs_D  | s.ostall_mfx_use_X_rt_D

    s.next_val_D = Wire( 1 )

    @s.combinational
    def comb_D():
      # ostall due to mngr2proc

      s.ostall_mngr_D.value = s.mngr2proc_rdy_D & ~s.mngr2proc_val

      # ostall due to mul

      s.ostall_mul_D.value  = s.val_D & ( s.mul_D == y ) & ~s.mul_req_rdy_D

      # put together all ostall conditions

      s.ostall_D.value      = s.val_D & ( s.ostall_mngr_D | s.ostall_hazard_D | s.ostall_mul_D );

      # stall in D stage

      s.stall_D.value       = s.val_D & ( s.ostall_D | s.ostall_X | s.ostall_M | s.ostall_W )

      # osquash due to jumps, not implemented yet

      s.osquash_D.value     = s.val_D & ~s.stall_D & s.pc_redirect_D

      # squash in D stage

      s.squash_D.value      = s.val_D & s.osquash_X

      # mngr2proc port

      s.mngr2proc_rdy.value = s.val_D & ~s.stall_D & s.mngr2proc_rdy_D

      # mul req

      s.mul_req_val_D.value = s.val_D & ~s.stall_D & ~s.squash_D & ( s.mul_D == y )

      # next valid bit

      s.next_val_D.value    = s.val_D & ~s.stall_D & ~s.squash_D

    #---------------------------------------------------------------------
    # X stage
    #---------------------------------------------------------------------

    @s.combinational
    def comb_reg_en_X():
      s.reg_en_X.value  = ~s.stall_X

    s.inst_type_X      = Wire( 8 )
    s.rf_wen_pending_X = Wire( 1 )
    s.proc2mngr_val_X  = Wire( 1 )
    s.wb_result_sel_X  = Wire( 2 )
    s.br_type_X        = Wire( 3 )
    s.mul_X            = Wire( 1 )
    s.stats_en_wen_X   = Wire( 1 )

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
        s.xcelreq_X.next        = s.xcelreq_D
        s.wb_result_sel_X.next  = s.wb_result_sel_D
        s.br_type_X.next        = s.br_type_D
        s.mul_X.next            = s.mul_D
        s.ex_result_sel_X.next  = s.ex_result_sel_D
        s.stats_en_wen_X.next   = s.stats_en_wen_D

    # Branch logic

    @s.combinational
    def comb_br_X():
      if s.val_X:
        if   ( s.br_type_X == br_bne  ): s.pc_redirect_X.value = ~s.br_cond_eq_X
        elif ( s.br_type_X == br_beq  ): s.pc_redirect_X.value =  s.br_cond_eq_X
        elif ( s.br_type_X == br_bgez ): s.pc_redirect_X.value = ~s.br_cond_neg_X |  s.br_cond_zero_X
        elif ( s.br_type_X == br_bgtz ): s.pc_redirect_X.value = ~s.br_cond_neg_X & ~s.br_cond_zero_X
        elif ( s.br_type_X == br_blez ): s.pc_redirect_X.value =  s.br_cond_neg_X |  s.br_cond_zero_X
        elif ( s.br_type_X == br_bltz ): s.pc_redirect_X.value =  s.br_cond_neg_X & ~s.br_cond_zero_X
        else:                            s.pc_redirect_X.value =  0

        s.pc_sel_X.value        = 1
      else:
        s.pc_redirect_X.value   = 0
        s.pc_sel_X.value        = 0

    s.next_val_X    = Wire( 1 )

    s.ostall_mul_X  = Wire( 1 )
    s.ostall_dmem_X = Wire( 1 )
    s.ostall_xcel_X = Wire( 1 )

    @s.combinational
    def comb_X():
      # ostall due to dmemreq or imul or xcelreq

      s.ostall_dmem_X.value    = s.val_X & ( s.dmemreq_type_X != nr ) & ~s.dmemreq_rdy
      s.ostall_mul_X.value     = s.val_X & ( s.mul_X == y ) & ~s.mul_resp_val_X
      s.ostall_xcel_X.value    = s.val_X & ~s.xcelreq_rdy & s.xcelreq_X

      s.ostall_X.value         = s.val_X & ( s.ostall_dmem_X | s.ostall_mul_X.value | s.ostall_xcel_X )

      # stall in X stage

      s.stall_X.value     = s.val_X & ( s.ostall_X | s.ostall_M | s.ostall_W )

      # osquash due to taken branches

      s.osquash_X.value   = s.val_X & ~s.stall_X & s.pc_redirect_X

      # send dmemreq if not stalling

      s.dmemreq_val.value = s.val_X & ~s.stall_X & ( s.dmemreq_type_X != nr )

      if   s.dmemreq_type_X == ld:
        s.dmemreq_msg_type.value = 0  # read
      elif s.dmemreq_type_X == st:
        s.dmemreq_msg_type.value = 1  # write
      else:
        s.dmemreq_msg_type.value = 0

      # xcelreq signals

      if   s.inst_type_X == MFX:
        s.xcelreq_msg_type.value = 0  # read
      elif s.inst_type_X == MTX:
        s.xcelreq_msg_type.value = 1  # write
      else:
        s.xcelreq_msg_type.value = 0

      s.xcelreq_val.value = s.val_X & ~s.stall_X & ( s.xcelreq_X == y )

      # mul resp

      s.mul_resp_rdy_X.value = s.val_X & ~s.stall_X & ( s.mul_X == y )

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
    s.dmemreq_type_M   = Wire( 2 )
    s.stats_en_wen_M   = Wire( 1 )
    s.xcelreq_M        = Wire( 1 )

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
        s.xcelreq_M.next        = s.xcelreq_X
        s.wb_result_sel_M.next  = s.wb_result_sel_X
        s.stats_en_wen_M.next   = s.stats_en_wen_X

    s.next_val_M    = Wire( 1 )

    @s.combinational
    def comb_M():

      s.ostall_M.value      = s.val_M & ((( s.dmemreq_type_M != nr ) & ~s.dmemresp_val) | (s.xcelreq_M & ~s.xcelresp_val))


      # stall in M stage

      s.stall_M.value       = s.val_M & ( s.ostall_M | s.ostall_W )

      # set dmemresp ready if not stalling

      s.dmemresp_rdy.value  = s.val_M & ~s.stall_M & ( s.dmemreq_type_M != nr )
      s.xcelresp_rdy.value = s.val_M & ~s.stall_M & s.xcelreq_M

      # next valid bit

      s.next_val_M.value    = s.val_M & ~s.stall_M

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
        s.val_W.next                  = 0
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
      # set write enables if valid

      s.rf_wen_W.value       = s.val_W & s.rf_wen_pending_W
      s.stats_en_wen_W.value = s.val_W & s.stats_en_wen_pending_W

      # ostall due to proc2mngr

      s.ostall_W.value      = s.val_W & s.proc2mngr_val_W & ~s.proc2mngr_rdy

      # stall in W stage

      s.stall_W.value       = s.val_W & s.ostall_W

      # set proc2mngr val if not stalling

      s.proc2mngr_val.value = s.val_W & ~s.stall_W & s.proc2mngr_val_W

      s.commit_inst.value   = s.val_W
