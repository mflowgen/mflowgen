####################################################################################
# Design Compiler Reference Methodology
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
####################################################################################

The reference methodology provides users with a set of reference
scripts that serve as a good starting point for running each tool.  These
scripts are not designed to run in their current form.  They should be used
as a reference and adapted for use in your design environment.

The Design Compiler Reference Methodology includes options for
running DFT Compiler and Power Compiler optimization steps.  Please note
that additional licenses are required when running DFT Compiler and Power
Compiler inside of Design Compiler.  The sections of the script relating to
the use of DFT Compiler and Power Compiler are marked clearly, which allows you
to easily include or exclude these sections when preparing your synthesis
scripts.

For Design Compiler, a common set of scripts is provided that can be used
to run both Design Compiler and Design Compiler Topographical.
This common set of scripts also allows you to easily migrate your existing
scripts from wire load mode synthesis to topographical mode synthesis.
The script is designed to detect when Design Compiler is being run in
topographical mode (with the -topographical_mode option), and then
automatically execute additional steps relating to topographical mode synthesis.

The Design Compiler Reference Methodology includes support for the following flows:

*  The top-down synthesis flow, including multivoltage synthesis with
   IEEE 1801, which is also known as Unified Power Format (UPF).

*  The hierarchical synthesis flow, including multivoltage synthesis with UPF.

The Design Compiler Reference Methodology also includes options for running
Formality reference scripts to verify your synthesis results for all flows.

Note:
   All scripts are designed to work in both wire load mode and topographical mode.


The Design Compiler Reference Methodology includes the following files
======================================================================

DC-RMsettings.txt         - Reference methodology option settings used to generate
                            the scripts.

README.DC-RM.txt          - Information and instructions for setting up and
                            running the Design Compiler Reference Methodology scripts.

Release_Notes.DC-RM.txt   - Release notes for the Design Compiler Reference
                            Methodology scripts listing the incremental changes in
                            each new version of the scripts.

rm_setup/common_setup.tcl - Common design setup variables for all reference
                            methodologies, including those for Design Compiler,
                            IC Compiler, and TetraMAX.

rm_setup/dc_setup.tcl     - Library setup for Design Compiler Reference Methodology,
                            including the Formality script.

rm_setup/dc_setup_filenames.tcl

                          - File names setup for Design Compiler Reference
                            Methodology, including the Formality script.

rm_dc_scripts/dc.tcl      - Design Compiler Reference Methodology script for top-
                            down synthesis or block-level synthesis in a
                            hierarchical flow.

rm_dc_scripts/fm.tcl      - Formality script to verify top-down synthesis results or
                            block-level synthesis results in a hierarchical flow.

rm_dc_scripts/dc_top.tcl  - Design Compiler Reference Methodology top-level
                            integration script for hierarchical flow synthesis.

                            This file is included only if the reference methodology
                            scripts are configured for a hierarchical flow.

rm_dc_scripts/fm_top.tcl  - Formality top-level verification script for
                            hierarchical flow synthesis.

                            This file is included only if the reference methodology
                            scripts are configured for a hierarchical flow.

rm_dc_scripts/dc.upf      - Design Compiler Reference Methodology sample UPF file
                            for top-down multivoltage synthesis.

                            This file is included only if the reference methodology
                            scripts are configured for a multivoltage flow.

rm_dc_scripts/dc.dft_autofix_config.tcl

                          - Design Compiler Reference Methodology sample design for
                            test AutoFix configuration file.

rm_dc_scripts/dc.dft_occ_config.tcl

                          - Design Compiler Reference Methodology sample
                            design-for-test (DFT) on-chip clocking configuration
                            file.

                            This file is included only when the reference
                            methodology scripts are configured to include on-chip
                            clocking in the DFT flow.


Instructions
Using the Design Compiler Reference Methodology for a Top-Down Flow
===================================================================

Note:
    The file names in the following instructions refer to variable names that are
    defined in the dc_setup_filenames.tcl file. Default file names are assigned for
    all variables. You can customize your flow by changing the names to match the
    names of the files used in your flow.

1.  Copy the reference methodology files to a new location.

2.  Edit common_setup.tcl to set the design name, search path, and library
    information for your design.

