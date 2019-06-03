#=========================================================================
# stream_out.tcl
#=========================================================================
# Script used to customize the GDS stream out step
#
# Author : Christopher Torng
# Date   : March 26, 2018

streamOut $vars(results_dir)/$vars(design).gds.gz -units 1000 -mapFile $vars(gds_layer_map)

