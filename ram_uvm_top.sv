import ram_test_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();

	bit clk;

	initial begin
		forever begin
			#1 clk = ~clk;
		end
	end

RAM_if RAM_if_inst (clk);
// RAM_Design DUT(RAM_if_inst.din, RAM_if_inst.rst_n, RAM_if_inst.clk, RAM_if_inst.dout,
// 		       RAM_if_inst.rx_valid, RAM_if_inst.tx_valid);
RAM_Design DUT(RAM_if_inst); 

initial begin
	uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", RAM_if_inst);
	run_test("ram_test"); //same name of test class
end

bind RAM_Design RAM_SVA SVA_inst(RAM_if_inst);

endmodule 
