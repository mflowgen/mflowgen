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

# Start Innovus in an assign-free flow
set_db init_no_new_assigns true

# (Hack) Set the Library Unit to match the sdc
#    Intel (without a notice) changed the time unit from ps to ns in the 
# standard cell libraries, while leaving other collateral libraries in ps.
# For Genus, it chooses the finest time unit (ps) when generating SDCs.
# For Innovus, it chooses the time unit of the main library (ns).
# Because SDC is unit-less, Innovus will interpret the SDC using ns.
# To avoid this issue, we set the library unit to match the SDC.
# There might be some other way to do this, but this is the easiest.
setLibraryUnit -time 1ps -cap 1fF
