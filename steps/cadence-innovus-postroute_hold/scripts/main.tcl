#=========================================================================
# main.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 2, 2020

#-------------------------------------------------------------------------
# Final design tweaks to ensure hold is met
#-------------------------------------------------------------------------
# This step is the very last one that actually changes the design.
#
# The role of the final signoff step is to take the design, _not_ change
# it at all, and to run a (final) highest-effort timing check before
# dumping all reports and results.
#
# In this step, we want to ensure that hold is definitely met, so we run a
# final optDesign with the "-hold" flag. Why do we need to do this? The
# tool has many priorities (e.g., setup, hold, transitions, max cap, area,
# power). Fixing one priority often spills over and hurts another
# priority. For example, fixing setup involves adding buffers to speed up
# a path (and now setup is fine), but those buffers might speed the path
# up too much and now fail hold. Before the chip goes out, we want to make
# sure the _last_ thing the tool did was to make sure hold is met. Hold
# violations are essentially unrecoverable after taping out.
#

# Enable verbose mode, which prints why hold violations were not fixed

setOptMode -verbose true

# Set target setup/hold slack
#
# Use this option carefully because over constraining can lead to increase
# in buffers, which causes more congestion and power

setOptMode -usefulSkewPostRoute true

setOptMode -holdTargetSlack  $::env(hold_target_slack)
setOptMode -setupTargetSlack $::env(setup_target_slack)

# Set the RC extraction effort
#
# The signoff-quality timing engine is a standalone engine that is meant
# to be similar quality-wise to PrimeTime.
#

puts "Info: Using signoff engine = $::env(signoff_engine)"

if { $::env(signoff_engine) } {
  setExtractRCMode -engine postRoute -effortLevel signoff
} else {
  setExtractRCMode -engine postRoute -effortLevel high
}

# Run the final postroute hold fixing

optDesign -postRoute -outDir reports -prefix postroute_hold -hold


