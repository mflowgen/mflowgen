#=========================================================================
# pre_postroute.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step

# Enable verbose mode, which prints why hold violations were not fixed

setOptMode -verbose true

# Help meet hold timing.. this target slack adjusts for inaccuracies in
# postroute extraction compared with signoff extraction
#
#Use this option carefully because over constraining can lead to increase
#in buffers, which causes more congestion and power

setOptMode -holdTargetSlack  0.005
setOptMode -setupTargetSlack 0.000

setOptMode -usefulSkewPostRoute true

# Setup clock uncertainty is at signoff level now

set_clock_uncertainty 0.01 [get_clocks core_clk] -setup

# Set a slightly conservative hold uncertainty during postroute to help
# meet hold time and correct for postroute correlation with signoff

set_clock_uncertainty 0.10 [get_clocks core_clk] -hold

