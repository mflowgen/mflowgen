#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.

floorPlan -s $core_width $core_height $core_margin_l $core_margin_b $core_margin_r $core_margin_t
setFlipping s

loadIoFile $vars(plug_dir)/$vars(design).save.io

