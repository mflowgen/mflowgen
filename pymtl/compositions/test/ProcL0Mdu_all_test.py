#=========================================================================
# ProcL0Mdu_all_test.py
#=========================================================================

import pytest
import random
import struct

from pymtl     import *
from harnesses import asm_test

from pclib.test import TestSource, TestSink
from test import TestMemory
from ifcs import MemMsg
from proc.SparseMemoryImage       import SparseMemoryImage
from proc.tinyrv2_encoding        import assemble

from compositions.ProcL0Mdu import ProcL0Mdu

def run_test( gen_test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0,
              max_cycles=20000 ):

  num_cores = 1
  cacheline_nbits = 256

  # Instantiate and elaborate the model

  model = TestHarness( ProcL0Mdu(), dump_vcd, test_verilog, num_cores, cacheline_nbits,
                       src_delay, sink_delay, mem_stall_prob, mem_latency )

  model.vcd_file = dump_vcd
  model.elaborate()

  # Assemble the test program

  mem_image = assemble( gen_test() )

  # Load the program into the model

  model.load( mem_image )

  # Create a simulator using the simulation tool

  sim = SimulationTool( model )

  # Run the simulation

  print()

  sim.reset()
  while not model.done() and sim.ncycles < max_cycles:
    sim.print_line_trace()
    sim.cycle()

  # print the very last line trace after the last tick

  sim.print_line_trace()

  # Force a test failure if we timed out

  assert sim.ncycles < max_cycles

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

  model.cleanup()

#=========================================================================
# TestHarness
#=========================================================================

