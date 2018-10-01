#=========================================================================
# post_postroute.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step

# Reset clock uncertainty to signoff levels now that postroute is done

set_clock_uncertainty 0.01 [get_clocks *]

