#! /usr/bin/env python
#=========================================================================
# insert_iocells.py
#=========================================================================
# Fill in the template Innovus IO floorplan file (*.save.io)
#
# The *.save.io.template file is populated to create the *.save.io IO
# floorplanning file to be read in by Innovus during floorplanning.
#
# The template file has placeholders like this:
#
#     (inst  name="{west_iocell_0}" offset=38.3400 )
#     (inst  name="{west_iocell_1}" offset=88.3400 )
#     (inst  name="{west_iocell_2}" offset=138.3400 )
#     (inst  name="{west_iocell_3}" offset=188.3400 )
#
#     (...)
#
#     (inst  name="{east_iocell_0}" offset=38.3400 )
#     (inst  name="{east_iocell_1}" offset=88.3400 )
#     (inst  name="{east_iocell_2}" offset=138.3400 )
#     (inst  name="{east_iocell_3}" offset=188.3400 )
#
# These just get substituted in.
#
# Date   : April 18, 2018
# Author : Christopher Torng
#

template_file = 'HostButterfree.save.io.template'
output_file   = 'HostButterfree.save.io'

#-------------------------------------------------------------------------
# Mappings
#-------------------------------------------------------------------------

mappings = {

    # West side, top to bottom (cell 0 on bottom)

    'west_iocell_12'  :     'vss_core_5_iocell', # ------- Ground (core)
    'west_iocell_11'  :     'vdd_core_5_iocell', # ------- Power (core)
    'west_iocell_10'  :  'vss_dummy_h_6_iocell', # Dummy
    'west_iocell_9'   :  'vss_dummy_h_5_iocell', # Dummy
    'west_iocell_8'   :  'vss_dummy_h_4_iocell', # Dummy
    'west_iocell_7'   :     'vss_core_4_iocell', # ------- Ground (core)
    'west_iocell_6'   :     'vdd_core_4_iocell', # ------- Power (core)
    'west_iocell_5'   :  'vss_dummy_h_3_iocell', # Dummy
    'west_iocell_4'   :  'vss_dummy_h_2_iocell', # Dummy
    'west_iocell_3'   :  'vss_dummy_h_1_iocell', # Dummy
    'west_iocell_2'   :  'vss_dummy_h_0_iocell', # Dummy
    'west_iocell_1'   :     'vdd_core_3_iocell', # ------- Power (core)
    'west_iocell_0'   :     'vss_core_3_iocell', # ------- Ground (core)

    # North side, left to right

    'north_iocell_0'  :  'vss_io_0_iocell', # ------- Ground (IO)
    'north_iocell_1'  : 'out_msg_0_iocell', # Output
    'north_iocell_2'  :  'vdd_io_0_iocell', # ------- Power (IO)
    'north_iocell_3'  : 'out_msg_1_iocell', # Output
    'north_iocell_4'  :  'vss_io_1_iocell', # ------- Ground (IO)
    'north_iocell_5'  : 'out_msg_2_iocell', # Output
    'north_iocell_6'  :  'vdd_io_1_iocell', # ------- Power (IO)
    'north_iocell_7'  : 'out_msg_3_iocell', # Output
    'north_iocell_8'  : 'out_msg_4_iocell', # Output
    'north_iocell_9'  :  'vss_io_2_iocell', # ------- Ground (IO)
    'north_iocell_10' : 'out_msg_5_iocell', # Output
    'north_iocell_11' : 'out_msg_6_iocell', # Output
    'north_iocell_12' :  'vdd_io_2_iocell', # ------- Power (IO)
    'north_iocell_13' : 'out_msg_7_iocell', # Output
    'north_iocell_14' :  'vss_io_3_iocell', # ------- Ground (IO)
    'north_iocell_15' :   'out_req_iocell', # Output
    'north_iocell_16' :  'vdd_io_3_iocell', # ------- Power (IO)
    'north_iocell_17' :   'out_ack_iocell', # Input
    'north_iocell_18' :  'vss_io_4_iocell', # ------- Ground (IO)

    # East side, top to bottom (cell 0 on bottom)

    'east_iocell_12'  :     'vss_core_8_iocell', # ------- Ground (core)
    'east_iocell_11'  :     'vdd_core_8_iocell', # ------- Power (core)
    'east_iocell_10'  : 'vss_dummy_h_12_iocell', # Dummy
    'east_iocell_9'   : 'vss_dummy_h_11_iocell', # Dummy
    'east_iocell_8'   : 'vss_dummy_h_10_iocell', # Dummy
    'east_iocell_7'   :     'vss_core_7_iocell', # ------- Ground (core)
    'east_iocell_6'   :     'vdd_core_7_iocell', # ------- Power (core)
    'east_iocell_5'   :  'vss_dummy_h_9_iocell', # Dummy
    'east_iocell_4'   :  'vss_dummy_h_8_iocell', # Dummy
    'east_iocell_3'   :  'vss_dummy_h_7_iocell', # Dummy
    'east_iocell_2'   :          'reset_iocell', # Input
    'east_iocell_1'   :     'vdd_core_6_iocell', # ------- Power (core)
    'east_iocell_0'   :     'vss_core_6_iocell', # ------- Ground (core)

    # South side, left to right

    'south_iocell_0'  : 'vss_core_0_iocell', # ------- Ground (core)
    'south_iocell_1'  : 'vdd_core_0_iocell', # ------- Power (core)
    'south_iocell_2'  :  'in__msg_0_iocell', # Input
    'south_iocell_3'  :  'in__msg_1_iocell', # Input
    'south_iocell_4'  :  'in__msg_2_iocell', # Input
    'south_iocell_5'  :  'in__msg_3_iocell', # Input
    'south_iocell_6'  :  'in__msg_4_iocell', # Input
    'south_iocell_7'  : 'vdd_core_1_iocell', # ------- Power (core)
    'south_iocell_8'  : 'vss_core_1_iocell', # ------- Ground (core)
    'south_iocell_9'  :        'clk_iocell', # Clock
    'south_iocell_10' : 'vss_core_2_iocell', # ------- Ground (core)
    'south_iocell_11' : 'vdd_core_2_iocell', # ------- Power (core)
    'south_iocell_12' :  'in__msg_5_iocell', # Input
    'south_iocell_13' :  'in__msg_6_iocell', # Input
    'south_iocell_14' :  'in__msg_7_iocell', # Input
    'south_iocell_15' :    'in__req_iocell', # Input
    'south_iocell_16' :  'vdd_poc_0_iocell', # ------- Power (IO) (POC)
    'south_iocell_17' :    'in__ack_iocell', # Output
    'south_iocell_18' :   'vss_io_5_iocell', # ------- Ground (IO)

}

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

# Read in the template file

print "- Reading " + template_file + "..."

with open( template_file, 'r') as fd:
  template = fd.read()

# Populate the placeholders

print "- Populating template..."

output = template.format( **mappings )

print "- Writing " + output_file + "..."

# Write out the IO floorplan file

with open( output_file, 'w') as fd:
  fd.write( output )

print "- Done!"