class TestHarness( Model ):

  #-----------------------------------------------------------------------
  # constructor
  #-----------------------------------------------------------------------

  def __init__( s, model, dump_vcd, test_verilog, num_cores, cacheline_nbits,
                src_delay, sink_delay, mem_stall_prob, mem_latency ):

    num_memports = 2   # 1 dmem, 1 imem

    s.num_cores = num_cores

    s.src    = TestSource[num_cores]( 32, [], src_delay  )
    s.sink   = TestSink  [num_cores]( 32, [], sink_delay )
    s.model  = model

    if test_verilog:
      s.model = TranslationTool( s.model )

    s.mem    = TestMemory( MemMsg(8,32,cacheline_nbits), num_memports,
                           mem_stall_prob, mem_latency )

    # Composition <-> Memory

    s.connect( s.model.imemreq,  s.mem.reqs[0]     )
    s.connect( s.model.imemresp, s.mem.resps[0]    )

    s.connect( s.model.dmemreq.val, s.mem.reqs[1].val )
    s.connect( s.model.dmemreq.rdy, s.mem.reqs[1].rdy )
    s.connect( s.model.dmemreq.msg.type_,  s.mem.reqs[1].msg.type_  )
    s.connect( s.model.dmemreq.msg.opaque, s.mem.reqs[1].msg.opaque )
    s.connect( s.model.dmemreq.msg.addr,   s.mem.reqs[1].msg.addr   )
    @s.combinational
    def comb_req():
      s.mem.reqs[1].msg.data[0:32].value = s.model.dmemreq.msg.data
      s.mem.reqs[1].msg.len.value = s.model.dmemreq.msg.len
      if s.model.dmemreq.msg.len == 0:
        s.mem.reqs[1].msg.len.value = 4

    s.connect( s.model.dmemresp.val, s.mem.resps[1].val )
    s.connect( s.model.dmemresp.rdy, s.mem.resps[1].rdy )
    s.connect( s.model.dmemresp.msg.type_,  s.mem.resps[1].msg.type_  )
    s.connect( s.model.dmemresp.msg.opaque, s.mem.resps[1].msg.opaque )
    s.connect( s.model.dmemresp.msg.test,   s.mem.resps[1].msg.test   )
    @s.combinational
    def comb_resp():
      s.model.dmemresp.msg.data.value = s.mem.resps[1].msg.data[0:32]
      s.model.dmemresp.msg.len.value = s.mem.resps[1].msg.len
      if s.mem.resps[1].msg.len == 4:
        s.model.dmemresp.msg.len.value = 0

    # Processor <-> Proc/Mngr

    if num_cores == 1:  # Single-core system
      s.connect( s.model.mngr2proc, s.src[0].out  )
      s.connect( s.model.proc2mngr, s.sink[0].in_ )
    else:
      for i in xrange(num_cores):
        s.connect( s.model.mngr2proc[i], s.src[i].out  )
        s.connect( s.model.proc2mngr[i], s.sink[i].in_ )

    # Dump VCD

    if dump_vcd:
      s.model.vcd_file = dump_vcd
      if hasattr(s.model, 'inner'):
        s.model.inner.vcd_file = dump_vcd

  #-----------------------------------------------------------------------
  # load
  #-----------------------------------------------------------------------

  def load( self, mem_image ):

    # Iterate over the sections

    sections = mem_image.get_sections()
    for section in sections:

      # For .mngr2proc sections, copy section into mngr2proc src

      if section.name == ".mngr2proc":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          for i in xrange(self.num_cores):
            self.src[i].src.msgs.append( Bits(32,bits) )

      elif section.name.endswith("_2proc"):
        idx = int( section.name[5:-6], 0 )

        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.src[idx].src.msgs.append( Bits(32,bits) )

      # For .proc2mngr sections, copy section into proc2mngr_ref src

      elif section.name == ".proc2mngr":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]

          for i in xrange(self.num_cores):
            self.sink[i].sink.msgs.append( Bits(32,bits) )

      elif section.name.endswith("_2mngr"):
        idx = int( section.name[5:-6], 0 )

        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.sink[idx].sink.msgs.append( Bits(32,bits) )

      # For all other sections, simply copy them into the memory

      else:
        start_addr = section.addr
        stop_addr  = section.addr + len(section.data)
        self.mem.mem[start_addr:stop_addr] = section.data

  #-----------------------------------------------------------------------
  # cleanup
  #-----------------------------------------------------------------------

  def cleanup( s ):
    del s.mem.mem[:]

  #-----------------------------------------------------------------------
  # done
  #-----------------------------------------------------------------------

  def done( s ):
    return reduce( lambda x,y : x and y,
                  [x.done for x in s.src]+[x.done for x in s.sink] )

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    src_trace  = "|".join( [x.line_trace() for x in s.src]  )
    sink_trace = "|".join( [x.line_trace() for x in s.sink] )
    return src_trace + " >" + \
           ("- " if s.model.stats_en else "  ") + \
           s.model.line_trace() + "|" + \
           s.mem.line_trace()  + " > " + \
           sink_trace

#=========================================================================
# run_test
#=========================================================================


#-------------------------------------------------------------------------
# beq
#-------------------------------------------------------------------------

