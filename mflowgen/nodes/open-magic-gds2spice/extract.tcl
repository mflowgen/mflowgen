drc off
cif istyle sky130(vendor)
gds flatten true
gds read ./inputs/design-merged.gds
load $::env(design_name) -dereference
select top cell
extract no all
extract do local
extract unique
extract
ext2spice lvs
ext2spice $::env(design_name).ext
feedback save $::env(design_name).log
exit