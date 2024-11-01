package ram_monitor_pkg;
	
	import ram_config_obj_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class ram_monitor extends uvm_monitor;
		`uvm_component_utils(ram_monitor)
		
		virtual RAM_if ram_monitor_vif;
		//ram_config_obj ram_config_obj_driver;
		ram_sequence_item ram_rsp_seq_item;
		uvm_analysis_port #(ram_sequence_item) mon_an_prt;

		function new(string name = "ram_monitor", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			mon_an_prt = new("mon_an_prt",this);
		endfunction

		task run_phase(uvm_phase phase);
			// ram_monitor_vif.rst_n = 0;
			// @(negedge ram_monitor_vif.clk);
			// ram_monitor_vif.rst_n = 1;
			super.run_phase(phase);

			forever begin
				ram_rsp_seq_item = ram_sequence_item::type_id::create("ram_rsp_seq_item");

				@(negedge ram_monitor_vif.clk);				

				ram_rsp_seq_item.rx_valid = ram_monitor_vif.rx_valid;
				ram_rsp_seq_item.rst_n = ram_monitor_vif.rst_n;
				ram_rsp_seq_item.din = ram_monitor_vif.din;
					
				mon_an_prt.write(ram_rsp_seq_item);
				`uvm_info("run_phase", ram_rsp_seq_item.convert2string(), UVM_HIGH)					
			end
		endtask
	
	endclass

endpackage
