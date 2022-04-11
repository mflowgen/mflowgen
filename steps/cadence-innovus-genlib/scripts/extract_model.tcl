set lib_files {}

foreach view [all_analysis_views] {
    set lib_name "${view}.lib"
    lappend lib_files $lib_name
    set_analysis_view -setup $view -hold $view
    do_extract_model $lib_name -view $view
}

# If we have more than one analysis view, merge them into a single design.lib
if {[llength $lib_files] > 1} {
    merge_model_timing -library $lib_files -modes [all_analysis_views] -mode_group combined -outfile design.lib
} else {
    mv $lib_files design.lib
}


