module BIT_SYNC#(parameter NUM_STAGES = 3,  parameter BUS_WIDTH = 8)(

	input	wire	[BUS_WIDTH - 1:0]	ASYNC,
	input	wire						RST,
	input	wire						CLK,
	output	reg		[BUS_WIDTH - 1:0]	SYNC

);

reg		[NUM_STAGES - 1: 0]		data_FF		[BUS_WIDTH - 1:0];
reg		[NUM_STAGES - 2: 0]		count;		//Length of chain loop variable
reg		[BUS_WIDTH - 1: 0]		n;			//No. of chains loop variable

always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		SYNC    <= 'b0;
		count	<= 'b0;
		
		for (n = 0; n < BUS_WIDTH; n = n + 1)		//To clear memory if bus width is > 1
		 begin
            data_FF[n] <= 'b0;
		 end
	 
	 end

	else if(BUS_WIDTH == 'b1)			//If Output is only 1 bit
	 begin
		data_FF[NUM_STAGES-1] <= ASYNC;
		
		for(count = NUM_STAGES - 1; count > 0; count = count - 1)
		 begin
			data_FF[count-1] <= data_FF[count]; 
		 end

		SYNC <= data_FF[0] ;
		
	 end

	

	else								//If Output & Input is a bus
	 begin
		
		for(n = 0; n < BUS_WIDTH; n = n + 1)
		 begin
			
			data_FF[n][NUM_STAGES-1] <= ASYNC[n];
		
			for(count = NUM_STAGES - 1; count > 0; count = count - 1)
			begin
				data_FF[n][count-1] <= data_FF[n][count]; 
			end 
			
			SYNC[n] <= data_FF[n][0];

		 end
	 end

end

endmodule