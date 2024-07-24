module data_sampling(

input	wire			CLK,
input	wire			RST,
input	wire			RX_IN,
input	wire			dat_samp_en,
input	wire	[4:0]	edge_cnt,
input	wire	[5:0]	Prescale,		//Easy 16, Hard 8.16.32
output	reg				sampled_bit

);

wire 	[1:0]	sample;
wire	[5:0]	halfedge;
reg				S0, S1, S2;

always@(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		S0 <= 'b0;
		S1 <= 'b0;
		S2 <= 'b0;
	 end
	
	else if (dat_samp_en)
	 begin
		if (edge_cnt == (halfedge - 1))
			S0 <= RX_IN;
	
		else if (edge_cnt == halfedge )
			S1 <= RX_IN;
		
		else if (edge_cnt == (halfedge + 1) )
			S2 <= RX_IN;

	 end
	 
end


always @(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		sampled_bit <= 'b0;
	 end
	
	else if (dat_samp_en)
	 begin
		
		if((sample >= 'd2) && (edge_cnt == Prescale - 1))
			sampled_bit <= 'b1;
		else if ((sample <= 'd2) && (edge_cnt == Prescale - 1))
			sampled_bit <= 'b0;		
		 
	 end
end

assign	halfedge   = Prescale >> 1;
assign	sample     = S0 + S1 + S2 ;

endmodule