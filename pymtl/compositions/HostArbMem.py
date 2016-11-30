#========================================================================
# HostArbMem
#========================================================================
# This composition is an incremental design that composes the host
# interface, the memory arbiter, and SRAMs.
#
# The host interface has two ports to the memory arbiter. The memory
# arbiter is two-to-one and connects to only one of the two SRAM wrapper
# ports. The other SRAM wrapper port is left hanging.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemReqMsg4B, MemRespMsg4B

from sram       import SramWrapper
from arbiter    import Funnel, Router

#-------------------------------------------------------------------------
# Host + Mem Composition
#-------------------------------------------------------------------------

class HostArbMem( Model ):

  # Defaults: 32b accesses * 6144 words = 24KB, partitioned into 6 subarrays

  def __init__( s, num_bits = 32, num_words = 6144, num_subarrays = 6 ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Two request ports

    s.host_memreqa  = InValRdyBundle ( MemReqMsg4B  )
    s.host_memrespa = OutValRdyBundle( MemRespMsg4B )

    s.host_memreqb  = InValRdyBundle ( MemReqMsg4B  )
    s.host_memrespb = OutValRdyBundle( MemRespMsg4B )

    #---------------------------------------------------------------------
    # Memory Arbiter: Funnel and Router
    #---------------------------------------------------------------------
    # Memory funnel connections
    #
    # - in_[0] : host to mem request port A
    # - in_[1] : host to mem request port B
    # - out    : sram port A

    s.funnel = Funnel( 2, MemReqMsg4B  )
    s.router = Router( 2, MemRespMsg4B )

    # Connections

    s.connect( s.host_memreqa,  s.funnel.in_[0] )
    s.connect( s.host_memrespa, s.router.out[0] )

    s.connect( s.host_memreqb,  s.funnel.in_[1] )
    s.connect( s.host_memrespb, s.router.out[1] )

    #---------------------------------------------------------------------
    # SRAM
    #---------------------------------------------------------------------

    s.sram = SramWrapper(num_bits, num_words, num_subarrays)

    # Connections (sram port B is not used)

    s.connect_pairs(
      s.sram.memreqa,  s.funnel.out,
      s.sram.memrespa, s.router.in_,
    )

  def line_trace( s ):
    return "({}) ({}) | ({}) ({}) ".format( s.host_memreqa, s.host_memrespa,
                                            s.host_memreqb, s.host_memrespb )

