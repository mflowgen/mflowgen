#=========================================================================
# stream-out.tcl
#=========================================================================
# Script used to customize the GDS stream out step
#
# Author : Christopher Torng
# Date   : March 26, 2018

streamOut $vars(results_dir)/$vars(design).gds.gz \
    -units 1000 \
    -mapFile $vars(gds_layer_map)

set merge_files \
    [concat \
        [lsort [glob -nocomplain inputs/adk/*.gds*]] \
        [lsort [glob -nocomplain inputs/*.gds*]] \
    ]

streamOut $vars(results_dir)/$vars(design)-merged.gds \
    -units 1000 \
    -mapFile $vars(gds_layer_map) \
    -merge $merge_files
               

