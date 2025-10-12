#=========================================================================
# Makefile
#=========================================================================
# Generate db from a lib file (using Synopsys DC)
#
# Author : Christopher Torng
# Date   : November 11, 2019
#

all:
	rm -rf build
	mkdir -p build
	cd build && dc_shell-xg-t -64bit -output_log_file build.log -f ../generate_db.tcl | tee build.log

