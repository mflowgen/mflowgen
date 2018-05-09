#=========================================================================
# Functional Model for Sram SP HDE 28nm
#=========================================================================

# OS and basics
import os
import shutil

#PyMTL import
from pymtl import *

class SramSpHsd28nmFuncPRTL( Model ):

  def __init__( s, num_bits = 32, num_words = 256, module_name = '' ):

    AW = clog2( num_words )      # address width
    BW = num_bits                # $ceil(num_bits/8)
    bW = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    # SRAM Configuration
    sram_conf         = {}
    sram_conf['type'] = 'sram_sp_hsd'

    # If module_name is empty, compose one
    if not module_name:
      module_name = 'sram_28nm_{}x{}_SP'.format( num_words ,
                                                 num_bits  )

    # Module name
    s.explicit_modulename = module_name

    s.vblackbox      = True
    s.vbb_modulename = module_name
    s.vbb_no_reset   = True

    # Get SRAM specification
    lib_dir = os.path.dirname(os.path.abspath(__file__))
    cwd_dir = os.getcwd()

    # Needed files
    spec_file_name = '{}.{}.spec' .format(module_name      ,
                                          sram_conf['type'])

    # Directories
    dst_dir        = '{}/srams'   .format(cwd_dir          )
    src_dir        = '{}/specs'   .format(lib_dir          )

    # Files
    dst_path       = '{}/{}'      .format(dst_dir          ,
                                          spec_file_name   )
    src_path       = '{}/{}'      .format(src_dir          ,
                                          spec_file_name   )

    # Check if specification exists
    if os.path.isfile(src_path):
      # We will copy the specification file to the simulation directory
      # Eventually, we need to protect this step with 'translation' flags

      # Make a directory for specification
      if not os.path.isdir(dst_dir):
        os.makedirs(dst_dir)

      # Copy the spec file
      shutil.copyfile(src_path, dst_path)

    else:
      raise ValueError('Cannot find specs file {}'.format(src_path))


    # port names set to match the ARM memory compiler

    # clock (in PyMTL simulation it uses implict .clk port when
    # translated to Verilog, actual clock ports should be CLK
    s.ceny      = OutPort(  1 )
    s.weny      = OutPort( BW )
    s.gweny     = OutPort(  1 )
    s.ay        = OutPort( AW )
    s.q         = OutPort( BW )
    s.so        = OutPort(  2 )
    s.cen       = InPort (  1 )
    s.wen       = InPort ( BW )
    s.a         = InPort ( AW )
    s.d         = InPort ( BW )
    s.ema       = InPort (  3 )
    s.emaw      = InPort (  2 )
    s.emas      = InPort (  1 )
    s.ten       = InPort (  1 )
    s.tcen      = InPort (  1 )
    s.twen      = InPort ( BW )
    s.ta        = InPort ( AW )
    s.td        = InPort ( BW )
    s.gwen      = InPort (  1 )
    s.tgwen     = InPort (  1 )
    s.ret1n     = InPort (  1 )
    s.si        = InPort (  2 )
    s.se        = InPort (  1 )
    s.dftrambyp = InPort (  1 )

    # memory array

    s.ram = [ Wire( num_bits ) for x in xrange( num_words ) ]

    # read path

    s.dout = Wire( num_bits )

    @s.posedge_clk
    def read_logic():
      if ( not s.cen ) and s.gwen:
        s.dout.next = s.ram[ s.a ]
      else:
        s.dout.next = 0

    # write path
    @s.posedge_clk
    def write_logic():
      if ( not s.cen ) and ( not s.gwen ):
        s.ram[s.a].next = (s.ram[s.a] & s.wen) | (s.d & ~s.wen)

    @s.combinational
    def comb_logic():
      s.q.value = s.dout


  def line_trace( s ):
    wr = ( not s.cen ) and ( not s.gwen )
    rd = ( not s.cen ) and       s.gwen

    wr_str = '->' if wr else '  '
    rd_str = '->' if rd else '  '

    return '({} {} sram[{}] {} {})'.format( s.d, wr_str, s.a, rd_str, s.q )
