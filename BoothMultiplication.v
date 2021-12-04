`timescale 1ns / 1ps
module BoothMultiplication(input GO, clk, RST, input [31:0]m, r, output done, cntOut, output [1:0]Pbits, CS, output[63:0] result);
// internal signals
wire addResSel, addSel, pSel, enC, enA, enS, enP, count;
DP datapath(clk,m,r,count,addResSel,addSel, pSel, enC, enA, enS, enP, done, result, Pbits, cntOut);
CU control(GO, RST, clk, cntOut, Pbits, CS, pSel, addSel, addResSel, enC, enA, enS, enP, count, done);
endmodule
