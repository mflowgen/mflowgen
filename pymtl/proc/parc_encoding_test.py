#=========================================================================
# parc_encoding_test.py
#=========================================================================
# To test instruction encodings, I basically just used gas to generate
# the reference instruction bits.

import parc_encoding
import pytest
import struct

from SparseMemoryImage import SparseMemoryImage

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

  inst_bits = parc_encoding.assemble_inst( {}, 0, inst_str )
  assert inst_bits == inst_bits_ref

  inst_str  = parc_encoding.disassemble_inst( inst_bits )
  assert inst_str == inst_str_ref

#-------------------------------------------------------------------------
# check_sym
#-------------------------------------------------------------------------
# Include a symbol table and pc when checking the instruction. Useful for
# testing control flow instructions like jumps and branches.

def check_sym( sym, pc, inst_str, inst_bits_ref, inst_str_ref ):

  inst_bits = parc_encoding.assemble_inst( sym, pc, inst_str )
  assert inst_bits == inst_bits_ref

  inst_str  = parc_encoding.disassemble_inst( inst_bits )
  assert inst_str == inst_str_ref

#-------------------------------------------------------------------------
# Basic instructions
#-------------------------------------------------------------------------

def test_parc_inst_mfc0():
  check( "mfc0 r1, mngr2proc",      0x40010800, "mfc0  r01, r01" )
  check( "mfc0 r01, mngr2proc",     0x40010800, "mfc0  r01, r01" )
  check( "mfc0 r01,mngr2proc",      0x40010800, "mfc0  r01, r01" )
  check( "mfc0 r11, mngr2proc",     0x400b0800, "mfc0  r11, r01" )
  check( "mfc0 r29, mngr2proc",     0x401d0800, "mfc0  r29, r01" )

def test_parc_inst_mtc0():
  check( "mtc0 r1, mngr2proc",      0x40810800, "mtc0  r01, r01" )
  check( "mtc0 r01, mngr2proc",     0x40810800, "mtc0  r01, r01" )
  check( "mtc0 r01,mngr2proc",      0x40810800, "mtc0  r01, r01" )
  check( "mtc0 r11, mngr2proc",     0x408b0800, "mtc0  r11, r01" )
  check( "mtc0 r29, mngr2proc",     0x409d0800, "mtc0  r29, r01" )

def test_parc_inst_nop():
  check( "nop",                     0x00000000, "nop" )

#-------------------------------------------------------------------------
# accelerator instructions
#-------------------------------------------------------------------------

def test_parc_inst_mfx():
  check( "mfx r1, xr2, 1",          0x48410801, "mfx r01, xr02, 0001" )

def test_parc_inst_mtx():
  check( "mtx r1, xr2, 1",          0x48410001, "mtx r01, xr02, 0001" )

#-------------------------------------------------------------------------
# Register-register arithmetic, logical, and comparison instructions
#-------------------------------------------------------------------------

def test_parc_inst_addu():
  check( "addu r1,  r2,  r3",       0x00430821, "addu  r01, r02, r03" )
  check( "addu r04,r05,r06",        0x00a62021, "addu  r04, r05, r06" )
  check( "addu r11, r12, r13",      0x018d5821, "addu  r11, r12, r13" )
  check( "addu r29, r30, r31",      0x03dfe821, "addu  r29, r30, r31" )

def test_parc_inst_subu():
  check( "subu r1,  r2,  r3",       0x00430823, "subu  r01, r02, r03" )
  check( "subu r04,r05,r06",        0x00a62023, "subu  r04, r05, r06" )
  check( "subu r11, r12, r13",      0x018d5823, "subu  r11, r12, r13" )
  check( "subu r29, r30, r31",      0x03dfe823, "subu  r29, r30, r31" )

def test_parc_inst_and():
  check( "and  r1,  r2,  r3",       0x00430824, "and   r01, r02, r03" )
  check( "and  r04,r05,r06",        0x00a62024, "and   r04, r05, r06" )
  check( "and  r11, r12, r13",      0x018d5824, "and   r11, r12, r13" )
  check( "and  r29, r30, r31",      0x03dfe824, "and   r29, r30, r31" )

