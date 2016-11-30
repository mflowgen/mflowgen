#=========================================================================
# ParcProcFL
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemReqMsg4B, MemRespMsg4B
from pclib.fl   import InValRdyQueueAdapter, OutValRdyQueueAdapter
from pclib.fl   import BytesMemPortAdapter

from xcel.XcelMsg  import XcelReqMsg, XcelRespMsg

from parc_encoding  import ParcInst
from parc_semantics import ParcSemantics

class ProcFL( Model ):

  #-----------------------------------------------------------------------
  # Constructor
  #-----------------------------------------------------------------------

  def __init__( s, trace_regs=False ):

    # Dummy ctrl register

    s.ctrlreg_req  = InValRdyBundle ( 37 )
    s.ctrlreg_resp = OutValRdyBundle( 37 )

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

    s.xcelreq     = OutValRdyBundle ( XcelReqMsg()  )
    s.xcelresp    = InValRdyBundle  ( XcelRespMsg() )

    # Memory Proxy

    s.imem        = BytesMemPortAdapter( s.imemreq, s.imemresp )
    s.dmem        = BytesMemPortAdapter( s.dmemreq, s.dmemresp )

    # Proc/Mngr Queue Adapters

    s.mngr2proc_q = InValRdyQueueAdapter  ( s.mngr2proc )
    s.proc2mngr_q = OutValRdyQueueAdapter ( s.proc2mngr )

    # Accelerator Queue Adapters

    s.xcelreq_q   = OutValRdyQueueAdapter ( s.xcelreq  )
    s.xcelresp_q  = InValRdyQueueAdapter  ( s.xcelresp )

    # Construct the ISA semantics object

    s.isa = ParcSemantics( s.dmem,
                           s.mngr2proc_q, s.proc2mngr_q,
                           s.xcelreq_q,   s.xcelresp_q )

    # Copies of pc and inst for line tracing

    s.pc   = Bits( 32, 0x00000000 )
    s.inst = Bits( 32, 0x00000000 )

    # Stats

    s.num_total_inst = 0
    s.num_inst       = 0

    s.trace = " "*29
    s.trace_regs = trace_regs

    s.isa.reset()
    s.isa.R.trace_regs = trace_regs

    #---------------------------------------------------------------------
    # tick_fl
    #---------------------------------------------------------------------

    @s.tick_fl
    def logic():

      try:

        # Update instruction counts

        s.num_total_inst += 1
        if s.isa.stats_en:
          s.num_inst += 1

        # Set trace string in case the fetch yields

        s.trace = " "*29

        # Fetch instruction

        s.pc   = s.isa.PC.uint()
        s.inst = ParcInst( s.imem[ s.pc : s.pc+4 ] )

        # Set trace string in case the execution function yeilds

        s.trace = "#".ljust(29)

        # Execute instruction

        s.isa.execute( s.inst )

        # Trace instruction

        s.trace = "{:0>8x} {:<20}".format( s.pc, s.inst )

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

