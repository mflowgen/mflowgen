#=========================================================================
# compile-options.tcl
#=========================================================================
# This script sets the "$compile_ultra_options" variable used in the
# compile.tcl script.
#
# Author : Christopher Torng
# Date   : May 14, 2018
#

#-------------------------------------------------------------------------
# Flatten effort
#-------------------------------------------------------------------------
#
# - Effort 0: No auto-ungrouping / boundary optimizations (strict hierarchy)
# - Effort 1: No auto-ungrouping / boundary optimizations
#             DesignWare cells are ungrouped (var compile_ultra_ungroup_dw)
# - Effort 2: Enable auto-ungrouping / boundary optimizations
#             DesignWare cells are ungrouped (var compile_ultra_ungroup_dw)
# - Effort 3: Everything ungrouped + level param for how deep to ungroup
#
# Note that even with boundary optimizations off, DC will still propagate
# constants across the boundary, although this can be disabled with a
# variable if we really wanted to disable it.
#

puts "Info: Flattening effort = $dc_flatten_effort"

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
  puts "Info: Unrecognizable flatten effort value: $dc_flatten_effort"
  exit
}

#-------------------------------------------------------------------------
# Enable or disable clock gating
#-------------------------------------------------------------------------

puts "Info: Enable clock gating = $dc_gate_clock"

if { $dc_gate_clock == True } {
  append compile_ultra_options " -gate_clock"
}

#-------------------------------------------------------------------------
# Other
#-------------------------------------------------------------------------

# Three-state nets are declared as Verilog "wire" instead of "tri." This
# is useful in eliminating "assign" primitives and "tran" gates in the
# Verilog output.

set_app_var verilogout_no_tri true

# Prevent assignment statements in the Verilog netlist

set_fix_multiple_port_nets -all -buffer_constants

# Apply physical design constraints (this really belongs in constraints)
#
# Set the minimum and maximum routing layers used in DC topographical mode
#

if { $dc_topographical == True } {
  set_ignored_layers -min_routing_layer $ADK_MIN_ROUTING_LAYER_DC
  set_ignored_layers -max_routing_layer $ADK_MAX_ROUTING_LAYER_DC

  report_ignored_layers
}


