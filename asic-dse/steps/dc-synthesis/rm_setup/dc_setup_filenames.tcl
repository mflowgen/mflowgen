#################################################################################
# Design Compiler Reference Methodology Filenames Setup
# Script: dc_setup_filenames.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
#################################################################################

#################################################################################
# Use this file to customize the filenames used in the Design Compiler
# Reference Methodology scripts.  This file is designed to be sourced at the
# beginning of the dc_setup.tcl file after sourcing the common_setup.tcl file.
#
# Note that the variables presented in this file depend on the type of flow
# selected when generating the reference methodology files.
#
# Example.
#    If you set DFT flow as FALSE, you will not see DFT related filename
#    variables in this file.
#
# When reusing this file for different flows or newer release, ensure that
# all the required filename variables are defined.  One way to do this is
# to source the default dc_setup_filenames.tcl file and then override the
# default settings as needed for your design.
#
# The default values are backwards compatible with older
# Design Compiler Reference Methodology releases.
#
# Note: Care should be taken when modifying the names of output files
#       that are used in other scripts or tools.
#################################################################################

#################################################################################
# General Flow Files
#################################################################################

##########################
# Milkyway Library Names #
##########################

set DCRM_MW_LIBRARY_NAME				${DESIGN_NAME}_LIB
set DCRM_FINAL_MW_CEL_NAME				${DESIGN_NAME}_DCT

###############
# Input Files #
###############

set DCRM_SDC_INPUT_FILE					${DESIGN_NAME}.sdc
#YUNSUP: this is set by make_generated_vars.tcl
#set DCRM_CONSTRAINTS_INPUT_FILE				${DESIGN_NAME}.constraints.tcl

###########
# Reports #
###########

set DCRM_CONSISTENCY_CHECK_ENV_FILE			${DESIGN_NAME}.compile_ultra.env

set DCRM_FINAL_QOR_REPORT				${DESIGN_NAME}.mapped.qor.rpt
set DCRM_FINAL_TIMING_REPORT				${DESIGN_NAME}.mapped.timing.rpt
set DCRM_FINAL_AREA_REPORT				${DESIGN_NAME}.mapped.area.rpt
set DCRM_FINAL_POWER_REPORT				${DESIGN_NAME}.mapped.power.rpt
set DCRM_FINAL_CLOCK_GATING_REPORT			${DESIGN_NAME}.mapped.clock_gating.rpt

################
# Output Files #
################

set DCRM_ELABORATED_DESIGN_DDC_OUTPUT_FILE 		${DESIGN_NAME}.elab.ddc
set DCRM_COMPILE_ULTRA_DDC_OUTPUT_FILE			${DESIGN_NAME}.compile_ultra.ddc
set DCRM_FINAL_DDC_OUTPUT_FILE				${DESIGN_NAME}.mapped.ddc
set DCRM_FINAL_VERILOG_OUTPUT_FILE			${DESIGN_NAME}.mapped.v
set DCRM_FINAL_SDC_OUTPUT_FILE				${DESIGN_NAME}.mapped.sdc


#################################################################################
# DCT Flow Files
#################################################################################

###################
# DCT Input Files #
###################

set DCRM_DCT_DEF_INPUT_FILE				${DESIGN_NAME}.def
set DCRM_DCT_FLOORPLAN_INPUT_FILE			${DESIGN_NAME}.fp
set DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE		${DESIGN_NAME}.physical_constraints.tcl


###############
# DCT Reports #
###############

set DCRM_DCT_PHYSICAL_CONSTRAINTS_REPORT		${DESIGN_NAME}.physical_constraints.rpt

set DCRM_DCT_FINAL_CONGESTION_REPORT			${DESIGN_NAME}.mapped.congestion.rpt
set DCRM_DCT_FINAL_CONGESTION_MAP_OUTPUT_FILE		${DESIGN_NAME}.mapped.congestion_map.png
set DCRM_DCT_FINAL_CONGESTION_MAP_WINDOW_OUTPUT_FILE	${DESIGN_NAME}.mapped.congestion_map_window.png

####################
# DCT Output Files #
####################

set DCRM_DCT_FLOORPLAN_OUTPUT_FILE			${DESIGN_NAME}.fp

set DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE		${DESIGN_NAME}.mapped.fp
set DCRM_DCT_FINAL_SPEF_OUTPUT_FILE			${DESIGN_NAME}.mapped.spef
set DCRM_DCT_FINAL_SDF_OUTPUT_FILE			${DESIGN_NAME}.mapped.sdf


#################################################################################
# Formality Flow Files
#################################################################################

set DCRM_SVF_OUTPUT_FILE 				${DESIGN_NAME}.mapped.svf

set FMRM_UNMATCHED_POINTS_REPORT			${DESIGN_NAME}.fmv_unmatched_points.rpt

set FMRM_FAILING_SESSION_NAME				${DESIGN_NAME}
set FMRM_FAILING_POINTS_REPORT				${DESIGN_NAME}.fmv_failing_points.rpt
set FMRM_ABORTED_POINTS_REPORT				${DESIGN_NAME}.fmv_aborted_points.rpt
set FMRM_ANALYZE_POINTS_REPORT				${DESIGN_NAME}.fmv_analyze_points.rpt
