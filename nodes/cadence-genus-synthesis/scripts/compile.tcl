#=========================================================================
# compile.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : September 28, 2020

set_attr uniquify_naming_style "%s_%d"
uniquify $design_name

# Obey flattening effort of mflowgen graph
set_attribute auto_ungroup $auto_ungroup_val

syn_gen
set_attr syn_map_effort high
syn_map
syn_opt
