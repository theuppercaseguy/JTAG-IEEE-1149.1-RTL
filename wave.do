onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group JTAG_INF -radix binary /jtag_tb_top/jtag_intf/tclk
add wave -noupdate -expand -group JTAG_INF /jtag_tb_top/jtag_intf/trst
add wave -noupdate -expand -group JTAG_INF /jtag_tb_top/jtag_intf/tms
add wave -noupdate -expand -group JTAG_INF /jtag_tb_top/jtag_intf/tdi
add wave -noupdate -expand -group JTAG_INF /jtag_tb_top/jtag_intf/tdo
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/TCK
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/TRST
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/TMS
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/tap_state
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/curr_state
add wave -noupdate -expand -group TAP_GSM /jtag_tb_top/jtag_top_inst/tap_fsm_inst/next_state
add wave -noupdate -expand -group Decoder /jtag_tb_top/jtag_top_inst/tdr_inst/instr_decoder_i/ir_reg
add wave -noupdate -expand -group Decoder /jtag_tb_top/jtag_top_inst/tdr_inst/instr_decoder_i/mode_ctrl
add wave -noupdate -expand -group Decoder /jtag_tb_top/jtag_top_inst/tdr_inst/instr_decoder_i/tdr_selected
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/clk
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/rst_n
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/state
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/ser_in
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/par_in
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/ser_out
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/par_out
add wave -noupdate -expand -group idocode_TDR /jtag_tb_top/jtag_top_inst/tdr_inst/shift_idcode_reg/shift_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {167 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 378
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {34 ns} {1256 ns}
