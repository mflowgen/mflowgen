#========================================================================
# PARC Instruction Type
#========================================================================
# Instruction types are similar to message types but are strictly used
# for communication within a PARC-based processor. Instruction
# "messages" can be unpacked into the various fields as defined by the
# PARC ISA, as well as be constructed from specifying each field
# explicitly. The 32-bit instruction has different fields depending on
# the format of the instruction used. The following are the various
# instruction encoding formats used in the PARC ISA.
#
# R-Type:
#
#   31  26 25  21 20  16 15  11 10   6 5    0
#  +------+------+------+------+------+------+
#  |  op  |  rs  |  rt  |  rd  |  sa  | func |
#  +------+------+------+------+------+------+
#
# I-Type:
#
#   31  26 25  21 20  16 15                 0
#  +------+------+------+--------------------+
#  |  op  |  rs  |  rt  |         imm        |
#  +------+------+------+--------------------+
#
# J-Type:
#
#   31  26 25                               0
#  +------+----------------------------------+
#  |  op  |             target               |
#  +------+----------------------------------+
#
# COP2-Type:
#
#  31   26 25  21 20  16 15  11 10          0
#  +------+------+------+------+-------------+
#  |  op  |  rs  |  rt  |  mt  |    imm      |
#  +------+------+------+------+-------------+
#
# The instruction type also defines a list of instruction encodings in
# the PARC ISA, which are used to decode instructions in the control unit.

from pymtl import *

#-------------------------------------------------------------------------
# co-processor register definition
#-------------------------------------------------------------------------

PISA_CPR_MNGR2PROC = 1
PISA_CPR_PROC2MNGR = 2
PISA_CPR_STATS_EN  = 21
PISA_CPR_NUMCORES  = 16
PISA_CPR_COREID    = 17

#-------------------------------------------------------------------------
# Parc Instruction Fields
#-------------------------------------------------------------------------

OP    = slice( 26, 32 )
RS    = slice( 21, 26 )
RT    = slice( 16, 21 )
RD    = slice( 11, 16 )
SHAMT = slice(  6, 11 )
FUNC  = slice(  0,  6 )
IMM   = slice(  0, 16 )
TGT   = slice(  0, 26 )
ACCID = slice(  0, 11 )
MT    = slice( 11, 16 )

#-------------------------------------------------------------------------
# Parc Instruction Definitions
#-------------------------------------------------------------------------

