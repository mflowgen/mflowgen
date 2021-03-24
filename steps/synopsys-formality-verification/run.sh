#! /usr/bin/env bash
#=========================================================================
# run.sh
#=========================================================================
# Author : Kartik Prabhu
# Date   : March 23, 2021
#

# Print commands during execution

set -x

# Build directories

rm -rf ./logs
rm -rf ./reports

mkdir -p logs
mkdir -p reports


fm_shell -f START.tcl | tee -i logs/fm.log
