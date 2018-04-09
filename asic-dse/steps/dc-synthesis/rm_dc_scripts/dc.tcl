source -echo -verbose $::env(dc_flow_dir)/rm_setup/dc_setup.tcl

#################################################################################
# Source the user plugin for pre-synthesis
#################################################################################
# ctorng: Adding this step to match the rest of the build system

if {[file exists [which ${pre_synthesis_plugin}]]} {
  puts "Info: Reading in the pre-synthesis plugin [which ${pre_synthesis_plugin}]\n"
  source -echo -verbose ${pre_synthesis_plugin}
}

#################################################################################
# Design Compiler Reference Methodology Script for Top-Down Flow
# Script: dc.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
#################################################################################
# ctorng: Updated the reference methodology to this version
# Version: L-2016.03-SP2 (July 25, 2016)
#################################################################################

#################################################################################
# Additional Variables
#
# Add any additional variables needed for your flow here.
#################################################################################

# No additional flow variables are being recommended

#################################################################################
# Setup for Formality verification
#
# SVF should always be written to allow Formality verification
# for advanced optimizations.
#################################################################################

set_svf ${RESULTS}/${DCRM_SVF_OUTPUT_FILE}

#################################################################################
# Setup SAIF Name Mapping Database
#
# Include an RTL SAIF for better power optimization and analysis.
#
# saif_map should be issued prior to RTL elaboration to create a name mapping
# database for better annotation.
################################################################################

#if { ${VINAME} != "NONE" } {
#  saif_map -start
#}

#################################################################################
# Read in the RTL Design
#
# Read in the RTL source files or read in the elaborated design (.ddc).
# Use the -format option to specify: verilog, sverilog, or vhdl as needed.
#################################################################################

# The first "WORK" is a reserved word for Design Compiler. The value for
# the -path option is customizable.

define_design_lib WORK -path ${RESULTS}/WORK

# Analyze the RTL source files

if { ![analyze -format sverilog ${RTL_SOURCE_FILES}] } {
  exit 1
}

elaborate ${DESIGN_NAME}
current_design ${DESIGN_NAME}
link

# OR

# You can read an elaborated design from the same release.
# Using an elaborated design from an older release will not give the best results.

# read_ddc ${DCRM_ELABORATED_DESIGN_DDC_OUTPUT_FILE}

# Write out the elaborated design
#
# - The ddc can be used as a checkpoint to load up to the current state
# - The v is useful to double-check the netlist that dc will be mapping

write -hierarchy -format ddc     -output ${RESULTS}/${DCRM_ELABORATED_DDC_OUTPUT_FILE}
write -hierarchy -format verilog -output ${RESULTS}/${DCRM_ELABORATED_V_OUTPUT_FILE}

# SAIF name mapping

#if { ${VINAME} != "NONE" } {
#  saif_map -create_map -source_instance ${VINAME} -input rtl-sim.saif
#}
# saif_map -rtl_summary -missing_rtl -report

#################################################################################
# Apply Logical Design Constraints
#################################################################################

puts "Info: Sourcing constraints file plugin"
puts "Info: - ${DCRM_CONSTRAINTS_INPUT_FILE}"

source -echo -verbose ${DCRM_CONSTRAINTS_INPUT_FILE}

# You can enable analysis and optimization for multiple clocks per register.
# To use this, you must constrain to remove false interactions between mutually exclusive
# clocks.  This is needed to prevent unnecessary analysis that can result in
# a significant runtime increase with this feature enabled.
#
# set_clock_groups -physically_exclusive | -logically_exclusive | -asynchronous \
#                  -group {CLKA, CLKB} -group {CLKC, CLKD}
#
# set_app_var timing_enable_multiple_clocks_per_reg true

# The check_timing command checks for constraint problems such as undefined
# clocking, undefined input arrival times, and undefined output constraints.
# These constraint problems could cause you to overlook timing violations. For
# this reason, the check_timing command is recommended whenever you apply new
# constraints such as clock definitions, I/O delays, or timing exceptions.

redirect -tee ${REPORTS}/${DCRM_CHECK_TIMING_REPORT} {check_timing}

#################################################################################
# Apply The Operating Conditions
#################################################################################

