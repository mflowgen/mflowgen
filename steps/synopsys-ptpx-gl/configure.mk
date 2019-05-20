#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 20, 2019
#

#-------------------------------------------------------------------------
# Step Description -- synopsys-ptpx-gl
#-------------------------------------------------------------------------
# This step runs gate-level average power analysis with Synopsys PrimeTime

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.synopsys-ptpx-gl
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                 ______     __________     ______     _    _                   #'
	@echo '#                |  ___ \   |___    ___|   |  ___ \   | \  / |                  #'
	@echo '#                | (__ ) |      |  |       | (__ ) |   \ \/ /                   #'
	@echo '#                |  ____/       |  |       |  ____/     |  |                    #'
	@echo '#                |  |           |  |       |  |        / /\ \                   #'
	@echo '#                |__|           |__|       |__|       |_/  \_|                  #'
	@echo '#                             G A T E - L E V E L                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.synopsys-ptpx-gl = ptpx-gl

#-------------------------------------------------------------------------
# Interface to designer_interface.tcl
#-------------------------------------------------------------------------
# The designer_interface.tcl file is the first script run by PrimeTime
# (see the top of ptpx.tcl). It is the interface that connects the
# scripts with the ASIC design kit and the build system.
#
# This section defines variables passed from the build system to PT. The
# variables are exported to the environment so that the tcl script can see
# them.

# Directories

export ptpx_gl_flow_dir     = $(flow_dir.synopsys-ptpx-gl)
export ptpx_gl_plugins_dir  = $(plugins_dir.synopsys-ptpx-gl)
export ptpx_gl_logs_dir     = $(logs_dir.synopsys-ptpx-gl)
export ptpx_gl_reports_dir  = $(reports_dir.synopsys-ptpx-gl)
export ptpx_gl_results_dir  = $(results_dir.synopsys-ptpx-gl)
export ptpx_gl_collect_dir  = $(collect_dir.synopsys-ptpx-gl)

#--------------------------------------------------------------------
# Build variables
#--------------------------------------------------------------------

ptpx_gl_exec = pt_shell
ptpx_gl_tcl  = $(flow_dir.synopsys-ptpx-gl)/ptpx.tcl

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.synopsys-ptpx-gl

# Build directories

	rm -rf ./$(logs_dir.synopsys-ptpx-gl)
	rm -rf ./$(reports_dir.synopsys-ptpx-gl)
	rm -rf ./$(results_dir.synopsys-ptpx-gl)

	mkdir -p $(logs_dir.synopsys-ptpx-gl)
	mkdir -p $(reports_dir.synopsys-ptpx-gl)
	mkdir -p $(results_dir.synopsys-ptpx-gl)

# Run the ptpx script

	$(ptpx_gl_exec) -f $(ptpx_gl_tcl) \
    | tee $(logs_dir.synopsys-ptpx-gl)/ptpx.log

# Clean up

	mv pt_shell_command.log   $(logs_dir.synopsys-ptpx-gl) || true
	mv parasitics_command.log $(logs_dir.synopsys-ptpx-gl) || true

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-synopsys-ptpx-gl:
	rm -rf ./$(VPATH)/synopsys-ptpx-gl
	rm -rf ./$(logs_dir.synopsys-ptpx-gl)
	rm -rf ./$(reports_dir.synopsys-ptpx-gl)
	rm -rf ./$(results_dir.synopsys-ptpx-gl)
	rm -rf ./$(collect_dir.synopsys-ptpx-gl)
	rm -rf ./$(handoff_dir.synopsys-ptpx-gl)

clean-ptpx-gl: clean-synopsys-ptpx-gl


