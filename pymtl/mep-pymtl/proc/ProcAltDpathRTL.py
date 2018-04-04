#=========================================================================
# ProcAltDpathPRTL.py
#=========================================================================

import os,sys,inspect
currentdir = os.path.dirname( os.path.abspath(inspect.getfile(inspect.currentframe())) )
parentdir  = os.path.dirname( currentdir )

sys.path.insert(0, parentdir)

from pymtl      import *
from pclib.rtl  import RegisterFile, Mux, RegEnRst, RegEn, arith
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemReqMsg4B, MemRespMsg4B

from ProcDpathComponentsRTL import BranchTargetCalcRTL, AluRTL, JumpTargetCalcRTL

from imul       import IntMulAltRTL

#-------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------

c_reset_vector = 0x0000
c_reset_inst   = 0

OP    = slice( 26, 32 )
RS    = slice( 21, 26 )
RT    = slice( 16, 21 )
RD    = slice( 11, 16 )
SHAMT = slice(  6, 11 )
FUNC  = slice(  0,  6 )
IMM   = slice(  0, 16 )
TGT   = slice(  0, 26 )

#-------------------------------------------------------------------------
# ProcBaseDpathPRTL
#-------------------------------------------------------------------------

class ProcAltDpathRTL( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # imem ports

    s.imemreq_msg       = OutPort( MemReqMsg4B )
    s.imemresp_msg_data = InPort ( 32 )

    # dmem ports

    s.dmemreq_msg_addr  = OutPort( 32 )
    s.dmemreq_msg_data  = OutPort( 32 )

    s.dmemresp_msg_data = InPort ( 32 )

    # xcel ports
    # TODO (jls): figure out how to use xcel_id to handle multiple xcel
    s.xcelreq_msg_reg   = OutPort( 5 )
    s.xcelreq_msg_data  = OutPort( 32 )

    s.xcelresp_msg_data = InPort ( 32 )

    # mngr ports

    s.mngr2proc_data    = InPort ( 32 )
    s.proc2mngr_data    = OutPort( 32 )

    # Control signals (ctrl->dpath)

    s.reg_en_F          = InPort ( 1 )
    s.pc_sel_F          = InPort ( 2 )

    s.reg_en_D          = InPort ( 1 )
    s.op0_sel_D         = InPort ( 2 )
    s.op1_sel_D         = InPort ( 3 )
    s.op0_byp_sel_D     = InPort ( 2 )
    s.op1_byp_sel_D     = InPort ( 2 )

    s.reg_en_X          = InPort ( 1 )
    s.alu_fn_X          = InPort ( 4 )
    s.ex_result_sel_X   = InPort ( 1 )

    s.reg_en_M          = InPort ( 1 )
    s.wb_result_sel_M   = InPort ( 2 )

    s.reg_en_W          = InPort ( 1 )
    s.rf_waddr_W        = InPort ( 5 )
    s.rf_wen_W          = InPort ( 1 )
    s.stats_en_wen_W    = InPort ( 1 )

    # imul

    s.mul_req_val_D     = InPort ( 1 )
    s.mul_req_rdy_D     = OutPort( 1 )

    s.mul_resp_val_X    = OutPort( 1 )
    s.mul_resp_rdy_X    = InPort ( 1 )

    # Status signals (dpath->Ctrl)

    s.inst_D            = OutPort( 32 )
    s.br_cond_eq_X      = OutPort( 1 )
    s.br_cond_neg_X     = OutPort( 1 )
    s.br_cond_zero_X    = OutPort( 1 )

    # stats_en output

    s.stats_en          = OutPort( 1 )

    #---------------------------------------------------------------------
    # F stage
    #---------------------------------------------------------------------

    s.pc_F        = Wire( 32 )
    s.pc_plus4_F  = Wire( 32 )

    s.pc_incr_F = m = arith.Incrementer( nbits = 32, increment_amount = 4 )

    s.connect_pairs(
      m.in_, s.pc_F,
      m.out, s.pc_plus4_F
    )

    # forward delaration for branch and jump target

    s.br_target_X = Wire( 32 )
    s.j_target_D  = Wire( 32 )
    s.jr_target_D = Wire( 32 )

    # PC sel mux

    s.pc_sel_mux_F = m = Mux( dtype = 32, nports = 4 )

    s.connect_pairs(
      m.in_[0],  s.pc_plus4_F,
      m.in_[1],  s.br_target_X,
      m.in_[2],  s.j_target_D,
      m.in_[3],  s.jr_target_D,
      m.sel,     s.pc_sel_F
    )

    @s.combinational
    def imem_req_F():
      s.imemreq_msg.type_.value   = 0
      s.imemreq_msg.len.value     = 0
      s.imemreq_msg.addr.value    = s.pc_sel_mux_F.out
      s.imemreq_msg.data.value    = 0
      s.imemreq_msg.opaque.value  = 0

    s.pc_reg_F = m = RegEnRst( dtype = 32, reset_value = c_reset_vector - 4 )

    s.connect_pairs(
      m.en,  s.reg_en_F,
      m.in_, s.pc_sel_mux_F.out,
      m.out, s.pc_F
    )

    #---------------------------------------------------------------------
    # D stage
    #---------------------------------------------------------------------

    s.pc_plus4_reg_D = m = RegEnRst( dtype = 32 )

    s.connect_pairs(
      m.en,  s.reg_en_D,
      m.in_, s.pc_plus4_F,
    )

    s.inst_D_reg = m = RegEnRst( dtype = 32, reset_value = c_reset_inst )

    s.connect_pairs(
      m.en,  s.reg_en_D,
      m.in_, s.imemresp_msg_data,
      m.out, s.inst_D
    )

    # sext unit

    s.imm_sext_D = m = arith.SignExtender( in_nbits = 16, out_nbits = 32 )

    s.connect( m.in_, s.inst_D[ IMM ] )

    # zext unit

    s.imm_zext_D = m = arith.ZeroExtender( in_nbits = 16, out_nbits = 32 )

    s.connect( m.in_, s.inst_D[ IMM ] )

    # zext unit

    s.shamt_zext_D = m = arith.ZeroExtender( in_nbits = 5, out_nbits = 32 )

    s.connect( m.in_, s.inst_D[ SHAMT ] )

    # zext unit

    s.rs_padded_D = m = arith.ZeroExtender( in_nbits = 5, out_nbits = 32 )

    s.connect( m.in_, s.inst_D[ RS ] )


    # branch target unit

    s.br_target_calc_D = m = BranchTargetCalcRTL()

    s.connect_pairs(
      m.pc_plus4, s.pc_plus4_reg_D.out,
      m.imm_sext, s.imm_sext_D.out,
    )

    # jump target unit

    s.j_target_clac_D = m = JumpTargetCalcRTL()

    s.connect_pairs(
      m.pc_plus4,   s.pc_plus4_reg_D.out,
      m.imm_target, s.inst_D[ TGT ],
      m.j_target,   s.j_target_D
    )

    # Register File

    s.rf_rdata0_D = Wire( 32 )
    s.rf_rdata1_D = Wire( 32 )

    s.rf_wdata_W  = Wire( 32 )

    s.rf = m = RegisterFile( dtype = 32, nregs = 32, rd_ports = 2, const_zero = True )

    s.connect_pairs(
      m.rd_addr[0], s.inst_D[ RS ],
      m.rd_addr[1], s.inst_D[ RT ],

      m.rd_data[0], s.rf_rdata0_D,
      m.rd_data[1], s.rf_rdata1_D,

      m.wr_en,      s.rf_wen_W,
      m.wr_addr,    s.rf_waddr_W,
      m.wr_data,    s.rf_wdata_W
    )

    # op0 bypass mux

    s.byp_data_X = Wire( 32 )
    s.byp_data_M = Wire( 32 )
    s.byp_data_W = Wire( 32 )

    s.op0_byp_mux_D = m = Mux( dtype = 32, nports = 4 )

    s.connect_pairs(
      m.in_[0],   s.rf_rdata0_D,
      m.in_[1],   s.byp_data_X,
      m.in_[2],   s.byp_data_M,
      m.in_[3],   s.byp_data_W,
      m.sel,      s.op0_byp_sel_D
    )

    # connect RF_data_0 to jr target

    s.connect( s.op0_byp_mux_D.out, s.jr_target_D )

    # op0 sel mux

    s.op0_sel_mux_D = m = Mux( dtype = 32, nports = 4 )

    s.connect_pairs(
      m.in_[0], s.op0_byp_mux_D.out,
      m.in_[1], s.shamt_zext_D.out,
      m.in_[2], 16,                 # constant 16
      m.in_[3], s.rs_padded_D.out,  # for mtx and mfx
      m.sel,    s.op0_sel_D
    )

    # op1 bypass mux

    s.op1_byp_mux_D = m = Mux( dtype = 32, nports = 4 )

    s.connect_pairs(
      m.in_[0],   s.rf_rdata1_D,
      m.in_[1],   s.byp_data_X,
      m.in_[2],   s.byp_data_M,
      m.in_[3],   s.byp_data_W,
      m.sel,      s.op1_byp_sel_D
    )

    # op1 sel mux

    s.op1_sel_mux_D = m = Mux( dtype = 32, nports = 5 )

    s.connect_pairs(
      m.in_[0], s.op1_byp_mux_D.out,
      m.in_[1], s.imm_sext_D.out,
      m.in_[2], s.imm_zext_D.out,
      m.in_[3], s.pc_plus4_reg_D.out,
      m.in_[4], s.mngr2proc_data,
      m.sel,    s.op1_sel_D,
    )

    # imul

    s.mul_req_msg_D  = Wire( 64 )
    s.mul_resp_msg_X = Wire( 32 )

    s.imul = m = IntMulAltRTL()

    s.connect_pairs(
      m.req.val, s.mul_req_val_D,
      m.req.rdy, s.mul_req_rdy_D,
      m.req.msg[ 32:64 ], s.op0_sel_mux_D.out,
      m.req.msg[  0:32 ], s.op1_sel_mux_D.out,

      m.resp.val, s.mul_resp_val_X,
      m.resp.rdy, s.mul_resp_rdy_X,
      m.resp.msg, s.mul_resp_msg_X,
    )

    #---------------------------------------------------------------------
    # X stage
    #---------------------------------------------------------------------

    s.br_target_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.br_target_calc_D.br_target,
      m.out, s.br_target_X
    )

    s.op0_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op0_sel_mux_D.out,
    )

    s.op1_reg_X = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op1_sel_mux_D.out,
    )

    s.dmem_wdata_reg_X = m =  RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_X,
      m.in_, s.op1_byp_mux_D.out,
    )

    # ALU

    s.alu_X = m = AluRTL()

    s.connect_pairs(
      m.in0,      s.op0_reg_X.out,
      m.in1,      s.op1_reg_X.out,
      m.fn,       s.alu_fn_X,
      m.ops_eq,   s.br_cond_eq_X,
      m.op0_zero, s.br_cond_zero_X,
      m.op0_neg,  s.br_cond_neg_X
    )

    # dmemreq address and data

    s.connect( s.dmemreq_msg_addr, s.alu_X.out )
    s.connect( s.dmemreq_msg_data, s.dmem_wdata_reg_X.out )

    # xcelreq id and data

    s.connect( s.xcelreq_msg_reg,  s.op0_reg_X.out[slice(0,5)] )
    s.connect( s.xcelreq_msg_data, s.op1_reg_X.out )

    # mux

    s.ex_result_sel_mux_X = m = Mux( dtype = 32, nports = 2 )

    s.connect_pairs(
      m.in_[0], s.alu_X.out,
      m.in_[1], s.mul_resp_msg_X,
      m.sel,    s.ex_result_sel_X
    )

    s.connect( s.ex_result_sel_mux_X.out, s.byp_data_X )

    #---------------------------------------------------------------------
    # M stage
    #---------------------------------------------------------------------

    s.ex_result_reg_M = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_M,
      m.in_, s.ex_result_sel_mux_X.out,
    )

    s.wb_result_sel_mux_M = m = Mux( dtype = 32, nports = 3 )

    s.connect_pairs(
      m.in_[0], s.ex_result_reg_M.out,
      m.in_[1], s.dmemresp_msg_data,
      m.in_[2], s.xcelresp_msg_data,
      m.sel,    s.wb_result_sel_M
    )

    s.connect( s.wb_result_sel_mux_M.out, s.byp_data_M )

    #---------------------------------------------------------------------
    # W stage
    #---------------------------------------------------------------------

    s.wb_result_reg_W = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.reg_en_W,
      m.in_, s.wb_result_sel_mux_M.out,
    )

    s.connect( s.proc2mngr_data, s.wb_result_reg_W.out )

    s.connect( s.rf_wdata_W, s.wb_result_reg_W.out )

    s.connect( s.wb_result_reg_W.out, s.byp_data_W )

    s.stats_en_reg_W = m = RegEnRst( dtype = 32, reset_value = 0 )

    s.connect_pairs(
      m.en,  s.stats_en_wen_W,
      m.in_, s.wb_result_reg_W.out,
    )

    @s.combinational
    def stats_en_logic_W():
      s.stats_en.value = reduce_or( s.stats_en_reg_W.out ) # reduction with bitwise OR
