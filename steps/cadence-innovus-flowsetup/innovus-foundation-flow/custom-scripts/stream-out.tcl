#=========================================================================
# stream-out.tcl
#=========================================================================
# Script used to customize the GDS stream out step
#
# Author : Christopher Torng
# Date   : March 26, 2018


set merge_files \
    [concat \
        [lsort [glob -nocomplain inputs/adk/*.gds*]] \
        [lsort [glob -nocomplain inputs/*.gds*]] \
    ]

if { [info exists ADK_DBU_PRECISION] } { 
    if { $ADK_DBU_PRECISION == "default" } {
        streamOut $vars(results_dir)/$vars(design).gds.gz \
            -mapFile $vars(gds_layer_map)

        streamOut $vars(results_dir)/$vars(design)-merged.gds \
            -mapFile $vars(gds_layer_map) \
            -uniquifyCellNames \
            -merge $merge_files
    } else {
        streamOut $vars(results_dir)/$vars(design).gds.gz \
            -units $ADK_DBU_PRECISION \
            -mapFile $vars(gds_layer_map)

        streamOut $vars(results_dir)/$vars(design)-merged.gds \
            -units $ADK_DBU_PRECISION \
            -mapFile $vars(gds_layer_map) \
            -uniquifyCellNames \
            -merge $merge_files
    }
} else {
    streamOut $vars(results_dir)/$vars(design).gds.gz \
        -units 1000 \
        -mapFile $vars(gds_layer_map)

    streamOut $vars(results_dir)/$vars(design)-merged.gds \
        -units 1000 \
        -mapFile $vars(gds_layer_map) \
        -uniquifyCellNames \
        -merge $merge_files
}