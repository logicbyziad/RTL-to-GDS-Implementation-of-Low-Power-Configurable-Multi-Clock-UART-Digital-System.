module RST_SYNC#(parameter NUM_STAGES = 3)(

	input	wire	RST,
	input	wire	CLK,
	output	reg		SYNC_RST

);

reg		[NUM_STAGES - 1: 0]		shift_FF;
reg		[NUM_STAGES - 2: 0]		count;

always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		SYNC_RST <= 'b1;
		shift_FF <= 'b0;
		count	 <= 'b0;
	 end

	else
	 begin
		shift_FF[NUM_STAGES-1] <= 'b1;
		
		for(count = NUM_STAGES - 1; count > 0; count = count - 1)
		 begin
			shift_FF[count-1] <= shift_FF[count]; 
		 end

		SYNC_RST <= shift_FF[0] ;
		
	 end

end

endmodule