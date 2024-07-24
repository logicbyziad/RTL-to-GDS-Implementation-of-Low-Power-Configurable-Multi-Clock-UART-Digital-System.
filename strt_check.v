module	strt_check(

input	wire		CLK,	
input	wire		RST,
input	wire		RX_IN,
input	wire		strt_chk_en,
output	reg			strt_glitch

);


always @(posedge CLK or negedge RST)
begin
	
	if(!RST)
	 begin
		strt_glitch <= 'b0;
	 end
	
	else if (strt_chk_en)
	 begin
		
		if(!RX_IN)
		strt_glitch <= 'b0;
		
		else
		strt_glitch <= 'b1;
		
	 end
end

endmodule