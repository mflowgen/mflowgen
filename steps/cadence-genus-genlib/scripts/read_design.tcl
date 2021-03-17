set genus_design_name              $::env(design_name)
set genus_gl_netlist               [glob -nocomplain inputs/*.vcs.v]
set genus_sdc                      [glob -nocomplain inputs/*.pt.sdc]
set genus_spef                     [glob -nocomplain inputs/*.spef.gz]


# No good for multiple reasons, see issue <issue-link-here>
# set_attr library \
#     [join "
#        [lsort [glob -nocomplain inputs/adk/*.lib]]
#        [lsort [glob -nocomplain inputs/*.lib]]
#     "]
# 
# source set_libs.tcl
if { [is_common_ui_mode] } { set_db common_ui false }
if { [get_attribute library /] == "" } {
    echo EMPTY
    # OMG the things I gotta do to keep postcondition check from thinking there's an errror [sic]
    printf "%s%s no tech libraries, should e.g. source 'set_libs.tcl'\n" "**ERR" "OR"
    exit 13
}

read_hdl       $genus_gl_netlist
elaborate
current_design $genus_design_name

# Read in the SDC and parasitics
# Try to read the sdc constraints files

if {[ file exists $genus_sdc ]} {
    puts "\n  > Info: Sourcing $genus_sdc\"\n"
    read_sdc -echo $genus_sdc
}  else {
    puts "\n  > Warn: No sdc constraint file found\"\n"
}

# Try to read the spef parasitic files

if {[ file exists $genus_spef ]} {
    puts "\n  > Info: Sourcing $genus_spef\"\n"
    read_spef $genus_spef
}  else {
    puts "\n  > Warn: No spef parasitic file found\"\n"
}
