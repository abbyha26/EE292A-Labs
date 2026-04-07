#################################################
# Stratus IDE project file generated;
# Stratus IDE project file format version: 2
#################################################
CONFIG   += console
CONFIG   -= app_bundle
CONFIG   -= qt

STRATUSHOME = $$(STRATUS_HOME)
SYSTEMCHOME = $$(STRATUS_HOME)/tools.lnx86/stratus/systemc/2.3.3

TEMPLATE = app
INCLUDEPATH += $${SYSTEMCHOME}/include
INCLUDEPATH += $${SYSTEMCHOME}/include/tlm
INCLUDEPATH += $${STRATUSHOME}/share/stratus/include
INCLUDEPATH += ./bdw_work/wrappers
INCLUDEPATH += ./
INCLUDEPATH += ./memlib/c_parts
INCLUDEPATH += ./memlib
INCLUDEPATH += ../src/
INCLUDEPATH += ../tb/

SOURCES += \ 
		../tb/sc_main.cpp \ 
		../tb/system.cpp \ 
		../tb/tb.cpp \ 
		../src/fedec.cpp \ 
		../src/execute.cpp \ 
		../src/memwb.cpp \ 
		../src/hl5.cpp \ 
		memlib/c_parts/hl5_block_1w1r.cc \ 

HEADERS += \ 
		../tb/system.hpp \ 
		../tb/tb.hpp \ 
		../src/fedec.hpp \ 
		../src/execute.hpp \ 
		../src/memwb.hpp \ 
		../src/hl5.hpp \ 
		memlib/c_parts/hl5_block_1w1r.h \ 

OTHER_FILES += \ 
		Makefile \ 
		project.tcl \ 
		project.db/auto_project.tcl \ 

