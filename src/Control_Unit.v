`timescale 1ns / 1ps

module Control_Unit(
    input [5:0] Opcode,
    input [5:0] func,
    input reset,
    output reg [9:0] Control_Signal
    );
    
    always@(*) begin
        if(reset) begin
            Control_Signal = 10'b00000000;
        end
        else begin
        case(Opcode) 
            6'b100011: Control_Signal = 10'b1010000000; //lw
            6'b101011: Control_Signal = 10'b0001000000; //sw
            6'b000010: Control_Signal = 10'b0100000000; //j
            6'b101010: Control_Signal = 10'b0010001100; //xori
            6'b001101: Control_Signal = 10'b0010100100; //ori
            6'b000111: Control_Signal = 10'b0010000100; //addi
            6'b011110: Control_Signal = 10'b0100111010; //beq
            6'b111111: begin
                            case(func)
                                6'b010101: Control_Signal = 10'b0010111110;
                                6'b100001: Control_Signal = 10'b0010011110;
                                6'b101010: Control_Signal = 10'b0010010110;
                                default: Control_Signal = 10'b0000000000;
                            endcase
                        end
            default: Control_Signal = 10'b000000000;
        endcase
        end
    end
endmodule
