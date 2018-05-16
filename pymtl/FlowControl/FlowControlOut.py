#=========================================================================
# FlowControlOut
#=========================================================================
#
# This unit inspects messages being dequeued from the input queues in a
# design and send a credit update to the host. The approach is very
# conservative and will not yield high throughput.
#
# Author: Khalid Al-Hawaj
# Date  : May 12, 2018

# General Import
from pymtl import *

# Interfaces
from pclib.ifcs  import InValRdyBundle, OutValRdyBundle

class FlowControlOut( Model ):

  def __init__( s, num_ports, max_credit ):

    #------------------------------------------------
    # Internal inferred parameters
    #------------------------------------------------

    max_credit_lg = clog2( max_credit + 1 )
    num_ports_lg  = clog2( num_ports      )
    update_msg_bw = max_credit_lg * num_ports

    s.max_credit = max_credit

    #------------------------------------------------
    # Keeping track of a dequeue
    #------------------------------------------------

    s.req_val = InPort[num_ports]( 1 )
    s.req_rdy = InPort[num_ports]( 1 )

    #------------------------------------------------
    # Credit update
    #------------------------------------------------

    s.update = OutValRdyBundle( update_msg_bw )

    #------------------------------------------------
    # Update algorithm
    #------------------------------------------------
    # The algorithm is pretty simple. Every threshold
    # worth of dequeues, we send a redeem message,
    # which will be the update message

    #------------------------------------------------
    # Constants
    #------------------------------------------------

    s.trigger_threshold = Bits( max_credit_lg, max_credit / 2 )

    #------------------------------------------------
    # Wires
    #------------------------------------------------

    s.tokens      = Wire(   num_ports   )
    s.all_credits = Wire( update_msg_bw )
    s.send_update = Wire(       1       )
    s.trigger     = Wire(       1       )

    #------------------------------------------------
    # Credit counters
    #------------------------------------------------

    s.  credits  = Wire[num_ports]( max_credit_lg )
    s.c_credits  = Wire[num_ports]( max_credit_lg )
    s.n_credits  = Wire[num_ports]( max_credit_lg )

    #------------------------------------------------
    # Trigger meta-data
    #------------------------------------------------

    s.  trigger_cnt = Wire( num_ports_lg + max_credit_lg )
    s.c_trigger_cnt = Wire( num_ports_lg                 )
    s.n_trigger_cnt = Wire( num_ports_lg + max_credit_lg )

    #------------------------------------------------
    # Generate Trigger
    #------------------------------------------------

    @s.combinational
    def gen_trigger():

      s.trigger.value = 0

      if s.trigger_cnt >= s.trigger_threshold:
        s.trigger.value = 1

    #------------------------------------------------
    # Generate consumed tokens
    #------------------------------------------------

    @s.combinational
    def gen_tokens():

      s.tokens.value = 0

      for i in xrange( num_ports ):
        s.tokens[i].value = s.req_val[i] & s.req_rdy[i]

    #------------------------------------------------
    # Update trigger counter
    #------------------------------------------------

    @s.combinational
    def update_trigger_counter():

      # Initialization

      s.n_trigger_cnt.value = s.trigger_cnt

      # Iterate through all tokens and count them

      s.c_trigger_cnt.value = 0

      for i in xrange( num_ports ):
        s.c_trigger_cnt.value = s.c_trigger_cnt + s.tokens[i]

      # Update the trigger counter

      if s.trigger and s.update.rdy:
        s.n_trigger_cnt.value = 0
      else:
        s.n_trigger_cnt.value = s.n_trigger_cnt + s.c_trigger_cnt

      # Reset :)

      if s.reset:
        s.n_trigger_cnt.value = 0

    #------------------------------------------------
    # Generate update message
    #------------------------------------------------

    @s.combinational
    def gen_update_msg():

      # Iterate over all ports and gather all credits

      for i in xrange( num_ports ):
        s.all_credits[(i * max_credit_lg):((i + 1) * max_credit_lg)].value = s.credits[i]

      # Depending on the trigger

      if   s.trigger: s.update.msg.value = s.all_credits
      else          : s.update.msg.value = 0

    #------------------------------------------------
    # Update credit credits
    #------------------------------------------------

    @s.combinational
    def update_logic():

      # Gather all the different signal views

      for i in xrange( num_ports ):
        s.c_credits[i].value = s.credits[i]

      # Combinational signals initialization

      s.update.val.value = 0

      # Two states, really: Triggered or not triggered

      if s.trigger:
        s.update.val.value = 1

      if s.trigger and s.update.rdy:
        # All credits are redeemed, reset c_credits
        for i in xrange( num_ports ):
          s.c_credits[i].value = 0

      # Reset :)
      if s.reset:
        s.update.val.value = 0

    #------------------------------------------------
    # Update streams credits
    #------------------------------------------------

    @s.combinational
    def update_credit():

      for i in xrange( num_ports ):
        s.n_credits[i].value = s.c_credits[i]

      for i in xrange( num_ports ):
        if s.tokens[i]:
          s.n_credits[i].value = s.n_credits[i] + s.tokens[i]

      if s.reset:
        for i in xrange( num_ports ):
          s.n_credits[i].value = 0

    #------------------------------------------------
    # Sequential logic
    #------------------------------------------------

    @s.tick_rtl
    def seq():

      # Credit counters

      for i in xrange( num_ports ):
        s.credits[i].next = s.n_credits[i]

      # Trigger counter

      s.trigger_cnt.next = s.n_trigger_cnt
