`timescale 1ns /1 ns

module sim_top;
reg [3:0] DA;
reg [3:0] DB;
reg CLK;
wire [3:0] Q;

wire VCCI_sig = 1;

GSR GSR_INST(.GSR(VCCI_sig));
PUR PUR_INST(.PUR(VCCI_sig));

integer index;
integer test_gen_out;

parameter width = 9, pattern = 100 , step1 = 1, step2 = 4; //5nsto generate 100MHz

reg [1:width] mem [1: pattern];

rtl_top post(.DA(DA), .DB(DB), .CLK(CLK), .Q(Q));


initial
begin
        test_gen_out = $fopen("./test_vector.out");
        $readmemb ("test_vector.in", mem);

               for (index = 1; index <= pattern ; index = index + 1)
               begin
                  #step1 {DA,DB,CLK} = mem[index];
                  #step2 $display ($time, " %b_%b_%b %b",DA,DB,CLK,Q);
                  $fdisplay (test_gen_out," %b_%b_%b %b",DA,DB,CLK,Q);
               end
end
endmodule
