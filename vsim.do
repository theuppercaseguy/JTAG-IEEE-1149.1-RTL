vlib work
vmap work work
vlog +incdir+$env(QUESTA_HOME)/uvm-1.2/src -f ../files.f
# vlog -timescale=1ns/1ps +incdir+$env(QUESTA_HOME)/uvm-1.2/src ../rtl/jtag_package.sv ../rtl/TAP_FSM.sv
vopt jtag_tb_top -o tb_opt +acc
vsim -l sim.log -wlf sim.wlf tb_opt +UVM_TESTNAME=my_test +UVM_VERBOSITY=UVM_MEDIUM
do ../wave.do
# add wave -r /*
run -all