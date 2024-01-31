module part3(
	input  clk,
	input  rst,
    input  [7:0] key,
	output [6:0] seg
);

wire [6:0] z;
assign seg = ~z;

reg [3:0] STATE = 0;
reg [3:0] STATE_next = 0;
reg [3:0] hex = 0;
reg [3:0] hex_next = 0;

reg [24:0] delay = 25'h0000000;
reg on = 0;

always_ff @(posedge clk) begin
    if (rst) begin
        delay <= 25'h0;
    end else begin
       delay <= delay - 1'b1; 
	   if(delay == 25'hFFFFFFF) begin
	       on <= ~on;
	   end
    end 
end

hexto7segment h(.x(hex), .z(z));

always_comb begin
	STATE_next = STATE;
	hex_next   = hex;
	case(STATE)
		0: begin
			hex_next = 4'h0;
			STATE_next = STATE + 1;
		end
		1: begin
			hex_next = 4'h1;
			STATE_next = STATE + 1;
		end
		2: begin
			hex_next = 4'h2;
			STATE_next = STATE + 1;
		end
		3: begin
			hex_next = 4'h3;
			STATE_next = STATE + 1;
		end
		4: begin
			hex_next = 4'h4;
			STATE_next = STATE + 1;
		end
		5: begin
			hex_next = 4'h5;
			STATE_next = STATE + 1;
		end
		6: begin
			hex_next = 4'h6;
			STATE_next = STATE + 1;
		end
		7: begin
			hex_next = 4'h7;
			STATE_next = STATE + 1;
		end
		8: begin
			hex_next = 4'h8;
			STATE_next = STATE + 1;
		end
		9: begin
			hex_next = 4'h9;
			STATE_next = 0;
		end
	endcase
end

always@(posedge on) begin
	STATE <= STATE_next;
	hex   <= hex_next;
end

endmodule

module hexto7segment(
    input  [3:0]x,
    output reg [6:0]z
    );
always @(*) begin
		case (x)
			4'b0000: z = 7'b0000001; // "0"  
			4'b0001: z = 7'b1001111; // "1" 
			4'b0010: z = 7'b0010010; // "2" 
			4'b0011: z = 7'b0000110; // "3" 
			4'b0100: z = 7'b1001100; // "4" 
			4'b0101: z = 7'b0100100; // "5" 
			4'b0110: z = 7'b0100000; // "6" 
			4'b0111: z = 7'b0001111; // "7" 
			4'b1000: z = 7'b0000000; // "8"  
			4'b1001: z = 7'b0000100; // "9" 
			default: z = 7'b0000001; // "0"
		endcase
end
 
endmodule
