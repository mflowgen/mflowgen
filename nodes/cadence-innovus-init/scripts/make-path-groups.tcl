#=========================================================================
# make_path_groups.tcl
#=========================================================================
# Path groups help the timing engine prioritize which timing paths to
# spend more time fixing. Generally we create timing groups for
# register-to-register paths (Reg2Reg), input-to-register paths (In2Reg),
# and register-to-output paths (Reg2Out). However, other timing groups can
# also be very useful (e.g., macros).
#
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Set up path groups for timing
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

# Create collection for all macros

set blocks      [ dbGet top.insts.cell.baseClass block -p2 ]
set macro_refs  [ list ]
set macros      [ list ]

# If the list of blocks is non-empty, filter out non-physical blocks

set blocks_exist  [ expr [ lindex $blocks 0 ] != 0 ]

if { $blocks_exist } {
  foreach b $blocks {
    set cell    [ dbGet $b.cell ]
    set isBlock [ dbIsCellBlock $cell ]
    set isPhys  [ dbGet $b.isPhysOnly ]
    # Return all blocks that are _not_ physical-only (e.g., filter out IO bondpads)
    if { [ expr $isBlock && ! $isPhys ] } {
      puts [ dbGet $b.name ]
      lappend macro_refs $b
      lappend macros     [ dbGet $b.name ]
    }
  }
}

# Group paths (for any groups that exist)

group_path -name In2Out -from $inputs -to $outputs

if { $allregs != "" } {
  group_path -name In2Reg  -from $inputs  -to $allregs
  group_path -name Reg2Out -from $allregs -to $outputs
}

if { $regs != "" } {
  group_path -name Reg2Reg -from $regs -to $regs
}

if { $allregs != "" && $icgs != "" } {
  group_path -name Reg2ClkGate -from $allregs -to $icgs
}

if { $macros != "" } {
  group_path -name All2Macro -to   $macros
  group_path -name Macro2All -from $macros
}

# High-effort path groups

if { $macros != "" } {
  setPathGroupOptions All2Macro -effortLevel high
  setPathGroupOptions Macro2All -effortLevel high
}

if { $regs != "" } {
  setPathGroupOptions Reg2Reg -effortLevel high
}


