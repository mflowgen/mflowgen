# boson synthesis + technology mapping for mflowgen.
# Reads the ADK standard cells (inputs/adk) and the design RTL (inputs/design.v), compiles to a gate
# netlist mapped to the ADK, and writes it as design.boson.nl.v. Parameters arrive as environment
# variables (mflowgen sets each step parameter in the environment).

set adk inputs/adk
read_liberty $adk/stdcells.lib
read_lef     $adk/rtk-tech.lef
read_lef     $adk/stdcells.lef
# ADK tcl defines cell names (tie cells, driving cell, ...) as ADK_* variables
if {[file exists $adk/adk.tcl]} { source $adk/adk.tcl }

set D      $::env(design_name)
set PER    $::env(clock_period)
set CLKP   [expr {[info exists ::env(clock_port)] ? $::env(clock_port) : "clk"}]
set EFFORT [expr {[info exists ::env(effort)]     ? $::env(effort)     : "high"}]

# synthesis timing constraint
set f [open synth.sdc w]
puts $f "create_clock -name clk -period $PER \[get_ports $CLKP\]"
close $f

puts "BOSON: compile $D at $PER ns (effort $EFFORT)"
compile inputs/design.v -top $D -sdc synth.sdc -effort $EFFORT
report_qor

# resolve constant tie-offs to the ADK tie cells, when the ADK names them
if {[info exists ADK_TIE_HI_CELL] && [info exists ADK_TIE_HI_PORT]} {
  set_tiehi  $ADK_TIE_HI_CELL.$ADK_TIE_HI_PORT
}
if {[info exists ADK_TIE_LO_CELL] && [info exists ADK_TIE_LO_PORT]} {
  set_tielow $ADK_TIE_LO_CELL.$ADK_TIE_LO_PORT
}

write_verilog -tie_cells design.boson.nl.v
puts "BOSON: synth done -> design.boson.nl.v"
