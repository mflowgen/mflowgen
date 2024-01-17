#=========================================================================
# setup-ccopt.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

# Allow clock gate cloning and merging

set_ccopt_property clone_clock_gates true
set_ccopt_property clone_clock_logic true
set_ccopt_property ccopt_merge_clock_gates true
set_ccopt_property ccopt_merge_clock_logic true
set_ccopt_property cts_merge_clock_gates true
set_ccopt_property cts_merge_clock_logic true

# Useful skew
#
# setOptMode -usefulSkew [ true | false ]
#
# - This enables/disables all other -usefulSkew* options (e.g.,
#   -usefulSkewCCOpt, -usefulSkewPostRoute, and -usefulSkewPreCTS)
#
# setOptMode -usefulSkewCCOpt [ none | standard | medium | extreme ]
#
# - If setOptMode -usefulSkew is false, then this entire option is ignored
#
# - Connection to "set_ccopt_effort" .. these are the same:
#   - "set_ccopt_effort -low"    and "setOptMode -usefulSkewCCOpt standard"
#   - "set_ccopt_effort -medium" and "setOptMode -usefulSkewCCOpt medium"
#   - "set_ccopt_effort -high"   and "setOptMode -usefulSkewCCOpt extreme"
#

puts "Info: Useful skew = $::env(useful_skew)"
puts "Info: Useful skew ccopt effort = $::env(useful_skew_ccopt_effort)"

if { $::env(useful_skew) } {
  setOptMode -usefulSkew      true
  setOptMode -usefulSkewCCOpt $::env(useful_skew_ccopt_effort)
} else {
  setOptMode -usefulSkew      false
}

# Specify clock tree synthesis cells and slew
set_ccopt_mode \
  -integration "native" \
  -cts_inverter_cells ${ADK_CTS_INVERTER_CELLS} \
  -cts_buffer_cells ${ADK_CTS_BUFFER_CELLS} \
  -cts_clock_gating_cells ${ADK_CTS_CLOCK_GATING_CELLS} \
  -cts_logic_cells ${ADK_CTS_LOGIC_CELLS} \
  -ccopt_modify_clock_latency true \
  -cts_target_slew ${ADK_CTS_TARGET_SLEW}

# Enable the use of clock gating cells
foreach cell ${ADK_CTS_CLOCK_GATING_CELLS} {
  setDontUse ${cell} false
}

# # Apply a NDR to clk tree if ADK_CLK_TREE_NDR_NAME is defined
# if { [info exists ADK_CLK_TREE_NDR_NAME] } {
#     # create a new NDR rule
#     add_ndr -name $ADK_CLK_TREE_NDR_NAME -width $ADK_CLK_TREE_NDR_WIDTH
#     # create assosiated route types
#     create_route_type \
#         -name                           clk_route_type_trunk \
#         -non_default_rule               $ADK_CLK_TREE_NDR_NAME \
#         -top_preferred_layer            $ADK_CLK_TREE_NDR_LAYER_TOP \
#         -bottom_preferred_layer         $ADK_CLK_TREE_NDR_LAYER_BOTTOM \
#         -preferred_routing_layer_effort high
#     create_route_type \
#         -name                           clk_route_type_leaf \
#         -top_preferred_layer            $ADK_CLK_TREE_NDR_LAYER_TOP \
#         -bottom_preferred_layer         $ADK_CLK_TREE_NDR_LAYER_BOTTOM \
#         -preferred_routing_layer_effort high
#     # Apply the route types to all clock trees (by omitting the -clock_tree option)
#     set_ccopt_property route_type \
#         -net_type top \
#         clk_route_type_trunk
#     set_ccopt_property route_type \
#         -net_type trunk \
#         clk_route_type_trunk
#     set_ccopt_property route_type \
#         -net_type leaf \
#         clk_route_type_leaf
# }