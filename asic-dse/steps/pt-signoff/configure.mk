#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description -- pt-signoff
#-------------------------------------------------------------------------
# This step runs timing and SI signoff using Synopsys PT

descriptions.pt-signoff = "Timing and SI signoff"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.pt-signoff
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# Primetime Timing and SI Signoff'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.pt-signoff = pt

#-------------------------------------------------------------------------
# Interface
#-------------------------------------------------------------------------

# Directories

export pt_flow_dir     = $(flow_dir.pt-signoff)
export pt_plugins_dir  = $(plugins_dir.pt-signoff)
export pt_logs_dir     = $(logs_dir.pt-signoff)
export pt_reports_dir  = $(reports_dir.pt-signoff)
export pt_results_dir  = $(results_dir.pt-signoff)
export pt_collect_dir  = $(collect_dir.pt-signoff)

# Netlist from Innovus (PT can use the vcs.v with no VDD/VSS pins)

export pt_netlist_handoff = $(pt_collect_dir)/$(design_name).vcs.v

# Clock

export pt_clock_period    = $(clock_period)

# Parasitics from Innovus
#
# Note: We may want to use other corners than typical for RC someday..

export pt_typical_spef    = $(pt_collect_dir)/typical.spef.gz

# SDC constraints from Innovus

export pt_sdc_input       = $(pt_collect_dir)/$(design_name).pt.sdc

#-------------------------------------------------------------------------
# Build rules
#-------------------------------------------------------------------------

pt_exec = pt_shell
pt_tcl  = $(flow_dir.pt-signoff)/rm_pt_scripts/pt.tcl

#pt_corners = typical ff_typical
pt_corners = typical

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.pt-signoff

# Build directories

	rm -rf ./$(logs_dir.pt-signoff)
	mkdir -p $(logs_dir.pt-signoff)

# Run the script

	$(foreach corner,$(pt_corners), \
		CORNER_CASE=$(corner) $(pt_exec) -f $(pt_tcl) \
			| tee $(logs_dir.pt-signoff)/pt_$(corner).log;)

#      -output_log_file $(logs_dir.pt-signoff)/pt_$(corner).log;)

# Prepare handoffs

	mkdir -p $(handoff_dir.pt-signoff)
	ln -srf $(results_dir.pt-signoff)/* $(handoff_dir.pt-signoff)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-pt-signoff:
	rm -rf ./$(VPATH)/pt-signoff
	rm -rf ./$(logs_dir.pt-signoff)
	rm -rf ./$(reports_dir.pt-signoff)
	rm -rf ./$(results_dir.pt-signoff)
	rm -rf ./$(collect_dir.pt-signoff)
	rm -rf ./$(handoff_dir.pt-signoff)

clean-pt: clean-pt-signoff

