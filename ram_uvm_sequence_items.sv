package ram_sequence_item_pkg;
	
	import ram_config_obj_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_sequence_item extends uvm_sequence_item;
		
		`uvm_object_utils(ram_sequence_item);

		randc bit [7:0] addr;
		rand  bit [7:0] data;

		rand logic rx_valid, rst_n;
		rand logic [9:0] din;

		logic tx_valid;
		logic [7:0] dout;

		function new(string name  = "ram_sequence_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s reset = 0b%0b, rx_valid = 0b%0b, din = 0b%0b, tx_valid = 0b%0b, dout = 0b%0b",
							  super.convert2string(), rst_n, rx_valid, din, tx_valid, dout);
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf(" reset = 0b%0b, rx_valid = 0b%0b, din = 0b%0b, tx_valid = 0b%0b, dout = 0b%0b",
							   rst_n, rx_valid, din, tx_valid, dout);
		endfunction : convert2string_stimulus

		//constraints blocks

	endclass 

endpackage 