def test_parc_inst_or():
  check( "or   r1,  r2,  r3",       0x00430825, "or    r01, r02, r03" )
  check( "or   r04,r05,r06",        0x00a62025, "or    r04, r05, r06" )
  check( "or   r11, r12, r13",      0x018d5825, "or    r11, r12, r13" )
  check( "or   r29, r30, r31",      0x03dfe825, "or    r29, r30, r31" )

def test_parc_inst_xor():
  check( "xor  r1,  r2,  r3",       0x00430826, "xor   r01, r02, r03" )
  check( "xor  r04,r05,r06",        0x00a62026, "xor   r04, r05, r06" )
  check( "xor  r11, r12, r13",      0x018d5826, "xor   r11, r12, r13" )
  check( "xor  r29, r30, r31",      0x03dfe826, "xor   r29, r30, r31" )

def test_parc_inst_nor():
  check( "nor  r1,  r2,  r3",       0x00430827, "nor   r01, r02, r03" )
  check( "nor  r04,r05,r06",        0x00a62027, "nor   r04, r05, r06" )
  check( "nor  r11, r12, r13",      0x018d5827, "nor   r11, r12, r13" )
  check( "nor  r29, r30, r31",      0x03dfe827, "nor   r29, r30, r31" )

def test_parc_inst_slt():
  check( "slt  r1,  r2,  r3",       0x0043082a, "slt   r01, r02, r03" )
  check( "slt  r04,r05,r06",        0x00a6202a, "slt   r04, r05, r06" )
  check( "slt  r11, r12, r13",      0x018d582a, "slt   r11, r12, r13" )
  check( "slt  r29, r30, r31",      0x03dfe82a, "slt   r29, r30, r31" )

def test_parc_inst_sltu():
  check( "sltu r1,  r2,  r3",       0x0043082b, "sltu  r01, r02, r03" )
  check( "sltu r04,r05,r06",        0x00a6202b, "sltu  r04, r05, r06" )
  check( "sltu r11, r12, r13",      0x018d582b, "sltu  r11, r12, r13" )
  check( "sltu r29, r30, r31",      0x03dfe82b, "sltu  r29, r30, r31" )

#-------------------------------------------------------------------------
# Register-immediate arithmetic, logical, and comparison instructions
#-------------------------------------------------------------------------
# Notice that our checks are slightly different for those instructions
# which sign extend their immediate (i.e., addiu, slti, sltiu) and those
# that zero extend their immediate (i.e., andi, ori, xori).

def test_parc_inst_addiu():
  check( "addiu r1,  r2,  3",       0x24410003, "addiu r01, r02, 0003"  )
  check( "addiu r1,  r2,  -3",      0x2441fffd, "addiu r01, r02, fffd"  )
  check( "addiu r1,  r2,  003",     0x24410003, "addiu r01, r02, 0003"  )
  check( "addiu r1,  r2,  0xff",    0x244100ff, "addiu r01, r02, 00ff"  )
  check( "addiu r1,  r2,  0x4f8f",  0x24414f8f, "addiu r01, r02, 4f8f"  )
  check( "addiu r1,  r2,  -0x4f8f", 0x2441b071, "addiu r01, r02, b071"  )
  check( "addiu r04,r05,3",         0x24a40003, "addiu r04, r05, 0003"  )
  check( "addiu r11, r12, 3",       0x258b0003, "addiu r11, r12, 0003"  )
  check( "addiu r29, r31, 3",       0x27fd0003, "addiu r29, r31, 0003"  )

