
from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux, RegEn, Adder

class AluPePRTL ( Model ):
  
  def __init__( s, nports = 4, DataBits = 32 ):

    s.config = InPort( 32 )
    s.in_    = InValRdyBundle   [ nports ]( DataBits )
    s.out    = OutValRdyBundle  [ nports ]( DataBits )
    
    s.in_val = Wire( 1 )
    
    @s.combinational
    def comb1():
      s.in_val.value = s.in_[s.config[0:2]].val and s.in_[s.config[2:4]].val
    
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
    
    # input queue
    s.in_queue = m =  NormalQueue( num_entries = 2, dtype = (2 * DataBits) )
    s.connect_pairs( 
      m.enq.msg[        0 : (DataBits-1)       ], s.in0_mux.out, 
      m.enq.msg[ DataBits : (2 * DataBits - 1) ], s.in1_mux.out, 
      m.enq.val,     s.in_val, 
    )

    @s.combinational
    def comb2():
      for i in xrange( nports ):
        if (i == s.config[0:2]) or (i == s.config[2:4]):
	  s.in_[i].rdy.value = s.in_queue.enq.rdy
	else:
	  s.in_[i].rdy.value = 0
	
	if (i == s.config[4:6]):
	  s.out[i].val.value       = s.in_queue.deq.val
	  s.in_queue.deq.rdy.value = s.out[i].rdy
	else:
	  s.out[i].val.value = 0
			
    # adder
    s.add = m = Adder( DataBits )
    s.connect_pairs(
      m.in0,   s.in_queue.deq.msg[        0 : (DataBits-1)       ],
      m.in1,   s.in_queue.deq.msg[ DataBits : (2 * DataBits - 1) ],
    )
    for i in xrange( nports ):
      s.connect( m.out, s.out[i].msg )

      
