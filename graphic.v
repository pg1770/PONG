`timescale 1ns / 1ps

module graphic(
    input wire  clk,
    input wire  [10:0] x, y,
    input wire  [1:0]  btn1, btn2,
    output wire [7:0]  rgb
);

    // colors: [B1 B2 G1 G2 G3 R1 R2 R3]
    localparam COLOR_BG   = 8'b01001000;
    localparam COLOR_BALL = 8'b11011101;
    localparam COLOR_LINE = 8'b11100001;
    localparam COLOR_LBAR = 8'b10010111;
    localparam COLOR_RBAR = 8'b00101011;
    localparam COLOR_NULL = 8'b00000000;
    
    // sizes
    localparam BAR_H  = 11'd60;
    localparam BAR_W  = 11'd5;
    localparam BALL_R = 11'd5;
    
    // velocities
    localparam BAR_V  = 10'd1;
    localparam BALL_V = 10'd1;
    
    reg [10:0] ball_x, ball_y, lbar_y, rbar_y;
    reg ball_move_x, ball_move_y;
    reg [5:0] lscore, rscore;
    initial begin
        ball_x = 11'd320;
        ball_y = 11'd240;
        lbar_y = 11'd240;
        rbar_y = 11'd240;
        ball_move_x = 1'b1;
        ball_move_y = 1'b1;        
    end
    
    reg [7:0] rgb_now;
    wire clk_frame = (x == 0 && y == 0);
    always @(posedge clk) begin
    
        if (clk_frame) begin
            // controls
            if (btn1[0] && lbar_y > 40  + BAR_H / 2) lbar_y = lbar_y - BAR_V;
            if (btn1[1] && lbar_y < 440 - BAR_H / 2) lbar_y = lbar_y + BAR_V;
            if (btn2[0] && rbar_y > 40  + BAR_H / 2) rbar_y = rbar_y - BAR_V;
            if (btn2[1] && rbar_y < 440 - BAR_H / 2) rbar_y = rbar_y + BAR_V;
            
            // ball move
            if (ball_move_x) ball_x = ball_x + BALL_V;
            else ball_x = ball_x - BALL_V;
            if (ball_move_y) ball_y = ball_y + BALL_V;
            else ball_y = ball_y - BALL_V;
            
            // coliision detect
            if (ball_y == 40 || ball_y == 440)
                ball_move_y = ~ball_move_y;
            if (ball_x == 40 && ball_y >= lbar_y - BAR_H / 2 && ball_y <= lbar_y + BAR_H / 2)
                ball_move_x = ~ball_move_x;
            if (ball_x == 600 && ball_y >= rbar_y - BAR_H / 2 && ball_y <= rbar_y + BAR_H / 2)
                ball_move_x = ~ball_move_x;
            
            // bound detect
            if (ball_x < 0 || ball_x > 640) begin
                ball_x = 320;
                ball_y = 240;
                ball_move_x = 1'b1;
                ball_move_y = 1'b1;
            end
        end
        
        if (x < 640 && y < 480) begin
            
            rgb_now <= COLOR_BG;
            
            // border
            if ((y == 40 || y == 440) && (x >= 40 && x <= 600))
                rgb_now <= COLOR_LINE;
            
            // bars
            if ((x >= 40 && x <= 40 + BAR_W) &&
                (y >= lbar_y - BAR_H / 2 && y <= lbar_y + BAR_H / 2))
                rgb_now <= COLOR_LBAR;
            if ((x >= 600 - BAR_W && x <= 600) &&
                (y >= rbar_y - BAR_H / 2 && y <= rbar_y + BAR_H / 2))
                rgb_now <= COLOR_RBAR;
            
            // ball
            if ((x >= ball_x - BALL_R && x <= ball_x + BALL_R) &&
                (y >= ball_y - BALL_R && y <= ball_y + BALL_R))
                rgb_now <= COLOR_BALL;
                
        end else begin
            rgb_now <= COLOR_NULL;
        end
    end
    
    assign rgb = rgb_now;
    
endmodule