from proc.test import inst_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_beq.gen_basic_test ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_beq.gen_src0_dep_taken_test    ) ,
  asm_test( inst_beq.gen_src0_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_src1_dep_taken_test    ) ,
  asm_test( inst_beq.gen_src1_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_srcs_dep_taken_test    ) ,
  asm_test( inst_beq.gen_srcs_dep_nottaken_test ) ,
  asm_test( inst_beq.gen_src0_eq_src1_test      ) ,
  asm_test( inst_beq.gen_value_test             ) ,
  asm_test( inst_beq.gen_random_test            ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_beq( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_beq_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_beq.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bne
#-------------------------------------------------------------------------

from proc.test import inst_bne

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bne.gen_basic_test             ),
  asm_test( inst_bne.gen_src0_dep_taken_test    ),
  asm_test( inst_bne.gen_src0_dep_nottaken_test ),
  asm_test( inst_bne.gen_src1_dep_taken_test    ),
  asm_test( inst_bne.gen_src1_dep_nottaken_test ),
  asm_test( inst_bne.gen_srcs_dep_taken_test    ),
  asm_test( inst_bne.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bne.gen_src0_eq_src1_test      ),
  asm_test( inst_bne.gen_value_test             ),
  asm_test( inst_bne.gen_random_test            ),
])
def test_bne( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bne_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bne.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# bge
#-------------------------------------------------------------------------

from proc.test import inst_bge

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bge.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bge.gen_src0_dep_taken_test    ),
  asm_test( inst_bge.gen_src0_dep_nottaken_test ),
  asm_test( inst_bge.gen_src1_dep_taken_test    ),
  asm_test( inst_bge.gen_src1_dep_nottaken_test ),
  asm_test( inst_bge.gen_srcs_dep_taken_test    ),
  asm_test( inst_bge.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bge.gen_src0_eq_src1_test      ),
  asm_test( inst_bge.gen_value_test             ),
  asm_test( inst_bge.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bge( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bge_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bge.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bgeu
#-------------------------------------------------------------------------

from proc.test import inst_bgeu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bgeu.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bgeu.gen_src0_dep_taken_test    ),
  asm_test( inst_bgeu.gen_src0_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_src1_dep_taken_test    ),
  asm_test( inst_bgeu.gen_src1_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_srcs_dep_taken_test    ),
  asm_test( inst_bgeu.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bgeu.gen_src0_eq_src1_test      ),
  asm_test( inst_bgeu.gen_value_test             ),
  asm_test( inst_bgeu.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bgeu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bgeu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bgeu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# blt
#-------------------------------------------------------------------------

from proc.test import inst_blt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_blt.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_blt.gen_src0_dep_taken_test    ),
  asm_test( inst_blt.gen_src0_dep_nottaken_test ),
  asm_test( inst_blt.gen_src1_dep_taken_test    ),
  asm_test( inst_blt.gen_src1_dep_nottaken_test ),
  asm_test( inst_blt.gen_srcs_dep_taken_test    ),
  asm_test( inst_blt.gen_srcs_dep_nottaken_test ),
  asm_test( inst_blt.gen_src0_eq_src1_test      ),
  asm_test( inst_blt.gen_value_test             ),
  asm_test( inst_blt.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_blt( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_blt_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_blt.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# bltu
#-------------------------------------------------------------------------

from proc.test import inst_bltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_bltu.gen_basic_test             ),

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_bltu.gen_src0_dep_taken_test    ),
  asm_test( inst_bltu.gen_src0_dep_nottaken_test ),
  asm_test( inst_bltu.gen_src1_dep_taken_test    ),
  asm_test( inst_bltu.gen_src1_dep_nottaken_test ),
  asm_test( inst_bltu.gen_srcs_dep_taken_test    ),
  asm_test( inst_bltu.gen_srcs_dep_nottaken_test ),
  asm_test( inst_bltu.gen_src0_eq_src1_test      ),
  asm_test( inst_bltu.gen_value_test             ),
  asm_test( inst_bltu.gen_random_test            ),

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_bltu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_bltu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_bltu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3)

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# add
#-------------------------------------------------------------------------

