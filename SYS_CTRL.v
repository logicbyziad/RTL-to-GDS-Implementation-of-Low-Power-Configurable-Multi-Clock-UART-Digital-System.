module SYS_CTRL(

	input	wire	[15:0]		ALU_OUT,
	input	wire				OUT_VALID,
	input	wire	[7:0]		RX_P_Data,
	input	wire				RX_D_VLD,
	input	wire	[7:0]		RdData,
	input	wire				RdData_Valid,
	input	wire				CLK,
	input	wire				RST,
	input	wire				FIFO_FULL,
	
	output	reg		[3:0]		ALU_FUN,
	output	reg					ALU_EN,
	output	reg					CLK_EN,
	output	reg		[3:0]		Address,
	output	reg					WrEn,
	output	reg					RdEn,
	output	reg					Wr_Inc,	
	output	reg		[7:0]		WrData,
	output	reg		[7:0]		TX_P_DATA,
	output	reg					TX_D_VLD,
	output	reg					clk_div_en
	
);


//State declaration
localparam	[3:0]	IDLE			= 'b1111,
					
					Reg_Write_Addr	= 'b1110,	
					Reg_Write_Data	= 'b1100,
					
					Reg_Read		= 'b1101,
					Reg_Read_Data	= 'b1001,
					
					ALU_Oprnd_A		= 'b1011,
					ALU_Oprnd_B		= 'b0011,
					ALU_OP_FUN		= 'b0111,	//Same for Operand and without Operand
					ALU_OP_FUN_2fr	= 'b0110,
					
					ALU_NOP			= 'b0101;		
					
					

reg	[3:0]	current_state, next_state;
					


//FSM State transition always
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
	
	//FSM States
	case(current_state)
	
	//Register Write Command
	Reg_Write_Addr	:	begin
							
							Address    = RX_P_Data[3:0];
							next_state = Reg_Write_Data;
						
						end	
		
	Reg_Write_Data	:	begin
							
							WrEn = 'b1;
							WrData = RX_P_Data;
	                        next_state = IDLE;
						
						end
	//Register Read
	Reg_Read		:	begin
						
							Address    = RX_P_Data[3:0];
							next_state = Reg_Read_Data;	
						
						end

	Reg_Read_Data	:	begin
						
						if(!FIFO_FULL)
						 begin
							RdEn = 'b1;
							TX_P_DATA = RdData;
							Wr_Inc = 'b1;
							next_state = IDLE;
							
							if(RdData_Valid) 
								TX_D_VLD  = 'b1;
							else 
								TX_D_VLD = 'b0;
						 end
						else next_state = IDLE; 
						
						end
	
	
	//ALU with Operand	
	ALU_Oprnd_A		:	begin
							
							WrEn = 'b1;
							Address = 'h0;
							WrData  = RX_P_Data;
							next_state = ALU_Oprnd_B;	
		
						end
	
	ALU_Oprnd_B		:	begin
							
							WrEn = 'b1;
							Address = 'h1;
							WrData  = RX_P_Data;
							next_state = ALU_FUN;
		
						end

	
	ALU_OP_FUN		:	begin
							if(!FIFO_FULL)
							 begin
								ALU_EN = 'b1;
								CLK_EN = 'b1;
								ALU_FUN = RX_P_Data[3:0];
								Wr_Inc = 'b1;
								
								if(OUT_VALID) 
									TX_D_VLD  = 'b1;
								else 
									TX_D_VLD = 'b0;
								
								
								if(ALU_OUT[15:8] == 'b0) 
								begin
									TX_P_DATA = ALU_OUT[7:0];
									next_state = IDLE;
								end
								else 
								begin
									next_state = ALU_OP_FUN_2fr;
								end
							 end
							 else next_state = IDLE;
		
						end
	
	ALU_OP_FUN_2fr		:	begin
							
							ALU_EN = 'b1;
							CLK_EN = 'b1;
							ALU_FUN = RX_P_Data[3:0];
							TX_P_DATA = ALU_OUT[15:8];
							Wr_Inc = 'b1;
							next_state = IDLE;
							
							if(OUT_VALID) 
								TX_D_VLD  = 'b1;
							else 
								TX_D_VLD = 'b0;
							
						end
	
	//ALU without Operand
	ALU_NOP			:	begin
							if(!FIFO_FULL)
							 begin
								ALU_EN = 'b1;
								CLK_EN = 'b1;
								ALU_FUN = RX_P_Data[3:0];
								TX_P_DATA = ALU_OUT;
								Wr_Inc = 'b1;
								next_state = IDLE;
								
								if(OUT_VALID) 
									TX_D_VLD  = 'b1;
								else 
									TX_D_VLD = 'b0;
							
							 end
							else next_state = IDLE;							 

						end
		
		
	IDLE			:	begin
							//Default Values to avoid any unintentional latches
	
							ALU_FUN    = 'b0;
							ALU_EN     = 'b0;
							CLK_EN     = 'b0;
							Address    = 'b0;
							WrEn       = 'b0;
							Wr_Inc	   = 'b0;
							RdEn       = 'b0;
							WrData     = 'b0;
							TX_P_DATA  = 'b0;
							TX_D_VLD   = 'b0;
							clk_div_en = 'b1;
							
							//Start Commands
							if(RX_D_VLD)
							begin
								case(RX_P_Data)
								'hAA	:	next_state = Reg_Write_Addr	;
								'hBB	:	next_state = Reg_Read  		;
								'hCC	:	next_state = ALU_Oprnd_A	;
								'hDD	:	next_state = ALU_NOP   		;
								default	:	next_state = IDLE	   		;
								endcase
							end
							
							else next_state = IDLE;
	
						end
		
		
		
	default			:	begin
							next_state  = IDLE;
							ALU_FUN     = 'b0;
							ALU_EN      = 'b0;
							CLK_EN      = 'b0;
							Address     = 'b0;
							WrEn        = 'b0;
							Wr_Inc	    = 'b0;
							RdEn        = 'b0;
							WrData      = 'b0;
							TX_P_DATA   = 'b0;
							TX_D_VLD    = 'b0;
							clk_div_en  = 'b1;
						end
	
	endcase

end

endmodule