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

# Find repo root

set SCRIPT_PATH = $0
set REPO_ROOT = `dirname "$SCRIPT_PATH"`
set REPO_ROOT = `cd "$REPO_ROOT" && pwd`

# Toolchain install location: sibling to repo folder
set TOOLCHAIN_ROOT = `dirname "$REPO_ROOT"`/riscv

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
setenv STRATUS_RTL $REPO_ROOT/hl5-master/hls/rtl
setenv PATH $TOOLCHAIN_ROOT/bin:$PATH

echo ""
echo "[3/4] Checking RISC-V compiler..."
which riscv32-unknown-elf-gcc
if ( $status != 0 ) then
    echo "ERROR: riscv32-unknown-elf-gcc not found."
    echo "Run the one-time toolchain install first:"
    exit 1
endif

echo ""
echo "[4/4] Changing to HLS directory..."
cd $REPO_ROOT/hl5-master/hls

echo ""
echo "Setup complete."
echo "Current directory: `pwd`"
echo "=================================================="
