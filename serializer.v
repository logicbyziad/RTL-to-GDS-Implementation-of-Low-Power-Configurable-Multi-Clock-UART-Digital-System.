module serializer # (parameter cnt_max = 8) (

	input	wire	[7:0]	P_DATA_ser,
	input	wire			DATA_VALID_ser,
	input	wire			ser_en,
	input	wire			CLK,
	input	wire			RST,
	output	wire  			ser_done,
	output	reg				ser_data

);

	reg		[7:0]		Data_reg;
	reg		[3:0]		counter;
	

always @(posedge CLK or negedge RST)
begin

	if (!RST)
		begin
		ser_data <= 1'b1;			//IDLE value is high
	  end
	  
	else if (DATA_VALID_ser)
	    begin
		Data_reg <= P_DATA_ser ;
		end
		
	else if (ser_en)	
	  begin
		{Data_reg[6:0],ser_data} <= Data_reg ;		//LSB to MSB
	  end
	  	
end

always @(posedge CLK or negedge RST)
begin

	if (!RST)
	  begin
		counter  <= 'b0;
	  end
	
	else if (ser_done)
	  begin
		counter  <= 'b0;
	  end
	  
	else if (ser_en)
	  begin
		counter <= counter + 1;
	  end

end

assign  ser_done =  (counter == cnt_max);

	
endmodule