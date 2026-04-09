create_library_set -name typical_lib \
  -timing [list /home/classes/ee/272/mflowgen/adks/freepdk-45nm/view-standard/stdcells.lib]

create_constraint_mode -name default_constraint \
  -sdc_files [list hl5_innovus.sdc]

create_delay_corner -name default_delay \
  -library_set typical_lib

create_analysis_view -name default_view \
  -constraint_mode default_constraint \
  -delay_corner default_delay

set_analysis_view -setup [list default_view] -hold [list default_view]
