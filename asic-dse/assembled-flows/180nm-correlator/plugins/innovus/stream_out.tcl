# Stream out GDS

streamOut $vars(results_dir)/$vars(design).gds.gz -units 1000 -mapFile $vars(gds_layer_map)
#streamOut -units 1000 -mapFile $vars(gds_layer_map) -merge $vars(gds_files) $vars(results_dir)/$vars(design).gds.gz

