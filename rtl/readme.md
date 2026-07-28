# IEEE 1149.1 JTAG Controller (SystemVerilog)

<p align="center">

![IEEE](https://img.shields.io/badge/IEEE-1149.1-blue)
![Language](https://img.shields.io/badge/Language-SystemVerilog-orange)
![Verification](https://img.shields.io/badge/Verification-Truechip%20JTAG%20VIP-success)
![Simulator](https://img.shields.io/badge/Simulator-QuestaSim%202026.1-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

</p>

---
# 📑 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Feature Matrix](#feature-matrix)
- [Project Architecture](#project-architecture)
- [JTAG Interface](#jtag-interface)
- [Integrating Your Own Core](#integrating-your-own-core)
- [Bridge Mode](#bridge-mode)
- [Boundary Scan Register (BSR)](#boundary-scan-register-bsr)
- [Configuration](#configuration)
- [Getting Started](#getting-started)
- [Compilation](#compilation)
  - [Compile Order](#compile-order)
  - [Example Compilation (QuestaSim)](#example-compilation-questasim)
- [Running Verification](#running-verification)
- [Verification Status](#verification-status)
- [Supported Instructions](#supported-instructions)
- [Example Waveforms](#example-waveforms)
- [Motivation](#motivation)
- [Why this implementation?](#why-this-implementation)
- [Repository Structure](#repository-structure)
- [Design Highlights](#design-highlights)
- [Future Improvements](#future-improvements)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)
- [Project Status](#project-status)

# Overview

This repository contains a fully synthesizable and modular implementation of an **IEEE 1149.1 (JTAG)** Test Access Port (TAP) controller written entirely in **SystemVerilog**.

The design was developed to closely follow the IEEE 1149.1 specification while remaining easy to integrate into custom ASIC or FPGA projects. Every major component of the TAP architecture has been implemented as an independent RTL module, making the design highly reusable and easy to extend.

The implementation has been functionally verified using the **Truechip IEEE 1149.1 JTAG VIP** running on **Siemens QuestaSim 2026.1**, successfully passing regression tests for all currently implemented instructions.

---

# Features

- Fully synthesizable SystemVerilog RTL
- IEEE 1149.1 compliant TAP Controller
- Modular architecture
- Parameterizable Instruction Register
- Parameterizable Boundary Scan Register
- Parameterizable IDCODE Register
- Generic Boundary Scan Cell implementation
- Support for custom user cores
- Optional Bridge Mode for standalone verification
- Separate Instruction and Data Register paths
- High-Z TDO outside Shift states
- Easily extendable instruction decoder
- Verified using commercial JTAG VIP
- Simulator independent RTL

---

# Feature Matrix

| Feature | IEEE Required | Implemented | VIP Tested |
|-----------|:------------:|:-----------:|:----------:|
| TAP Controller | ✅ | ✅ | ✅ |
| Instruction Register | ✅ | ✅ | ✅ |
| Boundary Scan Register | ✅ | ✅ | ✅ |
| BYPASS Register | ✅ | ✅ | ✅ |
| IDCODE Register | Optional | ✅ | ✅ |
| SAMPLE | ✅ | ✅ | ✅ |
| PRELOAD | ✅ | ✅ | ✅ |
| EXTEST | ✅ | ✅ | ✅ |
| CLAMP | Optional | ✅ | ✅ |
| INTEST | Optional | ✅ | ✅ |
| RUNBIST | Optional | ❌ | ❌ |

---

# Project Architecture

The design follows the standard IEEE 1149.1 architecture and separates every logical block into an independent reusable module.

<p align="center">
<img src="docs/images/jtag_architecture.png" width="100%">
</p>

The top-level architecture consists of the following RTL blocks:

| Module | Description |
|---------|-------------|
| `JTAG_top.sv` | Top-level integration module |
| `TAP_FSM.sv` | IEEE 1149.1 TAP Controller |
| `shift_ir.sv` | Instruction Register |
| `TDR.sv` | Test Data Register selection logic |
| `shift_register.sv` | Generic parameterized shift register |
| `bsc.sv` | IEEE Boundary Scan Cell |
| `instr_decoder.sv` | Instruction decoder |
| `jtag_package.sv` | Enums, parameters and instruction definitions |
| `jtag_interface.sv` | Top-level SystemVerilog interface |

---

# JTAG Interface

The project exposes a single SystemVerilog interface named

```sv
jtag_inf
```

which contains both the standard JTAG TAP signals and the DUT I/O signals.

## Standard JTAG Signals

| Signal | Direction | Description |
|----------|-----------|-------------|
| TCK | Input | Test Clock |
| TMS | Input | TAP State Machine Control |
| TDI | Input | Serial Test Data Input |
| TDO | Output | Serial Test Data Output |
| TRST | Input | Active-Low TAP Reset |

---

## DUT Signals

| Signal | Direction | Description |
|----------|-----------|-------------|
| io_in | Input | Physical input pins of the chip |
| io_logic_in | Output | Input Boundary Scan outputs into the user core |
| io_logic_out | Input | Outputs from the user core into the output Boundary Scan Cells |
| io_out | Output | Physical output pins driven by the output Boundary Scan Cells |

Data flows through the design as follows:

```text
External Pins => io_in => Input BSC's => io_logic_in => USER Core => io_logic_out => Output BSC's => io_out => external Pins

```
---
# Integrating Your Own Core

Connecting an existing RTL design is straightforward.

The Boundary Scan Register is split into two sections:

- Input Boundary Scan Cells
- Output Boundary Scan Cells

The user core sits between these two groups.

Connect your design exactly as shown below.

```text
                 +----------------------+
                 |      User Core       |
                 |                      |
io_logic_in ---->|                      |----> io_logic_out
                 |                      |
                 +----------------------+
```

### `io_logic_in`

Outputs generated by the **input Boundary Scan Cells**.
These signals should be connected directly to the inputs of your RTL design.

### `io_logic_out`

Outputs generated by your RTL design.
These signals become the inputs to the **output Boundary Scan Cells**.

### `io_out`

Outputs of the output Boundary Scan Cells.
These are the final physical output pins of the device.
---

# Bridge Mode
For projects that do not yet have a user core, or for standalone Boundary Scan verification, Bridge Mode can be enabled.

```sv
`define BRIDGE_CORE 1
```

When enabled,

```sv
assign io_logic_out = io_logic_in;
```

This directly connects the input Boundary Scan Cells to the output Boundary Scan Cells without requiring any user logic.

Bridge Mode is especially useful for:

- Initial RTL development
- Boundary Scan verification
- Manufacturing test verification
- JTAG bring-up
- Running VIP regressions before integrating the user core

---

# Boundary Scan Register (BSR)

The Boundary Scan Register consists of a serial chain of Boundary Scan Cells.

```text
TDI
 │
 ▼  ( Input Boundary Scan Cells )
[BSC0] → [BSC1] → [BSC2] → [BSC3] → [BSC4] → [BSC5] → [BSC6] → [BSC7] 
                                    (Output Boundary Scan Cells) │
                                                                 ▼
                                                                TDO         
```
The register width is automatically determined from

```sv
CORE_IN_PORTS + CORE_OUT_PORTS
```

No RTL modifications are required when changing the number of boundary scan cells.

---

# Configuration
The project is fully configurable through

```text
jtag_defines.svh
```
Supported configuration options include:

| Macro | Description |
|---------|-------------|
| CORE_IN_PORTS | Number of input Boundary Scan Cells |
| CORE_OUT_PORTS | Number of output Boundary Scan Cells |
| IR_WIDTH | Instruction Register width |
| IDCODE_WIDTH | IDCODE Register width |
| ID_CODE_REG_DEF_VAL | Default IDCODE value |
| BRIDGE_CORE | Enables Bridge Mode |

> [!WARNING]
>
> Always modify **`jtag_defines.svh`** when changing the project configuration.
>
> Avoid manually overriding parameters inside individual RTL modules.
>
> Since multiple modules share common widths and configuration values, changing parameters independently can lead to inconsistent register sizes and incorrect Boundary Scan behavior.

---

# Getting Started
Instantiate the interface

```sv
logic tck;

jtag_inf inf(tck);
```

Instantiate the top-level JTAG controller

```sv
JTAG_top dut(
    .inf(inf)
);
```

If integrating a custom core:
```text
assign core_inputs[3:0] = io_logic_in;
assign io_logic_out     = core_outputs[3:0];
```

For standalone verification without a user core, simply enable

```sv
`define BRIDGE_CORE 1
```

and the Boundary Scan chain will automatically bypass the user logic.

---
# Compilation

The RTL is simulator independent and should compile on any IEEE-compliant SystemVerilog simulator.

The project has been developed and verified using:

| Tool | Version |
|------|---------|
| Siemens QuestaSim | 2026.1 |
| Truechip IEEE 1149.1 VIP | 25.3 |

---

## Compile Order

Compile the source files in the following order.

```text
jtag_defines.svh
jtag_package.sv
jtag_interface.sv
shift_register.sv
shift_ir.sv
bsc.sv
instr_decoder.sv
TAP_FSM.sv
TDR.sv
JTAG_top.sv
Testbench
```

Maintaining this order ensures that packages, interfaces, typedefs, and parameter definitions are available before dependent modules are compiled.

---

# Example Compilation (QuestaSim)

```bash
# Compile
vlog -sv -f file.f

# Optimize (preserve full debug visibility)
vopt tb_top -o tb_top_opt +acc

# Start simulation
vsim -voptargs=+acc tb_top_opt

# Run until completion
run -all
```

---

# Running Verification

The RTL has been validated using the **Truechip IEEE 1149.1 JTAG VIP**.

Regression includes verification of:

- TAP State Machine
- Instruction Register
- Boundary Scan Register
- BYPASS Register
- IDCODE Register
- Instruction Decoder
- TDO Timing
- Boundary Scan Cell Operation
- Capture-DR
- Shift-DR
- Update-DR
- Capture-IR
- Shift-IR
- Update-IR
- Reset Behavior
- High-Z TDO Behavior
- Boundary Scan Pin Updates
- Instruction Transitions
- TAP State Transitions

---

# Verification Status

| Block | Status |
|---------|:------:|
| TAP FSM | ✅ |
| Instruction Register | ✅ |
| Boundary Scan Register | ✅ |
| Boundary Scan Cell | ✅ |
| BYPASS Register | ✅ |
| IDCODE Register | ✅ |
| Instruction Decoder | ✅ |
| TDO Output Logic | ✅ |
| Boundary Scan Pin Updates | ✅ |
| TAP Timing | ✅ |
| IEEE Compliance | ✅ |

---

# Supported Instructions

| Instruction | Description |
|------------|-------------|
| **BYPASS** | Selects the single-bit bypass register. |
| **IDCODE** | Selects the 32-bit device identification register. |
| **SAMPLE** | Captures the current system pin values without affecting system operation. |
| **PRELOAD** | Loads values into the Boundary Scan Register for later use by EXTEST or CLAMP. |
| **EXTEST** | Drives external pins using the Boundary Scan Register. |
| **INTEST** | Tests internal logic by driving the core through the Boundary Scan Register. |
| **CLAMP** | Holds outputs at the previously updated Boundary Scan Register values while selecting the BYPASS register. |
| **RUNBIST** | Reserved for future implementation. |

---

# Example Waveforms

Waveforms for each supported instruction will be added in the future.

The following instructions will include annotated timing diagrams:

- BYPASS
- IDCODE
- SAMPLE
- PRELOAD
- EXTEST
- INTEST
- CLAMP

Placeholder:

```text
docs/
└── waveforms/
    ├── bypass.png
    ├── idcode.png
    ├── sample.png
    ├── preload.png
    ├── extest.png
    ├── intest.png
    └── clamp.png
```

Each waveform will include:

- TAP State Sequence
- TMS Activity
- TDI Stream
- TDO Response
- Boundary Scan Register Contents
- Instruction Register Contents
- Pin Behavior
- Explanation of Each State Transition

---

## Motivation

This project was developed to gain a complete understanding of IEEE 1149.1 by implementing every architectural block from scratch instead of relying on vendor IP. The design emphasizes readability, modularity, configurability, and verification using an industry-standard JTAG VIP.

## Why this implementation?

Unlike many educational JTAG examples that implement only BYPASS or IDCODE, this project implements the complete TAP architecture, parameterized Boundary Scan Register, configurable Instruction Register, and multiple Test Data Registers while remaining IEEE 1149.1 compliant and verified using an industrial verification IP.

# Repository Structure

```text
.
├── rtl/
│   ├── JTAG_top.sv
│   ├── TDR.sv
│   ├── TAP_FSM.sv
│   ├── shift_ir.sv
│   ├── shift_register.sv
│   ├── bsc.sv
│   ├── instr_decoder.sv
│   ├── jtag_interface.sv
│   ├── jtag_package.sv
│   └── jtag_defines.svh
│
├── docs/
│   ├── images/
│   │   └── jtag_architecture.png
│   │
│   └── waveforms/
│
├── tb/
│   ├── jtag_tb_top.sv
│
├── files_list.f
|
├── README.md
│
└── LICENSE
```

---

# Design Highlights

- Fully modular RTL architecture
- Parameterized register widths
- Parameterized Boundary Scan Register length
- Independent reusable Boundary Scan Cell module
- Generic parameterized shift register
- IEEE 1149.1 compliant TAP Controller
- Supports optional user core integration
- Supports standalone Bridge Mode
- Clean separation between IR and DR paths
- Synthesizable RTL
- Simulator independent implementation
- Commercial VIP verified

---

# Future Improvements

Planned enhancements include:

- IEEE 1687 (IJTAG) support
- Segment Insertion Bit (SIB) implementation
- Embedded Instrument support
- Multiple Boundary Scan Chains
- RUNBIST implementation
- Optional 4-wire JTAG support (without TRST)
- Automatic BSDL generation
- User-defined instruction support
- Additional verification environments
- FPGA reference design

---

# Contributing

Contributions are welcome.

Possible areas include:

- Additional IEEE optional instructions
- Improved documentation
- More verification testcases
- FPGA demonstrations
- Additional simulator support
- IJTAG extensions
- BSDL generation
- Performance optimizations

Please open an Issue before submitting major architectural changes.

---

# License

This project is licensed under the **MIT License**.

You are free to:

- Use
- Modify
- Distribute
- Commercially use

the RTL under the terms of the MIT License.

---

# Acknowledgements

This implementation follows the **IEEE 1149.1 Standard (JTAG)**.

Verification has been performed using the **Truechip IEEE 1149.1 JTAG Verification IP** on **Siemens QuestaSim 2026.1**.

Special thanks to the IEEE working group for defining the JTAG standard and to Truechip for providing a comprehensive commercial verification environment.

---

# Contact

If you encounter a bug, have a feature request, or would like to contribute, please open a GitHub Issue.

Suggestions, improvements, and pull requests are always welcome.

---

# Project Status

> **Current Status:** Stable

- ✔ IEEE 1149.1 compliant
- ✔ Fully synthesizable
- ✔ Modular RTL
- ✔ Commercial VIP verified
- ✔ Ready for ASIC/FPGA integration
- ✔ Open for future IEEE 1687 (IJTAG) expansion