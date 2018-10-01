####################################################################################
# Synopsys(R) PrimeTime(R) Reference Methodology
# Version: K-2015.12-SP2 (April 4, 2016)
# Copyright (C) 2009-2016 Synopsys All rights reserved.
####################################################################################

A reference methodology provides a set of reference scripts that serve as a good 
starting point for running a tool. These scripts are not designed to run in their 
current form. You should use them as a reference and adapt them for use in your 
design environment.

The PrimeTime Reference Methodology includes options for running the PrimeTime, 
PrimeTime SI, PrimeTime ADV, PrimeTime GCA, and PrimeTime PX tools. Note that additional 
licenses are required when running the add-on tools.

The PrimeTime Reference Methodology also includes options for using multivoltage 
scaling libraries and IEEE 1801 mode, options for running power analysis, and a link  
to TetraMAX. IEEE 1801 is also known as the Unified Power Format (UPF).


Files Included With the PrimeTime Reference Methodology
=======================================================

------------------------------------------------------------------------------------
File	                        Description
------------------------------------------------------------------------------------
PT-RMsettings.txt               Reference methodology option settings that were 
                                selected when the scripts were generated

README.PT-RM.txt                Information and instructions for setting up and 
                                running the PrimeTime Reference Methodology scripts

Release_Notes.PT-RM.txt         Release notes for the PrimeTime Reference 
                                Methodology scripts listing the incremental 
                                changes in each new version of the scripts

common_setup.tcl                Common design setup variables for the reference 
                                methodologies

pt_setup.tcl                    Library and variable setup for PrimeTime 
                                Reference Methodology

rm_pt_scripts/pt.tcl            PrimeTime Reference Methodology generic run script 
                                for the PrimeTime tool

rm_pt_scripts/dmsa.tcl          PrimeTime Reference Methodology DMSA run script 
                                for the PrimeTime tool 

rm_pt_scripts/dmsa_mc.tcl       PrimeTime Reference Methodology DMSA scenario 
                                script for the PrimeTime tool

rm_pt_scripts/dmsa_analysis.tcl PrimeTime Reference Methodology DMSA analysis 
                                script for the PrimeTime tool
------------------------------------------------------------------------------------
 

Instructions for using the PrimeTime Reference Methodology
==========================================================

1. Copy the reference methodology files to a new location.

2. Edit common_setup.tcl to set the design name, search path, and library 
   information for your design.

3. Edit pt_setup.tcl to further customize your PrimeTime setup.
     
   This file is designed to work automatically with the values provided
   in the common_setup.tcl file.

4. Edit pt_scripts/pt.tcl to customize the steps that you want to perform in your 
   static timing analysis. 
     
   Read the script carefully, note the comments, and choose which steps you want 
   to include in your analysis. You can also change the file names to support your 
   design environment. This is a reference example. It requires modification to 
   work with your design.

5. Run your static timing analysis by using the appropriate command for the flow
   you selected in RMgen.
   
   For a standard reference methodology flow, run the tool from the directory 
   above the rm_setup directory.
   
   For a Lynx-compatible reference methodology flow, run the tool from a directory
   tree that is parallel to the working directory. The working directory name 
   should be rm_pt/tmp, and the directory rm_pt/logs should also
   exist before you run the tool.

   To run the generic flow, enter one of the following commands:               

   o  For the standard reference methodology flow, enter
      
      % pt_shell -f rm_pt_scripts/pt.tcl | tee pt.log

   o  For the Lynx-compatible reference methodology flow, enter

      % mkdir -p rm_pt/tmp rm_pt/logs/pt
      % cd rm_pt/tmp
      % pt_shell -f ../../scripts_block/rm_pt_scripts/pt.tcl | tee ../logs/pt/pt.log

   To run the DMSA flow, enter one of the following commands:
   
   o  For the standard reference methodology flow, enter
     
      % pt_shell -multi -f rm_pt_scripts/dmsa.tcl | tee dmsalog

   o  For the Lynx-compatible reference methodology flow, enter

      % mkdir -p rm_pt/tmp rm_pt/logs/pt
      % cd rm_pt/tmp
      % pt_shell -multi \
           -f ../../scripts_block/rm_pt_scripts/dmsa.tcl | tee ../logs/pt/dmsalog


Input files for the PrimeTime Reference Methodology
===================================================

Note:
   Not all of these files are required. You can change these default names.