def test_parc_inst_andi():
  check( "andi  r1,  r2,  3",       0x30410003, "andi  r01, r02, 0003" )
  check( "andi  r1,  r2,  003",     0x30410003, "andi  r01, r02, 0003" )
  check( "andi  r1,  r2,  0xff",    0x304100ff, "andi  r01, r02, 00ff" )
  check( "andi  r1,  r2,  0x8f8f",  0x30418f8f, "andi  r01, r02, 8f8f" )
  check( "andi  r04,r05,3",         0x30a40003, "andi  r04, r05, 0003" )
  check( "andi  r11, r12, 3",       0x318b0003, "andi  r11, r12, 0003" )
  check( "andi  r29, r31, 3",       0x33fd0003, "andi  r29, r31, 0003" )

def test_parc_inst_ori():
  check( "ori   r1,  r2,  3",       0x34410003, "ori   r01, r02, 0003" )
  check( "ori   r1,  r2,  003",     0x34410003, "ori   r01, r02, 0003" )
  check( "ori   r1,  r2,  0xff",    0x344100ff, "ori   r01, r02, 00ff" )
  check( "ori   r1,  r2,  0x8f8f",  0x34418f8f, "ori   r01, r02, 8f8f" )
  check( "ori   r04,r05,3",         0x34a40003, "ori   r04, r05, 0003" )
  check( "ori   r11, r12, 3",       0x358b0003, "ori   r11, r12, 0003" )
  check( "ori   r29, r31, 3",       0x37fd0003, "ori   r29, r31, 0003" )

  sym = { "label_a": 0xdeadbeef, "label_b": 0xcafe1234 }
  check_sym( sym, 0x1000, "ori r1, r2, %lo[label_a]", 0x3441beef, "ori   r01, r02, beef" )
  check_sym( sym, 0x1000, "ori r1, r2, %hi[label_a]", 0x3441dead, "ori   r01, r02, dead" )
  check_sym( sym, 0x1000, "ori r1, r2, %lo[label_b]", 0x34411234, "ori   r01, r02, 1234" )
  check_sym( sym, 0x1000, "ori r1, r2, %hi[label_b]", 0x3441cafe, "ori   r01, r02, cafe" )

def test_parc_inst_xori():
  check( "xori  r1,  r2,  3",       0x38410003, "xori  r01, r02, 0003" )
  check( "xori  r1,  r2,  003",     0x38410003, "xori  r01, r02, 0003" )
  check( "xori  r1,  r2,  0xff",    0x384100ff, "xori  r01, r02, 00ff" )
  check( "xori  r1,  r2,  0x8f8f",  0x38418f8f, "xori  r01, r02, 8f8f" )
  check( "xori  r04,r05,3",         0x38a40003, "xori  r04, r05, 0003" )
  check( "xori  r11, r12, 3",       0x398b0003, "xori  r11, r12, 0003" )
  check( "xori  r29, r31, 3",       0x3bfd0003, "xori  r29, r31, 0003" )

def test_parc_inst_slti():
  check( "slti  r1,  r2,  3",       0x28410003, "slti  r01, r02, 0003" )
  check( "slti  r1,  r2,  -3",      0x2841fffd, "slti  r01, r02, fffd" )
  check( "slti  r1,  r2,  003",     0x28410003, "slti  r01, r02, 0003" )
  check( "slti  r1,  r2,  0xff",    0x284100ff, "slti  r01, r02, 00ff" )
  check( "slti  r1,  r2,  0x4f8f",  0x28414f8f, "slti  r01, r02, 4f8f" )
  check( "slti  r1,  r2,  -0x4f8f", 0x2841b071, "slti  r01, r02, b071" )
  check( "slti  r04,r05,3",         0x28a40003, "slti  r04, r05, 0003" )
  check( "slti  r11, r12, 3",       0x298b0003, "slti  r11, r12, 0003" )
  check( "slti  r29, r31, 3",       0x2bfd0003, "slti  r29, r31, 0003" )

