hcell=""
if [ ! -z "$lvs_hcells_file" ]; then
  hcell="-hcell $lvs_hcells_file";
fi
black_box=""
if [ -e inputs/rules.svrf ]; then
  while read line; do
    if [[ $line == *"LVS BOX"* ]]; then
      arr=($(echo $line | xargs))
      black_box="${black_box}lvs_black_box \"${arr[-1]}\" -source_layout;\n"
    fi
  done < inputs/rules.svrf
fi
export black_box=$(echo -e $black_box)
virtual_connect=""
if [ ! -z "$lvs_connect_names" ]; then
  names=$(echo $lvs_connect_names | cut -d'"' -f 2)
  virtual_connect="virtual_connect -name"
  for name in $names; do
    virtual_connect="$virtual_connect \"$name\""
  done
  virtual_connect="$virtual_connect;"
fi
export virtual_connect
schematic_paths=""
for spi in inputs/*.spi inputs/*.sp; do
  if [ -e "$spi" ]; then
    schematic_paths="${schematic_paths}schematic_path \"$spi\" spice;\n"
  fi
done
for cdl in inputs/adk/*.cdl; do
  if [ -e "$cdl" ]; then
    schematic_paths="${schematic_paths}schematic_path \"$cdl\" cdl;\n"
  fi
done
export schematic_paths=$(echo -e $schematic_paths)
envsubst < lvs.runset.template > lvs.runset
pegasus -lvs \
  -top_cell ${design_name} \
  -source_top_cell ${design_name} \
  -spice lvs.extracted.sp \
  -control lvs.runset \
  ${hcell} \
  -ui_data -gdb_data \
  -dp ${nthreads} \
  inputs/adk/pegasus-lvs.rul

