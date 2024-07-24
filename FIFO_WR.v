module FIFO_WR #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 4)(

	input	wire							W_CLK,
	input	wire							W_RST,
	input	wire							W_INC,
	input	wire	[FIFO_DEPTH-1:0]		wq2_rptr,
	output	wire							W_FULL,
	output	reg		[FIFO_DEPTH-2:0]		W_ADDR,
	output	reg		[FIFO_DEPTH-1:0]		W_PTR
	
);

always@(posedge W_CLK or negedge W_RST)
begin
	
	if(!W_RST)
	 begin
		W_ADDR	<= 'b0;
		W_PTR	<= 'b0;
	 end

	else if(W_INC)
	 begin	 
		W_ADDR <= W_PTR[FIFO_DEPTH-2:0];
		W_PTR  <= W_PTR + 1;
	 end
	 
end

assign W_FULL = (W_PTR[FIFO_DEPTH-1] != wq2_rptr[FIFO_DEPTH-1]) && (W_PTR[FIFO_DEPTH-2:0] == wq2_rptr[FIFO_DEPTH-2:0]);


endmodule