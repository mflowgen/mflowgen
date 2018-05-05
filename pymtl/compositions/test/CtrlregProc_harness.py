#=========================================================================
# test_harness
#=========================================================================
# Includes a test harness that composes a processor, src/sink, and test
# memory, and a run_test function.

import struct

from pymtl import *

from pclib.test import TestSource, TestSink

from proc.NullXcelRTL      import NullXcelRTL
from proc.tinyrv2_encoding import assemble

from mdu  import IntMulDivUnit

from ifcs import CtrlRegReqMsg, CtrlRegRespMsg

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg4B

#=========================================================================
# TestHarness
#=========================================================================
# Use this with pytest parameterize so that the name of the function that
# generates the assembly test ends up as part of the actual test case
# name. Here is an example:
#
#  @pytest.mark.parametrize( "name,gen_test", [
#    asm_test( gen_basic_test  ),
#    asm_test( gen_bypass_test ),
#    asm_test( gen_value_test  ),
#  ])
#  def test( name, gen_test ):
#    run_test( ProcXFL, gen_test )
#

def asm_test( func ):
  name = func.__name__
  if name.startswith("gen_"):
    name = name[4:]
  if name.endswith("_test"):
    name = name[:-5]

  return (name,func)

#=========================================================================
# TestHarness
#=========================================================================

class TestHarness (Model):

  #-----------------------------------------------------------------------
  # constructor
  #-----------------------------------------------------------------------

  def __init__( s, ProcModel, dump_vcd,
                src_delay, sink_delay,
                mem_stall_prob, mem_latency, test_verilog=False ):

    s.ctrlregsrc  = TestSource ( CtrlRegReqMsg(),  [], src_delay  )
    s.ctrlregsink = TestSink   ( CtrlRegRespMsg(), [], sink_delay )

    s.src    = TestSource    ( 32, [], src_delay  )
    s.sink   = TestSink      ( 32, [], sink_delay )
    s.dut    = ProcModel     ()
    s.mdu    = IntMulDivUnit ( 32, 8 )
    s.xcel   = NullXcelRTL   ()
    s.mem    = TestMemory    ( MemMsg4B(), 2, mem_stall_prob, mem_latency )

    # Dump VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.dut = TranslationTool( s.dut, verilator_xinit=test_verilog, verilator_xinit=test_verilog )
      s.mdu  = TranslationTool( s.mdu , verilator_xinit=test_verilog, verilator_xinit=test_verilog )

    # CtrlReg

    s.connect( s.dut.ctrlregreq, s.ctrlregsrc.out    )
    s.connect( s.dut.ctrlregresp, s.ctrlregsink.in_  )

    # Processor <-> Proc/Mngr

    s.connect( s.dut.mngr2proc, s.src.out         )
    s.connect( s.dut.proc2mngr, s.sink.in_        )

    # Processor <-> Mdu
    # This only works for RTL! Don't connect for FL

    try:
      s.connect( s.dut.mdureq,  s.mdu.req )
      s.connect( s.dut.mduresp, s.mdu.resp )
    except AttributeError:
      pass

    # Processor <-> Xcel

    s.connect( s.dut.xcelreq,   s.xcel.xcelreq    )
    s.connect( s.dut.xcelresp,  s.xcel.xcelresp   )

    # Processor <-> Memory

    s.connect( s.dut.imemreq,   s.mem.reqs[0]     )
    s.connect( s.dut.imemresp,  s.mem.resps[0]    )
    s.connect( s.dut.dmemreq,   s.mem.reqs[1]     )
    s.connect( s.dut.dmemresp,  s.mem.resps[1]    )

  #-----------------------------------------------------------------------
  # load_ctrlreg
  #-----------------------------------------------------------------------

  def load_ctrlreg( self ):

    def req_cr( type_, addr, data ):
      msg       = CtrlRegReqMsg()
      msg.type_ = type_
      msg.addr  = addr
      msg.data  = data
      return msg

    def resp_cr( type_, data ):
      msg       = CtrlRegRespMsg()
      msg.type_ = type_
      msg.data  = data
      return msg

    rd = CtrlRegReqMsg.TYPE_READ
    wr = CtrlRegReqMsg.TYPE_WRITE

    #                Req   Req   Req              Resp  Resp
    #                Type  Addr  Data             Type  Data
    msgs = [ req_cr(   rd,    1,    0 ), resp_cr(   rd,    0 ), # read debug
             req_cr(   wr,    1,    1 ), resp_cr(   wr,    0 ), # write debug
             req_cr(   rd,    1,    0 ), resp_cr(   rd,    1 ), # read debug
             req_cr(   wr,    0,    1 ), resp_cr(   wr,    0 ), # go
           ]

    self.ctrlregsrc.src.msgs   = msgs[::2]
    self.ctrlregsink.sink.msgs = msgs[1::2]

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
          self.src.src.msgs.append( Bits(32,bits) )

      # For .proc2mngr sections, copy section into proc2mngr_ref src

      elif section.name == ".proc2mngr":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.sink.sink.msgs.append( Bits(32,bits) )

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
    return s.src.done and s.sink.done and s.ctrlregsrc.done and s.ctrlregsink.done

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return s.src.line_trace()  + " >" + \
           s.ctrlregsrc.line_trace()  + " >" + \
           s.dut.line_trace() + "|" + \
           s.mem.line_trace()  + " > " + \
           s.ctrlregsink.line_trace()  + " >" + \
           s.sink.line_trace()

#=========================================================================
# run_test
#=========================================================================

def run_test( ProcModel, gen_test,
              dump_vcd=None, test_verilog=False,
              src_delay=0, sink_delay=0,
              mem_stall_prob=0, mem_latency=0,
              max_cycles=10000 ):

  # Instantiate and elaborate the model

  model = TestHarness( ProcModel, dump_vcd,
                       src_delay, sink_delay,
                       mem_stall_prob, mem_latency, test_verilog )

  model.vcd_file = dump_vcd
  model.elaborate()

  # Assemble the test program

  mem_image = assemble( gen_test() )

  # Load the program into the model

  model.load( mem_image )

  # Load the CtrlReg messages into the model

  model.load_ctrlreg()

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

