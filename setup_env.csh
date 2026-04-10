#!/bin/tcsh

# Source this script:
#   source setup_env.csh

echo "=================================================="
echo "Initializing EE292A HL5 environment"
echo "=================================================="

if ( ! $?tcsh ) then
    echo "ERROR: This script must be sourced from tcsh."
    echo "Run:"
    echo "  tcsh"
    echo "  source setup_env.csh"
    exit 1
endif

# EE292A-Labs root directory
set REPO_ROOT = $cwd

# Expected subdirectories
set HL5_ROOT = $REPO_ROOT/hl5-master
set TOOLCHAIN_ROOT = $REPO_ROOT/riscv

echo ""
echo "[1/4] Loading Cadence modules..."
module purge
module load stratus/latest
module load xcelium/latest
module load genus/latest
module load innovus/latest

if ( $status != 0 ) then
    echo "ERROR: Failed to load Cadence modules."
    exit 1
endif

echo ""
echo "[2/4] Setting environment variables..."
setenv STRATUS_HLS_INSTALL $VRST_HOME
setenv STRATUS_RTL $HL5_ROOT/hls
setenv PATH $TOOLCHAIN_ROOT/bin:$PATH
rehash

echo ""
echo "[3/4] Checking required directories..."
if ( ! -d $HL5_ROOT ) then
    echo "ERROR: Could not find $HL5_ROOT"
    exit 1
endif

if ( ! -d $TOOLCHAIN_ROOT ) then
    echo "ERROR: Could not find $TOOLCHAIN_ROOT"
    echo "Make sure the RISC-V toolchain was installed into EE292A-Labs/riscv"
    exit 1
endif

echo ""
echo "[4/4] Checking RISC-V compiler..."
which riscv32-unknown-elf-gcc
if ( $status != 0 ) then
    echo "ERROR: riscv32-unknown-elf-gcc not found in PATH."
    echo "Expected location: $TOOLCHAIN_ROOT/bin"
    exit 1
endif

echo ""
echo "Setup complete."
echo "EE292A root:      $REPO_ROOT"
echo "HL5 root:         $HL5_ROOT"
echo "Toolchain root:   $TOOLCHAIN_ROOT"
echo "STRATUS_HLS_INSTALL = $STRATUS_HLS_INSTALL"
echo "STRATUS_RTL         = $STRATUS_RTL"
echo "RISC-V GCC: `which riscv32-unknown-elf-gcc`"
echo "=================================================="
