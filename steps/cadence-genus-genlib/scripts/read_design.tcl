set genus_design_name              $::env(design_name)
set genus_gl_netlist               [glob -nocomplain inputs/*.vcs.v]
set genus_sdc                      [glob -nocomplain inputs/*.pt.sdc]
set genus_spef                     [glob -nocomplain inputs/*.spef.gz]

set_db common_ui false

set_attr library    [join "
                      [lsort [glob -nocomplain inputs/adk/*.lib]]
                      [lsort [glob -nocomplain inputs/*.lib]]
                    "]

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
