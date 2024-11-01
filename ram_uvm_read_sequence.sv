package ram_read_sequence_pkg;
	
	import ram_write_sequence_pkg::*;	
	import ram_config_obj_pkg::*;
	import ram_sequence_item_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_read_sequence extends uvm_sequence #(ram_sequence_item);
		`uvm_component_utils(ram_read_sequence)

		parameter test_case = 256;
		
		bit [7:0] dyn_addr [] = new[test_case]; // dynamic array to carry randmoized addresses
		bit [7:0] dyn_data [] = new[test_case]; // dynamic array to carry randmoized data

		ram_sequence_item ram_seq_item;
		virtual RAM_if ram_rd_seq_vif;
		
		function new(string name = "ram_read_sequence");
			super.new(name);
		endfunction

		virtual task body();
			repeat(1000) begin

			ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

			start_item(ram_seq_item);

			ram_seq_item.rx_valid = 1'b1;
		    for(int i = 0 ; i < test_case ; i++) begin
		        
		        ram_seq_item.din = { 2'b10,dyn_addr[i] };
		        @(negedge ram_rd_seq_vif.clk);
		        ram_seq_item.din = { 2'b11,8'b11111111 };
		        @(posedge ram_rd_seq_vif.tx_valid);
		        
		    end
			finish_item(ram_seq_item);

			end
		endtask : body

	endclass : ram_read_sequence

endpackage : ram_read_sequence_pkg