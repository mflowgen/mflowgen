#=========================================================================
# ProcSram.py
#=========================================================================

# import os,sys,inspect

# currentdir = os.path.dirname( os.path.abspath(inspect.getfile(inspect.currentframe())) )
# parentdir  = os.path.dirname( currentdir )
# sys.path.insert(0, parentdir)

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemReqMsg4B, MemRespMsg4B

from sram       import SramWrapper
from proc       import ProcAltRTL
from arbiter    import Funnel, Router

from proc       import CtrlRegReqMsg, CtrlRegRespMsg
from proc.Xcel  import Xcel

class ProcSram( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Use explicit modulename

    s.explicit_modulename = 'ProcSram'

    # Host interface memory req/resp port

    s.host_memreq  = InValRdyBundle ( MemReqMsg4B  )
    s.host_memresp = OutValRdyBundle( MemRespMsg4B )

    # Control register req/resp port

    s.ctrlreg_req  = InValRdyBundle ( CtrlRegReqMsg()  )
    s.ctrlreg_resp = OutValRdyBundle( CtrlRegRespMsg() )

    # host2proc/proc2host req/resp port

    s.mngr2proc = InValRdyBundle ( 32 )
    s.proc2mngr = OutValRdyBundle( 32 )

    # debug bit

    s.debug = OutPort( 1 )

    #---------------------------------------------------------------------
    # Memory Arbiter: Funnel and Router
    #---------------------------------------------------------------------
    # Memory funnel connections
    #
    # - in_[0] : host to memory port
    # - in_[1] : processor data memory port
    # - in_[2] : xcel memory port
    # - out    : sram port A

    s.funnel = Funnel( 3, MemReqMsg4B  )
    s.router = Router( 3, MemRespMsg4B )

    # Connections

    s.connect( s.host_memreq,  s.funnel.in_[0] )
    s.connect( s.host_memresp, s.router.out[0] )

    #---------------------------------------------------------------------
    # SRAM
    #---------------------------------------------------------------------
    # We have 16KB SRAM total. Each sub-array is 4KB.
    # (1024 words per sub-array, 4096 words in total)
    #
    # Connections:
    #
    # - Port A: mem arbiter
    # - Port B: processor instruction memory port

    s.sram = SramWrapper(32, 4096, 4)

    # Connections

    s.connect_pairs(
      s.sram.memreqa,  s.funnel.out,
      s.sram.memrespa, s.router.in_,
    )

    #---------------------------------------------------------------------
    # Processor
    #---------------------------------------------------------------------

    s.proc = m = ProcAltRTL()

    s.connect_pairs(
      s.ctrlreg_req,   m.ctrlreg_req,
      s.ctrlreg_resp,  m.ctrlreg_resp,

      s.mngr2proc,     m.mngr2proc,
      s.proc2mngr,     m.proc2mngr,

      s.sram.memreqb,  m.imemreq,
      s.sram.memrespb, m.imemresp,

      s.funnel.in_[1], m.dmemreq,
      s.router.out[1], m.dmemresp,

      s.debug,         m.debug
    )

    #---------------------------------------------------------------------
    # Sorting (HLS generated) Accelerator
    #---------------------------------------------------------------------

    s.xcel = m = Xcel()

    # xcel <-> memory arbiter

    s.connect( s.funnel.in_[2], m.memreq  )
    s.connect( s.router.out[2], m.memresp )

    # xcel <-> processor

    s.connect( s.proc.xcelreq,  m.xcelreq  )
    s.connect( s.proc.xcelresp, m.xcelresp )

  def line_trace( s ):
    return "{}| > ({}) ({}) | ({}) ({}) ".format( s.proc.line_trace(),
                                                  s.sram.memreqa, s.sram.memrespa,
                                                  s.sram.memreqb, s.sram.memrespb )

