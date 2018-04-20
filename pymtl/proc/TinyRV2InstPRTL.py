#========================================================================
# TinyRV2 Instruction Type
#========================================================================
# Instruction types are similar to message types but are strictly used
# for communication within a TinyRV2-based processor. Instruction
# "messages" can be unpacked into the various fields as defined by the
# TinyRV2 ISA, as well as be constructed from specifying each field
# explicitly. The 32-bit instruction has different fields depending on
# the format of the instruction used. The following are the various
# instruction encoding formats used in the TinyRV2 ISA.
#
#  31          25 24   20 19   15 14    12 11          7 6      0
# | funct7       | rs2   | rs1   | funct3 | rd          | opcode |  R-type
# | imm[11:0]            | rs1   | funct3 | rd          | opcode |  I-type, I-imm
# | imm[11:5]    | rs2   | rs1   | funct3 | imm[4:0]    | opcode |  S-type, S-imm
# | imm[12|10:5] | rs2   | rs1   | funct3 | imm[4:1|11] | opcode |  SB-type,B-imm
# | imm[31:12]                            | rd          | opcode |  U-type, U-imm
# | imm[20|10:1|11|19:12]                 | rd          | opcode |  UJ-type,J-imm

from pymtl import *

#-------------------------------------------------------------------------
# TinyRV2 Instruction Fields
#-------------------------------------------------------------------------

OPCODE = slice(  0,  7 )
FUNCT3 = slice( 12, 15 )
FUNCT7 = slice( 25, 32 )

RD     = slice(  7, 12 )
RS1    = slice( 15, 20 )
RS2    = slice( 20, 25 )
SHAMT  = slice( 20, 25 )

I_IMM  = slice( 20, 32 )
CSRNUM = slice( 20, 32 )

S_IMM0 = slice(  7, 12 )
S_IMM1 = slice( 25, 32 )

B_IMM0 = slice(  8, 12 )
B_IMM1 = slice( 25, 31 )
B_IMM2 = slice(  7,  8 )
B_IMM3 = slice( 31, 32 )

U_IMM  = slice( 12, 32 )

J_IMM0 = slice( 21, 31 )
J_IMM1 = slice( 20, 21 )
J_IMM2 = slice( 12, 20 )
J_IMM3 = slice( 31, 32 )

# CUSTOM0 specific

XD     = slice( 14, 15 )
XS1    = slice( 13, 14 )
XS2    = slice( 12, 13 )

#-------------------------------------------------------------------------
# TinyRV2 Instruction Definitions
#-------------------------------------------------------------------------
NOP     = 0  # 00000000000000000000000000000000

# Load
LW      = 1  # ?????????????????010?????0000011

# Store
SW      = 2  # ?????????????????010?????0100011

# Shifts
SLL     = 3  # 0000000??????????001?????0110011
SLLI    = 4  # 0000000??????????001?????0010011
SRL     = 5  # 0000000??????????101?????0110011
SRLI    = 6  # 0000000??????????101?????0010011
SRA     = 7  # 0100000??????????101?????0110011
SRAI    = 8  # 0100000??????????101?????0010011

# Arithmetic
ADD     = 9  # 0000000??????????000?????0110011
ADDI    = 10 # ?????????????????000?????0010011
SUB     = 11 # 0100000??????????000?????0110011
LUI     = 12 # ?????????????????????????0110111
AUIPC   = 13 # ?????????????????????????0010111

# Logical
XOR     = 14 # 0000000??????????100?????0110011
XORI    = 15 # ?????????????????100?????0010011
OR      = 16 # 0000000??????????110?????0110011
ORI     = 17 # ?????????????????110?????0010011
AND     = 18 # 0000000??????????111?????0110011
ANDI    = 19 # ?????????????????111?????0010011

# Compare
SLT     = 20 # 0000000??????????010?????0110011
SLTI    = 21 # ?????????????????010?????0010011
SLTU    = 22 # 0000000??????????011?????0110011
SLTIU   = 23 # ?????????????????011?????0010011

