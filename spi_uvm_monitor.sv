package spi_monitor_pkg;
	
	import spi_config_obj_pkg::*;
	import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class spi_monitor extends uvm_monitor;
		`uvm_component_utils(spi_monitor)
		
		virtual SPI_if spi_monitor_vif;
		//spi_config_obj spi_config_obj_driver;
		spi_sequence_item spi_rsp_seq_item;
		uvm_analysis_port #(spi_sequence_item) mon_an_prt;

		function new(string name = "spi_monitor", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			mon_an_prt = new("mon_an_prt",this);
		endfunction

		task run_phase(uvm_phase phase);
			// spi_monitor_vif.rst_n = 0;
			// @(negedge spi_monitor_vif.clk);
			// spi_monitor_vif.rst_n = 1;
			super.run_phase(phase);

			forever begin
				spi_rsp_seq_item = spi_sequence_item::type_id::create("spi_rsp_seq_item");

				@(negedge spi_monitor_vif.clk);				

				spi_rsp_seq_item.SS_n = spi_monitor_vif.SS_n;
				spi_rsp_seq_item.rst_n = spi_monitor_vif.rst_n;
				spi_rsp_seq_item.data[9:0] = spi_monitor_vif.rx_data;
					
				mon_an_prt.write(spi_rsp_seq_item);
				`uvm_info("run_phase", spi_rsp_seq_item.convert2string(), UVM_HIGH)					
			end
		endtask
	
	endclass

endpackage
