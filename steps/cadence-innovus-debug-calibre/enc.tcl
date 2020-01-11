#=========================================================================
# enc.tcl
#=========================================================================
# Load the calibre menu in innovus
#
# Put this script in whichever directory you load innovus from, and it
# should be picked up. This script is based on previous installs and the
# only new thing is that it automatically sets the CALIBRE_HOME variable
# from the path to the calibre binary if the variable isn't available.
#
# Author : Christopher Torng
# Date   : November 8, 2019
#

proc load_calibre {} {

  global env

  # CALIBRE_HOME
  #
  # Usually this variable is set by the calibre install, but sometimes it
  # isn't. In this case, find CALIBRE_HOME from the path to the calibre
  # binary.
  #
  # So if the calibre bin lives in
  # "/foo/mentor/2018.8/aoi_cal_2018.2_33.24/bin/calibre", then just split
  # the string on the '/' character, remove the last two elements, and
  # join the string back with the '/' character to get CALIBRE_HOME.

  if {![info exists env(CALIBRE_HOME)] || $env(CALIBRE_HOME)==""} {

    if {![file exists [exec which calibre]]} {
      puts "Tool calibre not found. Calibre interface NOT loaded."
      return
    }

    if {[info exists env{MGC_HOME}]} {
      set CALIBRE_HOME $MGC_HOME
    } else {
      set CALIBRE_HOME \
        [join [lrange [split [exec which calibre] /] 0 end-2] /]
    }
  }

  set etclf [file join $CALIBRE_HOME lib cal_enc.tcl]

  if {![file readable $etclf]} {
    puts "Could not find Calibre initialization files."
    puts "Calibre interface not loaded."
    return
  }

  if {[catch {source $etclf} msg]} {
    puts "ERROR while loading Calibre interface: $msg"
  }
}

load_calibre