from proc.test import inst_add

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_add.gen_basic_test     ) ,
  asm_test( inst_add.gen_dest_dep_test  ) ,
  asm_test( inst_add.gen_src0_dep_test  ) ,
  asm_test( inst_add.gen_src1_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dep_test  ) ,
  asm_test( inst_add.gen_srcs_dest_test ) ,
  asm_test( inst_add.gen_value_test     ) ,
  asm_test( inst_add.gen_random_test    ) ,
])
def test_add( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_add_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_add.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# sub
#-------------------------------------------------------------------------

from proc.test import inst_sub

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sub.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sub.gen_dest_dep_test  ) ,
  asm_test( inst_sub.gen_src0_dep_test  ) ,
  asm_test( inst_sub.gen_src1_dep_test  ) ,
  asm_test( inst_sub.gen_srcs_dep_test  ) ,
  asm_test( inst_sub.gen_srcs_dest_test ) ,
  asm_test( inst_sub.gen_value_test     ) ,
  asm_test( inst_sub.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sub( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sub_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sub.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# mul
#-------------------------------------------------------------------------

from proc.test import inst_mul

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_mul.gen_dest_dep_test  ) ,
  asm_test( inst_mul.gen_src0_dep_test  ) ,
  asm_test( inst_mul.gen_src1_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dep_test  ) ,
  asm_test( inst_mul.gen_srcs_dest_test ) ,
  asm_test( inst_mul.gen_value_test     ) ,
  asm_test( inst_mul.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_mul( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_mul_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mul.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# mulh
#-------------------------------------------------------------------------

from proc.test import inst_mulh

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulh.gen_basic_test     ) ,
  asm_test( inst_mulh.gen_value_test     ) ,
  asm_test( inst_mulh.gen_random_test    ) ,
])
def test_mulh( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulh_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulh.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# mulhsu
#-------------------------------------------------------------------------

from proc.test import inst_mulhsu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulhsu.gen_basic_test     ) ,
  asm_test( inst_mulhsu.gen_value_test     ) ,
  asm_test( inst_mulhsu.gen_random_test    ) ,
])
def test_mulhsu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulhsu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulhsu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# mulhu
#-------------------------------------------------------------------------

from proc.test import inst_mulhu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mulhu.gen_basic_test     ) ,
  asm_test( inst_mulhu.gen_value_test     ) ,
  asm_test( inst_mulhu.gen_random_test    ) ,
])
def test_mulhu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_mulhu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_mulhu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# div
#-------------------------------------------------------------------------

from proc.test import inst_div

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_div.gen_basic_test     ) ,
  asm_test( inst_div.gen_value_test     ) ,
  asm_test( inst_div.gen_random_test    ) ,
])
def test_div( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_div_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_div.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# divu
#-------------------------------------------------------------------------

from proc.test import inst_divu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_divu.gen_basic_test     ) ,
  asm_test( inst_divu.gen_value_test     ) ,
  asm_test( inst_divu.gen_random_test    ) ,
])
def test_divu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_divu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_divu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# rem
#-------------------------------------------------------------------------

from proc.test import inst_rem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_rem.gen_basic_test     ) ,
  asm_test( inst_rem.gen_value_test     ) ,
  asm_test( inst_rem.gen_random_test    ) ,
])
def test_rem( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_rem_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_rem.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# remu
#-------------------------------------------------------------------------

from proc.test import inst_remu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_remu.gen_basic_test     ) ,
  asm_test( inst_remu.gen_value_test     ) ,
  asm_test( inst_remu.gen_random_test    ) ,
])
def test_remu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_remu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_remu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# and
#-------------------------------------------------------------------------

