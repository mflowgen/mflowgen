#=======================================================================
# DropUnit.py
#=======================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegRst

# State Constants

SNOOP = 0
WAIT  = 1

#-------------------------------------------------------------------------
# DropUnit
#-------------------------------------------------------------------------
# Drop Unit drops a transaction between any two models connected by
# using the val-rdy handshake protocol. It receives a drop signal as an
# input and if the drop signal is high, it will drop the next message
# it sees.

class DropUnitPRTL( Model ):

  def __init__( s, nbits ):

    s.drop    = InPort         ( 1     )
    s.in_     = InValRdyBundle ( nbits )
    s.out     = OutValRdyBundle( nbits )

  def elaborate_logic( s ):

    s.connect( s.in_.msg, s.out.msg )

    s.snoop_state = RegRst( 1, reset_value = 0 )

    #------------------------------------------------------------------
    # state_transitions
    #------------------------------------------------------------------
    
    @s.combinational
    def state_transitions():

      in_go   = s.in_.rdy and s.in_.val
      do_wait = s.drop    and not in_go

      if s.snoop_state.out.value == SNOOP:
        if do_wait: s.snoop_state.in_.value = WAIT
        else:       s.snoop_state.in_.value = SNOOP

      elif s.snoop_state.out == WAIT:
        if in_go: s.snoop_state.in_.value = SNOOP
        else:     s.snoop_state.in_.value = WAIT

    #------------------------------------------------------------------
    # set_outputs
    #------------------------------------------------------------------
    
    @s.combinational
    def set_outputs():

      if   s.snoop_state.out == SNOOP:
        s.out.val.value = s.in_.val and not s.drop
        s.in_.rdy.value = s.out.rdy

      elif s.snoop_state.out == WAIT:
        s.out.val.value = 0
        s.in_.rdy.value = 1