# Set operating condition on top level

# set_operating_conditions -max <max_opcond> -min <min_opcond>

#################################################################################
# Create Default Path Groups
#
# Separating these paths can help improve optimization.
# Remove these path group settings if user path groups have already been defined.
#################################################################################

set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name REGOUT -to [all_outputs]
group_path -name REGIN -from [remove_from_collection [all_inputs] $ports_clock_root]
group_path -name FEEDTHROUGH -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]

#################################################################################
# Power Optimization Section
#################################################################################

    #############################################################################
    # Clock Gating Setup
    #############################################################################

    # Default clock_gating_style suits most designs.  Change only if necessary.
    # set_clock_gating_style -positive_edge_logic {integrated} -negative_edge_logic {integrated} -control_point before ...

    # Clock gate insertion is now performed during compile_ultra -gate_clock
    # so insert_clock_gating is no longer recommended at this step.

    # The following setting can be used to enable global clock gating.
    # With global clock gating, common enables are extracted across hierarchies
    # which results in fewer redundant clock gates.

    # set compile_clock_gating_through_hierarchy true

    # For better timing optimization of enable logic, clock latency for
    # clock gating cells can be optionally specified.

    # set_clock_gate_latency -clock <clock_name> -stage <stage_num> \
    #         -fanout_latency {fanout_range1 latency_val1 fanout_range2 latency_val2 ...}

    #############################################################################
    # Apply Power Optimization Constraints
    #############################################################################

    # Include a SAIF file, if possible, for power optimization.  If a SAIF file
    # is not provided, the default toggle rate of 0.1 will be used for propagating
    # switching activity.

    # read_saif -auto_map_names -input ${DESIGN_NAME}.saif -instance < DESIGN_INSTANCE > -verbose

    if {[shell_is_in_topographical_mode]} {
      # For multi-Vth design, replace the following to set the threshold voltage groups in the libraries.

      # set_attribute <my_hvt_lib> default_threshold_voltage_group HVT -type string
      # set_attribute <my_lvt_lib> default_threshold_voltage_group LVT -type string
    }

    # Starting in J-2014.09, leakage optimization is the default flow and is always enabled.

    if {[shell_is_in_topographical_mode]} {
      # Use the following command to enable power prediction using clock tree estimation.

      # set_power_prediction true -ct_references <LIB CELL LIST>
    }

