#! /usr/bin/env python
#=========================================================================
# summarize_area.py
#=========================================================================
# Summarize area report from DC for brgtc2
#
# Date   : May 11, 2018
# Author : Christopher Torng
#

import argparse
import sys

from glob import glob

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

class ArgumentParserWithCustomError(argparse.ArgumentParser):
  def error( self, msg = "" ):
    if ( msg ): print("\n ERROR: %s" % msg)
    print("")
    file = open( sys.argv[0] )
    for ( lineno, line ) in enumerate( file ):
      if ( line[0] != '#' ): sys.exit(msg != "")
      if ( (lineno == 2) or (lineno >= 4) ): print( line[1:].rstrip("\n") )

def parse_cmdline():
  p = ArgumentParserWithCustomError( add_help=False )
  p.add_argument( "-v", "--verbose",  action="store_true" )
  p.add_argument( "-h", "--help",     action="store_true" )
  p.add_argument(       "--detailed", action="store_true" )
  opts = p.parse_args()
  if opts.help: p.error()
  return opts

#-------------------------------------------------------------------------
# Categories
#-------------------------------------------------------------------------

# Normalize all other area results to the sum of the area of this list

normalization_group = [
  'dut',
  'in_deserialize',
  'in_split',
  'in_q_000',
  'in_q_001',
  'in_q_002',
  'in_q_003',
  'in_q_004',
  'in_q_005',
  'in_q_006',
  'in_q_007',
  'in_q_008',
  'in_q_009',
  'out_merge',
  'out_serialize',
]

# List of instances to grab from DC area report

instances = [
  'dut',
  'dut/ctrlreg',
  'dut/dcache',
  'dut/dcache/ctrl/dirty_bits_0',
  'dut/dcache/ctrl/dirty_bits_1',
  'dut/dcache/ctrl/lru_bits',
  'dut/dcache/ctrl/valid_bits_0',
  'dut/dcache/ctrl/valid_bits_1',
  'dut/dcache/dpath/data_array_0/sram',
  'dut/dcache/dpath/data_array_1/sram',
  'dut/dcache/dpath/tag_array_0/sram',
  'dut/dcache/dpath/tag_array_1/sram',
  'dut/icache',
  'dut/icache/ctrl/dirty_bits_0',
  'dut/icache/ctrl/dirty_bits_1',
  'dut/icache/ctrl/lru_bits',
  'dut/icache/ctrl/valid_bits_0',
  'dut/icache/ctrl/valid_bits_1',
  'dut/icache/dpath/data_array_0/sram',
  'dut/icache/dpath/data_array_1/sram',
  'dut/icache/dpath/tag_array_0/sram',
  'dut/icache/dpath/tag_array_1/sram',
  'dut/l0i_000',
  'dut/l0i_000/inner/dpath/data_array',
  'dut/l0i_001',
  'dut/l0i_001/inner/dpath/data_array',
  'dut/l0i_002',
  'dut/l0i_002/inner/dpath/data_array',
  'dut/l0i_003',
  'dut/l0i_003/inner/dpath/data_array',
  'dut/fpu',
  'dut/fpu/fp_addsub',
  'dut/fpu/fp_cmp',
  'dut/fpu/fp_div',
  'dut/fpu/fp_flt2i',
  'dut/fpu/fp_i2flt',
  'dut/fpu/fp_mult',
  'dut/mdu',
  'dut/mdu/idiv',
  'dut/mdu/imul',
  'dut/net_dcachereq',
  'dut/net_dcacheresp',
  'dut/net_mdureq',
  'dut/net_mduresp',
  'dut/proc_000',
  'dut/proc_000/dpath/alu_X',
  'dut/proc_000/dpath/rf',
  'dut/proc_001',
  'dut/proc_001/dpath/alu_X',
  'dut/proc_001/dpath/rf',
  'dut/proc_002',
  'dut/proc_002/dpath/alu_X',
  'dut/proc_002/dpath/rf',
  'dut/proc_003',
  'dut/proc_003/dpath/alu_X',
  'dut/proc_003/dpath/rf',
  'dut/xcel_000',
  'dut/xcel_000/bloom_filter',
  'dut/xcel_001',
  'dut/xcel_001/bloom_filter',
  'dut/xcel_002',
  'dut/xcel_002/bloom_filter',
  'dut/xcel_003',
  'dut/xcel_003/bloom_filter',
  'in_deserialize',
  'in_split',
  'in_q_000',
  'in_q_001',
  'in_q_002',
  'in_q_003',
  'in_q_004',
  'in_q_005',
  'in_q_006',
  'in_q_007',
  'in_q_008',
  'in_q_009',
  'out_merge',
  'out_serialize',
]

# Groups of instances for summary report

