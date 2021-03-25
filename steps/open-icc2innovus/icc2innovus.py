#=========================================================================
# icc2innovus.py
#=========================================================================
# Converts ICC ECO commands to Innovus ECO commands.
#
# Author : Kartik Prabhu
# Date   : September 21, 2020
#


import re

# Main Changes:
# size_cell -> ecoChangeCell 
# insert_buffer -> ecoAddRepeater
# remove_buffer -> ecoDeleteRepeater

innovus_size_cell_cmd = "ecoChangeCell -inst {} -cell {}\n"
innovus_insert_buffer_cmd = "ecoAddRepeater -term {} -cell {} -name {}\n"
innovus_remove_buffer_cmd = "ecoDeleteRepeater -inst {}\n"

with open('inputs/icc_eco.tcl') as icc_eco, open('outputs/innovus_eco.tcl', 'w') as innovus_eco:
    for icc_eco_cmd in icc_eco:

        # skip comments
        if re.match("#", icc_eco_cmd):
            continue
        
        # current instance command is used to set the instance path
        elif re.match("current_instance", icc_eco_cmd):
            m = re.match(r"current_instance {(\S+)}", icc_eco_cmd)
            
            if m:
                instPath = m.groups()[0] + "/"
            else:
                instPath = ""
            
        elif re.match("size_cell", icc_eco_cmd):
            m = re.match(r"size_cell {(\S+)} {(\S+)}", icc_eco_cmd)

            inst, cell = m.groups()

            innovus_eco.write(innovus_size_cell_cmd.format(instPath+inst, cell))
        
        elif re.match("remove_buffer", icc_eco_cmd):
            m = re.match(r"remove_buffer \[get_cells {(\S+)}\]", icc_eco_cmd)

            inst = m.groups()[0]
            innovus_eco.write(innovus_remove_buffer_cmd.format(instPath+inst, cell))
        
        else:
            print("WARNING: Unknown command!")
            print(icc_eco_cmd)        
 
