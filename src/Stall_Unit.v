`timescale 1ns / 1ps

module Stall_Unit(
    input ID_EX_MemRead,
    input [4:0] ID_EX_RegRt,
    input [4:0] IF_ID_RegRt,
    input [4:0] IF_ID_RegRs,
    input Control_MemRead,
    input Control_WE_Datamem,
    output reg stall
    );
    
    always@(*) begin
        if((ID_EX_MemRead)&&((ID_EX_RegRt == IF_ID_RegRs)||((Control_MemRead||Control_WE_Datamem)&&(ID_EX_RegRt == IF_ID_RegRt)))) begin
            stall =1;
        end
        else begin
            stall = 0;
        end
    end
endmodule

