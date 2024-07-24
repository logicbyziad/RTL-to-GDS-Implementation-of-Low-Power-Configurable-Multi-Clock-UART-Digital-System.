module ClkDiv#(parameter ratio_bit_width = 8) (

	input	wire							i_ref_clk,		//reference freq
	input	wire							i_rst_n,		//Active low asynch rst
	input	wire							i_clk_en,		//ClkDiv enable
	input	wire  [ratio_bit_width - 1:0]	i_div_ratio,	//Divided ratio(integer)
	output	wire							o_div_clk		//divided clock output

);

wire	[ratio_bit_width - 2:0]	half_ratio;		//Divides ratio by 2 for clock division ratio
wire	[ratio_bit_width - 2:0]	half_ratio_dec;	//Decrements half_ratio by 1
reg		[ratio_bit_width - 2:0]	counter;
reg								div_clk;
reg								odd_flag;
wire							odd;			//LSB of ratio
wire							CLK_DIV_EN;		//Enable after checking ratio is not zero or one


always@ (posedge i_ref_clk or negedge i_rst_n)
 begin
	
	if (!i_rst_n)						//Reset Block
	 begin
		counter  <=  'b0;
		div_clk  <= 1'b0;
		odd_flag <= 1'b0;
	 end
	 
	else if (CLK_DIV_EN && !odd && (counter == half_ratio_dec))		//Even Block
	 begin
		counter   <=  'b0;
		div_clk <= !div_clk;
	 end

	else if ((CLK_DIV_EN && odd && (counter == half_ratio) && !odd_flag) || (CLK_DIV_EN && odd && (counter == half_ratio_dec) && odd_flag))		//Odd Block
	 begin
		counter  <=  'b0;
		div_clk  <= !div_clk;
		odd_flag <= !odd_flag;
	 end
	
	else								//Loop(increment) Counter
	 begin
		counter <= counter + 1;
	 end	
	 
 end
 
assign	CLK_DIV_EN = i_clk_en && (i_div_ratio != 0) &&  (i_div_ratio != 1);	//Makes sure ratio is not 1 or 0
assign	odd = i_div_ratio[0];												//Identifies if ratio is odd or even
assign	half_ratio = (i_div_ratio >> 1) ;									//Divides ratio by 2
assign	half_ratio_dec = (half_ratio) - 1;									//decrement half ratio
assign	o_div_clk = CLK_DIV_EN ? div_clk : i_ref_clk ;						//Makes output follow reference clock if enable isn't active
 
endmodule