`timescale 1ns / 1ps 
module ALU(
    input reset,
    input [31:0] A,
    input [31:0] B,
    input [2:0] Control_Input,
    output reg [31:0] ALU_Result,
    output reg Zero_Flag
    );

    always @(*) begin
        if (reset == 1) begin
            ALU_Result = 32'b0; // Initialize ALU_Result to zero
            Zero_Flag = 1'b0;   // Initialize Zero_Flag to zero
        end 
        else begin
            case (Control_Input)
                3'b000: ALU_Result = A+B;      // Handles addi, and address calculation for lw and sw operations
                3'b001: ALU_Result = A^B;      // Bitwise XOR operation
                3'b100: ALU_Result = A|B;      // Bitwise OR operation
                3'b111: ALU_Result = A-B;      //SUB
                3'b011: ALU_Result = A*B;      //MUL
                3'b010: ALU_Result = A<<B;     //Shift 
                default: ALU_Result = 32'b0;      // Default case
            endcase
            // Set Zero_Flag based on ALU_Result
            Zero_Flag = (ALU_Result == 32'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule