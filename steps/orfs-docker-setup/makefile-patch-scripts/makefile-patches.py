import os
import utils as util

# Base path
tcl_scripts_base_path       = '../flow/scripts/'

synth_metrics_tcl           = os.path.join(tcl_scripts_base_path, 'synth_metrics.tcl')
synth_tcl                   = os.path.join(tcl_scripts_base_path, 'synth.tcl')
floorplan_tcl               = os.path.join(tcl_scripts_base_path, 'floorplan.tcl')
tdms_place_tcl              = os.path.join(tcl_scripts_base_path, 'tdms_place.tcl')
macro_place_tcl             = os.path.join(tcl_scripts_base_path, 'macro_place.tcl')
tapcell_tcl                 = os.path.join(tcl_scripts_base_path, 'tapcell.tcl')
pdn_tcl                     = os.path.join(tcl_scripts_base_path, 'pdn.tcl')
global_place_skip_io_tcl    = os.path.join(tcl_scripts_base_path, 'global_place_skip_io.tcl')
io_placement_tcl            = os.path.join(tcl_scripts_base_path, 'io_placement.tcl')
io_placement_random_tcl     = os.path.join(tcl_scripts_base_path, 'io_placement_random.tcl')
global_place_tcl            = os.path.join(tcl_scripts_base_path, 'global_place.tcl')
resize_tcl                  = os.path.join(tcl_scripts_base_path, 'resize.tcl')
detail_place_tcl            = os.path.join(tcl_scripts_base_path, 'detail_place.tcl')
cts_tcl                     = os.path.join(tcl_scripts_base_path, 'cts.tcl')
global_route_tcl            = os.path.join(tcl_scripts_base_path, 'global_route.tcl')
fillcell_tcl                = os.path.join(tcl_scripts_base_path, 'fillcell.tcl')
detail_route_tcl            = os.path.join(tcl_scripts_base_path, 'detail_route.tcl')
density_fill_tcl            = os.path.join(tcl_scripts_base_path, 'density_fill.tcl')

makefile_base_path          = '../flow/'
makefile_path               = os.path.join(makefile_base_path, 'Makefile')
power_makefile_path         = './power-makefile.txt'

def makefile_synth():
    util.replace_line_in_file(makefile_path,
        'synth: $(RESULTS_DIR)/1_synth.v \\',
        'synth: $(RESULTS_DIR)/synth-output.v \\'
    )

    util.replace_line_in_file(makefile_path,
        '       $(RESULTS_DIR)/1_synth.sdc',
        '       $(RESULTS_DIR)/synth-output.sdc'
    )

    util.replace_line_in_file(makefile_path,
        '	cp $(RESULTS_DIR)/1_1_yosys.v $(RESULTS_DIR)/1_synth.v',
        '	cp $(RESULTS_DIR)/1_1_yosys.v $(RESULTS_DIR)/synth-output.v'
    )

    util.replace_line_in_file(makefile_path,
        '$(RESULTS_DIR)/1_synth.v: $(RESULTS_DIR)/1_1_yosys.v',
        '$(RESULTS_DIR)/synth-output.v: $(RESULTS_DIR)/1_1_yosys.v'
    )

    util.replace_line_in_file(makefile_path,
        '$(RESULTS_DIR)/1_synth.sdc: $(SDC_FILE)',
        '$(RESULTS_DIR)/synth-output.sdc: $(SDC_FILE)'
    )

    util.replace_line_in_file(makefile_path,
        '	cp $(SDC_FILE) $(RESULTS_DIR)/1_synth.sdc',
        '	cp $(SDC_FILE) $(RESULTS_DIR)/synth-output.sdc'
    )

def tcl_synth():
    util.replace_line_in_file(synth_metrics_tcl,
        'load_design 1_1_yosys.v 1_synth.sdc',
        'load_design 1_1_yosys.v synth-output.sdc'
    )
    
def makefile_floorplan():
    util.replace_line_in_file(makefile_path,
        'floorplan: $(RESULTS_DIR)/2_floorplan.odb \\',
        'floorplan: $(RESULTS_DIR)/floorplan-output.odb \\'
    )

    util.replace_line_in_file(makefile_path,
        '           $(RESULTS_DIR)/2_floorplan.sdc',
        '           $(RESULTS_DIR)/floorplan-output.sdc'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,2_1_floorplan,$(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) $(FOOTPRINT) $(SIG_MAP_FILE) $(FOOTPRINT_TCL),floorplan))',
        '$(eval $(call do-step,2_1_floorplan,$(RESULTS_DIR)/floorplan-input.v $(RESULTS_DIR)/floorplan-input.sdc $(TECH_LEF) $(SC_LEF) $(ADDITIONAL_LEFS) $(FOOTPRINT) $(SIG_MAP_FILE) $(FOOTPRINT_TCL),floorplan))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,2_3_floorplan_tdms,$(RESULTS_DIR)/2_2_floorplan_io.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES),tdms_place))',
        '$(eval $(call do-step,2_3_floorplan_tdms,$(RESULTS_DIR)/2_2_floorplan_io.odb $(RESULTS_DIR)/floorplan-input.v $(RESULTS_DIR)/floorplan-input.sdc $(LIB_FILES),tdms_place))'
    )
    
    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,2_3_floorplan_tdms,2_2_floorplan_io.odb,$(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(LIB_FILES)))',
        '$(eval $(call do-copy,2_3_floorplan_tdms,2_2_floorplan_io.odb,$(RESULTS_DIR)/floorplan-input.v $(RESULTS_DIR)/floorplan-input.sdc $(LIB_FILES)))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,2_4_floorplan_macro,$(RESULTS_DIR)/2_3_floorplan_tdms.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_synth.sdc $(MACRO_PLACEMENT) $(MACRO_PLACEMENT_TCL),macro_place))',
        '$(eval $(call do-step,2_4_floorplan_macro,$(RESULTS_DIR)/2_3_floorplan_tdms.odb $(RESULTS_DIR)/floorplan-input.v $(RESULTS_DIR)/floorplan-input.sdc $(MACRO_PLACEMENT) $(MACRO_PLACEMENT_TCL),macro_place))'
    )

    # Comment out the call that performs the PDN under the floorplan target
    util.comment_out_line(makefile_path, 
        '$(eval $(call do-step,2_6_floorplan_pdn,$(RESULTS_DIR)/2_5_floorplan_tapcell.odb $(PDN_TCL),pdn))'
    )

    # Generate '2_floorplan.odb' from '2_5_floorplan_tapcell.odb' instead of '2_6_floorplan_pdn.odb'
    util.comment_out_and_add_line(makefile_path,
        '$(eval $(call do-copy,2_floorplan,2_6_floorplan_pdn.odb,))',
        '$(eval $(call do-copy,floorplan-output,2_5_floorplan_tapcell.odb,))'  
    )

    # Remove the 'do-2_6_floorplan_pdn' from the 'do-floorplan' target    
    util.delete_word_in_a_line(makefile_path,
        '   $(UNSET_AND_MAKE) do-2_1_floorplan do-2_2_floorplan_io do-2_3_floorplan_tdms do-2_4_floorplan_macro do-2_5_floorplan_tapcell do-2_6_floorplan_pdn do-2_floorplan',
        'do-2_6_floorplan_pdn'
    )

def tcl_floorplan():
    util.replace_line_in_file(io_placement_random_tcl,
        '  load_design 2_1_floorplan.odb 1_synth.sdc',
        '  load_design 2_1_floorplan.odb floorplan-input.sdc'
    )

    util.replace_line_in_file(tdms_place_tcl,
        'load_design 2_2_floorplan_io.odb 1_synth.sdc',
        'load_design 2_2_floorplan_io.odb floorplan-input.sdc'
    )

    util.replace_line_in_file(macro_place_tcl,
        'load_design 2_3_floorplan_tdms.odb 1_synth.sdc',
        'load_design 2_3_floorplan_tdms.odb floorplan-input.sdc'
    )

    util.replace_line_in_file(tapcell_tcl,
        'load_design 2_4_floorplan_macro.odb 1_synth.sdc',
        'load_design 2_4_floorplan_macro.odb floorplan-input.sdc'
    )

    util.replace_line_in_file(floorplan_tcl,
        'load_design 1_synth.v 1_synth.sdc',
        'load_design floorplan-input.v floorplan-input.sdc'
    )
    util.replace_line_in_file(floorplan_tcl,
        'write_sdc -no_timestamp $::env(RESULTS_DIR)/2_floorplan.sdc',
        'write_sdc -no_timestamp $::env(RESULTS_DIR)/floorplan-output.sdc'
    )

def makefile_power():
    # Add the targets 'power', 'do-power', 'clean_power', and the other necessary eval calls
    util.copy_after_target(power_makefile_path, makefile_path, 'clean_floorplan')

