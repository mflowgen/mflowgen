#=========================================================================
# SramPRTL.py
#=========================================================================
# This is a unified module to help include SRAMs in designs. The module
# will either select a generic memory or a technology-specific memory
# based on technology-node parameter.
#
# If an SRAM doesn't exist for the technology node selected, this module
# would instantiate a generic SRAM.
#
# Author : Khalid Al-Hawaj
# Date   : 24th April 2018

import importlib

from pymtl import *

class SramRTL( Model ):

  # Constructor

  def __init__( s, num_bits = 32, num_words = 256, tech_node = 'generic', instance_name = '' ):

    addr_width = clog2( num_words )      # address width
    nbytes     = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.wen  = InPort ( 1 )          # write en
    s.cen  = InPort ( 1 )          # whole SRAM en
    s.addr = InPort ( addr_width ) # address
    s.in_  = InPort ( num_bits )   # write data
    s.out  = OutPort( num_bits )   # read data
    s.mask = InPort ( nbytes )     # byte write en

    #---------------------------------------------------------------------
    # Load Appropriate Model
    #---------------------------------------------------------------------

    sram_class = None

    if tech_node != 'generic':
      class_name = 'SramWrapper{}PRTL'.format(tech_node)

      try:
        sram_module = importlib.import_module('.{}'.format(class_name), 'sram')
        sram_class  = getattr(sram_module, class_name)
      except Exception as e:
        pass

    if sram_class == None:
      from sram import SramGenericPRTL as sram_class

    #---------------------------------------------------------------------
    # Instantiate an SRAM
    #---------------------------------------------------------------------

    s.sram = sram_class( num_bits, num_words, instance_name )

    #---------------------------------------------------------------------
    # Connect ports
    #---------------------------------------------------------------------

    s.connect_pairs(

      # Inputs
      s.wen     , s.sram.wen ,
      s.cen     , s.sram.cen ,
      s.addr    , s.sram.addr,
      s.in_     , s.sram.in_ ,
      s.mask    , s.sram.mask,

      # Outputs
      s.sram.out, s     .out ,

    )

  def line_trace( s ):
    return s.sram.line_trace()
