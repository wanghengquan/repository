module top(a, b, clk);
input a, clk;
output b;

reg b;
reg c;

always @ (posedge clk)
	begin 
		c <= a ;
	end

always @ (posedge clk)
	begin 
		b <= c ;
	end



endmodule			


