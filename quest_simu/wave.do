onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/tclk
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/trst
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/tdi
add wave -noupdate /jtag_tb_top/jtag_top_inst/tap_fsm_curr_state
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/tdr_selected
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/tdo
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/id_code_par_out
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/id_code_ser_out
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/bypass_reg
add wave -noupdate /jtag_tb_top/jtag_top_inst/ir_hold_reg
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/capture_dr_en
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/shift_dr_en
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/update_dr_en
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/mode
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/bsr_capture_dr
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/bsr_shift_dr
add wave -noupdate /jtag_tb_top/jtag_top_inst/tdr/bsr_update_dr
add wave -noupdate -radix binary /jtag_tb_top/jtag_top_inst/tdr/bsc_chain
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {876 ns} 0}
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
WaveRestoreZoom {2720 ns} {3720 ns}
