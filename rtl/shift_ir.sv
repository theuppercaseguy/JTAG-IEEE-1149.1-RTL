

module shift_ir import jtag_package::*;
 #(parameter IR_WIDTH = 8) (
	input logic tdi, tck, trst,
	input logic shift_en,
	
	output logic tdo,
	output logic [IR_WIDTH-1:0] ir_hold_reg
);
	shift_register #(.WIDTH(IR_WIDTH))
		shift_ir_reg(
			.clk(tck),
			.rst_n(trst),
			.state(trst == 0 ? PAR_IN : (shift_en ? SER_IN : DISABLE) ), //if reset active paralel load ir default value, else right shift tdi
			.ser_in(tdi),
			.par_in(IR_DEFAULT_RST_VALUE),

			.ser_out(tdo),
			.par_out(ir_hold_reg)
	);

endmodule : shift_ir