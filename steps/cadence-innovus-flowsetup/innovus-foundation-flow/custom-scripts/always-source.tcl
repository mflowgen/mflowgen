#=========================================================================
# always-source.tcl
#=========================================================================
# This plug-in script is called at the start of all Innovus flow scripts.
#
# Author : Christopher Torng
# Date   : March 26, 2018

# Source the adk.tcl

source $vars(adk_dir)/adk.tcl

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------
# Most innovus stages create the reports directory on their own, but some
# do not (e.g., route). However, most stages expect the reports directory
# to exist, otherwise they die. So we just create it here to make sure
# there is always a reports directory.

mkdir -p $vars(rpt_dir)

# [steveri 08/2021] There seems to be a source of nondeterminism when
# building e.g. garnet glb tile:
# 
# **WARN: (IMPECO-560): The netlist is not unique, because the module
#   'Tile_PE_mux_logic_1_20' is instantiated multiple times. Make the
#   netlist unique by running 'set init_design_uniquify 1' before
#   loading the design to avoid the problem.
# 
# Type 'man IMPECO-560' for more detail.
#
# So...

set init_design_uniquify 1
