#=========================================================================
# ProcAltPRTL.py
#=========================================================================

from pymtl             import *
from pclib.ifcs        import InValRdyBundle, OutValRdyBundle
from pclib.ifcs        import MemReqMsg4B, MemRespMsg4B
from pclib.rtl         import SingleElementBypassQueue, TwoElementBypassQueue
from pclib.rtl         import SingleElementPipelinedQueue
from parc_encoding     import disassemble_inst
from PARCInstRTL       import inst_dict

from ProcAltDpathRTL   import ProcAltDpathRTL
from ProcAltCtrlRTL    import ProcAltCtrlRTL
from DropUnitRTL       import DropUnitRTL

from xcel.XcelMsg      import XcelReqMsg, XcelRespMsg

from CtrlReg           import CtrlReg
from CtrlRegMsg        import CtrlRegReqMsg, CtrlRegRespMsg

class ProcAltRTL( Model ):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # use explicit module name

    s.explicit_modulename = 'ProcAltRTL'

    # Ctrl Register Interface

    s.ctrlreg_req  = InValRdyBundle ( CtrlRegReqMsg()  )
    s.ctrlreg_resp = OutValRdyBundle( CtrlRegRespMsg() )

    # Proc/Mngr Interface

    s.mngr2proc   = InValRdyBundle  ( 32 )
    s.proc2mngr   = OutValRdyBundle ( 32 )

    # Instruction Memory Request/Response Interface

    s.imemreq     = OutValRdyBundle ( MemReqMsg4B  )
    s.imemresp    = InValRdyBundle  ( MemRespMsg4B )

    # Data Memory Request/Response Interface

    s.dmemreq     = OutValRdyBundle ( MemReqMsg4B  )
    s.dmemresp    = InValRdyBundle  ( MemRespMsg4B )

    # Accelerator Request/Response Interface

    s.xcelreq     = OutValRdyBundle ( XcelReqMsg()  )
    s.xcelresp    = InValRdyBundle  ( XcelRespMsg() )

    # val_W port used for counting commited insts.

    s.commit_inst = OutPort( 1 )

    # stats_en

    s.stats_en    = OutPort( 1 )

    # debug port

    s.debug       = OutPort( 1 )

    #---------------------------------------------------------------------
    # Structural composition
    #---------------------------------------------------------------------

    s.ctrl  = ProcAltCtrlRTL()
    s.dpath = ProcAltDpathRTL()

    s.ctrlreg = CtrlReg()

    # Bypass queues

    # We add bypass queues each each memreq/resp interface to prevent any
    # val/rdy dependency. The imemreq needs two-element bypass queue
    # because it may hold two instructions in-flight.

    # We do not add bypass queues to imemresp

    s.imemreq_queue   = TwoElementBypassQueue   ( MemReqMsg4B   )
    s.dmemreq_queue   = SingleElementBypassQueue( MemReqMsg4B   )
    s.imemresp_queue  = SingleElementBypassQueue( MemRespMsg4B  )
    s.dmemresp_queue  = SingleElementBypassQueue( MemRespMsg4B  )
    s.proc2mngr_queue = SingleElementBypassQueue( 32 )
    s.mngr2proc_queue = SingleElementBypassQueue( 32 )

    # Note on HLS-generated xcel:
    # - the xcelreq.rdy (output from xcel) depends on xcelreq.val all the
    # time.
    # - the xcelresp.val could sometimes depend on xcelreq.val but
    # this could be a false path.

    s.xcelreq_queue   = SingleElementBypassQueue   ( XcelReqMsg()  )
    s.xcelresp_queue  = SingleElementPipelinedQueue( XcelRespMsg() )

    # Outgoing queues

    s.connect_pairs(
      s.imemreq_queue.deq,   s.imemreq,
      s.dmemreq_queue.deq,   s.dmemreq,
      s.proc2mngr_queue.deq, s.proc2mngr,
      s.xcelreq_queue.deq,   s.xcelreq
    )

    # Incoming queues

    s.connect_pairs(
      s.imemresp,  s.imemresp_queue.enq,
      s.dmemresp,  s.dmemresp_queue.enq,
      s.mngr2proc, s.mngr2proc_queue.enq,
      s.xcelresp,  s.xcelresp_queue.enq
    )

    # imem drop unit

    s.imemresp_drop = Wire( 1 )

    s.imemresp_drop_unit = m = DropUnitRTL( 32 )

    s.connect_pairs(
      m.drop,    s.imemresp_drop,
      m.in_.val, s.imemresp_queue.deq.val,
      m.in_.rdy, s.imemresp_queue.deq.rdy,
      m.in_.msg, s.imemresp_queue.deq.msg.data,
    )

    # Control register

    s.go = Wire( 1 )

    s.connect_pairs(
      s.ctrlreg.req,         s.ctrlreg_req,
      s.ctrlreg.resp,        s.ctrlreg_resp,
      s.ctrlreg.go,          s.go,
      s.ctrlreg.commit_inst, s.ctrl.commit_inst,
      s.ctrlreg.stats_en,    s.dpath.stats_en
    )

    # The output debug is OR of stats_en and CR1
    # usually we don't want glue logic but since this is
    # just an or gate, it might be ok.

    @s.combinational
    def debug_or():
      s.debug.value = s.ctrlreg.debug or s.stats_en

    # Control

    s.connect_pairs(

      s.ctrl.go,               s.go,

      # imem ports

      s.ctrl.imemreq_val,      s.imemreq_queue.enq.val,
      s.ctrl.imemreq_rdy,      s.imemreq_queue.enq.rdy,

      s.ctrl.imemresp_val,     s.imemresp_drop_unit.out.val,
      s.ctrl.imemresp_rdy,     s.imemresp_drop_unit.out.rdy,

      # to drop unit

      s.ctrl.imemresp_drop,    s.imemresp_drop,

      # dmem port

      s.ctrl.dmemreq_val,      s.dmemreq_queue.enq.val,
      s.ctrl.dmemreq_rdy,      s.dmemreq_queue.enq.rdy,
      s.ctrl.dmemreq_msg_type, s.dmemreq_queue.enq.msg.type_,
      s.ctrl.dmemresp_val,     s.dmemresp_queue.deq.val,
      s.ctrl.dmemresp_rdy,     s.dmemresp_queue.deq.rdy,

      # dmem port

      s.ctrl.xcelreq_val,      s.xcelreq_queue.enq.val,
      s.ctrl.xcelreq_rdy,      s.xcelreq_queue.enq.rdy,
      s.ctrl.xcelreq_msg_type, s.xcelreq_queue.enq.msg.type_,
      s.ctrl.xcelresp_val,     s.xcelresp_queue.deq.val,
      s.ctrl.xcelresp_rdy,     s.xcelresp_queue.deq.rdy,

      # proc2mngr and mngr2proc

      s.ctrl.proc2mngr_val,    s.proc2mngr_queue.enq.val,
      s.ctrl.proc2mngr_rdy,    s.proc2mngr_queue.enq.rdy,

      s.ctrl.mngr2proc_val,    s.mngr2proc_queue.deq.val,
      s.ctrl.mngr2proc_rdy,    s.mngr2proc_queue.deq.rdy,

      # commit_inst and stats_en for counting

      s.ctrl.commit_inst,      s.commit_inst

    )

    # connect unused memreq fields to zero

    s.connect( s.dmemreq_queue.enq.msg.len   , 0 )
    s.connect( s.dmemreq_queue.enq.msg.opaque, 0 )

    # Dpath

    s.connect_pairs(

      # imem ports

      s.dpath.imemreq_msg,       s.imemreq_queue.enq.msg,
      s.dpath.imemresp_msg_data, s.imemresp_drop_unit.out.msg,

      # dmem ports

      s.dpath.dmemreq_msg_addr,  s.dmemreq_queue.enq.msg.addr,
      s.dpath.dmemreq_msg_data,  s.dmemreq_queue.enq.msg.data,
      s.dpath.dmemresp_msg_data, s.dmemresp_queue.deq.msg.data,

      # mngr

      s.dpath.mngr2proc_data,    s.mngr2proc_queue.deq.msg,
      s.dpath.proc2mngr_data,    s.proc2mngr_queue.enq.msg,

      # stats_en

      s.dpath.stats_en,          s.stats_en,

      # xcel

      0,                         s.xcelreq_queue.enq.msg.opaque,
      s.dpath.xcelreq_msg_reg,   s.xcelreq_queue.enq.msg.raddr,
      s.dpath.xcelreq_msg_data,  s.xcelreq_queue.enq.msg.data,

      s.xcelresp_queue.deq.msg.data, s.dpath.xcelresp_msg_data

    )

    # Ctrl <-> Dpath

    s.connect_auto( s.ctrl, s.dpath )

  #-----------------------------------------------------------------------
  # Line tracing
  #-----------------------------------------------------------------------

  def line_trace( s ):

    # F stage

    if not s.ctrl.val_F.value:
      F_str = "{:<8s}".format( ' ' )
    elif s.ctrl.squash_F.value:
      F_str = "{:<8s}".format( '~' )
    elif s.ctrl.stall_F.value:
      F_str = "{:<8s}".format( '#' )
    else:
      F_str = "{:08x}".format( s.dpath.pc_reg_F.out.value.uint() )

    # D stage

    if not s.ctrl.val_D.value:
      D_str = "{:<22s}".format( ' ' )
    elif s.ctrl.squash_D.value:
      D_str = "{:<22s}".format( '~' )
    elif s.ctrl.stall_D.value:
      D_str = "{:<22s}".format( '#' )
    else:
      D_str = "{:<22s}".format( disassemble_inst(s.ctrl.inst_D.value) )

    # X stage

    if not s.ctrl.val_X.value:
      X_str = "{:<5s}".format( ' ' )
    elif s.ctrl.stall_X.value:
      X_str = "{:<5s}".format( '#' )
    else:
      X_str = "{:<5s}".format( inst_dict[s.ctrl.inst_type_X.value.uint()] )

    # M stage

    if not s.ctrl.val_M.value:
      M_str = "{:<5s}".format( ' ' )
    elif s.ctrl.stall_M.value:
      M_str = "{:<5s}".format( '#' )
    else:
      M_str = "{:<5s}".format( inst_dict[s.ctrl.inst_type_M.value.uint()] )

    # W stage

    if not s.ctrl.val_W.value:
      W_str = "{:<5s}".format( ' ' )
    elif s.ctrl.stall_W.value:
      W_str = "{:<5s}".format( '#' )
    else:
      W_str = "{:<5s}".format( inst_dict[s.ctrl.inst_type_W.value.uint()] )

    pipeline_str = ( F_str + "|" + D_str + "|" + X_str + "|" + M_str + "|" + W_str )

    return pipeline_str

