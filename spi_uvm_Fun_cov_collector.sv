package spi_cov_collector_pkg;
	
	import spi_config_obj_pkg::*;
	import spi_sequencer_pkg::*;
	import spi_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	
	class spi_cov_collector extends uvm_component;
		`uvm_component_utils(spi_cov_collector)
		
		virtual SPI_if spi_cov_collector_vif;
		//spi_config_obj spi_config_obj_driver;
		spi_sequence_item spi_seq_item_cov;
		uvm_analysis_export #(spi_sequence_item) spi_cov_export;
		uvm_tlm_analysis_fifo #(spi_sequence_item) spi_cov_fifo;

	//covergroups & coverpoints
	//-----------------------------------------------------------------------------
		covergroup cvr_grp2;
        
         SS_N_cp:coverpoint spi_cov_collector_vif.SS_n{
            bins high={1};
            bins low={0};
         }
       
         rst_n_cp:coverpoint spi_cov_collector_vif.rst_n{
            bins active={0};
            bins non_active={1};
         }
   
         rx_data_cp:coverpoint spi_cov_collector_vif.rx_data[9:8]{
            bins write_address={2'b00};
            bins write_data={2'b01};
            bins read_addr={2'b10};
            bins read_data={2'b11};
         }

         rx_valid_cp:coverpoint spi_cov_collector_vif.rx_valid{
            bins high={1};
            bins low={0};
         }
         
         rx_valid_with_rst: cross rx_valid_cp,rst_n_cp{   
            ignore_bins rx_valid_activated_rst=binsof(rx_valid_cp.high)&&binsof(rst_n_cp.active);
         }

         rx_data_with_rst: cross  rx_data_cp,rst_n_cp{
            ignore_bins rx_data_with_activated_rst=binsof(rx_data_cp)&&binsof(rst_n_cp.active);
         }

         
         rx_data_with_SS_N: cross rx_data_cp,SS_N_cp;
      
       endgroup
	//-----------------------------------------------------------------------------

		function new(string name = "spi_cov_collector", uvm_component parent = null);
			super. new(name, parent);
			
			//create cov grs
			cvr_grp2 = new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase (phase);
			
			spi_cov_export = new("spi_cov_export",this);
			spi_cov_fifo = new("spi_cov_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase (phase);
			
			spi_cov_export.connect(spi_cov_fifo.analysis_export);			
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				spi_cov_fifo.get(spi_seq_item_cov);

				//cov gr sample calls
     		    cvr_grp2.sample();
			end
		endtask
	
	endclass

endpackage