# Branches
BEQ     = 24 # ?????????????????000?????1100011
BNE     = 25 # ?????????????????001?????1100011
BLT     = 26 # ?????????????????100?????1100011
BGE     = 27 # ?????????????????101?????1100011
BLTU    = 28 # ?????????????????110?????1100011
BGEU    = 29 # ?????????????????111?????1100011

# Jump & Link
JAL     = 30 # ?????????????????????????1101111
JALR    = 31 # ?????????????????000?????1100111

# Multiply
MUL     = 32 # 0000001??????????000?????0110011

# AMOs

AMOSWAP = 33 # 00001????????????010?????0101111
AMOADD  = 34 # 00000????????????010?????0101111
AMOXOR  = 35 # 00100????????????010?????0101111
AMOAND  = 36 # 01100????????????010?????0101111
AMOOR   = 37 # 01000????????????010?????0101111
AMOMIN  = 38 # 10000????????????010?????0101111
AMOMAX  = 39 # 10100????????????010?????0101111
AMOMINU = 40 # 11000????????????010?????0101111
AMOMAXU = 41 # 11100????????????010?????0101111

# Privileged
CSRR    = 42 # ????????????00000010?????1110011
CSRW    = 43 # ?????????????????001000001110011

# ZERO inst
ZERO    = 44

# CSRRX for accelerator
CSRRX   = 45 # 0111111?????00000010?????1110011

#-------------------------------------------------------------------------
# TinyRV2 Instruction Disassembler
#-------------------------------------------------------------------------

inst_dict = {
  NOP     : "nop",
  LW      : "lw",
  SW      : "sw",
  SLL     : "sll",
  SLLI    : "slli",
  SRL     : "srl",
  SRLI    : "srli",
  SRA     : "sra",
  SRAI    : "srai",
  ADD     : "add",
  ADDI    : "addi",
  SUB     : "sub",
  LUI     : "lui",
  AUIPC   : "auipc",
  XOR     : "xor",
  XORI    : "xori",
  OR      : "or",
  ORI     : "ori",
  AND     : "and",
  ANDI    : "andi",
  SLT     : "slt",
  SLTI    : "slti",
  SLTU    : "sltu",
  SLTIU   : "sltiu",
  BEQ     : "beq",
  BNE     : "bne",
  BLT     : "blt",
  BGE     : "bge",
  BLTU    : "bltu",
  BGEU    : "bgeu",
  JAL     : "jal",
  JALR    : "jalr",
  MUL     : "mul",
  AMOSWAP : "amoswap",
  AMOADD  : "amoadd",
  AMOXOR  : "amoxor",
  AMOAND  : "amoand",
  AMOOR   : "amoor",
  AMOMIN  : "amomin",
  AMOMAX  : "amomax",
  AMOMINU : "amominu",
  AMOMAXU : "amomaxu",
  CSRR    : "csrr",
  CSRW    : "csrw",
  CSRRX   : "csrrx",
  ZERO    : "????"
}

#-------------------------------------------------------------------------
# CSR registers
#-------------------------------------------------------------------------

# R/W
CSR_PROC2MNGR = 0x7C0
CSR_STATS_EN  = 0x7C1

# R/O
CSR_MNGR2PROC = 0xFC0
CSR_NUMCORES  = 0xFC1
CSR_COREID    = 0xF14

#-----------------------------------------------------------------------
# DecodeInstType
#-----------------------------------------------------------------------
# TinyRV2 Instruction Type Decoder

