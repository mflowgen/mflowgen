from pymtl      import * 
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.ifcs import MemMsg4B, MemReqMsg4B, MemRespMsg4B
from pclib.rtl  import RegEn

class LdPePRTL ( Model ):
  
  def __init__(s, nports = 4, DataBits = 32, ConfigBits = 32, 
               mem_ifcs_types = MemMsg4B() ):
    
    #local params
    ioports  = nports - 1
    sel_bits = clog2( nports )
    
    # Config input
    s.config  = InPort( ConfigBits )

    s.addr    = InPort( DataBits )
    s.stride  = InPort( DataBits )
    s.count   = InPort( DataBits )

    # IO interface
    s.in_     = InValRdyBundle   [ ioports ]( DataBits )
    s.out     = OutValRdyBundle  [ ioports ]( DataBits )

    # Memory interface
    s.memreq  = OutValRdyBundle ( mem_ifcs_types.req )
    s.memresp = InValRdyBundle ( mem_ifcs_types.resp )

    # set the sel signal
    s.stride_sel = Wire( sel_bits )
    s.addr_sel   = Wire( sel_bits )
    s.count_sel  = Wire( sel_bits )
    s.out_sel    = Wire( sel_bits )

    s.connect( s.stride_sel, s.config[          0 : sel_bits   ] )
    s.connect( s.addr_sel,   s.config[ sel_bits   : 2*sel_bits ] )
    s.connect( s.count_sel,  s.config[ 2*sel_bits : 3*sel_bits ] )
    s.connect( s.out_sel,    s.config[ 3*sel_bits : 4*sel_bits ] )

    # stride mux
    s.stride_mux = m = Mux( DataBits, nports )
    s.connect_pairs( 
      m.in_[io_ports], s.stride,
      m.sel,           s.stride_sel,
    )
    for i in xarange( ioports ):
      s.connect( m.in_[i], s.in_[i].msg )
    
    #stride reg
    s.stride = m = RegEn( DataBits )
    s.connect( m.in_, s.stride_mux.out )

    # count mux
    s.count_mux = m = Mux( DataBits, nports )
    s.connect_pairs( 
      m.in_[io_ports], s.count,
      m.sel,           s.count_sel,
    )
    for i in xarange( ioports ):
      s.connect( m.in_[i], s.in_[i].msg )


    # addr_in mux
    s.addr_in_mux = m = Mux( DataBits, nports)
    s.connect_pairs( 
      m.in_[io_ports], s.addr,
      m.sel,           s.addr_sel,
    )
    for i in xarange( ioports ):
      s.connect( m.in_[i], s.in_[i].msg )
    
    s.addr_reg_mux_sel = Wire(1)
    s.addr_inc_out = Wire( DataBits )

    # addr_reg mux
    s.addr_reg_mux = m = Mux( DataBits, 2 )
    s.connect_pairs(
      m.in_[0], s.addr_in_mux.out,
      m.in_[1], s.addr_inc_out,
      m.sel,    s.addr_reg_mux_sel,
    )

    # addr reg
    s.addr_reg = m = RegEn( DataBits )
    s.connect( m.in_,  s.addr_reg_mux.out )

    @s.combinational
    def comb_addr_reg_sel():
      s.addr_reg.en




