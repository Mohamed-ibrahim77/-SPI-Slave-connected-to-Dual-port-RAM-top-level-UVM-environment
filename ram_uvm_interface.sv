interface RAM_if (clk);
input bit clk;

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

logic rx_valid, rst_n;
logic [9:0] din;

logic tx_valid;
logic [7:0] dout;

endinterface