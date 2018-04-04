#=========================================================================
# parc_semantics
#=========================================================================
# This class defines the semantics for each instruction in the PARCv2
# instruction set.
#
# Author : Christopher Batten
# Date   : May 22, 2014

from pymtl            import Bits,concat
from pymtl.datatypes  import helpers
from parc_encoding    import ParcInst

from xcel.XcelMsg  import XcelReqMsg, XcelRespMsg

#-------------------------------------------------------------------------
# Syntax Helpers
#-------------------------------------------------------------------------

def sext( bits ):
  return helpers.sext( bits, 32 )

def zext( bits ):
  return helpers.zext( bits, 32 )

class ParcSemantics (object):

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
          self.src0 = "R[{:2d}]={:0>8}".format( int(idx), self.regs[idx] )
        else:
          self.src1 = "R[{:2d}]={:0>8}".format( int(idx), self.regs[idx] )

      return self.regs[idx]

    def __setitem__( self, idx, value ):

      trunc_value = Bits( 32, value, trunc=True )

      if self.trace_regs:
        self.dest = "R[{:2d}]={:0>8}".format( int(idx), trunc_value )

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
                xcelreq_queue,   xcelresp_queue ):

    self.R = ParcSemantics.RegisterFile()
    self.M = memory

    self.mngr2proc_queue = mngr2proc_queue
    self.proc2mngr_queue = proc2mngr_queue

    self.xcelreq_queue   = xcelreq_queue
    self.xcelresp_queue  = xcelresp_queue

    self.reset()

  #-----------------------------------------------------------------------
  # reset
  #-----------------------------------------------------------------------

  def reset( s ):

    s.PC = Bits( 32, 0x00000000 )
    s.stats_en = False

  #-----------------------------------------------------------------------
  # Basic Instructions
  #-----------------------------------------------------------------------

  def execute_mfc0( s, inst ):

    # CP0 register: mngr2proc
    if inst.rd == 1:
      bits = s.mngr2proc_queue.popleft()
      s.mngr2proc_str = str(bits)
      s.R[inst.rt] = bits

    # CPO register: numcores
    elif inst.rd == 16:
      s.R[inst.rt] = 1

    # CPO register: coreid
    elif inst.rd == 17:
      s.R[inst.rt] = 0

    else:
      raise ParcSemantics.IllegalInstruction(
        "Unrecognized CPO register ({}) for mfc0 at PC={}" \
          .format(inst.rd.uint(),s.PC) )

    s.PC += 4

  def execute_mtc0( s, inst ):

    # CP0 register: proc2mngr
    if inst.rd == 2:
      bits = s.R[inst.rt]
      s.proc2mngr_str = str(bits)
      s.proc2mngr_queue.append( bits )

    # CPO register: stats_en
    elif inst.rd == 21:
      s.stats_en = bool(s.R[inst.rt])

    else:
      raise ParcSemantics.IllegalInstruction(
        "Unrecognized CPO register ({}) for mtc0 at PC={}" \
          .format(inst.rd.uint(),s.PC) )

    s.PC += 4

  def execute_nop( s, inst ):
    s.PC += 4

  #-----------------------------------------------------------------------
  # Register-register arithmetic, logical, and comparison instructions
  #-----------------------------------------------------------------------

  def execute_addu( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] + s.R[inst.rt]
    s.PC += 4

  def execute_subu( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] - s.R[inst.rt]
    s.PC += 4

  def execute_and( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] & s.R[inst.rt]
    s.PC += 4

  def execute_or( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] | s.R[inst.rt]
    s.PC += 4

  def execute_xor( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] ^ s.R[inst.rt]
    s.PC += 4

  def execute_nor( s, inst ):
    s.R[inst.rd] = ~( s.R[inst.rs] | s.R[inst.rt] )
    s.PC += 4

  def execute_slt( s, inst ):
    s.R[inst.rd] = s.R[inst.rs].int() < s.R[inst.rt].int()
    s.PC += 4

  def execute_sltu( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] < s.R[inst.rt]
    s.PC += 4

  #-----------------------------------------------------------------------
  # Register-immediate arithmetic, logical, and comparison instructions
  #-----------------------------------------------------------------------

  def execute_addiu( s, inst ):
    s.R[inst.rt] = s.R[inst.rs] + sext(inst.imm)
    s.PC += 4

  def execute_andi( s, inst ):
    s.R[inst.rt] = s.R[inst.rs] & zext(inst.imm)
    s.PC += 4

  def execute_ori( s, inst ):
    s.R[inst.rt] = s.R[inst.rs] | zext(inst.imm)
    s.PC += 4

  def execute_xori( s, inst ):
    s.R[inst.rt] = s.R[inst.rs] ^ zext(inst.imm)
    s.PC += 4

  def execute_slti( s, inst ):
    s.R[inst.rt] = s.R[inst.rs].int() < sext(inst.imm).int()
    s.PC += 4

  def execute_sltiu( s, inst ):
    s.R[inst.rt] = s.R[inst.rs] < sext(inst.imm)
    s.PC += 4

  #-----------------------------------------------------------------------
  # Shift instructions
  #-----------------------------------------------------------------------

  def execute_sll( s, inst ):
    s.R[inst.rd] = s.R[inst.rt] << inst.shamt
    s.PC += 4

  def execute_srl( s, inst ):
    s.R[inst.rd] = s.R[inst.rt] >> inst.shamt
    s.PC += 4

  def execute_sra( s, inst ):
    s.R[inst.rd] = s.R[inst.rt].int() >> inst.shamt.uint()
    s.PC += 4

  def execute_sllv( s, inst ):
    s.R[inst.rd] = s.R[inst.rt] << s.R[inst.rs][0:5]
    s.PC += 4

  def execute_srlv( s, inst ):
    s.R[inst.rd] = s.R[inst.rt] >> s.R[inst.rs][0:5]
    s.PC += 4

  def execute_srav( s, inst ):
    s.R[inst.rd] = s.R[inst.rt].int() >> s.R[inst.rs][0:5].uint()
    s.PC += 4

  #-----------------------------------------------------------------------
  # Other instructions
  #-----------------------------------------------------------------------

  def execute_lui( s, inst ):
    s.R[inst.rt] = zext(inst.imm) << 16
    s.PC += 4

  #-----------------------------------------------------------------------
  # Multiply instruction
  #-----------------------------------------------------------------------

  def execute_mul( s, inst ):
    s.R[inst.rd] = s.R[inst.rs] * s.R[inst.rt]
    s.PC += 4

  #-----------------------------------------------------------------------
  # Load/store instructions
  #-----------------------------------------------------------------------

  def execute_lw( s, inst ):
    addr = s.R[inst.rs] + sext(inst.imm)
    s.R[inst.rt] = s.M[addr:addr+4]
    s.PC += 4

  def execute_sw( s, inst ):
    addr = s.R[inst.rs] + sext(inst.imm)
    s.M[addr:addr+4] = s.R[inst.rt]
    s.PC += 4

  #-----------------------------------------------------------------------
  # Unconditional jump instructions
  #-----------------------------------------------------------------------

  def execute_j( s, inst ):
    s.PC = concat( (s.PC+4)[28:32], inst.jtarg, Bits(2,0) )

  def execute_jal( s, inst ):
    s.R[31] = s.PC + 4
    s.PC = concat( (s.PC+4)[28:32], inst.jtarg, Bits(2,0) )

  def execute_jr( s, inst ):
    s.PC = s.R[inst.rs]

  #-----------------------------------------------------------------------
  # Conditional branch instructions
  #-----------------------------------------------------------------------

  def execute_beq( s, inst ):
    if s.R[inst.rs] == s.R[inst.rt]:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  def execute_bne( s, inst ):
    if s.R[inst.rs] != s.R[inst.rt]:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  def execute_blez( s, inst ):
    if s.R[inst.rs].int() <= 0:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  def execute_bgtz( s, inst ):
    if s.R[inst.rs].int() > 0:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  def execute_bltz( s, inst ):
    if s.R[inst.rs].int() < 0:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  def execute_bgez( s, inst ):
    if s.R[inst.rs].int() >= 0:
      s.PC = s.PC + 4 + ( sext(inst.imm) << 2 )
    else:
      s.PC += 4

  #-----------------------------------------------------------------------
  # Accelerator Instructions
  #-----------------------------------------------------------------------

  def execute_mtx( s, inst ):

    reqmsg        = XcelReqMsg()
    reqmsg.type_  = XcelReqMsg.TYPE_WRITE
    reqmsg.opaque = 0
    reqmsg.raddr  = inst.rs
    reqmsg.data   = s.R[inst.rt]

    s.xcelreq_queue.append( reqmsg )
    s.xcelresp_queue.popleft()

    s.PC += 4

  def execute_mfx( s, inst ):

    reqmsg        = XcelReqMsg()
    reqmsg.type_  = XcelReqMsg.TYPE_READ
    reqmsg.opaque = 0
    reqmsg.raddr  = inst.rs
    reqmsg.data   = 0

    s.xcelreq_queue.append( reqmsg )
    respmsg = s.xcelresp_queue.popleft()

    s.R[inst.rt] = respmsg.data

    s.PC += 4

  #-----------------------------------------------------------------------
  # exec
  #-----------------------------------------------------------------------

  execute_dispatch = {

    'mfc0'  : execute_mfc0,
    'mtc0'  : execute_mtc0,
    'nop'   : execute_nop,

    'addu'  : execute_addu,
    'subu'  : execute_subu,
    'and'   : execute_and,
    'or'    : execute_or,
    'xor'   : execute_xor,
    'nor'   : execute_nor,
    'slt'   : execute_slt,
    'sltu'  : execute_sltu,

    'addiu' : execute_addiu,
    'andi'  : execute_andi,
    'ori'   : execute_ori,
    'xori'  : execute_xori,
    'slti'  : execute_slti,
    'sltiu' : execute_sltiu,

    'sll'   : execute_sll,
    'srl'   : execute_srl,
    'sra'   : execute_sra,
    'sllv'  : execute_sllv,
    'srlv'  : execute_srlv,
    'srav'  : execute_srav,

    'lui'   : execute_lui,

    'mul'   : execute_mul,

    'lw'    : execute_lw,
    'sw'    : execute_sw,

    'j'     : execute_j,
    'jal'   : execute_jal,
    'jr'    : execute_jr,

    'beq'   : execute_beq,
    'bne'   : execute_bne,
    'blez'  : execute_blez,
    'bgtz'  : execute_bgtz,
    'bltz'  : execute_bltz,
    'bgez'  : execute_bgez,

    'mtx'   : execute_mtx,
    'mfx'   : execute_mfx,

  }

  def execute( self, inst ):
    self.execute_dispatch[inst.name]( self, inst )

