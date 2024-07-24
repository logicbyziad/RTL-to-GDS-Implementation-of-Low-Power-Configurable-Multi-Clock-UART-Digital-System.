vlib work

vlog	FIFO_MEM_CNTRL.v DF_SYNC.v FIFO_WR.v FIFO_RD.v ASYC_FIFO.v \
		BIT_SYNC.v RST_SYNC.v DATA_SYNC.v ClkDiv.v PULSE_GEN.v CLKDIV_MUX.v \
		UART_RX.v FSM_RX.v edge_bit_counter.v parity_check.v strt_check.v stop_check.v deserializer.v data_sampling.v \
		UART_TX.v serializer.v FSM_TX.v parity_calc.v multiplexer.v UART_TOP.v \
		SYS_CTRL.v SYS_TOP.v RegFile.v ALU.v CLK_GATE.v SYS_TOP_TB_2.v

vsim -voptargs=+acc work.SYS_TOP_TB_2

add wave * 

run -all