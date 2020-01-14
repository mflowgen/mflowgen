#=========================================================================
# save-design.tcl
#=========================================================================
# Save an Innovus design checkpoint
#
# 1. Options for saving a portable design
# 2. Save user-defined variables across Innovus sessions
#
# Author : Christopher Torng
# Date   : March 26, 2018 and January 13, 2020

set innovus_checkpoint_path checkpoints/design.checkpoint/save.enc

#-------------------------------------------------------------------------
# 1. Options for saving a portable design
#-------------------------------------------------------------------------
# The goal is to save the design so that the checkpoint can be reopened
# even if the directory name or location changes. This portability is very
# useful if we ever rename build directories during design-space
# exploration.
#
# Potential options:
#
#   -libs         : directly copies the lib file instead of using symlinks
#   -lib2ldb      : converts lib to compact / unreadable Innovus format
#   -relativePath : tries to use relative paths from the cwd
#   -user_path    : tries to use original user path
#   -tgz          : compress into tarball with gzip (implies -libs)
#
#   also related is "setImportMode -syncRelativePath true"
#
# Unfortunately, a truly portable checkpoint requires saving all libraries
# with the -libs option (an NDA hazard).
#
# The next best option is to use symlinks to tech libs and requiring that
# the paths to the technology files never changes.
#

set version [ string range [ getVersion ] 0 1 ]

if {[ expr $version >= 19 ]} {
  # Innovus 19 has an option that may be portable if user gave a good path
  saveDesign $innovus_checkpoint_path -user_path
} else {
  # Innovus 18 still has portability issues with absolute-path symlinks
  saveDesign $innovus_checkpoint_path -relativePath
}

#-------------------------------------------------------------------------
# 2. Save user-defined variables across Innovus sessions
#-------------------------------------------------------------------------
# Saves all user-defined variables from this Innovus session as a script.
# The generated script can be run to restore these variables to a new
# session.
#
#-------------------------------------------------------------------------
# Background
#-------------------------------------------------------------------------
# Innovus does not save user-defined variables across sessions, so if you
# defined a var during floorplan:
#
#     set core_width 1000   # inaccessible in future Innovus sessions
#
# It would not be available during a later step like power planning. One
# way to solve this is to put all shared variables into a script that is
# always sourced at the beginning of each step, but this is not very clean
# and not modular at all.
#
# The save_variables.tcl script explicitly saves and loads user-defined
# variables in the $savedvars() array. The saved variables can be passed
# along with the checkpoint for downstream Innovus sessions. Any variable
# saved in this array can be saved and loaded across Innovus sessions.
#
# You can save to the special array like this:
#
#     set savedvars(core_width) 1000
#
#-------------------------------------------------------------------------
# Steps
#-------------------------------------------------------------------------
#
# For this to work:
#
# 1. Source this code snippet at the end of a session
# 2. A tcl script is generated with "set" commands, which can be loaded at
#    the start of a new session
#
# Note:
#
# - Handles tcl lists
# - Does not handle tcl arrays, which cannot be echoed
#

echo "\n# User-defined variables (in array savedvars)\n" >> $innovus_checkpoint_path

foreach {varname value} [ array get savedvars ] {
  if { [ llength $value ] <= 1 } {
    echo set savedvars($varname) $value >> $innovus_checkpoint_path
  } else {
    echo set savedvars($varname) \[ list $value \] >> $innovus_checkpoint_path
  }
}


