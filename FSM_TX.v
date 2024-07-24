module FSM_TX (

	input	wire			DATA_VALID_fsm,
	input	wire			PAR_EN_fsm,
	input	wire			ser_done,
	input	wire			CLK,
	input	wire			RST,
	output	reg			ser_en,
	output	reg			busy,
	output	reg		[2:0]	mux_sel

);

localparam	[2:0]	par_bit	    = 3'b011,
			start_bit   = 3'b000,
			stop_bit    = 3'b101,
			serial_data = 3'b001,
			IDLE        = 3'b100;


reg		[2:0]	current_state, next_state;

always @(posedge CLK or negedge RST)
begin
	if(!RST)
	 begin
		current_state <= IDLE;
	 end
	else
	 begin
		current_state <= next_state;
	 end
end

always @(*)
begin
	
	case(current_state)
	start_bit	:	begin
					mux_sel = 3'b000;
					ser_en	= 1'b1 ;
					busy	= 1'b1 ;
					next_state = serial_data;
					end
	
	stop_bit	:	begin
					mux_sel = 3'b101;
					ser_en  = 1'b0;
					busy    = 1'b1;
					next_state = IDLE;
					end

	par_bit		:	begin
					mux_sel = 3'b011;
					ser_en	= 1'b0 ;
					busy	= 1'b1 ;
					next_state = stop_bit;
					end
	
	serial_data	:	begin
					mux_sel = 3'b001;
					ser_en  = 1'b1 ;
					busy    = 1'b1 ;
					
					if(ser_done && PAR_EN_fsm)
					next_state = par_bit;
					
					else if(ser_done && !PAR_EN_fsm) 
					next_state = stop_bit;
					
					else
					next_state = serial_data;
					
					end
	
	IDLE		:	begin
					mux_sel = 3'b100;
					ser_en = 1'b0;
					busy  = 1'b0;
					
					if (DATA_VALID_fsm)
					next_state = start_bit;
					else
					next_state = IDLE;
					
					end
	
	default		:	begin
					mux_sel = 3'b100;
					ser_en = 1'b0;
					busy   = 1'b0;
					next_state = IDLE;
					end

	endcase

end

endmodule
