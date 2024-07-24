module SYS_TOP(

	input	wire				REF_CLK,
	input	wire				RST,
	input	wire				UART_CLK,
	input	wire				RX_IN,
	output	wire				TX_OUT,
	output	wire				par_err,
	output	wire				stp_err

);

wire			RX_CLK, TX_CLK, ALU_CLK;
wire			UART_RST, SYNC_RST;

wire			busy, FIFO_FULL;

wire			ALU_EN, CLK_EN, clk_div_en;

wire			R_INC, Wr_Inc, WrEn, RdEn;

wire			data_valid, TX_D_VLD, OUT_VALID, RdData_Valid;

wire	[7:0]	TX_P_DATA, Div_Ratio, WrData, RdData, RX_P_Data, P_DATA, RD_DATA, REG0, REG1, REG2, REG3;

wire	[15:0]	ALU_OUT;

wire	[3:0]	ALU_FUN, Address;



//////////////////////////////////////////////////////////

UART_TOP U0_UART (
.RST(UART_RST),
.TX_CLK(TX_CLK),
.RX_CLK(RX_CLK),
.parity_enable(REG2[0]),
.parity_type(REG2[1]),
.Prescale(REG2[7:2]),
.RX_IN_S(RX_IN),
.RX_OUT_P(P_DATA),                      
.RX_OUT_V(data_valid),                      
.TX_IN_P(RD_DATA), 
.TX_IN_V(!F_EMPTY), 
.TX_OUT_S(TX_OUT),
.TX_OUT_V(busy),
.parity_error(par_err),
.framing_error(stp_err)                  
);

////////////////////////////////////////////////////////////

PULSE_GEN U_pulsegen(
.RST(UART_RST),
.CLK(TX_CLK),
.LVL_SIG(busy),
.PULSE_SIG(R_INC)
);


DATA_SYNC U_datasync(
.CLK(REF_CLK),
.RST(SYNC_RST),
.unsync_bus(P_DATA),
.bus_enable(data_valid),
.sync_bus(RX_P_Data),
.enable_pulse(RX_D_VLD)
);


SYS_CTRL U_sysctrl(
.ALU_OUT(ALU_OUT),
.OUT_VALID(OUT_VALID),
.RX_P_Data(RX_P_Data),
.RX_D_VLD(RX_D_VLD),
.RdData(RdData),
.RdData_Valid(RdData_Valid),
.CLK(REF_CLK),
.RST(SYNC_RST),
.ALU_FUN(ALU_FUN),
.ALU_EN(ALU_EN),
.CLK_EN(CLK_EN),
.Address(Address),
.WrEn(WrEn),
.RdEn(RdEn),
.Wr_Inc(Wr_Inc),	
.WrData(WrData),
.TX_P_DATA(TX_P_DATA),
.TX_D_VLD(TX_D_VLD),
.clk_div_en(clk_div_en),
.FIFO_FULL(FIFO_FULL)
);


RegFile U_regfile(
.WrData(WrData),
.Address(Address),
.WrEn(WrEn),
.RdEn(RdEn),
.CLK(REF_CLK),
.RST(SYNC_RST),
.RdData(RdData),
.REG0(REG0),
.REG1(REG1),
.REG2(REG2),
.REG3(REG3),
.RdData_Valid(RdData_Valid)
);


ALU U_ALU(
.A(REG0),
.B(REG1),
.ALU_FUN(ALU_FUN),
.ALU_EN(ALU_EN),
.CLK(ALU_CLK),
.RST(SYNC_RST),
.ALU_OUT(ALU_OUT),
.OUT_VALID(OUT_VALID)
);


CLK_GATE U_clkgate(
.CLK(REF_CLK),
.CLK_EN(CLK_EN),
.GATED_CLK(ALU_CLK)
);


RST_SYNC U_rstsync_uart(
.RST(RST),
.CLK(UART_CLK),
.SYNC_RST(UART_RST)
);


RST_SYNC U_rstsync_ref(
.RST(RST),
.CLK(REF_CLK),
.SYNC_RST(SYNC_RST)
);


ClkDiv U_clkdiv_tx(
.i_ref_clk(UART_CLK),	
.i_rst_n(UART_RST),	
.i_clk_en(clk_div_en),	
.i_div_ratio(REG3),
.o_div_clk(TX_CLK)
);


ClkDiv U_clkdiv_rx(
.i_ref_clk(UART_CLK),	
.i_rst_n(UART_RST),	
.i_clk_en(clk_div_en),	
.i_div_ratio(Div_Ratio),
.o_div_clk(RX_CLK)
);


ASYC_FIFO U_fifo(
.W_CLK(REF_CLK),
.W_RST(SYNC_RST),
.W_INC(Wr_Inc),
.R_CLK(TX_CLK),
.R_RST(UART_RST),
.R_INC(R_INC),
.WR_DATA(WrData),
.RD_DATA(RD_DATA),
.W_FULL(FIFO_FULL),
.R_EMPTY(F_EMPTY)
);

CLKDIV_MUX U_prescalemux(
.IN(REG2[7:2]),
.OUT(Div_Ratio)
);


endmodule