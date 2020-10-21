//############################################################
//
// Testbench: mac8x8_tb
//
// Feature Test: mac8x8
//
// Description: mac8x8_tb instantiates one instance of
//              mac8x8, applies vectors at negative edge
//              of clock and samples the outputs at positive
//              edge of clock + period/4.
//
// Output Files:
//              mac8x8.results
//              mac8x8.errors
//              mac8x8.status
//
//############################################################
`timescale 100 ps/100 ps
`define DSIZE 8
`define OSIZE 16

module testbench;

reg [`DSIZE-1:0] x, y;
reg clk, rst;

wire [`OSIZE:0] dataout;

mac8x8 U1 (
	.dataout(dataout),
	.x(x),
	.y(y),
	.clk(clk),
	.rst(rst));

// test control variables:

parameter MAX_VECTORS = 10;
parameter CLOCK_PERIOD = 1000; // 100 ns clock
integer VECTOR_CNT, ERROR_CNT;

// output file variables:

reg [31:0] RESULTFILE, ERRORFILE, STATUSFILE;

// test vector variables:

reg [`DSIZE-1:0] x_vec [0:MAX_VECTORS-1];
reg [`DSIZE-1:0] y_vec [0:MAX_VECTORS-1];
reg clk_vec [0:MAX_VECTORS-1];
reg rst_vec [0:MAX_VECTORS-1];
reg [`OSIZE:0] dataout_expected [0:MAX_VECTORS-1];
reg [`OSIZE:0] dataout_tmp [0:MAX_VECTORS-1];


// vector generation initial block

initial
begin

// pattern 0
      x_vec[0] = `DSIZE'd0;
      y_vec[0] = `DSIZE'd0;
      rst_vec[0] = 1'b1;
      dataout_tmp[0] = `OSIZE'd0;
      dataout_expected[0] = `OSIZE'd0;

// pattern 1
      x_vec[1] = `DSIZE'd2;
      y_vec[1] = `DSIZE'd5;
      rst_vec[1] = 1'b0;
      dataout_tmp[1] = `OSIZE'd10;
      dataout_expected[1] = dataout_tmp[0];

// pattern 2
      x_vec[2] = `DSIZE'd5;
      y_vec[2] = `DSIZE'd4;
      rst_vec[2] = 1'b0;
      dataout_tmp[2] = `OSIZE'd30;
      dataout_expected[2] = dataout_tmp[1];

// pattern 3
      x_vec[3] = `DSIZE'd7;
      y_vec[3] = `DSIZE'd9;
      rst_vec[3] = 1'b0;
      dataout_tmp[3] = `OSIZE'd93;
      dataout_expected[3] = dataout_tmp[2];

// pattern 4
      x_vec[4] = `DSIZE'd17;
      y_vec[4] = `DSIZE'd0;
      rst_vec[4] = 1'b0;
      dataout_tmp[4] = `OSIZE'd93;
      dataout_expected[4] = dataout_tmp[3];

// pattern 5
      x_vec[5] = `DSIZE'd11;
      y_vec[5] = `DSIZE'd11;
      rst_vec[5] = 1'b0;
      dataout_tmp[5] = `OSIZE'd214;
      dataout_expected[5] = dataout_tmp[4];

// pattern 6
      x_vec[6] = `DSIZE'd01;
      y_vec[6] = `DSIZE'd100;
      rst_vec[6] = 1'b0;
      dataout_tmp[6] = `OSIZE'd314;
      dataout_expected[6] = dataout_tmp[5];

// pattern 7
      x_vec[7] = `DSIZE'd0;
      y_vec[7] = (`DSIZE'b1 << `DSIZE) -1;
      rst_vec[7] = 1'b0;
      dataout_tmp[7] = `OSIZE'd314;
      dataout_expected[7] = dataout_tmp[6];

// pattern 8
      x_vec[8] = (`DSIZE'b1 << `DSIZE) -1;
      y_vec[8] = (`DSIZE'b1 << `DSIZE) -1;
      rst_vec[8] = 1'b0;
      dataout_tmp[8] = `OSIZE'b01111111100111011;
      dataout_expected[8] = dataout_tmp[7];

// pattern 9
      x_vec[9] = (`DSIZE'b1 << `DSIZE) -1;
      y_vec[9] = (`DSIZE'b1 << `DSIZE) -1;
      rst_vec[9] = 1'b0;
      dataout_tmp[9] = `OSIZE'd0;
      dataout_expected[9] = dataout_tmp[8];
end

// apply vectors and generate output files block

initial
begin
   RESULTFILE = $fopen("mac8x8_tb.results");
   ERRORFILE = $fopen("mac8x8_tb.errors");
   STATUSFILE = $fopen("mac8x8_tb.status");

   $fwrite(RESULTFILE,
   "Vec_number   x y clk rst = dataout \n\n\n");
   ERROR_CNT = 0;
   $display("\nStarting Simulation...\n");
   @(posedge clk) ;  // skip the first rising edge
   for (VECTOR_CNT = 0; VECTOR_CNT<= MAX_VECTORS-1; VECTOR_CNT=VECTOR_CNT+1)
   begin
      @(negedge clk); // apply vectors
      x = x_vec[VECTOR_CNT];
      y = y_vec[VECTOR_CNT];
      rst = rst_vec[VECTOR_CNT];
      @(posedge clk) # (CLOCK_PERIOD/4); // sample outputs
      if ((dataout != dataout_expected[VECTOR_CNT]) || (^dataout === 1'bx ))
      begin
         $fdisplay (ERRORFILE, "Error: pattern#%4d", VECTOR_CNT);
         $fdisplay (ERRORFILE, "time%d:", $time);
         $fdisplay (ERRORFILE,
         "Expected dataout = %b", dataout_expected[VECTOR_CNT]);
         $fdisplay (ERRORFILE, "Actual dataout = %b\n", dataout);
         ERROR_CNT = ERROR_CNT+1;
      end
      $fwrite(RESULTFILE, "%3d %b %b %b %b = %b\n",
      VECTOR_CNT, x, y, clk, rst, dataout);
   end
   if (ERROR_CNT == 0)
   begin
      $display("Simulation Passed!");
      $fdisplay(STATUSFILE,"pass\n");
   end
   else
   begin
      $display("Simulation Failed!");
      $fdisplay(STATUSFILE,"fail\n");
   end
   $fclose(RESULTFILE);
   $fclose(ERRORFILE);
   $fclose(STATUSFILE);

   $display("\n Writing mac8x8_tb.results\n");

   #(CLOCK_PERIOD/4) $finish;
end

// create clock patterns

initial clk = 1;

always
begin
   # ((CLOCK_PERIOD)/2) clk = ~clk;
end
endmodule
