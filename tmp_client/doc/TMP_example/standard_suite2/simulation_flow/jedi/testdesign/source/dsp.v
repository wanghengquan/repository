module dsp
(
    rst,
    clk,
    a,
    b,
    y
);

input           clk;
input           rst;
input   [35:0]        a;
input   [35:0]        b;
output  [71:0]        y;

reg   [71:0]        y; 


always @(posedge clk or negedge rst)
begin
    if (rst == 1'b0)
    begin
        y   <= 72'h0;
    end
    else
    begin
        y  <= a * b; 
    end
end

endmodule
