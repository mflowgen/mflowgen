#=========================================================================
# TinyRV2ProcFL
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.fl   import InValRdyQueueAdapter, OutValRdyQueueAdapter

from tinyrv2_encoding  import TinyRV2Inst
from tinyrv2_semantics import TinyRV2Semantics

from XcelMsg import XcelReqMsg, XcelRespMsg

# BRGTC2 custom MemMsg/BytesMemAdapter modified for RISC-V 32

from ifcs import BytesMemPortAdapter
from ifcs import MemReqMsg4B, MemRespMsg4B

class ProcFL( Model ):

  #-----------------------------------------------------------------------
  # Constructor
  #-----------------------------------------------------------------------

  def __init__( s, trace_regs=False, num_cores=1 ):

    # Stats enable port

    s.stats_en    = OutPort ( 1 )

    # Coreid

    s.core_id     = InPort ( 32 )

    # Proc/Mngr Interface

    s.mngr2proc   = InValRdyBundle  ( 32 )
    s.proc2mngr   = OutValRdyBundle ( 32 )

    # Instruction Memory Request/Response Interface

    s.imemreq     = OutValRdyBundle ( MemReqMsg4B  )
    s.imemresp    = InValRdyBundle  ( MemRespMsg4B )

    # Data Memory Request/Response Interface

    s.dmemreq     = OutValRdyBundle ( MemReqMsg4B  )
    s.dmemresp    = InValRdyBundle  ( MemRespMsg4B )

    # Accelerator Request/Response Interface

    s.xcelreq     = OutValRdyBundle ( XcelReqMsg() )
    s.xcelresp    = InValRdyBundle  ( XcelRespMsg() )

    # Memory Proxy

    s.imem        = BytesMemPortAdapter( s.imemreq, s.imemresp )
    s.dmem        = BytesMemPortAdapter( s.dmemreq, s.dmemresp )

    # Proc/Mngr Queue Adapters

    s.mngr2proc_q = InValRdyQueueAdapter  ( s.mngr2proc )
    s.proc2mngr_q = OutValRdyQueueAdapter ( s.proc2mngr )

    # Proc/Xcel Queue Adapters

    s.xcelreq_q   = OutValRdyQueueAdapter ( s.xcelreq  )
    s.xcelresp_q  = InValRdyQueueAdapter  ( s.xcelresp )

    # Construct the ISA semantics object

    s.isa = TinyRV2Semantics( s.dmem, s.mngr2proc_q, s.proc2mngr_q,
                              s.xcelreq_q, s.xcelresp_q,
                              num_cores=num_cores )

    # Copies of pc and inst for line tracing

    s.pc   = Bits( 32, 0x00000200 )
    s.inst = Bits( 32, 0x00000000 )

    # Stats

    s.num_total_inst = 0
    s.num_inst       = 0

    s.trace = " "*29
    s.trace_regs = trace_regs

    s.isa.reset()
    s.isa.R.trace_regs = trace_regs

    # used for counting commited insts

    s.commit_inst = OutPort( 1 )

    #---------------------------------------------------------------------
    # tick_fl
    #---------------------------------------------------------------------

    @s.tick_fl
    def logic():

      try:

        # Update instruction counts, stats_en, and core_id value

        s.num_total_inst += 1
        s.stats_en.next = s.isa.stats_en
        s.isa.coreid = s.core_id

        if s.isa.stats_en:
          s.num_inst += 1
        s.commit_inst.next = 0

        # Set trace string in case the fetch yields

        s.trace = " "*34

        # Fetch instruction

        s.pc   = s.isa.PC.uint()
        s.inst = TinyRV2Inst( s.imem[ s.pc : s.pc+4 ] )

        # Set trace string in case the execution function yeilds

        s.trace = "#".ljust(34)

        # Execute instruction

        s.isa.execute( s.inst )
        s.commit_inst.next = 1

        # Trace instruction

        s.trace = "{:0>8x} {: <25}".format( s.pc, s.inst )

      except:
        print( "Unexpected error at PC={:0>8x}!".format(s.pc) )
        raise

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):
    if s.trace_regs:
      return s.trace + "  " + s.isa.R.trace_regs_str()
    else:
      return s.trace

