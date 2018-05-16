#===============================================================================
# SwShim.py
#===============================================================================
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl       import *
from pclib.ifcs  import InValRdyBundle, OutValRdyBundle
from pclib.rtl   import RegEn

from ifcs        import InReqAckBundle, OutReqAckBundle
from adapters    import *

from FlowControl import FlowControlIn, FlowControlOut

class SwShim( Model ):

  def __init__( s, dut, dut_asynch, asynch_bitwidth = 32,
                   dump_vcd = None, translate = False ):

    #-Interface----------------------------------------------------------

    p_in_width  = 0
    p_out_width = 0

    s.dut_in_msg  = []
    s.dut_in_val  = []
    s.dut_in_rdy  = []
    s.dut_out_msg = []
    s.dut_out_val = []
    s.dut_out_rdy = []

    # Replicate DUT inputs

    for name, obj in dut.__dict__.items():
      nbits = s.replicate_dut_port( name, obj, InValRdyBundle )
      if( nbits > p_in_width ) : p_in_width = nbits

    # Replicate DUT outputs

    for name, obj in dut.__dict__.items():
      nbits = s.replicate_dut_port( name, obj, OutValRdyBundle )
      if( nbits > p_out_width ) : p_out_width = nbits

    # hawajkm: Adding one output port for credit flow control
    p_in_nports  = len( s.dut_in_msg  )
    p_out_nports = len( s.dut_out_msg ) + 1

    #-Structural Composition---------------------------------------------

    # Flow Control

    # hawajkm
    # We include a simple flow control scheme where knowing how much entries each
    # queue can store, we allow each input port to send only that amount. We wait
    # for the flow control unit to acknowledge how many entries are there before
    # we allow further messages to be sent. This is ultra conservative approach.
    # However, it is a much needed enhancement.

    s.tokens   = Wire( p_in_nports )
    s.throttle = Wire( p_in_nports )
    s.in_val   = Wire( p_in_nports )
    s.in_rdy   = Wire( p_in_nports )

    s.flow_control = m = FlowControlIn( p_in_nports, 16 )

    # Sim->DUT ValRdy Merge

    s.in_merge = m = ValRdyMerge( p_in_nports, p_in_width )

    for _ in range( p_in_nports ):
      bw = s.dut_in_msg[ _ ].nbits
      s.connect( m.in_[ _ ].msg[0:bw], s.dut_in_msg[ _ ] )

      # Connect ValRdy control signals to the control flow unit

      s.connect( s.dut_in_val        [ _ ], s.flow_control.p_val[ _ ] )
      s.connect( s.flow_control.a_rdy[ _ ], m.in_[ _ ].rdy             )

      # Connect throttled ValRdy control signals to streams

      s.connect( s.flow_control.a_val[ _ ], m.in_[ _ ].val            )
      s.connect( s.dut_in_rdy        [ _ ], s.flow_control.p_rdy[ _ ] )

    # Sim->DUT ValRdy Serialize

    s.in_serialize = m = ValRdySerializer( p_in_width + p_in_nports, asynch_bitwidth )
    s.connect( m.in_.msg, s.in_merge.out.msg )
    s.connect( m.in_.val, s.in_merge.out.val )
    s.connect( m.in_.rdy, s.in_merge.out.rdy )

    # Sim->DUT ValRdy to ReqAck

    s.in_valRdyToReqAck = m = ValRdyToReqAck( asynch_bitwidth )
    s.connect( m.in_.msg, s.in_serialize.out.msg )
    s.connect( m.in_.val, s.in_serialize.out.val )
    s.connect( m.in_.rdy, s.in_serialize.out.rdy )

    # Sim->DUT Asynch Output

    s.dut = dut_asynch

    # VCD

    if dump_vcd:
      s.dut.vcd_file = dump_vcd

    # Translate Verilog if needed

    if translate:
      s.dut = TranslationTool( s.dut, enable_blackbox = True, verilator_xinit=translate )

    s.connect( s.dut.in_.msg, s.in_valRdyToReqAck.out.msg )
    s.connect( s.dut.in_.req, s.in_valRdyToReqAck.out.req )
    s.connect( s.dut.in_.ack, s.in_valRdyToReqAck.out.ack )

    # DUT->Sim ReqAck to ValRdy

    s.in_reqAckToValRdy = m = ReqAckToValRdy( asynch_bitwidth )
    s.connect( m.in_.msg, s.dut.out.msg )
    s.connect( m.in_.req, s.dut.out.req )
    s.connect( m.in_.ack, s.dut.out.ack )

    # DUT->Sim ValRdy Deserialize

    s.in_deserialize = m = ValRdyDeserializer( asynch_bitwidth, p_out_width + p_out_nports )
    s.connect( m.in_.msg, s.in_reqAckToValRdy.out.msg )
    s.connect( m.in_.val, s.in_reqAckToValRdy.out.val )
    s.connect( m.in_.rdy, s.in_reqAckToValRdy.out.rdy )

    # DUT->Sim ValRdy Split

    s.in_split = m = ValRdySplit( p_out_nports, p_out_width )
    s.connect( m.in_.msg, s.in_deserialize.out.msg )
    s.connect( m.in_.val, s.in_deserialize.out.val )
    s.connect( m.in_.rdy, s.in_deserialize.out.rdy )

    # DUT output

    for _ in range( p_out_nports ):
      if _ < p_out_nports - 1:
        # Normal output
        bw = s.dut_out_msg[ _ ].nbits
        s.connect( m.out[ _ ].msg[0:bw], s.dut_out_msg[ _ ] )
        s.connect( m.out[ _ ].val      , s.dut_out_val[ _ ] )
        s.connect( m.out[ _ ].rdy      , s.dut_out_rdy[ _ ] )
      else:
        # Flow control
        bw = s.flow_control.update.msg.nbits
        s.connect( m.out[ _ ].msg[0:bw], s.flow_control.update.msg )
        s.connect( m.out[ _ ].val      , s.flow_control.update.val )
        s.connect( m.out[ _ ].rdy      , s.flow_control.update.rdy )


  #-DUT Replication------------------------------------------------------

  def replicate_dut_port( s, name, obj, PortType ):
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
      # Create port for shim
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

      s.__dict__[ name ] = PortType( dtype )

      # Create reference wires
      portnum = len( msg_list )
      msg_list.append( Wire( dtype ) )
      s.connect( msg_list[ portnum ], s.__dict__[ name ].msg )
      val_list.append( Wire( 1 ) )
      s.connect( val_list[ portnum ], s.__dict__[ name ].val )
      rdy_list.append( Wire( 1 ) )
      s.connect( rdy_list[ portnum ], s.__dict__[ name ].rdy )
      return nbits
    elif isinstance( obj, list ):
      max_nbits = 0
      for item in obj :
        nbits = s.replicate_dut_port( name, item, PortType )
        if ( nbits > max_nbits ) : max_nbits = nbits
      return max_nbits
    else:
      return 0

  #-Line Trace-----------------------------------------------------------

  def line_trace( s ):
    return "(SHIM) ::: {}{}{} ::: (SHIM)".format( s.dut.in_, s.dut.line_trace(), s.dut.out )
