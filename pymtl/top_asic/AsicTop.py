#===============================================================================
# FpgaDut.py
#===============================================================================
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

# Moyang: Rename it as AsicTop

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn
from pclib.rtl  import NormalQueue

from ifcs       import InReqAckBundle, OutReqAckBundle
from adapters   import *

from top        import ProcSram

class AsicTop( Model ):

  vbb_modulename = 'AsicTop' # statically assign Verilog module name

  def __init__( s, asynch_bitwidth = 8 ):

    s.explicit_modulename = 'AsicTop'

    #-Interface----------------------------------------------------------

    s.in_ = InReqAckBundle ( asynch_bitwidth )
    s.out = OutReqAckBundle( asynch_bitwidth )

    s.debug = OutPort( 1 )

    #-DUT Set Up---------------------------------------------------------

    p_in_width  = 0
    p_out_width = 0

    # Moyang: specialize this only for this project
    s.dut = ProcSram()
    s.dut_in_msg  = []
    s.dut_in_val  = []
    s.dut_in_rdy  = []
    s.dut_out_msg = []
    s.dut_out_val = []
    s.dut_out_rdy = []

    # Additional port 

    s.connect( s.dut.debug, s.debug )

    # Connect DUT inputs

    for name, obj in s.dut.__dict__.items():
      nbits = s.connect_dut_port( obj, InValRdyBundle )
      if( nbits > p_in_width ) : p_in_width = nbits

    # Connect DUT outputs

    for name, obj in s.dut.__dict__.items():
      nbits = s.connect_dut_port( obj, OutValRdyBundle )
      if( nbits > p_out_width ) : p_out_width = nbits

    p_in_nports  = len( s.dut_in_msg )
    p_out_nports = len( s.dut_out_msg )

    #-Structural Composition---------------------------------------------

    # Input ReqAck to ValRdy

    s.in_reqAckToValRdy = m = ReqAckToValRdy( asynch_bitwidth )
    s.connect( m.in_.msg, s.in_.msg )
    s.connect( m.in_.req, s.in_.req )
    s.connect( m.in_.ack, s.in_.ack )

    # Input ValRdy Deserialize

    s.in_deserialize = m = ValRdyDeserializer( asynch_bitwidth, p_in_width + p_in_nports )
    s.connect( m.in_.msg, s.in_reqAckToValRdy.out.msg )
    s.connect( m.in_.val, s.in_reqAckToValRdy.out.val )
    s.connect( m.in_.rdy, s.in_reqAckToValRdy.out.rdy )

    # Input ValRdy Split

    s.in_split = m = ValRdySplit( p_in_nports, p_in_width )
    s.connect( m.in_.msg, s.in_deserialize.out.msg )
    s.connect( m.in_.val, s.in_deserialize.out.val )
    s.connect( m.in_.rdy, s.in_deserialize.out.rdy )

    # DUT

    s.in_q = []
    # s.q_ct = []

    for _ in range( p_in_nports ):

      # Make a copy of the port's dtype
      #
      # The attribute assignments are for Verilog translation (see
      # BitStruct __call__ definition)

      msg   = s.dut_in_msg[ _ ]
      dtype = msg.dtype()
      if type( dtype ) is not Bits:
        dtype._module      = msg.dtype._module
        dtype._classname   = msg.dtype._classname
        dtype._instantiate = msg.dtype._instantiate

      width = s.dut_in_msg[ _ ].nbits
      queue = NormalQueue( 10, dtype )
      s.in_q.append( queue )
      # s.q_ct.append( 0 )
      s.connect( m.out[ _ ].msg[ 0:width ], queue.enq.msg )
      s.connect( m.out[ _ ].val           , queue.enq.val )
      s.connect( m.out[ _ ].rdy           , queue.enq.rdy )
      s.connect( queue.deq.msg, s.dut_in_msg[ _ ] )
      s.connect( queue.deq.val, s.dut_in_val[ _ ] )
      s.connect( queue.deq.rdy, s.dut_in_rdy[ _ ] )

    # Output ValRdy Merge

    s.out_merge = m = ValRdyMerge( p_out_nports, p_out_width )
    for _ in range( p_out_nports ):
      width   = s.dut_out_msg[ _ ].nbits
      m_width = m.in_[ _ ].msg.nbits
      s.connect( m.in_[ _ ].msg[ 0:width ], s.dut_out_msg[ _ ] )
      s.connect( m.in_[ _ ].val, s.dut_out_val[ _ ] )
      s.connect( m.in_[ _ ].rdy, s.dut_out_rdy[ _ ] )
      # connect extra pins to zero
      if m_width > width:
        s.connect( m.in_[ _ ].msg[ width:m_width ], 0 )

    # Output ValRdy Serialize

    s.out_serialize = m = ValRdySerializer( p_out_width + p_out_nports, asynch_bitwidth )
    s.connect( m.in_.msg, s.out_merge.out.msg )
    s.connect( m.in_.val, s.out_merge.out.val )
    s.connect( m.in_.rdy, s.out_merge.out.rdy )

    # Output ValRdy to ReqAck

    s.out_valRdyToReqAck = m = ValRdyToReqAck( asynch_bitwidth )
    s.connect( m.in_.msg, s.out_serialize.out.msg )
    s.connect( m.in_.val, s.out_serialize.out.val )
    s.connect( m.in_.rdy, s.out_serialize.out.rdy )

    # Output

    s.connect( m.out.msg, s.out.msg )
    s.connect( m.out.req, s.out.req )
    s.connect( m.out.ack, s.out.ack )

    # @s.tick_rtl
    # def q_check():
    #   for _ in range( len( s.in_q ) ):
    #     if s.in_q[ _ ].enq.rdy and s.in_q[ _ ].enq.val:
    #       s.q_ct[ _ ] += 1
    #     if s.in_q[ _ ].deq.rdy and s.in_q[ _ ].deq.val:
    #       s.q_ct[ _ ] -= 1

  #-DUT Connection-------------------------------------------------------

  def connect_dut_port( s, obj, PortType ):
    if PortType == InValRdyBundle:
      msg_list = s.dut_in_msg
      val_list = s.dut_in_val
      rdy_list = s.dut_in_rdy
    elif PortType == OutValRdyBundle:
      msg_list = s.dut_out_msg
      val_list = s.dut_out_val
      rdy_list = s.dut_out_rdy
    else:
      return 0

    if isinstance( obj, PortType ):
      portnum = len( msg_list )
      nbits = obj.msg.nbits

      # Make a copy of the port's dtype
      #
      # The attribute assignments are for Verilog translation (see
      # BitStruct __call__ definition)

      dtype              = obj.msg.dtype()
      if type( dtype ) is not Bits:
        dtype._module      = obj.msg.dtype._module
        dtype._classname   = obj.msg.dtype._classname
        dtype._instantiate = obj.msg.dtype._instantiate

      msg_list.append( Wire( dtype ) )
      s.connect( msg_list[ portnum ], obj.msg )
      val_list.append( Wire( 1 ) )
      s.connect( val_list[ portnum ], obj.val )
      rdy_list.append( Wire( 1 ) )
      s.connect( rdy_list[ portnum ], obj.rdy )
      return nbits
    elif isinstance( obj, list ):
      max_nbits = 0
      for item in obj :
        nbits = s.connect_dut_port( item, PortType )
        if ( nbits > max_nbits ) : max_nbits = nbits
      return max_nbits
    else:
      return 0

  #-Line Trace-----------------------------------------------------------

  def line_trace( s ):
    # queue_trace = ""
    # for _ in range( len( s.q_ct ) ):
    #   queue_trace = queue_trace + str( s.q_ct[ _ ] ) + ":"
    trace = s.in_reqAckToValRdy.line_trace() + \
    " > " + s.in_deserialize.line_trace() + \
    " > " + s.in_split.line_trace() + \
    " > " + s.dut.line_trace() + \
    " > " + s.out_merge.line_trace() + \
    " > " + s.out_serialize.line_trace() + \
    " > " + s.out_valRdyToReqAck.line_trace()
    return trace