def test_parc_inst_sltiu():
  check( "sltiu r1,  r2,  3",       0x2c410003, "sltiu r01, r02, 0003" )
  check( "sltiu r1,  r2,  -3",      0x2c41fffd, "sltiu r01, r02, fffd" )
  check( "sltiu r1,  r2,  003",     0x2c410003, "sltiu r01, r02, 0003" )
  check( "sltiu r1,  r2,  0xff",    0x2c4100ff, "sltiu r01, r02, 00ff" )
  check( "sltiu r1,  r2,  0x4f8f",  0x2c414f8f, "sltiu r01, r02, 4f8f" )
  check( "sltiu r1,  r2,  -0x4f8f", 0x2c41b071, "sltiu r01, r02, b071" )
  check( "sltiu r04,r05,3",         0x2ca40003, "sltiu r04, r05, 0003" )
  check( "sltiu r11, r12, 3",       0x2d8b0003, "sltiu r11, r12, 0003" )
  check( "sltiu r29, r31, 3",       0x2ffd0003, "sltiu r29, r31, 0003" )

#-------------------------------------------------------------------------
# Shift instructions
#-------------------------------------------------------------------------

def test_parc_inst_sll():
  check( "sll r1,  r2,  3",         0x000208c0, "sll   r01, r02, 03" )
  check( "sll r1,  r2,  31",        0x00020fc0, "sll   r01, r02, 1f" )
  check( "sll r04,r05,3",           0x000520c0, "sll   r04, r05, 03" )
  check( "sll r11, r12, 3",         0x000c58c0, "sll   r11, r12, 03" )
  check( "sll r29, r30, 3",         0x001ee8c0, "sll   r29, r30, 03" )

def test_parc_inst_srl():
  check( "srl r1,  r2,  3",         0x000208c2, "srl   r01, r02, 03" )
  check( "srl r1,  r2,  31",        0x00020fc2, "srl   r01, r02, 1f" )
  check( "srl r04,r05,3",           0x000520c2, "srl   r04, r05, 03" )
  check( "srl r11, r12, 3",         0x000c58c2, "srl   r11, r12, 03" )
  check( "srl r29, r30, 3",         0x001ee8c2, "srl   r29, r30, 03" )

def test_parc_inst_sra():
  check( "sra r1,  r2,  3",         0x000208c3, "sra   r01, r02, 03" )
  check( "sra r1,  r2,  31",        0x00020fc3, "sra   r01, r02, 1f" )
  check( "sra r04,r05,3",           0x000520c3, "sra   r04, r05, 03" )
  check( "sra r11, r12, 3",         0x000c58c3, "sra   r11, r12, 03" )
  check( "sra r29, r30, 3",         0x001ee8c3, "sra   r29, r30, 03" )

def test_parc_inst_sllv():
  check( "sllv r1,  r2,  r3",       0x00620804, "sllv  r01, r02, r03" )
  check( "sllv r04,r05,r06",        0x00c52004, "sllv  r04, r05, r06" )
  check( "sllv r11, r12, r13",      0x01ac5804, "sllv  r11, r12, r13" )
  check( "sllv r29, r30, r31",      0x03fee804, "sllv  r29, r30, r31" )

def test_parc_inst_srlv():
  check( "srlv r1,  r2,  r3",       0x00620806, "srlv  r01, r02, r03" )
  check( "srlv r04,r05,r06",        0x00c52006, "srlv  r04, r05, r06" )
  check( "srlv r11, r12, r13",      0x01ac5806, "srlv  r11, r12, r13" )
  check( "srlv r29, r30, r31",      0x03fee806, "srlv  r29, r30, r31" )

def test_parc_inst_srav():
  check( "srav r1,  r2,  r3",       0x00620807, "srav  r01, r02, r03" )
  check( "srav r04,r05,r06",        0x00c52007, "srav  r04, r05, r06" )
  check( "srav r11, r12, r13",      0x01ac5807, "srav  r11, r12, r13" )
  check( "srav r29, r30, r31",      0x03fee807, "srav  r29, r30, r31" )

#-------------------------------------------------------------------------
# Other instructions
#-------------------------------------------------------------------------

