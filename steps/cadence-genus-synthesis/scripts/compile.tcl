#=========================================================================
# compile.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : September 28, 2020

set_attr uniquify_naming_style "%s_%d"
uniquify $design_name

# Obey flattening effort of mflowgen graph
set_attribute auto_ungroup $auto_ungroup_val

# FIXME technology specific
set_attribute avoid true [get_lib_cells {*/E* */G* *D16* *D20* *D24* *D28* *D32* SDF* *DFM*}]
# don't use Scan enable D flip flops
set_attribute avoid true [get_lib_cells {*SEDF*}]

syn_gen
set_attr syn_map_effort high
syn_map
syn_opt
