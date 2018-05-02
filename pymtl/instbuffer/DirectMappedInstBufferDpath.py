#=========================================================================
# DirectMappedInstBufferDpath.py
#=========================================================================

from pymtl      import *

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemReqMsg, MemRespMsg
from ifcs import MemReqMsg4B, MemRespMsg4B

from pclib.rtl        import Mux, RegEnRst, RegisterFile
from pclib.rtl.arith  import EqComparator

class DirectMappedInstBufferDpath( Model ):

  def __init__( s, num_entries, line_nbytes ):

    opaque_nbits = 8
    addr_nbits   = 32

    line_nbits   = line_nbytes * 8  # 16-byte line = 128 bits size
    line_bw      = clog2( line_nbytes ) # 16-byte line = 4 bit wide
    idx_nbits    = clog2( num_entries ) # 2 entries = 1 bit to represent
    tag_nbits    = addr_nbits - line_bw - idx_nbits

    data_nbits   = 32
    line_nwords  = line_nbits/data_nbits # 16-byte line = 128 bit = 4 x 32

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.buffreq_msg  = InPort ( MemReqMsg( opaque_nbits, addr_nbits, data_nbits)   )
    s.buffresp_msg = OutPort( MemRespMsg( opaque_nbits, data_nbits ) )
    s.memreq_msg   = OutPort( MemReqMsg( opaque_nbits, addr_nbits, line_nbits )  )
    s.memresp_msg  = InPort ( MemRespMsg( opaque_nbits, line_nbits ) )

    # control signals (ctrl->dpath)

    s.buffreq_en   = InPort( 1 )
    s.arrays_wen   = InPort( 1 )
    s.buffresp_hit = InPort( 1 )

    # status signals (dpath->ctrl)

    s.tag_match    = OutPort( 1 )
    s.is_valid     = OutPort( 1 )

    # Register the unpacked buffreq_msg
    # No need to store data/type because I$ requests are READ-ONLY

    s.buffreq_addr_reg = m = RegEnRst( dtype = addr_nbits, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.buffreq_en,
      m.in_, s.buffreq_msg.addr,
    )

    s.buffreq_opaque_reg = m = RegEnRst( dtype = opaque_nbits, reset_value = 0 )
    s.connect_pairs(
      m.en,  s.buffreq_en,
      m.in_, s.buffreq_msg.opaque,
      m.out, s.buffresp_msg.opaque,
    )

    s.buffreq_offset = Wire( line_bw-2 )
    s.buffreq_idx    = Wire( idx_nbits )
    s.buffreq_tag    = Wire( tag_nbits )

    s.connect( s.buffreq_offset, s.buffreq_addr_reg.out[2:line_bw] )
    s.connect( s.buffreq_idx,    s.buffreq_addr_reg.out[line_bw:line_bw+idx_nbits]    )
    s.connect( s.buffreq_tag,    s.buffreq_addr_reg.out[line_bw+idx_nbits:addr_nbits] )

    # Tag array / data array / valid_bit array
    # Note that for the fully associative InstBuffer we don't need a huge
    # array -- instead we just need 2/4 registers to hold the tags
    # Also, we don't need those xxx_bar and sram_xxx signals -- no SRAM!
    # Each entry in the tag/data array stores the tag/data of each line

    # Shunning: I have to change the valid_array to resetable RegEnRst

    s.valid_array = RegEnRst( dtype = num_entries, reset_value = 0 )

    s.tag_array   = RegisterFile( tag_nbits, num_entries, 1, 1, False)
    s.data_array  = RegisterFile( line_nbits, num_entries, 1, 1, False )

    # Reading the arrays:
    # - valid bits are read out, bundled, and send to ctrl
    # - tags are read out for tag checking with request addr in EqComparator
    # - data entries are read out and selected in the big mux based on ctrl signal
    #
    # Writing the arrays:
    # - All enable signals come from the same array_wen_mask
    # - valid array's input is always 1 as there is no coherence
    # - tag array's input is the current request's tag in addr
    # - data array's input is the memory response data

    s.tag_read_out  = Wire( tag_nbits )
    s.data_read_out = Wire( line_nbits )

    @s.combinational
    def comb_valid_read():
      s.is_valid.value = s.valid_array.out[ s.buffreq_idx ] # effectively a huge mux

    @s.combinational
    def comb_valid_write():
      s.valid_array.in_.value = s.valid_array.out  # hawajkm: avoid latches :)
      s.valid_array.in_[ s.buffreq_idx ].value = 1 # effectively a huge demux

    s.connect_pairs(
      s.valid_array.en,         s.arrays_wen,

      s.tag_array.rd_addr[0], s.buffreq_idx,
      s.tag_array.rd_data[0], s.tag_read_out,
      s.tag_array.wr_en,      s.arrays_wen,
      s.tag_array.wr_addr,    s.buffreq_idx,
      s.tag_array.wr_data,    s.buffreq_tag,

      s.data_array.rd_addr[0], s.buffreq_idx,
      s.data_array.rd_data[0], s.data_read_out,
      s.data_array.wr_en,      s.arrays_wen,
      s.data_array.wr_addr,    s.buffreq_idx,
      s.data_array.wr_data,    s.memresp_msg.data,
    )

    # Compare the tag of the corresponding set with the current tag

    s.tag_compare = EqComparator( nbits = tag_nbits )

    s.connect_pairs(
      s.tag_compare.in0, s.tag_read_out,
      s.tag_compare.in1, s.buffreq_tag,
      s.tag_compare.out, s.tag_match,
    )

    # Select word for buff response (always 4B aligned) based on the offset

    s.read_word_sel_mux = m = Mux( dtype = data_nbits, nports = line_nwords )

    s.connect( m.sel, s.buffreq_offset )
    for i in xrange( line_nwords ):
      s.connect( m.in_[i], s.data_read_out[i*addr_nbits:(i+1)*addr_nbits] )

    # InstBuffer is READ-ONLY
    @s.combinational
    def comb_buffresp_msg_pack():
      s.buffresp_msg.type_.value = MemRespMsg.TYPE_READ
      s.buffresp_msg.test.value  = concat( Bits( 1, 0 ), s.buffresp_hit )
      s.buffresp_msg.len.value   = 0
      s.buffresp_msg.data.value  = s.read_word_sel_mux.out

    @s.combinational
    def comb_memreq_msg_pack():
      s.memreq_msg.type_.value  = MemReqMsg.TYPE_READ
      s.memreq_msg.opaque.value = 0
      # No need to select/register the tag from tag array since there is no eviction!
      s.memreq_msg.addr.value   = concat(s.buffreq_tag, s.buffreq_idx, Bits(line_bw, 0))
      s.memreq_msg.len.value    = 0
      s.memreq_msg.data.value   = 0