def test_parc_inst_lui():
  check( "lui r1,  3",              0x3c010003, "lui   r01, 0003" )
  check( "lui r1,  003",            0x3c010003, "lui   r01, 0003" )
  check( "lui r1,  0xff",           0x3c0100ff, "lui   r01, 00ff" )
  check( "lui r1,  0x8f8f",         0x3c018f8f, "lui   r01, 8f8f" )
  check( "lui r04,3",               0x3c040003, "lui   r04, 0003" )
  check( "lui r11, 3",              0x3c0b0003, "lui   r11, 0003" )
  check( "lui r29, 3",              0x3c1d0003, "lui   r29, 0003" )

  sym = { "label_a": 0xdeadbeef, "label_b": 0xcafe1234 }
  check_sym( sym, 0x1000, "lui r1, %lo[label_a]", 0x3c01beef, "lui   r01, beef" )
  check_sym( sym, 0x1000, "lui r1, %hi[label_a]", 0x3c01dead, "lui   r01, dead" )
  check_sym( sym, 0x1000, "lui r1, %lo[label_b]", 0x3c011234, "lui   r01, 1234" )
  check_sym( sym, 0x1000, "lui r1, %hi[label_b]", 0x3c01cafe, "lui   r01, cafe" )

#-------------------------------------------------------------------------
# Multiply instructions
#-------------------------------------------------------------------------

def test_parc_inst_mul():
  check( "mul  r1,  r2,  r3",       0x70430802, "mul   r01, r02, r03" )
  check( "mul  r04,r05,r06",        0x70a62002, "mul   r04, r05, r06" )
  check( "mul  r11, r12, r13",      0x718d5802, "mul   r11, r12, r13" )
  check( "mul  r29, r30, r31",      0x73dfe802, "mul   r29, r30, r31" )

#-------------------------------------------------------------------------
# Load/store instructions
#-------------------------------------------------------------------------

def test_parc_inst_lw():
  check( "lw  r1,       3(r2)",     0x8c410003, "lw    r01, 0003(r02)" )
  check( "lw  r1,      -3(r2)",     0x8c41fffd, "lw    r01, fffd(r02)" )
  check( "lw  r1,     003(r2)",     0x8c410003, "lw    r01, 0003(r02)" )
  check( "lw  r1,    0xff(r2)",     0x8c4100ff, "lw    r01, 00ff(r02)" )
  check( "lw  r1,  0x4f8f(r2)",     0x8c414f8f, "lw    r01, 4f8f(r02)" )
  check( "lw  r1, -0x4f8f(r2)",     0x8c41b071, "lw    r01, b071(r02)" )
  check( "lw  r04,3(r05)",          0x8ca40003, "lw    r04, 0003(r05)" )
  check( "lw  r11, 3(r12)",         0x8d8b0003, "lw    r11, 0003(r12)" )
  check( "lw  r29, 3(r31)",         0x8ffd0003, "lw    r29, 0003(r31)" )

def test_parc_inst_sw():
  check( "sw  r1,       3(r2)",     0xac410003, "sw    r01, 0003(r02)" )
  check( "sw  r1,      -3(r2)",     0xac41fffd, "sw    r01, fffd(r02)" )
  check( "sw  r1,     003(r2)",     0xac410003, "sw    r01, 0003(r02)" )
  check( "sw  r1,    0xff(r2)",     0xac4100ff, "sw    r01, 00ff(r02)" )
  check( "sw  r1,  0x4f8f(r2)",     0xac414f8f, "sw    r01, 4f8f(r02)" )
  check( "sw  r1, -0x4f8f(r2)",     0xac41b071, "sw    r01, b071(r02)" )
  check( "sw  r04,3(r05)",          0xaca40003, "sw    r04, 0003(r05)" )
  check( "sw  r11, 3(r12)",         0xad8b0003, "sw    r11, 0003(r12)" )
  check( "sw  r29, 3(r31)",         0xaffd0003, "sw    r29, 0003(r31)" )

#-------------------------------------------------------------------------
# Unconditional jump instructions
#-------------------------------------------------------------------------

