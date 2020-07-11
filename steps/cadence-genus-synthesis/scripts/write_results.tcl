#=========================================================================
# write_results.tcl
#=========================================================================
# Write Genus results.
#
# Author : Alex Carsello, James Thomas
# Date   : July 14, 2020

write_snapshot -directory results_syn -tag final
write_design -innovus -basename results_syn/syn_out

write_name_mapping

