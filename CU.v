`timescale 1ns / 1ps
module CU(input GO, RST, clk, counterStatus, input [1:0] Pbits,
output reg [1:0] CS, output reg pSel, addSel, addResSel, enC, enA, enS, enP, count, done);
reg [1:0] NS;
//Next State Logi
always@(CS,GO,counterStatus)
begin
case(CS)
0: NS = GO ? 2'b01:2'b00;
1: NS = 2'd2;
2: NS = (counterStatus) ? (2'd2):(2'd3);
3: NS = 2'b00;
default: NS = 2'b00;
endcase
end
//State Register
always@(posedge clk, posedge RST)
begin
CS <= RST? 0:NS;
end

//Output Logic
always@(CS,Pbits)
begin
  case(CS)
  0: {addSel, addResSel, pSel, enC, enA, enS, enP, done, count} = 9'b000_1000_00;
  1: {addSel, addResSel, pSel, enC, enA, enS, enP, done, count} = 9'b000_0111_00;
  2: begin
    case(Pbits)
    1:{addSel, addResSel, pSel, enC, enA, enS, enP, done, count} = 9'b101_0001_01; //01
    2:{addSel, addResSel, pSel, enC, enA, enS, enP, done, count} = 9'b001_0001_01; //10
    default:// 00 or 11
    {addSel, addResSel, pSel, enC, enA, enS, enP, done, count}= 9'b011_0001_01;
    endcase
    end
  3: {addSel, addResSel, pSel, enC, enA, enS, enP, done, count}= 9'b000_0000_10;
  default:
  {addSel, addResSel, pSel, enC, enA, enS, enP, done, count} = 9'b000_0000_00;
  endcase
end
endmodule