def test_parc_inst_j():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "j label_a",     0x08000801, "j     0000801" )
  check_sym( sym, 0x1000, "j label_b",     0x08000001, "j     0000001" )

def test_parc_inst_jal():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "jal label_a",   0x0c000801, "jal   0000801" )
  check_sym( sym, 0x1000, "jal label_b",   0x0c000001, "jal   0000001" )

def test_parc_inst_jr():
  check( "jr r1",                   0x00200008, "jr    r01" )
  check( "jr r04",                  0x00800008, "jr    r04" )
  check( "jr r11",                  0x01600008, "jr    r11" )
  check( "jr r29",                  0x03a00008, "jr    r29" )

#-------------------------------------------------------------------------
# Conditional branch instructions
#-------------------------------------------------------------------------

def test_parc_inst_beq():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "beq r1, r2, label_a", 0x10220400, "beq   r01, r02, 0400" )
  check_sym( sym, 0x1000, "beq r1, r2, label_b", 0x1022fc00, "beq   r01, r02, fc00" )

def test_parc_inst_bne():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "bne r1, r2, label_a", 0x14220400, "bne   r01, r02, 0400" )
  check_sym( sym, 0x1000, "bne r1, r2, label_b", 0x1422fc00, "bne   r01, r02, fc00" )

def test_parc_inst_blez():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "blez r1, label_a", 0x18200400, "blez  r01, 0400" )
  check_sym( sym, 0x1000, "blez r1, label_b", 0x1820fc00, "blez  r01, fc00" )

def test_parc_inst_bgtz():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "bgtz r1, label_a", 0x1c200400, "bgtz  r01, 0400" )
  check_sym( sym, 0x1000, "bgtz r1, label_b", 0x1c20fc00, "bgtz  r01, fc00" )

def test_parc_inst_bltz():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "bltz r1, label_a", 0x04200400, "bltz  r01, 0400" )
  check_sym( sym, 0x1000, "bltz r1, label_b", 0x0420fc00, "bltz  r01, fc00" )

def test_parc_inst_bgez():
  sym = { "label_a": 0x00002004, "label_b": 0x00000004 }
  check_sym( sym, 0x1000, "bgez r1, label_a", 0x04210400, "bgez  r01, 0400" )
  check_sym( sym, 0x1000, "bgez r1, label_b", 0x0421fc00, "bgez  r01, fc00" )

#-------------------------------------------------------------------------
# Test invalid formatting
#-------------------------------------------------------------------------

def test_invalid_field_rs():

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu 1, r2, r3" )

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu r32, r2, r3" )

def test_invalid_field_rt():
  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu 1, r2, r3" )

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu r1, r32, r3" )

def test_invalid_field_rd():

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu r1, r2, 3" )

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addu r1, r2, r32" )

def test_invalid_field_imm_zext():
  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "andi r1, r2, 0xfffff" )

def test_invalid_field_imm_sext():

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "addiu r1, r2, -0xffff" )

def test_invalid_field_shamt():

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "sll r1, r2, 32" )

  with pytest.raises( AssertionError ):
    parc_encoding.assemble_inst( {}, 0, "sll r1, r2, -1" )

#-------------------------------------------------------------------------
# mk_section
#-------------------------------------------------------------------------
# Helper function to make a section from a list of words.

def mk_section( name, addr, words ):
  data = bytearray()
  for word in words:
    data.extend(struct.pack("<I",word))

  return SparseMemoryImage.Section( name, addr, data )

#-------------------------------------------------------------------------
# Test assembling code without control flow
#-------------------------------------------------------------------------

