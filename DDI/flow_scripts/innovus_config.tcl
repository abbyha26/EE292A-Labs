# Generated using: Flowkit 25.12-e010_1
################################################################################
# Innovus attributes
#
#  Attributes used to drive tool behavior.  Most typically these are root level
#  attributes.  All root attributes can be listed by using 'report_obj -all' or
#  by category using 'report_obj -all -verbose'
#
#  Further attribute help can be obtained by using the command 'help <ATTRIBUTE>'
#
#  The init_innovus_user flow_step is provided to specify tool level configs after a
#  design has been loaded via the init_design flow_step or specified as a
#  flow_starting_db from a subsequent flow (ie syn_opt).
#
################################################################################

##############################################################################
# STEP init_innovus_user
##############################################################################
create_flow_step -name init_innovus_user -owner design {
  # Timing attributes  [get_db -category timing && delaycalc]
  #-----------------------------------------------------------------------------
  
  # Extraction attributes  [get_db -category extract_rc]
  #-----------------------------------------------------------------------------
  
  # Floorplan attributes  [get_db -category floorplan]
  #-----------------------------------------------------------------------------
  set_db finish_floorplan_active_objs   [list macro soft_blockage core]
  
  # Placement attributes  [get_db -category place]
  #-----------------------------------------------------------------------------
  
  # Optimization attributes  [get_db -category opt]
  #-----------------------------------------------------------------------------
  set dly_cells  [get_db [get_db base_cells DLY*] .name]
  set buf_cells [get_db [get_db base_cells BUF*] .name]
  set_db opt_hold_cells "$dly_cells $buf_cells"

  # Clock attributes  [get_db -category cts]
  #-----------------------------------------------------------------------------
  set_db cts_use_inverters true

  # Routing attributes  [get_db -category route]
  #-----------------------------------------------------------------------------

}
