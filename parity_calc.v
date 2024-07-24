module parity_calc (

	input	wire	[7:0]	P_DATA_par,			//High for odd, Low for even
	input	wire			DATA_VALID_par,
	input	wire			PAR_TYP_par,
	input	wire			CLK,
	input	wire			RST,
	output	reg				par_bit

);

wire		parity_value;


assign parity_value = ^P_DATA_par;		// 0 for even and 1 for odd

always@(posedge CLK or negedge RST)
begin
	if (!RST)
		par_bit <= 1'b0;
		
	else if (DATA_VALID_par && PAR_TYP_par)		//Odd parity
		par_bit <= parity_value;
		
	else if (DATA_VALID_par && !PAR_TYP_par)	//Even parity
		par_bit <= !parity_value;

end

endmodule