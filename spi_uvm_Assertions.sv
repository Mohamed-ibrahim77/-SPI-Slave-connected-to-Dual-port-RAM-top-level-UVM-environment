module SPI_SVA(SPI_if.DUT SPI_if_inst);

mosi_asssert_write : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.mosi==0 |=> SPI_if_inst.mosi==0);
mosi_asssert_read  : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.mosi==1 |=> SPI_if_inst.mosi==1);

ram_data_in_assert : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.MOSI === SPI_if_inst.rx_data);
ram_data_out_assert : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.tx_data === SPI_if_inst.MISO);

valid_assert : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.SS_n |-> (SPI_if_inst.rx_valid == 0 && SPI_if_inst.tx_valid ==0));

write_assert : assert property (@(posedge SPI_if_inst.clk) (SPI_if_inst.SS_n==0 && SPI_if_inst.MOSI==0) |-> ##10 SPI_if_inst.rx_valid );
read_add_data_assert : assert property (@(posedge SPI_if_inst.clk) (SPI_if_inst.SS_n==0 && SPI_if_inst.MOSI==1) |=> SPI_if_inst.cs==3'b011 ##[1:3]SPI_if_inst.cs==3'b100);

ram_tx_valid : assert property (@(posedge SPI_if_inst.clk) SPI_if_inst.tx_valid |-> SPI_if_inst.cs == 3'b100);

reset_assert : assert property(@(posedge SPI_if_inst.clk) SPI_if_inst.rst_n==0 |-> SPI_if_inst.cs == 3'b000);

endmodule