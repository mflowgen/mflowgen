#=========================================================================
# main.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 2, 2020

#-------------------------------------------------------------------------
# Final design tweaks to ensure hold is met
#-------------------------------------------------------------------------
# This step is the very last one that actually changes the design.
#
# The role of the final signoff step is to take the design, _not_ change
# it at all, and to run a (final) highest-effort timing check before
# dumping all reports and results.
#
# In this step, we want to ensure that hold is definitely met, so we run a
# final optDesign with the "-hold" flag. Why do we need to do this? The
# tool has many priorities (e.g., setup, hold, transitions, max cap, area,
# power). Fixing one priority often spills over and hurts another
# priority. For example, fixing setup involves adding buffers to speed up
# a path (and now setup is fine), but those buffers might speed the path
# up too much and now fail hold. Before the chip goes out, we want to make
# sure the _last_ thing the tool did was to make sure hold is met. Hold
# violations are essentially unrecoverable after taping out.
#

# Enable verbose mode, which prints why hold violations were not fixed

setOptMode -verbose true

# Set target setup/hold slack
#
# Use this option carefully because over constraining can lead to increase
# in buffers, which causes more congestion and power

setOptMode -usefulSkewPostRoute true

setOptMode -holdTargetSlack  $::env(hold_target_slack)
setOptMode -setupTargetSlack $::env(setup_target_slack)

# Set the RC extraction effort
#
# The signoff-quality timing engine is a standalone engine that is meant
# to be similar quality-wise to PrimeTime.
#

puts "Info: Using signoff engine = $::env(signoff_engine)"

if { $::env(signoff_engine) } {
  setExtractRCMode -engine postRoute -effortLevel signoff
}

# QRC seems to crash more often when multi-cpu value is large;
# after changing from 16 back to eight, I managed to get
# twenty-ish consecutive runs with no error. Also see Innovus
# User Guide Product Version 19.10, dated April 2019, p. 1057:
# "Generally, performance improvement will ... diminish beyond 8 CPUs."
# ---
# More details about the error, from run logs:
# 
# Cadence Innovus(TM) Implementation System.
# Version:        v19.10-p002_1, built Fri Apr 19 15:18:11 PDT 2019
# ...
# ERROR (Cpp-2) : A mandatory condition failed to be true at line 907 of file snzcomps.cpp.
# Condition: compFlags.to_bool()
# ERROR (EXTGRMP-103) : Current job number 1 failed. Please check stdout and log files for more details. Exiting...
#  Tool:                    Cadence Quantus Extraction 64-bit
#  Version:                 19.1.1-s086 Mon Mar 25 09:39:10 PDT 2019
#  Error messages:          2
# Exit code 2.
# Cadence Quantus Extraction completed unsuccessfully at 2021-Apr-01 02:52:10
# ---
# For even more details, see https://github.com/STanfordAHA/garnet/issues/761

set need_restore_multi false
if {[getDistributeHost -mode] == "local"} {
    set ncpu [getMultiCpuUsage -localCpu]
    if {$ncpu > 8} {
        set need_restore_multi true
        setMultiCpuUsage -localCpu 8
        puts "\nInfo: Temporarily changed multi-cpu from $ncpu to 8 to make QRC happy"
    }
}

# Run the final postroute hold fixing

optDesign -postRoute -outDir reports -prefix postroute_hold -hold

# Restore original multi settings

if {$need_restore_multi == true} {
    setDistributeHost -local
    setMultiCpuUsage -localCpu $ncpu
    puts "\nInfo: Restored multi-cpu back to its original value '$ncpu'"
}

    

