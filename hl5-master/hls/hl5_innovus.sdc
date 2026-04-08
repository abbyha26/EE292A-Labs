source design_knobs.tcl
create_clock -name $CLK_PORT -period $CLK_PERIOD [get_ports $CLK_PORT]