def tcl_power():
    ## rename input file names
    util.replace_line_in_file(pdn_tcl,
        'load_design 2_5_floorplan_tapcell.odb 1_synth.sdc',
        'load_design power-input.odb power-input.sdc'
    )
    ## rename output file names
    util.replace_line_in_file(pdn_tcl,
        '  write_def $::env(RESULTS_DIR)/2p5_power.def',
        '  write_def $::env(RESULTS_DIR)/power-output.def'
    )

    util.replace_line_in_file(pdn_tcl,
        'write_db $::env(RESULTS_DIR)/2_6_floorplan_pdn.odb',
        'write_db $::env(RESULTS_DIR)/power-output.odb'
    )

def makefile_place():
    util.replace_line_in_file(makefile_path,
        'place: $(RESULTS_DIR)/3_place.odb \\',
        'place: $(RESULTS_DIR)/place-output.odb \\'  
    )

    util.replace_line_in_file(makefile_path,
        '       $(RESULTS_DIR)/3_place.sdc',
        '       $(RESULTS_DIR)/place-output.sdc'  
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,3_1_place_gp_skip_io,$(RESULTS_DIR)/2_floorplan.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES),global_place_skip_io))',
        '$(eval $(call do-step,3_1_place_gp_skip_io,$(RESULTS_DIR)/place-input.odb $(RESULTS_DIR)/place-input.sdc $(LIB_FILES),global_place_skip_io))'  
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,3_3_place_gp,$(RESULTS_DIR)/3_2_place_iop.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES),global_place))',
        '$(eval $(call do-step,3_3_place_gp,$(RESULTS_DIR)/3_2_place_iop.odb $(RESULTS_DIR)/place-input.sdc $(LIB_FILES),global_place))'  
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,3_4_place_resized,$(RESULTS_DIR)/3_3_place_gp.odb $(RESULTS_DIR)/2_floorplan.sdc,resize))',
        '$(eval $(call do-step,3_4_place_resized,$(RESULTS_DIR)/3_3_place_gp.odb $(RESULTS_DIR)/place-input.sdc,resize))'  
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,3_place,3_5_place_dp.odb,))',
        '$(eval $(call do-copy,place-output,3_5_place_dp.odb,))'  
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,3_place,2_floorplan.sdc,,.sdc))',
        '$(eval $(call do-copy,place-output,place-input.sdc,,.sdc))'  
    )

def tcl_place():
    ## rename input file names
    util.replace_line_in_file(global_place_skip_io_tcl,
        'load_design 2_floorplan.odb 2_floorplan.sdc',
        'load_design place-input.odb place-input.sdc'        
    )
    util.replace_line_in_file(io_placement_tcl,
        '  load_design 3_1_place_gp_skip_io.odb 2_floorplan.sdc',
        '  load_design 3_1_place_gp_skip_io.odb place-input.sdc'        
    )
    util.replace_line_in_file(global_place_tcl,
        'load_design 3_2_place_iop.odb 2_floorplan.sdc',
        'load_design 3_2_place_iop.odb place-input.sdc'        
    )
    util.replace_line_in_file(resize_tcl,
        'load_design 3_3_place_gp.odb 2_floorplan.sdc',
        'load_design 3_3_place_gp.odb place-input.sdc'        
    )
    util.replace_line_in_file(detail_place_tcl,
        'load_design 3_4_place_resized.odb 2_floorplan.sdc',
        'load_design 3_4_place_resized.odb place-input.sdc'        
    )

def makefile_cts():
    util.replace_line_in_file(makefile_path,
        'cts: $(RESULTS_DIR)/4_cts.odb \\',
        'cts: $(RESULTS_DIR)/cts-output.odb \\'
    )

    util.replace_line_in_file(makefile_path,
        '     $(RESULTS_DIR)/4_cts.sdc',
        '     $(RESULTS_DIR)/cts-output.sdc'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,4_1_cts,$(RESULTS_DIR)/3_place.odb $(RESULTS_DIR)/3_place.sdc,cts))',
        '$(eval $(call do-step,4_1_cts,$(RESULTS_DIR)/cts-input.odb $(RESULTS_DIR)/cts-input.sdc,cts))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,4_cts,4_1_cts.odb))',
        '$(eval $(call do-copy,cts-output,4_1_cts.odb))'
    )

    util.replace_line_in_file(makefile_path,
        '$(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.odb',
        '$(RESULTS_DIR)/cts-output.sdc: $(RESULTS_DIR)/cts-output.odb'
    )

def tcl_cts():
    util.replace_line_in_file(cts_tcl,
        'load_design 3_place.odb 3_place.sdc',
        'load_design cts-input.odb cts-input.sdc'
    )

    util.replace_line_in_file(cts_tcl,
        '  write_def $::env(RESULTS_DIR)/4_1_cts.def',
        '  write_def $::env(RESULTS_DIR)/cts-output.def'
    )

    util.replace_line_in_file(cts_tcl,
        'write_sdc -no_timestamp $::env(RESULTS_DIR)/4_cts.sdc',
        'write_sdc -no_timestamp $::env(RESULTS_DIR)/cts-output.sdc'
    )

