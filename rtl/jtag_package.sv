//==============================================================================
// Package     : jtag_package
// Standard    : IEEE Std 1149.1
//
// Description:
//   Global package containing all common definitions used throughout the JTAG
//   implementation. Defines the IEEE 1149.1 TAP state encoding, supported JTAG
//   instructions, Test Data Register (TDR) selections, default register values,
//   and project-wide configuration parameters shared across all RTL modules.
//
// Contents:
//   • TAP Controller state definitions
//   • Supported JTAG instruction opcodes
//   • Test Data Register (TDR) selection types
//   • Shift-register control modes
//   • Global design parameters (IR width, BSR width, IDCODE, etc.)
//==============================================================================
package jtag_package;

	// IEEE 1149.1 TAP Controller 16-state finite-state machine
	typedef enum logic [3:0] {
	    EXIT2_DR    = 4'h0,
	    EXIT1_DR    = 4'h1,
	    SHIFT_DR    = 4'h2,
	    PAUSE_DR    = 4'h3,
	    SEL_SCAN_IR = 4'h4,
	    UPDATE_DR   = 4'h5,
	    CAP_DR      = 4'h6,
	    SEL_SCAN_DR = 4'h7,
	    EXIT2_IR    = 4'h8,
	    EXIT1_IR    = 4'h9,
	    SHIFT_IR    = 4'hA,
	    PAUSE_IR    = 4'hB,
	    RUN_IDLE    = 4'hC,
	    UPDATE_IR   = 4'hD,
	    CAP_IR      = 4'hE,
	    RST         = 4'hF
	} tap_state_t;

	// Generic operating modes used by reusable shift-register modules
	typedef enum {DISABLE, SER_IN, PAR_IN} shift_reg_state_t;

	parameter CORE_IN_PORTS  = `CORE_IN_PORTS;
	parameter CORE_OUT_PORTS = `CORE_OUT_PORTS;
	// Boundary Scan Register width = total number of boundary scan cells
	parameter BSC_COUNT = (CORE_IN_PORTS + CORE_OUT_PORTS);

	// Instruction Register width
	parameter IR_WIDTH = `IR_WIDTH;

	// IDCODE register width (typically 32 bits per IEEE 1149.1)
	parameter IDCODE_WIDTH = `IDCODE_WIDTH;

	// Hardwired IEEE IDCODE register value:
	// Version[31:28] | Part Number[27:12] | Manufacturer[11:1] | 1'b1
	parameter ID_CODE_REG_DEF_VAL = `ID_CODE_REG_DEF_VAL;

	// Supported IEEE 1149.1 instructions
	typedef enum logic [IR_WIDTH-1:0]{
		INTEST   = `INTEST,
		IDCODE   = `IDCODE,
		RUNBIST  = `RUNBIST,
		SAMPLE   = `SAMPLE,
		EXTEST   = `EXTEST,
		PRELOAD  = `PRELOAD,
		CLAMP    = `CLAMP,
		BYPASS   = {IR_WIDTH{1'b1}}    // Mandatory IEEE BYPASS opcode
	} instructions_t;

	// IR reset value after Test-Logic-Reset (device defaults to IDCODE)
	parameter IR_DEFAULT_RST_VALUE = {{(IR_WIDTH-1){1'b0}},1'b1};

	// Bridge mode: directly connects core input to core output when enabled
	parameter BRIDGE_CORE = `BRIDGE_CORE;

	// Available Test Data Registers selectable by the Instruction Register
	typedef enum {TDR_BSR, TDR_IDCODE, TDR_BYPASS, TDR_RUNBIST} tdr_avlbl_t;

endpackage : jtag_package