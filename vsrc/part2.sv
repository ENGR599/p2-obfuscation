`timescale 1ns/1ps

module part2(
    input clk,
    input rst,
    input [7:0] key,
    output [3:0] led
);


logic [27:0] delay = 28'h0000000;
logic [27:0] next_delay;
logic on;
logic next_on;

assign led = {on, on, on, on};

always_ff @(posedge clk) begin
    if (rst) begin
        delay <= 28'h0000000;
        on <= 1'b0;
    end else begin
        delay <= next_delay;
        on <= next_on;
    end
end

always_comb begin
    next_delay = delay + 1'b1;
    next_on = on;

	if(delay >= 28'h7FFFFFF && delay < 28'hFFFFFFF) begin
		next_on = ~on;
	end else if (delay == 28'hFFFFFFF) begin
        next_on = ~on;
        next_delay = 28'h0000000;
    end
end

endmodule

