`timescale 1ns / 1ps

module Testbench();

reg clk;
reg reset;

Top_Module uut(
    clk,
    reset
    );

initial begin
    clk =0;
    reset = 0;
    #1
    reset =1 ;
    #1
    reset =0;
    #120
    $finish;
end

always begin
    #5 clk = ~clk; 
end

endmodule
