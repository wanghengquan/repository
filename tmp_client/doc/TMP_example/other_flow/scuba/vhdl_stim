`timescale 1ns /1 ns

module test_lattice_sim;

wire [27:0] SUM;

reg ADDNSUB,SignA,SignB,CLK0,CE0,RST0;
reg [9:0] A0;
reg [16:0] B0;

reg [9:0] A1;
reg [16:0] B1;

wire VCCI_sig = 1;



integer index;
integer maddsub_10x17_dynamic_vlog_gen_out;

parameter width = 60, pattern = 68 , step = 95;
reg [1:width] mem [1: pattern];
   
maddsub_10x17_dynamic_vlog post(.ADDNSUB(ADDNSUB),.SignA(SignA),.SignB(SignB),.CLK0(CLK0),.CE0(CE0),.RST0(RST0),.SUM(SUM),.A0(A0),.B0(B0),.A1(A1),.B1(B1));


initial
begin
        maddsub_10x17_dynamic_vlog_gen_out = $fopen("./maddsub_10x17_dynamic_vlog.sim");
        $readmemb ("maddsub_10x17_dynamic_vlog.in", mem);

               for (index = 1; index <= pattern ; index = index + 1)
               begin
                  #5 {A0,B0,A1,B1,ADDNSUB,SignA,SignB,CE0,RST0,CLK0} = mem[index];
                  //#step $display ($time, " %b_%b_%b_%b_%b_%b_%b_%b%b%b %b", A0,B0,A1,B1,ADDNSUB,SignA,SignB,CE0,RST0,CLK0,SUM);
                  #5 $fdisplay (maddsub_10x17_dynamic_vlog_gen_out," %d %b%b%b%b%b%b%b%b%b%b %b",index,A0,B0,A1,B1,ADDNSUB,SignA,SignB,CE0,RST0,CLK0,SUM); 
               end
end
endmodule


