#=========================================================================
# MepPymtlTop_test.py
#=========================================================================
#
# This is our top level pymtl design. Eventually this will include proc,
# sram, arbiter (funnel and router), host interface, and xcel. It has 8-bit
# req/ack interface.
#
# For the final tapeout we need a Verilog layer to wrap it.
#

import pytest
import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl             import *

# import from fpga project
from fpga              import SwShim
from fpga.drivers      import ZedDriver

# Import from proc project

from proc.test.harness import asm_test

# Import from top project

from top               import *
from top               import ProcSram

# Import from top_asic (this) project

from harness           import *
from AsicTop           import AsicTop

#-------------------------------------------------------------------------
# Design
#-------------------------------------------------------------------------

def instantiate_dut(dump_vcd, test_verilog):

  asynch_bitwidth = 8

  # rename verilog module name

  dut            = ProcSram()
  hwshim_and_dut = AsicTop( asynch_bitwidth )
  swshim         = SwShim( dut, hwshim_and_dut, asynch_bitwidth,
                           dump_vcd, test_verilog ) # RTL version

  return swshim

def cleanup( dut ):
  # for asic this is uncessary
  # dut.dut.close()
  pass

#-------------------------------------------------------------------------
# rimm test cases
#-------------------------------------------------------------------------

from proc.test import inst_addiu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addiu.gen_basic_test     ),
  asm_test( inst_addiu.gen_dest_byp_test  ),
  asm_test( inst_addiu.gen_src_byp_test   ),
  asm_test( inst_addiu.gen_srcs_dest_test ),
  asm_test( inst_addiu.gen_value_test     ),
  asm_test( inst_addiu.gen_random_test    ),

])
def test_addiu( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_andi

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_andi.gen_dest_byp_test  ),
  asm_test( inst_andi.gen_src_byp_test   ),
  asm_test( inst_andi.gen_srcs_dest_test ),
  asm_test( inst_andi.gen_value_test     ),
  asm_test( inst_andi.gen_random_test    ),
])
def test_andi( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_lui

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lui.gen_basic_test     ),
  asm_test( inst_lui.gen_dest_byp_test  ),
  asm_test( inst_lui.gen_value_test     ),
  asm_test( inst_lui.gen_random_test    ),
])
def test_lui( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_ori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_ori.gen_basic_test     ),
  asm_test( inst_ori.gen_dest_byp_test  ),
  asm_test( inst_ori.gen_src_byp_test   ),
  asm_test( inst_ori.gen_srcs_dest_test ),
  asm_test( inst_ori.gen_value_test     ),
  asm_test( inst_ori.gen_random_test    ),
])
def test_ori( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sll

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sll.gen_basic_test     ),
  asm_test( inst_sll.gen_dest_byp_test  ),
  asm_test( inst_sll.gen_src_byp_test   ),
  asm_test( inst_sll.gen_srcs_dest_test ),
  asm_test( inst_sll.gen_value_test     ),
  asm_test( inst_sll.gen_random_test    ),
])
def test_sll( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_slti

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slti.gen_basic_test     ),
  asm_test( inst_slti.gen_dest_byp_test  ),
  asm_test( inst_slti.gen_src_byp_test   ),
  asm_test( inst_slti.gen_srcs_dest_test ),
  asm_test( inst_slti.gen_value_test     ),
  asm_test( inst_slti.gen_random_test    ),

])
def test_slti( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sltiu
@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltiu.gen_basic_test     ),
  asm_test( inst_sltiu.gen_dest_byp_test  ),
  asm_test( inst_sltiu.gen_src_byp_test   ),
  asm_test( inst_sltiu.gen_srcs_dest_test ),
  asm_test( inst_sltiu.gen_value_test     ),
  asm_test( inst_sltiu.gen_random_test    ),
])
def test_sltiu( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sra
@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sra.gen_basic_test     ),
  asm_test( inst_sra.gen_dest_byp_test  ),
  asm_test( inst_sra.gen_src_byp_test   ),
  asm_test( inst_sra.gen_srcs_dest_test ),
  asm_test( inst_sra.gen_value_test     ),
  asm_test( inst_sra.gen_random_test    ),
])
def test_sra( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_srl

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srl.gen_basic_test     ),
  asm_test( inst_srl.gen_dest_byp_test  ),
  asm_test( inst_srl.gen_src_byp_test   ),
  asm_test( inst_srl.gen_srcs_dest_test ),
  asm_test( inst_srl.gen_value_test     ),
  asm_test( inst_srl.gen_random_test    ),
])
def test_srl( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_xori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xori.gen_basic_test     ),
  asm_test( inst_xori.gen_dest_byp_test  ),
  asm_test( inst_xori.gen_src_byp_test   ),
  asm_test( inst_xori.gen_srcs_dest_test ),
  asm_test( inst_xori.gen_value_test     ),
  asm_test( inst_xori.gen_random_test    ),
])
def test_xori( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# rr test cases
#-------------------------------------------------------------------------

from proc.test import inst_addu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addu.gen_basic_test     ),
  asm_test( inst_addu.gen_dest_byp_test  ),
  asm_test( inst_addu.gen_src0_byp_test  ),
  asm_test( inst_addu.gen_src1_byp_test  ),
  asm_test( inst_addu.gen_srcs_byp_test  ),
  asm_test( inst_addu.gen_srcs_dest_test ),
  asm_test( inst_addu.gen_value_test     ),
  asm_test( inst_addu.gen_random_test    ),
])
def test_addu( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_and

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_and.gen_basic_test     ),
  asm_test( inst_and.gen_dest_byp_test  ),
  asm_test( inst_and.gen_src0_byp_test  ),
  asm_test( inst_and.gen_src1_byp_test  ),
  asm_test( inst_and.gen_srcs_byp_test  ),
  asm_test( inst_and.gen_srcs_dest_test ),
  asm_test( inst_and.gen_value_test     ),
  asm_test( inst_and.gen_random_test    ),
])
def test_and( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_nor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_nor.gen_basic_test     ),
  asm_test( inst_nor.gen_dest_byp_test  ),
  asm_test( inst_nor.gen_src0_byp_test  ),
  asm_test( inst_nor.gen_src1_byp_test  ),
  asm_test( inst_nor.gen_srcs_byp_test  ),
  asm_test( inst_nor.gen_srcs_dest_test ),
  asm_test( inst_nor.gen_value_test     ),
  asm_test( inst_nor.gen_random_test    ),

])
def test_nor( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_or

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_or.gen_basic_test     ),
  asm_test( inst_or.gen_dest_byp_test  ),
  asm_test( inst_or.gen_src0_byp_test  ),
  asm_test( inst_or.gen_src1_byp_test  ),
  asm_test( inst_or.gen_srcs_byp_test  ),
  asm_test( inst_or.gen_srcs_dest_test ),
  asm_test( inst_or.gen_value_test     ),
  asm_test( inst_or.gen_random_test    ),

])
def test_or( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sllv

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sllv.gen_basic_test     ),
  asm_test( inst_sllv.gen_dest_byp_test  ),
  asm_test( inst_sllv.gen_src0_byp_test  ),
  asm_test( inst_sllv.gen_src1_byp_test  ),
  asm_test( inst_sllv.gen_srcs_byp_test  ),
  asm_test( inst_sllv.gen_srcs_dest_test ),
  asm_test( inst_sllv.gen_value_test     ),
  asm_test( inst_sllv.gen_random_test    ),

])
def test_sllv( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_slt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slt.gen_basic_test     ),
  asm_test( inst_slt.gen_dest_byp_test  ),
  asm_test( inst_slt.gen_src0_byp_test  ),
  asm_test( inst_slt.gen_src1_byp_test  ),
  asm_test( inst_slt.gen_srcs_byp_test  ),
  asm_test( inst_slt.gen_srcs_dest_test ),
  asm_test( inst_slt.gen_value_test     ),
  asm_test( inst_slt.gen_random_test    ),

])
def test_slt( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltu.gen_basic_test     ),
  asm_test( inst_sltu.gen_dest_byp_test  ),
  asm_test( inst_sltu.gen_src0_byp_test  ),
  asm_test( inst_sltu.gen_src1_byp_test  ),
  asm_test( inst_sltu.gen_srcs_byp_test  ),
  asm_test( inst_sltu.gen_srcs_dest_test ),
  asm_test( inst_sltu.gen_value_test     ),
  asm_test( inst_sltu.gen_random_test    ),
])
def test_sltu( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_srav

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srav.gen_basic_test     ),
  asm_test( inst_srav.gen_dest_byp_test  ),
  asm_test( inst_srav.gen_src0_byp_test  ),
  asm_test( inst_srav.gen_src1_byp_test  ),
  asm_test( inst_srav.gen_srcs_byp_test  ),
  asm_test( inst_srav.gen_srcs_dest_test ),
  asm_test( inst_srav.gen_value_test     ),
  asm_test( inst_srav.gen_random_test    ),

])
def test_srav( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_srlv

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srlv.gen_basic_test     ),
  asm_test( inst_srlv.gen_dest_byp_test  ),
  asm_test( inst_srlv.gen_src0_byp_test  ),
  asm_test( inst_srlv.gen_src1_byp_test  ),
  asm_test( inst_srlv.gen_srcs_byp_test  ),
  asm_test( inst_srlv.gen_srcs_dest_test ),
  asm_test( inst_srlv.gen_value_test     ),
  asm_test( inst_srlv.gen_random_test    ),

])
def test_srlv( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_subu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_subu.gen_basic_test     ),
  asm_test( inst_subu.gen_dest_byp_test  ),
  asm_test( inst_subu.gen_src0_byp_test  ),
  asm_test( inst_subu.gen_src1_byp_test  ),
  asm_test( inst_subu.gen_srcs_byp_test  ),
  asm_test( inst_subu.gen_srcs_dest_test ),
  asm_test( inst_subu.gen_value_test     ),
  asm_test( inst_subu.gen_random_test    ),


])
def test_subu( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_xor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xor.gen_basic_test     ),
  asm_test( inst_xor.gen_dest_byp_test  ),
  asm_test( inst_xor.gen_src0_byp_test  ),
  asm_test( inst_xor.gen_src1_byp_test  ),
  asm_test( inst_xor.gen_srcs_byp_test  ),
  asm_test( inst_xor.gen_srcs_dest_test ),
  asm_test( inst_xor.gen_value_test     ),
  asm_test( inst_xor.gen_random_test    ),
])
def test_xor( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_mul

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul.gen_basic_test     ),
  asm_test( inst_mul.gen_dest_byp_test  ),
  asm_test( inst_mul.gen_src0_byp_test  ),
  asm_test( inst_mul.gen_src1_byp_test  ),
  asm_test( inst_mul.gen_srcs_byp_test  ),
  asm_test( inst_mul.gen_srcs_dest_test ),
  asm_test( inst_mul.gen_value_test     ),
  asm_test( inst_mul.gen_random_test    ),

])
def test_mul( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# branch test cases
#-------------------------------------------------------------------------

from proc.test import inst_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_beq.gen_basic_test             ),
  asm_test( inst_beq.gen_src0_byp_taken_test    ),
  asm_test( inst_beq.gen_src0_byp_nottaken_test ),
  asm_test( inst_beq.gen_src1_byp_taken_test    ),
  asm_test( inst_beq.gen_src1_byp_nottaken_test ),
  asm_test( inst_beq.gen_srcs_byp_taken_test    ),
  asm_test( inst_beq.gen_srcs_byp_nottaken_test ),
  asm_test( inst_beq.gen_src0_eq_src1_test      ),
  asm_test( inst_beq.gen_value_test             ),
  asm_test( inst_beq.gen_random_test            ),
])
def test_beq( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_bgez

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgez.gen_basic_test            ),
  asm_test( inst_bgez.gen_src_byp_taken_test    ),
  asm_test( inst_bgez.gen_src_byp_nottaken_test ),
  asm_test( inst_bgez.gen_value_test            ),
  asm_test( inst_bgez.gen_random_test           ),

])
def test_bgez( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_bgtz

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgtz.gen_basic_test            ),
  asm_test( inst_bgtz.gen_src_byp_taken_test    ),
  asm_test( inst_bgtz.gen_src_byp_nottaken_test ),
  asm_test( inst_bgtz.gen_value_test            ),
  asm_test( inst_bgtz.gen_random_test           ),
])
def test_bgtz( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_blez

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_blez.gen_basic_test            ),
  asm_test( inst_blez.gen_src_byp_taken_test    ),
  asm_test( inst_blez.gen_src_byp_nottaken_test ),
  asm_test( inst_blez.gen_value_test            ),
  asm_test( inst_blez.gen_random_test           ),
])
def test_blez( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_bltz

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bltz.gen_basic_test            ),
  asm_test( inst_bltz.gen_src_byp_taken_test    ),
  asm_test( inst_bltz.gen_src_byp_nottaken_test ),
  asm_test( inst_bltz.gen_value_test            ),
  asm_test( inst_bltz.gen_random_test           ),
])
def test_bltz( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_bne

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bne.gen_basic_test             ),
  asm_test( inst_bne.gen_src0_byp_taken_test    ),
  asm_test( inst_bne.gen_src0_byp_nottaken_test ),
  asm_test( inst_bne.gen_src1_byp_taken_test    ),
  asm_test( inst_bne.gen_src1_byp_nottaken_test ),
  asm_test( inst_bne.gen_srcs_byp_taken_test    ),
  asm_test( inst_bne.gen_srcs_byp_nottaken_test ),
  asm_test( inst_bne.gen_src0_eq_src1_test      ),
  asm_test( inst_bne.gen_value_test             ),
  asm_test( inst_bne.gen_random_test            ),
])
def test_bne( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# jump test cases
#-------------------------------------------------------------------------

from proc.test import inst_j

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_j.gen_basic_test             ),
  asm_test( inst_j.gen_jump_test              ),
])
def test_j( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_jal

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal.gen_basic_test    ),
  asm_test( inst_jal.gen_link_byp_test ),
  asm_test( inst_jal.gen_jump_test     ),
])
def test_jal( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_jr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jr.gen_basic_test   ),
  asm_test( inst_jr.gen_src_byp_test ),
  asm_test( inst_jr.gen_jump_test    ),
])
def test_jr( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# mngr
#-------------------------------------------------------------------------

from proc.test import inst_mngr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mngr.gen_basic_test  ),
  asm_test( inst_mngr.gen_bypass_test ),
  asm_test( inst_mngr.gen_value_test  ),
  asm_test( inst_mngr.gen_random_test ),
])
def test_mngr( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# mem test cases
#-------------------------------------------------------------------------

from proc.test import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ),
  asm_test( inst_lw.gen_dest_byp_test  ),
  asm_test( inst_lw.gen_base_byp_test   ),
  asm_test( inst_lw.gen_srcs_dest_test ),
  asm_test( inst_lw.gen_value_test     ),
  asm_test( inst_lw.gen_random_test    ),
])
def test_lw( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

from proc.test import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_basic_test     ),
  asm_test( inst_sw.gen_dest_byp_test  ),
  asm_test( inst_sw.gen_base_byp_test  ),
  asm_test( inst_sw.gen_src_byp_test   ),
  asm_test( inst_sw.gen_srcs_byp_test  ),
  asm_test( inst_sw.gen_srcs_dest_test ),
  asm_test( inst_sw.gen_value_test     ),
  asm_test( inst_sw.gen_random_test    ),
])
def test_sw( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 200000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# xcel test cases
#-------------------------------------------------------------------------

from proc.test import inst_xcel

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xcel.gen_basic_sort_test  ),
  asm_test( inst_xcel.gen_random_sort_test ),
])
def test_xcel( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 150000, gen_ref )
  cleanup( dut )

#-------------------------------------------------------------------------
# random asm test cases
#-------------------------------------------------------------------------

from proc.test import inst_random

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_random.gen_random_asm_test  ),
])
def test_random( name, test, dump_vcd, test_verilog, gen_ref ):
  dut = instantiate_dut(dump_vcd, test_verilog)
  run_test( dut, test, 0, 0, dump_vcd, test_verilog, 200000, gen_ref )
  cleanup( dut )
