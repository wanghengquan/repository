
`timescale 1 ns / 1 ps

module rtl_top
#(
parameter addr_width = 4,
parameter data_width = 12
)
(
input	[addr_width-1 : 0]	addr,
input	[data_width-1 : 0]	data,
input	clk,
input	clken,
input	rst,
output	[data_width-1 : 0]	qout
);


//shift depth 16
module_top uut (.Din(data), .Addr(addr), .Clock(clk), .ClockEn(clken), .Reset(rst), .Q(qout));

endmodule
