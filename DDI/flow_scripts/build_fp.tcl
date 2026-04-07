# Size Floorplan
create_floorplan -site CoreSite -core_density_size 0.60 0.60 25.0 25.0 25.0 25.0

# Global Connects
delete_global_net_connections 
connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name {}
connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name {}
connect_global_net VDD -type tie_hi
connect_global_net VSS -type tie_lo

# Add PG Grid
route_pg -psdl [get_db scripts_dir]/flash.psdl

update_power_vias -skip_via_on_pin standardcell -skip_via_on_wire_shape {ring blockring corewire blockwire iowire padring fillwire noshape} -bottom_layer Metal1 -add_vias 1 -top_layer Metal8

# Add partiton pins
assign_io_pins -improve_si -auto_bus_group
