# Generated using: Flowkit 25.12-e010_1
################################################################################
# This file contains 'create_flow_step' content for steps which are required
# in an implementation flow, but whose contents are specific.  Review  all
# <PLACEHOLDER> content and replace with commands and options more appropriate
# for the design being implemented. Any new flowstep definitions should be done
# using the 'flow_config.tcl' file.
################################################################################

###############################################################################
# Setup Paths
###############################################################################
if {! [is_attribute libs_dir -obj_type root]} {
    define_attribute libs_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute lib_dir -obj_type root]} {
    define_attribute lib_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute data_dir -obj_type root]} {
    define_attribute data_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute lef_dir -obj_type root]} {
    define_attribute lef_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute qrc_dir -obj_type root]} {
    define_attribute qrc_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute scripts_dir -obj_type root]} {
    define_attribute scripts_dir -obj_type root -data_type string -category flow
}
if {! [is_attribute project_dir -obj_type root]} {
    define_attribute project_dir -obj_type root -data_type string -category flow
}
if { [is_attribute -obj_type root flow_source_directory] } {
  set_db project_dir [file dirname [file normalize [get_db flow_source_directory]]]
} else {
  set_db project_dir [file dirname [file normalize [get_db init_flow_directory]]]
}
set_db scripts_dir [get_db project_dir]/scripts
set_db data_dir $env(STRATUS_RTL)

set_db libs_dir $env(STRATUS_HLS_INSTALL)/share/stratus/techlibs/GPDK045/gsclib045_svt_v4.4/gsclib045
set_db lib_dir [get_db libs_dir]/timing
set_db lef_dir [get_db libs_dir]/lef
set_db qrc_dir [get_db libs_dir]/qrc

##############################################################################
# STEP set_dont_use
##############################################################################
create_flow_step -name set_dont_use -owner design {
  #- disable base_cell usage during optimization
  <%? {dont_use_cells} return "foreach base_cell_name [list [get_flow_config dont_use_cells]] {set_db \[get_db base_cells \$base_cell_name\] .dont_use true}" %>
}

##############################################################################
# STEP read_hdl
##############################################################################
create_flow_step -name read_hdl -owner design {
  set_db init_hdl_search_path [get_db data_dir]
  set vlog_files { \
     execute_rtl.v \
     fedec_rtl.v \
     memwb_rtl.v \
     hl5_rtl.v}

  #- read and elaborate design
  read_hdl $vlog_files -language v2001
  elaborate [get_flow_config design_name]
}

##############################################################################
# STEP init_floorplan
##############################################################################
create_flow_step -name init_floorplan -owner design {
  #- initialize floorplan object using DEF and/or floorplan files
  <%? {init_floorplan_file} return "read_floorplan [lmap f [get_flow_config init_floorplan_file] {file join [get_db init_flow_directory] $f}]" %>
  <%? {init_def_files} return "foreach def_file [list [lmap f [get_flow_config init_def_files] {file join [get_db init_flow_directory] $f}]] { read_def \$def_file }" %>
} -check {
  foreach file [lmap f [get_flow_config -quiet init_floorplan_file] {file join [get_db init_flow_directory] $f}] {
    check "[file exists $file] && [file readable $file]" "The floorplan file: '$file' was not found or is not readable."
  }
  foreach file [lmap f [get_flow_config -quiet init_def_files] {file join [get_db init_flow_directory] $f}] {
    check "[file exists $file] && [file readable $file]" "The def file: '$file' was not found or is not readable."
  }
}

##############################################################################
# STEP add_clock_route_types
##############################################################################
create_flow_step -name add_clock_route_types -owner design {
  #- define route_types and/or route_rules
  #create_route_type -name cts_top   < PLACEHOLDER: CLOCK TOP ROUTE RULE >
  #create_route_type -name cts_trunk < PLACEHOLDER: CLOCK TRUNK ROUTE RULE >
  #create_route_type -name cts_leaf  < PLACEHOLDER: CLOCK LEAF ROUTE RULE >
  
  #set_db cts_route_type_top  cts_top
  #set_db cts_route_type_trunk cts_trunk
  #set_db cts_route_type_leaf  cts_leaf
##### ADDED FOR CTS #############################
  catch "unset name width spacing"
  catch "unset array width spacing"

  foreach layerPtr [get_db layers -if {.type == "routing"}] {
    set name              [get_db $layerPtr .name]
    set width($name)      [get_db $layerPtr .min_width]
    set spacing($name)    [get_db $layerPtr .min_spacing]
  }

  ### Build a 2x width / 2x spacing NDR rule.
  set widthList ""
  foreach name [array names width] {
    lappend widthList $name [expr 2 * $width($name)]
  }

  set spaceList ""
  foreach name [array names spacing] {
    lappend spaceList $name [expr 2 * $spacing($name)]
  }

  if {![llength [get_db route_rules NDR_2W2S]]} {
    create_route_rule -name NDR_2W2S -width "$widthList" -spacing "$spaceList"
  }

    create_route_type -name NDR_2W2S_noshield \
          -route_rule NDR_2W2S \
          -top_preferred_layer Metal7 \
          -bottom_preferred_layer Metal6 

  create_route_type -name NDR_2W2S_shield \
          -route_rule NDR_2W2S \
          -top_preferred_layer Metal9 \
          -bottom_preferred_layer Metal8 \
	  -shield_net VSS

  set_db cts_route_type_leaf            NDR_2W2S_noshield 
  set_db cts_route_type_trunk           NDR_2W2S_shield
  set_db cts_route_type_top             NDR_2W2S_shield

}
