module rtl_top
(input    clki,
 input    rst,
 input    dina,
 input    dinb,
 output   dout);

reg rega;
reg regb;
reg dout;
reg dsum;


always @ (posedge clki or posedge rst)
begin
	if(rst)
	begin
		rega <= 0;
		regb <= 0;
	end
	else
	begin
		rega <= dina;
		regb <= dinb;
	end
end

always @ (posedge clki or posedge rst)
begin
	if(rst)
	begin
		dsum <= 0;
	end
	else
	begin
		dsum <= rega + regb;
	end
end

always @ (posedge clki or posedge rst)
begin
	if(rst)
	begin
		dout <= 0;
	end
	else
	begin
		dout <= dsum;
	end
end

endmodule
