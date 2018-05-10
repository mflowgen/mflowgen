#=========================================================================
# TestMemory
#=========================================================================
# A behavioral Test Memory which is parameterized based on the number of
# memory request/response ports. This version is a little different from
# the one in pclib because we actually use the memory messages correctly
# in the interface.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.cl   import InValRdyRandStallAdapter
from pclib.cl   import OutValRdyInelasticPipeAdapter

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg, MemReqMsg, MemRespMsg, MemMsg4B

#- - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - -
#-------------------------------------------------------------------------
# BRGTC2
#-------------------------------------------------------------------------
# The AMO implementations (and MemMsg) has been updated to match RISC-V.
#
# There is also a small fix to the AMO ops to handle signed ops. The AMO
# operations act on the bitwidth of the processor architecture, so the
# read_data from the TestMemory used with AMOs cannot just be the memory
# request message size (e.g., 128b):
#
#         read_data = Bits( s.data_nbits )
#
# It must instead be the number of bytes matching the bitwidth in the
# processor (e.g., 32b):
#
#         read_data = Bits( nbytes*8 )
#
# Otherwise for example we would be reading 128b from the memory and
# comparing that to the 32b value from the request message.
#
#-------------------------------------------------------------------------
#- - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - - - NOTE  - -

#-------------------------------------------------------------------------
# TestMemory
#-------------------------------------------------------------------------

