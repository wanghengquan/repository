//Verilog testbench template generated by SCUBA Diamond (64-bit) 3.5.0.91
`timescale 1 ns / 1 ps
module tb;
    reg [4:0] Address = 5'b0;
    reg [7:0] Data = 8'b0;
    reg Clock = 0;
    reg WE = 0;
    reg ClockEn = 0;
    wire [7:0] Q;

    integer i0 = 0, i1 = 0, i2 = 0, i3 = 0, i4 = 0, i5 = 0;

    GSR GSR_INST (.GSR(1'b1));
    PUR PUR_INST (.PUR(1'b1));

    module_top u1 (.Address(Address), .Data(Data), .Clock(Clock), .WE(WE), 
        .ClockEn(ClockEn), .Q(Q)
    );

    initial
    begin
       Address <= 0;
      #100;
      #10;
      for (i1 = 0; i1 < 70; i1 = i1 + 1) begin
        @(posedge Clock);
        #1  Address <= Address + 1'b1;
      end
    end
    initial
    begin
       Data <= 0;
      #100;
      #10;
      for (i2 = 0; i2 < 35; i2 = i2 + 1) begin
        @(posedge Clock);
        #1  Data <= Data + 1'b1;
      end
    end
    always
    #5.00 Clock <= ~ Clock;

    initial
    begin
       WE <= 1'b0;
      #10;
      for (i4 = 0; i4 < 35; i4 = i4 + 1) begin
        @(posedge Clock);
        #1  WE <= 1'b1;
      end
       WE <= 1'b0;
    end
    initial
    begin
       ClockEn <= 1'b0;
      #100;
      #10;
       ClockEn <= 1'b1;
    end
endmodule