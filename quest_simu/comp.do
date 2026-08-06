vlib work
vmap work work
vlog -mfcu -f ../rtl/file_list.f
vopt jtag_tb_top -o ijtag_tb_opt +acc
vsim -l sim.log -wlf sim.wlf ijtag_tb_opt
run -all
//do ijtag_wave.do
//exit