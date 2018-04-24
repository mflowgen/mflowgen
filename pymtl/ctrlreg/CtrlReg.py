#=========================================================================
# CtrlReg.py
#=========================================================================
# This module contains control registers that can be read or written with
# a val/rdy interface. Each control register also has an output port from
# this module. The block diagram of the control register design looks like
# this:
#
#            CtrlReg
#           +----------------------------------+
#           |            registers             |
#           | -----+      +----+               |
#     req ->| in_q |----> |    |               |
#           | -----+  |   |    |--+----------> | -> wires out
#           |         |   +/\--+  | data       |
#           |         |           |            |
#           |         |           v    ------+ |
#           |         +--------------> out_q | | -> resp
#           |                          ------+ |
#           |                                  |
#           +----------------------------------+
#
# Request messages go into the input queue. The message is popped out of
# the input queue, and then the read/write happens. For writes, the
# control register is enabled and written, with changes visible on
# the following cycle. For reads, the data for the specified register is
# combinationallly read and then wrapped into the response message.
#
# Response messages go into the output queue. The data field of the
# response message is 0 for writes and has the read data for reads.
#
# Control registers are connected directly to outputs as ports so that
# they can be hooked up to control other parts of the design.
#
# Currently we have these control registers (CRs):
#
# - CR0 (r/w) : go bit, unfreezes the processor
# - CR1 (r/w) : debug bit
# - CR2 (r  ) : number of committed instructions
# - CR3 (r  ) : number of cycles

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import SingleElementNormalQueue, RegEnRst

from ifcs       import CtrlRegReqMsg, CtrlRegRespMsg

class CtrlReg( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Ports to host interface

    s.req  = InValRdyBundle ( CtrlRegReqMsg()  )
    s.resp = OutValRdyBundle( CtrlRegRespMsg() )

    # Ports from processor to CtrlReg

    s.commit_inst = InPort( 1 )
    s.stats_en    = InPort( 1 )

    # Ports from CtrlReg to processor

    s.go          = OutPort( 1 )

    # Misc ports

    s.debug       = OutPort( 1 )

    #---------------------------------------------------------------------
    # Params
    #---------------------------------------------------------------------

    addr_width = s.req.msg.addr.nbits
    data_width = s.req.msg.data.nbits

    #---------------------------------------------------------------------
    # Input Queue
    #---------------------------------------------------------------------

    s.in_q = m = SingleElementNormalQueue( CtrlRegReqMsg() )

    # Connect input

    s.connect( s.req, m.enq )

    #---------------------------------------------------------------------
    # Control Registers
    #---------------------------------------------------------------------
    # Note that this is a collection of registers, as opposed to a
    # register file. The reason it is not a register file is that many
    # registers can be updated in parallel. For example, the instruction
    # counter and cycle counter can both be updated in the same cycle.

    # Control register mapping
    #
    # NOTE: Make sure that the go bit is ZERO when coming out of reset!

    cr_go           = Bits( 4, 0 ) # Go bit
    cr_debug        = Bits( 4, 1 ) # Debug bit
    cr_instcounter  = Bits( 4, 2 ) # Instruction counter
    cr_cyclecounter = Bits( 4, 3 ) # Cycle counter

    # Instantiate registers (16 registers)

    s.ctrlregs = \
      [ RegEnRst( dtype = 32, reset_value = 0 ) for _ in xrange(16) ]

    # Read interface

    s.rf_raddr = Wire( addr_width )
    s.rf_rdata = Wire( data_width )

    @s.combinational
    def comb_rf_read_interface():
      s.rf_raddr.value = s.in_q.deq.msg.addr
      s.rf_rdata.value = s.ctrlregs[ s.rf_raddr ].out

    # Write interface

    s.rf_wen   = Wire( 1 )
    s.rf_waddr = Wire( addr_width )
    s.rf_wdata = Wire( data_width )

    @s.combinational
    def comb_rf_write_interface():
      s.rf_waddr.value = s.in_q.deq.msg.addr
      s.rf_wdata.value = s.in_q.deq.msg.data
      s.rf_wen.value   = s.in_q.deq.val & \
          ( s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE )

    # Control Register: Go

    s.cr_go_en = Wire( 1 )
    s.cr_go_in = Wire( 32 )

    @s.combinational
    def comb_cr_go_logic():
      s.cr_go_en.value = s.rf_wen & ( s.rf_waddr == cr_go )
      s.cr_go_in.value = s.rf_wdata

    s.connect_pairs(
      s.ctrlregs[cr_go].en,  s.cr_go_en,
      s.ctrlregs[cr_go].in_, s.cr_go_in,
    )

    # Control Register: Debug

    s.cr_debug_en = Wire( 1 )
    s.cr_debug_in = Wire( 32 )

    @s.combinational
    def comb_cr_debug_logic():
      s.cr_debug_en.value = s.rf_wen & ( s.rf_waddr == cr_debug )
      s.cr_debug_in.value = s.rf_wdata

    s.connect_pairs(
      s.ctrlregs[cr_debug].en,  s.cr_debug_en,
      s.ctrlregs[cr_debug].in_, s.cr_debug_in,
    )

    # Control Register: Instruction counter

    s.cr_instcounter_en = Wire( 1 )
    s.cr_instcounter_in = Wire( 32 )

    @s.combinational
    def comb_cr_instcounter_logic():
      s.cr_instcounter_en.value = s.commit_inst & s.stats_en
      s.cr_instcounter_in.value = s.ctrlregs[cr_instcounter].out + 1

    s.connect_pairs(
      s.ctrlregs[cr_instcounter].en,  s.cr_instcounter_en,
      s.ctrlregs[cr_instcounter].in_, s.cr_instcounter_in,
    )

    # Control Register: Cycle counter

    s.cr_cyclecounter_en = Wire( 1 )
    s.cr_cyclecounter_in = Wire( 32 )

    @s.combinational
    def comb_cr_cyclecounter_logic():
      s.cr_cyclecounter_en.value = s.stats_en
      s.cr_cyclecounter_in.value = s.ctrlregs[cr_cyclecounter].out + 1

    s.connect_pairs(
      s.ctrlregs[cr_cyclecounter].en,  s.cr_cyclecounter_en,
      s.ctrlregs[cr_cyclecounter].in_, s.cr_cyclecounter_in,
    )

    # Connections to Output Ports
    #
    # These wires directly connect the registers to their output ports

    # go bit (1 bit)

    s.connect( s.ctrlregs[cr_go].out[0], s.go )

    # debug bit (1 bit)

    s.connect( s.ctrlregs[cr_debug].out[0], s.debug )

    #---------------------------------------------------------------------
    # Output Queue
    #---------------------------------------------------------------------

    s.out_q = m = SingleElementNormalQueue( CtrlRegRespMsg() )

    s.connect( s.in_q.deq.val, m.enq.val )
    s.connect( s.in_q.deq.rdy, m.enq.rdy )

    # Create response message

    @s.combinational
    def comb_resp_msg():
      s.out_q.enq.msg.type_.value  = s.in_q.deq.msg.type_

      if s.in_q.deq.msg.type_ == CtrlRegReqMsg.TYPE_WRITE:
        s.out_q.enq.msg.data.value = 0
      else:
        s.out_q.enq.msg.data.value = s.rf_rdata

    # Connect output

    s.connect( s.out_q.deq, s.resp )

  def line_trace( s ):
    return '({})'.format(s.in_q.deq)

