//module RAM_Design (din, rst_n, clk, dout, rx_valid, tx_valid);  
module RAM_Design (RAM_if ) ;

	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	 input logic rx_valid, rst_n,clk;
	 input logic [9:0] din;

	 output logic tx_valid;
	 output logic [7:0] dout;

	reg [ADDR_SIZE-1:0] addr_rd, addr_wr;
	reg [7:0] mem [MEM_DEPTH-1:0];
	
	always @(posedge clk or negedge rst_n) begin

		if (!rst_n) begin
			for (int i = 0 ; i < MEM_DEPTH ; i = i + 1) begin 
				mem [i] <= 0;   
			end		
			dout <= 0;    
			tx_valid <= 0;
			addr_rd <= 0;       
			addr_wr <= 0;  
		end

		else if (rx_valid) begin
			if (din[9:8] == 2'b00) begin
				addr_wr <= din[7:0];
				tx_valid <= 0;
			end
			else if (din[9:8] == 2'b01) begin
				mem [addr_wr] <= din[7:0];
				tx_valid <= 0;
			end
			else if (din[9:8] == 2'b10) begin
				addr_rd <= din[7:0];
				tx_valid <= 0;
			end
			else if (din[9:8] == 2'b11) begin
				dout <= mem[addr_rd];
				tx_valid <= 1;
			end
			else begin
				dout <= 0;
				tx_valid <= 0;
			end
		end 
	end
endmodule