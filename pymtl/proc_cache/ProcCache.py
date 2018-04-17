#=========================================================================
# ProcCache.py
#=========================================================================

from pymtl               import *
from pclib.ifcs          import InValRdyBundle, OutValRdyBundle
from pclib.ifcs          import MemMsg

from proc.ProcPRTL           import ProcPRTL
from cache.BlockingCachePRTL import BlockingCachePRTL

class ProcCache( Model ):

  def __init__( s ):

    # Parameters

    num_cores       = 1
    opaque_nbits    = 8
    addr_nbits      = 32
    icache_nbytes   = 256
    dcache_nbytes   = 256
    data_nbits      = 32
    cacheline_nbits = 128

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.memifc = MemMsg( opaque_nbits, addr_nbits, cacheline_nbits )

    s.mngr2proc = InValRdyBundle ( 32 )
    s.proc2mngr = OutValRdyBundle( 32 )

    s.imemreq  = OutValRdyBundle( s.memifc.req )
    s.imemresp = InValRdyBundle ( s.memifc.resp )

    s.dmemreq  = OutValRdyBundle( s.memifc.req )
    s.dmemresp = InValRdyBundle ( s.memifc.resp )

    # These ports are for statistics. Basically we want to provide the
    # simulator with some useful signals to let the simulator calculate
    # cache miss rate.

    s.stats_en      = OutPort( 1 )
    s.commit_inst   = OutPort( 1 )

    s.icache_miss   = OutPort( 1 )
    s.icache_access = OutPort( 1 )
    s.dcache_miss   = OutPort( 1 )
    s.dcache_access = OutPort( 1 )

    #---------------------------------------------------------------------
    # Components
    #---------------------------------------------------------------------

    s.proc   = ProcPRTL( num_cores )
    s.icache = BlockingCachePRTL( 0 )
    s.dcache = BlockingCachePRTL( 0 )

    #---------------------------------------------------------------------
    # Connections
    #---------------------------------------------------------------------

    # core id & mngr

    s.connect( s.proc.core_id, 0 )

    s.connect( s.mngr2proc, s.proc.mngr2proc   )
    s.connect( s.proc2mngr, s.proc.proc2mngr   )

    # instruction

    s.connect( s.proc.imemreq,   s.icache.cachereq  )
    s.connect( s.icache.memreq,  s.imemreq  )

    s.connect( s.proc.imemresp,  s.icache.cacheresp )
    s.connect( s.icache.memresp, s.imemresp )

    # data

    s.connect( s.proc.dmemreq,   s.dcache.cachereq  )
    s.connect( s.dcache.memreq,  s.dmemreq  )

    s.connect( s.proc.dmemresp,  s.dcache.cacheresp )
    s.connect( s.dcache.memresp, s.dmemresp )

    # statistics

    s.connect( s.stats_en,    s.proc.stats_en    )
    s.connect( s.commit_inst, s.proc.commit_inst )

    @s.combinational
    def collect_cache_statistics():
      s.icache_miss.value   = s.icache.cacheresp.rdy & s.icache.cacheresp.val & \
                            (~s.icache.cacheresp.msg.test[0])

      s.icache_access.value = s.icache.cachereq.rdy & s.icache.cachereq.val

      s.dcache_miss.value   = s.dcache.cacheresp.rdy & s.dcache.cacheresp.val & \
                            (~s.dcache.cacheresp.msg.test[0])

      s.dcache_access.value = s.dcache.cachereq.rdy & s.dcache.cachereq.val

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return  s.proc.line_trace() \
            + "[" + s.icache.line_trace() + "|" \
            + s.dcache.line_trace() + "]"
