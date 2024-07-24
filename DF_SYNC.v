module DF_SYNC #(parameter DATA_WIDTH = 8,  parameter FIFO_DEPTH = 4)(

	input	wire							CLK,
	input	wire							RST,
	input	wire	[FIFO_DEPTH-1:0]		ptr_in,
	output	reg		[FIFO_DEPTH-1:0]		ptr_out
	
);

reg		[FIFO_DEPTH-1:0]	meta_FF;
reg		[FIFO_DEPTH-1:0]	sync_FF;
reg  [FIFO_DEPTH:0]   n;

always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		meta_FF	<= 'b0;
		sync_FF <= 'b0;
		ptr_out	<= 'b0;
	 end

	else
	 begin
		for(n = (FIFO_DEPTH-1); n > 0; n = n-1)
		 begin
			meta_FF[n] <= ptr_in[n];
			sync_FF[n] <= meta_FF[n];
			ptr_out[n] <= sync_FF[n];
		 end
	 end

end

endmodule