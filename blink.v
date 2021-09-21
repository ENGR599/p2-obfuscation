`timescale 1ns/1ps

module blink (
    input clk,
    input [7:0] key,
    output [3:0] led
);

assign led = {on, on, on, on};

reg [24:0] delay = 25'h0000000;
reg on = 0;

always @(posedge clk) begin
    delay<= delay - 1'b1; 
end

always@(*) begin
	if(delay == 25'hFFFFFFF) begin
		on = ~on;
	end 
end

endmodule