NOP   =   0   # 0b000000_00000_00000_00000_00000_000000
ADDIU =   1   # 0b001001_?????_?????_?????_?????_??????
ORI   =   2   # 0b001101_?????_?????_?????_?????_??????
LUI   =   3   # 0b001111_00000_?????_?????_?????_??????
ADDU  =   4   # 0b000000_?????_?????_?????_00000_100001
LW    =   5   # 0b100011_?????_?????_?????_?????_??????
SW    =   6   # 0b101011_?????_?????_?????_?????_??????
JAL   =   7   # 0b000011_?????_?????_?????_?????_??????
JR    =   8   # 0b000000_?????_00000_00000_00000_001000
BNE   =   9   # 0b000101_?????_?????_?????_?????_??????
MTC0  =  10   # 0b010000_00100_?????_?????_00000_000000
ANDI  =  11   # 0b001100_?????_?????_?????_?????_??????
XORI  =  12   # 0b001110_?????_?????_?????_?????_??????
SLTI  =  13   # 0b001010_?????_?????_?????_?????_??????
SLTIU =  14   # 0b001011_?????_?????_?????_?????_??????
SLL   =  15   # 0b000000_00000_?????_?????_?????_000000
SRL   =  16   # 0b000000_00000_?????_?????_?????_000010
SRA   =  17   # 0b000000_00000_?????_?????_?????_000011
SLLV  =  18   # 0b000000_?????_?????_?????_00000_000100
SRLV  =  19   # 0b000000_?????_?????_?????_00000_000110
SRAV  =  20   # 0b000000_?????_?????_?????_00000_000111
SUBU  =  21   # 0b000000_?????_?????_?????_00000_100011
AND   =  22   # 0b000000_?????_?????_?????_00000_100100
OR    =  23   # 0b000000_?????_?????_?????_00000_100101
XOR   =  24   # 0b000000_?????_?????_?????_00000_100110
NOR   =  25   # 0b000000_?????_?????_?????_00000_100111
SLT   =  26   # 0b000000_?????_?????_?????_00000_101010
SLTU  =  27   # 0b000000_?????_?????_?????_00000_101011
MUL   =  28   # 0b011100_?????_?????_?????_00000_000010
DIV   =  29   # 0b100111_?????_?????_?????_00000_000101
DIVU  =  30   # 0b100111_?????_?????_?????_00000_000111
REM   =  31   # 0b100111_?????_?????_?????_00000_000110
REMU  =  32   # 0b100111_?????_?????_?????_00000_001000
LH    =  33   # 0b100001_?????_?????_?????_?????_??????
LHU   =  34   # 0b100101_?????_?????_?????_?????_??????
LB    =  35   # 0b100000_?????_?????_?????_?????_??????
LBU   =  36   # 0b100100_?????_?????_?????_?????_??????
SH    =  37   # 0b101001_?????_?????_?????_?????_??????
SB    =  38   # 0b101000_?????_?????_?????_?????_??????
J     =  39   # 0b000010_?????_?????_?????_?????_??????
JAL   =  40   # 0b000011_?????_?????_?????_?????_??????
JALR  =  41   # 0b000000_?????_00000_?????_00000_001001
BEQ   =  42   # 0b000100_?????_?????_?????_?????_??????
BLEZ  =  43   # 0b000110_?????_00000_?????_?????_??????
BGTZ  =  44   # 0b000111_?????_00000_?????_?????_??????
BLTZ  =  45   # 0b000001_?????_00000_?????_?????_??????
BGEZ  =  46   # 0b000001_?????_00001_?????_?????_??????
MFC0  =  47   # 0b010000_00000_?????_?????_00000_000000
MTX   =  48   # 0b010010_?????_?????_00000_?????_??????
MFX   =  49   # 0b010010_?????_?????_00001_?????_??????

#-------------------------------------------------------------------------
# Parc Instruction Disassembler
#-------------------------------------------------------------------------

inst_dict = {
    NOP    : "nop",
    ADDIU  : "addiu",
    ORI    : "ori",
    LUI    : "lui",
    ADDU   : "addu",
    LW     : "lw",
    SW     : "sw",
    JAL    : "jal",
    JR     : "jr",
    BNE    : "bne",
    MTC0   : "mtc0",
    ANDI   : "andi",
    XORI   : "xori",
    SLTI   : "slti",
    SLTIU  : "sltiu",
    SLL    : "sll",
    SRL    : "srl",
    SRA    : "sra",
    SLLV   : "sllv",
    SRLV   : "srlv",
    SRAV   : "srav",
    SUBU   : "subu",
    AND    : "and",
    OR     : "or",
    XOR    : "xor",
    NOR    : "nor",
    SLT    : "slt",
    SLTU   : "sltu",
    MUL    : "mul",
    DIV    : "div",
    DIVU   : "divu",
    REM    : "rem",
    REMU   : "remu",
    LB     : "lb",
    LBU    : "lbu",
    LH     : "lh",
    LHU    : "lhu",
    SB     : "sb",
    SH     : "sh",
    J      : "j",
    JALR   : "jalr",
    BEQ    : "beq",
    BLEZ   : "blez",
    BGTZ   : "bgtz",
    BLTZ   : "bltz",
    BGEZ   : "bgez",
    MFC0   : "mfc0",
    MTX    : "mtx",
    MFX    : "mfx",
}

#-----------------------------------------------------------------------
# DecodeInstType
#-----------------------------------------------------------------------
# Parc Instruction Type Decoder

