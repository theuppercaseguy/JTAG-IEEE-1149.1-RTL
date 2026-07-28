//==============================================================================
// Module      : JTAG_top
// Standard    : IEEE Std 1149.1
//
// Description:
//   Top-level JTAG module implementing the IEEE 1149.1 Test Access Port (TAP).
//   This module integrates the TAP finite state machine, Instruction Register
//   (IR), Data Registers (Boundary Scan Register, BYPASS and IDCODE), and
//   controls TDO multiplexing.
//
// Architecture:
//   - TAP FSM generates the current IEEE 1149.1 TAP state.
//   - Instruction Register shifts serial instructions and updates during
//     UPDATE_IR.
//   - Data Register block contains all available TDRs and selects the active
//     register based on the decoded instruction.
//   - TDO is updated on the falling edge of TCK as required by IEEE 1149.1.
//
// IEEE Compliance:
//   - TMS sampled on TCK rising edge.
//   - TDO changes on TCK falling edge.
//   - IR updated only during UPDATE_IR.
//   - Only the selected Test Data Register participates in DR operations.
//
//------------------------------------------------------------------------------


module JTAG_top import jtag_package::*;#(
		parameter IR_WIDTH 	   = IR_WIDTH,
		parameter BSC_COUNT	   = BSC_COUNT,
		parameter IDCODE_WIDTH = IDCODE_WIDTH
	)(
		jtag_inf inf
	);

	//-------------------------------------------------------------------------
	// TAP Controller
	// Implements the IEEE 1149.1 TAP FSM and generates the current TAP state.
	// All IR/DR operations are controlled using this state machine.
	//-------------------------------------------------------------------------
	tap_state_t tap_fsm_curr_state;
	TAP_FSM tap_fsm_inst(
		.TRST     (inf.trst),
		.TCK      (inf.tclk),
		.TMS      (inf.tms),

		.tap_state(tap_fsm_curr_state)
	);

	//-------------------------------------------------------------------------
	// Instruction Register (IR)
	//
	// intm_ir_hold_reg :
	//     Shift register contents while shifting an instruction.
	//
	// ir_hold_reg :
	//     Active instruction register used by the instruction decoder.
	//     Gets updated only during UPDATE_IR state.
	//
	// ir_reg_lsb :
	//     Serial TDO output of the IR shift register.
	//-------------------------------------------------------------------------
	logic [IR_WIDTH-1:0] ir_hold_reg, intm_ir_hold_reg;
	logic ir_reg_lsb;

	shift_ir #(.IR_WIDTH(IR_WIDTH))
	ir_reg	(
		.tck         (inf.tclk),

		// Reset IR shift register during:
		//  1. External TRST assertion
		//  2. TAP Test-Logic-Reset state
		//  3. Capture-IR state (loads IEEE mandated capture pattern)
		.trst        ( ~(!inf.trst || tap_fsm_curr_state == RST || tap_fsm_curr_state == CAP_IR)),

		.tdi         (inf.tdi),

		// Enable shifting only during SHIFT_IR
		.shift_en    (tap_fsm_curr_state == SHIFT_IR),

		// Serial output towards TDO mux
		.tdo         (ir_reg_lsb),

		// Current contents of the IR shift register
		.ir_hold_reg (intm_ir_hold_reg)
	);

	//-------------------------------------------------------------------------
	// Test Data Registers (TDR)
	//
	// Contains all DR paths:
	//   - Boundary Scan Register (BSR)
	//   - BYPASS Register
	//   - IDCODE Register
	//
	// Selected register depends on the active instruction in ir_hold_reg.
	//
	// dr_reg_lsb:
	//     Serial output of currently selected data register.
	//-------------------------------------------------------------------------
	logic dr_reg_lsb;

	TDR #( 
		.BSC_COUNT					(BSC_COUNT),
	  	.IR_WIDTH  					(IR_WIDTH),
	  	.IDCODE_WIDTH				(IDCODE_WIDTH)
    )tdr_inst(
		.tclk						(inf.tclk), 

		// Reset active data registers whenever TAP enters reset state
		.trst						(inf.trst || ~(tap_fsm_curr_state == RST)), 

		.tdi						(inf.tdi), 

		// Currently active instruction
		.ir_hold_reg				(ir_hold_reg), 

		// Current TAP state used for DR control
		.tap_fsm_curr_state	        (tap_fsm_curr_state),

		// Boundary scan input pins
		.io_in						(inf.io_in),

		// Core outputs entering output-side BSCs
		.io_logic_out				(inf.io_logic_out),

		// Boundary scan driven output pins
		.io_out						(inf.io_out),

		// Input-side BSC outputs towards core logic
		.io_logic_in  				(inf.io_logic_in),

		// Serial output of selected TDR
		.tdo 						(dr_reg_lsb)
    );

	//-------------------------------------------------------------------------
	// TDO Output Logic
	//
	// IEEE 1149.1:
	//   - TDO changes on falling edge of TCK.
	//   - IR data appears during SHIFT_IR.
	//   - DR data appears during SHIFT_DR.
	//   - TDO remains high impedance otherwise.
	//
	// Instruction register is updated during UPDATE_IR.
	//-------------------------------------------------------------------------
	always_ff @(negedge inf.tclk)
	begin
		// Latch newly shifted instruction into active instruction register
		if(tap_fsm_curr_state == UPDATE_IR)
			ir_hold_reg <= intm_ir_hold_reg;

		// Drive IR serial data during SHIFT_IR
		if(tap_fsm_curr_state == SHIFT_IR)
			inf.tdo <= ir_reg_lsb;

		// Tri-state TDO whenever not actively shifting
		if(tap_fsm_curr_state != SHIFT_IR && tap_fsm_curr_state != SHIFT_DR)
			inf.tdo <= 'bz;

		// Drive DR serial data during SHIFT_DR
		if(tap_fsm_curr_state == SHIFT_DR)
			inf.tdo <= dr_reg_lsb; 

	end 

endmodule : JTAG_top