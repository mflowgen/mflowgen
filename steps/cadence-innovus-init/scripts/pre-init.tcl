#=========================================================================
# pre-init.tcl
#=========================================================================
# This is used to do some setup before the main initialization script.
# For example, some layer map files need to be set first, otherwise the
# initialization scripts will throw errors afterwards.

# set the QRC-LEF layer map if it exists
if {[file exists $vars(adk_dir)/pdk-qrc-lef.map]} {
  setExtractRCMode -lefTechFileMap $vars(adk_dir)/pdk-qrc-lef.map
}
