module multiplexer (

	input			CLK,
	input			RST,
	input	[2:0]	mux_sel,
	input			ser_data,
	input			par_bit,
	output	reg		TX_OUT
	
);

localparam		start = 1'b0,
				stop  = 1'b1,
				IDLE  = 1'b1;


always@(posedge CLK or negedge RST)
begin
	if(!RST)
	 begin
		TX_OUT <= 1'b1;
	 end
	else
	 begin		
		case(mux_sel)
		3'b000	:	begin
					TX_OUT <= start;	  //start bit
					end

		3'b101	:	begin
					TX_OUT <= stop ;	  //stop bit
					end
					
		3'b001	:	begin
					TX_OUT <= ser_data;	  //data stream
					end
					
		3'b011	:	begin
					TX_OUT <= par_bit  ;  //parity bit
					end
					
		3'b100	:	begin
					TX_OUT <= IDLE ;	  //IDLE high
					end
		
		default	:	begin
					TX_OUT <= IDLE ;	  //IDLE high
					end
		endcase
	 end
end

endmodule