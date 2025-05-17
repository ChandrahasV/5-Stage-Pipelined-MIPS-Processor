`timescale 1ns / 1ps

module Data_Memory(
    input Write_Enable,
    input clk,
    input reset,
    input [31:0] Address,
    input [31:0] Write_Data,
    output [31:0] Read_Data
    );
    
    reg [7:0] Mem [35:0];
    
    assign Read_Data = {Mem[Address], Mem[Address+1],Mem[Address+2],Mem[Address+3]};
    always@(posedge clk,posedge reset) begin
        if(reset) begin
        Mem[0]=8'd20; Mem[1]=8'h00; Mem[2]=8'h00; Mem[3]=8'h00; 
        Mem[4]= 8'h00; Mem[5]=8'h00; Mem[6]=8'h01; Mem[7]= 8'h00; 
        Mem[8]= 8'h00; Mem[9]=8'h00; Mem[10]=8'h00; Mem[11]= 8'h00;
        Mem[12]= 8'h00; Mem[13]=8'h00; Mem[14]=8'h00; Mem[15]= 8'h00;
        Mem[16]= 8'h00; Mem[17]=8'h00; Mem[18]=8'h00; Mem[19]= 8'h00;
        Mem[20]= 8'h00; Mem[21]=8'h00; Mem[22]=8'h00; Mem[23]= 8'h00;
        Mem[24]= 8'h00; Mem[25]=8'h00; Mem[26]=8'h00; Mem[27]= 8'h00;
        Mem[28]= 8'h00; Mem[29]=8'h00; Mem[30]=8'h00; Mem[31]= 8'h00;
        Mem[32]= 8'h00; Mem[33]=8'h00; Mem[34]=8'h00; Mem[35]= 8'h00;
        end
        else begin
            if(Write_Enable) begin
                {Mem[Address],Mem[Address+1],Mem[Address+2],Mem[Address+3]} <= Write_Data;
            end
        end
    end
    
endmodule
