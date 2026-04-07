#
# BDW Project File
#

################################################################################
# Technology Library
################################################################################
# Root path of the library
set LIB_PATH "[get_install_path]/share/stratus/techlibs/GPDK045/gsclib045_svt_v4.4/gsclib045"
# Standard cell information for the timing corner
set LIB_TLIB  "$LIB_PATH/timing/slow_vdd1v2_basicCells.lib"
# Standard cell information for the power corner
set LIB_PLIB  "$LIB_PATH/timing/fast_vdd1v2_basicCells.lib"
# Layout information for the wiring
set LIB_TLEF  "$LIB_PATH/lef/gsclib045_tech.lef"
# Layout information for the standard cells
set LIB_SLEF  "$LIB_PATH/lef/gsclib045_macro.lef"
# Combine lefs into one list
set LIB_LEFS "$LIB_TLEF $LIB_SLEF"
# Verilog simulation models of the standard cells
set LIB_VLOG "$LIB_PATH/verilog/slow_vdd1v2_basicCells.v"
# QRC tech file with information for parasitic extraction
set LIB_QRC "$LIB_PATH/qrc/qrcTechFile"
# the standard library definition takes the .lib file for the timing corner and the verilog models
use_tech_lib $LIB_TLIB -verilog_files $LIB_VLOG



# Project paths
set INCLUDES "-I./memlib -I../src/ -I../tb/"

#
# Set the memory library
#
use_hls_lib "./memlib"

#set CLOCK_PERIOD 20
set clockPeriod      20
set clockUnits       sc_core::SC_NS ;# must match the units in the technology library
set resetActiveLevel 0

# Set the include paths and defines used by both g++ and stratus_hls

set     incDefs {}
lappend incDefs -I./memlib
lappend incDefs -I../src/
lappend incDefs -I../tb/
#lappend incDefs -I$aeware
lappend incDefs -DRESET_ACTIVE_LEVEL=$resetActiveLevel

# Set the compilation options that only apply to g++

set     ccOpts {}
lappend ccOpts -DCLOCK_PERIOD=$clockPeriod
lappend ccOpts -DCLOCK_UNITS=$clockUnits
lappend ccOpts -DSC_INCLUDE_FX
lappend ccOpts -DUSE_ESC
lappend ccOpts -O2
lappend ccOpts -g
lappend ccOpts -Wall
set     ccOpts [concat $ccOpts $incDefs]

set_attr cc_options                     [join $ccOpts]
set_attr hls_cc_options                 [join $incDefs]
set_attr clock_period                   $clockPeriod
set_attr cycle_slack                    [expr $clockPeriod*0.10]

#set_attr cc_options " $INCLUDES -DCLOCK_PERIOD=$CLOCK_PERIOD -g"
#set_attr hls_cc_options " $INCLUDES -DCLOCK_PERIOD=$CLOCK_PERIOD"

set_attr clock_period			$clockPeriod
set_attr default_input_delay		[expr $clockPeriod*0.25]
set_attr cycle_slack			[expr $clockPeriod*0.10] ;# 10% margin in scheduling clock
set_attr path_delay_limit			111
#set_attr launch_command "./launch_script.sh"
#
# Tech-agnostic global synthesis attributes.
#
set_attr message_detail             3
set_attr default_protocol           false
set_attr inline_partial_constants   true
set_attr output_style_reset_all     true
set_attr lsb_trimming               true
set_attr power						on
set_attr rtl_annotation				all
set_attr dpopt_auto					op
set_attr undef_func                 error
set_attr ignore_scan_cells          on
set_attr balance_expr				delay


## miscellaneous
set_attr output_style_reset_all on
set_attr prints off

## Simulation Options
set_attr end_of_sim_command "make saySimPassed"
#set_systemc_options -version 2.3 -gcc 4.1
use_systemc_simulator xcelium
use_verilog_simulator xcelium
enable_waveform_logging -shm


#
# Testbench or System Level Modules
# systemModule
define_system_module main ../tb/sc_main.cpp
define_system_module system ../tb/system.cpp
define_system_module tb ../tb/tb.cpp

#
# SC_MODULEs to be synthesized
#

define_hls_module fedec     ../src/fedec.cpp
define_hls_module execute   ../src/execute.cpp
define_hls_module memwb     ../src/memwb.cpp
define_hls_module hl5    ../src/hl5.cpp
define_io_config * PIN ;# define a PIN configuration for every module
#
# External arrays
#
define_external_array_access -to system -from hl5.fedec -from hl5.memwb