def makefile_route():
    util.replace_line_in_file(makefile_path,
        'route: $(RESULTS_DIR)/5_route.odb \\',
        'route: $(RESULTS_DIR)/route-output.odb \\'
    )

    util.replace_line_in_file(makefile_path,
        '       $(RESULTS_DIR)/5_route.sdc',
        '       $(RESULTS_DIR)/route-output.sdc'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,5_1_grt,$(RESULTS_DIR)/4_cts.odb $(FASTROUTE_TCL) $(PRE_GLOBAL_ROUTE),global_route))',
        '$(eval $(call do-step,5_1_grt,$(RESULTS_DIR)/route-input.odb $(FASTROUTE_TCL) $(PRE_GLOBAL_ROUTE),global_route))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,5_3_route,$(RESULTS_DIR)/4_cts.odb,detail_route))',
        '$(eval $(call do-step,5_3_route,$(RESULTS_DIR)/route-input.odb,detail_route))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,5_route,5_3_route.odb))',
        '$(eval $(call do-copy,route-output,5_3_route.odb))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,5_route,4_cts.sdc,,.sdc))',
        '$(eval $(call do-copy,route-output,route-input.sdc,,.sdc))'
    )

def tcl_route():
    util.replace_line_in_file(global_route_tcl,
        'load_design 4_cts.odb 4_cts.sdc',
        'load_design route-input.odb route-input.sdc'
    )

    util.replace_line_in_file(fillcell_tcl,
        'load_design 5_1_grt.odb 4_cts.sdc',
        'load_design 5_1_grt.odb route-input.sdc'
    )

    util.replace_line_in_file(detail_route_tcl,
        '  set db_file 4_cts.odb',
        '  set db_file route-input.odb'
    )

    util.replace_line_in_file(detail_route_tcl,
        'load_design $db_file 4_cts.sdc',
        'load_design $db_file cts-input.sdc'
    )

def makefile_finish():
    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-step,6_1_fill,$(RESULTS_DIR)/5_route.odb $(RESULTS_DIR)/5_route.sdc $(FILL_CONFIG),density_fill))',
        '$(eval $(call do-step,6_1_fill,$(RESULTS_DIR)/finish-input.odb $(RESULTS_DIR)/finish-input.sdc $(FILL_CONFIG),density_fill))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,6_1_fill,5_route.odb))',
        '$(eval $(call do-copy,6_1_fill,finish-input.odb))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,6_1_fill,5_route.sdc,,.sdc))',
        '$(eval $(call do-copy,6_1_fill,finish-input.sdc,,.sdc))'
    )

    util.replace_line_in_file(makefile_path,
        '$(eval $(call do-copy,6_final,5_route.sdc,,.sdc))',
        '$(eval $(call do-copy,6_final,finish-input.sdc,,.sdc))'
    )

def tcl_finish():
    util.replace_line_in_file(density_fill_tcl,
        'load_design 5_route.odb 5_route.sdc',
        'load_design finish-input.odb finish-input.sdc'
    )

def makefile_misc():
    util.comment_out_and_add_line(makefile_path,
        'all: synth floorplan place cts route finish',
        'all: synth floorplan power place cts route finish'  
    )

    util.comment_out_and_add_line(makefile_path,
        '	@echo "  clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish"',
        '	@echo "  clean_synth clean_floorplan clean_power clean_place clean_cts clean_route clean_finish"'  
    )
    
    util.comment_out_and_add_line(makefile_path,
        'clean_all: clean_synth clean_floorplan clean_place clean_cts clean_route clean_finish clean_metadata clean_abstract',
        'clean_all: clean_synth clean_floorplan clean_power clean_place clean_cts clean_route clean_finish clean_metadata clean_abstract'  
    )
    
    util.add_line_next_to_specific_line(makefile_path,
        '$(eval $(call OPEN_GUI_SHORTCUT,floorplan,2_floorplan.odb))',
        '$(eval $(call OPEN_GUI_SHORTCUT,power,2p5_power.odb))'
    )

def main():
    makefile_synth()
    tcl_synth()
    makefile_floorplan()
    tcl_floorplan()
    makefile_power()
    tcl_power()
    makefile_place()
    tcl_place()
    makefile_cts()
    tcl_cts()
    makefile_route()
    tcl_route()
    makefile_finish()
    tcl_finish()
    makefile_misc()

if __name__ == '__main__':
    main()