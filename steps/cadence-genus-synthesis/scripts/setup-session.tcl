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

if {[file exists $vars(qrcTechFile)]} {
  set_attr qrc_tech_file $vars(qrcTechFile)
}

if {[file exists $vars(capTableFile)]} {
  set_attr cap_table_file $vars(capTableFile)
}

set_attr hdl_flatten_complex_port true

set_attr hdl_resolve_instance_with_libcell true

if {[info exists ADK_DONT_USE_CELL_LIST]} {
  set_attribute avoid true [get_lib_cells $ADK_DONT_USE_CELL_LIST]
}
