#=========================================================================
# ProcL0Mdu.py
#=========================================================================

from pymtl               import *
from pclib.ifcs          import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs                import MemMsg, MduMsg

from proc.ProcPRTL           import ProcPRTL
from instbuffer.InstBuffer   import InstBuffer
from mdu.IntMulDivUnit       import IntMulDivUnit

from adapters.HostAdapter    import HostAdapter

class ProcL0Mdu( Model ):

  def __init__( s ):

    s.explicit_modulename = "ProcL0Mdu"

    # Parameters

    num_cores       = 1
    opaque_nbits    = 8
    addr_nbits      = 32
    data_nbits      = 32
    cacheline_nbits = 256

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.L0_disable = InPort( 1 )
    s.host_en    = InPort( 1 )

    s.imemifc = MemMsg( opaque_nbits, addr_nbits, cacheline_nbits )
    s.dmemifc = MemMsg( opaque_nbits, addr_nbits, data_nbits )
    s.mduifc  = MduMsg( 32, 8 )

    s.mngr2proc = InValRdyBundle ( 32 )
    s.proc2mngr = OutValRdyBundle( 32 )

    s.imemreq  = OutValRdyBundle( s.imemifc.req )
    s.imemresp = InValRdyBundle ( s.imemifc.resp )

    s.dmemreq  = OutValRdyBundle( s.dmemifc.req )
    s.dmemresp = InValRdyBundle ( s.dmemifc.resp )

    s.host_mdureq  = InValRdyBundle( s.mduifc.req )
    s.host_mduresp = InValRdyBundle( s.mduifc.resp )

    # These ports are for statistics. Basically we want to provide the
    # simulator with some useful signals to let the simulator calculate
    # cache miss rate.

    s.stats_en      = OutPort( 1 )
    s.commit_inst   = OutPort( 1 )

    #---------------------------------------------------------------------
    # Components
    #---------------------------------------------------------------------

    s.proc = ProcPRTL( num_cores )
    s.mdu  = IntMulDivUnit( 32, 8 )
    s.l0i  = InstBuffer( 2, cacheline_nbits/8 )

    s.mdu_adapter = HostAdapter( req=s.mdu.req, resp=s.mdu.resp )

    #---------------------------------------------------------------------
    # Connections
    #---------------------------------------------------------------------

    # Shunning: these signals should really come from host

    s.connect( s.l0i.L0_disable, s.L0_disable )
    s.connect( s.mdu_adapter.host_en, s.host_en )

    # core id & mngr

    s.connect( s.proc.core_id, 0 )

    s.connect( s.mngr2proc, s.proc.mngr2proc   )
    s.connect( s.proc2mngr, s.proc.proc2mngr   )

    # mdu

    s.connect( s.host_mdureq,  s.mdu_adapter.hostreq  )
    s.connect( s.host_mduresp, s.mdu_adapter.hostresp )
    s.connect( s.proc.mdureq,  s.mdu_adapter.realreq  )
    s.connect( s.proc.mduresp, s.mdu_adapter.realresp )

    s.connect( s.mdu_adapter.req,  s.mdu.req  )
    s.connect( s.mdu_adapter.resp, s.mdu.resp )


    # instruction

    s.connect( s.proc.imemreq,  s.l0i.buffreq  )
    s.connect( s.l0i.memreq,    s.imemreq  )

    s.connect( s.proc.imemresp, s.l0i.buffresp )
    s.connect( s.l0i.memresp,   s.imemresp )

    # data

    s.connect( s.proc.dmemreq,   s.dmemreq  )
    s.connect( s.proc.dmemresp,  s.dmemresp )

    # statistics

    s.connect( s.stats_en,    s.proc.stats_en    )
    s.connect( s.commit_inst, s.proc.commit_inst )

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return  s.proc.line_trace() \
            + "|" + s.l0i.line_trace() + "|" \
            + s.mdu.line_trace() + "]"
