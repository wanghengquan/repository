`timescale 1ns/1ps
module tb_dsp;

 	GSR GSR_INST (.GSR_N(1'b1));
 	PUR PUR_INST (.PUR(1'b1));	

integer outlog;
initial outlog=$fopen("./outlog.log");


reg          clk;
reg          rst;
reg  [35:0]        a;
reg  [35:0]        b;

wire   [71:0]        y; 

dsp u_dsp
(
    .rst                (rst),
    .clk                (clk),
    .a                  (a  ),
    .b                  (b  ),
    .y                  (y  )
);


initial
begin
    rst     <= 1'b0;
    #102;
    rst     <= 1'b1;

    repeat(200)
    begin
        @(negedge clk);
        a   <= $random;
        b   <= $random;
        @(negedge clk);
        @(negedge clk);
        if (y != (a * b))
		  $fdisplay(outlog, "FAIL");
		else
		  $fdisplay(outlog, "PASS"); 
    end
    $finish;

end

initial
begin
    clk <= 1'b0;
    forever
    begin
       #10;
       clk  <= ~clk;
    end
end


endmodule
