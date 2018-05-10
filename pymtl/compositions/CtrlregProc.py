#=========================================================================
# CtrlregProc.py
#=========================================================================

from pymtl               import *
from pclib.ifcs          import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs                import MemMsg, MduMsg
from ifcs                import CtrlRegMsg

from proc.ProcPRTL       import ProcPRTL
from proc.XcelMsg        import XcelReqMsg, XcelRespMsg
from ctrlreg.CtrlReg     import CtrlReg

class CtrlregProc( Model ):

  def __init__( s ):

    # Parameters

    num_cores       = 1
    opaque_nbits    = 8
    addr_nbits      = 32
    data_nbits      = 32
    cacheline_nbits = 128

    s.memifc     = MemMsg( opaque_nbits, addr_nbits, data_nbits )
    s.mduifc     = MduMsg( 32, 8 )
    s.ctrlregifc = CtrlRegMsg()

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # CtrlReg

    s.debug = OutPort( 1 )

    s.ctrlregreq  = InValRdyBundle ( s.ctrlregifc.req )
    s.ctrlregresp = OutValRdyBundle( s.ctrlregifc.resp )

    # Proc

    s.mngr2proc = InValRdyBundle ( 32 )
    s.proc2mngr = OutValRdyBundle( 32 )

    s.mdureq   = OutValRdyBundle( s.mduifc.req )
    s.mduresp  = InValRdyBundle ( s.mduifc.resp )

    s.imemreq  = OutValRdyBundle( s.memifc.req )
    s.imemresp = InValRdyBundle ( s.memifc.resp )

    s.dmemreq  = OutValRdyBundle( s.memifc.req )
    s.dmemresp = InValRdyBundle ( s.memifc.resp )

    s.xcelreq   = OutValRdyBundle( XcelReqMsg() )
    s.xcelresp  = InValRdyBundle ( XcelRespMsg() )

    #---------------------------------------------------------------------
    # Components
    #---------------------------------------------------------------------

    s.ctrlreg = CtrlReg  ()
    s.proc    = ProcPRTL ( num_cores, reset_freeze = True )

    #---------------------------------------------------------------------
    # Connections
    #---------------------------------------------------------------------

    # core id & mngr

    s.connect( s.proc.core_id, 0 )

    s.connect( s.mngr2proc, s.proc.mngr2proc   )
    s.connect( s.proc2mngr, s.proc.proc2mngr   )

    # mdu

    s.connect( s.mdureq,  s.proc.mdureq   )
    s.connect( s.mduresp, s.proc.mduresp   )

    # instruction

    s.connect( s.imemreq,  s.proc.imemreq   )
    s.connect( s.imemresp, s.proc.imemresp   )

    # data

    s.connect( s.dmemreq,  s.proc.dmemreq   )
    s.connect( s.dmemresp, s.proc.dmemresp   )

    # xcel

    s.connect( s.xcelreq,  s.proc.xcelreq   )
    s.connect( s.xcelresp, s.proc.xcelresp   )

    # Control register <--> proc

    s.connect( s.ctrlreg.go,          s.proc.go    )

    s.connect( s.ctrlreg.stats_en,    s.proc.stats_en    )
    s.connect( s.ctrlreg.commit_inst, s.proc.commit_inst )

    # ctrlreg

    s.connect( s.ctrlreg.req,  s.ctrlregreq )
    s.connect( s.ctrlreg.resp, s.ctrlregresp )

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return "[ " + s.ctrlreg.line_trace() + " ] " + \
           "[ " + s.proc.line_trace()    + " ] "


