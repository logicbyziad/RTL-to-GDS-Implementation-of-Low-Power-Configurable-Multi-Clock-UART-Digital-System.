module DATA_SYNC#(parameter NUM_STAGES = 8,  parameter BUS_WIDTH = 8)(

	input	wire	[BUS_WIDTH - 1:0]	unsync_bus,
	input	wire						RST,
	input	wire						CLK,
	input	wire						bus_enable,
	output	reg		[BUS_WIDTH - 1:0]	sync_bus,
	output	reg							enable_pulse

);

reg		[NUM_STAGES - 1: 0]		data_FF;
reg		[NUM_STAGES - 2: 0]		count;
wire							gen_pulse;
reg								bus_en_reg;


//Multi FF Block & enable_pulse
always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		enable_pulse <= 'b0;
		bus_en_reg   <= 'b0;
		data_FF		 <= 'b0;
	 end

	else
	 begin
		
		data_FF[NUM_STAGES-1] <= bus_enable;
		
		for(count = NUM_STAGES - 1; count > 0; count = count - 1)
		 begin
			data_FF[count-1] <= data_FF[count];
		 end

		bus_en_reg   <= data_FF[0];
		enable_pulse <= gen_pulse;

	 end

end

//Mux and FF for sync_bus output
always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		sync_bus <= 'b0;
	 end

	else if(gen_pulse)
	 begin
		sync_bus <= unsync_bus;
	 end

end

//Pulse Generator Block
assign	gen_pulse = !bus_en_reg & data_FF[0];


endmodule