#=========================================================================
# tinyrv2_encoding_test.py
#=========================================================================
# To test instruction encodings, I basically just used gas to generate
# the reference instruction bits.

import pytest
import struct

from proc.tinyrv2_encoding  import assemble_inst, disassemble_inst
from proc.SparseMemoryImage import SparseMemoryImage

#-------------------------------------------------------------------------
# compare_str
#-------------------------------------------------------------------------
# compare two strings ignoring whitespaces

def compare_str( str1, str2 ):
  str1 = str1.replace(" ", "")
  str2 = str2.replace(" ", "")
  return str1 == str2

#-------------------------------------------------------------------------
# check
#-------------------------------------------------------------------------
# Takes an instruction string which is assembled and checked against the
# given instruction bits. These instruction bits are then disassembled
# and checked against the given instruction diassembly string. We do not
# compare the diassembled string to the first isntruction string since
# some instruction accept many different syntaxes for assembly but these
# will map to a more cannonical output during diassembly.

def check( inst_str, inst_bits_ref, inst_str_ref ):

  inst_bits = assemble_inst( {}, 0, inst_str )
  assert inst_bits == inst_bits_ref

  inst_str  = disassemble_inst( inst_bits )
  assert compare_str( inst_str, inst_str_ref )

#-------------------------------------------------------------------------
# check_sym
#-------------------------------------------------------------------------
# Include a symbol table and pc when checking the instruction. Useful for
# testing control flow instructions like jumps and branches.

def check_sym( sym, pc, inst_str, inst_bits_ref, inst_str_ref ):

  inst_bits = assemble_inst( sym, pc, inst_str )
  assert inst_bits == inst_bits_ref

  inst_str  = disassemble_inst( inst_bits )
  assert compare_str( inst_str, inst_str_ref )

#-------------------------------------------------------------------------
# Basic instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_nop():
  check( "nop",                     0b00000000000000000000000000010011, "nop" )

#-------------------------------------------------------------------------
# Register-register arithmetic, logical, and comparison instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_add():
  check( "add   x1,  x2,  x3",      0b00000000001100010000000010110011, "add   x01, x02, x03" )
  check( "add   x01, x02  x03",     0b00000000001100010000000010110011, "add   x01, x02, x03" )

#-------------------------------------------------------------------------
# Register-immediate arithmetic, logical, and comparison instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_addi():
  check( "addi  x1,  x2,  3",       0b00000000001100010000000010010011, "addi  x01, x02, 0x003" )
  check( "addi  x1,  x2,  0xff",    0b00001111111100010000000010010011, "addi  x01, x02, 0x0ff" )

#-------------------------------------------------------------------------
# Shift instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_slli():
  check( "slli  x1,  x2,  3",       0b00000000001100010001000010010011, "slli  x01, x02, 03"  )

def test_tinyrv2_inst_srli():
  check( "srli  x1,  x2,  3",       0b00000000001100010101000010010011, "srli  x01, x02, 03"  )

def test_tinyrv2_inst_srai():
  check( "srai  x1,  x2,  3",       0b01000000001100010101000010010011, "srai  x01, x02, 03"  )

#-------------------------------------------------------------------------
# Other instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_lui():
  check( "lui   x1,  0xdeadb",      0b11011110101011011011000010110111, "lui   x01, 0xdeadb"    )

def test_tinyrv2_inst_auipc():
  check( "auipc x1,  0xdeadb",      0b11011110101011011011000010010111, "auipc x01, 0xdeadb"    )

#-------------------------------------------------------------------------
# Load/store instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_lw():
  # lw rd, imm(rs1)
  check( "lw    x1,     3(x2)",     0b00000000001100010010000010000011, "lw    x01, 0x003(x02)" )
  check( "lw   x13, 0xabc(x4)",     0b10101011110000100010011010000011, "lw    x13, 0xabc(x04)" )
  check( "lw   x13,    -3(x4)",     0b11111111110100100010011010000011, "lw    x13, 0xffd(x04)" )

def test_tinyrv2_inst_sw():
  # sw rs2, imm(rs1)
  check( "sw    x1,     3(x2)",     0b00000000000100010010000110100011, "sw    x01, 0x003(x02)" )
  check( "sw    x1, 0xabc(x2)",     0b10101010000100010010111000100011, "sw    x01, 0xabc(x02)" )

#-------------------------------------------------------------------------
# Jump instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_jal():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "jal  x01, label_a", 0b00000000010000000001000011101111, "jal x01, 0x001004" )

def test_tinyrv2_inst_jalr():
  check( "jalr  x10, x8,  3",       0b00000000001101000000010101100111, "jalr  x10, x08, 0x003"  )

#-------------------------------------------------------------------------
# Conditional branch instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_beq():
  sym = { "label_a": 0x00001404, "label_b": 0x00000400 }
  check_sym( sym, 0x1000, "beq x01, x02, label_a", 0b01000000001000001000001001100011, "beq x01, x02, 0x0404" )
  check_sym( sym, 0x1000, "beq x01, x02, label_b", 0b11000000001000001000000001100011, "beq x01, x02, 0x1400" )

#-------------------------------------------------------------------------
# AMO instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_amo():
  check( "amoadd  x1,  x2,  x3",     0b00000000001100010010000010101111, "amoadd x01, x02, x03" )
  check( "amoxor x13,  x4,  x5",     0b00100000010100100010011010101111, "amoxor x13, x04, x05" )
  check( "amoand x01, x04, x05",     0b01100000010100100010000010101111, "amoand x01, x04, x05" )

#-------------------------------------------------------------------------
# System instructions
#-------------------------------------------------------------------------

def test_tinyrv2_inst_csrr():
  check( "csrr  x3, mngr2proc",     0b11111100000000000010000111110011, "csrr  x03, 0xfc0"       )

def test_tinyrv2_inst_csrw():
  check( "csrw  proc2mngr, x2",     0b01111100000000010001000001110011, "csrw  0x7c0, x02"       )

#-------------------------------------------------------------------------
# mk_section
#-------------------------------------------------------------------------
# Helper function to make a section from a list of words.

def mk_section( name, addr, words ):
  data = bytearray()
  for word in words:
    data.extend(struct.pack("<I",word))

  return SparseMemoryImage.Section( name, addr, data )
