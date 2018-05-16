#=========================================================================
# Router.py
#=========================================================================
# The Router model is a val-rdy based arbiter model that routes an incoming
# val-rdy message to an output val-rdy port bundle, given a number of
# outputs. NOTE: The message is assumed to have an opaque field and the
# router simply inspects the opaque field to route a message.

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

#-------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------

class Router( Model ):

  def __init__( s, nports, MsgType ):
    assert hasattr( MsgType, "opaque" ), "This Router requires \"opaque\" field in MsgType"

    #---------------------------------------------------------------------
    # Internal parameters
    #---------------------------------------------------------------------

    nports_lg = clog2( nports )

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.in_ = InValRdyBundle            ( MsgType )
    s.out = OutValRdyBundle [ nports ]( MsgType )

    #---------------------------------------------------------------------
    # Assign outputs
    #---------------------------------------------------------------------
    # Notice that we inspect the opaque field in the incoming message to
    # assign the correct OutValRdyBundle.

    @s.combinational
    def comb_out_val():
      for i in xrange( nports ):
        s.out[i].val.value = 0
        s.out[i].msg.value = 0

      if s.in_.val:
        s.out[ s.in_.msg.opaque ].val.value = s.in_.val
        s.out[ s.in_.msg.opaque ].msg.value = s.in_.msg
        # s.out[ s.in_.msg.opaque ].msg.opaque.value = 0

    s.msg_opaque = Wire( MsgType().opaque.nbits )
    s.msg_dest   = Wire(      nports_lg         )

    # There is a val -> rdy combinational dependency in the following logic
    @s.combinational
    def comb_in_rdy():
      s.msg_opaque.value = s.in_.msg.opaque
      s.msg_dest  .value = s.msg_opaque[0:nports_lg]

      # in_rdy is the rdy status of the opaque-th output
      s.in_.rdy.value = s.out[ s.msg_dest ].rdy  & s.in_.val

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    out_str = '{' + '|'.join(map(str,s.out)) + '}'
    return "{} () {}".format( s.in_ , out_str )
