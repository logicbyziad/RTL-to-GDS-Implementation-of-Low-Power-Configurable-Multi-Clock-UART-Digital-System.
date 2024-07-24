module PULSE_GEN(

	input	wire		RST,
	input	wire		CLK,
	input	wire		LVL_SIG,
	output	reg			PULSE_SIG

);

reg		pulse_FF;
wire	gen_pulse;

always@(posedge CLK or negedge RST)
begin

	if(!RST)
	 begin
		PULSE_SIG <= 'b0;
	 end
	 
	else
	 begin
		pulse_FF  <= LVL_SIG;
		PULSE_SIG <= gen_pulse;
	 end

end

assign gen_pulse = LVL_SIG & !pulse_FF;

endmodule