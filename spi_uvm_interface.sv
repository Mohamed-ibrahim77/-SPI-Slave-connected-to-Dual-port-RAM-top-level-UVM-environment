interface SPI_if (clk);
	input bit clk;
	
	logic MOSI,SS_n,rst_n,tx_valid;
	logic [7:0]tx_data;
	
	logic MISO,rx_valid;
	logic [9:0]rx_data;

endinterface