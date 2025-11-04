#=========================================================================
# setup-session.tcl
#=========================================================================
# The setup session script configures the Formality session to analyze 
# clock gating and sets other variables.
#
# Author : Kartik Prabhu
# Date   : March 23, 2021

# Multicore support
set_host_options -max_cores $fm_num_cores 

# Specifies that the design has both low and high styles of clock gating
set_app_var verification_clock_gate_hold_mode any

# Reduce the simulation-synthesis mismatch message to a warning
set_mismatch_message_filter -warn
