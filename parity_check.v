module parity_check(

input	wire			CLK,
input	wire			RST,
input	wire			PAR_TYP,			// Even 0, Odd 1
input	wire			par_chk_en,
input	wire			sampled_bit,
input	wire	[7:0]	P_DATA,
output	reg				par_err

);

wire is_odd_par = ^P_DATA;

always @(posedge CLK or negedge RST)
begin
	if(!RST)
	 begin
		par_err <= 'b0;
	 end
	else if (par_chk_en)
	 begin
		
		if(PAR_TYP)				//Odd
		 begin
			par_err <= (is_odd_par != sampled_bit);
		 end
		 
		else					//Even
		 begin
			par_err <= (is_odd_par == sampled_bit);		 
		 end
		 
	 end
end

endmodule