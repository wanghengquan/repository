module top(
    input wire clkin,
    input wire reset,
    input wire [7:0] datain,
    output reg wrapout,
	output wire sclk,
    output wire [7:0] q
);

//wire sclk;
sdr inst (.clkin(clkin), .reset(reset), .sclk(sclk), .datain(datain), .q(q));

always@(posedge sclk)
  wrapout <= reset;

endmodule
