#=========================================================================
# Chansey.py
#=========================================================================

from pymtl                      import *
from pclib.ifcs                 import InValRdyBundle, OutValRdyBundle

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs                       import CtrlRegMsg, MemMsg, MduMsg
from ifcs.FpuMsg                import FpuReqMsg, FpuRespMsg

from ctrlreg.CtrlReg            import CtrlReg
from proc.ProcPRTL              import ProcPRTL
from proc.NullXcelRTL           import NullXcelRTL
from mdu.IntMulDivUnit          import IntMulDivUnit
from instbuffer.InstBuffer      import InstBuffer

from cache.BlockingCachePRTL    import BlockingCachePRTL

from networks.Funnel            import Funnel
from networks.Router            import Router
from adapters.HostAdapter       import HostAdapter

from bloom.BloomFilterXcel      import BloomFilterXcel
from mem_coalescer.MemCoalescer import MemCoalescer

from fpu.DesignWareFloatingPointUnit import DesignWareFloatingPointUnit

class Chansey( Model ):

  def __init__( s, num_cores=4, mopaque_nbits=8, addr_nbits=32,
                   word_nbits=32, cacheline_nbits=128 ):

    s.explicit_modulename = "Chansey"

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Interface types

    s.ctrlregifc     = CtrlRegMsg()
    s.proc_cache_ifc = MemMsg( mopaque_nbits, addr_nbits, word_nbits )
    s.cache_mem_ifc  = MemMsg( mopaque_nbits, addr_nbits, cacheline_nbits )
    s.proc_mdu_ifc   = MduMsg( 32, 8 )

    # Actual port bundles that goes out of this composition
    # There are ten bundles going out:
    # - 1 x ctrlreg req/resp
    # - 4 x mngrproc/proc2mngr
    # - 1 x host_mdu    req/resp
    # - 1 x host_icache req/resp
    # - 1 x host_dcache req/resp
    # - 1 x actual imem req/resp
    # - 1 x actual dmem req/resp

    s.ctrlregreq      = InValRdyBundle ( s.ctrlregifc.req  )
    s.ctrlregresp     = OutValRdyBundle( s.ctrlregifc.resp )

    # These ports should be an array of port bundles, but the host
    # interface uses reflection and breaks with an array. So we are
    # flattening these out here.

    s.mngr2proc_0    = InValRdyBundle ( 32 )
    s.proc2mngr_0    = OutValRdyBundle( 32 )
    s.mngr2proc_1    = InValRdyBundle ( 32 )
    s.proc2mngr_1    = OutValRdyBundle( 32 )
    s.mngr2proc_2    = InValRdyBundle ( 32 )
    s.proc2mngr_2    = OutValRdyBundle( 32 )
    s.mngr2proc_3    = InValRdyBundle ( 32 )
    s.proc2mngr_3    = OutValRdyBundle( 32 )

    s.imemreq         = OutValRdyBundle( s.cache_mem_ifc.req  )
    s.imemresp        = InValRdyBundle ( s.cache_mem_ifc.resp )

    s.dmemreq         = OutValRdyBundle( s.cache_mem_ifc.req  )
    s.dmemresp        = InValRdyBundle ( s.cache_mem_ifc.resp )

    s.host_mdureq     = InValRdyBundle ( s.proc_mdu_ifc.req  )
    s.host_mduresp    = OutValRdyBundle( s.proc_mdu_ifc.resp )

    s.host_icachereq  = InValRdyBundle ( s.cache_mem_ifc.req  ) # We have L0i!!!
    s.host_icacheresp = OutValRdyBundle( s.cache_mem_ifc.resp )

    s.host_dcachereq  = InValRdyBundle ( s.proc_cache_ifc.req  )
    s.host_dcacheresp = OutValRdyBundle( s.proc_cache_ifc.resp )

    # These ports are for the ctrl register

    s.debug = OutPort( 1 )

    #---------------------------------------------------------------------
    # Components
    #---------------------------------------------------------------------

    # Shared L1I

    s.icache         = BlockingCachePRTL( 0, wide_access = True )
    s.icache_adapter = HostAdapter( req=s.icache.cachereq, resp=s.icache.cacheresp )

    # N L0is <-> icache_coalescer <-> 1 cache
    s.icache_coalescer  = MemCoalescer( num_cores, s.cache_mem_ifc,
                                        addr_nbits, cacheline_nbits,
                                        mopaque_nbits )

    # Shared L1D

    s.dcache         = BlockingCachePRTL( 0, wide_access = False )
    s.dcache_adapter = HostAdapter( req=s.dcache.cachereq, resp=s.dcache.cacheresp )

    s.net_dcachereq  = Funnel( num_cores, s.proc_cache_ifc.req  )  # N cores - to - 1 cache
    s.net_dcacheresp = Router( num_cores, s.proc_cache_ifc.resp )  # 1 cache - to - N cores

    # Shared Mdu

    s.mdu         = IntMulDivUnit( 32, 8 )
    s.mdu_adapter = HostAdapter( req=s.mdu.req, resp=s.mdu.resp )

    s.net_mdureq  = Funnel( num_cores, s.proc_mdu_ifc.req )   # N cores - to - 1 cache
    s.net_mduresp = Router( num_cores, s.proc_mdu_ifc.resp )  # 1 cache - to - N cores

    # Shared FPU

    s.fpu         = DesignWareFloatingPointUnit()

    s.net_fpureq  = Funnel( num_cores, FpuReqMsg() )
    s.net_fpuresp = Router( num_cores, FpuRespMsg() )

    # Control Register

    s.ctrlreg = CtrlReg( num_cores )

    # Processors

    s.proc = ProcPRTL   [num_cores]( num_cores, reset_freeze = True )
    s.l0i  = InstBuffer [num_cores]( 2, cacheline_nbits/8 )
    s.xcel = BloomFilterXcel[num_cores]( snoop_mem_msg=s.proc_cache_ifc,
                                         csr_begin=0 )

    #---------------------------------------------------------------------
    # Connections
    #---------------------------------------------------------------------

    # bloom filter connection to the memory system.

    s.cachereq_go = Wire(1)

    for i in xrange( num_cores ):
      s.connect( s.xcel[i].memreq_snoop.msg, s.dcache_adapter.req.msg )
      s.connect( s.xcel[i].memreq_snoop.val, s.cachereq_go )

    @s.combinational
    def comb_cachereq_go():
      s.cachereq_go.value = s.dcache.cachereq.val and s.dcache.cachereq.rdy

    # ctrlreg

    s.connect( s.ctrlreg.req,  s.ctrlregreq )
    s.connect( s.ctrlreg.resp, s.ctrlregresp )

    # core id & mngr

    for i in xrange( num_cores ):
      s.connect_pairs(
        s.proc[i].core_id,     i,

        s.proc[i].go,          s.ctrlreg.go[i],
        s.proc[i].commit_inst, s.ctrlreg.commit_inst[i],

#        s.proc[i].mngr2proc,   s.mngr2proc[i],
#        s.proc[i].proc2mngr,   s.proc2mngr[i],

        s.proc[i].xcelreq,     s.xcel[i].xcelreq,
        s.proc[i].xcelresp,    s.xcel[i].xcelresp,
      )

    s.connect_pairs(
      s.proc[0].mngr2proc,   s.mngr2proc_0,
      s.proc[0].proc2mngr,   s.proc2mngr_0,
      s.proc[1].mngr2proc,   s.mngr2proc_1,
      s.proc[1].proc2mngr,   s.proc2mngr_1,
      s.proc[2].mngr2proc,   s.mngr2proc_2,
      s.proc[2].proc2mngr,   s.proc2mngr_2,
      s.proc[3].mngr2proc,   s.mngr2proc_3,
      s.proc[3].proc2mngr,   s.proc2mngr_3,
    )

    # core #0's stats_en is brought up to the top level

    s.connect( s.proc[0].stats_en, s.ctrlreg.stats_en )

    # instruction cache and l0i and network

    for i in xrange( num_cores ):
      s.connect_pairs(
        # proc -> L0i -> icache_coalescer
        s.proc[i].imemreq,            s.l0i[i].buffreq,
        s.l0i[i].memreq,              s.icache_coalescer.reqs[i],

        # icache_coalescer -> L0i -> proc
        s.icache_coalescer.resps[i],  s.l0i[i].memresp,
        s.l0i[i].buffresp,            s.proc[i].imemresp,
      )

    # nets <-> icache <-> imem

    s.connect_pairs(
      # host_icache -> adapter's host port \
      #                                     +-- adapter -- icache
      # net         -> adapter's real port /

      s.host_icachereq,   s.icache_adapter.hostreq,
      s.host_icacheresp,  s.icache_adapter.hostresp,

      s.icache_coalescer.memreq,  s.icache_adapter.realreq,
      s.icache_coalescer.memresp, s.icache_adapter.realresp,

      s.icache_adapter.req,  s.icache.cachereq,
      s.icache_adapter.resp, s.icache.cacheresp,
    )

    # icache is hooked up to the top level imemreq/resp

    s.connect( s.icache.memreq,  s.imemreq )
    s.connect( s.icache.memresp, s.imemresp )

    # dcache and network

    for i in xrange( num_cores ):
      # proc -> net_dcachereq
      s.connect( s.proc[i].dmemreq,  s.net_dcachereq.in_[i] )

      # net_dcacheresp -> proc
      s.connect( s.net_dcacheresp.out[i], s.proc[i].dmemresp )

    s.connect_pairs(
      # host_dcache -> adapter's host port \
      #                                     +-- adapter -- dcache
      # net         -> adapter's real port /

      s.host_dcachereq,   s.dcache_adapter.hostreq,
      s.host_dcacheresp,  s.dcache_adapter.hostresp,

      s.net_dcachereq.out,  s.dcache_adapter.realreq,
      s.net_dcacheresp.in_, s.dcache_adapter.realresp,

      s.dcache_adapter.req,  s.dcache.cachereq,
      s.dcache_adapter.resp, s.dcache.cacheresp,
    )

    # dcache is hooked up to the top level dmemreq/resp

    s.connect( s.dcache.memreq,  s.dmemreq )
    s.connect( s.dcache.memresp, s.dmemresp )

    # mdu and network and host req

    for i in xrange( num_cores ):
      # proc -> net_mdureq
      s.connect( s.proc[i].mdureq,  s.net_mdureq.in_[i] )

      # net_mduresp -> proc
      s.connect( s.net_mduresp.out[i], s.proc[i].mduresp )

    s.connect_pairs(
      # host_mdu -> adapter's host port \
      #                                  +-- adapter -- mdu
      # net      -> adapter's real port /

      s.host_mdureq,   s.mdu_adapter.hostreq,
      s.host_mduresp,  s.mdu_adapter.hostresp,

      s.net_mdureq.out,  s.mdu_adapter.realreq,
      s.net_mduresp.in_, s.mdu_adapter.realresp,

      s.mdu_adapter.req,  s.mdu.req,
      s.mdu_adapter.resp, s.mdu.resp,
    )

    # FPU connections

    for i in xrange( num_cores ):
      # proc -> net_fpureq
      s.connect( s.proc[i].fpureq,  s.net_fpureq.in_[i] )

      # net_fpuresp -> proc
      s.connect( s.net_fpuresp.out[i], s.proc[i].fpuresp )

    s.connect_pairs(
      s.net_fpureq.out,  s.fpu.req,
      s.net_fpuresp.in_, s.fpu.resp,
    )

    # Turn off host_en signals in the adapters

    s.connect( s.mdu_adapter   .host_en, s.ctrlreg.host_en[0] )
    s.connect( s.icache_adapter.host_en, s.ctrlreg.host_en[1] )
    s.connect( s.dcache_adapter.host_en, s.ctrlreg.host_en[2] )

    # TODO add a ctrlreg for L0_disable
    for i in xrange( num_cores ):
      s.connect( s.l0i[i].L0_disable, 0 )

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):
    trace =  s.icache_coalescer.line_trace()
    trace += ' I$ ' + s.icache.line_trace()
    trace += ' [ ' + s.mdu.line_trace() + ' ] '
    for i in xrange(len(s.proc)):
      trace += ' [ ' + s.proc[i].line_trace() + s.l0i[i].line_trace() + ' ] '
    trace += "D$" + s.dcache.line_trace()
    return trace

