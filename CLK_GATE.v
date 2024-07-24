module CLK_GATE(

	input	wire	CLK,
	input	wire	CLK_EN,
	output	wire	GATED_CLK	

);

assign GATED_CLK = CLK_EN? CLK : 0; 

endmodule