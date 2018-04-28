#=========================================================================
# BytesMemPortAdapter
#=========================================================================
# These classes provides the Bytes interface, but the implementation
# essentially turns reads/writes into memory requests sent over a
# port-based memory interface. We use greenlets to enable us to wait
# until the response has come back before returning to the function
# accessing the list.

from greenlet import greenlet

class BytesMemPortAdapter (object):

  #-----------------------------------------------------------------------
  # Constructor
  #-----------------------------------------------------------------------

  def __init__( s, memreq, memresp ):

    # Shorter names

    s.MemReqMsgType  = memreq.msg.dtype
    s.MemRespMsgType = memresp.msg.dtype

    # References to the memory request and response ports

    s.memreq  = memreq
    s.memresp = memresp

    # Shorter names

    s.trace = " "

  def execute_amo( s, amo_type, addr, newdata ):

    # Always 4-byte for AMO

    nbytes = 4

    len_ = nbytes if nbytes < s.memreq.msg.data.nbits/8 else 0

    # Create a memory request to send out memory request port

    s.trace = "r"

    memreq_msg        = s.MemReqMsgType()
    memreq_msg.type_  = amo_type
    memreq_msg.addr   = addr
    memreq_msg.opaque = 0
    memreq_msg.len    = len_
    memreq_msg.data   = newdata

    s.memreq.msg.next  = memreq_msg
    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    # Yield so we wait at least one cycle for the response

    greenlet.getcurrent().parent.switch(0)

    # If memory request is not ready yet then yeild

    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    while not s.memreq.rdy:
      s.trace = ";"
      greenlet.getcurrent().parent.switch(0)

    # If memory response has not arrived, then yield

    s.memreq.val.next  = 0
    s.memresp.rdy.next = 1

    while not s.memresp.val:
      s.trace = ":"
      greenlet.getcurrent().parent.switch(0)

    # When memory response has arrived, return the corresponding data

    s.trace = " "
    s.memreq.val.next  = 0
    s.memresp.rdy.next = 0
    return s.memresp.msg.data[0:nbytes*8]

  #-----------------------------------------------------------------------
  # __getitem__
  #-----------------------------------------------------------------------

  def __getitem__( s, key ):

    # Calculate base address and length for request

    if isinstance( key, slice ):
      addr   = int(key.start)
      nbytes = int(key.stop) - int(key.start)
    else:
      addr   = int(key)
      nbytes = 1

    len_ = nbytes if nbytes < s.memreq.msg.data.nbits/8 else 0

    # Create a memory request to send out memory request port

    s.trace = "r"

    memreq_msg        = s.MemReqMsgType()
    memreq_msg.type_  = s.MemReqMsgType.TYPE_READ
    memreq_msg.addr   = addr
    memreq_msg.opaque = 0
    memreq_msg.len    = len_
    memreq_msg.data   = 0

    s.memreq.msg.next  = memreq_msg
    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    # Yield so we wait at least one cycle for the response

    greenlet.getcurrent().parent.switch(0)

    # If memory request is not ready yet then yeild

    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    while not s.memreq.rdy:
      s.trace = ";"
      greenlet.getcurrent().parent.switch(0)

    # If memory response has not arrived, then yield

    s.memreq.val.next  = 0
    s.memresp.rdy.next = 1

    while not s.memresp.val:
      s.trace = ":"
      greenlet.getcurrent().parent.switch(0)

    # When memory response has arrived, return the corresponding data

    s.trace = " "
    s.memreq.val.next  = 0
    s.memresp.rdy.next = 0
    return s.memresp.msg.data[0:nbytes*8]

  #-----------------------------------------------------------------------
  # __setitem__
  #-----------------------------------------------------------------------

  def __setitem__( s, key, value ):

    # Calculate base address and length for request

    if isinstance( key, slice ):
      addr   = int(key.start)
      nbytes = int(key.stop) - int(key.start)
    else:
      addr   = int(key)
      nbytes = 1

    len_ = nbytes if nbytes < s.memreq.msg.data.nbits/8 else 0

    # Create a memory request to send out memory request port

    s.trace = "w"

    memreq_msg        = s.MemReqMsgType()
    memreq_msg.type_  = s.MemReqMsgType.TYPE_WRITE
    memreq_msg.opaque = 0
    memreq_msg.addr   = addr
    memreq_msg.len    = len_
    memreq_msg.data   = value

    s.memreq.msg.next  = memreq_msg
    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    # Yield so we wait at least one cycle for the response

    greenlet.getcurrent().parent.switch(0)

    # If memory request is not ready yet then yeild

    s.memreq.val.next  = 1
    s.memresp.rdy.next = 1

    while not s.memreq.rdy:
      s.trace = ";"
      greenlet.getcurrent().parent.switch(0)

    # If memory response has not arrived, then yield

    s.memreq.val.next  = 0
    s.memresp.rdy.next = 1

    while not s.memresp.val:
      s.trace = ":"
      greenlet.getcurrent().parent.switch(0)

    # When memory response has arrived, then we are done

    s.trace = " "
    s.memreq.val.next  = 0
    s.memresp.rdy.next = 0

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return s.trace

