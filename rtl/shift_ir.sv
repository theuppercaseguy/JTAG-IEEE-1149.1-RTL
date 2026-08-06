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

module instr_shift_reg import jtag_package::*; #(
	parameter IR_WIDTH = 8              // Instruction Register width
)(
	input logic tdi,                    // Serial data input (from TDI)
	input logic tclk,                   // JTAG test clock
	input logic trst_n,                 // Active-low asynchronous reset
	input tap_state_t tap_fsm_curr_state, // Current TAP controller state

	output logic tdo,                   // Serial data output (LSB of shift register)
	output logic [IR_WIDTH-1:0] ir_hold_reg // Latched instruction presented to decoder
);

	reg   [IR_WIDTH-1:0] shift_reg; // IR shift register
	//==================================================================
	// Instruction Register
	//
	// RST/CAP_IR : Load IEEE-defined capture/reset pattern
	// SHIFT_IR   : Shift TDI into MSB, LSB exits through TDO
	// UPDATE_IR  : Latch shifted instruction into IR hold register
	//==================================================================
	//------------------------------------------------------------
	// Shift Register
	//------------------------------------------------------------
	always_ff @(posedge tclk or negedge trst_n) begin
	    if (!trst_n)
	        shift_reg <= IR_DEFAULT_RST_VALUE;
	    else begin
	        case (tap_fsm_curr_state)
	            RST,
	            CAP_IR  : shift_reg <= IR_DEFAULT_RST_VALUE;
	            SHIFT_IR: shift_reg <= {tdi, shift_reg[IR_WIDTH-1:1]};
	            default : ;
	        endcase
	    end
	end

	//------------------------------------------------------------
	// Update Register (IEEE 1149.1)
	// Updated on falling edge during UPDATE_IR
	//------------------------------------------------------------
	always_ff @(negedge tclk or negedge trst_n) begin
	    if (!trst_n)
	        ir_hold_reg <= IR_DEFAULT_RST_VALUE;
	    else if (tap_fsm_curr_state == UPDATE_IR)
	        ir_hold_reg <= shift_reg;
	end

  // LSB is shifted out on TDO
  assign tdo = shift_reg[0];

endmodule : instr_shift_reg