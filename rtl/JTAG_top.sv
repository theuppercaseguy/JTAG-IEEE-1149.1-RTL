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
		parameter IR_WIDTH 	   = jtag_package::IR_WIDTH,
		parameter BSC_COUNT	   = jtag_package::BSC_COUNT,
		parameter IDCODE_WIDTH = jtag_package::IDCODE_WIDTH
	)(
		jtag_inf inf
	);

	//-------------------------------------------------------------------------
	// TAP Controller
	// Implements the IEEE 1149.1 TAP FSM and generates the current TAP state.
	// All IR/DR operations are controlled using this state machine.
	//-------------------------------------------------------------------------
	tap_state_t tap_fsm_curr_state;
	logic shift_dr_en, capture_dr_en, update_dr_en;
	TAP_FSM tap_fsm_inst(
		.TRST     (inf.trst),
		.TCLK      (inf.tclk),
		.TMS      (inf.tms),

		.tap_state(tap_fsm_curr_state),

	    .shift_dr_en  (shift_dr_en),
	    .capture_dr_en(capture_dr_en),
	    .update_dr_en (update_dr_en)
	);

	//-------------------------------------------------------------------------
	// Instruction Register (IR)
	//
	// ir_hold_reg :
	//     Active instruction register used by the instruction decoder.
	//     Gets updated only during UPDATE_IR state.
	//
	// ir_reg_lsb :
	//     Serial TDO output of the IR shift register.
	//-------------------------------------------------------------------------
	logic [IR_WIDTH-1:0] ir_hold_reg;
	logic ir_reg_lsb;

	instr_shift_reg #(.IR_WIDTH(IR_WIDTH))
	instr_reg(
		.tclk        (inf.tclk 						  ),
		.trst_n      (inf.trst  					  ),

		.tdi         (inf.tdi 						  ),
		.tap_fsm_curr_state         (tap_fsm_curr_state 						  ),
		.tdo         (ir_reg_lsb					  ),// Serial output towards TDO mux
		
		.ir_hold_reg (ir_hold_reg)// Current contents of the IR shift register
	);

	//--------------------------------------------------------------------------
	// Instruction Decoder
	// Decodes the current instruction to select the active Test Data Register
	// and generate Boundary Scan mode control.
	//--------------------------------------------------------------------------
	tdr_avlbl_t tdr_selected;
	logic mode;
	instr_decoder #(.IR_WIDTH(IR_WIDTH))
	instr_decoder_i (
		.ir_reg       (ir_hold_reg),

		.mode_ctrl    (mode),
		.tdr_selected (tdr_selected)
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
    )tdr(
		.tclk						(inf.tclk), 
		.trst						(inf.trst || ~(tap_fsm_curr_state == RST)), 

		.tdi						(inf.tdi), 
		.capture_dr_en				(capture_dr_en), 
		.shift_dr_en				(shift_dr_en), 
		.update_dr_en				(update_dr_en), 
		.mode						(mode),
		.tdr_selected				(tdr_selected),
		.io_in						(inf.io_in),// Boundary scan input pins
		.io_logic_out				(inf.io_logic_out),// Core outputs entering output-side BSCs

		.io_logic_in  				(inf.io_logic_in),// Input-side BSC outputs towards core logic
		.io_out						(inf.io_out),// Boundary scan driven output pins
		.tdo 						(dr_reg_lsb)// Serial output of selected TDR
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
		// Tri-state TDO whenever not actively shifting
		if(tap_fsm_curr_state != SHIFT_IR && tap_fsm_curr_state != SHIFT_DR)
			inf.tdo <= 'bz;

		// Drive IR serial data during SHIFT_IR
		if(tap_fsm_curr_state == SHIFT_IR)
			inf.tdo <= ir_reg_lsb;

		// Drive DR serial data during SHIFT_DR
		if(tap_fsm_curr_state == SHIFT_DR)
			inf.tdo <= dr_reg_lsb; 

	end 

endmodule : JTAG_top