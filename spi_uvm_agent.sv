package spi_agent_pkg;
	
	import spi_config_obj_pkg::*;
	import spi_driver_pkg::*;
	import spi_monitor_pkg::*;
	import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class spi_agent extends uvm_agent;
		`uvm_component_utils(spi_agent)
		
		//virtual SPI_if spi_agent_vif;
		spi_sequencer spi_sqr;
		spi_driver spi_drv;
		spi_monitor spi_mon;
		spi_config_obj spi_config_obj_agent;
		//spi_sequence_item spi_stim_seq_item;
		uvm_analysis_port #(spi_sequence_item) spi_agt_ap; //cause of error (port not export) 

		function new(string name = "spi_agent", uvm_component parent = null);
			super. new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			if(!uvm_config_db #(spi_config_obj)::get(this,"","CFG", spi_config_obj_agent)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get the configuration object");
			end
		
			spi_agt_ap = new("spi_agt_ap",this); //missing creating analysis port {error}

			spi_sqr = spi_sequencer::type_id::create(spi_sqr,this);				
			spi_drv = spi_driver::type_id::create(spi_drv,this);				
			spi_mon = spi_monitor::type_id::create(spi_mon,this);				

			//spi_agent_vif = spi_config_obj_agent.spi_config_vif;
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			
			spi_drv.spi_driver_vif = spi_config_obj_agent.spi_config_vif;
			//spi_drv.spi_agent_vif = spi_config_obj_agent.spi_config_vif; is wrong
			
			spi_mon.spi_monitor_vif = spi_config_obj_agent.spi_config_vif;
			//spi_mon.spi_agent_vif = spi_config_obj_agent.spi_agent_vif; is wrong

			spi_drv.seq_item_port.connect(spi_sqr.seq_item_export);
		endfunction 

	endclass	

endpackage