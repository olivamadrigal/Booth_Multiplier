`timescale 1ns / 1ps
/*

Datapath module that implements Booth's algorithm: DP.v

CMPE 297 HW 1 Booth's Algorithm March 16, 2016 Samira C. Oliva

// datapath for booth adder (32-bit architecture)
inputs: m := 32-bit multiplicand r := 32-bit multiplier;

control signals from CU

outputs:

pOut := result from comparing P[1:0] the two LSBs of the product cntOut := result of (count = 0)?

result := final product = (m x r)
*/


module DP(input clk, input [31:0] m, r, 
		    input addResSel, addSel, pSel, enC, enA, enS, enP, done,
			 output [63:0] result, output [1:0] pOut, output cntOut);

//internal signals
wire [64:0] Preg, Sreg, Areg, P, S, A, PRS, outMux1, outMux2, Pv, sum;
				
wire [5:0] cnt;

initialize iniDATA(m, r, Preg, Sreg, Areg);
dReg       Product(clk, enP, Pv, P );
dReg       Svalue(clk, enS, Sreg, S );
dReg       Avalue(clk, enA, Areg, A );

MUX2to1    pMUX(pSel, PRS, Preg, Pv);
MUX2to1    aMUX(addSel, A, S, outMux1);
MUX2to1    rMUX(addResSel, P, sum, outMux2);

//arithmetic shift right
assign PRS  = {outMux2[64], outMux2[64:1]};

ADDER      add(P, outMux1, sum);  
counter    counter1(clk, enC, count, 6'd32, cnt);
cmpCNT     cmpCount(cnt, cntOut);

assign pOut = P[1:0]; //goes to CU

triStateBuffer buffer(P[64:1], done, result);


endmodule



/********************************************************/
module initialize(input [31:0] m, r, output [64:0] P, S, A);

reg [31:0] m2;

assign A = {m, 33'd0};

//two's complement
always@(m[31])
begin
if(m[31])
   begin
	m2 <= ~(m - 1); //undo two's complement
	end
else
   begin 
	m2 <= ((~m) + 1);//take two's complement
	end
end

assign S = {m2, 33'd0};
assign P = {32'd0, r, 1'b0};

endmodule

/********************************************************/
module dReg(input clk, en, input [64:0] d, 
		 output reg [64:0] q);

   always@(posedge clk)
		if(en)    q <= d;
		else
				    q <= q;
endmodule

/********************************************************/
// if s = 1, C = A, esle C = B
module MUX2to1(input s, input [64:0] A, B, output [64:0] C);
		
		assign C = s ? A: B;
		 
endmodule

/********************************************************/
module counter(input clk, enC, count, input [5:0] n, output reg [5:0] cnt);

	always @(posedge clk)
	begin
		if(enC)
			cnt <= n;
		else if(count)
			cnt <= cnt - 1;//count down
		else
			cnt <= cnt; //hold
	end
	
endmodule

/********************************************************/
// result 0 := count is now 0
// result 1 := count is > 0
module cmpCNT(input [5:0] cnt, output cntRes);

	assign cntRes = (cnt == 6'd0)? 0 : 1;

endmodule

/********************************************************/
module triStateBuffer(input [64:0] P, input done, output [64:0] result);

	  assign result = done? P : 65'dZ; //P or High-Z

endmodule

/********************************************************/
module ADDER(input [64:0] A, B, output [64:0] C);

	assign C = A + B;

endmodule


