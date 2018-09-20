
from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux, Adder

class AluPePRTL ( Model ):
  
  def __init__( s, nports = 4, DataBits = 32, ConfigBits = 32 ):

    # local params
    sel_bits = clog2( nports )

    s.config = InPort( ConfigBits )
    s.in_    = InValRdyBundle   [ nports ]( DataBits )
    s.out    = OutValRdyBundle  [ nports ]( DataBits )
    
    # selection signals
    s.in0_sel = Wire( sel_bits )
    s.in1_sel = Wire( sel_bits )
    s.out_sel = Wire( sel_bits )

    s.connect_pairs(
      s.in0_sel, s.config[ 0          : sel_bits  ],
      s.in1_sel, s.config[ sel_bits   : 2*sel_bits],
      s.out_sel, s.config[ 2*sel_bits : 3*sel_bits],
    )

    # input mux 0
    s.in0_mux = m = Mux( DataBits, nports )
    s.connect( m.sel, s.in0_sel )
    for i in xrange( nports ):
      s.connect( m.in_[i], s.in_[i].msg )

    # input mux 1
    s.in1_mux = m = Mux( DataBits, nports)
    s.connect( m.sel, s.in1_sel )
    for i in xrange( nports ):
      s.connect( m.in_[i], s.in_[i].msg )
    
    # adder
    s.add = m = Adder( DataBits )
    s.connect_pairs(
      m.in0,   s.in0_mux.out,
      m.in1,   s.in1_mux.out,
    )
    for i in xrange( nports ):
      s.connect( m.out, s.out[i].msg )

    @s.combinational
    def comb_logic():
      for i in xrange( nports ):
        if (i == s.in0_sel):
          s.in_[i].rdy.value = s.in_[s.in1_sel].val and s.out[s.out_sel].rdy 
        elif (i == s.in1_sel):
          s.in_[i].rdy.value = s.in_[s.in0_sel].val and s.out[s.out_sel].rdy
        else:
          s.in_[i].rdy.value = 0
          
        if (i == s.out_sel):
          s.out[i].val.value = s.in_[s.in0_sel].val and s.in_[s.in1_sel].val
        else:
          s.out[i].val.value = 0
    
  def line_trace(s):
    return "({}|{}){}:{} ({}|{}){}:{} >> {}:{}({}|{})".format(
    s.in_[s.in0_sel].val,s.in_[s.in0_sel].rdy, s.in0_sel, s.in0_mux.out,
    s.in_[s.in1_sel].val,s.in_[s.in1_sel].rdy, s.in1_sel, s.in1_mux.out,
    s.out_sel, s.add.out, s.out[s.out_sel].val,s.out[s.out_sel].rdy)
