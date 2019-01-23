#=========================================================================
# save_design.tcl
#=========================================================================
# Script used to customize the save design step
#
# Save the design so that the checkpoint can be reopened even if the
# directory name or location changes. This portability is very useful if
# we ever rename build directories during design-space exploration.
#
# Potential options:
#
#   -libs         : directly copies the lib file instead of using symlinks
#   -lib2ldb      : converts lib to compact / unreadable Innovus format
#   -relativePath : tries to use relative paths from the cwd
#   -tgz          : compress into tarball with gzip (implies -libs)
#
# Also related is "setImportMode -syncRelativePath true"
#
# Author : Christopher Torng
# Date   : March 26, 2018

saveDesign $vars(dbs_dir)/$vars(step).enc -relativePath

