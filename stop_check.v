module	stop_check #(parameter stop_bit_value = 1)(

input	wire		CLK,	
input	wire		RST,
input	wire		sampled_bit,
input	wire		stp_chk_en,
output	reg			stp_err

);


always @(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		stp_err <= 'b0;
	 end
	
	else if (stp_chk_en)
	 begin
		
		if(sampled_bit == stop_bit_value)
		stp_err <= 'b0;
		
		else
		stp_err <= 'b1;
		
	 end
end

endmodule