groups = {

  'design': [
    'dut',
    'in_deserialize',
    'in_split',
    'in_q_000',
    'in_q_001',
    'in_q_002',
    'in_q_003',
    'in_q_004',
    'in_q_005',
    'in_q_006',
    'in_q_007',
    'in_q_008',
    'in_q_009',
    'out_merge',
    'out_serialize',
    ],

  'ctrlreg': [
    'dut/ctrlreg',
    ],

  'dcache': [
    'dut/dcache',
    ],

  'icache': [
    'dut/icache',
    ],

  'l0': [
    'dut/l0i_000',
    'dut/l0i_001',
    'dut/l0i_002',
    'dut/l0i_003',
    ],

  'fpu': [
    'dut/fpu',
    'dut/fpu/fp_addsub',
    'dut/fpu/fp_cmp',
    'dut/fpu/fp_div',
    'dut/fpu/fp_flt2i',
    'dut/fpu/fp_i2flt',
    'dut/fpu/fp_mult',
    ],

  'mdu': [
    'dut/mdu',
    ],

  'net': [
    'dut/net_dcachereq',
    'dut/net_dcacheresp',
    'dut/icache_coalescer',
    'dut/net_mdureq',
    'dut/net_mduresp',
    ],

  'proc': [
    'dut/proc_000',
    'dut/proc_001',
    'dut/proc_002',
    'dut/proc_003',
    ],

  'xcel': [
    'dut/xcel_000',
    'dut/xcel_001',
    'dut/xcel_002',
    'dut/xcel_003',
    ],

  'host': [
    'in_deserialize',
    'in_split',
    'in_q_000',
    'in_q_001',
    'in_q_002',
    'in_q_003',
    'in_q_004',
    'in_q_005',
    'in_q_006',
    'in_q_007',
    'in_q_008',
    'in_q_009',
    'out_merge',
    'out_serialize',
    ],

}

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

def main():
  opts = parse_cmdline()

  # Path to DC area report from build directory

  report_path = 'reports/dc-synthesis/*.mapped.area.rpt'

  #-------------------------------------------------------------------------
  # Main
  #-------------------------------------------------------------------------

  # Grab the data from the report

  report = glob( report_path )[0]

  with open( report, 'r' ) as fd:
    lines = fd.readlines()
    lines = [ x.strip() for x in lines ]

  # Filter out empty lines, and then filter to only the lines in the
  # list of instances we want to see

  lines = filter( lambda l: l.strip() != '', lines )
  lines = filter( lambda l: l.split()[0] in instances, lines )

  # Grab the first column (has instance name), second column (has area in
  # um2), and last column (has module name)

  lines = [ l.split() for l in lines ]
  lines = [ { 'inst'   : l[0],
              'area'   : l[1],
              'module' : l[-1] } for l in lines ]

  # Add an extra column for percentage area of normalization instance

  normalization_instance_areas = \
    [ filter( lambda l: l['inst'] == inst, lines )[0]['area'] \
        for inst in normalization_group ]

  normalizer_area = \
    reduce( lambda a, b: float(a) + float(b), normalization_instance_areas )

  for l in lines:
    l['pc_area'] = float(l['area']) / float(normalizer_area) * 100

  # Create summary data by aggregating all data within each group into a
  # single area number per group

  summary_data = []

  for group, instlist in groups.iteritems():
    area_list    = [ l['area']    for l in lines if l['inst'] in instlist ]
    pc_area_list = [ l['pc_area'] for l in lines if l['inst'] in instlist ]
    area_list    = [ float(x) for x in area_list ]
    pc_area_list = [ float(x) for x in pc_area_list ]
    summary_data.append( \
        { 'name'    : group,
          'area'    : reduce( lambda a, b: a + b, area_list),
          'pc_area' : reduce( lambda a, b: a + b, pc_area_list) } )

  #-------------------------------------------------------------------------
  # Print detailed report
  #-------------------------------------------------------------------------

  if opts.detailed:

    # Print the detailed header

    detailed_header_template_str = \
        '{inst:36}    {area:>12}    {pc_area:<9}    {module}'

    print detailed_header_template_str.format( inst    = 'Instance',
                                               area    = 'Area',
                                               pc_area = 'Percent',
                                               module  = 'Module' )
    print '-'*80

    # Print the detailed data

    detailed_template_str = \
        '{inst:36} -- {area:>12} -- {pc_area:>6.2f} -- {module}'

    details = [ detailed_template_str.format( \
                  inst    = l['inst'],
                  area    = l['area'],
                  pc_area = l['pc_area'],
                  module  = l['module'] ) for l in lines ]

    for _ in details:
      print _

    print

  #-------------------------------------------------------------------------
  # Print summary report
  #-------------------------------------------------------------------------

  # Sort the summary data by area

  sorted_summary_data = sorted( summary_data,
                                reverse=True,
                                key=lambda(x):x['area'] )

  # Print the summary header

  summary_header_template_str = \
      '{group:16}    {area:>12}    {pc_area:<9}'

  print summary_header_template_str.format( group   = 'Group',
                                            area    = 'Area',
                                            pc_area = 'Percent' )
  print '-'*60

  # Print the summary

  summary_template_str = \
      '{group:16} -- {area:>12} -- {pc_area:>6.2f}'

  summary = [ summary_template_str.format( \
                group   = l['name'],
                area    = l['area'],
                pc_area = l['pc_area'] ) for l in sorted_summary_data ]

  for _ in summary:
    print _

  print


main()

