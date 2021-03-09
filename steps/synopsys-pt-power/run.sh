#! /usr/bin/env bash
#=========================================================================
# run.sh
#=========================================================================
# Author : Maximilian Koschay
# Date   : 05.03.2021
#

# Print commands during execution

set -x

# Prime Time Shell
pt_exec='pt_shell'

# Build directories

rm -rf ./logs
rm -rf ./reports
rm -rf ./outputs

mkdir -p logs
mkdir -p reports
mkdir -p outputs

$pt_exec -f START.tcl -output_log_file logs/pt.log || exit 1





