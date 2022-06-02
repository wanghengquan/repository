//
// Sum three numbers and wait for next
// start signal
//
`timescale 100 ps/100 ps
module vlog_statmchs_sum3(sum, ready, d, reset,start, clk);
output [7:0] sum;
input [7:0] d;
output ready;
input start, clk,reset;

reg [7:0] sum;
reg ready;
//integer [3:0] i;
integer i;
reg flag;

always @(posedge clk) begin :lbl

	//@(posedge clk);
	//flag = ;
	if (reset || (!start)) begin
		ready = 1;
		//@(posedge clk);
	end
	for(i = 0;!reset &&  (i < 3'b100); i = i + 1) begin
		ready = 0;
		sum = (i?sum:0) + d;
		//@(posedge clk);
	end
end

endmodule
		
