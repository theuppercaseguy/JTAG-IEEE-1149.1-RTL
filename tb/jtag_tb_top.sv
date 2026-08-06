
module jtag_tb_top;

	import jtag_package::*;
	logic clk, rst;

	jtag_inf jtag_intf(clk);

	JTAG_top jtag_top_inst(
		.inf(jtag_intf)
	);

	initial begin
		jtag_intf.trst = 0; //rst enabled at startup
		clk = 0;
		forever #50ns clk = ~clk;
		// #150 jtag_intf.trst = 1; //rst deactivated
	end

	initial begin
		#150ns; jtag_intf.trst = 1; jtag_intf.tms =  1'b0; // at rst
		#100ns;  jtag_intf.tms =  1'b1; // at run
		#100ns;  jtag_intf.tms =  1'b1; // at sel dr
		#100ns;  jtag_intf.tms =  1'b0; // at sel ir
		#100ns;  jtag_intf.tms =  1'b0; // at cap ir
		#100ns;  jtag_intf.tms =  1'b0;  jtag_intf.tdi = 1'b1;// at shit ir
		#100ns;  jtag_intf.tms =  1'b1;  jtag_intf.tdi = 1'b0;// at shit ir
		#100ns;  jtag_intf.tms =  1'b1;  // at exit1 ir
		#100ns;  jtag_intf.tms =  1'b1;  // at update ir
		#100ns;  jtag_intf.tms =  1'b1;  // at sel dr

		#50ns;  jtag_intf.tms =  1'b0;  // at cap dr
		repeat(31)//32 idcode bits
		#100ns;  jtag_intf.tms =  1'b0;  // at shift dr
		#100ns;  jtag_intf.tms =  1'b1;  // at exit1 dr
		#100ns;  jtag_intf.tms =  1'b1;  // at update dr
		#100ns;  jtag_intf.tms =  1'b0;  // at run dr
		#100ns;  jtag_intf.tms =  1'b0;  // at run dr
		#100ns;  jtag_intf.tms =  1'b0;  // at run dr

		$finish;;
	end 

endmodule : jtag_tb_top