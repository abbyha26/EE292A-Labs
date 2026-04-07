# HL5: A 32-bit RISC-V processor designed with HLS

This is a high-level description in SystemC of an in-order 32-bit RISC-V core.
This design is qualified to work for versions:
Stratus HLS -> 25.02.001-p
Xcelium Simulation -> 25.03.002
Genus Logic Synthesis and Innovus -> 25.12 and later
Set RTL directory location
```bash
setenv STRATUS_RTL <RTL directory>
```
Set Stratus HLS installation path
```bash
setenv STRATUS_HLS_INSTALL /hls/release/stratus_25.02.001-p
```
set up your enviroment to run Genus and Innovus 25.12 or later
```bash
setup ddi DDI251/25.12-s079_1
```

## Installing the RISC-V toolchain

Test programs must be compiled with the RISC-V toolchain.

```bash
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
mkdir build
cd build
../configure --prefix=<custom_target_path> --with-arch=rv32ima --with-abi=ilp32
make
```

To compile the test programs, make sure that `riscv32-unknown-elf-gcc` is set to PATH.

```bash
cd <hl5>/soft
make
```

## Simulating and Synthesizing HL5

Simulation and synthesis run within the Cadence Stratus HLS 25.02.001-P environment.
In addition to Stratus HLS, simulation is configured to use XCELIUM as the
RTL and SystemC simulator.  You may change this configuration from the Stratus
`project.tcl` script.

For instance, to run HLS and generate RTL for the `BASIC` HLS configuration,
enter the HLS folder and run the following target.

```bash
cd <hl5>/hls
#fedec block
make hls_fedec_BASIC
#execute block
make hls_execute_BASIC
#memwb block
make hls_memwb_BASIC
#HL5 block
#make hls_hl5_BASIC
```

To run a simulation of the C program, compile the test
programs, then execute the following targets.
This RISC-V design currently lacks edge‑case guards (divide‑by‑zero and overflow).

```bash
cd <hl5>/hls
# Behavioral simulation
make sim_BASIC_div_10_B
# RTL simulation for BASIC HLS configuration
make sim_BASIC_div_10_V
# RTL simulation with GUI support
make debug_BASIC_div_10_V
```

The simulation will print on screen the content of the program counter, the
instruction register and the register file.

The target for synthesis is set to ASIC technology targeting 45nm.

If you use this work, please reference the following paper.

> _*[HL5: A 32-bit RISC-V Processor Designed with High-Level
> Synthesis](https://www.sld.cs.columbia.edu/pubs/mantovani_cicc20.pdf).*
> Paolo Mantovani, Robert Margelli, Davide Giri, and Luca P. Carloni.
> In the Proceedings of the Custom Integrated Circuits Conference (CICC), 2020._