if {[shell_is_in_topographical_mode]} {

  ##################################################################################
  # Apply Physical Design Constraints
  #
  # Optional: Floorplan information can be read in here if available.
  # This is highly recommended for irregular floorplans.
  #
  # Floorplan constraints can be provided from one of the following sources:
  #	* extract_physical_constraints with a DEF file
  #	* read_floorplan with a floorplan file (written by write_floorplan)
  #	* User generated Tcl physical constraints
  #
  ##################################################################################

  # Specify ignored layers for routing to improve correlation
  # Use the same ignored layers that will be used during place and route

  if { ${MIN_ROUTING_LAYER} != ""} {
    set_ignored_layers -min_routing_layer ${MIN_ROUTING_LAYER}
  }
  if { ${MAX_ROUTING_LAYER} != ""} {
    set_ignored_layers -max_routing_layer ${MAX_ROUTING_LAYER}
  }

  report_ignored_layers

  # If the macro names change after mapping and writing out the design due to
  # ungrouping or Verilog change_names renaming, it may be necessary to translate
  # the names to correspond to the cell names that exist before compile.

  # During DEF constraint extraction, extract_physical_constraints automatically
  # matches DEF names back to precompile names in memory using standard matching rules.
  # read_floorplan will also automatically perform this name matching.

  # Modify fuzzy_query_options if other characters are used for hierarchy separators
  # or bus names.

  # set_fuzzy_query_options -hierarchical_separators {/ _ .} \
  #                         -bus_name_notations {[] __ ()} \
  #                         -class {cell pin port net} \
  #                         -show

  ## For DEF floorplan input

  # The DEF file for DCT can be written from ICC using the following recommended options
  # icc_shell> write_def -version 5.7 -rows_tracks_gcells -macro -pins -blockages -specialnets \
  #                      -vias -region_groups -verbose -output ${DCRM_DCT_DEF_INPUT_FILE}

  if {[file exists [which ${DCRM_DCT_DEF_INPUT_FILE}]]} {
    # If you have physical only cells as a part of your floorplan DEF file, you can use
    # the -allow_physical_cells option with extract_physical_constraints to include
    # the physical only cells as a part of the floorplan in Design Compiler to improve correlation.
    #
    # Note: With -allow_physical_cells, new logical cells in the DEF file
    #       that have a fixed location will also be added to the design in memory.
    #       See the extract_physical_constraints manpage for more information about
    #       identifying the cells added to the design when using -allow_physical_cells.

    # extract_physical_constraints -allow_physical_cells ${DCRM_DCT_DEF_INPUT_FILE}

    puts "RM-Info: Reading in DEF file [which ${DCRM_DCT_DEF_INPUT_FILE}]\n"
    extract_physical_constraints ${DCRM_DCT_DEF_INPUT_FILE}
  }

  # OR

  ## For floorplan file input

  # The floorplan file for Design Compiler Topographical can be written from IC Compiler using the following
  # recommended options:
  # Note: IC Compiler requires the use of -placement {terminal} with -create_terminal beginning in the
  #       D-2010.03-SP1 release.
  # icc_shell> write_floorplan -placement {io terminal hard_macro soft_macro} -create_terminal \
  #                            -row -create_bound -preroute -track ${DCRM_DCT_FLOORPLAN_INPUT_FILE}

  # Read in the secondary floorplan file, previously written by write_floorplan in Design Compiler,
  # to restore physical-only objects back to the design, before reading the main floorplan file.

  if {[file exists [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects]]} {
    puts "RM-Info: Reading in secondary floorplan file [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects]\n"
    read_floorplan ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects
  }

  if {[file exists [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}]]} {
    puts "RM-Info: Reading in floorplan file [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}]\n"
    read_floorplan ${DCRM_DCT_FLOORPLAN_INPUT_FILE}
  }

  # OR

  ## For Tcl file input

  # For Tcl constraints, the name matching feature must be explicitly enabled
  # and will also use the set_query_rules setttings. This should be turned off
  # after the constraint read in order to minimize runtime.

  if {[file exists [which ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}]]} {
    set_app_var enable_rule_based_query true
    puts "RM-Info: Sourcing script file [which ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}]\n"
    source -echo -verbose ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}
    set_app_var enable_rule_based_query false
  }


  # Use write_floorplan to save the applied floorplan.

  # Note: A secondary floorplan file ${DCRM_DCT_FLOORPLAN_OUTPUT_FILE}.objects
  #       might also be written to capture physical-only objects in the design.
  #       This file should be read in before reading the main floorplan file.

  write_floorplan -all ${RESULTS}/${DCRM_DCT_FLOORPLAN_OUTPUT_FILE}

  # Verify that all the desired physical constraints have been applied
  # Add the -pre_route option to include pre-routes in the report
  report_physical_constraints > ${REPORTS}/${DCRM_DCT_PHYSICAL_CONSTRAINTS_REPORT}
}

#################################################################################
# Apply Additional Optimization Constraints
#################################################################################

# Make sure that logic to perform reset remains with the gate to prevent
# X-propagation problems

set compile_seqmap_honor_sync_set_reset true

# Replace special characters with non-special ones before writing out the synthesized netlist.
# E.g., "\bus[5]" -> "bus_5_"

set_app_var verilogout_no_tri true

# Prevent assignment statements in the Verilog netlist.

set_fix_multiple_port_nets -all -buffer_constants

# Design Compiler Flattening Options

if {[info exists DC_FLATTEN_EFFORT]} {
  set dc_flatten_effort $DC_FLATTEN_EFFORT
  if {"$dc_flatten_effort" == ""} {
    set dc_flatten_effort 0
  }
} else {
  set dc_flatten_effort 0
}

# Setup Design Compiler flattening effort

puts "Info: Design Compiler flattening effort (DC_FLATTEN_EFFORT) = $dc_flatten_effort"

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
  error "Unrecognizable DC_FLATTEN_EFFORT value: $dc_flatten_effort"
}