class DecodeInstType( Model ):

  # Interface

  def __init__( s ):

    s.in_ = InPort ( 32 )
    s.out = OutPort(  8 )

    @s.combinational
    def comb_logic():

      s.out.value = ZERO

      if   s.in_ == 0b10011:                 s.out.value = NOP
      elif s.in_[OPCODE] == 0b0110011:
        if   s.in_[FUNCT7] == 0b0000000:
          if   s.in_[FUNCT3] == 0b000:       s.out.value = ADD
          elif s.in_[FUNCT3] == 0b001:       s.out.value = SLL
          elif s.in_[FUNCT3] == 0b010:       s.out.value = SLT
          elif s.in_[FUNCT3] == 0b011:       s.out.value = SLTU
          elif s.in_[FUNCT3] == 0b100:       s.out.value = XOR
          elif s.in_[FUNCT3] == 0b101:       s.out.value = SRL
          elif s.in_[FUNCT3] == 0b110:       s.out.value = OR
          elif s.in_[FUNCT3] == 0b111:       s.out.value = AND
        elif s.in_[FUNCT7] == 0b0100000:
          if   s.in_[FUNCT3] == 0b000:       s.out.value = SUB
          elif s.in_[FUNCT3] == 0b101:       s.out.value = SRA
        elif s.in_[FUNCT7] == 0b0000001:
          if   s.in_[FUNCT3] == 0b000:       s.out.value = MUL

      elif s.in_[OPCODE] == 0b0010011:
        if   s.in_[FUNCT3] == 0b000:         s.out.value = ADDI
        elif s.in_[FUNCT3] == 0b010:         s.out.value = SLTI
        elif s.in_[FUNCT3] == 0b011:         s.out.value = SLTIU
        elif s.in_[FUNCT3] == 0b100:         s.out.value = XORI
        elif s.in_[FUNCT3] == 0b110:         s.out.value = ORI
        elif s.in_[FUNCT3] == 0b111:         s.out.value = ANDI
        elif s.in_[FUNCT3] == 0b001:         s.out.value = SLLI
        elif s.in_[FUNCT3] == 0b101:
          if   s.in_[FUNCT7] == 0b0000000:   s.out.value = SRLI
          elif s.in_[FUNCT7] == 0b0100000:   s.out.value = SRAI

      elif s.in_[OPCODE] == 0b0100011:
        if   s.in_[FUNCT3] == 0b010:         s.out.value = SW

      elif s.in_[OPCODE] == 0b0000011:
        if   s.in_[FUNCT3] == 0b010:         s.out.value = LW

      elif s.in_[OPCODE] == 0b1100011:
        if   s.in_[FUNCT3] == 0b000:         s.out.value = BEQ
        elif s.in_[FUNCT3] == 0b001:         s.out.value = BNE
        elif s.in_[FUNCT3] == 0b100:         s.out.value = BLT
        elif s.in_[FUNCT3] == 0b101:         s.out.value = BGE
        elif s.in_[FUNCT3] == 0b110:         s.out.value = BLTU
        elif s.in_[FUNCT3] == 0b111:         s.out.value = BGEU

      elif s.in_[OPCODE] == 0b0110111:       s.out.value = LUI

      elif s.in_[OPCODE] == 0b0010111:       s.out.value = AUIPC

      elif s.in_[OPCODE] == 0b1101111:       s.out.value = JAL

      elif s.in_[OPCODE] == 0b1100111:       s.out.value = JALR

      elif s.in_[OPCODE] == 0b1110011:
        if   s.in_[FUNCT3] == 0b001:         s.out.value = CSRW
        elif s.in_[FUNCT3] == 0b010:
          if s.in_[FUNCT7] == 0b0111111:     s.out.value = CSRRX
          else:                              s.out.value = CSRR
      # elif s.in_[OPCODE] == 0b0001011:     s.out.value = CUST0

      elif s.in_[OPCODE] == 0b0101111:
        if   s.in_[FUNCT3] == 0b010:
          if   s.in_[FUNCT7][2:] == 0b00001: s.out.value = AMOSWAP
          elif s.in_[FUNCT7][2:] == 0b00000: s.out.value = AMOADD
          elif s.in_[FUNCT7][2:] == 0b00100: s.out.value = AMOXOR
          elif s.in_[FUNCT7][2:] == 0b01100: s.out.value = AMOAND
          elif s.in_[FUNCT7][2:] == 0b01000: s.out.value = AMOOR
          elif s.in_[FUNCT7][2:] == 0b10000: s.out.value = AMOMIN
          elif s.in_[FUNCT7][2:] == 0b10100: s.out.value = AMOMAX
          elif s.in_[FUNCT7][2:] == 0b11000: s.out.value = AMOMINU
          elif s.in_[FUNCT7][2:] == 0b11100: s.out.value = AMOMAXU

