module edge_bit_counter (

input	wire			CLK,
input	wire			RST,
input	wire			edge_cnt_en,
input	wire	[5:0]	Prescale,		//Easy 8, Hard 16.32
output	reg		[3:0]	bit_cnt,
output	reg		[4:0]	edge_cnt

);


always @(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		bit_cnt  <= 'b0;
		edge_cnt <= 'b0;
	 end
	
	else if (edge_cnt_en)
	 begin
		
		if(edge_cnt == (Prescale - 1))
		 begin
			bit_cnt  <= bit_cnt + 1;
			edge_cnt <= 'b0;
		 end
			
		else
		 begin
			edge_cnt <= edge_cnt + 1;
		 end
		
	 end

	else
	 begin
		bit_cnt  <= 'b0;
		edge_cnt <= 'b0;
	 end
	 
end


endmodule