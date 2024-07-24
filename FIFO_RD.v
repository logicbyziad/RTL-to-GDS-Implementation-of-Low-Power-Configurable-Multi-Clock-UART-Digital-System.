module FIFO_RD #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 4)(

	input	wire							R_CLK,
	input	wire							R_RST,
	input	wire							R_INC,
	input	wire	[FIFO_DEPTH-1:0]		rq2_wptr,
	output	reg 	[FIFO_DEPTH-2:0]		R_ADDR,
	output	reg		[FIFO_DEPTH-1:0]		R_PTR,
	output	wire							R_EMPTY
	
);

always@(posedge R_CLK or negedge R_RST)
begin
	
	if(!R_RST)
	 begin
		R_ADDR	<= 'b0;
		R_PTR	<= 'b0;
	 end

	else if(R_INC)
	 begin
		R_ADDR <= R_PTR[FIFO_DEPTH-2:0];
		R_PTR  <= R_PTR + 1;
	 end

end


assign R_EMPTY = (R_PTR[FIFO_DEPTH-1] != rq2_wptr[FIFO_DEPTH-1]) && (R_PTR[FIFO_DEPTH-2:0] == rq2_wptr[FIFO_DEPTH-2:0]);


endmodule