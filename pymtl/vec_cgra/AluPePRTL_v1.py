
from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux, Adder, RegEn
from pclib.rtl  import SingleElementPipelinedQueue

class AluPePRTL ( Model ):
  
  def __init__( s, nports = 4, DataBits = 32, ConfigBits = 32 ):

    # local params
    sel_bits = clog2( nports )

    s.config = InPort( ConfigBits )
    s.go     = InPort( 1 )
    s.idle   = OutPort( 1 )

    s.in_    = InValRdyBundle   [ nports ]( DataBits )
    s.out    = OutValRdyBundle  [ nports ]( DataBits )
    
    # input queue 
    s.in_queue = SingleElementPipelinedQueue [ nports ]( DataBits )
    
    # selection signals
    s.in0_sel = Wire( sel_bits )
    s.in1_sel = Wire( sel_bits )
    s.out_sel = Wire( sel_bits )

    # config reg
    s.config_reg = m = RegEn( ConfigBits )
    s.connect( m.in_, s.config )

    s.connect_pairs(
      s.in0_sel, s.config_reg.out[ 0          : sel_bits  ],
      s.in1_sel, s.config_reg.out[ sel_bits   : 2*sel_bits],
      s.out_sel, s.config_reg.out[ 2*sel_bits : 3*sel_bits],
    )

    # input mux 0
    s.in0_mux = m = Mux( DataBits, nports )
    s.connect( m.sel, s.in0_sel )

    # input mux 1
    s.in1_mux = m = Mux( DataBits, nports)
    s.connect( m.sel, s.in1_sel )
    
    for i in xrange( nports ):
      s.connect_pairs(
        s.in_queue[i].enq.val, s.in_[i].val,
        s.in_queue[i].enq.msg, s.in_[i].msg,
        s.in_queue[i].deq.msg, s.in0_mux.in_[i],
        s.in_queue[i].deq.msg, s.in1_mux.in_[i],
      )
    
    # adder
    s.add = m = Adder( DataBits )
    s.connect_pairs(
      m.in0,   s.in0_mux.out,
      m.in1,   s.in1_mux.out,
    )

    @s.combinational
    def comb_logic():
      s.idle.value = ~s.in_[s.in0_sel].val and ~s.in_[s.in1_sel].val and s.out[s.out_sel].rdy
      s.config_reg.en.value = s.go & s.idle
      s.in_queue.enq.val.value = s.in_[in0_sel].val and s.in_[in1_sel].val 
      for i in xrange( nports ):
        if (i == s.in0_sel):
          s.in_[i].rdy.value = s.in_[s.in1_sel].val and s.in_queue[i].enq.rdy
        elif (i == s.in1_sel):
          s.in_[i].rdy.value = s.in_[s.in0_sel].val and s.in_queue[i].enq.rdy
        else:
          s.in_[i].rdy.value = 0
          
        if (i == s.out_sel):
          s.out[i].val.value       = s.in_queue[s.in0_sel].deq.val and s.in_queue[s.in1_sel].deq.val
          s.in_queue[s.in0_sel].deq.rdy.value = s.out[i].rdy
          s.in_queue[s.in1_sel].deq.rdy.value = s.out[i].rdy
        else:
          s.out[i].val.value = 0
    
  def line_trace(s):
    return "({}|{}){}:{} ({}|{}){}:{} >> {}:{}({}|{})".format(
    s.in_[s.in0_sel].val,s.in_[s.in0_sel].rdy, s.in0_sel, s.in0_mux.out,
    s.in_[s.in1_sel].val,s.in_[s.in1_sel].rdy, s.in1_sel, s.in1_mux.out,
    s.out_sel, s.add.out, s.out[s.out_sel].val,s.out[s.out_sel].rdy)