class TestMemory( Model ):

  def __init__( s, mem_ifc_dtypes=MemMsg4B(), nports=1,
                stall_prob=0, latency=0, mem_nbytes=2**20 ):

    # Interface

    xr = range
    s.reqs  = [ InValRdyBundle  ( mem_ifc_dtypes.req  ) for _ in xr(nports) ]
    s.resps = [ OutValRdyBundle ( mem_ifc_dtypes.resp ) for _ in xr(nports) ]

    # Checks

    assert mem_ifc_dtypes.req.data.nbits  % 8 == 0
    assert mem_ifc_dtypes.resp.data.nbits % 8 == 0

    # Buffers to hold memory request/response messages

    s.reqs_q = []
    for req in s.reqs:
      s.reqs_q.append( InValRdyRandStallAdapter( req, stall_prob ) )

    s.resps_q = []
    for resp in s.resps:
      s.resps_q.append( OutValRdyInelasticPipeAdapter( resp, latency ) )

    # Actual memory

    s.mem = bytearray( mem_nbytes )

    # Local constants

    s.mk_rd_resp   = mem_ifc_dtypes.resp.mk_rd
    s.mk_wr_resp   = mem_ifc_dtypes.resp.mk_wr
    s.mk_misc_resp = mem_ifc_dtypes.resp.mk_msg
    s.data_nbits   = mem_ifc_dtypes.req.data.nbits
    s.nports       = nports

    #---------------------------------------------------------------------
    # Tick
    #---------------------------------------------------------------------

    @s.tick_cl
    def tick():

      # Tick adapters

      for req_q, resp_q in zip( s.reqs_q, s.resps_q ):
        req_q.xtick()
        resp_q.xtick()

      # Iterate over input/output queues

      for req_q, resp_q in zip( s.reqs_q, s.resps_q ):

        if not req_q.empty() and not resp_q.full():

          # Dequeue memory request message

          memreq = req_q.deq()

          # When len is zero, then we use all of the data

          nbytes = memreq.len
          if memreq.len == 0:
            nbytes = s.data_nbits/8

          # Handle a read request

          if memreq.type_ == MemReqMsg.TYPE_READ:

            # Copy the bytes from the bytearray into read data bits

            read_data = Bits( s.data_nbits )
            for j in range( nbytes ):
              read_data[j*8:j*8+8] = s.mem[ memreq.addr + j ]

            # Create and enqueue response message

            resp_q.enq( s.mk_rd_resp( memreq.opaque, memreq.len, read_data ) )

          # Handle a write request

          elif memreq.type_ == MemReqMsg.TYPE_WRITE:

            # Copy write data bits into bytearray

            write_data = memreq.data
            for j in range( nbytes ):
              s.mem[ memreq.addr + j ] = write_data[j*8:j*8+8].uint()

            # Create and enqueu response message

            resp_q.enq( s.mk_wr_resp( memreq.opaque, 0 ) )

          # AMOS

          elif ( memreq.type_ == MemReqMsg.TYPE_AMO_ADD  or
                 memreq.type_ == MemReqMsg.TYPE_AMO_AND  or
                 memreq.type_ == MemReqMsg.TYPE_AMO_OR   or
                 memreq.type_ == MemReqMsg.TYPE_AMO_SWAP or
                 memreq.type_ == MemReqMsg.TYPE_AMO_MIN  or
                 memreq.type_ == MemReqMsg.TYPE_AMO_MINU or
                 memreq.type_ == MemReqMsg.TYPE_AMO_MAX  or
                 memreq.type_ == MemReqMsg.TYPE_AMO_MAXU or
                 memreq.type_ == MemReqMsg.TYPE_AMO_XOR ):

            req_data = memreq.data

            # AMOs may do signed operations, so only use nbytes of data

            read_data = Bits( nbytes*8 )
            req_data_ = req_data[0:nbytes*8]

            # Copy the bytes from the bytearray into read data bits

            for j in range( nbytes ):
              read_data[j*8:j*8+8] = s.mem[ memreq.addr + j ]

            # compute the data to be written

            write_data = AMO_FUNS[ memreq.type_.uint() ]( read_data, req_data_ )

            # Copy write data bits into bytearray

            for j in range( nbytes ):
              s.mem[ memreq.addr + j ] = write_data[j*8:j*8+8].uint()

            # Create and enqueue response message

            resp_q.enq( s.mk_misc_resp( memreq.type_, memreq.opaque,
                                        memreq.len, read_data ) )

          # Unknown message type -- throw an exception

          else:
            raise Exception( "TestMemory doesn't know how to handle message type {}"
                             .format( memreq.type_ ) )

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):

    trace_str = ""
    for req, resp_q, resp in zip( s.reqs, s.resps_q, s.resps ):
      trace_str += "{}({}){} ".format( req, resp_q, resp )

    return trace_str

  #-----------------------------------------------------------------------
  # write_mem
  #-----------------------------------------------------------------------
  # Writes the list of bytes to the given memory address.

  def write_mem( s, addr, data ):
    assert len(s.mem) > (addr + len(data))
    s.mem[ addr : addr + len(data) ] = data

  #-----------------------------------------------------------------------
  # read_mem
  #-----------------------------------------------------------------------
  # Reads size bytes from the given memory address.

  def read_mem( s, addr, size ):
    assert len(s.mem) > (addr + size)
    return s.mem[ addr : addr + size ]

#-------------------------------------------------------------------------
# AMO_FUNS
#-------------------------------------------------------------------------
# Implementations of the amo functions. First argument is the value read
# from memory, the second argument is the data coming from the memory
# request.

AMO_FUNS = { MemReqMsg.TYPE_AMO_ADD  : lambda m,a : m+a,
             MemReqMsg.TYPE_AMO_AND  : lambda m,a : m&a,
             MemReqMsg.TYPE_AMO_OR   : lambda m,a : m|a,
             MemReqMsg.TYPE_AMO_SWAP : lambda m,a : a,
             MemReqMsg.TYPE_AMO_MIN  : lambda m,a : m if m.int() < a.int() else a,
             MemReqMsg.TYPE_AMO_MINU : min,
             MemReqMsg.TYPE_AMO_MAX  : lambda m,a : m if m.int() > a.int() else a,
             MemReqMsg.TYPE_AMO_MAXU : max,
             MemReqMsg.TYPE_AMO_XOR  : lambda m,a : m^a,
           }

