#! /usr/bin/env bash
#=========================================================================
# debug.sh
#=========================================================================
# Author : Maximilian Koschay
# Date   : 05.03.2021
#

# Print commands during execution

set -x

# Prime Time Shell
pt_exec='pt_shell'

# Check if a finished session was saved
if [[ -d ./outputs/primetime.session ]]; then
	$pt_exec -gui -x "restore_session outputs/primetime.session/" -output_log_file logs/pt.log || exit 1
else
	export SYN_EXIT_AFTER_SETUP=1
	$pt_exec -gui -f "START.tcl" -output_log_file logs/pt.log || exit 1
fi

