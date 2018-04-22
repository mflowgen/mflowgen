#=========================================================================
# ProcDpathPRTL.py
#=========================================================================

from pymtl      import *
from pclib.rtl  import RegisterFile, Mux, RegEnRst, RegEn
from pclib.rtl  import Adder, Incrementer
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from ProcDpathComponentsPRTL import AluPRTL, ImmGenPRTL
from TinyRV2InstPRTL         import OPCODE, RS1, RS2, XS1, XS2, RD, SHAMT

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg4B, MemRespMsg4B

#-------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------

c_reset_vector = 0x200
c_reset_inst   = 0

#-------------------------------------------------------------------------
# ProcDpathPRTL
#-------------------------------------------------------------------------

class ProcDpathPRTL( Model ):

  def __init__( s, num_cores = 1 ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Parameters

    s.core_id = InPort( 32 )

    # imem ports

    s.imemreq_msg       = OutPort( MemReqMsg4B )
    s.imemresp_msg_data = InPort ( 32 )

    # dmem ports

    s.dmemreq_msg_addr  = OutPort( 32 )
    s.dmemreq_msg_data  = OutPort( 32 )
    s.dmemresp_msg_data = InPort ( 32 )

    # mngr ports

    s.mngr2proc_data    = InPort ( 32 )
    s.proc2mngr_data    = OutPort( 32 )

    # xcel ports

    s.xcelreq_msg_data  = OutPort( 32 )
    s.xcelreq_msg_raddr = OutPort( 5 )

    s.xcelresp_msg_data = InPort ( 32 )

    # Control signals (ctrl->dpath)

    s.reg_en_F          = InPort ( 1 )
    s.pc_sel_F          = InPort ( 2 )

    s.reg_en_D          = InPort ( 1 )
    s.op1_byp_sel_D     = InPort ( 2 )
    s.op2_byp_sel_D     = InPort ( 2 )
    s.op1_sel_D         = InPort ( 1 )
    s.op2_sel_D         = InPort ( 2 )
    s.csrr_sel_D        = InPort ( 2 )
    s.imm_type_D        = InPort ( 3 )
    s.mdu_req_opa       = OutPort( 32 )
    s.mdu_req_opb       = OutPort( 32 )

    s.reg_en_X          = InPort ( 1 )
    s.alu_fn_X          = InPort ( 4 )
    s.ex_result_sel_X   = InPort ( 2 )
    s.mdu_resp_msg      = InPort ( 32 )

    s.reg_en_M          = InPort ( 1 )
    s.wb_result_sel_M   = InPort ( 2 )

    s.reg_en_W          = InPort ( 1 )
    s.rf_waddr_W        = InPort ( 5 )
    s.rf_wen_W          = InPort ( 1 )
    s.stats_en_wen_W    = InPort ( 1 )

    # Status signals (dpath->Ctrl)

    s.inst_D            = OutPort( 32 )
    s.br_cond_eq_X      = OutPort( 1 )
    s.br_cond_lt_X      = OutPort( 1 )
    s.br_cond_ltu_X     = OutPort( 1 )

    # stats_en output

    s.stats_en          = OutPort( 1 )

    #---------------------------------------------------------------------
    # F stage
    #---------------------------------------------------------------------

    s.pc_F        = Wire( 32 )
    s.pc_plus4_F  = Wire( 32 )

    # PC+4 incrementer

    s.pc_incr_F = m = Incrementer( nbits = 32, increment_amount = 4 )
    s.connect_pairs(
      m.in_, s.pc_F,
      m.out, s.pc_plus4_F
    )

    # forward delaration for branch target and jal target

    s.br_target_X  = Wire( 32 )
    s.jal_target_D = Wire( 32 )
    s.jalr_target_X = Wire( 32 )

    # PC sel mux

    s.pc_sel_mux_F = m = Mux( dtype = 32, nports = 4 )
    s.connect_pairs(
      m.in_[0],  s.pc_plus4_F,
      m.in_[1],  s.br_target_X,
      m.in_[2],  s.jal_target_D,
      m.in_[3],  s.jalr_target_X,
      m.sel,     s.pc_sel_F
    )

    @s.combinational
    def imem_req_F():
      s.imemreq_msg.addr.value  = s.pc_sel_mux_F.out

    # PC register

    s.pc_reg_F = m = RegEnRst( dtype = 32, reset_value = c_reset_vector - 4 )
    s.connect_pairs(
      m.en,  s.reg_en_F,
      m.in_, s.pc_sel_mux_F.out,
      m.out, s.pc_F
    )

    #---------------------------------------------------------------------
    # D stage
    #---------------------------------------------------------------------

    # PC reg in D stage
    # This value is basically passed from F stage for the corresponding
    # instruction to use, e.g. branch to (PC+imm)

    s.pc_reg_D = m = RegEnRst( dtype = 32 )
    s.connect_pairs(
      m.en,  s.reg_en_D,
      m.in_, s.pc_F,
    )

    # Instruction reg

    s.inst_D_reg = m = RegEnRst( dtype = 32, reset_value = c_reset_inst )
    s.connect_pairs(
      m.en,  s.reg_en_D,
      m.in_, s.imemresp_msg_data,
      m.out, s.inst_D                  # to ctrl
    )

    # Register File
    # The rf_rdata_D wires, albeit redundant in some sense, are used to
    # remind people these data are from D stage.

    s.rf_rdata0_D = Wire( 32 )
    s.rf_rdata1_D = Wire( 32 )

    s.rf_wdata_W  = Wire( 32 )

    s.rf = m = RegisterFile( dtype = 32, nregs = 32, rd_ports = 2, const_zero = True )
    s.connect_pairs(
      m.rd_addr[0], s.inst_D[ RS1 ],
      m.rd_addr[1], s.inst_D[ RS2 ],

      m.rd_data[0], s.rf_rdata0_D,
      m.rd_data[1], s.rf_rdata1_D,

      m.wr_en,      s.rf_wen_W,
      m.wr_addr,    s.rf_waddr_W,
      m.wr_data,    s.rf_wdata_W
    )

    # Immediate generator

    s.imm_gen_D = m = ImmGenPRTL()
    s.connect_pairs(
      m.imm_type, s.imm_type_D,
      m.inst, s.inst_D
    )

    s.byp_data_X = Wire( 32 )
    s.byp_data_M = Wire( 32 )
    s.byp_data_W = Wire( 32 )

    # op1 bypass mux

    s.op1_byp_mux_D = m = Mux( dtype = 32, nports = 4 )
    s.connect_pairs(
      m.in_[0], s.rf_rdata0_D,
      m.in_[1], s.byp_data_X,
      m.in_[2], s.byp_data_M,
      m.in_[3], s.byp_data_W,
      m.sel,    s.op1_byp_sel_D
    )

    # op2 bypass mux

    s.op2_byp_mux_D = m = Mux( dtype = 32, nports = 4 )
    s.connect_pairs(
      m.in_[0], s.rf_rdata1_D,
      m.in_[1], s.byp_data_X,
      m.in_[2], s.byp_data_M,
      m.in_[3], s.byp_data_W,
      m.sel,    s.op2_byp_sel_D
    )

    # op1 sel mux

    s.op1_sel_mux_D = m = Mux( dtype = 32, nports = 2 )
    s.connect_pairs(
      m.in_[0], s.op1_byp_mux_D.out,
      m.in_[1], s.pc_reg_D.out,
      m.sel,    s.op1_sel_D,
    )

    # csrr sel mux

    s.csrr_sel_mux_D = m = Mux( dtype = 32, nports = 3 )
    s.connect_pairs(
      m.in_[0], s.mngr2proc_data,
      m.in_[1], num_cores,
      m.in_[2], s.core_id,
      m.sel,    s.csrr_sel_D,
    )

    # op2 sel mux
    # This mux chooses among RS2, imm, and the output of the above csrr
    # sel mux. Basically we are using two muxes here for pedagogy.

    s.op2_sel_mux_D = m = Mux( dtype = 32, nports = 3 )
    s.connect_pairs(
      m.in_[0], s.op2_byp_mux_D.out,
      m.in_[1], s.imm_gen_D.imm,
      m.in_[2], s.csrr_sel_mux_D.out,
      m.sel,    s.op2_sel_D,
    )

    # send out mdu operands at D stage

    s.connect( s.mdu_req_opa, s.op1_sel_mux_D.out )
    s.connect( s.mdu_req_opb, s.op2_sel_mux_D.out )

    # Risc-V always calcs branch/jal target by adding imm(generated above) to PC

    s.pc_plus_imm_D = m = Adder( 32 )
    s.connect_pairs(
      m.in0, s.pc_reg_D.out,
      m.in1, s.imm_gen_D.imm,
      m.out, s.jal_target_D
    )

    #---------------------------------------------------------------------
    # X stage
    #---------------------------------------------------------------------

    # br_target_reg_X
    # Since branches are resolved in X stage, we register the target,
    # which is already calculated in D stage, to X stage.

    s.br_target_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.pc_plus_imm_D.out,
      m.out, s.br_target_X
    )

    # PC reg in X stage

    s.pc_reg_X = m = RegEnRst( dtype = 32 )
    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.pc_reg_D.out,
    )

    # op1 reg

    s.op1_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op1_sel_mux_D.out,
    )

    # op2 reg

    s.op2_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op2_sel_mux_D.out,
    )

    s.connect( s.xcelreq_msg_raddr, s.op2_reg_X.out[0:5] )

    # dmemreq write data reg
    # Since the op1 is the base address and op2 is the immediate so that
    # we could utilize ALU to do address calculation, we need one more
    # register to hold the R[rs2] we want to store to memory.

    s.dmem_write_data_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op2_byp_mux_D.out # R[rs2]
    )

    s.connect( s.xcelreq_msg_data, s.op1_reg_X.out )

    # ALU

    s.alu_X = m = AluPRTL()
    s.connect_pairs(
      m.in0,     s.op1_reg_X.out,
      m.in1,     s.op2_reg_X.out,
      m.fn,      s.alu_fn_X,
      m.ops_eq,  s.br_cond_eq_X,
      m.ops_lt,  s.br_cond_lt_X,
      m.ops_ltu, s.br_cond_ltu_X,
      m.out,     s.jalr_target_X
    )

    # PC+4 generator

    s.pc_incr_X = m = Incrementer( nbits = 32, increment_amount = 4 )
    s.connect( m.in_, s.pc_reg_X.out )

    # X result sel mux

    s.ex_result_sel_mux_X = m = Mux( dtype = 32, nports = 3 )
    s.connect_pairs(
      m.in_[0], s.alu_X.out,
      m.in_[1], s.mdu_resp_msg,
      m.in_[2], s.pc_incr_X.out,
      m.sel,    s.ex_result_sel_X,
    )

    s.connect( s.ex_result_sel_mux_X.out, s.byp_data_X )

    # dmemreq address & data

    s.connect( s.dmemreq_msg_addr, s.alu_X.out )
    s.connect( s.dmemreq_msg_data, s.dmem_write_data_reg_X.out )

    #---------------------------------------------------------------------
    # M stage
    #---------------------------------------------------------------------

    # Alu execution result reg

    s.ex_result_reg_M = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_M,
      m.in_, s.ex_result_sel_mux_X.out
    )

    # Writeback result selection mux

    s.wb_result_sel_mux_M = m = Mux( dtype = 32, nports = 3 )
    s.connect_pairs(
      m.in_[0], s.ex_result_reg_M.out,
      m.in_[1], s.dmemresp_msg_data,
      # xcel
      m.in_[2], s.xcelresp_msg_data,
      m.sel,    s.wb_result_sel_M
    )

    s.connect( s.wb_result_sel_mux_M.out, s.byp_data_M )

    #---------------------------------------------------------------------
    # W stage
    #---------------------------------------------------------------------

    # Writeback result reg

    s.wb_result_reg_W = m = RegEnRst( dtype = 32, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.reg_en_W,
      m.in_, s.wb_result_sel_mux_M.out,
    )

    s.connect( s.wb_result_reg_W.out, s.byp_data_W )

    s.connect( s.proc2mngr_data, s.wb_result_reg_W.out )

    s.connect( s.rf_wdata_W, s.wb_result_reg_W.out )

    s.stats_en_reg_W = m = RegEnRst( dtype = 32, reset_value = 0 )

    # stats_en logic

    s.connect_pairs(
      m.en,  s.stats_en_wen_W,
      m.in_, s.wb_result_reg_W.out,
    )

    @s.combinational
    def stats_en_logic_W():
      s.stats_en.value = reduce_or( s.stats_en_reg_W.out ) # reduction with bitwise OR

