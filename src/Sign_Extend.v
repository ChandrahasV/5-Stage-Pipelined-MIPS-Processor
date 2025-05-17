`timescale 1ns / 1ps

module Sign_Extend16(
    input [15:0] Signed_Data,
    output reg [31:0] out
    );
    
    always @(*) begin
        if(Signed_Data[15] == 1'b1) begin
            out = {16'b1111111111111111, Signed_Data[15:0]};  // Sign-extend for negative values
        end
        else begin
            out = {16'b0000000000000000, Signed_Data[15:0]};  // Sign-extend for positive values
        end
    end
endmodule
