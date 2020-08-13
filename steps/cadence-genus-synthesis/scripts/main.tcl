#=========================================================================
# main.tcl
#=========================================================================
# Main Genus script.
#
# Author : Alex Carsello, James Thomas
# Date   : July 14, 2020

set design_name                $::env(design_name)
set clock_period               $::env(clock_period)
set gate_clock                 $::env(gate_clock)
set uniquify_with_design_name  $::env(uniquify_with_design_name)

set_db common_ui false

if { $gate_clock == True } {
  set_attr lp_insert_clock_gating true
}
 
set_attr library    [join "
                      [glob -nocomplain inputs/adk/*.lib]
                      [glob -nocomplain inputs/*.lib]
                    "]

set_attr lef_library [join "
                       inputs/adk/rtk-tech.lef
                       [glob -nocomplain inputs/adk/*.lef]
                       [glob -nocomplain inputs/*.lef]
                     "]

set_attr qrc_tech_file [list inputs/adk/pdk-typical-qrcTechFile]

read_hdl -sv [glob -directory inputs -type f *.v *.sv]
elaborate $design_name

source "inputs/adk/adk.tcl"

source -verbose "inputs/constraints.tcl"

if { $uniquify_with_design_name == True } {
  set_attr uniquify_naming_style "${design_name}_%s_%d"
  uniquify $design_name
}

# FIXME technology specific
set_attribute avoid true [get_lib_cells {*/E* */G* *D16* *D20* *D24* *D28* *D32* SDF* *DFM*}]
# don't use Scan enable D flip flops
set_attribute avoid true [get_lib_cells {*SEDF*}]

syn_gen
set_attr syn_map_effort high
syn_map
syn_opt 

