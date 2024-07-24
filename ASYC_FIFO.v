module ASYC_FIFO#(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 4)(

	input	wire							W_CLK,
	input	wire							W_RST,
	input	wire							W_INC,
	input	wire							R_CLK,
	input	wire							R_RST,
	input	wire							R_INC,
	input	wire	[DATA_WIDTH-1:0]		WR_DATA,
	output	wire	[DATA_WIDTH-1:0]		RD_DATA,
	output	wire							W_FULL,
	output	wire							R_EMPTY
	
);

wire	[FIFO_DEPTH-2:0]	W_ADDR, R_ADDR;
wire	[FIFO_DEPTH-1:0]	rq2_wptr, wq2_rptr;
wire	[FIFO_DEPTH-1:0]	R_PTR, W_PTR;


FIFO_MEM_CNTRL U_FIFOMEM(
.W_ADDR(W_ADDR),
.R_ADDR(R_ADDR),
.W_INC(W_INC),
.W_CLK(W_CLK),
.W_FULL(W_FULL),
.WR_DATA(WR_DATA),
.RD_DATA(RD_DATA)
);


DF_SYNC U_sync_r2w(
.CLK(W_CLK),
.RST(W_RST),
.ptr_in(R_PTR),
.ptr_out(wq2_rptr)
);


DF_SYNC U_sync_w2r(
.CLK(R_CLK),
.RST(R_RST),
.ptr_in(W_PTR),
.ptr_out(rq2_wptr)
);


FIFO_WR U_FIFO_WR(
.W_CLK(W_CLK),
.W_RST(W_RST),
.W_INC(W_INC),
.wq2_rptr(wq2_rptr),
.W_FULL(W_FULL),
.W_ADDR(W_ADDR),
.W_PTR(W_PTR)
);


FIFO_RD U_FIFO_RD(
.R_CLK(R_CLK),
.R_RST(R_RST),
.R_INC(R_INC),
.rq2_wptr(rq2_wptr),
.R_EMPTY(R_EMPTY),
.R_ADDR(R_ADDR),
.R_PTR(R_PTR)
);

endmodule