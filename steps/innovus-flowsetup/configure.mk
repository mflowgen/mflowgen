#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-flowsetup
#-------------------------------------------------------------------------
# This step sets up the Innovus foundation flow and also sets up shared
# Innovus-related variables (e.g., directories, exec commands) used
# throughout the Innovus flow.

descriptions.innovus-flowsetup = "Run the Innovus Foundation Flow"

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

# None

#-------------------------------------------------------------------------
# Innovus general setup
#-------------------------------------------------------------------------
# Set up common variables used across all Innovus steps

# Innovus directories will be shared across all Innovus steps

export innovus_plugins_dir  = $(plugins_dir)/innovus
export innovus_logs_dir     = $(logs_dir)/innovus
export innovus_reports_dir  = $(reports_dir)/innovus
export innovus_results_dir  = $(results_dir)/innovus
export innovus_handoffs_dir = $(handoff_dir)/innovus

# INNOVUS GUI
#
# The Innovus gui is disabled by default if the environment variable
# INNOVUS_GUI is not defined. Export INNOVUS_GUI to enable the Innovus GUI
# during Innovus runs.
#
#     % export INNOVUS_GUI=1
#     % make init
#     (... gui pops up ...)
#

ifndef INNOVUS_GUI
innovus_gui_options = -nowin
endif

# Innovus execute command

innovus_exec     = innovus -overwrite -64 $(innovus_gui_options)

# Innovus execute command with gui enabled

innovus_exec_gui = innovus -overwrite -64

#-------------------------------------------------------------------------
# Innovus foundation flow setup
#-------------------------------------------------------------------------

# The setup tcl needs to know where the script root is

export innovus_ff_script_root = \
	$(flow_dir.innovus-flowsetup)/SCRIPTS

# The setup tcl needs to know where the collected results from dc are

export innovus_ff_collect_dir = $(collect_dir.innovus-flowsetup)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

# Innovus options for gen_flow.tcl
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
# The "all" indicates that all of the steps should be generated.

define commands.innovus-flowsetup
	mkdir -p $(logs_dir.innovus-flowsetup)
	mkdir -p $(results_dir.innovus-flowsetup)
# Generate the foundation flow
	innovus -64 -no_gui -no_logv -batch \
    -execute "writeFlowTemplate -directory $(results_dir.innovus-flowsetup)"
	rm -f innovus.log innovus.cmd
# Run the foundation flow gen_flow.tcl
	$(results_dir.innovus-flowsetup)/SCRIPTS/gen_flow.tcl \
    -m flat --Verbose --nomake                                          \
    --setup $(flow_dir.innovus-flowsetup)                               \
    --dir $(results_dir.innovus-flowsetup)                              \
    all | tee $(logs_dir.innovus-flowsetup)/flowsetup.log
# Remove Innovus vpath cmds from scripts, which conflicts with our flow
	sed -i "s/.*VPATH.*touch.*/#\0/" \
    $(results_dir.innovus-flowsetup)/INNOVUS/run*.tcl
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-flowsetup)
	(cd $(handoff_dir.innovus-flowsetup) && \
    ln -sf ../../$(results_dir.innovus-flowsetup)/* .)
# Make common Innovus build directories
	mkdir -p $(innovus_logs_dir)
	mkdir -p $(innovus_reports_dir)
	mkdir -p $(innovus_results_dir)
	mkdir -p $(innovus_handoffs_dir)
# For easy access, put the innovus flow scripts at the top level
	rm -f s.flow-innovus
	ln -sf $(handoff_dir.innovus-flowsetup)/INNOVUS s.flow-innovus
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-flowsetup:
	rm -rf ./$(VPATH)/innovus-flowsetup
	rm -rf ./$(logs_dir.innovus-flowsetup)
	rm -rf ./$(reports_dir.innovus-flowsetup)
	rm -rf ./$(results_dir.innovus-flowsetup)
	rm -rf ./$(collect_dir.innovus-flowsetup)
	rm -rf ./$(handoff_dir.innovus-flowsetup)
	rm -rf ./$(innovus_logs_dir)
	rm -rf ./$(innovus_reports_dir)
	rm -rf ./$(innovus_results_dir)
	rm -rf ./$(innovus_handoffs_dir)
	rm -f s.flow-innovus

clean-flowsetup: clean-innovus-flowsetup


