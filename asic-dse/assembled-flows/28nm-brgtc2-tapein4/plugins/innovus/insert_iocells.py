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

template_file = 'brgtc2_chip.save.io.template'
output_file   = 'brgtc2_chip.save.io'

#-------------------------------------------------------------------------
# Mappings
#-------------------------------------------------------------------------

mappings = {

    # West side, top to bottom (cell 0 on bottom)

    'west_iocell_12'  :  'vss_core_west_1_iocell', # ------- Ground (core)
    'west_iocell_11'  :  'vdd_core_west_1_iocell', # ------- Power (core)
    'west_iocell_10'  :    'vss_dummy_h_6_iocell', # Dummy
    'west_iocell_9'   :    'vss_dummy_h_5_iocell', # Dummy
    'west_iocell_8'   :    'vss_dummy_h_4_iocell', # Dummy
    'west_iocell_7'   :    'vss_dummy_h_3_iocell', # Dummy
    'west_iocell_6'   :    'vss_dummy_h_2_iocell', # Dummy
    'west_iocell_5'   :  'vdd_core_west_0_iocell', # ------- Power (core)
    'west_iocell_4'   :  'vss_core_west_0_iocell', # ------- Ground (core)
    'west_iocell_3'   :    'vss_dummy_h_1_iocell', # Dummy
    'west_iocell_2'   :    'vdd_io_west_0_iocell', # ------- Power (IO)
    'west_iocell_1'   :    'vss_dummy_h_0_iocell', # Dummy
    'west_iocell_0'   :    'vss_io_west_0_iocell', # ------- Ground (IO)

    # North side, left to right

    'north_iocell_0'  :   'vss_io_north_0_iocell', # ------- Ground (IO)
    'north_iocell_1'  : 'vss_core_north_0_iocell', # ------- Ground (core)
    'north_iocell_2'  : 'vdd_core_north_0_iocell', # ------- Power (core)
    'north_iocell_3'  :   'vdd_io_north_0_iocell', # ------- Power (IO)
    'north_iocell_4'  :        'out_msg_0_iocell', # Output
    'north_iocell_5'  :        'out_msg_1_iocell', # Output
    'north_iocell_6'  :   'vss_io_north_1_iocell', # ------- Ground (IO)
    'north_iocell_7'  :        'out_msg_2_iocell', # Output
    'north_iocell_8'  :        'out_msg_3_iocell', # Output
    'north_iocell_9'  : 'vdd_core_north_1_iocell', # ------- Power (core)
    'north_iocell_10' : 'vss_core_north_1_iocell', # ------- Ground (core)
    'north_iocell_11' :        'out_msg_4_iocell', # Output
    'north_iocell_12' :        'out_msg_5_iocell', # Output
    'north_iocell_13' :   'vdd_io_north_1_iocell', # ------- Power (IO)
    'north_iocell_14' :        'out_msg_6_iocell', # Output
    'north_iocell_15' :        'out_msg_7_iocell', # Output
    'north_iocell_16' : 'vss_core_north_2_iocell', # ------- Ground (core)
    'north_iocell_17' : 'vdd_core_north_2_iocell', # ------- Power (core)
    'north_iocell_18' :   'vss_io_north_2_iocell', # ------- Ground (IO)

    # East side, top to bottom (cell 0 on bottom)

    'east_iocell_12'  :    'vss_io_east_1_iocell', # ------- Ground (IO)
    'east_iocell_11'  :          'out_req_iocell', # Output
    'east_iocell_10'  :    'vdd_io_east_0_iocell', # ------- Power (IO)
    'east_iocell_9'   :          'out_ack_iocell', # Input
    'east_iocell_8'   :  'vdd_core_east_1_iocell', # ------- Power (core)
    'east_iocell_7'   :  'vss_core_east_1_iocell', # ------- Ground (core)
    'east_iocell_6'   :  'vdd_core_east_0_iocell', # ------- Power (core)
    'east_iocell_5'   :  'vss_core_east_0_iocell', # ------- Ground (core)
    'east_iocell_4'   :            'reset_iocell', # Input
    'east_iocell_3'   :   'vdd_poc_east_0_iocell', # ------- Power (IO) (POC)
    'east_iocell_2'   :    'vss_dummy_h_8_iocell', # Dummy
    'east_iocell_1'   :    'vss_dummy_h_7_iocell', # Dummy
    'east_iocell_0'   :    'vss_io_east_0_iocell', # ------- Ground (IO)

    # South side, left to right

    'south_iocell_0'  :   'vss_io_south_0_iocell', # ------- Ground (IO)
    'south_iocell_1'  :              'clk_iocell', # Clock
    'south_iocell_2'  : 'vss_core_south_0_iocell', # ------- Ground (core)
    'south_iocell_3'  : 'vdd_core_south_0_iocell', # ------- Power (core)
    'south_iocell_4'  :    'vss_dummy_v_0_iocell', # Dummy
    'south_iocell_5'  :        'in__msg_0_iocell', # Input
    'south_iocell_6'  :        'in__msg_1_iocell', # Input
    'south_iocell_7'  :        'in__msg_2_iocell', # Input
    'south_iocell_8'  :        'in__msg_3_iocell', # Input
    'south_iocell_9'  :        'in__msg_4_iocell', # Input
    'south_iocell_10' :        'in__msg_5_iocell', # Input
    'south_iocell_11' :        'in__msg_6_iocell', # Input
    'south_iocell_12' :        'in__msg_7_iocell', # Input
    'south_iocell_13' :          'in__req_iocell', # Input
    'south_iocell_14' : 'vss_core_south_1_iocell', # ------- Ground (core)
    'south_iocell_15' : 'vdd_core_south_1_iocell', # ------- Power (core)
    'south_iocell_16' :   'vdd_io_south_0_iocell', # ------- Power (IO)
    'south_iocell_17' :          'in__ack_iocell', # Output
    'south_iocell_18' :   'vss_io_south_1_iocell', # ------- Ground (IO)

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

