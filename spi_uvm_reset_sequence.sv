package spi_reset_sequence_pkg;
	
	import spi_config_obj_pkg::*;
	import spi_sequence_item_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_reset_sequence extends uvm_sequence #(spi_sequence_item);
		`uvm_component_utils(spi_reset_sequence)

		spi_sequence_item spi_seq_item;
		//virtual SPI_if spi_rd_seq_vif;
		
		function new(string name = "spi_reset_sequence");
			super.new(name);
		endfunction

		virtual task body();
			spi_seq_item = spi_sequence_item::type_id::create("spi_seq_item");

			start_item(spi_seq_item);

				spi_seq_item.rst_n = 0;
				spi_seq_item.SS_n = 0;
				spi_seq_item.data = 0;
				
			finish_item(spi_seq_item);

			spi_seq_item.rst_n = 1;
		endtask : body

	endclass : spi_reset_sequence

endpackage : spi_reset_sequence_pkg