def test_assemble_without_ctrl():

  # Create the assembly code string

  asm = \
  """
    ori  r1, r0, 0x2000  # address of src0
    ori  r2, r0, 0x2004  # address of src1
    ori  r3, r0, 0x2008  # address of dest
    lw   r4, 0(r1)       # load src0
    lw   r5, 0(r2)       # load src1
    addu r6, r4, r5      # add two elements together
    sw   r6, 0(r3)       # store dest

    .data
    .word 13             # src0
    .word 15             # src1
    .word 0              # dest
  """

  # Assemble code into a memory image

  mem_image = parc_encoding.assemble( asm )

  # Create a reference text section by using binutils

  text_section = mk_section( ".text", 0x0000,
  [
    0x34012000, # li   at, 0x2000
    0x34022004, # li   v0, 0x2004
    0x34032008, # li   v1, 0x2008
    0x8c240000, # lw   a0, 0(at)
    0x8c450000, # lw   a1, 0(v0)
    0x00853021, # addu a2, a0, a1
    0xac660000, # sw   a2, 0(v1)
  ])

  # Create a reference data section manually

  data_section = mk_section( ".data", 0x2000,
  [
    0x0000000d, # .word 13
    0x0000000f, # .word 13
    0x00000000, # .word 0
  ])

  # Build a sparse memory image

  mem_image_ref = SparseMemoryImage()
  mem_image_ref.add_section( text_section )
  mem_image_ref.add_section( data_section )

  # Check that both sparse memory image are equal

  assert mem_image == mem_image_ref

#-------------------------------------------------------------------------
# Test assembling code with control flow
#-------------------------------------------------------------------------

def test_assemble_with_ctrl():

  # Create the assembly code string

  asm = \
  """
    addiu r1, r0, 4       # array size
    ori   r2, r0, 0x2000  # src0 base pointer
    ori   r3, r0, 0x2010  # src1 base pointer
    ori   r4, r0, 0x2020  # dest base pointer
    addiu r5, r0, 0       # induction variable
  loop:
    lw    r6, 0(r2)       # load src0
    lw    r7, 0(r3)       # load src1
    addu  r8, r6, r7      # addition
    sw    r8, 0(r4)       # store dest
    addiu r2, r2, 4       # pointer bump for src0
    addiu r3, r3, 4       # pointer bump for src1
    addiu r4, r4, 4       # pointer bump for dest
    addiu r5, r5, 1       # increment induction variable
    bne   r5, r1, loop    # loop branch

    .data # addr = 0x2000

    # src0 array
    .word 89320
    .word 30239
    .word  1329
    .word 89021

    # src1 array
    .word 30411
    .word 64198
    .word  4210
    .word 20199

    # dest array
    .word 0
    .word 0
    .word 0
    .word 0
  """

  # Assemble code into a memory image

  mem_image = parc_encoding.assemble( asm )

  # Create a reference text section by using binutils

  text_section = mk_section( ".text", 0x0000,
  [
    0x24010004, # li    at, 4
    0x34022000, # li    v0, 0x2000
    0x34032010, # li    v1, 0x2010
    0x34042020, # li    a0, 0x2020
    0x24050000, # li    a1, 0
    0x8c460000, # lw    a2, 0(v0)
    0x8c670000, # lw    a3, 0(v1)
    0x00c74021, # addu  a4, a2, a3
    0xac880000, # sw    a4, 0(a0)
    0x24420004, # addiu v0, v0, 4
    0x24630004, # addiu v1, v1, 4
    0x24840004, # addiu a0, a0, 4
    0x24a50001, # addiu a1, a1, 1
    0x14a1fff7, # bne   a1, at, 1154 <loop>
  ])

  # Create a reference data section manually

  data_section = mk_section( ".data", 0x2000,
  [
    0x00015ce8, # .word  89320
    0x0000761f, # .word  30239
    0x00000531, # .word   1329
    0x00015bbd, # .word  89021
    0x000076cb, # .word  30411
    0x0000fac6, # .word  64198
    0x00001072, # .word   4210
    0x00004ee7, # .word  20199
    0x00000000, # .word      0
    0x00000000, # .word      0
    0x00000000, # .word      0
    0x00000000, # .word      0
  ])

  # Build a sparse memory image

  mem_image_ref = SparseMemoryImage()
  mem_image_ref.add_section( text_section )
  mem_image_ref.add_section( data_section )

  # Check that both sparse memory image are equal

  assert mem_image == mem_image_ref

