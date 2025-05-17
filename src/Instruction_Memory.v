`timescale 1ns / 1ps 
module Instruction_Memory( 
    input [31:0] PC, 
    input reset, 
    output [31:0] Instruction_Code
    ); 

    reg [7:0] Mem [35:0]; //byte addressable memory 36 locations 

//For normal memory read we use the following statement 
assign Instruction_Code = {Mem[PC], Mem[PC+1],Mem[PC+2],Mem[PC+3]}; //reads instruction code specified by PC //BigEndian 

//handling reset condition 
always @(reset) begin 
if (reset ==1) //if reset is equal to logic 0 
// Initialize the memory with 4 instructions
//BigEndian Format
begin 
    
    Mem[0]=8'hFC; Mem[1]=8'h22; Mem[2]=8'h18; Mem[3]=8'h21; 
    // 11111100001000100001100000100001 FC221821 mul r2,r1
    Mem[4]= 8'h1C; Mem[5]=8'h21; Mem[6]=8'h00; Mem[7]= 8'h02;
    // 00011100001000010000000000000010 1C210002 addi r1,r1,2
    Mem[8]= 8'h1C; Mem[9]=8'h43; Mem[10]=8'h00; Mem[11]= 8'h02;
    // 00011100010000110000000000000010 1C430002 addi r3,r2,2
    Mem[12]= 8'h78; Mem[13]=8'h23; Mem[14]=8'h00; Mem[15]= 8'h01;
    // 01111000001000110000000000000001 78230001 beq r3,r1,1
    Mem[16]= 8'h00; Mem[17]=8'h00; Mem[18]=8'h00; Mem[19]= 8'h00;
    Mem[20]= 8'h00; Mem[21]=8'h00; Mem[22]=8'h00; Mem[23]= 8'h00;
    Mem[24]= 8'h00; Mem[25]=8'h00; Mem[26]=8'h00; Mem[27]= 8'h00;
    Mem[28]= 8'h00; Mem[29]=8'h00; Mem[30]=8'h00; Mem[31]= 8'h00;
    Mem[32]= 8'hAC; Mem[33]=8'h02; Mem[34]=8'h00; Mem[35]= 8'h04;


    end 
end 
endmodule
