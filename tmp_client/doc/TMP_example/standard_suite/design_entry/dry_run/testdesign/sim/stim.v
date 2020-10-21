`timescale 1ns / 1 ns
            
            
module test_lattice_sim;
            
reg [5:0] Address;
wire [8:0] Q;
reg OutClock,OutClockEn;
reg Reset;


wire VCCI_sig = 1;
GSR GSR_INST(.GSR(VCCI_sig));
PUR PUR_INST(.PUR(VCCI_sig));
    
integer index;
integer romblk_64x9_vlog_gen_out;

parameter width = 9, pattern = 128 , step = 95;
reg [1:width] mem [1: pattern];
            
                
romblk_64x9_1111_vlog post( .Reset(Reset),.Address(Address),.OutClock(OutClock),.OutClockEn(OutClockEn),.Q(Q) );
                
initial
begin
        romblk_64x9_vlog_gen_out = $fopen("./romblk_64x9_1111_vlog.sim");
        $readmemb ("romblk_64x9_1111_vlog.in", mem);

               for (index = 1; index <= pattern ; index = index + 1)
               begin
                  #5 {Address,OutClockEn,Reset,OutClock} = mem[index];
                  //#step $display ($time, " %b_%b_%b_%b %b", Address,OutClockEn,Reset,OutClock,Q );
                  #5 $fdisplay (romblk_64x9_vlog_gen_out," %d %b %b_%b_%b_%b", index,Q,Address,OutClockEn,Reset,OutClock); 
               end
end
endmodule