#-------------------------------------------------------------------------
# Test assembling code with proc/mngr
#-------------------------------------------------------------------------

def test_assemble_with_proc_mngr():

  # Create the assembly code string

  asm = \
  """
    mfc0 r1, mngr2proc < 0x13
    mfc0 r2, mngr2proc < 0x57
    addu r3, r1, r2    # add two elements together
    mtc0 r3, proc2mngr > 0x6a
    nop
    mfc0 r1, mngr2proc < 0x65
    mfc0 r2, mngr2proc < 0x42
    addu r3, r1, r2    # add two elements together
    mtc0 r3, proc2mngr > 0xa7
  """

  # Assemble code into a memory image

  mem_image = parc_encoding.assemble( asm )

  # Create a reference text section by using binutils

  text_section = mk_section( ".text", 0x0000,
  [
    0x40010800, # mfc0 at, mngr2proc
    0x40020800, # mfc0 v0, mngr2proc
    0x00221821, # addu v1, at,v0
    0x40831000, # mtc0 v1, proc2mngr
    0x00000000, # nop
    0x40010800, # mfc0 at, mngr2proc
    0x40020800, # mfc0 v0, mngr2proc
    0x00221821, # addu v1, at,v0
    0x40831000, # mtc0 v1, proc2mngr
  ])

  # Create a reference mngr2proc section manually

  mngr2proc_section = mk_section( ".mngr2proc", 0x13000,
  [
    0x00000013,
    0x00000057,
    0x00000065,
    0x00000042,
  ])

  # Create a reference proc2mngr section manually

  proc2mngr_section = mk_section( ".proc2mngr", 0x14000,
  [
    0x0000006a,
    0x000000a7,
  ])

  # Build a sparse memory image

  mem_image_ref = SparseMemoryImage()
  mem_image_ref.add_section( text_section      )
  mem_image_ref.add_section( mngr2proc_section )
  mem_image_ref.add_section( proc2mngr_section )

  # Check that both sparse memory image are equal

  assert mem_image == mem_image_ref

#-------------------------------------------------------------------------
# test_parc_inst_fields_reg
#-------------------------------------------------------------------------

def test_parc_inst_fields_reg():
  from parc_encoding import ParcInst, assemble_inst

  inst = ParcInst( assemble_inst( {}, 0, "addu r1, r2, r3" ) )
  assert inst.name == "addu"
  assert inst.rd   == 1
  assert inst.rs   == 2
  assert inst.rt   == 3

#-------------------------------------------------------------------------
# test_parc_inst_fields_imm
#-------------------------------------------------------------------------

def test_parc_inst_fields_imm():
  from parc_encoding import ParcInst, assemble_inst

  inst = ParcInst( assemble_inst( {}, 0, "addiu r30, r31, 0x4eef" ) )
  assert inst.name == "addiu"
  assert inst.rt   == 30
  assert inst.rs   == 31
  assert inst.imm  == 0x4eef

#-------------------------------------------------------------------------
# test_parc_inst_fields_shamt
#-------------------------------------------------------------------------

def test_parc_inst_fields_shamt():
  from parc_encoding import ParcInst, assemble_inst

  inst = ParcInst( assemble_inst( {}, 0, "sll r15, r16, 31" ) )
  assert inst.name  == "sll"
  assert inst.rd    == 15
  assert inst.rt    == 16
  assert inst.shamt == 31

#-------------------------------------------------------------------------
# test_parc_inst_fields_jtarg
#-------------------------------------------------------------------------

def test_parc_inst_fields_jtarg():
  from parc_encoding import ParcInst, assemble_inst

  inst_bits = assemble_inst( {"label":0x1010}, 0x1000, "j label" )
  inst = ParcInst( inst_bits )
  assert inst.name  == "j"
  assert inst.jtarg == 0x00404