#################################################################################
# Save the compile environment snapshot for the Consistency Checker utility.
#
# This utility checks for inconsistent settings between Design Compiler and
# IC Compiler which can contribute to correlation mismatches.
#
# Download this utility from SolvNet.  See the following SolvNet article for
# complete details:
#
# https://solvnet.synopsys.com/retrieve/026366.html
#
# The article is titled: "Using the Consistency Checker to Automatically Compare
# Environment Settings Between Design Compiler and IC Compiler"
#################################################################################

# Uncomment the following line to snapshot the environment for the Consistency Checker

# write_environment -consistency -output ${REPORTS}/${DCRM_CONSISTENCY_CHECK_ENV_FILE}

#################################################################################
# Check for Design Problems
#################################################################################

# Check the current design for consistency

check_design -summary
check_design > ${REPORTS}/${DCRM_CHECK_DESIGN_REPORT}

#################################################################################
# Compile the Design
#
# Recommended Options:
#
#     -scan
#     -gate_clock (-self_gating)
#     -retime
#     -spg
#
# Use compile_ultra as your starting point. For test-ready compile, include
# the -scan option with the first compile and any subsequent compiles.
#
# Use -gate_clock to insert clock-gating logic during optimization.  This
# is now the recommended methodology for clock gating.
#
# Use -self_gating option in addition to -gate_clock for potentially saving
# additional dynamic power, in topographical mode only. Registers that are
# not clock gated will be considered for XOR self gating.
# XOR self gating should be performed along with clock gating, using -gate_clock
# and -self_gating options. XOR self gates will be inserted only if there is
# potential power saving without degrading the timing.
# An accurate switching activity annotation either by reading in a saif
# file or through set_switching_activity command is recommended.
# You can use "set_self_gating_options" command to specify self-gating
# options.
#
# Use -retime to enable adaptive retiming optimization for further timing benefit.
#
# Use the -spg option to enable Design Compiler Graphical physical guidance flow.
# The physical guidance flow improves QoR, area and timing correlation, and congestion.
# It also improves place_opt runtime in IC Compiler.
#
# Note: In addition to -spg option you can enable the support of via resistance for
#       RC estimation to improve the timing correlation with IC Compiler by using the
#       following setting:
#
#       set_app_var spg_enable_via_resistance_support true
#
# You can selectively enable or disable the congestion optimization on parts of
# the design by using the set_congestion_optimization command.
# This option requires a license for Design Compiler Graphical.
#
# The constant propagation is enabled when boundary optimization is disabled. In
# order to stop constant propagation you can do the following
#
# set_compile_directives -constant_propagation false <object_list>
#
# Note: Layer optimization is on by default in Design Compiler Graphical, to
#       improve the the accuracy of certain net delay during optimization.
#       To disable the the automatic layer optimization you can use the
#       -no_auto_layer_optimization option.
#
#################################################################################

if {[shell_is_in_topographical_mode]} {
  # Use the "-check_only" option of "compile_ultra" to verify that your
  # libraries and design are complete and that optimization will not fail
  # in topographical mode.  Use the same options as will be used in compile_ultra.

  # compile_ultra -gate_clock -check_only
}

eval "compile_ultra -gate_clock $compile_ultra_options"

#################################################################################
# High-effort area optimization
#
# optimize_netlist -area command, was introduced in I-2013.12 release to improve
# area of gate-level netlists. The command performs monotonic gate-to-gate
# optimization on mapped designs, thus improving area without degrading timing or
# leakage.
#################################################################################

if {!([info exists DC_SKIP_OPTIMIZE_NETLIST] && $DC_SKIP_OPTIMIZE_NETLIST)} {
  optimize_netlist -area
}

# Final check design

check_design -summary
check_design > ${REPORTS}/${DCRM_FINAL_CHECK_DESIGN_REPORT}

#################################################################################
# Write Out Final Design and Reports
#
#        .ddc:   Recommended binary format used for subsequent Design Compiler sessions
#    Milkyway:   Recommended binary format for IC Compiler
#        .v  :   Verilog netlist for ASCII flow (Formality, PrimeTime, VCS)
#       .spef:   Topographical mode parasitics for PrimeTime
#        .sdf:   SDF backannotated topographical mode timing for PrimeTime
#        .sdc:   SDC constraints for ASCII flow
#
#################################################################################

