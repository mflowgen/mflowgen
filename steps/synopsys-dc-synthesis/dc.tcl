#=========================================================================
# dc.tcl
#=========================================================================
# We use Synopsys DC to synthesize a single RTL netlist file into gates.
#
# This script has evolved over time inspired by (1) the Synopsys reference
# methodology scripts that are released year after year on Solvnet, (2)
# synthesis scripts from other research groups, as well as (3) reference
# papers from user groups online.
#
# If you make a major update to this script (e.g., update inspired by the
# latest version of the Synopsys reference methodology), please list the
# changeset in the version history below.
#
# Author : Christopher Torng
# Date   : September 30, 2018
#
#-------------------------------------------------------------------------
# Version History
#-------------------------------------------------------------------------
#
# - 09/30/2018 -- Christopher Torng
#     - Clean slate DC scripts
#     - We are now independent of the Synopsys Reference Methodology
#     - Version of Synopsys DC running "% dc_shell -v":
#         dc_shell version    -  M-2016.12
#         dc_shell build date -  Nov 21, 2016
#
# - 04/08/2018 -- Christopher Torng
#     - Our original version was based on the Synopsys reference
#       methodology (D-2010.03-SP1)
#     - Big update now inspired by the Celerity Synopsys DC scripts, which
#       were in turn also based on the Synopsys reference methodology
#       (L-2016.03-SP2)
#
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
# Designer interface
#-------------------------------------------------------------------------
# Source the designer interface script, which sets up variables from the
# build system, sets up ASIC design kit variables, etc.

source -echo -verbose designer_interface.tcl

#-------------------------------------------------------------------------
# Pre-synthesis plugin
#-------------------------------------------------------------------------

if {[file exists [which $dc_pre_synthesis_plugin]]} {
  puts "Info: Reading pre-synth plugin: $dc_pre_synthesis_plugin"
  source -echo -verbose $dc_pre_synthesis_plugin
}

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------

# Set up variables for this specific ASIC design kit

set SYNOPSYS_TOOL "dc-syn"
source -echo -verbose $dc_adk_tcl

# Multicore support -- watch how many licenses we have!

set_host_options -max_cores $dc_num_cores

# Set up alib caching for faster consecutive runs

set_app_var alib_library_analysis_path $dc_alib_dir

# Set up tracking for Synopsys Formality

set_svf ${dc_results_dir}/${dc_design_name}.mapped.svf

# Set up search path for libraries and design files

set_app_var search_path ". $dc_additional_search_path $search_path"

# Important app vars
#
# - target_library    -- DC maps the design to gates in this library (db)
# - synthetic_library -- DesignWare library (sldb)
# - link_library      -- Libraries for any other design references (e.g.,
#                        SRAMs, hierarchical blocks, macros, IO libs) (db)

