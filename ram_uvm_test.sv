package ram_test_pkg;

	import ram_env_pkj::*;
	import ram_config_obj_pkg::*;
	import ram_write_sequence_pkg::*;
	import ram_read_sequence_pkg::*;
	import ram_reset_sequence_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_test extends  uvm_test;
		`uvm_component_utils(ram_test)

		ram_env env;  // ram_env wrong it must be the same name of env class(ram_env) 
		ram_config_obj ram_config_obj_test;
		virtual RAM_if ram_test_vif;
		ram_write_sequence write_seq;
		ram_read_sequence read_seq;
		ram_reset_sequence reset_seq;
		//ram_write_read_sequence write_read_seq;

		function new (string name = "ram_test",uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			
			env = ram_env::type_id::create("env",this); 	
			ram_config_obj_test = ram_config_obj:: type_id:: create("ram_config_obj_test");
			write_seq = ram_write_sequence:: type_id:: create("write_seq");
			read_seq = ram_read_sequence:: type_id:: create("read_seq");
			reset_seq = ram_reset_sequence:: type_id:: create("reset_seq");

			//write_read_seq = ram_write_read_sequence:: type_id:: create("write_read_seq",this);

			if(!uvm_config_db#(virtual RAM_if):: get(this,"","RAM_IF", ram_config_obj_test.ram_config_vif))
				`uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the ram from the uvm_config_db");

			uvm_config_db#(virtual ram_config_obj):: set(this," ∗ ","CFG", ram_config_obj_test);

		endfunction  

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			
			phase.raise_objection(this);
			#100;
			
			`uvm_info("run_phase","reset asserted",UVM_MEDIUM)
			reset_seq.start(env.ram_agt.ram_sqr);
			`uvm_info("run_phase","rest deasserted",UVM_MEDIUM)

			`uvm_info("run_phase","Inside the ram write_seq",UVM_MEDIUM)
			write_seq.start(env.ram_agt.ram_sqr);
			`uvm_info("run_phase","Inside the ram write_seq",UVM_MEDIUM)

			`uvm_info("run_phase","Inside the ram read_seq",UVM_MEDIUM)
			read_seq.start(env.ram_agt.ram_sqr);
			`uvm_info("run_phase","Inside the ram read_seq",UVM_MEDIUM)

			// `uvm_info("run_phase","Inside the ram write_read_seq",UVM_MEDIUM)
			// write_read_seq.start(env.ram_agt.ram_sqr);
			// `uvm_info("run_phase","Inside the ram write_read_seq",UVM_MEDIUM)

			phase.drop_objection(this);
		endtask  

	endclass 

endpackage 