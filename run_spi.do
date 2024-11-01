vlib work
vlog -f source_files_spi.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/SPI_if_inst/*
run -all

#run 0
#quit -sim
#vcover report SPI_Design.ucdb -details -annotate -all -output spi_coverage_rpt.txt  