Flow Independent
------------------------------------------------------------------------------------
File                    Description
------------------------------------------------------------------------------------
${NETLIST_FILES}        List of Verilog netlist files defined in pt_setup.tcl
------------------------------------------------------------------------------------


Generic Flow
------------------------------------------------------------------------------------
File                    Description
------------------------------------------------------------------------------------
${libraries}            Library files

${mv1_scaling_library}  Multivoltage scaling library (1) file

${mv2_scaling_library}  Multivoltage scaling library (2) file

${UPF_FILE}             UPF setup file

${LPPI_FILE}            Script file containing commands that set the
                        link_path_per_instance variable to ensure appropriate 
                        linking for the design in the PrimeTime tool 

                        This file is written by the write_link_library command 
                        in the Synopsys Design Compiler(R) tool or the 
                        Synopsys IC Compiler(TM) tool.

${SDF_PATHS}            Standard Delay Format (SDF) path for SDF file, 
                        if SDF back annotation flow is used

${SDF_FILES}            SDF file, if SDF back annotation flow is used 

${PARASITIC_PATHS}      Path to parasitics file if either a Synopsys Binary 
                        Parasitic Format (SBPF) file or a Standard Parasitic 
                        Exchange Format (SPEF) file is used 

${PARASITIC_FILES}      Parasitic file, either SBPF or SPEF file can be used

${CONSTRAINT_FILES}     Timing constraint files for the design, or files generated  
                        by the Synopsys TetraMAX(R) tool

${AOCVM_FILES}          Advanced OCV mode derate file

${ACTIVITY_FILE}        Switching activity file for power analysis

${STRIP_PATH}           Provides strip path setting for the switching activity 
                        file

${NAME_MAP_FILE}        Name mapping file for power analysis

${PT2TMAX_SCRIPT_FILE}  pt2tmax tool command language (Tcl) script file

${LEF_FILES} 		LEF files for physically-aware ECO

${DEF_FILES} 		DEF files for physically-aware ECO

${PHYSICAL_CONSTRAINT_FILE}	
			Physical constraint file for physically-aware ECO
------------------------------------------------------------------------------------


DMSA Flow
------------------------------------------------------------------------------------
File                                    Description
------------------------------------------------------------------------------------

Libraries, UPF, SDF, AOCVM, and parasitic files are corner based
----------------------------------------------------------------
${dmsa_corner_library_files($corner)}  	Library files

${dmsa_mv1_scaling_library($corner)}   	Multivoltage scaling library (1) file

${dmsa_mv2_scaling_library($corner)}   	Multivoltage scaling library (2) file

${dmsa_UPF_FILE}                       	UPF setup file

${SDF_PATHS($corner)}                   Path to SDF file, if SDF back annotation 
                                        flow is used

${SDF_FILES($corner)}                   SDF file, if SDF back annotation flow 
                                        is used

${PARASITIC_PATHS($corner)}             Path to parasitics file, if either SBPF 
                                        or SPEF file is used

${PARASITIC_FILES($corner)}             Parasitic file, if either SBPF or SPEF file
                                        is used

${AOCVM_FILES($corner)}                 Advanced OCV mode file for each corner

${ACTIVITY_FILE}                        Switching activity file for power analysis

${STRIP_PATH}                           Provides strip path setting for the 
                                        switching activity file

${NAME_MAP_FILE}                        Name mapping file for power analysis

${LEF_FILES} 				LEF files for physically-aware ECO

${DEF_FILES} 				DEF files for physically-aware ECO

${PHYSICAL_CONSTRAINT_FILE}		Physical constraint file for physically-aware ECO

Constraints are mode based
--------------------------
${dmsa_mode_constraint_files($mode)}    Mode-dependent timing constraints for  
                                       	the design, or mode-dependent files 
                                       	generated by the TetraMAX tool
------------------------------------------------------------------------------------


Output files from PrimeTime Reference Methodology
=================================================

For both the generic and DMSA flows, the ${REPORTS} directory defined 
in pt_setup.tcl contains reports from the static timing analysis run.

For the DMSA flow, you should inspect the following subdirectory:

Each mode or corner (scenario) of a DMSA run has a log file located at

   <current_working_directory>/work/scenario/out.log

You should analyze the output files generated by the PrimeTime Reference Methodology 
scripts to resolve issues with the setup (check_timing -verbose and report_clock) 
and timing violations (report_timing and report_constraints).
