#=========================================================================
# harness.py
#=========================================================================

import pytest
import struct

from pymtl                   import *
from pclib.ifcs              import InValRdyBundle, OutValRdyBundle
from pclib.ifcs              import MemReqMsg4B, MemRespMsg4B
from pclib.test              import TestSource, TestSink

# Import from proc

from proc.parc_encoding import assemble
from proc               import SparseMemoryImage
from proc               import CtrlRegReqMsg, CtrlRegRespMsg

from ProcSram           import ProcSram

#=========================================================================
# TestHarness
#=========================================================================

class TestHarness( Model ):

  #-----------------------------------------------------------------------
  # constructor
  #-----------------------------------------------------------------------

  def __init__( s, dut, src_delay, sink_delay, dump_vcd=False, test_verilog=False ):

    # Interface

    s.ctrlreg_req  = InValRdyBundle ( CtrlRegReqMsg()  )
    s.ctrlreg_resp = OutValRdyBundle( CtrlRegRespMsg() )

    s.src    = TestSource( 32, [], src_delay  )
    s.sink   = TestSink  ( 32, [], sink_delay )
    s.proc   = dut

    s.host_src  = TestSource( MemReqMsg4B,  [], src_delay   )
    s.host_sink = TestSink  ( MemRespMsg4B, [], sink_delay  )

    # Dump VCD

    if dump_vcd:
      s.proc.vcd_file = dump_vcd

    # Verilog translation

    s.verilog = test_verilog

    if test_verilog:
      s.proc = TranslationTool( s.proc, enable_blackbox=True, verilator_xinit=test_verilog )

    # Ctrl registers

    s.connect( s.proc.ctrlreg_req,  s.ctrlreg_req  )
    s.connect( s.proc.ctrlreg_resp, s.ctrlreg_resp )

    # Processor <-> Proc/Mngr

    s.connect( s.proc.proc2mngr, s.sink.in_ )

    # Serialize mngr2proc src after host-to-memory src so that it only
    # sends packets after the host_src finishes loading the test program
    # into the DUT memory
    #
    # - only allow mngr2proc.val to go high if host_src is done
    # - only allow mngr2proc.rdy to go high if host_src is done

    s.mngr2proc_val_modified = Wire( 1 )
    s.mngr2proc_rdy_modified = Wire( 1 )

    @s.combinational
    def mngr2proc_val_modified_logic():
      s.mngr2proc_val_modified.value = s.src.out.val        & s.host_src.done
      s.mngr2proc_rdy_modified.value = s.proc.mngr2proc.rdy & s.host_src.done

    s.connect( s.proc.mngr2proc.val,     s.mngr2proc_val_modified )
    s.connect( s.mngr2proc_rdy_modified, s.src.out.rdy            )
    s.connect( s.proc.mngr2proc.msg,     s.src.out.msg            )

    # Host to memory funnel/router

    s.connect( s.proc.host_memreq,  s.host_src.out  )
    s.connect( s.proc.host_memresp, s.host_sink.in_ )

  #-----------------------------------------------------------------------
  # load_memory
  #-----------------------------------------------------------------------
  # Given a SparseMemoryImage, load it to a TestSource, to be written to
  # the memory

  def load_memory( self, mem_image ):

    # Iterate over the sections

    sections = mem_image.get_sections()
    for section in sections:

      # For all other sections, simply copy them into the memory

      req_msgs  = []
      resp_msgs = []

      if not ( section.name == ".mngr2proc" or section.name == ".proc2mngr" ):
        addr     = section.addr
        max_addr = section.addr + len(section.data)
        assert max_addr < 0x4000, \
            'Program too large ({:d}): only 24KB of SRAM is on-chip!'.format( max_addr )
        for i in xrange(0,len(section.data),4):
          addr = section.addr + i
          bits = Bits( 32, struct.unpack_from("<I",buffer(section.data,i,4))[0] )
          self.host_src.src.msgs.append  ( MemReqMsg4B.mk_msg ( type_=1, opaque=0, addr=addr, len_=0, data=bits ) )
          self.host_sink.sink.msgs.append( MemRespMsg4B.mk_msg( type_=1, opaque=0, len_=0, data=0 ) )

  #-----------------------------------------------------------------------
  # load_mngr
  #-----------------------------------------------------------------------

  def load_mngr( self, mem_image ):

    sections = mem_image.get_sections()
    for section in sections:

      if section.name == ".mngr2proc":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.src.src.msgs.append( Bits(32,bits) )

      elif section.name == ".proc2mngr":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.sink.sink.msgs.append( Bits(32,bits) )

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return "{}|{}|{}| >> {} >> |{}|{}|{}".format( s.ctrlreg_req, s.host_src.line_trace(), s.src.line_trace(), s.proc.line_trace(), s.sink.line_trace(), s.host_sink.line_trace(), s.ctrlreg_resp )

  #-----------------------------------------------------------------------
  # done
  #-----------------------------------------------------------------------

  def done( s ):
    return s.src.done and s.sink.done

  #-----------------------------------------------------------------------
  # host_done
  #-----------------------------------------------------------------------

  def host_done( s ):
    return s.host_src.done and s.host_sink.done

#=========================================================================
# run_test
#=========================================================================

def run_test( dut, gen_test, src_delay, sink_delay, dump_vcd, test_verilog, max_cycles ):

  model = TestHarness( dut, src_delay, sink_delay, dump_vcd, test_verilog )
  model.vcd_file = dump_vcd
  model.elaborate()

  # Assemble the test program

  mem_image = assemble( gen_test() )

  # Load the program into the model

  model.load_memory( mem_image )
  model.load_mngr  ( mem_image )

  # Create a simulator using the simulation tool

  sim = SimulationTool( model )

  # Run the simulation

  print()

  sim.reset()

  # helper function to turn on/off go bit

  def go( b ):

    def tick():
      sim.eval_combinational()
      sim.print_line_trace()
      sim.cycle()

    # Prepare request packet

    msg = CtrlRegReqMsg()
    msg.type_ = CtrlRegReqMsg.TYPE_WRITE
    msg.addr  = 0
    msg.data  = b

    model.ctrlreg_req.msg.value  = msg

    model.ctrlreg_req.val.value  = 1
    model.ctrlreg_resp.rdy.value = 1

    # Save this cycle's req rdy signal
    #
    # For some reason, if ctrlreg_req_rdy is set to model.ctrlreg_req.rdy,
    # even though the value is 0 if I print it right here, it keeps
    # getting set back to 1 if I print it after tick() is called. This
    # messes up the manual val/rdy signaling I'm doing.
    #
    # So I am now setting it to model.ctrlreg_req.rdy.uint(), which is an
    # integer and isn't affected by tick().

    ctrlreg_req_rdy = model.ctrlreg_req.rdy.uint()

    # Always tick at least one cycle with val high

    tick()

    # Continue ticking until we see that the transaction occurred in the
    # previous cycle

    while not ctrlreg_req_rdy:
      ctrlreg_req_rdy = model.ctrlreg_req.rdy.uint()
      tick()

    # Lower val the cycle after the transaction occurs

    model.ctrlreg_req.val.value  = 0

    tick()

  go( 0 )

  # now write instructions and data to the memory

  while ( not model.host_done() ) and sim.ncycles < max_cycles:
    sim.print_line_trace()
    sim.cycle()

  # start the processor

  go( 1 )

  while ( not model.done() ) and sim.ncycles < max_cycles:
    sim.print_line_trace()
    sim.cycle()

  # Force a test failure if we timed out

  assert sim.ncycles < max_cycles

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

