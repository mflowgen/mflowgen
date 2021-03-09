#=========================================================================
# setup-session.tcl
#=========================================================================
# The setup session script configures the PrimteTime session to use
# PT PX or PrimePower to do power analysis
#
# Author : Maximilian Koschay
# Date   : 05.03.2021


# Set up paths and libraries

set_app_var search_path      ". $ptpx_additional_search_path $search_path"
set_app_var target_library   $ptpx_target_libraries
set_app_var link_library     [join "
                               *
                               $ptpx_target_libraries
                               $ptpx_extra_link_libraries
                             "]

# Set up power analysis

set_app_var power_enable_analysis true
set_app_var power_analysis_mode   $ptpx_analysis_mode

set_app_var report_default_significant_digits 3

# check if GL or RTL activity file is used by checking the existence of
# a namemap file

if {[file exists $ptpx_namemap] == 1} {
	set ptpx_rtl_mapping True
} else {
	set ptpx_rtl_mapping False
}

# check if requireed activity file exist

if {$ptpx_analysis_mode == "time_based"} {
	if {[file exists $ptpx_vcd] == 0} {
		echo "Error: Did not find a value change dumb file for time-based power analysis!"
    	exit 1
	} 
} elseif {$ptpx_analysis_mode == "averaged"} {
	if {[file exists $ptpx_saif] == 1} {
		set ptpx_averaged_use_activity "saif"
	} elseif { [file exists $ptpx_vcd] == 1 } {
		set ptpx_averaged_use_activity "vcd"
	} else {
		echo "Error: Did not find a VCD or SAIF file for averaged power analysis!"
    	exit 1
	}

} else {
	echo "Error: analysis_mode must be set either averaged or time_based!"
	exit 1
}