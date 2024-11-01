package ram_write_sequence_pkg;
	
	import ram_config_obj_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_write_sequence extends uvm_sequence #(ram_sequence_item);
		`uvm_component_utils(ram_write_sequence)

		ram_sequence_item ram_seq_item;
			
		function new(string name = "ram_write_sequence");
			super.new(name);
		endfunction

		virtual task body();
			repeat(1000) begin

			ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

			start_item(ram_seq_item);

			ram_seq_item.rx_valid = 1'b1;
			repeat (256) begin
				ram_seq_item.din = { 2'b00,dyn_addr[i] };
		        @(negedge ram_seq_item.clk);
		        
		        ram_seq_item.din = { 2'b01,dyn_data[i] };
		        @(negedge ram_seq_item.clk);
			end
		    ram_seq_item.rx_valid = 1'b0;

			finish_item(ram_seq_item);

			end
		endtask : body

	endclass : ram_write_sequence

endpackage : ram_write_sequence_pkg