#################################################################################
# Write out Design
#################################################################################

# Write and close SVF file and make it available for immediate use

set_svf -off

# Use naming rules to preserve structs

define_name_rules verilog -preserve_struct_ports
report_names -rules verilog > ${REPORTS}/${DCRM_FINAL_NAME_CHANGE_REPORT}
change_names -rules verilog -hierarchy

# Write out files

write -format ddc     -hierarchy -output ${RESULTS}/${DCRM_FINAL_DDC_OUTPUT_FILE}
write -format verilog -hierarchy -output ${RESULTS}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}
write -format svsim              -output ${RESULTS}/${DCRM_FINAL_SVERILOG_WRAPPER_OUTPUT_FILE}

# ctorng: Dump the mapped.v and svwrapper.v into one svsim.v file to make
# it easier to include a single file for gate-level simulation. The
# svwrapper matches the interface RTL expects (array of arrays,
# parameters, etc.).

sh cat ${RESULTS}/${DCRM_FINAL_VERILOG_OUTPUT_FILE} \
       ${RESULTS}/${DCRM_FINAL_SVERILOG_WRAPPER_OUTPUT_FILE} \
       > ${RESULTS}/${DCRM_FINAL_SVERILOG_SIM_OUTPUT_FILE}

# Write top-level verilog view needed for block instantiation

write -format verilog -output ${RESULTS}/${DCRM_FINAL_VERILOG_TOP_OUTPUT_FILE}

# Write and close SVF file and make it available for immediate use

set_svf -off

#################################################################################
# Write out Design Data
#################################################################################

if {[shell_is_in_topographical_mode]} {

  # Note: A secondary floorplan file ${DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE}.objects
  #       might also be written to capture physical-only objects in the design.
  #       This file should be read in before reading the main floorplan file.

  write_floorplan -all ${RESULTS}/${DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE}

  # Write parasitics data from Design Compiler Topographical placement for static timing analysis
  write_parasitics -output ${RESULTS}/${DCRM_DCT_FINAL_SPEF_OUTPUT_FILE}

  # Write SDF backannotation data from Design Compiler Topographical placement for static timing analysis
  write_sdf ${RESULTS}/${DCRM_DCT_FINAL_SDF_OUTPUT_FILE}

  # Do not write out net RC info into SDC
  set_app_var write_sdc_output_lumped_net_capacitance false
  set_app_var write_sdc_output_net_resistance false
}

# Write out SDC constraints file

write_sdc -nosplit ${RESULTS}/${DCRM_FINAL_SDC_OUTPUT_FILE}

# If SAIF is used, write out SAIF name mapping file for PrimeTime-PX
#if { ${VINAME} != "NONE" } {
#  saif_map -type ptpx -write_map ${RESULTS}/dc-syn.mapped.SAIF.namemap
#}

#################################################################################
# Generate Final Reports
#################################################################################

# Report units

redirect -tee ${REPORTS}/${DCRM_FINAL_UNITS_REPORT} {report_units}

# Report QOR

report_qor > ${REPORTS}/${DCRM_FINAL_QOR_REPORT}

# Report timing

report_clock_timing \
  -type summary > ${REPORTS}/${DCRM_FINAL_CLOCK_TIMING_REPORT}

report_timing -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit \
  -path_type full_clock -attributes \
  -nworst 10 -max_paths 30 \
  -delay_type max \
  > ${REPORTS}/${DCRM_FINAL_TIMING_SETUP_REPORT}

report_timing -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit \
  -path_type full_clock -attributes \
  -nworst 10 -max_paths 30 \
  -delay_type min \
  > ${REPORTS}/${DCRM_FINAL_TIMING_HOLD_REPORT}

# Report constraints

report_constraint \
  -nosplit        \
  -verbose > ${REPORTS}/${DCRM_FINAL_CONSTRAINTS_REPORT}

