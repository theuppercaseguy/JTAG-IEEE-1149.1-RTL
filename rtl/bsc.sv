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

//==============================================================================
// Module      : bsc
// Cell Type   : IEEE Std 1149.1 BSC_1 Boundary Scan Cell
//
// Description:
//   Implements a single IEEE 1149.1 Boundary Scan Cell (BSC_1). The cell
//   supports boundary-scan capture, serial shifting, and update operations
//   under TAP controller supervision. Multiple instances are connected in
//   series to form the Boundary Scan Register (BSR).
//
// Data Paths:
//   • Functional path : sys_in  ----------> sys_out
//   • Scan path       : from_bsc_in ---> capture_ff ---> to_bsc_out
//
// Control Signals:
//   • capture_dr : Captures functional pin value into the scan FF.
//   • shift_dr   : Shifts serial data through the BSR.
//   • update_dr  : Transfers scan FF contents to the update FF.
//   • mode_ctrl  : Selects functional mode or boundary-scan mode.
//==============================================================================
module bsc(
	input  logic tclk,
	input  logic sys_in, from_bsc_in, // Functional input and serial input from previous BSC
	input  logic shift_dr, capture_dr, update_dr,
	input  logic mode_ctrl,
	output logic sys_out, to_bsc_out
);

	// Internal datapath signals
	logic shift_mux_out;
	logic capture_ff_out;
	logic update_ff_out;
	logic mux_out;

	// MUX A:
	// CaptureDR -> sample functional input
	// ShiftDR   -> accept serial data from previous BSC
	assign shift_mux_out = shift_dr == 0 ? sys_in : from_bsc_in;

	// Capture/Shift register
	// Samples sys_in during CaptureDR and shifts serial data during ShiftDR
	always_ff @(posedge tclk)
	if(shift_dr || capture_dr)
		capture_ff_out <= shift_mux_out;

	// Update register
	// Latches captured/shifted value during UpdateDR
	always_ff @(negedge tclk)
	if(update_dr)
		update_ff_out <= capture_ff_out;

	// MUX B:
	// Functional mode  -> pass system signal
	// Test mode        -> drive value stored in update register
	assign mux_out = mode_ctrl == 0 ? sys_in : update_ff_out;
	assign sys_out = mux_out;

	// Serial output to the next Boundary Scan Cell
	assign to_bsc_out = capture_ff_out;

endmodule : bsc