


module instr_decoder import jtag_package::*;
	#(parameter IR_WIDTH = 4)
(
	input logic [IR_WIDTH-1:0] ir_reg,
 	
	output logic mode_ctrl,
	output tdr_avlbl_t tdr_selected
);

	always_comb begin
		case (ir_reg) //mode values defined by IEEE
	 	EXTEST: begin
	 		mode_ctrl = 1;
	 		tdr_selected = TDR_BSR;
	 	end
	 	IDCODE: begin
	 		mode_ctrl = 0;
	 		tdr_selected = TDR_IDCODE;
	 	end
	 	INTEST: begin
	 		mode_ctrl = 1;
	 		tdr_selected = TDR_BSR;
	 	end
	 	PRELOAD: begin
	 		mode_ctrl = 0;
	 		tdr_selected = TDR_BSR;
	 	end
	 	RUNBIST: begin
	 		mode_ctrl = 1;
	 		tdr_selected = TDR_RUNBIST;
	 	end
	 	SAMPLE: begin
	 		mode_ctrl = 0;
	 		tdr_selected = TDR_BSR;
	 	end
	 	BYPASS: begin
	 		mode_ctrl = 0;
	 		tdr_selected = TDR_BYPASS;
	 	end 
	 	CLAMP: begin
	 		mode_ctrl = 1;
	 		tdr_selected = TDR_BYPASS;
	 	end 
	 
	 	default : begin 
	 		mode_ctrl = 0;
	 		tdr_selected = TDR_IDCODE;
	 	end
		endcase
	end

endmodule : instr_decoder