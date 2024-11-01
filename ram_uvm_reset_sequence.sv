package ram_reset_sequence_pkg;
	
	import ram_write_sequence_pkg::*;	
	import ram_config_obj_pkg::*;
	import ram_sequence_item_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_reset_sequence extends uvm_sequence #(ram_sequence_item);
		`uvm_component_utils(ram_reset_sequence)

		ram_sequence_item ram_seq_item;
		//virtual RAM_if ram_rd_seq_vif;
		
		function new(string name = "ram_reset_sequence");
			super.new(name);
		endfunction

		virtual task body();
			ram_seq_item = ram_sequence_item::type_id::create("ram_seq_item");

			start_item(ram_seq_item);

				ram_seq_item.rst_n = 0;
				ram_seq_item.rx_valid = 0;
				ram_seq_item.din = 0;
				
			finish_item(ram_seq_item);

			ram_seq_item.rst_n = 1;
		endtask : body

	endclass : ram_reset_sequence

endpackage : ram_reset_sequence_pkg