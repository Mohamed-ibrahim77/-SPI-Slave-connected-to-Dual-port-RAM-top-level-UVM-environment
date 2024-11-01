package ram_write_sequence_pkg;
	
	import ram_config_obj_pkg::*;
	//import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_write_sequence extends uvm_sequence #(ram_sequence_item);
		`uvm_component_utils(ram_write_sequence)

		parameter test_case = 256;
		
		bit [7:0] dyn_addr [] = new[test_case]; // dynamic array to carry randmoized addresses
		bit [7:0] dyn_data [] = new[test_case]; // dynamic array to carry randmoized data

		ram_sequence_item ram_seq_item;
		virtual RAM_if ram_wr_seq_vif;
			
		function new(string name = "ram_write_sequence");
			super.new(name);
		endfunction
		
		virtual task body();

			ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");
			
			//-----------------------------------------
			assert(ram_seq_item.randomize());
			//-----------------------------------------

			for(int i = 0 ; i < test_case ; i++) begin
		        dyn_addr[i] = ram_seq_item.addr;
		        dyn_data[i] = ram_seq_item.data;
		        //s1.DIN_CHK.sample();
		    end
			repeat(500) begin

			start_item(ram_seq_item);

			ram_seq_item.rx_valid = 1'b1;
			for(int i = 0 ; i < test_case ; i++) begin
		        ram_seq_item.din = { 2'b00,dyn_addr[i] };
		        @(negedge ram_wr_seq_vif.clk);
		        ram_seq_item.din = { 2'b01,dyn_data[i] };
		        @(negedge ram_wr_seq_vif.clk);
		    end
		    ram_seq_item.rx_valid = 1'b0;

			finish_item(ram_seq_item);

			end
		endtask : body

	endclass : ram_write_sequence

endpackage : ram_write_sequence_pkg