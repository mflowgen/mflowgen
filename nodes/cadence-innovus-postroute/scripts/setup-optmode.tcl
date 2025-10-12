#=========================================================================
# setup-optmode.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

# Enable verbose mode, which prints why hold violations were not fixed

setOptMode -verbose true

# Help meet hold timing.. this target slack adjusts for inaccuracies in
# postroute extraction compared with signoff extraction
#
# Use this option carefully because over constraining can lead to increase
# in buffers, which causes more congestion and power

setOptMode -holdTargetSlack  $::env(hold_target_slack)
setOptMode -setupTargetSlack $::env(setup_target_slack)

# Useful skew
#
# setOptMode -usefulSkew [ true | false ]
#
# - This enables/disables all other -usefulSkew* options (e.g.,
#   -usefulSkewCCOpt, -usefulSkewPostRoute, and -usefulSkewPreCTS)
#
# setOptMode -usefulSkewPostRoute [ true | false ]
#
# - If setOptMode -usefulSkew is false, then this entire option is ignored
#

puts "Info: Useful skew = $::env(useful_skew)"

if { $::env(useful_skew) } {
  setOptMode -usefulSkew          true
  setOptMode -usefulSkewPostRoute true
} else {
  setOptMode -usefulSkew         false
}




