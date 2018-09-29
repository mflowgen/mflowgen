#=========================================================================
# post_init.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Can be used for various floorplan related tasks, like:
#              - Die/core boundary
#              - placement of hard macros/blocks
#              - power domain size and clearence surrounding to it
#              - Placement and routing blockages in the floorplan
#              - IO ring creation
#              - PSO planning
#-------------------------------------------------------------------------

report_ports > $vars(rpt_dir)/$vars(step).ports.rpt

#-------------------------------------------------------------------------
# Set up path groups
#-------------------------------------------------------------------------

# Reset all existing path groups, including basic path groups

reset_path_group -all

# Reset all options set on all path groups

resetPathGroupOptions

# Create collection for each category

set inputs   [all_inputs -no_clocks]
set outputs  [all_outputs]
set icgs     [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set regs     [remove_from_collection [all_registers -edge_triggered] $icgs]
set allregs  [all_registers]

# Group paths

group_path -name In2Reg  -from $inputs  -to $allregs
group_path -name Reg2Out -from $allregs -to $outputs
group_path -name In2Out  -from $inputs  -to $outputs

group_path -name Reg2Reg     -from $regs    -to $regs
group_path -name Reg2ClkGate -from $allregs -to $icgs

# High-effort path groups

setPathGroupOptions Reg2Reg -effortLevel high

#-------------------------------------------------------------------------
# Report timing -- hold
#-------------------------------------------------------------------------

# Report zero-load timing now to identify hard macros (memories or IP
# blocks), which have large hold time requirements. Identifying these
# situations early allows planning for enough space to insert the required
# buffers and delay cells to fix them.

timeDesign -preplace -hold -expandedViews -prefix preplace -outDir $vars(rpt_dir)

