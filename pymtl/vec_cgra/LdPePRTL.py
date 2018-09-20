from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux
from pclib.ifcs import MemMsg4B, MemReqMsg4B, MemRespMsg4B

class LdPePRTL ( Model ):
  
  def __init__( s, nports = 4, DataBits = 32, ConfigBits = 32,
                mem_ifcs_types = MemMsg4B() ):

    # local params
    sel_bits = clog2( nports )
    
    # config input
    s.config = InPort( ConfigBits )

    # IO interface
    s.in_    = InValRdyBundle   [ nports ]( DataBits )
    s.out    = OutValRdyBundle  [ nports ]( DataBits )
    
    # memory interface
    s.memreq  = OutValRdyBundle ( mem_ifcs_types.req )
    s.memresp = InValRdyBundle ( mem_ifcs_types.resp )

    # selection signals
    s.in_sel = Wire( sel_bits )
    s.out_sel = Wire( sel_bits )

    s.connect_pairs(
      s.in_sel,  s.config[ 0          : sel_bits  ],
      s.out_sel, s.config[ sel_bits   : 2*sel_bits],
    )

    # input mux
    s.in_mux = m = Mux( DataBits, nports )
    s.connect( m.sel, s.in_sel )
    for i in xrange( nports ):
      s.connect_pairs( 
        m.in_[i], s.in_[i].msg,
        m.out,    s.memreq.msg.addr,
    )

    @s.combinational
    def comb_logic():
      for i in xrange( nports ):
        if (i == s.in_sel):
          s.in_[i].rdy.value        = s.memreq.rdy
          s.memreq.val.value        = s.in_[i].val
          s.memreq.msg.type_.value  = MemReqMsg4B.TYPE_READ
          s.memreq.msg.len.value    = 0
        else:
          s.in_[i].rdy.value = 0
          
        if (i == s.out_sel):
          s.out[i].val.value  = s.memresp.val
          s.memresp.rdy.value = s.out[i].rdy
          s.out[i].msg.value  = s.memresp.msg.data
        else:
          s.out[i].val.value = 0
    

  def line_trace(s):
    return "({}|{}){}:{} >> {}:{}({}|{})".format(
    s.in_[s.in_sel].val,s.in_[s.in_sel].rdy, s.in_sel, s.in_mux.out,
    s.out_sel, s.out[s.out_sel].msg, s.out[s.out_sel].val,s.out[s.out_sel].rdy)
