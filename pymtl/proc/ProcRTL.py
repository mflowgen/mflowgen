#=========================================================================
# Choose PyMTL or Verilog version
#=========================================================================
# Set this variable to 'pymtl' if you are using PyMTL for your RTL design
# (i.e., your design is in IntMulAltPRTL) or set this variable to
# 'verilog' if you are using Verilog for your RTL design (i.e., your
# design is in IntMulAltVRTL).

rtl_language = 'pymtl'

#-------------------------------------------------------------------------
# Do not edit below this line
#-------------------------------------------------------------------------

# This is the PyMTL wrapper for the corresponding Verilog RTL model.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from proc.XcelMsg import XcelReqMsg
from proc.XcelMsg import XcelRespMsg

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg4B, MemRespMsg4B

class ProcVRTL( VerilogModel ):

  # Verilog module setup

  vprefix    = "proc"
  vlinetrace = True

  # Constructor

  def __init__( s, num_cores = 1 ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    # Specify core id
    s.core_id     = InPort( 32 )

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

    s.xcelreq   = OutValRdyBundle( XcelReqMsg()    )
    s.xcelresp  = InValRdyBundle ( XcelRespMsg()    )

    # for counting num_inst

    s.commit_inst = OutPort( 1 )

    # stats_en output

    s.stats_en    = OutPort( 1 )

    #---------------------------------------------------------------------
    # Verilog import setup
    #---------------------------------------------------------------------

    # Verilog parameters

    s.set_params({
      'p_num_cores' : num_cores
    })

    # Verilog ports

    s.set_ports({
      'clk'           : s.clk,
      'reset'         : s.reset,

      'core_id'       : s.core_id,

      'imemreq_msg'   : s.imemreq.msg,
      'imemreq_val'   : s.imemreq.val,
      'imemreq_rdy'   : s.imemreq.rdy,

      'imemresp_msg'  : s.imemresp.msg,
      'imemresp_val'  : s.imemresp.val,
      'imemresp_rdy'  : s.imemresp.rdy,

      'dmemreq_msg'   : s.dmemreq.msg,
      'dmemreq_val'   : s.dmemreq.val,
      'dmemreq_rdy'   : s.dmemreq.rdy,

      'dmemresp_msg'  : s.dmemresp.msg,
      'dmemresp_val'  : s.dmemresp.val,
      'dmemresp_rdy'  : s.dmemresp.rdy,

      'mngr2proc_msg' : s.mngr2proc.msg,
      'mngr2proc_val' : s.mngr2proc.val,
      'mngr2proc_rdy' : s.mngr2proc.rdy,

      'proc2mngr_msg' : s.proc2mngr.msg,
      'proc2mngr_val' : s.proc2mngr.val,
      'proc2mngr_rdy' : s.proc2mngr.rdy,

      'mngr2proc_msg' : s.mngr2proc.msg,
      'mngr2proc_val' : s.mngr2proc.val,
      'mngr2proc_rdy' : s.mngr2proc.rdy,

      'proc2mngr_msg' : s.proc2mngr.msg,
      'proc2mngr_val' : s.proc2mngr.val,
      'proc2mngr_rdy' : s.proc2mngr.rdy,

      'xcelreq_msg'   : s.xcelreq.msg,
      'xcelreq_val'   : s.xcelreq.val,
      'xcelreq_rdy'   : s.xcelreq.rdy,

      'xcelresp_msg'  : s.xcelresp.msg,
      'xcelresp_val'  : s.xcelresp.val,
      'xcelresp_rdy'  : s.xcelresp.rdy,

      'commit_inst'   : s.commit_inst,

      'stats_en'      : s.stats_en
    })

# See if the course staff want to force testing a specific RTL language
# for their own testing.

import sys
if hasattr( sys, '_called_from_test' ):

  import pytest
  if pytest.config.getoption('prtl'):
    rtl_language = 'pymtl'
  elif pytest.config.getoption('vrtl'):
    rtl_language = 'verilog'

# Import the appropriate version based on the rtl_language variable

if rtl_language == 'pymtl':
  from ProcPRTL import ProcPRTL as ProcRTL
elif rtl_language == 'verilog':
  ProcRTL = ProcVRTL

else:
  raise Exception("Invalid RTL language!")

