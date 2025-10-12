#=========================================================================
# generate-results.tcl
#=========================================================================
# Write out the design
#
# Author : Christopher Torng
# Date   : May 14, 2018
#

# Write the .namemap file for energy analysis

if {[file exists "inputs/run.saif" ]} {
  saif_map                   \
    -create_map              \
    -input "inputs/run.saif" \
    -source_instance ${dc_saif_instance}
}

# Write out files

write -format ddc \
      -hierarchy  \
      -output ${dc_results_dir}/${dc_design_name}.mapped.ddc

write -format verilog \
      -hierarchy      \
      -output ${dc_results_dir}/${dc_design_name}.mapped.v

write -format svsim \
      -output ${dc_results_dir}/${dc_design_name}.mapped.svwrapper.v

# Dump the mapped.v and svwrapper.v into one svsim.v file to make it
# easier to include a single file for gate-level simulation. The svwrapper
# matches the interface of the original RTL even if using SystemVerilog
# features (e.g., array of arrays, uses parameters, etc.).

sh cat ${dc_results_dir}/${dc_design_name}.mapped.v \
       ${dc_results_dir}/${dc_design_name}.mapped.svwrapper.v \
       > ${dc_results_dir}/${dc_design_name}.mapped.svsim.v

# Write top-level verilog view needed for block instantiation

write             \
  -format verilog \
  -output ${dc_results_dir}/${dc_design_name}.mapped.top.v

# Floorplan

if { $dc_topographical == True } {
  write_floorplan -all ${dc_results_dir}/${dc_design_name}.mapped.fp
}

# Parasitics

write_parasitics -output ${dc_results_dir}/${dc_design_name}.mapped.spef

# SDF for back-annotated gate-level simulation

write_sdf ${dc_results_dir}/${dc_design_name}.mapped.sdf

# Do not write out net RC info into SDC

set_app_var write_sdc_output_lumped_net_capacitance false
set_app_var write_sdc_output_net_resistance false

# SDC constraints

write_sdc -nosplit ${dc_results_dir}/${dc_design_name}.mapped.sdc

# UPF
if {[file exists $dc_upf]} {
  save_upf ${dc_results_dir}/${dc_design_name}.upf
}

