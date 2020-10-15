#! /usr/bin/env bash

mkdir -p logs
pegasus -drc -gds ./inputs/design_merged.gds ./inputs/adk/${drc_rule_deck} -top_cell ${design_name} -log_dir ./logs/ -interactive -dp 8
mkdir -p outputs && cd outputs
ln -sf ../DRC.rep ./drc.summary
ln -sf ../DRC_RES.db ./drc.results