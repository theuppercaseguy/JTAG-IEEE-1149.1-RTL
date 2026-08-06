onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group jtag_inf /ijtag_tb_top/jtag_intf/trst
add wave -noupdate -expand -group jtag_inf /ijtag_tb_top/jtag_intf/tclk
add wave -noupdate -expand -group jtag_inf /ijtag_tb_top/jtag_intf/tdi
add wave -noupdate -expand -group jtag_inf /ijtag_tb_top/jtag_intf/tdo
add wave -noupdate -expand -group jtag_inf /ijtag_tb_top/jtag_intf/tms
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/tap_fsm_curr_state
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/instr_decoder_i/tdr_selected
add wave -noupdate -radix binary /ijtag_tb_top/ijtag_top_inst/instr_reg/shift_reg
add wave -noupdate -radix binary /ijtag_tb_top/ijtag_top_inst/instr_reg/ir_hold_reg
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/capture_en
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/shift_en
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/update_en
add wave -noupdate -group decoder /ijtag_tb_top/ijtag_top_inst/instr_decoder_i/mode_ctrl
add wave -noupdate -group decoder /ijtag_tb_top/ijtag_top_inst/instr_decoder_i/ijtag_sib_sel
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib1_val
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib2_val
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib3_val
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib4_val
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib5_val
add wave -noupdate -expand -group SIBS /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib6_val
add wave -noupdate -expand -group TDRs -label tdr1_shift_reg -radix binary /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/tdr_1/shift_reg
add wave -noupdate -expand -group TDRs -label tdr2_shift_reg -radix binary /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/tdr_2/shift_reg
add wave -noupdate -expand -group TDRs -label tdr3_shift_reg -radix binary /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/tdr_3/shift_reg
add wave -noupdate -expand -group TDRs -label tdr4_shift_reg -radix binary /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/tdr_4/shift_reg
add wave -noupdate -expand -group TDRs -label tdr5_shift_reg -radix binary /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/tdr_5/shift_reg
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/si
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/from_so
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/sel
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/so
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/to_si
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/to_sel
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/sib_val
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/cap_reg
add wave -noupdate -group SIB_1 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_1/upd_reg
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/sel
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/si
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/to_si
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/from_so
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/so
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/to_sel
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/sib_val
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/cap_reg
add wave -noupdate -group SIB_2 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_2/upd_reg
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/si
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/from_so
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/sel
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/so
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/to_si
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/to_sel
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/sib_val
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/cap_reg
add wave -noupdate -group SIB_3 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_3/upd_reg
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/si
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/from_so
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/sel
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/so
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/to_si
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/to_sel
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/sib_val
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/cap_reg
add wave -noupdate -group SIB_4 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_4/upd_reg
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/si
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/from_so
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/sel
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/so
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/to_si
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/to_sel
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/sib_val
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/cap_reg
add wave -noupdate -group SIB_5 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_5/upd_reg
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/si
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/from_so
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/sel
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/so
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/to_si
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/to_sel
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/sib_val
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/cap_reg
add wave -noupdate -group SIB_6 /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/sib_6/upd_reg
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR1_WIDTH
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR1_RST_VAL
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR2_WIDTH
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR2_RST_VAL
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR3_WIDTH
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR3_RST_VAL
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR4_WIDTH
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR4_RST_VAL
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR5_WIDTH
add wave -noupdate /ijtag_tb_top/ijtag_top_inst/ijtag_netwrok/TDR5_RST_VAL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8253752 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7758458 ps} {9751924 ps}
