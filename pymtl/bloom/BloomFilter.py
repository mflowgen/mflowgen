#=========================================================================
# BloomFilter.py
#=========================================================================
# An implementation of Bloom Filter that uses parallel reads and writes.

from pymtl import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl import Reg, RegEn, RegRst
import random

class BloomFilterMsg( BitStructDefinition ):

  TYPE_INSERT = 0
  TYPE_CHECK  = 1
  TYPE_CLEAR  = 2

  type_str = {
    TYPE_INSERT : "i",
    TYPE_CHECK  : "c",
    TYPE_CLEAR  : "C",
  }

  def __init__( s, nbits ):
    s.type_ = BitField( 2 )
    s.word = BitField( nbits )

  def mk_msg( s, type_, word ):
    msg = s()
    msg.type_ = type_
    msg.word = word
    return msg

  def __str__( s ):
    return "{}:{}".format( BloomFilterMsg.type_str[int(s.type_)], s.word )

class HashFunction( Model ):

  def __init__( s, num_bits_exponent, nbits, const_hash_key ):

    s.in_ = InPort( nbits )
    s.out = OutPort( num_bits_exponent )

    s.addition = Wire( nbits )

    @s.combinational
    def comb_hash_val():
      s.addition.value = s.in_

      for i in range( 1, nbits ):
        if (const_hash_key >> i) & 1:
          s.addition.value += (s.in_ << i)[ : nbits ]
      s.out.value = s.addition[ nbits - num_bits_exponent : nbits ]


class BloomFilterParallel( Model ):

  def __init__( s, num_bits_exponent, num_hash_funs, msg_type, seed=0xdeadbeef ):

    s.in_       = InValRdyBundle( msg_type )
    s.check_out = OutValRdyBundle( 1 )

    # Storage bits

    s.bits      = Reg( 2 ** num_bits_exponent )

    # State

    s.STATE_IDLE   = 0
    s.STATE_INSERT = 1
    s.STATE_CHECK  = 2
    s.STATE_CLEAR  = 3
    s.STATE_NBITS  = 2

    s.state = RegRst( s.STATE_NBITS, reset_value=s.STATE_IDLE )

    # Insert/check word

    s.word  = RegEn( msg_type.word.nbits )
    s.connect( s.word.en,  s.in_.rdy and s.in_.val )
    s.connect( s.word.in_, s.in_.msg.word )

    # Hash function generation

    random.seed( seed )
    s.hash_funs = [ HashFunction( num_bits_exponent, msg_type.word.nbits,
                                  random.randint(0, 2**(msg_type.word.nbits-1) - 1) )
                    for i in range( num_hash_funs ) ]

    for i in range( num_hash_funs ):
      s.connect( s.word.out, s.hash_funs[i].in_ )

    # Next state update.

    @s.combinational
    def comb_state():
      s.state.in_.value = s.state.out

      if s.state.out == s.STATE_IDLE or s.state.out == s.STATE_INSERT or \
           s.state.out == s.STATE_CLEAR:
        s.state.in_.value = s.STATE_IDLE
        if s.in_.val:
          if s.in_.msg.type_ == BloomFilterMsg.TYPE_INSERT:
            s.state.in_.value = s.STATE_INSERT
          elif s.in_.msg.type_ == BloomFilterMsg.TYPE_CHECK:
            s.state.in_.value = s.STATE_CHECK
          elif s.in_.msg.type_ == BloomFilterMsg.TYPE_CLEAR:
            s.state.in_.value = s.STATE_CLEAR

      elif s.state.out == s.STATE_CHECK and s.check_out.rdy:
        s.state.in_.value = s.STATE_IDLE

    # Bits insert/check logic.
    # XXX: hacky!!! Due to a PyMTL bug, we need to have a state that
    # toggles and fires the combinational block.
    s.foo = Reg( 1 )

    @s.combinational
    def comb_bits():
      s.in_.rdy.value = 0
      s.check_out.val.value = 0
      s.foo.in_.value = not s.foo.out

      if s.state.out == s.STATE_IDLE:
        s.in_.rdy.value = 1

      elif s.state.out == s.STATE_CLEAR:
        s.in_.rdy.value = 1
        s.bits.in_.value = Bits( 2 ** num_bits_exponent, 0 )

      elif s.state.out == s.STATE_INSERT:
        s.in_.rdy.value = 1
        s.bits.in_.value = s.bits.out

        for i in range( len( s.hash_funs ) ):
          s.bits.in_[ s.hash_funs[i].out ].value |= 1

      elif s.state.out == s.STATE_CHECK:
        s.check_out.val.value = 1
        s.check_out.msg.value = 1

        for hash_fun in s.hash_funs:
          s.check_out.msg.value &= s.bits.out[ hash_fun.out ]

  def line_trace( s ):
    return "{} ({}) {}".format( s.state.out,
                                " ".join( [ "{}".format(hf.out) for hf in s.hash_funs ] ),
                                s.bits.out )