3.  Edit dc_setup.tcl to customize your Design Compiler setup.

    The dc_setup.tcl file is designed to work automatically with the values
    provided in common_setup.tcl.  Include a list of your RTL files in the
    RTL_SOURCE_FILES variable.  Use only file names and take advantage of the
    search_path setting to keep your files portable.

    Alternatively, you can use a separate script to read the RTL files in
    Design Compiler and Formality.  To use this capability, select SCRIPT for the
    RTL Source Format option when you download the scripts in RMgen. The
    ${DCRM_RTL_READ_SCRIPT} and ${FMRM_RTL_READ_SCRIPT} variables in the
    dc_setup_filenames.tcl file define the names of these scripts.

    Set up multicore optimization, if desired, by using the "set_host_options"
    command.  Ensure that you have sufficient cores and sufficient copies
    of all feature licenses to support your settings.

    Point to a common "alib_library_analysis_path" to save some runtime in
    subsequent DC sessions.

4.  Edit the dc.tcl file to customize the steps that you want to perform in your
    design synthesis.

    Read through this script carefully, note the comments, and choose which
    steps you want to include in your synthesis.  Remember that this is a
    reference example and requires modification to work with your design.

    You can customize the file names for input files, output files, and reports
    by changing the file names in dc_setup_filenames.tcl.

5.  Ensure that you have all the necessary design-specific input files to be used
    in the flow.  These files are picked up automatically from the search path
    defined in common_setup.tcl

    The minimum recommended files are

    o  ${DCRM_CONSTRAINTS_INPUT_FILE} (Logical design constraints)
    o  ${DCRM_DCT_DEF_INPUT_FILE} or ${DCRM_DCT_FLOORPLAN_INPUT_FILE}
       (floorplan to use for topographical mode synthesis)
    o  ${DCRM_DFT_SIGNAL_SETUP_INPUT_FILE} (DFT signal definitions)

    For a complete list of expected input files, see the list at the end
    of this README file.

6.  For a multivoltage flow, ensure that you have the following
    additional minimum recommended files:

    o  ${DCRM_MV_UPF_INPUT_FILE} (UPF setup file)
    o  ${DCRM_MV_SET_VOLTAGE_INPUT_FILE} (set_voltage commands)
    o  ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE} (create_voltage_area commands
                                               for topographical mode synthesis)

    The dc.upf file shows a general example of a UPF file.
    You can also use a Tcl-based utility, UPFgen, to quickly generate
    a UPF template for your design.

    For more information about UPFgen, please see the following SolvNet article:

    https://solvnet.synopsys.com/retrieve/025029.html

7.  Run your synthesis by using the dc.tcl script.

    For the standard reference methodology flow, run the tool from the directory
    above the rm_setup directory.

    % dc_shell -topographical_mode -f rm_dc_scripts/dc.tcl | tee dc.log

    For the Lynx-compatible reference methodology flow, run the tool from a
    directory tree that is parallel to the working directory.  The working directory
    name should be $rm_root/rm_dc/tmp, and the directory $rm_root/rm_dc/logs should
    also exist before you run the tool.

    % dc_shell -topographical_mode \
               -f ../../scripts_block/rm_dc_scripts/dc.tcl | tee ../logs/dc.log

8.  Verify the synthesis results by looking at your log file and studying the
    reports created in the ${REPORTS} directory.

    When you are satisfied that synthesis completed successfully, proceed to
    Formality verification in the next step.

9.  Edit the fm.tcl file as needed for Formality verification.

10. If you are using a UPF multivoltage flow and you are mapping
    to retention registers, you need to replace the technology library
    models of those cells with Verilog simulation models for Formality
    verification.

    Please see the following SolvNet article for details:

    https://solvnet.synopsys.com/retrieve/024106.html

11. Run your Formality verification by using the fm.tcl script.

    For the standard reference methodology flow, run the tool from the directory
    above the rm_setup directory.

    % fm_shell -f rm_dc_scripts/fm.tcl | tee fm.log

    For the Lynx-compatible reference methodology flow, run the tool from a
    directory tree that is parallel to the working directory.

    % fm_shell -f ../../scripts_block/rm_dc_scripts/fm.tcl | tee ../logs/fm.log


Instructions
Using the Design Compiler Reference Methodology for a Hierarchical Flow
=======================================================================

Note:
   The file names in the following instructions refer to variable names that are
   defined in the dc_setup_filenames.tcl file. Default file names are assigned for
   all variables. You can customize your flow by changing the names to match the
   names of the files used in your flow.

For general hierarchical flow overview information, please consult the
following application notes, which are available on SolvNet:

