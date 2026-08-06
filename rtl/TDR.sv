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
// Module      : TDR (Test Data Register)
// Standard    : IEEE Std 1149.1
//
// Description:
//   Implements all Test Data Registers (TDRs) required by the IEEE 1149.1 JTAG
//   architecture. Depending on the currently decoded instruction, one Test
//   Data Register is connected between TDI and TDO while all others remain
//   inactive.
//
// Implemented Registers:
//   • Boundary Scan Register (BSR)
//   • BYPASS Register (1-bit)
//   • IDCODE Register
//   • RUNBIST Placeholder
//
// Responsibilities:
//   • Generate CaptureDR, ShiftDR and UpdateDR control signals.
//   • Enable BSR only when it is the selected Test Data Register.
//   • Instantiate the complete Boundary Scan Register chain.
//   • Multiplex the active Test Data Register onto TDO.
//==============================================================================

module TDR import jtag_package::*;
  #( parameter IR_WIDTH      = 4,
     parameter BSC_COUNT     = 4,
     parameter IDCODE_WIDTH  = 4
  )(
  input tclk,
  input trst,
  input tdi,

  input logic shift_dr_en, capture_dr_en, update_dr_en,
  input logic mode,
  input tdr_avlbl_t tdr_selected,

  input logic [CORE_IN_PORTS-1:0]  io_in,          // External input pins
  input logic [CORE_IN_PORTS-1:0]  io_logic_out,   // Core outputs

  output logic [CORE_IN_PORTS-1:0]  io_logic_in,   // Input BSC outputs to core
  output logic [CORE_OUT_PORTS-1:0] io_out,        // Output BSC outputs to pins
  output logic tdo
);

  //--------------------------------------------------------------------------
  // BYPASS Register (1-bit)
  // Captures logic 0 during Capture-DR and shifts serial data during Shift-DR.
  //--------------------------------------------------------------------------
  logic bypass_reg;
  always_ff @(posedge tclk)
  begin
    if(capture_dr_en)
      bypass_reg <= 0;
    if(shift_dr_en)
      bypass_reg <= tdi;
  end

  //--------------------------------------------------------------------------
  // IDCODE Register
  // Parallel-loads the fixed IEEE IDCODE during Capture-DR and shifts it
  // serially during Shift-DR.
  //--------------------------------------------------------------------------
  logic [IDCODE_WIDTH-1:0] id_code_par_out;
  logic                    id_code_ser_out;

  shift_register #(.WIDTH(IDCODE_WIDTH))
  shift_idcode_reg(
    .clk     (tclk),
    .rst_n   (trst),
    .state   (capture_dr_en ? PAR_IN :
         (shift_dr_en   ? SER_IN : DISABLE)),
    .ser_in  (tdi),
    .par_in  (ID_CODE_REG_DEF_VAL),

    .ser_out (id_code_ser_out),
    .par_out (id_code_par_out)
  );


  //--------------------------------------------------------------------------
  // Boundary Scan Register (BSR)
  //--------------------------------------------------------------------------
  genvar i;
  logic [BSC_COUNT-1:0] bsc_chain;     // Complete BSR scan chain
  logic bsr_capture_dr, bsr_update_dr, bsr_shift_dr;  // Enable Boundary Scan control signals only when BSR is selected

  assign bsr_capture_dr = (tdr_selected == TDR_BSR) ?  capture_dr_en  : 1'b0;
  assign bsr_shift_dr   = /*~tclk & */shift_dr_en;
  assign bsr_update_dr  = update_dr_en;

  /*
                               INPUT BOUNDARY SCAN CELLS                         OUTPUT BOUNDARY SCAN CELLS

        io_in[3]      io_in[2]      io_in[1]      io_in[0]      io_logic_out[3] io_logic_out[2] io_logic_out[1] io_logic_out[0]
           │             │             │             │               │              │               │              │
           ▼             ▼             ▼             ▼               ▼              ▼               ▼              ▼
TDI ──▶ [BSC7] ─────▶ [BSC6] ─────▶ [BSC5] ─────▶ [BSC4] ───────▶ [BSC3] ──────▶ [BSC2] ───────▶ [BSC1] ──────▶ [BSC0] ──▶ TDO
          │             │             │             │               │               │               │              │
          ▼             ▼             ▼             ▼               ▼               ▼               ▼              ▼
    io_logic_in[3]  io_logic_in[2] io_logic_in[1] io_logic_in[0]  io_out[3]     io_out[2]       io_out[1]       io_out[0]
  */

  generate

    //----------------------------------------------------------------------
    // Input-side Boundary Scan Cells
    //
    // Scan path:
    //      TDI -> Input BSC[n-1] -> ... -> Input BSC[n/2]
    //----------------------------------------------------------------------
    for (i = 0; i < CORE_IN_PORTS; i++) begin
      bsc bsc_in(
        .tclk        (tclk),

        .sys_in      (io_in[CORE_IN_PORTS-1-i]),               // External input pin
        .from_bsc_in (i == 0 ? tdi : bsc_chain[(BSC_COUNT)-i]),// Previous scan cell / TDI

        .capture_dr  (bsr_capture_dr),
        .update_dr   (bsr_update_dr),
        .shift_dr    (bsr_shift_dr),

        .mode_ctrl   (mode),

        .sys_out     (io_logic_in[CORE_IN_PORTS-1-i]),      // Input towards core
        .to_bsc_out  (bsc_chain[BSC_COUNT-1-i])             // Next scan cell
      );
    end


    //----------------------------------------------------------------------
    // Output-side Boundary Scan Cells
    //
    // Scan path:
    //      ... -> Output BSC[n/2] -> ... -> Output BSC[0] -> TDO
    //----------------------------------------------------------------------
    for (i = 0; i < CORE_OUT_PORTS; i++) begin
      bsc bsc_out(
        .tclk        (tclk),

        .sys_in      (io_logic_out[CORE_OUT_PORTS-1-i]),   // Core output
        .from_bsc_in (i==0 ? bsc_chain[BSC_COUNT-CORE_IN_PORTS] :
                   bsc_chain[(BSC_COUNT - CORE_IN_PORTS)-i]),  // Previous scan cell

        .capture_dr  (bsr_capture_dr),
        .update_dr   (bsr_update_dr),
        .shift_dr    (bsr_shift_dr),
        .mode_ctrl   (mode),

        .sys_out     (io_out[CORE_OUT_PORTS-1-i]),              // External output pin
        .to_bsc_out  (bsc_chain[(BSC_COUNT-CORE_IN_PORTS-1)-i]) // Next scan cell
      );
    end

  endgenerate


  //--------------------------------------------------------------------------
  // TDO Multiplexer
  // Routes the currently selected Test Data Register to the TAP serial output.
  //--------------------------------------------------------------------------
  always_comb
  begin
    case (tdr_selected)

      TDR_IDCODE :
        tdo = id_code_ser_out;

      TDR_BYPASS :
        tdo = bypass_reg;

      TDR_BSR :
        tdo = bsc_chain[0];   // Last Boundary Scan Cell

      TDR_RUNBIST :
        tdo = 0;

      default :
        tdo = 0;

    endcase
  end

endmodule : TDR