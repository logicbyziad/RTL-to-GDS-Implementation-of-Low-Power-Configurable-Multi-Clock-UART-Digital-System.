module ALU#(parameter DATA_WIDTH = 8, parameter FN_WIDTH = 4)(

	input	wire	[DATA_WIDTH-1:0]		A,
	input	wire	[DATA_WIDTH-1:0]		B,
	input	wire	[FN_WIDTH-1:0]			ALU_FUN,
	input	wire							ALU_EN,
	input	wire							CLK,
	input	wire							RST,
	output	reg		[2*DATA_WIDTH-1:0]		ALU_OUT,
	output	reg								OUT_VALID	

);

always@(posedge CLK or negedge RST)
begin
  
  if(!RST)
	begin
		ALU_OUT		<= 'b0;
		OUT_VALID	<= 'b0;
	end
  
  else if(ALU_EN)
	begin
		OUT_VALID <= 'b1;
		
		case(ALU_FUN)
		//Arithmatic
		4'b0000:
		begin
			ALU_OUT <= A + B;
		end
		4'b0001:
		begin
			ALU_OUT <= A - B;
		end
		4'b0010: 
		begin
			ALU_OUT <= A * B;
		end
		4'b0011:
		begin
			ALU_OUT <= A / B;
		end
		
		//Logic
		4'b0100: 
		begin
			ALU_OUT <=  A & B ;
		end
		4'b0101:
		begin
			ALU_OUT <=   A | B ;
		end
		4'b0110: 
		begin
			ALU_OUT <= ~(A & B);
		end
		4'b0111: 
		begin
			ALU_OUT <= ~(A | B);
		end
		4'b1000:
		begin
			ALU_OUT <=  (A ^ B);
		end
		4'b1001:
		begin
			ALU_OUT <= ~(A ^ B);
		end
		
		//Compare
		4'b1010: 
		begin
			ALU_OUT <= (A==B);
		end
		4'b1011: 
		begin
		if(A>B)
			ALU_OUT <= 'b10;
		else
			ALU_OUT <= 'b0;
		end
		4'b1100: 
		begin
		if(A<B)
			ALU_OUT <= 'b11;
		else
			ALU_OUT <= 'b0;
		end
		
		//Shift
		4'b1101: 
		begin
			ALU_OUT <= A>>1;
		end
		4'b1110: 
		begin
			ALU_OUT <= A<<1;
		end
		
		default: 
		begin
			ALU_OUT   <= 'b0;
			OUT_VALID <= 'b0;
		end  
	
		endcase
	
	end
end 

endmodule