
from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux, Adder

class AluPePRTL ( Model ):
  
  def __init__( s, nports = 4, DataBits = 32, ConfigBits = 32 ):

    s.config = InPort( ConfigBits )
    s.in_    = InValRdyBundle   [ nports ]( DataBits )
    s.out    = OutValRdyBundle  [ nports ]( DataBits )
    
    # input mux 0
    s.in0_mux = m = Mux( DataBits, nports )
    s.connect( m.sel, s.config[0:2] )
    for i in xrange( nports ):
      s.connect( m.in_[i], s.in_[i].msg )

    # input mux 1
    s.in1_mux = m = Mux( DataBits, nports)
    s.connect( m.sel, s.config[2:4] )
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
        if (i == s.config[0:2]):
	  s.in_[i].rdy.value = s.in_[s.config[2:4]].val and s.out[s.config[4:6]].rdy 
        elif (i == s.config[2:4]):
	  s.in_[i].rdy.value = s.in_[s.config[0:2]].val and s.out[s.config[4:6]].rdy
	else:
	  s.in_[i].rdy.value = 0
	
	if (i == s.config[4:6]):
	  s.out[i].val.value = s.in_[s.config[0:2]].val and s.in_[s.config[2:4]].val
	else:
	  s.out[i].val.value = 0
    
  def line_trace(s):
    return "{}:{} {}:{} >> {}:{}".format(s.config[0:2], s.in0_mux.out, s.config[2:4], 
                                         s.in1_mux.out, s.config[4:6], s.add.out)
