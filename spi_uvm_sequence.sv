package spi_sequence_pkg;
	
	import spi_config_obj_pkg::*;
	//import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_write_sequence extends uvm_sequence #(spi_sequence_item);
		`uvm_component_utils(spi_write_sequence)

		parameter test_case = 256;
		
		bit [7:0] dyn_addr [] = new[test_case]; // dynamic array to carry randmoized addresses
		bit [7:0] dyn_data [] = new[test_case]; // dynamic array to carry randmoized data

		spi_sequence_item spi_seq_item;
		virtual SPI_if spi_wr_seq_vif;
			
		function new(string name = "spi_write_sequence");
			super.new(name);
		endfunction
		
		virtual task body();

			spi_seq_item = spi_sequence_item::type_id::create("spi_seq_item");
			
			//-----------------------------------------
			assert(spi_seq_item.randomize());
			//-----------------------------------------

			for(int i = 0 ; i < test_case ; i++) begin
		        dyn_addr[i] = spi_seq_item.addr;
		        dyn_data[i] = spi_seq_item.data;
		        //s1.DIN_CHK.sample();
		    end
			repeat(500) begin

			start_item(spi_seq_item);

			spi_seq_item.rx_valid = 1'b1;
			for(int i = 0 ; i < test_case ; i++) begin
		        spi_seq_item.din = { 2'b00,dyn_addr[i] };
		        @(negedge spi_wr_seq_vif.clk);
		        spi_seq_item.din = { 2'b01,dyn_data[i] };
		        @(negedge spi_wr_seq_vif.clk);
		    end
		    spi_seq_item.rx_valid = 1'b0;

			finish_item(spi_seq_item);

			end
		endtask : body

	endclass : spi_write_sequence

endpackage : spi_sequence_pkg