//top level 

module rtl_top
#(
parameter	width	=	3
)
(
input	[width:0]	DA,
input	[width:0]	DB,
input				CLK,
input				rst,
output	[width:0]	Q 
);

reg		[width:0]	q_c;
reg		[width:0]	da_c;
reg		[width:0]	db_c;
wire				clk_c;

equation_check U1(.CLKI(CLK), .CLKOP(clk_c));

always @(posedge clk_c or posedge rst) 
begin
	if (rst == 1)
	begin
		da_c	<= 0;
		db_c	<= 0;
		q_c		<= 0;
	end
	else
	begin
		da_c	<=	DA;
		db_c	<=	DB;
		q_c		<=	da_c + db_c;
	end
end

assign Q = q_c;
endmodule

