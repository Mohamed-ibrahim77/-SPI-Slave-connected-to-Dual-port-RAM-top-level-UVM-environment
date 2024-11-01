package ram_env_pkj;

	import ram_config_obj_pkg::*;
	import ram_agent_pkg::*;
	import ram_scoreboard_pkg::*;
	import ram_cov_collector_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_env extends  uvm_env;
	
		`uvm_component_utils(ram_env)

		ram_agent ram_agt;
		ram_cov_collector ram_cov;
		ram_scoreboard ram_sb;

		function new(string name = "ram_env",uvm_component parent = null);
			super.new(name, parent);
		endfunction 
	
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			// ram_driver = ram_driver::type_id::create("ram_driver",this);
			// ram_sqr = ram_sequencer::type_id::create("ram_sqr",this);
			ram_agt = ram_agent::type_id::create("ram_agt",this);
			ram_cov = ram_cov_collector::type_id::create("ram_cov",this);
			ram_sb = ram_scoreboard::type_id::create("ram_sb",this);

		endfunction : build_phase 
	
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase); // cause of error

			//ram_agt.agt_ap.connect(ram_sb.sb_export);
			ram_agt.ram_agt_ap.connect(ram_sb.ram_sb_export);

			//ram_agt.agt_ap.connect(ram_cov.cov_export);
			ram_agt.ram_agt_ap.connect(ram_cov.ram_cov_export);

		endfunction : connect_phase
	
	endclass 

endpackage 