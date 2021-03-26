#=========================================================================
# fix-eco.tcl
#=========================================================================
# This script performs the ECOs depending on the parameters, and writes
# out the changes to a file.
#
# Author : Kartik Prabhu
# Date   : September 21, 2020

set timing_save_pin_arrival_and_required true

# Show report on unfixed violations
set eco_report_unfixed_reason_max_endpoints 10

update_timing -full

# Recommended Order: 
# 1. Power Recovery (cell sizing, buffer removal)
# 2. DRC and Noise Violations (buffer insertion, cell sizing)
# 3. Timing Violations (buffer insertion, cell sizing)
# 4. Leakage Recovery (threshold voltage swapping)

foreach pt_eco_type [split $::env(eco_types) ","] {
    puts "Performing ECO ${pt_eco_type}"
    if { $pt_eco_type == "power" } {
        # Downsize both sequential and combinational cells
        fix_eco_power -verbose

        # Remove buffers
        fix_eco_power -verbose -methods {remove_buffer}
    } elseif { [string match "drc_*" $pt_eco_type] } {
        set drc_eco_type [string range $pt_eco_type 4 end]
        fix_eco_drc -verbose -type $drc_eco_type -buffer_list $ADK_BUF_CELL_LIST
    } elseif { $pt_eco_type == "timing" } {
        fix_eco_timing -verbose -type setup -setup_margin $pt_setup_margin -hold_margin $pt_hold_margin
        fix_eco_timing -verbose -type hold -buffer_list $ADK_BUF_CELL_LIST -setup_margin $pt_setup_margin -hold_margin $pt_hold_margin
    } elseif { $pt_eco_type == "leakage" } {
        fix_eco_leakage -verbose -pattern_priority $pt_eco_leakage_pattern
    } else {
        puts "Unrecognized ECO type: ${pt_eco_type}! Must be one of: power, drc_max_transition, drc_max_capacitance, drc_max_fanout, drc_noise, drc_delta_delay, drc_cell_em, timing, leakage."
    }
}

write_changes -format icctcl -output outputs/icc_eco.tcl
