#=========================================================================
# post_place.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step

# Density map

reportDensityMap > $vars(rpt_dir)/place.density.rpt

# Delete all cell padding for CTS and hold fixing

deleteCellPad *

