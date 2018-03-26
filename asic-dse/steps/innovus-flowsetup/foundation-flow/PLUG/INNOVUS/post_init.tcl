####################################################################################
#                             POST-INIT PLUG-IN
####################################################################################
#
# This plug-in script is called after design import from the run_init.tcl script.
#
# --------------------------------------------------------------------------------
# Can be used for various floorplan related tasks, like:
#              - Die/core boundary
#              - placement of hard macros/blocks
#              - power domain size and clearence surrounding to it
#              - Placement and routing blockages in the floorplan
#              - IO ring creation
#              - PSO planning
# --------------------------------------------------------------------------------
# Specifically, this example includes tasks related to the LP/CPF foundation flow 
# including power domain modification and power shut-off planning. The examples 
# included here operate based on variables (vars array) defined in the 
# OVERLAY/lp_config.tcl file
#
if {[info exists vars(cpf_file)]} {

# --------------------------------------------------------------------------------
# Modify power domains
# --------------------------------------------------------------------------------
# The 'modify_power_domains' procedure is included with the foundation flows
# to help automate power domain modification.  To enable this, please set the
# appropriate variables in the lp_config.tcl and uncomment the following command
#

#	ff_modify_power_domains
    
# --------------------------------------------------------------------------------
# Power switch insertion
# --------------------------------------------------------------------------------
# The 'add_power_switches' procedure is included with the foundation flows
# to cover common power switch insertion scenarios.  To use, set the appropriate
# variables in the lp_config.tcl file and uncomment the following command.
# --------------------------------------------------------------------------------
# NOTE: This procedure  will NOT COVER THE ALL THE OPTIONS in addPowerSwitch
# For more complicated scenarios, please manually add the addPowerSwitch command
# here with the necessary options.
# --------------------------------------------------------------------------------

#	ff_add_power_switches

}
