module FIFO_MEM_CNTRL #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 4)(

	input	wire	[FIFO_DEPTH-2:0]		W_ADDR,
	input	wire	[FIFO_DEPTH-2:0]		R_ADDR,
	input	wire							W_INC,
	input	wire							W_CLK,
	input	wire							W_FULL,
	input	wire	[DATA_WIDTH-1:0]		WR_DATA,
	output	reg		[DATA_WIDTH-1:0]		RD_DATA
	
);

reg		[DATA_WIDTH-1:0]	memory		[FIFO_DEPTH-1:0];
wire	W_CLK_EN;

always@(posedge W_CLK)
begin

	RD_DATA <= memory[R_ADDR];
	
	if(W_CLK_EN)
	 begin
		memory[W_ADDR] <= WR_DATA;
	 end
	 
end


assign W_CLK_EN = W_INC & !W_FULL;

endmodule