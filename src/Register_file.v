`timescale 1ns /1ps

module Register_file(
    input Write_Enable,
    input clk,
    input reset,
    input [4:0] Read_Reg_Num_1,
    input [4:0] Read_Reg_Num_2,
    input [4:0] Write_Reg_Num,
    input [31:0] Write_Data,
    output [31:0] Read_Data_1,
    output [31:0] Read_Data_2
    );
    
    reg [31:0] Reg_Memory[31:0];
    
    
    always@(posedge clk,posedge  reset) begin
        if(reset) begin
        Reg_Memory[0] <= 32'd0; 
        Reg_Memory[1] <= 32'd2; 
        Reg_Memory[2] <= 32'd3; 
        Reg_Memory[3] <= 32'b0; 
        Reg_Memory[4] <= 32'b0;
        Reg_Memory[5] <= 32'b0; 
        Reg_Memory[6] <= 32'b0;
        Reg_Memory[7] <= 32'b0;
        Reg_Memory[8] <= 32'b0; 
        Reg_Memory[9] <= 32'b0; 
        Reg_Memory[10] <= 32'b0; 
        Reg_Memory[11] <= 32'b0; 
        Reg_Memory[12] <= 32'b0; 
        Reg_Memory[13] <= 32'b0; 
        Reg_Memory[14] <= 32'b0; 
        Reg_Memory[15] <= 32'b0; 
        Reg_Memory[16] <= 32'b0; 
        Reg_Memory[17] <= 32'b0; 
        Reg_Memory[18] <= 32'b0; 
        Reg_Memory[19] <= 32'b0; 
        Reg_Memory[20] <= 32'b0; 
        Reg_Memory[21] <= 32'b0; 
        Reg_Memory[22] <= 32'b0; 
        Reg_Memory[23] <= 32'b0; 
        Reg_Memory[24] <= 32'b0; 
        Reg_Memory[25] <= 32'b0; 
        Reg_Memory[26] <= 32'b0; 
        Reg_Memory[27] <= 32'b0; 
        Reg_Memory[28] <= 32'b0; 
        Reg_Memory[29] <= 32'b0; 
        Reg_Memory[30] <= 32'b0;
        Reg_Memory[31] <= 32'b0; 
        end
        else begin
            if(Write_Enable) begin
                Reg_Memory[Write_Reg_Num] <= Write_Data;
            end
        end
    end
    
    assign Read_Data_1 = ((Write_Enable && (Write_Reg_Num == Read_Reg_Num_1)) && (Write_Reg_Num != 0)) ? Write_Data : Reg_Memory[Read_Reg_Num_1];
    assign Read_Data_2 = ((Write_Enable && (Write_Reg_Num == Read_Reg_Num_2)) && (Write_Reg_Num != 0)) ? Write_Data : Reg_Memory[Read_Reg_Num_2];

endmodule

