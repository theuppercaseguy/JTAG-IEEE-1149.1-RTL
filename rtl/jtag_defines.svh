//==============================================================================
// File        : jtag_defines.svh
// Standard    : IEEE Std 1149.1
//
// Description:
//   Project-wide compile-time configuration macros used by the JTAG RTL.
//   Defines register widths, supported instruction opcodes, IDCODE defaults,
//   boundary-scan configuration, and optional build-time features.
//==============================================================================
`ifndef CORE_IN_PORTS
`define CORE_IN_PORTS 4               // number of input boundary-scan cells
`endif
`ifndef CORE_OUT_PORTS
`define CORE_OUT_PORTS 4              // number of output boundary-scan cells
`endif
`ifndef IR_WIDTH
`define IR_WIDTH 32                   // instruction register width, in bits
`endif
`ifndef IDCODE_WIDTH
`define IDCODE_WIDTH 32               // fixed by IEEE 1149.1 IDCODE format
`endif
`ifndef ID_CODE_REG_DEF_VAL
`define ID_CODE_REG_DEF_VAL 65450     // hardwired IDCODE constant value
`endif
`ifndef INTEST
`define INTEST 0                      // opcode: drive/capture via core, not pins
`endif
`ifndef IDCODE
`define IDCODE 1                      // opcode: select 32-bit device ID register
`endif
`ifndef RUNBIST
`define RUNBIST 2                     // opcode: trigger internal self-test
`endif
`ifndef SAMPLE
`define SAMPLE 3                      // opcode: non-intrusive capture of pin/core state
`endif
`ifndef EXTEST
`define EXTEST 4                      // opcode: drive/capture via pins, not core
`endif
`ifndef PRELOAD
`define PRELOAD 5                     // opcode: stage BSR values before EXTEST, no pin effect
`endif
`ifndef CLAMP
`define CLAMP 6                       // opcode: hold pins at BSR value, bypass core
`endif
// define by IEEE as alll 1's
// `ifndef BYPASS
// `define BYPASS 'hffff
// `endif
`ifndef BRIDGE_CORE
`define BRIDGE_CORE 1
`endif
