#=========================================================================
# stream-out.tcl
#=========================================================================
# Script used to customize the GDS stream out step
#
# Author : Christopher Torng
# Date   : March 26, 2018

if { [info exists ADK_DBU_PRECISION] } { 
    set stream_out_units $ADK_DBU_PRECISION
} else {
    set stream_out_units 1000
}

streamOut $vars(results_dir)/$vars(design).gds.gz \
    -units ${stream_out_units} \
    -mapFile $vars(gds_layer_map)

set merge_files \
    [concat \
        [lsort [glob -nocomplain inputs/adk/*.gds*]] \
        [lsort [glob -nocomplain inputs/*.gds*]] \
    ]

streamOut $vars(results_dir)/$vars(design)-merged.gds \
    -units ${stream_out_units} \
    -mapFile $vars(gds_layer_map) \
    -uniquifyCellNames \
    -merge $merge_files
