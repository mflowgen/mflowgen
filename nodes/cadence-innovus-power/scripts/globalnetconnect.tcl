#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

# Connect VDD / VSS if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VDD] 0 ] != 0x0 } {
  globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
} 
if { [ lindex [dbGet top.insts.cell.pgterms.name VSS] 0 ] != 0x0 } {
  globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
}

# Connect VPWR / VGND if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VPWR] 0 ] != 0x0 } {
  globalNetConnect VDD -type pgpin -pin VPWR -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name VGND] 0 ] != 0x0 } {
  globalNetConnect VSS -type pgpin -pin VGND -inst * -verbose
}

# Connect VNW / VPW if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VNW] 0 ] != 0x0 } {
  globalNetConnect VDD -type pgpin -pin VNW -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name VPW] 0 ] != 0x0 } {
  globalNetConnect VSS -type pgpin -pin VPW -inst * -verbose
}

# Connect VNB / VPB if any cells have these pins

if { [ lindex [dbGet top.insts.cell.pgterms.name VNB] 0 ] != 0x0 } {
  globalNetConnect VSS -type pgpin -pin VNB -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name VPB] 0 ] != 0x0 } {
  globalNetConnect VDD -type pgpin -pin VPB -inst * -verbose
}

# Connect vcc / vssx if any cells have these pins
if { [ lindex [dbGet top.insts.cell.pgterms.name vssx] 0 ] != 0x0 } {
  globalNetConnect VSS -type pgpin -pin vssx -inst * -verbose
}

if { [ lindex [dbGet top.insts.cell.pgterms.name vcc] 0 ] != 0x0 } {
  globalNetConnect VDD -type pgpin -pin vcc -inst * -verbose
}
