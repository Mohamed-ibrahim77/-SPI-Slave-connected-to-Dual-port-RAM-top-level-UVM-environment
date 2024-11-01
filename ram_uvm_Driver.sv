package ram_driver_pkg;

	import ram_config_obj_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	class ram_driver extends uvm_driver;
		`uvm_component_utils(ram_driver)
		
		virtual RAM_if ram_driver_vif;
		ram_config_obj ram_config_obj_driver;
		ram_sequence_item ram_stim_seq_item;

		function new(string name = "ram_driver", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			if(!uvm_config_db #(ram_config_obj)::get(this,"","CFG", ram_config_obj_driver)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get the configuration object")
			end
				
			//ram_driver_vif = ram_config_obj_driver.ram_config_vif;
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			ram_driver_vif = ram_config_obj_driver.ram_config_vif;
		endfunction 

		task run_phase(uvm_phase phase);
			// ram_driver_vif.rst_n = 0;
			// @(negedge ram_driver_vif.clk);
			// ram_driver_vif.rst_n = 1;
			
			forever begin
				ram_stim_seq_item = ram_sequence_item::type_id::create("ram_stim_seq_item");
				
				seq_item_port.get_next_item(ram_stim_seq_item);

				ram_driver_vif.rx_valid = ram_stim_seq_item.rx_valid;
				ram_driver_vif.rst_n = ram_stim_seq_item.rst_n;
				ram_driver_vif.din = ram_stim_seq_item.din;
					
				@(negedge ram_driver_vif.clk);
				seq_item_port.get_next_item_done();

				`uvm_info("run_phase", ram_stim_seq_item.convert2string_stimulus(), UVM_HIGH)					
			end
		endtask
	
	endclass

endpackage
