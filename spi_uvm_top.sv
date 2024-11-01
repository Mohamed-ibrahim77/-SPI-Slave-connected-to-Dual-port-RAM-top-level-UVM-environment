import spi_test_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();

	bit clk;

	initial begin
		forever begin
			#1 clk = ~clk;
		end
	end

SPI_if SPI_if_inst (clk);
SPI_Design DUT(SPI_if_inst.MOSI,SPI_if_inst.MISO,SPI_if_inst.SS_n,SPI_if_inst.clk,SPI_if_inst.rst_n,
			   SPI_if_inst.rx_valid,SPI_if_inst.rx_data,SPI_if_inst.tx_valid,SPI_if_inst.tx_data);
		       // SPI_Design DUT(SPI_if_inst); is wrong

initial begin
	uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF", SPI_if_inst);
	run_test("spi_test"); //same name of test class
end

bind SPI_Design SPI_SVA SVA_inst(SPI_if_inst);

endmodule 
