#=========================================================================
# write_results.tcl
#=========================================================================
# Write Genus results.
#
# Author : Alex Carsello, James Thomas
# Date   : July 14, 2020

write_snapshot -directory results_syn -tag final
write_design -innovus -basename results_syn/syn_out
write_sdf > results_syn/syn_out.sdf
write_spef > results_syn/syn_out.spef

write_name_mapping

