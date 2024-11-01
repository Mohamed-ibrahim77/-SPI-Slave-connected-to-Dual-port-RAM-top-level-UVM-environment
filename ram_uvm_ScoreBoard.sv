package ram_scoreboard_pkg;
	
	import ram_config_obj_pkg::*;
	import ram_sequencer_pkg::*;
	import ram_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class ram_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(ram_scoreboard)
		
		//virtual RAM_if ram_scoreboard_vif;
		//ram_config_obj ram_config_obj_driver;
		ram_sequence_item ram_seq_item_sb;
		uvm_analysis_export #(ram_sequence_item) ram_sb_export;
		uvm_tlm_analysis_fifo #(ram_sequence_item) ram_sb_fifo;

		logic [7:0] ram_out_ref;

		int error_count = 0;
		int correct_count = 0;

		function new(string name = "ram_scoreboard", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			ram_sb_export = new("ram_sb_export",this);
			ram_sb_fifo = new("ram_sb_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase (phase);
			
			ram_sb_export.connect(ram_sb_fifo.analysis_export);			
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				ram_sb_fifo.get(ram_seq_item_sb);

				reference_model(ram_seq_item_sb);

				if (ram_seq_item_sb.dout != ram_out_ref) begin
					`uvm_error("run_phase", $sformatf("comparsion failed, transaction recieved by the DUT :%s while the ref out :0b%0b",
							    ram_seq_item_sb.convert2string(), ram_out_ref));
					error_count ++;
				end
				else begin
					`uvm_info("run_phase", $sformatf("correct ram dout :%s",ram_seq_item_sb.convert2string()), UVM_HIGH);
					correct_count ++;
				end
			end
		endtask
	
		//------------------------------------------------------------
		// virtual RAM_if ram_sb_vif;
		// ram_config_obj ram_config_obj_inst;
		parameter MEM_DEPTH = 256;
		parameter ADDR_SIZE = 8;
 
		logic [ADDR_SIZE-1:0] addr_rd, addr_wr;
		logic [7:0] mem [MEM_DEPTH-1:0];
		//------------------------------------------------------------

		task reference_model(ram_sequence_item seq_item_chk);
			if (seq_item_chk.rst_n == 1) begin
				ram_out_ref = 0;
			end

			else if (seq_item_chk.rx_valid) begin
					if (seq_item_chk.din[9:8] == 2'b00) begin
						addr_wr <= seq_item_chk.din[7:0];
						seq_item_chk.tx_valid <= 0;
					end
					else if (seq_item_chk.din[9:8] == 2'b01) begin
						mem [addr_wr] <= seq_item_chk.din[7:0];
						seq_item_chk.tx_valid <= 0;
					end
					else if (seq_item_chk.din[9:8] == 2'b10) begin
						addr_rd <= seq_item_chk.din[7:0];
						seq_item_chk.tx_valid <= 0;
					end
					else if (seq_item_chk.din[9:8] == 2'b11) begin
						ram_out_ref <= mem[addr_rd];
						seq_item_chk.tx_valid <= 1;
					end
					else begin
						ram_out_ref <= 0;
						seq_item_chk.tx_valid <= 0;
					end
			end
		endtask : reference_model

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);

			`uvm_info("report_phase", $sformatf("total correct transactions : %0d",correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("total failed transactions : %0d",error_count), UVM_MEDIUM);

		endfunction : report_phase

	endclass

endpackage
