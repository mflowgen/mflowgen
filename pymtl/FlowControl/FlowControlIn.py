#=========================================================================
# FlowControlIn
#=========================================================================
#
# Recieve credit updates from FlowControlOut and update credit counters.
# This unit will generate throttle signals to prevent any stream from
# causing a potential deadlock. The internal counters are initialized with
# maximum credit. Every cycle a stream is granted access, its counter
# is decremented by one. Once the counter reaches zero, the stream has no
# credit and thus needs to be throttled.
#
# Author: Khalid Al-Hawaj
# Date  : May 12, 2018

# General Import
from pymtl import *

# Interfaces
from pclib.ifcs  import InValRdyBundle, OutValRdyBundle

class FlowControlIn( Model ):

  def __init__( s, num_ports, max_credit ):

    #------------------------------------------------
    # Internal inferred parameters
    #------------------------------------------------

    max_credit_lg = clog2( max_credit + 1 )
    num_ports_lg  = clog2(   num_ports    )
    update_msg_bw = max_credit_lg * num_ports

    s.max_credit  = max_credit

    #------------------------------------------------
    # Intercepting requests --  For throttling
    #------------------------------------------------

    # Port
    s.p_val  =  InPort[num_ports]( 1 )
    s.p_rdy  = OutPort[num_ports]( 1 )

    # Arbiter
    s.a_val  = OutPort[num_ports]( 1 )
    s.a_rdy  =  InPort[num_ports]( 1 )

    #------------------------------------------------
    # Credit update
    #------------------------------------------------

    s.update = InValRdyBundle( update_msg_bw )

    #------------------------------------------------
    # Flow control algorithm
    #------------------------------------------------
    # The algorithm is very intuitive and naive.
    # This module will keep track of credit for each
    # stream; once a credit is zero, a throttle
    # signal is set for that stream to prevent
    # further messages and avoid a potential deadlock

    #------------------------------------------------
    # Wires
    #------------------------------------------------

    s.throttles = Wire( num_ports )
    s.tokens    = Wire( num_ports )

    #------------------------------------------------
    # Credit
    #------------------------------------------------

    s.  credits   = Wire[num_ports]( max_credit_lg )
    s.r_credits   = Wire[num_ports]( max_credit_lg )
    s.n_credits   = Wire[num_ports]( max_credit_lg )
    s.c_updates   = Wire[num_ports]( max_credit_lg )
    s.s_updates   = Wire[num_ports]( max_credit_lg ) # sliced :)

    #------------------------------------------------
    # Sliced update credit
    #------------------------------------------------

    for i in xrange( num_ports ):
      l = (i + 0) * max_credit_lg
      h = (i + 1) * max_credit_lg
      s.connect_wire( s.s_updates[i], s.update.msg[l:h] )

    #------------------------------------------------
    # Generate throttle signal
    #------------------------------------------------

    @s.combinational
    def gen_throttle():

      # Fail-safe

      s.throttles.value = 0

      # Reset Throttle for any stream that has credit

      for i in xrange( num_ports ):
        if   s.credits[i] > 0: s.throttles[i].value = 0
        else                 : s.throttles[i].value = 1

      # If reset, throttle

      if s.reset:
        s.throttles.value = 0

    #------------------------------------------------
    # Throttle streams
    #------------------------------------------------

    @s.combinational
    def throttle_streams():

      for i in xrange( num_ports ):
        s.a_val[i].value = s.p_val[i] & ~s.throttles[i]
        s.p_rdy[i].value = s.a_rdy[i] & ~s.throttles[i]

    #------------------------------------------------
    # Generate consumed tokens
    #------------------------------------------------

    @s.combinational
    def gen_tokens():

      s.tokens.value = 0
      for i in xrange( num_ports ):
        s.tokens[i].value = s.p_val[i] & s.a_rdy[i] & ~s.throttles[i]

    #------------------------------------------------
    # Credit update
    #------------------------------------------------

    @s.combinational
    def update_credit():

      # Gather combinational and registered signals

      for i in xrange( num_ports ):
        s.r_credits[i].value = s.credits[i]
        s.n_credits[i].value = s.credits[i]

      # Initialize updates to zero

      for i in xrange( num_ports ):
        s.c_updates[i].value = 0

      s.update.rdy.value = 1

      # If we have an update, count the update in!

      if s.update.val:

        # Get all updates
        for i in xrange( num_ports ):
          s.c_updates[i].value = s.s_updates[i]

      # Update the credits

      for i in xrange( num_ports ):
        # Consider the update
        s.n_credits[i].value = s.r_credits[i] + s.c_updates[i]

        # Deduct any consumed tokens
        if s.tokens[i]:
          s.n_credits[i].value = s.n_credits[i] - s.tokens[i]

      # If reset, ignore all previous work

      if s.reset:

        # Avoid dropping update messages
        s.update.rdy.value = 0

        # Reset credits
        for i in xrange( num_ports ):
          s.n_credits[i].value = max_credit


    #------------------------------------------------
    # Sequential logic
    #------------------------------------------------

    @s.tick_rtl
    def seq():

      # Update the credit
      for i in xrange( num_ports ):
        s.credits[i].next = s.n_credits[i]
