#!/bin/tcsh

echo "=================================================="
echo "Installing RISC-V toolchain (one-time setup)"
echo "=================================================="

# Default install location
set TOOLCHAIN_ROOT = /home/users/$USER/riscv
set TOOLCHAIN_SRC  = /home/users/$USER/riscv-gnu-toolchain

# Check if already installed
if ( -x $TOOLCHAIN_ROOT/bin/riscv32-unknown-elf-gcc ) then
    echo "RISC-V toolchain already installed at:"
    echo "  $TOOLCHAIN_ROOT"
    echo ""
    echo "Compiler found:"
    echo "  $TOOLCHAIN_ROOT/bin/riscv32-unknown-elf-gcc"
    exit 0
endif

# Clone repo if missing
if ( ! -d $TOOLCHAIN_SRC ) then
    echo ""
    echo "[1/4] Cloning riscv-gnu-toolchain..."
    cd /home/users/$USER
    git clone --recursive https://github.com/riscv/riscv-gnu-toolchain.git
    if ( $status != 0 ) then
        echo "ERROR: git clone failed."
        exit 1
    endif
else
    echo ""
    echo "[1/4] Toolchain source already exists:"
    echo "  $TOOLCHAIN_SRC"
endif

# Create build directory
echo ""
echo "[2/4] Creating build directory..."
cd $TOOLCHAIN_SRC
if ( ! -d build ) then
    mkdir build
endif

# Configure
echo ""
echo "[3/4] Configuring toolchain..."
cd build
../configure --prefix=$TOOLCHAIN_ROOT --with-arch=rv32ima --with-abi=ilp32
if ( $status != 0 ) then
    echo "ERROR: configure failed."
    exit 1
endif

# Build
echo ""
echo "[4/4] Building toolchain..."
echo "This may take a long time."
make
if ( $status != 0 ) then
    echo "ERROR: toolchain build failed."
    exit 1
endif

echo ""
echo "=================================================="
echo "Toolchain install complete."
echo "Installed to:"
echo "  $TOOLCHAIN_ROOT"
echo ""
echo "To verify:"
echo "  $TOOLCHAIN_ROOT/bin/riscv32-unknown-elf-gcc --version"
echo "=================================================="