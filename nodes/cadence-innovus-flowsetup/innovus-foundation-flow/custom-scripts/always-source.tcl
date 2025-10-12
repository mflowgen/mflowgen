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
