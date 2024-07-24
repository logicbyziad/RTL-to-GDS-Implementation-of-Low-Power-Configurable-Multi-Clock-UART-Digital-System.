module deserializer(

input	wire			CLK,
input	wire			RST,
input	wire			sampled_bit,
input	wire			deser_en,
input	wire	[3:0]	bit_cnt,
output	reg		[7:0]	P_DATA

);

wire deser_done;
reg [7:0] data;
wire [3:0] bitcount;



always @(posedge CLK or negedge RST)
begin
	if(!RST)
	 begin
		P_DATA <= 'b0;
	 end
	else if (deser_en && !deser_done)
	 begin
		data[bitcount] <= sampled_bit;
	 end
	else if (deser_done)
	 begin
		P_DATA <= data;
	 end
	
	
end

assign bitcount = bit_cnt - 2;
assign deser_done = (bitcount == 'd8);

endmodule