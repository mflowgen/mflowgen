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
    def output_logic():
      s.in_.rdy.value = 0
      for i in xrange( nports ):
        s.out[i].val.value = 0
        s.out[i].msg.value = 0
        if s.in_.val and s.in_.msg.opaque == i:
          s.out[i].val.value = s.in_.val
          s.out[i].msg.value = s.in_.msg
        # in_rdy is determined based on the opaque field
        if s.in_.msg.opaque == i:
          s.in_.rdy.value = s.out[i].rdy

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    out_str = '{' + '|'.join(map(str,s.out)) + '}'
    return "{} () {}".format( s.in_ , out_str )
