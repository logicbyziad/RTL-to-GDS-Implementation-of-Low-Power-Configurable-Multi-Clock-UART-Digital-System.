module UART_RX (

	input	wire			RX_IN,			//IDLE high
	input	wire	[5:0]	Prescale,		//Oversample by 8 or 16 or 32
	input	wire			PAR_EN,
	input	wire			PAR_TYP,
	input	wire			CLK,
	input	wire			RST,
	output	wire	[7:0]	P_DATA,
	output	wire			data_valid,
	output	wire			par_err,
	output	wire			stp_err
	
);

wire			par_chk_en, strt_chk_en, stp_chk_en,	
				deser_en, edge_cnt_en, dat_samp_en;		//FSM enable outputs

wire			strt_glitch;			//Error Flags

wire	[3:0]	bit_cnt;								//edge bit counter output
wire	[4:0]	edge_cnt;
 
wire			sampled_bit;							//data sampler output

FSM_RX U_fsm_rx(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.Prescale(Prescale),
.dat_samp_en(dat_samp_en),
.edge_cnt(edge_cnt),
.edge_cnt_en(edge_cnt_en),
.bit_cnt(bit_cnt),
.PAR_EN(PAR_EN),
.par_chk_en(par_chk_en),
.par_err(par_err),
.strt_chk_en(strt_chk_en),
.strt_glitch(strt_glitch),
.stp_chk_en(stp_chk_en),
.stp_err(stp_err),
.data_valid(data_valid),
.deser_en(deser_en)
);

edge_bit_counter U_ebc(
.CLK(CLK),
.RST(RST),
.Prescale(Prescale),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt),
.edge_cnt_en(edge_cnt_en)
);

data_sampling U_datasampler(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.dat_samp_en(dat_samp_en),
.edge_cnt(edge_cnt),
.Prescale(Prescale),
.sampled_bit(sampled_bit)
);

parity_check U_parchk(
.CLK(CLK),
.RST(RST),
.PAR_TYP(PAR_TYP),
.sampled_bit(sampled_bit),
.par_chk_en(par_chk_en),
.P_DATA(P_DATA),
.par_err(par_err)
);

strt_check U_strtchk(
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.strt_chk_en(strt_chk_en),
.strt_glitch(strt_glitch)
);

stop_check U_stpchk(
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.stp_chk_en(stp_chk_en),
.stp_err(stp_err)
);

deserializer U_deser(
.CLK(CLK),
.RST(RST),
.bit_cnt(bit_cnt),
.sampled_bit(sampled_bit),
.deser_en(deser_en),
.P_DATA(P_DATA)
);


endmodule