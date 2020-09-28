#=========================================================================
# setup-session.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : September 28, 2020
#
# Set up variables for this specific ASIC design kit

source -echo -verbose "inputs/adk/adk.tcl"

set_attr library     $vars(libs_typical,timing)
set_attr lef_library $vars(lef_files)

set_attr qrc_tech_file $vars(qrcTechFile)

set_attr hdl_flatten_complex_port true

