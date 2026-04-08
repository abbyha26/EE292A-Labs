# ============================================================
# Innovus place-and-route script for HL5
# ============================================================

source design_knobs.tcl

set init_lef_file {
  /home/classes/ee/272/mflowgen/adks/freepdk-45nm/view-standard/rtk-tech.lef
  /home/classes/ee/272/mflowgen/adks/freepdk-45nm/view-standard/stdcells.lef
}

set init_verilog   hl5_mapped.v
set init_top_cell  hl5
set init_mmmc_file mmmc.tcl

init_design

# Floorplan
floorPlan -r $CORE_ASPECT_RATIO $CORE_DENSITY \
    $CORE_MARGIN_L $CORE_MARGIN_B $CORE_MARGIN_R $CORE_MARGIN_T

# Placement
place_design

# Optional CTS
if {$RUN_CTS} {
    ccopt_design
}

# Routing optimization
routeDesign

# Reports
report_area   > innovus_area.rpt
report_timing > innovus_timing.rpt
report_power  > innovus_power.rpt

saveDesign final_design.enc
