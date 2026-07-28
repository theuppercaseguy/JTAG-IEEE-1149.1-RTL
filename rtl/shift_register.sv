



module shift_register import jtag_package::*; #(
		parameter WIDTH = 8 //8 bit wide
	)
	(
		input  logic clk,    						  // Clock
		input  logic rst_n,  						  // Asynchronous reset active low
		input  shift_reg_state_t state,   // no change, ser_in, par_in
		input  logic ser_in, 						  // MSB in
		input  logic [WIDTH-1:0] par_in,  // paralle in

		output  logic ser_out, 						// LSB out
		output  logic [WIDTH-1:0] par_out // parallel out
	);

	logic [WIDTH-1:0] shift_reg;

	always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
			shift_reg <= par_in;    	

    else begin
      case(state)
        DISABLE: shift_reg <=  shift_reg; 										// Do nothing
        SER_IN:  shift_reg <= {ser_in,shift_reg[WIDTH-1:1]}; 	// Right Shift
        PAR_IN:  shift_reg <=  par_in;    										// parallel load
        default: shift_reg <=  shift_reg; 										// Do nothing
      endcase
    end
  end

  assign ser_out = shift_reg[0];
  assign par_out = shift_reg;

endmodule : shift_register