class DecodeInstType( Model ):

  # Interface

  def __init__( s ):

    s.in_ = InPort ( 32 )
    s.out = OutPort(  8 )

  # elaborate_logic

    @s.combinational
    def comb_logic():
      if     s.in_         == 0:        s.out.value = NOP
      elif   s.in_[ OP ]   == 0b001001: s.out.value = ADDIU
      elif   s.in_[ OP ]   == 0b001101: s.out.value = ORI
      elif   s.in_[ OP ]   == 0b001111: s.out.value = LUI
      elif   s.in_[ OP ]   == 0b100011: s.out.value = LW
      elif   s.in_[ OP ]   == 0b101011: s.out.value = SW
      elif   s.in_[ OP ]   == 0b000011: s.out.value = JAL
      elif   s.in_[ OP ]   == 0b000101: s.out.value = BNE
      elif   s.in_[ OP ]   == 0b010000:
        if   s.in_[ RS ]   == 0b00100:  s.out.value = MTC0
        elif s.in_[ RS ]   == 0b00000:  s.out.value = MFC0
        else:                           s.out.value = NOP
      elif   s.in_[ OP ]   == 0b010010:
        if   s.in_[ MT ]   == 0b00001:  s.out.value = MFX
        elif s.in_[ MT ]   == 0b00000:  s.out.value = MTX
        else:                           s.out.value = NOP
      elif   s.in_[ OP ]   == 0b000000:
        if   s.in_[ FUNC ] == 0b100001: s.out.value = ADDU
        elif s.in_[ FUNC ] == 0b001000: s.out.value = JR
        elif s.in_[ FUNC ] == 0b000000: s.out.value = SLL
        elif s.in_[ FUNC ] == 0b000010: s.out.value = SRL
        elif s.in_[ FUNC ] == 0b000011: s.out.value = SRA
        elif s.in_[ FUNC ] == 0b000100: s.out.value = SLLV
        elif s.in_[ FUNC ] == 0b000110: s.out.value = SRLV
        elif s.in_[ FUNC ] == 0b000111: s.out.value = SRAV
        elif s.in_[ FUNC ] == 0b100011: s.out.value = SUBU
        elif s.in_[ FUNC ] == 0b100100: s.out.value = AND
        elif s.in_[ FUNC ] == 0b100101: s.out.value = OR
        elif s.in_[ FUNC ] == 0b100110: s.out.value = XOR
        elif s.in_[ FUNC ] == 0b100111: s.out.value = NOR
        elif s.in_[ FUNC ] == 0b101010: s.out.value = SLT
        elif s.in_[ FUNC ] == 0b101011: s.out.value = SLTU
        elif s.in_[ FUNC ] == 0b001001: s.out.value = JALR
        else:                           s.out.value = NOP
      elif   s.in_[ OP ]   == 0b001100: s.out.value = ANDI
      elif   s.in_[ OP ]   == 0b001110: s.out.value = XORI
      elif   s.in_[ OP ]   == 0b001010: s.out.value = SLTI
      elif   s.in_[ OP ]   == 0b001011: s.out.value = SLTIU
      elif   s.in_[ OP ]   == 0b011100: s.out.value = MUL
      elif   s.in_[ OP ]   == 0b100111:
        if   s.in_[ FUNC ] == 0b000101: s.out.value = DIV
        elif s.in_[ FUNC ] == 0b000111: s.out.value = DIVU
        elif s.in_[ FUNC ] == 0b000110: s.out.value = REM
        elif s.in_[ FUNC ] == 0b001000: s.out.value = REMU
        else:                           s.out.value = NOP
      elif   s.in_[ OP ]   == 0b100001: s.out.value = LH
      elif   s.in_[ OP ]   == 0b100101: s.out.value = LHU
      elif   s.in_[ OP ]   == 0b100000: s.out.value = LB
      elif   s.in_[ OP ]   == 0b100100: s.out.value = LBU
      elif   s.in_[ OP ]   == 0b101001: s.out.value = SH
      elif   s.in_[ OP ]   == 0b101000: s.out.value = SB
      elif   s.in_[ OP ]   == 0b000010: s.out.value = J
      elif   s.in_[ OP ]   == 0b000011: s.out.value = JAL
      elif   s.in_[ OP ]   == 0b000100: s.out.value = BEQ
      elif   s.in_[ OP ]   == 0b000110: s.out.value = BLEZ
      elif   s.in_[ OP ]   == 0b000111: s.out.value = BGTZ
      elif   s.in_[ OP ]   == 0b000001:
        if   s.in_[RT]     == 0b00000:  s.out.value = BLTZ
        elif s.in_[RT]     == 0b00001:  s.out.value = BGEZ
        else:                           s.out.value = NOP
      else:                             s.out.value = NOP


