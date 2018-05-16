#=========================================================================
# pre_postroute.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step

setOptMode -usefulSkewPostRoute true

# Help meet hold timing.. this target slack adjusts for inaccuracies in
# postroute extraction compared with signoff extraction
#
#Use this option carefully because over constraining can lead to increase
#in buffers, which causes more congestion and power

setOptMode -holdTargetSlack  0.005
setOptMode -setupTargetSlack 0.000

