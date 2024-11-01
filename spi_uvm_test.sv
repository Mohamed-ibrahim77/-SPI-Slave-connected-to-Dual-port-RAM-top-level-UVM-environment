package spi_test_pkg;

	import spi_env_pkj::*;
	import spi_config_obj_pkg::*;
//	import spi_sequence_pkg::*;
	import spi_reset_sequence_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_test extends  uvm_test;
		`uvm_component_utils(spi_test)

		spi_env env;  // spi_env wrong it must be the same name of env class(spi_env) 
		spi_config_obj spi_config_obj_test;
		virtual SPI_if spi_test_vif;
//		spi_sequence spi_seq;
		spi_reset_sequence reset_seq;
		
		function new (string name = "spi_test",uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			
			env = spi_env::type_id::create("env",this); 	
			spi_config_obj_test = spi_config_obj:: type_id:: create("spi_config_obj_test");
//			spi_seq = spi_spi_sequence:: type_id:: create("spi_seq");
			reset_seq = spi_reset_sequence:: type_id:: create("reset_seq");

			if(!uvm_config_db#(virtual spi_if):: get(this,"","spi_IF", spi_config_obj_test.spi_config_vif))
				`uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the spi from the uvm_config_db");

			uvm_config_db#(virtual spi_config_obj):: set(this," ∗ ","CFG", spi_config_obj_test);

		endfunction  

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			
			phase.raise_objection(this);
			#100;
			
			`uvm_info("run_phase","reset asserted",UVM_MEDIUM)
			reset_seq.start(env.spi_agt.spi_sqr);
			`uvm_info("run_phase","rest deasserted",UVM_MEDIUM)

//          `uvm_info("run_phase","Inside the spi spi_seq",UVM_MEDIUM)
//          spi_seq.start(env.spi_agt.spi_sqr);
//          `uvm_info("run_phase","Inside the spi spi_seq",UVM_MEDIUM)

			phase.drop_objection(this);
		endtask  

	endclass 

endpackage 