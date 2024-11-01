package spi_sequence_item_pkg;
	
	import spi_config_obj_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_sequence_item extends uvm_sequence_item;
		
		`uvm_object_utils(spi_sequence_item);

		rand logic SS_n;
	    rand logic [10:0] data;
	    rand logic rst_n;
	    
	    logic [9:0]rx_data;
	    logic rx_valid;
	    logic MISO;
	      
		function new(string name  = "spi_sequence_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s SS_n = 0b%0b, reset = 0b%0b, rx_valid = 0b%0b, data = 0b%0b, rx_data = 0b%0b, MISO = 0b%0b",
							  super.convert2string(), SS_n, rst_n, rx_valid, data, rx_data, MISO);
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf(" SS_n = 0b%0b, reset = 0b%0b, rx_valid = 0b%0b, data = 0b%0b, rx_data = 0b%0b, MISO = 0b%0b",
							   SS_n, rst_n, rx_valid, data, rx_data, MISO);
		endfunction : convert2string_stimulus

		//constraints blocks
		constraint c {
		
	         SS_n dist{0:=90,1:=10};
	         rst_n dist{1:=98,0:=2};
	         data[10:8] inside{3'b111,3'b110,3'b000,3'b001};
	    }
      

	endclass 

endpackage 