*  Hierarchical Flow Support in Design Compiler Topographical Mode

   https://solvnet.synopsys.com/retrieve/021034.html

*  IEEE P1801 (UPF) based Design Compiler topographical and IC Compiler
   Hierarchical Design Methodology

   https://solvnet.synopsys.com/retrieve/026172.html


*** Important NOTES ***
###########################################################################
# IC Compiler interface logic model (ILM) support is not available for the
# hierarchical multivoltage flow.
#
# The hierarchical flow is not yet available for the Lynx-compatible version
# of the reference methodology scripts.  If you select both the Lynx-compatible
# version of the scripts and a hierarchical flow in RMgen, it generates
# Lynx-compatible scripts for a top-down flow.
###########################################################################

Note:
    The Design Compiler Reference Methodology is designed to be used
    together with the IC Compiler Hierarchical Reference Methodology,
    which is part of the IC Compiler Reference Methodology and is
    available as a separate download from SolvNet.

To run the Design Compiler Hierarchical Reference Methodology scripts for
block-level synthesis,

1.  Edit the common_setup.tcl file to set the design name, search path,
    and library information for your design.

    Only the ${DESIGN_NAME} variable
    changes between your block-level synthesis runs.

    Note:
        For a hierarchical flow, the IC Compiler Hierarchical Reference
        Methodology requires the use of absolute paths
        in the common_setup.tcl file because this file is used at different
        UNIX path locations.

        Use the ${DESIGN_REF_DATA} absolute path prefix as much as possible
        for all your search_path and library specifications in order to keep
        your common_setup.tcl file portable.

    Example:
        # Absolute path prefix variable
        set DESIGN_REF_DATA "/designs/ProjectX/Rev3/design_data"

        set ADDITIONAL_SEARCH_PATH "${DESIGN_REF_DATA}/rtl \
                                    ${DESIGN_REF_DATA}/libs"

