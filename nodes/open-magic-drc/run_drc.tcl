# DRC batch script as done in the run_drc.tcl script generated from openPDK

puts "\[Magic DRC\]: $::env(design_name)"
gds read inputs/design-merged.gds
load $::env(design_name)
puts "\[INFO\]: Finished loading $::env(design_name)"
select top cell
drc euclidean on
drc style drc(full)

# Count number of DRC errors
drc catchup
puts "\[INFO\]: DRC catchup finshed. Running DRC why."
set drcresult [drc listall why]
puts "\[INFO\]: finshed DRC why command."
puts ""

set count 0
set total_count 0
set oscale [cif scale out]
puts "$::env(design_name)"
puts "----------------------------------------"
foreach {errtype coordlist} $drcresult {
    puts "\[DRC VIOLATION\]: $errtype"
    puts "----------------------------------------" 
    foreach coord $coordlist { 
        set bllx [expr {$oscale * [lindex $coord 0]}] 
        set blly [expr {$oscale * [lindex $coord 1]}] 
        set burx [expr {$oscale * [lindex $coord 2]}]
        set bury [expr {$oscale * [lindex $coord 3]}] 
        set coords [format " %.3f %.3f %.3f %.3f" $bllx $blly $burx $bury] 
        puts "\t\[VIOLATION LOCATION]:$coords" 
        set total_count [expr {$total_count + 1} ] 
    } 
    set count [expr {$count + 1} ] 
    puts "----------------------------------------" 
}

puts "\[DRC VIOLATION COUNT\]: $count"
puts "\[TOTAL DRC VIOLATION COUNT\]: $total_count"

puts ""

puts "\[INFO\]: Saving mag view with DRC errors($::env(design_name).drc.mag)"
# WARNING: changes the name of the cell; keep as last step
save $::env(design_name).drc.drc.mag
puts "\[INFO\]: Saved"

quit
