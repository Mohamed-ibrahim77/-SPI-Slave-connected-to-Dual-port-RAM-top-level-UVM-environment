package ram_agent_pkg;
	
	import ram_config_obj_pkg::*;
	import ram_driver_pkg::*;
	import ram_monitor_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class ram_agent extends uvm_agent;
		`uvm_component_utils(ram_agent)
		
		//virtual RAM_if ram_agent_vif;
		ram_sequencer ram_sqr;
		ram_driver ram_drv;
		ram_monitor ram_mon;
		ram_config_obj ram_config_obj_agent;
		//ram_sequence_item ram_stim_seq_item;
		uvm_analysis_port #(ram_sequence_item) ram_agt_ap; //cause of error (port not export) 

		function new(string name = "ram_agent", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			if(!uvm_config_db #(ram_config_obj)::get(this,"","CFG", ram_config_obj_agent)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get the configuration object");
			end
		
			ram_agt_ap = new("ram_agt_ap",this); //missing creating analysis port {error}

			ram_sqr = ram_sequencer::type_id::create(ram_sqr,this);				
			ram_drv = ram_driver::type_id::create(ram_drv,this);				
			ram_mon = ram_monitor::type_id::create(ram_mon,this);				

			//ram_agent_vif = ram_config_obj_agent.ram_config_vif;
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			
			ram_drv.ram_driver_vif = ram_config_obj_agent.ram_config_vif;
			//ram_drv.ram_agent_vif = ram_config_obj_agent.ram_config_vif; is wrong
			
			ram_mon.ram_monitor_vif = ram_config_obj_agent.ram_config_vif;
			//ram_mon.ram_agent_vif = ram_config_obj_agent.ram_agent_vif; is wrong

			ram_drv.seq_item_port.connect(ram_sqr.seq_item_export);
		endfunction 

	endclass	

endpackage