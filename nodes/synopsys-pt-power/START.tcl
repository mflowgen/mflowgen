#=========================================================================
# START.tcl
#=========================================================================
# This script runs a list of other scripts from the "scripts" or "inputs"
# dir in some order (either default or from an mflowgen Python parameter).
#
# The order of the scripts can specified from an mflowgen parameter. This
# creates a highly flexible node where you can rearrange the internal
# scripts or add new scripts. For example, with a default order of:
#
#     order = step1.tcl step2.tcl step3.tcl
#
# After adding a new input called "new.tcl", you can re-parameterize as:
#
#     order = step1.tcl new.tcl step2.tcl step3.tcl
#
# and the scripts will execute in that order.
#
# Author : Christopher Torng
# Date   : January 14, 2020

#-------------------------------------------------------------------------
# Execute
#-------------------------------------------------------------------------

# Order is a comma-separated string containing scripts to run

set order [split $::env(order) ","]

# Run the scripts in order (inputs take priority)

foreach tcl $order {
  # Try to find the script in the "inputs" directory first
  if {[ file exists inputs/$tcl ]} {
    puts "\n  > Info: Sourcing \"inputs/$tcl\"\n"
    source -echo -verbose inputs/$tcl
    # Hook to drop into interactive Design Compiler shell after setup
    if {[ info exists SYN_SETUP_DONE ]} { return }
  # Try to find the script in the "scripts" directory
  } elseif {[ file exists scripts/$tcl ]} {
    puts "\n  > Info: Sourcing \"scripts/$tcl\"\n"
    source -echo -verbose scripts/$tcl
    # Hook to drop into interactive Design Compiler shell after setup
    if {[ info exists SYN_SETUP_DONE ]} { return }
  # Failed to find the script anywhere...
  } else {
    echo "Warn: Did not find $tcl"
    exit 1
  }
}

# Save the primetime session for debug sessions
save_session outputs/primetime.session

exit


