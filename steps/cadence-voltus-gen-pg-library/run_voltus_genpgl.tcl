# Reads in a macro and generates a PG libary

set myQrcTechFile inputs/adk/pdk-typical-qrcTechFile

set myGdsLayerMap inputs/adk/pdk-qrc-gds.layermap

set myLefLayerMap inputs/adk/pdk-lefdef.layermap

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
  -lef_layermap $myLefLayerMap \
  -gds_files inputs/design-merged.gds \
  -spice_models run_voltus_genpgl_models.scs \
  -spice_subckts "design.cdl [glob -nocomplain inputs/*.cdl] [glob -nocomplain inputs/*.sp] [glob -nocomplain inputs/*.spi] [glob inputs/adk/stdcells*.cdl]" \
  -stop@via V1 \
  -power_pins { VDD 0.800} \
  -ground_pins {VSS GND} \
  -enable_distributed_processing true
  
  #-lef_layermap $myLefLayerMap \

set_advanced_pg_library_mode \
  -enable_subconductor_layers true \
  -verbosity true

generate_pg_library \
  -output PGV

exit

