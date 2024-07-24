module UART_TX (

	input		wire	[7:0]	P_DATA,
	input		wire			DATA_VALID,
	input		wire			PAR_EN,
	input		wire			PAR_TYP,
	input		wire			CLK,
	input		wire			RST,
	output		wire			TX_OUT,
	output		wire			busy
	
);

wire		ser_done,ser_en,ser_data;			//serializer wires
wire		par_bit;							//parity calc wires
wire [2:0]	mux_sel;			//mux wires

serializer U_ser(
.P_DATA_ser(P_DATA),
.DATA_VALID_ser(DATA_VALID),
.ser_en(ser_en),
.ser_done(ser_done),
.ser_data(ser_data),
.CLK(CLK),
.RST(RST)
);

parity_calc U_parcalc(
.P_DATA_par(P_DATA),
.DATA_VALID_par(DATA_VALID),
.PAR_TYP_par(PAR_TYP),
.par_bit(par_bit),
.CLK(CLK),
.RST(RST)
);

FSM_TX U_FSM_tx(
.DATA_VALID_fsm(DATA_VALID),
.PAR_EN_fsm(PAR_EN),
.ser_done(ser_done),
.ser_en(ser_en),
.mux_sel(mux_sel),
.busy(busy),
.CLK(CLK),
.RST(RST)
);

multiplexer U_mux(
.CLK(CLK),
.RST(RST),
.mux_sel(mux_sel),
.ser_data(ser_data),
.par_bit(par_bit),
.TX_OUT(TX_OUT)
);


endmodule