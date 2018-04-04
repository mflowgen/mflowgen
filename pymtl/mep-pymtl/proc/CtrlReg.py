#=========================================================================
# CtrlReg.py
#=========================================================================
# This module contains control registers that can be read or written with
# a val/rdy interface. Each control register has an output port to hook
# directly into the design. At a high level the design looks like this:
#
#        CtrlReg
#       +----------------------------------+
#       |                                  |
#       | -----+      +----+  ctrl regfile |
# req ->| in_q |----> |    |               |
#       | -----+  |   |    |--+----------> | -> wires out
#       |         |   +/\--+  | data       |
#       |         |           |            |
#       |         |          \|/   ------+ |
#       |         +------------->  out_q | | -> resp
#       |                          ------+ |
#       |                                  |
#       +----------------------------------+
#
# Request messages go into the input queue. When the input queue's dequeue
# msg is valid, the read/write happens. For writes, the control register
# file is enabled and written, with changes visible on the following
# cycle. For reads, the data for the specified register is wrapped into
# the response message. Response messages go into the output queue. Wires
# from the control register file come out as ports so they can be hooked
# up to control other parts of the design.
#
# Currently we have these control registers (CRs):
#
# - CR0 (r/w) : go bit, makes processor start
# - CR1 (r/w) : debug bit, not really useful
# - CR2 (r  ) : number of commited instruction
# - CR3 (r  ) : number of cycles

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import SingleElementNormalQueue

from CtrlRegMsg import CtrlRegReqMsg, CtrlRegRespMsg

class CtrlReg( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # val/rdy connections to host

    s.req  = InValRdyBundle ( CtrlRegReqMsg()  )
    s.resp = OutValRdyBundle( CtrlRegRespMsg() )

    # connection ports to processor

    # processor->ctrlreg

    s.commit_inst = InPort( 1 )
    s.stats_en    = InPort( 1 )

    # ctrlreg->processor

    s.go    = OutPort( 1 )
    s.debug = OutPort( 1 )

    #---------------------------------------------------------------------
    # Params
    #---------------------------------------------------------------------

    addr_width = s.req.msg.addr.nbits
    data_width = s.req.msg.data.nbits

    #---------------------------------------------------------------------
    # Input Queue
    #---------------------------------------------------------------------

    s.in_q = SingleElementNormalQueue( CtrlRegReqMsg() )

    # Connect input

    s.connect( s.req, s.in_q.enq )

    #---------------------------------------------------------------------
    # Control Register File
    #---------------------------------------------------------------------

    s.rf_raddr = Wire( addr_width )
    s.rf_rdata = Wire( data_width )

    s.rf_wen   = Wire( 1 )
    s.rf_waddr = Wire( addr_width )
    s.rf_wdata = Wire( data_width )

    # Read  : combinational read
    # Write : write the register file when in_q's dequeue message is valid
    # and the type is a write

    @s.combinational
    def rf_interface_logic():
      s.rf_raddr.value = s.in_q.deq.msg.addr

      s.rf_waddr.value = s.in_q.deq.msg.addr
      s.rf_wdata.value = s.in_q.deq.msg.data
      s.rf_wen.value = s.in_q.deq.val & \
          ( s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE )


    s.rf_raddr_l2 = Wire( 2 )
    s.rf_waddr_l2 = Wire( 2 )

    @s.combinational
    def addr_trunc():
      s.rf_raddr_l2.value = s.rf_raddr[0:2]
      s.rf_waddr_l2.value = s.rf_waddr[0:2]

    # Instantiate register file
    # only four control regs
    nregs = 4
    s.ctrlregs = [ Wire( data_width ) for _ in range( nregs ) ]

    @s.combinational
    def rf_comb_logic():
      s.rf_rdata.value = s.ctrlregs[ s.rf_raddr_l2 ]

    # CR0, CR1 32 bit
    # CR0: go bit
    # CR1: debug bit
    @s.posedge_clk
    def rf_seq_logic():
      if s.reset:
        # make sure when coming out of reset, go bit is zero
        s.ctrlregs[0].next = 0
        # only CR0 and CR1 are writeable
      elif s.rf_wen:
        if   s.rf_waddr == 0:
          s.ctrlregs[0].next = s.rf_wdata
        elif s.rf_waddr == 1:
          s.ctrlregs[1].next = s.rf_wdata

    # CR2, 32 bit
    # instruction counter
    @s.posedge_clk
    def rf_inst_count():
      if s.reset:
        s.ctrlregs[2].next = 0
      elif s.commit_inst and s.stats_en:
        s.ctrlregs[2].next = s.ctrlregs[2] + 1

    # CR3, 32 bit
    # cycle counter
    @s.posedge_clk
    def rf_cycle_count():
      if s.reset:
        s.ctrlregs[3].next = 0
      elif s.stats_en:
        s.ctrlregs[3].next = s.ctrlregs[3] + 1

    #---------------------------------------------------------------------
    # Control Register Output Ports
    #---------------------------------------------------------------------
    # These wires go straight from the registers to output ports.

    # go bit (CR0, 1 bit)

    s.connect( s.ctrlregs[0][0], s.go    )

    # debug bit (CR1, 1 bit)

    s.connect( s.ctrlregs[1][0], s.debug )

    #---------------------------------------------------------------------
    # Output Queue
    #---------------------------------------------------------------------

    s.out_q = SingleElementNormalQueue( CtrlRegRespMsg() )

    s.connect( s.in_q.deq.val, s.out_q.enq.val )
    s.connect( s.in_q.deq.rdy, s.out_q.enq.rdy )

    # Create response message

    @s.combinational
    def resp_msg():
      s.out_q.enq.msg.type_.value  = s.in_q.deq.msg.type_

      if s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE:
        s.out_q.enq.msg.data.value = 0
      else:
        s.out_q.enq.msg.data.value = s.rf_rdata


    # Connect output

    s.connect( s.out_q.deq, s.resp )

  def line_trace( s ):
    return '({})'.format(s.in_q.deq)

