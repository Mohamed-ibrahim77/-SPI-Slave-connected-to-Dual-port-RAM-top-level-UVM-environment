vlib work
vlog -f source_files_ram.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/RAM_if_inst/*
run -all

#run 0
#quit -sim
#vcover report RAM_Design.ucdb -details -annotate -all -output ram_coverage_rpt.txt  