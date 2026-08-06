//==============================================================================
//  Project    : IEEE 1149.1 JTAG / IEEE 1687 IJTAG RTL Implementation
//  Author     : Saad Khan
//  Email      : saadan06@gmail.com
//  GitHub     : https://github.com/theuppercaseguy
//  LinkedIn   : https://www.linkedin.com/in/the-guy/
//  Portfolio  : https://portfolio-saadkhan.vercel.app/
//------------------------------------------------------------------------------
//  Copyright (c) Saad Khan.
//
//  This project is open for educational, research, and commercial use.
//  Redistribution and modification are permitted, provided appropriate
//  credit is given to the original author and this repository is referenced.
//==============================================================================



//======================================================================
// Project Configuration
//----------------------------------------------------------------------
// Set to 1 to directly connect core inputs to outputs, bypassing any
// user logic. Useful for testing the Boundary Scan Register (BSR)
// without requiring a functional DUT.
//======================================================================
`ifndef BRIDGE_CORE
`define BRIDGE_CORE 1
`endif

//======================================================================
// JTAG Core Configuration
//----------------------------------------------------------------------
// Configurable parameters defining the size of the Boundary Scan
// Register (BSR), Instruction Register (IR), and standard JTAG
// instruction opcodes.
//======================================================================

// Number of Boundary Scan Cells (BSCs) connected to DUT inputs
`ifndef CORE_IN_PORTS
`define CORE_IN_PORTS 4
`endif

// Number of Boundary Scan Cells (BSCs) connected to DUT outputs
`ifndef CORE_OUT_PORTS
`define CORE_OUT_PORTS 4
`endif

// Width of the JTAG Instruction Register (IR)
`ifndef IR_WIDTH
`define IR_WIDTH 8
`endif

// Width of the IEEE 1149.1 IDCODE Register (fixed to 32 bits)
`ifndef IDCODE_WIDTH
`define IDCODE_WIDTH 32
`endif

// Default value loaded into the Device Identification Register
`ifndef ID_CODE_REG_DEF_VAL
`define ID_CODE_REG_DEF_VAL 65450
`endif

//======================================================================
// IEEE 1149.1 Instruction Opcodes
//----------------------------------------------------------------------
// Binary values decoded by the Instruction Register to select the
// active Test Data Register (TDR) or execute a JTAG operation.
//======================================================================

// Connect Boundary Scan Register between TDI and TDO for internal testing
`ifndef INTEST
`define INTEST 7
`endif

// Select the 32-bit Device Identification Register
`ifndef IDCODE
`define IDCODE 10
`endif

// Execute the device's Built-In Self-Test (BIST)
`ifndef RUNBIST
`define RUNBIST 8
`endif

// Capture system data into the Boundary Scan Register without affecting operation
`ifndef SAMPLE
`define SAMPLE 4
`endif

// Drive device pins using Boundary Scan Register contents
`ifndef EXTEST
`define EXTEST 6
`endif

// Load Boundary Scan Register values without updating device pins
`ifndef PRELOAD
`define PRELOAD 5
`endif

// Force output pins to previously loaded Boundary Scan Register values
`ifndef CLAMP
`define CLAMP 9
`endif

// Place all output pins into the high-impedance state
`ifndef HIGHZ
`define HIGHZ 'hD
`endif

// define by IEEE as alll 1's
// `ifndef BYPASS
// `define BYPASS 'hffff
// `endif
