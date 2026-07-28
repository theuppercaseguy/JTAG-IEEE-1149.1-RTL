module TAP_FSM import jtag_package::*;(
	input  logic TCK, TRST,
	input  logic TMS,
	output tap_state_t tap_state  // Asynchronous reset active low
);
	tap_state_t curr_state, next_state;

	always_ff @(posedge TCK or negedge TRST) begin
		if(!TRST)
			curr_state <= RST;              // async reset forces Test-Logic-Reset, independent of TMS
		else
			curr_state <= next_state;       // state update on rising edge, per IEEE 1149.1
	end

	always_comb begin
		case (curr_state)
			RST: 		  next_state =  TMS == 0 ? RUN_IDLE : RST ;
			RUN_IDLE:	  next_state =  TMS == 0 ? RUN_IDLE : SEL_SCAN_DR ;

			SEL_SCAN_DR:  next_state =  TMS == 0 ? CAP_DR   : SEL_SCAN_IR ;
			CAP_DR:		  next_state =  TMS == 0 ? SHIFT_DR : EXIT1_DR ;
			SHIFT_DR:	  next_state =  TMS == 0 ? SHIFT_DR : EXIT1_DR ;
			EXIT1_DR:	  next_state =  TMS == 0 ? PAUSE_DR : UPDATE_DR ;
			PAUSE_DR:	  next_state =  TMS == 0 ? PAUSE_DR : EXIT2_DR ;
			EXIT2_DR:	  next_state =  TMS == 0 ? SHIFT_DR : UPDATE_DR ;
			UPDATE_DR:	  next_state =  TMS == 0 ? RUN_IDLE : SEL_SCAN_DR ;
			SEL_SCAN_IR:  next_state =  TMS == 0 ? CAP_IR   : RST ;          // TMS=1 here re-enters reset, not SEL_SCAN_DR
			CAP_IR:		  next_state =  TMS == 0 ? SHIFT_IR : EXIT1_IR ;
			SHIFT_IR:	  next_state =  TMS == 0 ? SHIFT_IR : EXIT1_IR ;
			EXIT1_IR:	  next_state =  TMS == 0 ? PAUSE_IR : UPDATE_IR ;
			PAUSE_IR:	  next_state =  TMS == 0 ? PAUSE_IR : EXIT2_IR ;
			EXIT2_IR:	  next_state =  TMS == 0 ? SHIFT_IR : UPDATE_IR ;
			UPDATE_IR:	  next_state =  TMS == 0 ? RUN_IDLE : SEL_SCAN_DR ;
		endcase
	end

	assign tap_state = curr_state;         // combinational output, reflects current state every cycle

endmodule : TAP_FSM