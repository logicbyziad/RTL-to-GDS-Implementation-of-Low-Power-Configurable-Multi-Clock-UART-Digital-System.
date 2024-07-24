module RegFile#(parameter DATA_WIDTH = 8, parameter ADDRESS_WIDTH = 4) (

	input	wire	[DATA_WIDTH-1:0]		WrData,
	input	wire	[ADDRESS_WIDTH-1:0]		Address,
	input	wire							WrEn,
	input	wire							RdEn,
	input	wire							CLK,
	input	wire							RST,
	output	reg		[DATA_WIDTH-1:0]		RdData,
	output	reg		[DATA_WIDTH-1:0]		REG0,			//A
	output	reg		[DATA_WIDTH-1:0]		REG1,			//B
	output	reg		[DATA_WIDTH-1:0]		REG2,			//UART Config 
	output	reg		[DATA_WIDTH-1:0]		REG3,			//Div Ratio
	output	reg								RdData_Valid

);

reg [DATA_WIDTH-1:0]	Reg_File  [15:0];
integer n;		

always@(posedge CLK or negedge RST)
begin

	if(!RST)
	 begin
		RdData_Valid <= 'b0 ;
		RdData       <= 'b0 ;
		for (n=0 ; n < 16 ; n = n +1)
			begin
			if(n==2)
			Reg_File[n] <= 'b010000_01 ;
			else if (n==3) 
			Reg_File[n] <= 'b0010_0000 ;
			else
			Reg_File[n] <= 'b0 ;		 
			end
	 end
	 
	else if(WrEn && !RdEn) 
		
		begin
		  Reg_File[Address] <= WrData;
		end
	
	else if(RdEn && !WrEn)
          
		begin
          RdData <= Reg_File[Address];
		  REG0	 <= Reg_File[0];
		  REG1	 <= Reg_File[1];
		  REG2	 <= Reg_File[2];
		  REG3	 <= Reg_File[3];
		  RdData_Valid <= 'b1;
        end

end


endmodule