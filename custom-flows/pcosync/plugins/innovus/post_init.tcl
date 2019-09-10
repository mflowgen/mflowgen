#=========================================================================
# post_init.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step
#
#-------------------------------------------------------------------------
# Can be used for various floorplan related tasks, like:
#              - Die/core boundary
#              - placement of hard macros/blocks
#              - power domain size and clearence surrounding to it
#              - Placement and routing blockages in the floorplan
#              - IO ring creation
#              - PSO planning
#-------------------------------------------------------------------------

report_ports > $vars(rpt_dir)/$vars(step).ports.rpt

#set_dont_touch on pgen trigger logic
set_dont_touch [get_cells pulsegen1/pulsegen_trigger1]

