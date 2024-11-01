package spi_scoreboard_pkg;
	
	import spi_config_obj_pkg::*;
	import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class spi_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(spi_scoreboard)
		
		//virtual SPI_if spi_scoreboard_vif;
		//spi_config_obj spi_config_obj_driver;
		spi_sequence_item spi_seq_item_sb;
		uvm_analysis_export #(spi_sequence_item) spi_sb_export;
		uvm_tlm_analysis_fifo #(spi_sequence_item) spi_sb_fifo;

		logic [7:0] spi_out_ref;

		int error_count = 0;
		int correct_count = 0;

		function new(string name = "spi_scoreboard", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			spi_sb_export = new("spi_sb_export",this);
			spi_sb_fifo = new("spi_sb_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase (phase);
			
			spi_sb_export.connect(spi_sb_fifo.analysis_export);			
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				spi_sb_fifo.get(spi_seq_item_sb);

		//	    reference_model(spi_seq_item_sb);

				if (spi_seq_item_sb.MISO != spi_out_ref) begin
					`uvm_error("run_phase", $sformatf("comparsion failed, transaction recieved by the DUT :%s while the ref out :0b%0b",
							    spi_seq_item_sb.convert2string(), spi_out_ref));
					error_count ++;
				end
				else begin
					`uvm_info("run_phase", $sformatf("correct MISO :%s",spi_seq_item_sb.convert2string()), UVM_HIGH);
					correct_count ++;
				end
			end
		endtask
	
		//------------------------------------------------------------
		// virtual spi_if spi_sb_vif;
		// spi_config_obj spi_config_obj_inst;
		// paspieter MEM_DEPTH = 256;
		// paspieter ADDR_SIZE = 8;
 
		// logic [ADDR_SIZE-1:0] addr_rd, addr_wr;
		// logic [7:0] mem [MEM_DEPTH-1:0];
		// //------------------------------------------------------------

		// task reference_model(spi_sequence_item seq_item_chk);
		// 	if (seq_item_chk.rst_n == 1) begin
		// 		spi_out_ref = 0;
		// 	end

		// 	else if (seq_item_chk.rx_valid) begin
		// 			if (seq_item_chk.din[9:8] == 2'b00) begin
		// 				addr_wr <= seq_item_chk.din[7:0];
		// 				seq_item_chk.tx_valid <= 0;
		// 			end
		// 			else if (seq_item_chk.din[9:8] == 2'b01) begin
		// 				mem [addr_wr] <= seq_item_chk.din[7:0];
		// 				seq_item_chk.tx_valid <= 0;
		// 			end
		// 			else if (seq_item_chk.din[9:8] == 2'b10) begin
		// 				addr_rd <= seq_item_chk.din[7:0];
		// 				seq_item_chk.tx_valid <= 0;
		// 			end
		// 			else if (seq_item_chk.din[9:8] == 2'b11) begin
		// 				spi_out_ref <= mem[addr_rd];
		// 				seq_item_chk.tx_valid <= 1;
		// 			end
		// 			else begin
		// 				spi_out_ref <= 0;
		// 				seq_item_chk.tx_valid <= 0;
		// 			end
		// 	end
		// endtask : reference_model

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);

			`uvm_info("report_phase", $sformatf("total correct transactions : %0d",correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("total failed transactions : %0d",error_count), UVM_MEDIUM);

		endfunction : report_phase

	endclass

endpackage
