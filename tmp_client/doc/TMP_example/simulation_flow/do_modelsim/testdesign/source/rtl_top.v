
`timescale 1 ns / 1 ps

module rtl_top
#(
parameter addr_width = 5,
parameter data_width = 8
)
(
input	[addr_width-1 : 0]	addr,
input	[data_width-1 : 0]	data,
input	clk,
input	we,
input	clken,
output	[data_width-1 : 0]	qout
);



module_top uut (.Address(addr), .Data(data), .Clock(clk), .WE(we), .ClockEn(clken), .Q(qout));

endmodule
