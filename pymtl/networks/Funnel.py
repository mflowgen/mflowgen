#=========================================================================
# Funnel.py
#=========================================================================
# The Funnel model is a val-rdy based arbiter model that selects a single
# val-rdy message source given a number of sources. NOTE: The message is
# assumed to have an opaque field.
#
# For brgtc2, use the improved RRArbiterEn instead of RR

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RoundRobinArbiterEn

#-------------------------------------------------------------------------
# Funnel
#-------------------------------------------------------------------------

class Funnel( Model ):

  def __init__( s, nports, MsgType ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.in_ = InValRdyBundle  [ nports ]( MsgType )
    s.out = OutValRdyBundle           ( MsgType )

    #---------------------------------------------------------------------
    # Setup round robin arbiter
    #---------------------------------------------------------------------

    s.arbiter = RoundRobinArbiterEn( nports )

    # input valid -> arbiter input

    for i in xrange( nports ):
      s.connect( s.in_[i].val, s.arbiter.reqs[i] )

    # set the input's rdy only if it is granted and the output is rdy

    @s.combinational
    def comb_in_rdy():
      for i in xrange( nports ):
        s.in_[i].rdy.value = s.arbiter.grants[i] & s.out.rdy

    # The priority in the arbiter will change only if there is a granted
    # request and the output is ready

    @s.combinational
    def comb_arbiter_en():
      s.arbiter.en.value = s.out.val & s.out.rdy

    # set output valid if there is a valid granted request

    @s.combinational
    def comb_output():
      s.out.val.value = ( s.arbiter.grants != 0 )

      s.out.msg.value = 0
      for i in xrange( nports ):
        if s.arbiter.grants[i]:
          s.out.msg.value        = s.in_[i].msg
          s.out.msg.opaque.value = i

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    in_str = '{' + '|'.join(map(str,s.in_)) + '}'
    return "{} ({}) {}".format( in_str, s.arbiter.line_trace(), s.out )