from proc.test import inst_and

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_and.gen_basic_test     ) ,
  asm_test( inst_and.gen_dest_dep_test  ) ,
  asm_test( inst_and.gen_src0_dep_test  ) ,
  asm_test( inst_and.gen_src1_dep_test  ) ,
  asm_test( inst_and.gen_srcs_dep_test  ) ,
  asm_test( inst_and.gen_srcs_dest_test ) ,
  asm_test( inst_and.gen_value_test     ) ,
  asm_test( inst_and.gen_random_test    ) ,
])
def test_and( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_and_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_and.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# or
#-------------------------------------------------------------------------

from proc.test import inst_or

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_or.gen_basic_test     ) ,
  asm_test( inst_or.gen_dest_dep_test  ) ,
  asm_test( inst_or.gen_src0_dep_test  ) ,
  asm_test( inst_or.gen_src1_dep_test  ) ,
  asm_test( inst_or.gen_srcs_dep_test  ) ,
  asm_test( inst_or.gen_srcs_dest_test ) ,
  asm_test( inst_or.gen_value_test     ) ,
  asm_test( inst_or.gen_random_test    ) ,
])
def test_or( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_or_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_or.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# xor
#-------------------------------------------------------------------------

from proc.test import inst_xor

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xor.gen_basic_test     ) ,
  asm_test( inst_xor.gen_dest_dep_test  ) ,
  asm_test( inst_xor.gen_src0_dep_test  ) ,
  asm_test( inst_xor.gen_src1_dep_test  ) ,
  asm_test( inst_xor.gen_srcs_dep_test  ) ,
  asm_test( inst_xor.gen_srcs_dest_test ) ,
  asm_test( inst_xor.gen_value_test     ) ,
  asm_test( inst_xor.gen_random_test    ) ,
])
def test_xor( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_xor_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_xor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# slt
#-------------------------------------------------------------------------

from proc.test import inst_slt

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slt.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slt.gen_dest_dep_test  ) ,
  asm_test( inst_slt.gen_src0_dep_test  ) ,
  asm_test( inst_slt.gen_src1_dep_test  ) ,
  asm_test( inst_slt.gen_srcs_dep_test  ) ,
  asm_test( inst_slt.gen_srcs_dest_test ) ,
  asm_test( inst_slt.gen_value_test     ) ,
  asm_test( inst_slt.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slt( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slt_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_slt.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sltu
#-------------------------------------------------------------------------

from proc.test import inst_sltu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltu.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sltu.gen_dest_dep_test  ) ,
  asm_test( inst_sltu.gen_src0_dep_test  ) ,
  asm_test( inst_sltu.gen_src1_dep_test  ) ,
  asm_test( inst_sltu.gen_srcs_dep_test  ) ,
  asm_test( inst_sltu.gen_srcs_dest_test ) ,
  asm_test( inst_sltu.gen_value_test     ) ,
  asm_test( inst_sltu.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sltu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sltu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sltu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sra
#-------------------------------------------------------------------------

from proc.test import inst_sra

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sra.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sra.gen_dest_dep_test  ) ,
  asm_test( inst_sra.gen_src0_dep_test  ) ,
  asm_test( inst_sra.gen_src1_dep_test  ) ,
  asm_test( inst_sra.gen_srcs_dep_test  ) ,
  asm_test( inst_sra.gen_srcs_dest_test ) ,
  asm_test( inst_sra.gen_value_test     ) ,
  asm_test( inst_sra.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sra( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sra_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sra.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# srl
#-------------------------------------------------------------------------

from proc.test import inst_srl

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srl.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srl.gen_dest_dep_test  ) ,
  asm_test( inst_srl.gen_src0_dep_test  ) ,
  asm_test( inst_srl.gen_src1_dep_test  ) ,
  asm_test( inst_srl.gen_srcs_dep_test  ) ,
  asm_test( inst_srl.gen_srcs_dest_test ) ,
  asm_test( inst_srl.gen_value_test     ) ,
  asm_test( inst_srl.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srl( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srl_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_srl.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
#-------------------------------------------------------------------------
# sll
#-------------------------------------------------------------------------

from proc.test import inst_sll

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sll.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sll.gen_dest_dep_test  ) ,
  asm_test( inst_sll.gen_src0_dep_test  ) ,
  asm_test( inst_sll.gen_src1_dep_test  ) ,
  asm_test( inst_sll.gen_srcs_dep_test  ) ,
  asm_test( inst_sll.gen_srcs_dest_test ) ,
  asm_test( inst_sll.gen_value_test     ) ,
  asm_test( inst_sll.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sll( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sll_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sll.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# csr
#-------------------------------------------------------------------------

from proc.test import inst_csr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_csr.gen_basic_test      ),
  asm_test( inst_csr.gen_bypass_test     ),
  asm_test( inst_csr.gen_value_test      ),
  asm_test( inst_csr.gen_random_test     ),
  asm_test( inst_csr.gen_core_stats_test ),
])
def test_csr( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_csr_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_csr.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=10, mem_stall_prob=0.5, mem_latency=3)

#-------------------------------------------------------------------------
# jal
#-------------------------------------------------------------------------

from proc.test import inst_jal

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal.gen_basic_test        ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jal.gen_link_dep_test     ) ,
  asm_test( inst_jal.gen_jump_test         ) ,
  asm_test( inst_jal.gen_back_to_back_test ) ,
  asm_test( inst_jal.gen_value_test_0      ) ,
  asm_test( inst_jal.gen_value_test_1      ) ,
  asm_test( inst_jal.gen_value_test_2      ) ,
  asm_test( inst_jal.gen_value_test_3      ) ,
  asm_test( inst_jal.gen_jal_stall_test    ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])

