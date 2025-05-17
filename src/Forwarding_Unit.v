`timescale 1ns / 1ps

module Forwarding_Unit(
    input EX_MEM_RegWrite,
    input [4:0] EX_MEM_RegRd,
    input MEM_WB_RegWrite,
    input [4:0] MEM_WB_RegRd,
    input [4:0] ID_EX_RegRs,
    input [4:0] ID_EX_RegRt,
    output reg [1:0] ALU_MUX1,
    output reg [1:0] ALU_MUX2
    );

    always@(*) begin
        if((EX_MEM_RegWrite==1)&&(EX_MEM_RegRd!=5'b0)&&(EX_MEM_RegRd == ID_EX_RegRs)) begin
            ALU_MUX1 = 2'b01;    
        end
        else if((MEM_WB_RegWrite==1)&&(MEM_WB_RegRd!=5'b0)&&(MEM_WB_RegRd == ID_EX_RegRs)) begin
            ALU_MUX1 = 2'b10;            
        end
        else begin
            ALU_MUX1 = 2'b00;
        end
    end
    
    always@(*) begin
        if((EX_MEM_RegWrite==1)&&(EX_MEM_RegRd!=5'b0)&&(EX_MEM_RegRd == ID_EX_RegRt)) begin
            ALU_MUX2 = 2'b01;    
        end
        else if((MEM_WB_RegWrite==1)&&(MEM_WB_RegRd!=5'b0)&&(MEM_WB_RegRd == ID_EX_RegRt)) begin
            ALU_MUX2 = 2'b10;            
        end
        else begin
            ALU_MUX2 = 2'b00;
        end
    end
    
endmodule