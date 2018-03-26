#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

# None

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------
# From the build directory, the scripts in this step are accessible from
# $(steps_dir)/name-of-the-step

export innovus_flowsetup_steps_dir    = $(steps_dir)/innovus-flowsetup

# Directories

export innovus_flowsetup_logs_dir     = $(logs_dir)/innovus-flowsetup
export innovus_flowsetup_handoffs_dir = $(handoffs_dir)/innovus-flowsetup

#-------------------------------------------------------------------------
# Innovus general setup
#-------------------------------------------------------------------------
# Set up common variables used across all Innovus steps

innovus_exec         = innovus -overwrite -64 -nowin
innovus_exec_gui     = innovus -overwrite -64

# Innovus directories will be shared across all Innovus steps

export innovus_plugins_dir  = $(plugins_dir)/innovus
export innovus_logs_dir     = $(logs_dir)/innovus
export innovus_reports_dir  = $(reports_dir)/innovus
export innovus_results_dir  = $(results_dir)/innovus
export innovus_handoffs_dir = $(handoffs_dir)/innovus

#-------------------------------------------------------------------------
# Innovus foundation flow setup
#-------------------------------------------------------------------------

# FIXME: For now, have the plugins setup tcl override the global one, but
# we should later make plugin version just be sourced at the end of the
# global one.

ifneq ("$(wildcard $(innovus_plugins_dir)/setup.tcl)","")
innovus_setup_dir = $(innovus_plugins_dir)
else
innovus_setup_dir = $(innovus_flowsetup_steps_dir)
endif

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
	mkdir -p $(innovus_flowsetup_logs_dir)
	$(innovus_flowsetup_steps_dir)/foundation-flow/SCRIPTS/gen_flow.tcl -m flat --Verbose --dir $(innovus_flowsetup_handoffs_dir) --nomake --setup $(innovus_setup_dir) all | tee $(innovus_flowsetup_logs_dir)/flowsetup.log
# Remove Innovus vpath cmds from scripts, which conflicts with our flow
	sed -i "s/.*VPATH.*touch.*/#\0/" $(innovus_flowsetup_handoffs_dir)/INNOVUS/run*.tcl
# Make build directories
	mkdir -p $(innovus_logs_dir)
	mkdir -p $(innovus_reports_dir)
	mkdir -p $(innovus_results_dir)
	mkdir -p $(innovus_handoffs_dir)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

clean-innovus-flowsetup:
	rm -rf ./$(VPATH)/innovus-flowsetup
	rm -rf ./$(innovus_flowsetup_logs_dir)
	rm -rf ./$(innovus_flowsetup_handoffs_dir)
	rm -rf ./$(innovus_logs_dir)
	rm -rf ./$(innovus_reports_dir)
	rm -rf ./$(innovus_results_dir)
	rm -rf ./$(innovus_handoffs_dir)

clean-flowsetup: clean-innovus-flowsetup


