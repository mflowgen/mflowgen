#=========================================================================
# ProcRTL_test.py
#=========================================================================

import pytest
import random

from pymtl   import *
from CtrlregProc_harness import *
from compositions.CtrlregProc import CtrlregProc

#-------------------------------------------------------------------------
# lb
#-------------------------------------------------------------------------

from proc.test import inst_lb

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lb.gen_basic_test     ) ,
  asm_test( inst_lb.gen_dest_dep_test  ) ,
  asm_test( inst_lb.gen_base_dep_test  ) ,
  asm_test( inst_lb.gen_srcs_dest_test ) ,
  asm_test( inst_lb.gen_value_test     ) ,
  asm_test( inst_lb.gen_random_test    ) ,
])
def test_lb( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_lb_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_lb.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# lh
#-------------------------------------------------------------------------

from proc.test import inst_lh

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lh.gen_basic_test     ) ,
  asm_test( inst_lh.gen_dest_dep_test  ) ,
  asm_test( inst_lh.gen_base_dep_test  ) ,
  asm_test( inst_lh.gen_srcs_dest_test ) ,
  asm_test( inst_lh.gen_value_test     ) ,
  asm_test( inst_lh.gen_random_test    ) ,
])
def test_lh( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_lh_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_lh.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# lw
#-------------------------------------------------------------------------

from proc.test import inst_lw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lw.gen_basic_test     ) ,
  asm_test( inst_lw.gen_dest_dep_test  ) ,
  asm_test( inst_lw.gen_base_dep_test  ) ,
  asm_test( inst_lw.gen_srcs_dest_test ) ,
  asm_test( inst_lw.gen_value_test     ) ,
  asm_test( inst_lw.gen_random_test    ) ,
])
def test_lw( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_lw_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_lw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# lbu
#-------------------------------------------------------------------------

from proc.test import inst_lbu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lbu.gen_basic_test     ) ,
  asm_test( inst_lbu.gen_dest_dep_test  ) ,
  asm_test( inst_lbu.gen_base_dep_test  ) ,
  asm_test( inst_lbu.gen_srcs_dest_test ) ,
  asm_test( inst_lbu.gen_value_test     ) ,
  asm_test( inst_lbu.gen_random_test    ) ,
])
def test_lbu( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_lbu_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_lbu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# lhu
#-------------------------------------------------------------------------

from proc.test import inst_lhu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lhu.gen_basic_test     ) ,
  asm_test( inst_lhu.gen_dest_dep_test  ) ,
  asm_test( inst_lhu.gen_base_dep_test  ) ,
  asm_test( inst_lhu.gen_srcs_dest_test ) ,
  asm_test( inst_lhu.gen_value_test     ) ,
  asm_test( inst_lhu.gen_random_test    ) ,
])
def test_lhu( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_lhu_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_lhu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sb
#-------------------------------------------------------------------------

from proc.test import inst_sb

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sb.gen_basic_test     ),
  asm_test( inst_sb.gen_dest_dep_test  ),
  asm_test( inst_sb.gen_base_dep_test  ),
  asm_test( inst_sb.gen_src_dep_test   ),
  asm_test( inst_sb.gen_srcs_dep_test  ),
  asm_test( inst_sb.gen_srcs_dest_test ),
  asm_test( inst_sb.gen_value_test     ),
  asm_test( inst_sb.gen_random_test    ),
])
def test_sb( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_sb_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_sb.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sh
#-------------------------------------------------------------------------

from proc.test import inst_sh

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sh.gen_basic_test     ),
  asm_test( inst_sh.gen_dest_dep_test  ),
  asm_test( inst_sh.gen_base_dep_test  ),
  asm_test( inst_sh.gen_src_dep_test   ),
  asm_test( inst_sh.gen_srcs_dep_test  ),
  asm_test( inst_sh.gen_srcs_dest_test ),
  asm_test( inst_sh.gen_value_test     ),
  asm_test( inst_sh.gen_random_test    ),
])
def test_sh( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_sh_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_sh.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sw
#-------------------------------------------------------------------------

from proc.test import inst_sw

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sw.gen_basic_test     ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sw.gen_dest_dep_test  ),
  asm_test( inst_sw.gen_base_dep_test  ),
  asm_test( inst_sw.gen_src_dep_test   ),
  asm_test( inst_sw.gen_srcs_dep_test  ),
  asm_test( inst_sw.gen_srcs_dest_test ),
  asm_test( inst_sw.gen_value_test     ),
  asm_test( inst_sw.gen_random_test    ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sw( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sw_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_sw.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# amoadd
#-------------------------------------------------------------------------

from proc.test import inst_amoadd

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoadd.gen_basic_test     ),
  asm_test( inst_amoadd.gen_value_test     ),
  asm_test( inst_amoadd.gen_random_test    ),
])
def test_amoadd( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amoadd_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amoadd.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amoand
#-------------------------------------------------------------------------

from proc.test import inst_amoand

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoand.gen_basic_test     ),
  asm_test( inst_amoand.gen_value_test     ),
  asm_test( inst_amoand.gen_random_test    ),
])
def test_amoand( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amoand_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amoand.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amoor
#-------------------------------------------------------------------------

from proc.test import inst_amoor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoor.gen_basic_test     ),
  asm_test( inst_amoor.gen_value_test     ),
  asm_test( inst_amoor.gen_random_test    ),
])
def test_amoor( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amoor_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amoor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amoswap
#-------------------------------------------------------------------------

from proc.test import inst_amoswap

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoswap.gen_basic_test     ),
  asm_test( inst_amoswap.gen_value_test     ),
  asm_test( inst_amoswap.gen_random_test    ),
])
def test_amoswap( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amoswap_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amoswap.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amomin
#-------------------------------------------------------------------------

from proc.test import inst_amomin

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amomin.gen_basic_test     ),
  asm_test( inst_amomin.gen_value_test     ),
  asm_test( inst_amomin.gen_random_test    ),
])
def test_amomin( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amomin_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amomin.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amominu
#-------------------------------------------------------------------------

from proc.test import inst_amominu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amominu.gen_basic_test     ),
  asm_test( inst_amominu.gen_value_test     ),
  asm_test( inst_amominu.gen_random_test    ),
])
def test_amominu( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amominu_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amominu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amomax
#-------------------------------------------------------------------------

from proc.test import inst_amomax

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amomax.gen_basic_test     ),
  asm_test( inst_amomax.gen_value_test     ),
  asm_test( inst_amomax.gen_random_test    ),
])
def test_amomax( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amomax_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amomax.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amomaxu
#-------------------------------------------------------------------------

from proc.test import inst_amomaxu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amomaxu.gen_basic_test     ),
  asm_test( inst_amomaxu.gen_value_test     ),
  asm_test( inst_amomaxu.gen_random_test    ),
])
def test_amomaxu( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amomaxu_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amomaxu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# amoxor
#-------------------------------------------------------------------------

from proc.test import inst_amoxor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_amoxor.gen_basic_test     ),
  asm_test( inst_amoxor.gen_value_test     ),
  asm_test( inst_amoxor.gen_random_test    ),
])
def test_amoxor( name, test, dump_vcd, test_verilog ):
  run_test( CtrlregProc, test, dump_vcd, test_verilog )

def test_amoxor_rand_delays( dump_vcd, test_verilog ):
  run_test( CtrlregProc, inst_amoxor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

