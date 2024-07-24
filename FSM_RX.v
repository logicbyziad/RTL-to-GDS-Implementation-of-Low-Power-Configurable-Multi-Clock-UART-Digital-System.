module FSM_RX(

input	wire			CLK,
input	wire			RST,
input	wire			RX_IN,				//IDLE high
input	wire			PAR_EN,
input	wire	[5:0]	Prescale,
input	wire	[4:0]	edge_cnt,
input	wire	[3:0]	bit_cnt,
input	wire			par_err,
input	wire			stp_err,
input	wire			strt_glitch,

output	reg			par_chk_en,
output	reg			strt_chk_en,
output	reg			stp_chk_en,
output	reg			deser_en,
output	reg			edge_cnt_en,
output	reg			dat_samp_en,
output	reg			data_valid

);

localparam	[2:0]	IDLE   = 3'b110,
					start  = 3'b010,
					data   = 3'b000,
					parity = 3'b001,
					stop   = 3'b100;


reg	[2:0]	current_state, next_state;
					

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


wire	is_valid;
assign  is_valid = (!par_err) && (!stp_err);


always @(*)
begin
	
	//Default Values to avoid any unintentional latches
	dat_samp_en = 'b0 ;
	edge_cnt_en = 'b0 ;
	strt_chk_en = 'b0 ;
	par_chk_en  = 'b0 ;
	stp_chk_en  = 'b0 ;
	deser_en    = 'b0 ;
	
	
	case(current_state)
	start		:	begin
					strt_chk_en = 'b1;
					edge_cnt_en = 'b1;
					dat_samp_en = 'b1;
					
					next_state = data;
					
					end
	
	stop		:	begin
					stp_chk_en  = 'b1;
					edge_cnt_en = 'b1;
					deser_en    = 'b1;
					dat_samp_en = 'b1;
					
					next_state = IDLE;
					
					data_valid = is_valid;
					
					end

	parity		:	begin
					par_chk_en = 'b1;
					deser_en    = 'b1;
					dat_samp_en = 'b1;
					
					next_state = stop;
					
					end
	
	data		:	begin
					edge_cnt_en = 'b1;
					dat_samp_en = 'b1;
					
					if (bit_cnt) deser_en  = 'b1;
					
					if(strt_glitch)
					next_state = IDLE;
					
					else if(PAR_EN && (bit_cnt == 10))
					next_state = parity;
					
					else if(!PAR_EN && (bit_cnt == 10))
					next_state = stop;
					
					else
					next_state = data;
					
					end
	
	IDLE		:	begin
					data_valid  = 'b0 ;
					dat_samp_en = 'b0 ;
					edge_cnt_en = 'b0 ;
					strt_chk_en = 'b0 ;
					par_chk_en  = 'b0 ;
					stp_chk_en  = 'b0 ;
					deser_en    = 'b0 ;
					
					if (!RX_IN)
					 begin
					  edge_cnt_en = 'b1;
					  next_state = start;
					 end
					else
					next_state = IDLE;
					
					end
	
	default		:	begin
					dat_samp_en = 'b0 ;
					edge_cnt_en = 'b0 ;
					strt_chk_en = 'b0 ;
					par_chk_en  = 'b0 ;
					stp_chk_en  = 'b0 ;
					deser_en    = 'b0 ;
					data_valid  = 'b0 ;
					next_state  = IDLE;
					end

	endcase

end

endmodule