set_app_var target_library     $dc_target_libraries
set_app_var synthetic_library  dw_foundation.sldb
set_app_var link_library       [join "
                                 *
                                 $target_library
                                 $dc_extra_link_libraries
                                 $synthetic_library
                               "]


# SAIF mapping.
                               #
saif_map -start

# Create Milkyway library
#
# By default, Milkyway libraries only have 180 or so layers available to
# use (255 total, but some are reserved). The extend_mw_layers command
# expands the Milkyway library to accommodate up to 4095 layers.

# Only create new Milkyway design library if it doesn't already exist

set milkyway_library ${dc_design_name}_lib

if {![file isdirectory $milkyway_library ]} {

  # Create a new Milkyway library

  extend_mw_layers
  create_mw_lib -technology           $dc_milkyway_tf            \
                -mw_reference_library $dc_milkyway_ref_libraries \
                $milkyway_library

} else {

  # Reuse existing Milkyway library, but ensure that it is consistent with
  # the provided reference Milkyway libraries.

  set_mw_lib_reference $milkyway_library \
    -mw_reference_library $dc_milkyway_ref_libraries

}

open_mw_lib $milkyway_library

# Set up TLU plus (if the files exist)

if { $dc_topographical == True } {
  if {[file exists [which $dc_tluplus_max]]} {
    set_tlu_plus_files -max_tluplus  $dc_tluplus_max \
                       -min_tluplus  $dc_tluplus_min \
                       -tech2itf_map $dc_tluplus_map

    check_tlu_plus_files
  }
}

# Avoiding X-propagation for synchronous reset DFFs
#
# There are two key variables that help avoid X-propagation for
# synchronous reset DFFs:
#
# - set hdlin_ff_always_sync_set_reset true
#
#     - Tells DC to use every constant 0 loaded into a DFF with a clock
#       for synchronous reset, and every constant 1 loaded into a DFF with a
#       clock for synchronous set
#
# - set compile_seqmap_honor_sync_set_reset true
#
#     - Tells DC to preserve synchronous reset or preset logic close to
#       the flip-flop
#
# So the hdlin variable first tells DC to treat resets as synchronous, and
# the compile variable tells DC that for all these synchronous reset DFFs,
# keep the logic simple and close to the DFF to avoid X-propagation. The
# hdlin variable applies to the analyze step when we read in the RTL, so
# it must be set before we read in the Verilog. The second variable
# applies to compile and must be set before we run compile_ultra.
#
# Note: Instead of setting the hdlin_ff_always_sync_set_reset variable to
# true, you can specifically tell DC about a particular DFF reset using
# the //synopsys sync_set_reset "reset, int_reset" pragma.
#
# By default, the hdlin_ff_always_async_set_reset variable is set to true,
# and the hdlin_ff_always_sync_set_reset variable is set to false.

set hdlin_ff_always_sync_set_reset      true
set compile_seqmap_honor_sync_set_reset true

# Remove new variable info messages from the end of the log file

set_app_var sh_new_variable_message false

# Corners
#
# If we want to do corners in DC, then we would use this command to set
# the min and max libraries:

#set_min_library $max_library -min_version $min_library

# SAIF Name Mapping Database

#if { ${VINAME} != "NONE" } {
#  saif_map -start
#}

# Hook to drop into interactive Design Compiler shell after setup

if {[info exists ::env(DC_EXIT_AFTER_SETUP)]} { return }

#-------------------------------------------------------------------------
# Read design
#-------------------------------------------------------------------------

# Check libraries

check_library > $dc_reports_dir/${dc_design_name}.check_library.rpt

# The first "WORK" is a reserved word for Design Compiler. The value for
# the -path option is customizable.

define_design_lib WORK -path ${dc_results_dir}/WORK

# Analyze the RTL source files
#
# Source the read design plugin if it exists. Otherwise, we do a default
# read and elaborate the design.

if {[file exists [which $dc_read_design_plugin]]} {
  puts "Info: Reading read design plugin: $dc_read_design_plugin"
  source -echo -verbose $dc_read_design_plugin
} else {
  # Since no read design plugin exists, we do a default read
  if { ![analyze -format sverilog $dc_rtl_handoff] } { exit 1 }
  if {[file exists [which setup-design-params.txt]]} {
    elaborate $dc_design_name -file_parameters setup-design-params.txt
    rename_design $dc_design_name* $dc_design_name
  } else {
    elaborate $dc_design_name
  }
}

current_design $dc_design_name
link

#-------------------------------------------------------------------------
# Write out useful files
#-------------------------------------------------------------------------

# This ddc can be used as a checkpoint to load up to the current state

write -hierarchy -format ddc \
      -output ${dc_results_dir}/${dc_design_name}.elab.ddc

# This Verilog is useful to double-check the netlist that dc will use for
# mapping

write -hierarchy -format verilog \
      -output ${dc_results_dir}/${dc_design_name}.elab.v

# SAIF name mapping

#if { ${VINAME} != "NONE" } {
#  saif_map -create_map -source_instance ${VINAME} -input rtl-sim.saif
#}
# saif_map -rtl_summary -missing_rtl -report

#-------------------------------------------------------------------------
# Apply design constraints
#-------------------------------------------------------------------------

# Apply logical design constraints

puts "Info: Reading constraints file plugin: $dc_constraints_plugin"

source -echo -verbose $dc_constraints_plugin

# The check_timing command checks for constraint problems such as
# undefined clocking, undefined input arrival times, and undefined output
# constraints. These constraint problems could cause you to overlook
# timing violations. For this reason, the check_timing command is
# recommended whenever you apply new constraints such as clock
# definitions, I/O delays, or timing exceptions.

redirect -tee \
  ${dc_reports_dir}/${dc_design_name}.premapped.checktiming.rpt \
  {check_timing}

# Path groups

set ports_clock_root [filter_collection \
                       [get_attribute [get_clocks] sources] \
                       object_class==port]

group_path -name REGOUT \
           -to   [all_outputs]

group_path -name REGIN \
           -from [remove_from_collection [all_inputs] $ports_clock_root]

group_path -name FEEDTHROUGH \
           -from [remove_from_collection [all_inputs] $ports_clock_root] \
           -to   [all_outputs]

# Apply physical design constraints
#
# Set the minimum and maximum routing layers used in DC topographical mode

if { $dc_topographical == True } {
  set_ignored_layers -min_routing_layer $ADK_MIN_ROUTING_LAYER_DC
  set_ignored_layers -max_routing_layer $ADK_MAX_ROUTING_LAYER_DC

  report_ignored_layers
}

#-------------------------------------------------------------------------
# Additional options
#-------------------------------------------------------------------------

# Replace special characters with non-special ones before writing out the
# synthesized netlist (e.g., "\bus[5]" -> "bus_5_")

set_app_var verilogout_no_tri true

# Prevent assignment statements in the Verilog netlist.

set_fix_multiple_port_nets -all -buffer_constants

# Choose design flattening options

if {[info exists DC_FLATTEN_EFFORT]} {
  set dc_flatten_effort $DC_FLATTEN_EFFORT
  if {"$dc_flatten_effort" == ""} {
    set dc_flatten_effort 0
  }
} else {
  set dc_flatten_effort 0
}

puts "Info: Flattening effort (DC_FLATTEN_EFFORT) = $dc_flatten_effort"

set compile_ultra_options ""
if {$dc_flatten_effort == 0} {
  puts "Info: All design hierarchies are preserved unless otherwise specified."
  set_app_var compile_ultra_ungroup_dw false
  puts "Info: Design Compiler compile_ultra boundary optimization is disabled."
  append compile_ultra_options " -no_autoungroup -no_boundary_optimization"

} elseif {$dc_flatten_effort == 1} {
  puts "Info: Unconditionally ungroup the DesignWare cells."
  set_app_var compile_ultra_ungroup_dw true
  puts "Info: Design Compiler compile_ultra automatic ungrouping is disabled."
  puts "Info: Design Compiler compile_ultra boundary optimization is disabled."
  append compile_ultra_options " -no_autoungroup -no_boundary_optimization"

} elseif {$dc_flatten_effort == 2} {
  puts "Info: Unconditionally ungroup the DesignWare cells."
  set_app_var compile_ultra_ungroup_dw true
  puts "Info: Design Compiler compile_ultra automatic ungrouping is enabled."
  puts "Info: Design Compiler compile_ultra boundary optimization is enabled."
  append compile_ultra_options ""

} elseif {$dc_flatten_effort == 3} {
  set ungroup_start_level 2
  ungroup -start_level $ungroup_start_level -all -flatten
  puts "Info: All hierarchical cells starting from level $ungroup_start_level are flattened."
  puts "Info: Unconditionally ungroup the DesignWare cells."
  puts "Info: Design Compiler compile_ultra automatic ungrouping is enabled."
  puts "Info: Design Compiler compile_ultra boundary optimization is enabled."
  set_app_var compile_ultra_ungroup_dw true
  append compile_ultra_options ""

} else {
  puts "Info: Unrecognizable DC_FLATTEN_EFFORT value: $dc_flatten_effort"
  exit
}

# Enable or disable clock gating

if {[info exists DC_GATE_CLOCK]} {
  set dc_gate_clock $DC_GATE_CLOCK
  if {"$dc_gate_clock" == ""} {
    set dc_gate_clock true
  }
} else {
  set dc_gate_clock true
}

puts "Info: Clock gating (DC_GATE_CLOCK) = $dc_gate_clock"

if {$dc_gate_clock == true} {
  append compile_ultra_options " -gate_clock"
}

# Check design for consistency
#
# Most problems with synthesis will be caught in this report

check_design -summary
check_design \
  > ${dc_reports_dir}/${dc_design_name}.premapped.checkdesign.rpt

#-------------------------------------------------------------------------
# Compile
#-------------------------------------------------------------------------

puts "Info: DC compile_ultra options = $compile_ultra_options"

eval "compile_ultra $compile_ultra_options"

# High-effort area optimization
#
# This command was introduced in I-2013.12 and performs monotonic
# gate-to-gate optimization on mapped designs. It is supposed to improve
# area without degrading timing or leakage.

# Skip this step by setting the DC_SKIP_OPTIMIZE_NETLIST variable in the
# pre-synthesis plugin

if {!([info exists DC_SKIP_OPTIMIZE_NETLIST] && $DC_SKIP_OPTIMIZE_NETLIST)} {
  optimize_netlist -area
}

# Check design

check_design -summary
check_design > ${dc_reports_dir}/${dc_design_name}.mapped.checkdesign.rpt

# Write the .namemap file for the Energy analysis

if {[file exists "inputs/run.saif" ]} {
  saif_map -create_map -input "inputs/run.saif" -source_instance ${dc_design_name}
}

#-------------------------------------------------------------------------
# Write out the design
#-------------------------------------------------------------------------

# Synopsys Formality

set_svf -off

# Use naming rules to preserve structs

define_name_rules verilog -preserve_struct_ports

report_names     \
  -rules verilog \
  > ${dc_reports_dir}/${dc_design_name}.mapped.naming.rpt

change_names -rules verilog -hierarchy

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

# If SAIF is used, write out SAIF name mapping file for PrimeTime-PX

#if { ${VINAME} != "NONE" } {
#  saif_map -type ptpx -write_map \
#    ${dc_results_dir}/${dc_design_name}.mapped.saif.namemap
#}

#-------------------------------------------------------------------------
# Final reports
#-------------------------------------------------------------------------

# Report units

redirect -tee \
  ${dc_reports_dir}/${dc_design_name}.mapped.units.rpt \
  {report_units}

# Report QOR

report_qor > ${dc_reports_dir}/${dc_design_name}.mapped.qor.rpt

# Report timing

report_clock_timing \
  -type summary     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.clock.rpt

report_timing \
  -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit      \
  -path_type full_clock -attributes         \
  -nworst 10 -max_paths 30 -delay_type max  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.setup.rpt

report_timing \
  -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit      \
  -path_type full_clock -attributes         \
  -nworst 10 -max_paths 30 -delay_type min  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.hold.rpt

# Report constraints

report_constraint \
  -nosplit        \
  -verbose        \
  > ${dc_reports_dir}/${dc_design_name}.mapped.constraints.rpt

report_constraint \
  -nosplit        \
  -verbose        \
  -all_violators  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.constraints.violators.rpt

report_timing_requirements \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.requirements.rpt

# Report area

report_area  \
  -hierarchy \
  -physical  \
  -nosplit   \
  > ${dc_reports_dir}/${dc_design_name}.mapped.area.rpt

# Report references and resources

report_reference \
  -nosplit       \
  -hierarchy     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.reference.rpt

report_resources \
  -nosplit       \
  -hierarchy     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.resources.rpt

# Report power
#
# Use SAIF file for power analysis

# read_saif -auto_map_names -input ${dc_design_name}.saif \
#   -instance < DESIGN_INSTANCE > -verbose
saif_map -type ptpx -write_map ${dc_reports_dir}/${dc_design_name}.namemap

report_power \
  -nosplit   \
  -hier      \
  > ${dc_reports_dir}/${dc_design_name}.mapped.power.rpt

report_clock_gating \
  -nosplit          \
  > ${dc_reports_dir}/${dc_design_name}.mapped.clock_gating.rpt

#-------------------------------------------------------------------------
# Post-synthesis plugin
#-------------------------------------------------------------------------

if {[file exists [which $dc_post_synthesis_plugin]]} {
  puts "Info: Reading post-synthesis plugin: $dc_post_synthesis_plugin"
  source -echo -verbose $dc_post_synthesis_plugin
}

exit