report_constraint \
  -nosplit        \
  -verbose        \
  -all_violators > ${REPORTS}/${DCRM_FINAL_CONSTRAINTS_VIOL_REPORT}

# Report area

if {[shell_is_in_topographical_mode]} {
  report_area -hierarchy -physical -nosplit > ${REPORTS}/${DCRM_FINAL_AREA_REPORT}
} else {
  report_area -hierarchy -nosplit > ${REPORTS}/${DCRM_FINAL_AREA_REPORT}
}

if {[shell_is_in_topographical_mode]} {
  # report_congestion (topographical mode only) reports estimated routing related congestion
  # after topographical mode synthesis.
  # This command requires a license for Design Compiler Graphical.

  report_congestion -nosplit > ${REPORTS}/${DCRM_DCT_FINAL_CONGESTION_REPORT}

  # Use the following to generate and write out a congestion map from batch mode
  # This requires a GUI session to be temporarily opened and closed so a valid DISPLAY
  # must be set in your UNIX environment.

  # ctorng: Turn off congestion map that pulls up the GUI

#  if {[info exists env(DISPLAY)]} {
#    gui_start
#
#    # Create a layout window
#    set MyLayout [gui_create_window -type LayoutWindow]
#
#    # Build congestion map in case report_congestion was not previously run
#    report_congestion -build_map
#
#    # Display congestion map in layout window
#    gui_show_map -map "Global Route Congestion" -show true
#
#    # Zoom full to display complete floorplan
#    gui_zoom -window [gui_get_current_window -view] -full
#
#    # Write the congestion map out to an image file
#    # You can specify the output image type with -format png | xpm | jpg | bmp
#
#    # The following saves only the congestion map without the legends
#    gui_write_window_image -format png -file ${REPORTS}/${DCRM_DCT_FINAL_CONGESTION_MAP_OUTPUT_FILE}
#
#    # The following saves the entire congestion map layout window with the legends
#    gui_write_window_image -window ${MyLayout} -format png -file ${REPORTS}/${DCRM_DCT_FINAL_CONGESTION_MAP_WINDOW_OUTPUT_FILE}
#
#    gui_stop
#  } else {
#    puts "Information: The DISPLAY environment variable is not set. Congestion map generation has been skipped."
#  }
}

# Use SAIF file for power analysis
# read_saif -auto_map_names -input ${DESIGN_NAME}.saif -instance < DESIGN_INSTANCE > -verbose

report_power -nosplit -hier > ${REPORTS}/${DCRM_FINAL_POWER_REPORT}
report_clock_gating -nosplit > ${REPORTS}/${DCRM_FINAL_CLOCK_GATING_REPORT}

report_reference -nosplit -hierarchy > ${REPORTS}/${DCRM_FINAL_REFERENCE_REPORT}
report_resources -nosplit -hierarchy > ${REPORTS}/${DCRM_FINAL_RESOURCES_REPORT}

# Uncomment the next line if you include the -self_gating to the compile_ultra command
# to report the XOR Self Gating information.
# report_self_gating  -nosplit > ${REPORTS}/${DCRM_FINAL_SELF_GATING_REPORT}

# Uncomment the next line to reports the number, area, and  percentage  of cells
# for each threshold voltage group in the design.
# report_threshold_voltage_group -nosplit > ${REPORTS}/${DCRM_THRESHOLD_VOLTAGE_GROUP_REPORT}

#################################################################################
# Write out Milkyway Design for Top-Down Flow
#
# This should be the last step in the script
#################################################################################

# ctorng: We are not using ICC, so we do not need to write out the mwlib

#if {[shell_is_in_topographical_mode]} {
  # write_milkyway uses: mw_logic1_net, mw_logic0_net and mw_design_library variables from dc_setup.tcl
#  write_milkyway -overwrite -output ${DCRM_FINAL_MW_CEL_NAME}
#}

#################################################################################
# Source the user plugin for post-synthesis
#################################################################################
# ctorng: Adding this step to match the rest of the build system

if {[file exists [which ${post_synthesis_plugin}]]} {
  puts "Info: Reading in the post-synthesis plugin [which ${post_synthesis_plugin}]\n"
  source -echo -verbose ${post_synthesis_plugin}
}

exit

