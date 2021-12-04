`timescale 1ns / 1ps
module BoothMultiplication_tb;
//inputs
reg GO, clk, RST;
reg [31:0] m, r;
//outputs
wire done, cntOut; wire [1:0] pOut, CS; wire [63:0] result;
reg [63:0] eResult;
BoothMultiplication DUT(GO,clk,RST,m,r,done,cntOut,pOut,CS,result);
initial begin
RST = 1; GO = 1;#10; RST =0; #5; m = 32'hfffffffD; //-4
r = 32'hfffffffC;//-3
clk = 0; #5;
eResult = 64'h000000000000000C;#5 // expected result end
always begin
  clk <= ~clk; #5; 
end
always@(negedge clk) begin
if(CS == 2'b11)
begin
  if(eResult == result) 
    begin
    $display("successful: expected %b = result %b\n", eResult, result); $stop
    end
  else
    begin
    $display("ERROR: expected != result\n"); $stop;
    end 
end
end
endmodule
