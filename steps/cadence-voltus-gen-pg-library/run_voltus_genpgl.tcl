# Reads in a macro and generates a PG libary

set myQrcTechFile inputs/adk/pdk-typical-qrcTechFile

set myGdsLayerMap inputs/adk/pdk-qrc-gds.layermap

set_multi_cpu_usage -localCpu 8

# LefDef map is optional
#set myLefLayerMap 12lp_11M_3Mx_4Cx_2Kx_2Gx_LB.lefdef.map

read_lib -lef inputs/adk/rtk-tech.lef [glob inputs/adk/stdcells*.lef] inputs/design.lef

set_pg_library_mode \
  -celltype macros \
  -cell_list_file instances.list \
  -current_distribution propagation \
  -extraction_tech_file $myQrcTechFile \
  -gds_layermap $myGdsLayerMap \
  -gds_files inputs/design-merged.gds \
  -spice_models run_voltus_genpgl_models.scs \
  -spice_subckts "[glob inputs/adk/stdcell*.cdl] [glob -nocomplain inputs/*.cdl] design.cdl" \
  -stop@via V1 \
  -power_pins { VDD 0.800} \
  -ground_pins {VSS GND}
  
  #-lef_layermap $myLefLayerMap \

set_advanced_pg_library_mode \
  -enable_subconductor_layers true \
  -verbosity true

generate_pg_library \
  -output PGV

exit

