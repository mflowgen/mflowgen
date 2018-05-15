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

# Don't touch the balanced clock mux built with hand-instantiated stdcells

set_dont_touch clk_mux
set_dont_touch clk_inv

