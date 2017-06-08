//Verilog HDL for "umc40lp_delay", "thunder_50nsdelay" "functional"


//module thunder_50nsdelay ( out, in );
module delayline50n ( out, in, VCC, VSS );
  input VCC;
  input VSS;
  input in;
  output out;
  buf #50 u0 (out, in);
endmodule