2.  Set up separate subdirectories for each of the hierarchical blocks by
    using the design name. (The IC Compiler Hierarchical Reference Methodology
    does this automatically.)

    Ensure that each block common_setup.tcl file has the ${DESIGN_NAME} variable
    set to the block design name. (The IC Compiler Hierarchical Reference
    Methodology does this automatically)

    Note:
        Even if you use the IC Compiler Hierarchical Reference Methodology to set
        up your block directories, the following files will still need to be
        copied in each block subdirectory:

    	-  rm_setup/dc_setup.tcl
    	-  rm_setup/dc_setup_filenames.tcl
    	-  rm_dc_scripts/*

3.   Follow the top-down flow instructions, described previously, to synthesize
     each of the hierarchical blocks by using the dc.tcl script.

4.   Ensure that you have all the design-specific input files you need for
     each hierarchical design.  These files are picked up automatically from
     the search path defined in common_setup.tcl

     The minimum recommended files are

     o  ${DCRM_SDC_INPUT_FILE} (Budgeted block Synopsys Design Constraints (SDC)
                                constraints from the IC Compiler Hierarchical
                                Reference Methodology)

     o  ${DCRM_DCT_DEF_INPUT_FILE} (Design Exchange Format (DEF) block floorplan
                                    from the IC Compiler Hierarchical
                                    Reference Methodology)

     o  ${DCRM_DFT_SIGNAL_SETUP_INPUT_FILE} (DFT signal definitions for each block)

     Ensure that you have DFT signal definition files for each block.
     This is not automated in the flow.  Consult with your DFT engineer
     to obtain the correct setup for each block.

5.   For a multivoltage flow, ensure that you have the following additional
     minimum recommended files for each hierarchical design block:

     o  ${DCRM_MV_UPF_INPUT_FILE} (UPF setup file for each block)
     o  ${DCRM_MV_SET_VOLTAGE_INPUT_FILE} (set_voltage commands for each block)
     o  ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE} (create_voltage_area commands for
                                                topographical mode synthesis)

     The dc.upf file shows a general example of a UPF file.

     You can also use a Tcl-based utility, UPFgen, to quickly generate
     a UPF template for your design.

     For more information about UPFgen, please see the following SolvNet article:

     https://solvnet.synopsys.com/retrieve/025029.html

     Include the create_voltage_area settings for nested power domains in
     each hierarchical design.  Get the block voltage area coordinates from
     the following IC Compiler Hierarchical Reference Methodology report:

     ${DESIGN_NAME}.icc_dp.voltage_area.rpt

     Make a "create_voltage_area" script file for each design with the
     following file name:

     ${DESIGN_NAME}.create_voltage_area.tcl

6.   If you want to use Design Compiler ILMs, include the ILM creation step
     at the end of the script:

     create_ilm
     write -format ddc -hierarchy \
      -output ${RESULTS_DIR/${DCRM_FINAL_ILM_DDC_OUTPUT_FILE}

7.   Run synthesis in each of the block subdirectories:

     % cd ${BLOCK_NAME}
     % dc_shell -topographical_mode -f rm_dc_scripts/dc.tcl | tee dc.log

8.   Verify the synthesis results by looking at your log file and studying
     the reports created in the ${REPORTS} directory.

     When you are satisfied that synthesis completed successfully, proceed to
     Formality verification in the next step.

9.   Edit the fm.tcl file as needed for Formality verification.

10.  If you are using a UPF flow and you are mapping to retention
     registers, you need to replace the technology library models of those
     cells with Verilog simulation models for Formality verification.

     Please see the following SolvNet article for details:

     https://solvnet.synopsys.com/retrieve/024106.html

11.  Verify each block synthesis run separately with Formality

     % cd ${BLOCK_NAME}
     % fm_shell -f rm_dc_scripts/fm.tcl | tee fm.log

12.  Verify that all of your block-level runs have completed successfully.


To run the Design Compiler Hierarchical Reference Methodology scripts for
top-level synthesis,

1.   Create an additional subdirectory for your top-level synthesis.
     (The IC Compiler Hierarchical Reference Methodology does this automatically.)

2.   Edit the common_setup.tcl at the top-level.

     Include the list of hierarchical design names and cell names in the
     common_setup.tcl variables shown in the following example:

####################################################################################
# Hierarchical Flow Design Variables
####################################################################################

set HIERARCHICAL_DESIGNS           "" ;# List of hierarchical block design names "DesignA DesignB" ...
set HIERARCHICAL_CELLS             "" ;# List of hierarchical block cell instance names "u_DesignA u_DesignB" ...

    o  For each hierarchical block, add the following to your common_setup.tcl

          ${ADDITIONAL_SEARCH_PATH} at the top-level:

          ../${BLOCK_NAME}/results

       This allows the top-level synthesis run to easily pick up the block-level
       synthesis results.

    o  Add any IC Compiler ILMs to the ${MW_REFERENCE_LIB_DIRS} variable. Point
       to the Milkyway design library that contains the IC Compiler ILM for the
       abstracted block.

3.  Define the hierarchical block design names in the dc_setup.tcl file:

    o  DDC_HIER_DESIGNS - list of Synopsys logical database format (.ddc)
                          hierarchical design names
    o  DC_ILM_HIER_DESIGNS - list of Design Compiler ILM hierarchical design names
    o  ICC_ILM_HIER_DESIGNS - list of IC Compiler ILM hierarchical design names

###########################################################################
# Note: IC Compiler ILM support is not available for the hierarchical
#       multivoltage flow.
###########################################################################

4.  Ensure that you have all of the design-specific input files that
    you need to use in the flow.  These files are picked up automatically
    from the search path defined in common_setup.tcl

    The following are the minimum recommended files:

    o  ${DCRM_CONSTRAINTS_INPUT_FILE} (Logical design constraints)
    o  ${DCRM_DCT_DEF_INPUT_FILE} or ${DCRM_DCT_FLOORPLAN_INPUT_FILE}
       (floorplan to use for topographical mode synthesis)
    o  ${DCRM_DFT_SIGNAL_SETUP_INPUT_FILE} (DFT signal definitions)

    Use the same constraints at the top-level that you would use for
    a top-down flow.

    o  For topographical mode synthesis, include the floorplan for the top-level.

    o  Use a floorplan where the hierarchical blocks have been partitioned and
       have fixed placement at the top-level.

    (The IC Compiler Hierarchical Reference Methodology creates an updated top-level
    floorplan with fixed placement information for the hierarchical blocks.)

    A complete list of the expected input files is provided at the end of this
    README file.

5.  For a multivoltage flow, ensure that you have the following
    additional minimum recommended files:

    o  ${DCRM_MV_UPF_INPUT_FILE} (Top-level UPF setup file)
    o  ${DCRM_MV_SET_VOLTAGE_INPUT_FILE} (Top-level set_voltage commands)
    o  ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE} (create_voltage_area commands
                                              for topographical mode synthesis)

    Note:
       The UPF file for the top-level synthesis should only include UPF
       design information for the top-level.  Block-level UPF information
       is propagated to the top-level as a part of the flow.

    The dc.upf file shows a general example of a UPF file.

    You can also use a Tcl-based utility, UPFgen, to quickly generate
    a UPF template for your design.

    For more information about UPFgen, please see the following SolvNet article:

    https://solvnet.synopsys.com/retrieve/025029.html

6.  Run synthesis at the top-level:

    % cd ${TOP_DESIGN_NAME}
    % dc_shell -topographical_mode -f rm_dc_scripts/dc_top.tcl | tee dc_top.log

7.  Verify the synthesis results by looking at your log file and studying the
    reports created in the ${REPORTS} directory.

    When you are satisfied that synthesis completed successfully, proceed to
    Formality verification in the next step.

8.  Edit the fm_top.tcl file as needed for Formality verification.

9.  If you are using a UPF multivoltage flow and you are mapping
    to retention registers, you need to replace the technology library
    models of those cells with Verilog simulation models for Formality verification.

    Please see the following SolvNet article for details:

    https://solvnet.synopsys.com/retrieve/024106.html

10. If you are using a UPF multivoltage flow, the dc_top.tcl
    script writes out the following two UPF integration files automatically
    to facilitate verification of the top-level design in Formality.

    o  ${RESULTS}/${DESIGN_NAME}.full_chip.RTL.upf
    o  ${RESULTS}/${DESIGN_NAME}.full_chip.mapped.upf

    You are responsible for carefully examining these files for
    correctness.

11. Verify your top-level synthesis in Formality:

    % cd ${TOP_DESIGN_NAME}
    % fm_shell -f rm_dc_scripts/fm_top.tcl | tee fm_top.log

The final written netlist will contain the design without the physical hierarchical
blocks.  The next tool in the flow is expected to read the physical block-level
synthesis results in addition to the top-level synthesis results to obtain the
complete synthesized design.


Input Files for the Design Compiler Reference Methodology
=========================================================

Note:
   Not all of these files are required. You can see the complete list of input files
   and define the file names in the dc_setup_filenames.tcl file.

*  ${RTL_SOURCE_FILES} (list of RTL source files defined in dc_setup.tcl)

*  ${DCRM_RTL_READ_SCRIPT} and ${FMRM_RTL_READ_SCRIPT} (RTL read scripts)

*  ${DCRM_CONSTRAINTS_INPUT_FILE} (logical design constraints for synthesis,
                                   top-level in hierarchical flow)

*  ${DCRM_SDC_INPUT_FILE} (SDC logical design constraints,
                           blocks in hierarchical flow)

*  ${DESIGN_NAME}.saif (Activity Interchange Format (SAIF) file for gate-level
                        power optimization)

*  ${DCRM_DCT_DEF_INPUT_FILE} or ${DCRM_DCT_FLOORPLAN_INPUT_FILE}
                       (DEF floorplan to use for topographical mode synthesis)

*  ${DCRM_DFT_SIGNAL_SETUP_INPUT_FILE} (DFT signal definitions)

*  ${DCRM_DFT_AUTOFIX_CONFIG_INPUT_FILE} (DFT AutoFix configuration)

*  ${DCRM_DFT_OCC_CONFIG_INPUT_FILE} (DFT on-chip clocking configuration)

*  ${DESIGN_NAME}.upf (UPF setup file for multivoltage flow)

*  ${DCRM_MV_UPF_INPUT_FILE} (set_voltage commands for multivoltage flow)

*  ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE} (create_voltage_area commands for
                                           multivoltage flow)


Output Files from the Design Compiler Reference Methodology
===========================================================

The ${REPORTS} directory defined in dc_setup.tcl contains reports from the
synthesis run.

The ${RESULTS} directory defined in dc_setup.tcl contains the synthesis
output files, including the mapped netlist and the files needed for timing
analysis, power analysis, and formal verification.

You can see the complete list of output files and define the file names in
the dc_setup_filenames.tcl file.

The output files generated by the Design Compiler Reference Methodology
scripts are designed to be used as inputs for the IC Compiler Reference
Methodology.  The IC Compiler Reference Methodology is the next step in the
reference flow and is available as a separate download from SolvNet.