##########
## List of executable examples
##########
#set exe_list [list aes256_10 aes256_1 aes256 basic dhrystone_100 div_10 div_21 fft_1 fft hist_64 matrix_mult mmult_10 mmult_21 pointer_write test]
#set exe_list [list aes256_10 aes256_1 aes256 basic dhrystone_100 div_10 div_21 fft_1 fft hist_64 matrix_mult mmult_10 mmult_21 pointer_write test]
set exe_list [list div_10 aes256_10 aes256 basic mmult_10]

##########
## Programatic control of configurations
##########
set CONFIGS {
        BASIC		    "--dpopt_auto=off"
        BASIC_POFF           "--dpopt_auto=off --power_clock_gating=off"
        DPA		    "--dpopt_auto=op"
        PIPE_SOFT1           "--dpopt_auto=op -DPIPE_SOFT_STALL1=1"
        PIPE_SOFT2           "--dpopt_auto=op -DPIPE_SOFT_STALL2=1"
        PIPE_SOFT3           "--dpopt_auto=op -DPIPE_SOFT_STALL3=1"
        RADIX_2        "--dpopt_auto=op -DDIV_RADIX_2"
        RADIX_4             "--dpopt_auto=op -DDIV_RADIX_4"
}

foreach {cfgName cfgArgs} $CONFIGS {
        define_hls_config hl5       $cfgName $cfgArgs
        define_hls_config fedec     $cfgName $cfgArgs
        define_hls_config execute   $cfgName $cfgArgs
        define_hls_config memwb     $cfgName $cfgArgs

        ######################################################################
        # Genus Logic Synthesis Configurations
        ######################################################################
        define_logic_synthesis_config G_${cfgName} \
                        "hl5 ${cfgName}" "fedec ${cfgName}" "execute ${cfgName}" "memwb ${cfgName}" \
                -command bdw_rungenus \
                -options \
                {interconnect_mode ple} [list lef_library $LIB_LEFS] [list qrc_tech_file $LIB_QRC]

        foreach exename $exe_list {

                set DEFAULT_ARGV "../soft/$exename\.txt BEH report.txt"
                set ARGV_LIST "../soft/$exename\.txt $cfgName report.txt"

                # define simulation configurations
                define_sim_config "${cfgName}_${exename}\_B" \
                                        "hl5 BEH" "fedec BEH" "execute BEH" "memwb BEH" \
                                        -argv $DEFAULT_ARGV -io_config PIN

                define_sim_config "${cfgName}_${exename}\_V" \
                                        "hl5 RTL_V $cfgName" "fedec RTL_V $cfgName" \
                                        "execute RTL_V $cfgName" "memwb RTL_V $cfgName" \
                                        -argv $ARGV_LIST -io_config PIN
                define_sim_config "${cfgName}_${exename}\_GP" \
                                        "hl5 GATES_V $cfgName" "fedec GATES_V $cfgName" \
                                        "execute GATES_V $cfgName" "memwb GATES_V $cfgName" \
                                        -argv $ARGV_LIST -io_config PIN -verilog_input_delay 0.5
        }

}
set MIXED_CFG PIPE_SOFT_MIXED

define_logic_synthesis_config G_${MIXED_CFG} \
    "hl5 PIPE_SOFT1" \
    "fedec PIPE_SOFT1" \
    "execute PIPE_SOFT1" \
    "memwb PIPE_SOFT3" \
    -command bdw_rungenus \
    -options \
    {interconnect_mode ple} \
    [list lef_library $LIB_LEFS] \
    [list qrc_tech_file $LIB_QRC]

foreach exename $exe_list {

    set DEFAULT_ARGV "../soft/$exename.txt BEH report.txt"
    set MIXED_ARGV  "../soft/$exename.txt $MIXED_CFG report.txt"

    define_sim_config "${MIXED_CFG}_${exename}_B" \
        "hl5 BEH" "fedec BEH" "execute BEH" "memwb BEH" \
        -argv $DEFAULT_ARGV -io_config PIN

    define_sim_config "${MIXED_CFG}_${exename}_V" \
        "hl5 RTL_V PIPE_SOFT1" \
        "fedec RTL_V PIPE_SOFT1" \
        "execute RTL_V PIPE_SOFT1" \
        "memwb RTL_V PIPE_SOFT3" \
        -argv $MIXED_ARGV -io_config PIN

    define_sim_config "${MIXED_CFG}_${exename}_GP" \
        "hl5 GATES_V PIPE_SOFT1" \
        "fedec GATES_V PIPE_SOFT1" \
        "execute GATES_V PIPE_SOFT1" \
        "memwb GATES_V PIPE_SOFT3" \
        -argv $MIXED_ARGV -io_config PIN \
        -verilog_input_delay 0.5
}


# Added by make_auto_project tool
use_auto_project
