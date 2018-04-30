#=========================================================================
# ProcPRTL.py
#=========================================================================
# ProcAlt + xcelreq/resp + custom0

from pymtl             import *
from pclib.ifcs        import InValRdyBundle, OutValRdyBundle
from pclib.rtl         import SingleElementBypassQueue, TwoElementBypassQueue
from tinyrv2_encoding  import disassemble_inst
from TinyRV2InstPRTL   import inst_dict

from ProcDpathPRTL    import ProcDpathPRTL
from ProcCtrlPRTL     import ProcCtrlPRTL
from DropUnitPRTL      import DropUnitPRTL

from XcelMsg import XcelReqMsg, XcelRespMsg

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg4B, MemRespMsg4B, MduReqMsg, MduRespMsg

# Shunning: Need to hook up all unused ports ...

class ProcPRTL( Model ):

  def __init__( s, num_cores = 1 ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Starting F16 we turn core_id into input ports to
    # enable module reusability. In the past it was passed as arguments.

    s.core_id   = InPort( 32 )

    # Proc/Mngr Interface

    s.mngr2proc = InValRdyBundle ( 32 )
    s.proc2mngr = OutValRdyBundle( 32 )

    # MulDivUnit Interface

    s.mdureq    = OutValRdyBundle( MduReqMsg(32, 8) )
    s.mduresp   = InValRdyBundle( MduRespMsg(32) )

    # Instruction Memory Request/Response Interface

    s.imemreq   = OutValRdyBundle( MemReqMsg4B  )
    s.imemresp  = InValRdyBundle ( MemRespMsg4B )

    # Data Memory Request/Response Interface

    s.dmemreq   = OutValRdyBundle( MemReqMsg4B  )
    s.dmemresp  = InValRdyBundle ( MemRespMsg4B )

    # Accelerator Request/Response Interface

    s.xcelreq   = OutValRdyBundle( XcelReqMsg()    )
    s.xcelresp  = InValRdyBundle ( XcelRespMsg()    )

    # val_W port used for counting commited insts.

    s.commit_inst = OutPort( 1 )

    # stats_en

    s.stats_en    = OutPort( 1 )

    #---------------------------------------------------------------------
    # Structural composition
    #---------------------------------------------------------------------

    s.ctrl  = ProcCtrlPRTL()
    s.dpath = ProcDpathPRTL( num_cores )

    # Connect parameters

    s.connect( s.core_id, s.dpath.core_id )

    # Bypass queues

    s.imemreq_queue   = TwoElementBypassQueue( MemReqMsg4B )
    s.dmemreq_queue   = SingleElementBypassQueue( MemReqMsg4B )
    s.proc2mngr_queue = SingleElementBypassQueue( 32 )
    s.xcelreq_queue   = SingleElementBypassQueue( XcelReqMsg() )

    s.connect_pairs(
      s.imemreq_queue.deq,   s.imemreq,
      s.dmemreq_queue.deq,   s.dmemreq,
      s.proc2mngr_queue.deq, s.proc2mngr,
      s.xcelreq_queue.deq,   s.xcelreq
    )

    # imem drop unit

    s.imemresp_drop = Wire( 1 )

    s.imemresp_drop_unit = m = DropUnitPRTL( 32 )

    s.connect_pairs(
      m.drop,    s.imemresp_drop,
      m.in_.val, s.imemresp.val,
      m.in_.rdy, s.imemresp.rdy,
      m.in_.msg, s.imemresp.msg.data,
    )

    # Control

    s.connect_pairs(

      # mdu

      s.ctrl.mdureq_val,       s.mdureq.val,
      s.ctrl.mdureq_rdy,       s.mdureq.rdy,
      s.ctrl.mdureq_msg_type,  s.mdureq.msg.type_,

      s.ctrl.mduresp_val,      s.mduresp.val,
      s.ctrl.mduresp_rdy,      s.mduresp.rdy,

      # imem ports

      s.ctrl.imemreq_val,   s.imemreq_queue.enq.val,
      s.ctrl.imemreq_rdy,   s.imemreq_queue.enq.rdy,

      s.ctrl.imemresp_val,  s.imemresp_drop_unit.out.val,
      s.ctrl.imemresp_rdy,  s.imemresp_drop_unit.out.rdy,

      # to drop unit

      s.ctrl.imemresp_drop, s.imemresp_drop,

      # dmem port

      s.ctrl.dmemreq_val,   s.dmemreq_queue.enq.val,
      s.ctrl.dmemreq_rdy,   s.dmemreq_queue.enq.rdy,
      s.ctrl.dmemreq_msg_type, s.dmemreq_queue.enq.msg.type_,
      s.ctrl.dmemreq_msg_len,  s.dmemreq_queue.enq.msg.len,

      s.ctrl.dmemresp_val,  s.dmemresp.val,
      s.ctrl.dmemresp_rdy,  s.dmemresp.rdy,

      # xcel port

      s.ctrl.xcelreq_val,   s.xcelreq_queue.enq.val,
      s.ctrl.xcelreq_rdy,   s.xcelreq_queue.enq.rdy,
      s.ctrl.xcelreq_msg_type,  s.xcelreq_queue.enq.msg.type_,

      s.ctrl.xcelresp_val,  s.xcelresp.val,
      s.ctrl.xcelresp_rdy,  s.xcelresp.rdy,

      # proc2mngr and mngr2proc

      s.ctrl.proc2mngr_val, s.proc2mngr_queue.enq.val,
      s.ctrl.proc2mngr_rdy, s.proc2mngr_queue.enq.rdy,

      s.ctrl.mngr2proc_val, s.mngr2proc.val,
      s.ctrl.mngr2proc_rdy, s.mngr2proc.rdy,

      # commit inst for counting

      s.ctrl.commit_inst,   s.commit_inst

    )

    # Dpath

    s.connect_pairs(

      # mdu

      s.dpath.mdureq_msg_op_a, s.mdureq.msg.op_a,
      s.dpath.mdureq_msg_op_b, s.mdureq.msg.op_b,

      s.dpath.mduresp_msg, s.mduresp.msg.result,

      # imem ports

      s.dpath.imemreq_msg,       s.imemreq_queue.enq.msg,
      s.dpath.imemresp_msg_data, s.imemresp_drop_unit.out.msg,

      # dmem ports

      s.dpath.dmemreq_msg_addr,  s.dmemreq_queue.enq.msg.addr,
      s.dpath.dmemreq_msg_data,  s.dmemreq_queue.enq.msg.data,
      s.dpath.dmemresp_msg_data, s.dmemresp.msg.data,

      # mngr

      s.dpath.mngr2proc_data,    s.mngr2proc.msg,
      s.dpath.proc2mngr_data,    s.proc2mngr_queue.enq.msg,

      # xcel

      s.dpath.xcelreq_msg_data,  s.xcelreq_queue.enq.msg.data,
      s.dpath.xcelreq_msg_raddr, s.xcelreq_queue.enq.msg.raddr,
      s.dpath.xcelresp_msg_data, s.xcelresp.msg.data,

      # stats output

      s.dpath.stats_en,          s.stats_en

    )

    # Connect all unconnected ports
    s.connect( s.dmemreq_queue.enq.msg.opaque, 0 )

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
      D_str = "{:<25s}".format( ' ' )
    elif s.ctrl.squash_D.value:
      D_str = "{:<25s}".format( '~' )
    elif s.ctrl.stall_D.value:
      D_str = "{:<25s}".format( '#' )
    else:
      D_str = "{:<25s}".format( disassemble_inst(s.ctrl.inst_D.value) )

    # X stage

    if not s.ctrl.val_X.value:
      X_str = "{:<7s}".format( ' ' )
    elif s.ctrl.stall_X.value:
      X_str = "{:<7s}".format( '#' )
    else:
      X_str = "{:<7s}".format( inst_dict[s.ctrl.inst_type_X.value.uint()] )

    # M stage

    if not s.ctrl.val_M.value:
      M_str = "{:<7s}".format( ' ' )
    elif s.ctrl.stall_M.value:
      M_str = "{:<7s}".format( '#' )
    else:
      M_str = "{:<7s}".format( inst_dict[s.ctrl.inst_type_M.value.uint()] )

    # W stage

    if not s.ctrl.val_W.value:
      W_str = "{:<7s}".format( ' ' )
    elif s.ctrl.stall_W.value:
      W_str = "{:<7s}".format( '#' )
    else:
      W_str = "{:<7s}".format( inst_dict[s.ctrl.inst_type_W.value.uint()] )

    pipeline_str = ( F_str + "|" + D_str + "|" + X_str + "|" + M_str + "|" + W_str )

    return pipeline_str
