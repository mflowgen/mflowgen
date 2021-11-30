#! /usr/bin/env bash
#=========================================================================
# run.sh
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

# Print commands during execution

set -x

# DC shell

dc_exec='dc_shell-xg-t -64bit'

# Build directories

rm -rf ./logs
rm -rf ./reports
rm -rf ./results

mkdir -p logs
mkdir -p reports
mkdir -p results

# alib
#
# Design Compiler caches analyzed libraries to improve performance using
# ".alib" directories. The alib takes a while to generate but is reused on
# subsequent runs. It is useful to store a centralized copy of the alib to
# avoid re-generating the alib (usually only several minutes but can be
# annoying) on every new clone of the ASIC repo.
#
# However, if DC sees a .db that does not have an associated .alib it will
# try to automatically create one. This is not usually a problem when
# students just use standard cells, but if a student is trying to use
# SRAMs, then they will be using new .db files that DC has not seen yet.
# The problem is that students do not have write permissions to the
# centralized copy of the alib in the ADK.
#
# The solution we use is to create a local alib directory in the current
# build directory with _per-file_ symlinks to the centralized alib (and
# with the same directory hierarchy). This allows students to reuse the
# centralized copies of the alib files while allowing new alibs (e.g., for
# SRAMs) to be generated locally.
#
# This is possible because the alibs are stored in a directory that holds
# a ".db.alib" file for each db file:
#
# - alib
#   - alib-52
#     - iocells.db.alib
#     - stdcells.db.alib
#
# This new alib directory just needs to contain symlinks to each saved
# alib in the ADK. This can be done simply by using "cp -srf" of the ADK
# alib to the build directory, which generates symbolic links to each file
# instead of copying. This way, the student can access the master copy of
# the saved alibs in the ADK, and if there are any additional db's
# specified, their alibs will be saved in the local build directory.

rm -rf alib
mkdir -p alib

cp -srf $PWD/inputs/adk/alib/* alib || true

# Run the synthesis script

if [ "x$topographical" == "xTrue" ]; then
  opt_topographical='-topographical_mode'
else
  opt_topographical=
fi

$dc_exec $opt_topographical -f START.tcl -output_log_file logs/dc.log || exit 1

# Compress the spef file

cd results
gzip *.mapped.spef
cd ..

# Set up the outputs

mkdir -p outputs && cd outputs

ln -sf ../results/*.mapped.v       design.v
ln -sf ../results/*.mapped.sdc     design.sdc
ln -sf ../results/*.mapped.spef.gz design.spef.gz
ln -sf ../reports/*.namemap        design.namemap
ln -sf ../results/*.svf            design.svf
ln -sf ../results/*.upf            design.upf

cd ..


