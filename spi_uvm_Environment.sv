package spi_env_pkj;

	import spi_config_obj_pkg::*;
	import spi_agent_pkg::*;
	import spi_scoreboard_pkg::*;
	import spi_cov_collector_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_env extends  uvm_env;
	
		`uvm_component_utils(spi_env)

		spi_agent spi_agt;
		spi_cov_collector spi_cov;
		spi_scoreboard spi_sb;

		function new(string name = "spi_env",uvm_component parent = null);
			super.new(name, parent);
		endfunction 
	
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			// spi_driver = spi_driver::type_id::create("spi_driver",this);
			// spi_sqr = spi_sequencer::type_id::create("spi_sqr",this);
			spi_agt = spi_agent::type_id::create("spi_agt",this);
			spi_cov = spi_cov_collector::type_id::create("spi_cov",this);
			spi_sb = spi_scoreboard::type_id::create("spi_sb",this);

		endfunction : build_phase 
	
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase); // cause of error

			//spi_agt.agt_ap.connect(spi_sb.sb_export);
			spi_agt.spi_agt_ap.connect(spi_sb.spi_sb_export);

			//spi_agt.agt_ap.connect(spi_cov.cov_export);
			spi_agt.spi_agt_ap.connect(spi_cov.spi_cov_export);

		endfunction : connect_phase
	
	endclass 

endpackage 