def test_jal( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/
def test_jal_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_jal.gen_jump_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=.5, mem_latency=3 )
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# jalr
#-------------------------------------------------------------------------

from proc.test import inst_jalr

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jalr.gen_basic_test    ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_jalr.gen_link_dep_test ) ,
  asm_test( inst_jalr.gen_jump_test     ) ,
  asm_test( inst_jalr.gen_lsb_test      ) ,
  asm_test( inst_jalr.gen_value_test_0      ) ,
  asm_test( inst_jalr.gen_value_test_1      ) ,
  asm_test( inst_jalr.gen_value_test_2      ) ,
  asm_test( inst_jalr.gen_value_test_3      ) ,

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])

def test_jalr( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_jalr_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_jalr.gen_jump_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

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
  run_test( test, dump_vcd, test_verilog )

def test_lw_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_lw.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sw_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sw.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amoadd_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amoadd.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amoand_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amoand.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amoor_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amoor.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amoswap_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amoswap.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amomin_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amomin.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amominu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amominu.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amomax_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amomax.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amomaxu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amomaxu.gen_random_test, dump_vcd, test_verilog,
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
  run_test( test, dump_vcd, test_verilog )

def test_amoxor_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_amoxor.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# jal_beq
#-------------------------------------------------------------------------

from proc.test import inst_jal_beq

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_jal_beq.gen_basic_test     ) ,
])
def test_jal_beq( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# mul_mem
#-------------------------------------------------------------------------

from proc.test import inst_mul_mem

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_mul_mem.gen_basic_test     ) ,
  asm_test( inst_mul_mem.gen_more_test      ) ,
])
def test_mul_mem( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )


#-------------------------------------------------------------------------
# addi
#-------------------------------------------------------------------------

