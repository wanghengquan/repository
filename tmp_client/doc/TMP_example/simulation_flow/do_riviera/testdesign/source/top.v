//top level 

module rtl_top
#(
parameter	width	=	3
)
(
input	[width:0]	DA,
input	[width:0]	DB,
input				CLK,
output	[width:0]	Q 
);

wire	clk_c;
reg		[width:0]	q_c;
reg		[width:0]	da_c;
reg		[width:0]	db_c;


always @(posedge CLK) begin
	da_c	<=	DA;
	db_c	<=	DB;
	q_c		<=	da_c + db_c;
end

assign Q = q_c;
endmodule

