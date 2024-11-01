module RAM_SVA(RAM_if RAM_if_inst);

sequence A;
	((RAM_if_inst.din[9] == 1'b1) && (RAM_if_inst.din[8] == 1'b1));
endsequence

property tx_valid_chk_11;
	@(posedge RAM_if_inst.clk) A |-> ##1 $rose(RAM_if_inst.tx_valid) |-> ##1 $fell(RAM_if_inst.tx_valid);
endproperty

tx_chk_11: cover property(tx_valid_chk_11);
tx_asser_11: assert property(tx_valid_chk_11);

sequence B;
	((RAM_if_inst.din[9] == 1'b0) && (RAM_if_inst.din[8] == 1'b0)) || ((RAM_if_inst.din[9] == 1'b0) && (RAM_if_inst.din[8] == 1'b1));
endsequence

property tx_valid_chk_00_01;
	@(posedge RAM_if_inst.clk) B |=> !(RAM_if_inst.tx_valid);
endproperty

tx_chk_00_01: cover property(tx_valid_chk_00_01);
tx_asser_00_01: assert property(tx_valid_chk_00_01);

sequence C;
	((RAM_if_inst.din[9] == 1'b1) && (RAM_if_inst.din[8] == 1'b0));
endsequence

property tx_valid_chk_10;
	@(posedge RAM_if_inst.clk) C |-> ##1 (RAM_if_inst.tx_valid == 0);
endproperty

tx_chk_10: cover property(tx_valid_chk_10);
tx_asser_10: assert property(tx_valid_chk_10);

endmodule