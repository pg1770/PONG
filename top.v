`timescale 1ns / 1ps

 module top(
    input wire clk,
    input wire [1:0] btn1,
    input wire [1:0] btn2,
    output wire hsync, vsync,
    output wire [7:0] rgb
);

    wire [10:0] x, y;
    vga_sync vga0(.clk(clk),
        .hsync(hsync), .vsync(vsync),
        .x(x), .y(y));
    
    wire [1:0] btn1_out, btn2_out;
    debounce b0(clk, btn1[0], btn1_out[0]);
    debounce b1(clk, btn1[1], btn1_out[1]);
    debounce b2(clk, btn2[0], btn2_out[0]);
    debounce b3(clk, btn2[1], btn2_out[1]);
    
    graphic g0(.clk(clk),
        .x(x), .y(y), .rgb(rgb),
        .btn1(btn1_out), .btn2(btn2_out));

endmodule
