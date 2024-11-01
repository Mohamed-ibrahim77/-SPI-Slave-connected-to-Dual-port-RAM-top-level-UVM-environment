package ram_cov_collector_pkg;
	
	import ram_config_obj_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class ram_cov_collector extends uvm_component;
		`uvm_component_utils(ram_cov_collector)
		
		//virtual RAM_if ram_cov_collector_vif;
		//ram_config_obj ram_config_obj_driver;
		ram_sequence_item ram_seq_item_cov;
		uvm_analysis_export #(ram_sequence_item) ram_cov_export;
		uvm_tlm_analysis_fifo #(ram_sequence_item) ram_cov_fifo;

		//covergroups & coverpoints
		// covergroup DIN_CHK;
		//     addr_cp : coverpoint addr
		//     {
		//         bins max_addr = {255};
		//         bins zero_addr = {0};
		//         bins others = default;
		//     }
		// endgroup

		function new(string name = "ram_cov_collector", uvm_component parent = null);
			super. new(name, parent);
			
			//create cov grs
			//DIN_CHK = new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			ram_cov_export = new("ram_cov_export",this);
			ram_cov_fifo = new("ram_cov_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase (phase);
			
			ram_cov_export.connect(ram_cov_fifo.analysis_export);			
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				ram_cov_fifo.get(ram_seq_item_cov);

				//cov gr sample calls
			end
		endtask
	
	endclass

endpackage
