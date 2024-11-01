package spi_driver_pkg;

	import spi_config_obj_pkg::*;
	import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	class spi_driver extends uvm_driver;
		`uvm_component_utils(spi_driver)
		
		virtual SPI_if spi_driver_vif;
		spi_config_obj spi_config_obj_driver;
		spi_sequence_item spi_stim_seq_item;

		function new(string name = "spi_driver", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			if(!uvm_config_db #(spi_config_obj)::get(this,"","CFG", spi_config_obj_driver)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get the configuration object")
			end
				
			//spi_driver_vif = spi_config_obj_driver.spi_config_vif;
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			spi_driver_vif = spi_config_obj_driver.spi_config_vif;
		endfunction 

		task run_phase(uvm_phase phase);
			// spi_driver_vif.rst_n = 0;
			// @(negedge spi_driver_vif.clk);
			// spi_driver_vif.rst_n = 1;
			
			forever begin
				spi_stim_seq_item = spi_sequence_item::type_id::create("spi_stim_seq_item");
				
				seq_item_port.get_next_item(spi_stim_seq_item);

				spi_driver_vif.SS_n = spi_stim_seq_item.SS_n;
				spi_driver_vif.rst_n = spi_stim_seq_item.rst_n;
				spi_driver_vif.rx_data = spi_stim_seq_item.data[9:0];
					
				@(negedge spi_driver_vif.clk);
				seq_item_port.get_next_item_done();

				`uvm_info("run_phase", spi_stim_seq_item.convert2string_stimulus(), UVM_HIGH)					
			end
		endtask
	
	endclass

endpackage