from proc.test import inst_addi

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_addi.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_addi.gen_dest_dep_test  ) ,
  asm_test( inst_addi.gen_src_dep_test   ) ,
  asm_test( inst_addi.gen_srcs_dest_test ) ,
  asm_test( inst_addi.gen_value_test     ) ,
  asm_test( inst_addi.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_addi( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_addi_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_addi.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# andi
#-------------------------------------------------------------------------

from proc.test import inst_andi

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_andi.gen_basic_test     ) ,
  asm_test( inst_andi.gen_dest_dep_test  ) ,
  asm_test( inst_andi.gen_src_dep_test   ) ,
  asm_test( inst_andi.gen_srcs_dest_test ) ,
  asm_test( inst_andi.gen_value_test     ) ,
  asm_test( inst_andi.gen_random_test    ) ,
])
def test_andi( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_andi_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_andi.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# ori
#-------------------------------------------------------------------------

from proc.test import inst_ori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_ori.gen_basic_test     ) ,
  asm_test( inst_ori.gen_dest_dep_test  ) ,
  asm_test( inst_ori.gen_src_dep_test   ) ,
  asm_test( inst_ori.gen_srcs_dest_test ) ,
  asm_test( inst_ori.gen_value_test     ) ,
  asm_test( inst_ori.gen_random_test    ) ,
])
def test_ori( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_ori_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_ori.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# xori
#-------------------------------------------------------------------------

from proc.test import inst_xori

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_xori.gen_basic_test     ) ,
  asm_test( inst_xori.gen_dest_dep_test  ) ,
  asm_test( inst_xori.gen_src_dep_test   ) ,
  asm_test( inst_xori.gen_srcs_dest_test ) ,
  asm_test( inst_xori.gen_value_test     ) ,
  asm_test( inst_xori.gen_random_test    ) ,
])
def test_xori( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

def test_xori_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_xori.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#-------------------------------------------------------------------------
# slti
#-------------------------------------------------------------------------

from proc.test import inst_slti

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slti.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slti.gen_dest_dep_test  ) ,
  asm_test( inst_slti.gen_src_dep_test   ) ,
  asm_test( inst_slti.gen_srcs_dest_test ) ,
  asm_test( inst_slti.gen_value_test     ) ,
  asm_test( inst_slti.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slti( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slti_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_slti.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# sltiu
#-------------------------------------------------------------------------

from proc.test import inst_sltiu

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_sltiu.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_sltiu.gen_dest_dep_test  ) ,
  asm_test( inst_sltiu.gen_src_dep_test   ) ,
  asm_test( inst_sltiu.gen_srcs_dest_test ) ,
  asm_test( inst_sltiu.gen_value_test     ) ,
  asm_test( inst_sltiu.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_sltiu( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_sltiu_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_sltiu.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# srai
#-------------------------------------------------------------------------

from proc.test import inst_srai

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srai.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srai.gen_dest_dep_test  ) ,
  asm_test( inst_srai.gen_src_dep_test   ) ,
  asm_test( inst_srai.gen_srcs_dest_test ) ,
  asm_test( inst_srai.gen_value_test     ) ,
  asm_test( inst_srai.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srai( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srai_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_srai.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# srli
#-------------------------------------------------------------------------

from proc.test import inst_srli

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_srli.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_srli.gen_dest_dep_test  ) ,
  asm_test( inst_srli.gen_src_dep_test   ) ,
  asm_test( inst_srli.gen_srcs_dest_test ) ,
  asm_test( inst_srli.gen_value_test     ) ,
  asm_test( inst_srli.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_srli( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_srli_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_srli.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# slli
#-------------------------------------------------------------------------

from proc.test import inst_slli

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_slli.gen_basic_test     ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_slli.gen_dest_dep_test  ) ,
  asm_test( inst_slli.gen_src_dep_test   ) ,
  asm_test( inst_slli.gen_srcs_dest_test ) ,
  asm_test( inst_slli.gen_value_test     ) ,
  asm_test( inst_slli.gen_random_test    ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_slli( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_slli_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_slli.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# lui
#-------------------------------------------------------------------------

from proc.test import inst_lui

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_lui.gen_basic_test    ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_lui.gen_dest_dep_test ) ,
  asm_test( inst_lui.gen_value_test    ) ,
  asm_test( inst_lui.gen_random_test   ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_lui( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_lui_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_lui.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

#-------------------------------------------------------------------------
# auipc
#-------------------------------------------------------------------------

from proc.test import inst_auipc

@pytest.mark.parametrize( "name,test", [
  asm_test( inst_auipc.gen_basic_test    ) ,

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to test more complicated
  # scenarios.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  asm_test( inst_auipc.gen_dest_dep_test ) ,
  asm_test( inst_auipc.gen_value_test    ) ,
  asm_test( inst_auipc.gen_random_test   ) ,
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
])
def test_auipc( name, test, dump_vcd, test_verilog ):
  run_test( test, dump_vcd, test_verilog )

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# random stall and delay
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

def test_auipc_rand_delays( dump_vcd, test_verilog ):
  run_test( inst_auipc.gen_random_test, dump_vcd, test_verilog,
            src_delay=3, sink_delay=5, mem_stall_prob=0.5, mem_latency=3 )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
