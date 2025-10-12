#! /usr/bin/env bash
#=========================================================================
# run.sh
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

# Print commands during execution

set -x

# Generate the Innovus foundation flow scripts

innovus -64 -no_gui -no_logv -batch -execute "writeFlowTemplate"

# Run the Innovus foundation flow
#
# Options for gen_flow.tcl
#
#     -d | --dir      : Output directory for generated scripts.
#     -f | --flat     : Level of unrolling ... full, partial, none
#     -n | --nomake   : Skip Makefile generation
#     -y | --style    : Rundir naming style [date|increment]
#     -r | --rtl      : Enable RTL Script Generation
#     -N | --Novus    : Enable novus_ui flowkit generation
#     -s | --setup    : Provide the directory containing the setup.tcl setup file
#     -u | --rundir   : Directory to execute the flow
#                       requried to run the Foundation Flow.
#     -v | --version  : Target version (17.1.0, 16.2.0, 16.1.0, 15.2.0, 15.1.0, ...)
#     -V | --Verbose  : Verbose mode
#
# The Innovus readme says to run the gen_flow.tcl script like this:
#
#     % tclsh <path_to>/SCRIPTS/gen_flow.tcl -m <flat | hier > <steps>
#
#     where <steps> = single step, step range, or 'all'
#
# The "all" indicates that all of the steps should be generated. The
# chosen Innovus steps is usually "all", but to fine-tune which steps are
# generated, change "all" to something like "init place postcts_hold route
# postroute signoff".
#

./SCRIPTS/gen_flow.tcl -m flat --Verbose --nomake --setup . --dir \
  innovus-foundation-flow all | tee flowsetup.log

# Make sure the foundation flow was generated

if [[ ! -d ./innovus-foundation-flow/INNOVUS ]]; then
  exit 1
fi

# Fix a potentially long filename

cd innovus-foundation-flow/INNOVUS
if [[ ! -f run_simple.tcl ]]; then
  mv run_simple*.tcl run_simple.tcl
fi
cd ../..

# IMPORTANT -- Make Innovus foundation flow path-agnostic!
#
# The foundation flow hardcodes the current directory into the scripts for
# some reason. This means that it expects you to always run the flow from
# the same directory it was generated in. We want a portable flow that can
# run from other directories.
#
# Only a few tcl files seem to have these hardcoded paths. The flow seems
# to work fine if we substitute the paths to just be '.' (i.e., whatever
# the current directory is).
#
# Notes
#
# - We grep the foundation flow with -l to get the files that have $PWD
#
# - The sed command needs | as the delimiter, since $PWD has / in it
#
# - Our current working directory may be a symlink, so `cd -P .` changes
# into the same directory without symlinks, and we try to substitute
# again. This is in case the flow scripts used the full path and not the
# symlink path. Then we cd back.
#
# After these steps, the flow scripts should be portable and can be run
# from any other directory.
#

grep $PWD innovus-foundation-flow -rl \
  | xargs sed -i "s|$PWD|.|g" &> /dev/null || true
cd -P .
grep $PWD innovus-foundation-flow -rl \
  | xargs sed -i "s|$PWD|.|g" &> /dev/null || true
cd - > /dev/null

# Remove $vars(config_files), which seems unnecessary and makes it easier
# to run a step from another directory. All the run scripts source this.

sed -i "s|^set vars(config_files).*$|set vars(config_files) {}|" \
  innovus-foundation-flow/vars.tcl

# Remove vpath touching, which is unnecessary and also causes directory
# management issues when innovus steps are modularized

sed -i "s/.*VPATH.*touch.*/#\0/" innovus-foundation-flow/INNOVUS/run*.tcl

# Prepare outputs

mkdir -p outputs && cd outputs

ln -sf ../innovus-foundation-flow .

cd ..


