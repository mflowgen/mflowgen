#=========================================================================
# tinyrv2_semantics
#=========================================================================
# This class defines the semantics for each instruction in the RISC-V
# teaching grade instruction set.
#
# Author : Christopher Batten, Moyang Wang, Shunning Jiang
# Date   : Aug 29, 2016

from pymtl            import Bits,concat
from pymtl.datatypes  import helpers
from tinyrv2_encoding import TinyRV2Inst

from XcelMsg import XcelReqMsg, XcelRespMsg

#-------------------------------------------------------------------------
# Syntax Helpers
#-------------------------------------------------------------------------

def sext( bits ):
  return helpers.sext( bits, 32 )

def zext( bits ):
  return helpers.zext( bits, 32 )

class TinyRV2Semantics (object):

  #-----------------------------------------------------------------------
  # IllegalInstruction
  #-----------------------------------------------------------------------

  class IllegalInstruction (Exception):
    pass

  #-----------------------------------------------------------------------
  # RegisterFile
  #-----------------------------------------------------------------------

  class RegisterFile (object):

    def __init__( self ):

      self.regs = [ Bits(32,0) for i in xrange(32) ]

      self.trace_str  = ""
      self.trace_regs = False
      self.src0 = ""
      self.src1 = ""
      self.dest = ""

    def __getitem__( self, idx ):
      if self.trace_regs:
        if self.src0 == "":
          self.src0 = "X[{:2d}]={:0>8}".format( int(idx), self.regs[idx] )
        else:
          self.src1 = "X[{:2d}]={:0>8}".format( int(idx), self.regs[idx] )

      return self.regs[idx]

    def __setitem__( self, idx, value ):

      trunc_value = Bits( 32, value, trunc=True )

      if self.trace_regs:
        self.dest = "X[{:2d}]={:0>8}".format( int(idx), trunc_value )

      if idx != 0:
        self.regs[idx] = trunc_value

    def trace_regs_str( self ):
      self.trace_str = "{:14} {:14} {:14}".format( self.dest, self.src0, self.src1 )
      self.src0 = ""
      self.src1 = ""
      self.dest = ""
      return self.trace_str

  #-----------------------------------------------------------------------
  # Constructor
  #-----------------------------------------------------------------------

  def __init__( self, memory,
                mngr2proc_queue, proc2mngr_queue,
                xcelreq_queue, xcelresp_queue,
                num_cores=1 ):

    self.R = TinyRV2Semantics.RegisterFile()
    self.M = memory

    self.mngr2proc_queue = mngr2proc_queue
    self.proc2mngr_queue = proc2mngr_queue
    self.xcelreq_queue   = xcelreq_queue
    self.xcelresp_queue  = xcelresp_queue

    self.numcores = num_cores
    self.coreid   = -1

    # Only support RISC-V 32-bit ISA
    self.xlen = 32

    self.reset()

  #-----------------------------------------------------------------------
  # reset
  #-----------------------------------------------------------------------

  def reset( s ):

    s.PC = Bits( 32, 0x00000200 )
    s.stats_en = False
    s.coreid   = -1

  #-----------------------------------------------------------------------
  # Basic Instructions
  #-----------------------------------------------------------------------

  def execute_nop( s, inst ):
    s.PC += 4

  #-----------------------------------------------------------------------
  # Register-register arithmetic, logical, and comparison instructions
  #-----------------------------------------------------------------------

  def execute_add( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] + s.R[inst.rs2]
    s.PC += 4

  def execute_sub( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] - s.R[inst.rs2]
    s.PC += 4

  def execute_sll( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] << (s.R[inst.rs2].uint() & 0x1F)
    s.PC += 4

  def execute_slt( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1].int() < s.R[inst.rs2].int()
    s.PC += 4

  def execute_sltu( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] < s.R[inst.rs2]
    s.PC += 4

  def execute_xor( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] ^ s.R[inst.rs2]
    s.PC += 4

  def execute_srl( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] >> (s.R[inst.rs2].uint() & 0x1F)
    s.PC += 4

  def execute_sra( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1].int() >> (s.R[inst.rs2].uint() & 0x1F)
    s.PC += 4

  def execute_or( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] | s.R[inst.rs2]
    s.PC += 4

  def execute_and( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] & s.R[inst.rs2]
    s.PC += 4

  #-----------------------------------------------------------------------
  # Register-immediate arithmetic, logical, and comparison instructions
  #-----------------------------------------------------------------------

  def execute_addi( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] + sext(inst.i_imm)
    s.PC += 4

  def execute_slti( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1].int() < inst.i_imm.int()
    s.PC += 4

  def execute_sltiu( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] < sext(inst.i_imm)
    s.PC += 4

  def execute_xori( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] ^ sext(inst.i_imm)
    s.PC += 4

  def execute_ori( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] | sext(inst.i_imm)
    s.PC += 4

  def execute_andi( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] & sext(inst.i_imm)
    s.PC += 4

  def execute_slli( s, inst ):
    # does not have exception, just assert here
    s.R[inst.rd] = s.R[inst.rs1] << inst.shamt
    s.PC += 4

  def execute_srli( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1] >> inst.shamt
    s.PC += 4

  def execute_srai( s, inst ):
    s.R[inst.rd] = s.R[inst.rs1].int() >> inst.shamt.uint()
    s.PC += 4

  #-----------------------------------------------------------------------
  # Other instructions
  #-----------------------------------------------------------------------

  def execute_lui( s, inst ):
    s.R[inst.rd] = inst.u_imm
    s.PC += 4

  def execute_auipc( s, inst ):
    s.R[inst.rd] = inst.u_imm + s.PC
    s.PC += 4

  #-----------------------------------------------------------------------
  # Load/store instructions
  #-----------------------------------------------------------------------

  def execute_lb( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = sext(s.M[addr:addr+1])
    s.PC += 4

  def execute_lh( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = sext(s.M[addr:addr+2])
    s.PC += 4

  def execute_lw( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = s.M[addr:addr+4]
    s.PC += 4

  def execute_lbu( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = zext(s.M[addr:addr+1])
    s.PC += 4

  def execute_lhu( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = zext(s.M[addr:addr+2])
    s.PC += 4

  def execute_sb( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.s_imm)
    s.M[addr] = s.R[inst.rs2][0:8]
    s.PC += 4

  def execute_sh( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.s_imm)
    s.M[addr:addr+2] = s.R[inst.rs2][0:16]
    s.PC += 4

  def execute_sw( s, inst ):
    addr = s.R[inst.rs1] + sext(inst.s_imm)
    s.M[addr:addr+4] = s.R[inst.rs2]
    s.PC += 4

  #-----------------------------------------------------------------------
  # Unconditional jump instructions
  #-----------------------------------------------------------------------

  def execute_jal( s, inst ):
    s.R[inst.rd] = s.PC + 4
    s.PC = s.PC + sext(inst.j_imm)

  def execute_jalr( s, inst ):
    temp = s.R[inst.rs1] + sext(inst.i_imm)
    s.R[inst.rd] = s.PC + 4
    s.PC = temp & 0xFFFFFFFE

  #-----------------------------------------------------------------------
  # Conditional branch instructions
  #-----------------------------------------------------------------------

  def execute_beq( s, inst ):
    if s.R[inst.rs1] == s.R[inst.rs2]:
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  def execute_bne( s, inst ):
    if s.R[inst.rs1] != s.R[inst.rs2]:
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  def execute_blt( s, inst ):
    if s.R[inst.rs1].int() < s.R[inst.rs2].int():
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  def execute_bge( s, inst ):
    if s.R[inst.rs1].int() >= s.R[inst.rs2].int():
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  def execute_bltu( s, inst ):
    if s.R[inst.rs1] < s.R[inst.rs2]:
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  def execute_bgeu( s, inst ):
    if s.R[inst.rs1] >= s.R[inst.rs2]:
      s.PC = s.PC + sext(inst.b_imm)
    else:
      s.PC += 4

  #-----------------------------------------------------------------------
  # RV32M instructions
  #-----------------------------------------------------------------------

  def execute_mul( s, inst ):
    s.R[ inst.rd ] = s.R[inst.rs1] * s.R[inst.rs2]
    s.PC += 4

  def execute_mulh( s, inst ):
    s.R[ inst.rd ] = (helpers.sext( s.R[inst.rs1], 64 ) * helpers.sext( s.R[inst.rs2], 64 ))[32:64]
    s.PC += 4

  def execute_mulhsu( s, inst ):
    s.R[ inst.rd ] = (helpers.sext( s.R[inst.rs1], 64 ) * helpers.zext( s.R[inst.rs2], 64 ))[32:64]
    s.PC += 4

  def execute_mulhu( s, inst ):
    s.R[ inst.rd ] = (helpers.zext( s.R[inst.rs1], 64 ) * helpers.zext( s.R[inst.rs2], 64 ))[32:64]
    s.PC += 4

  def execute_div( s, inst ):
    a, b = s.R[inst.rs1].int(), s.R[inst.rs2].int()
    if b == 0:
      s.R[ inst.rd ] = Bits( 32, -1 )
    else:
      res = abs(a) / abs(b)
      if (a<0) ^ (b<0): res = -res 
      s.R[ inst.rd ] = Bits( 32, res )

    s.PC += 4

  def execute_divu( s, inst ):
    a, b = s.R[inst.rs1].uint(), s.R[inst.rs2].uint()
    if b == 0:
      s.R[ inst.rd ] = Bits( 32, -1 )
    else:
      s.R[ inst.rd ] = Bits( 32, a/b )

    s.PC += 4

  def execute_rem( s, inst ):
    a, b = s.R[inst.rs1].int(), s.R[inst.rs2].int()
    if b == 0:
      s.R[ inst.rd ] = Bits( 32, a )
    else:
      res = abs(a) % abs(b)
      if a<0: res = -res
      s.R[ inst.rd ] = Bits( 32, res )

    s.PC += 4

  def execute_remu( s, inst ):
    a, b = s.R[inst.rs1].uint(), s.R[inst.rs2].uint()
    if b == 0:
      s.R[ inst.rd ] = Bits( 32, a )
    else:
      s.R[ inst.rd ] = Bits( 32, a%b )

    s.PC += 4

  #-----------------------------------------------------------------------
  # AMO instructions
  #-----------------------------------------------------------------------

  def execute_amoswap( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = s.R[inst.rs2]
    s.PC += 4

  def execute_amoadd( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data + s.R[inst.rs2]
    s.PC += 4

  def execute_amoxor( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data ^ s.R[inst.rs2]
    s.PC += 4

  def execute_amoor( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data | s.R[inst.rs2]
    s.PC += 4

  def execute_amoand( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data & s.R[inst.rs2]
    s.PC += 4

  def execute_amomin( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data if   read_data.int() < s.R[inst.rs2].int() \
                                 else s.R[inst.rs2]
    s.PC += 4

  def execute_amominu( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = min( read_data, s.R[inst.rs2] )
    s.PC += 4

  def execute_amomax( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = read_data if   read_data.int() > s.R[inst.rs2].int() \
                                 else s.R[inst.rs2]
    s.PC += 4

  def execute_amomaxu( s, inst ):
    addr = s.R[inst.rs1]
    read_data = s.M[addr:addr+4]
    s.R[inst.rd] = read_data
    s.M[addr:addr+4] = max( read_data, s.R[inst.rs2] )
    s.PC += 4

  # Fence

  def execute_fence( s, inst ):
    s.PC += 4

  def execute_fencei( s, inst ):
    s.PC += 4
  #-----------------------------------------------------------------------
  # CSR instructions
  #-----------------------------------------------------------------------

  def execute_csrr( s, inst ):

    # CSR: mngr2proc
    # for mngr2proc just ignore the rs1 and do _not_ write to CSR at all.
    # this is the same as setting rs1 = x0.

    if   inst.csrnum == 0xFC0:
      bits = s.mngr2proc_queue.popleft()
      s.mngr2proc_str = str(bits)
      s.R[inst.rd] = bits

    # CSR: numcores
    elif inst.csrnum == 0xFC1:
      s.R[inst.rd] = s.numcores

    # CSR: coreid
    elif inst.csrnum == 0xF14:
      s.R[inst.rd] = s.coreid

    # CSR: xcel regs
    elif inst.csrnum >= 0x7E0 and inst.csrnum <= 0x7FF:
      reqmsg = XcelReqMsg()
      reqmsg.type_ = XcelReqMsg.TYPE_READ
      reqmsg.raddr = inst.csrnum[0:5]
      reqmsg.data  = 0
      s.xcelreq_queue.append( reqmsg )

      respmsg = s.xcelresp_queue.popleft()
      s.R[inst.rd] = respmsg.data

    else:
      raise TinyRV2Semantics.IllegalInstruction(
        "Unrecognized CSR register ({}) for csrr at PC={}" \
          .format(inst.csrnum.uint(),s.PC) )

    s.PC += 4

  def execute_csrw( s, inst ):

    # CSR: proc2mngr
    # for proc2mngr we ignore the rd and do _not_ write old value to rd.
    # this is the same as setting rd = x0.

    if   inst.csrnum == 0x7C0:
      bits = s.R[inst.rs1]
      s.proc2mngr_str = str(bits)
      s.proc2mngr_queue.append( bits )

    # CSR: stats_en

    elif inst.csrnum == 0x7C1:
      s.stats_en = bool( s.R[inst.rs1] )

    elif inst.csrnum >= 0x7E0 and inst.csrnum <= 0x7FF:
      reqmsg = XcelReqMsg()
      reqmsg.type_ = XcelReqMsg.TYPE_WRITE
      reqmsg.raddr = inst.csrnum[0:5]
      reqmsg.data  = s.R[inst.rs1]
      s.xcelreq_queue.append( reqmsg )

      respmsg = s.xcelresp_queue.popleft()
      # discard resp msg

    else:
      raise TinyRV2Semantics.IllegalInstruction(
        "Unrecognized CSR register ({}) for csrw at PC={}" \
          .format(inst.csrnum.uint(),s.PC) )

    s.PC += 4

  def execute_dumb( s, inst ):
    pass

  #-----------------------------------------------------------------------
  # exec
  #-----------------------------------------------------------------------

  execute_dispatch = {

  # Listed in the order of the lecture handout
  # 1.3 Tiny Risc-V Instruction Set Architecture

    'nop'     : execute_nop,

    'add'     : execute_add,
    'addi'    : execute_addi,
    'sub'     : execute_sub,
    'and'     : execute_and,
    'andi'    : execute_andi,
    'or'      : execute_or,
    'ori'     : execute_ori,
    'xor'     : execute_xor,
    'xori'    : execute_xori,

    'slt'     : execute_slt,
    'slti'    : execute_slti,
    'sltu'    : execute_sltu,
    'sltiu'   : execute_sltiu,

    'sra'     : execute_sra,
    'srai'    : execute_srai,
    'srl'     : execute_srl,
    'srli'    : execute_srli,
    'sll'     : execute_sll,
    'slli'    : execute_slli,

    'lui'     : execute_lui,
    'auipc'   : execute_auipc,
    'lb'      : execute_lb,
    'lh'      : execute_lh,
    'lw'      : execute_lw,
    'lbu'     : execute_lbu,
    'lhu'     : execute_lhu,
    'sb'      : execute_sb,
    'sh'      : execute_sh,
    'sw'      : execute_sw,

    'jal'     : execute_jal,
    'jalr'    : execute_jalr,
    'beq'     : execute_beq,
    'bne'     : execute_bne,
    'blt'     : execute_blt,
    'bge'     : execute_bge,
    'bltu'    : execute_bltu,
    'bgeu'    : execute_bgeu,

    'mul'     : execute_mul,
    'mulh'    : execute_mulh,
    'mulhsu'  : execute_mulhsu,
    'mulhu'   : execute_mulhu,
    'div'     : execute_div,
    'divu'    : execute_divu,
    'rem'     : execute_rem,
    'remu'    : execute_remu,

    'amoswap' : execute_amoswap,
    'amoadd'  : execute_amoadd,
    'amoxor'  : execute_amoxor,
    'amoor'   : execute_amoor,
    'amoand'  : execute_amoand,
    'amomin'  : execute_amomin,
    'amomax'  : execute_amomax,
    'amominu' : execute_amominu,
    'amomaxu' : execute_amomaxu,

    'fence'   : execute_fence,
    'fence.i' : execute_fencei,

    'csrr'    : execute_csrr,
    'csrw'    : execute_csrw,

    ' '       : execute_dumb # this is for all-zero

  }

  def execute( self, inst ):
    self.execute_dispatch[inst.name]( self, inst )

