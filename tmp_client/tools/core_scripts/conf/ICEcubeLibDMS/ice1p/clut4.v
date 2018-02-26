`timescale 1ns/1ns

module clut4vic (lut4, lut4vic, in0, in1, in2, in3, in0b, in1b, in2b, in3b, cbit);

//the output signal
output lut4, lut4vic;

//the input signals
input in0, in1, in2, in3, in0b, in1b, in2b, in3b;
input [15:0] cbit;

reg lut4;
      
`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$cbit0$lut4= 1.0,
      tphl$cbit0$lut4= 1.0,
      tplh$cbit1$lut4= 1.0,
      tphl$cbit1$lut4= 1.0,
      tplh$cbit2$lut4= 1.0,
      tphl$cbit2$lut4= 1.0,
      tplh$cbit3$lut4= 1.0,
      tphl$cbit3$lut4= 1.0,
      tplh$cbit4$lut4= 1.0,
      tphl$cbit4$lut4= 1.0,
      tplh$cbit5$lut4= 1.0,
      tphl$cbit5$lut4= 1.0,
      tplh$cbit6$lut4= 1.0,
      tphl$cbit6$lut4= 1.0,
      tplh$cbit7$lut4= 1.0,
      tphl$cbit7$lut4= 1.0,
      tplh$cbit8$lut4= 1.0,
      tphl$cbit8$lut4= 1.0,
      tplh$cbit9$lut4= 1.0,
      tphl$cbit9$lut4= 1.0,
      tplh$cbit10$lut4= 1.0,
      tphl$cbit10$lut4= 1.0,
      tplh$cbit11$lut4= 1.0,
      tphl$cbit11$lut4= 1.0,
      tplh$cbit12$lut4= 1.0,
      tphl$cbit12$lut4= 1.0,
      tplh$cbit13$lut4= 1.0,
      tphl$cbit13$lut4= 1.0,
      tplh$cbit14$lut4= 1.0,
      tphl$cbit14$lut4= 1.0,
      tplh$cbit15$lut4= 1.0,
      tphl$cbit15$lut4= 1.0,
      tplh$in3$lut4= 1.0,
      tphl$in3$lut4= 1.0,
      tplh$in2$lut4= 1.0,
      tphl$in2$lut4= 1.0,
      tplh$in1$lut4= 1.0,
      tphl$in1$lut4= 1.0,
      tplh$in0$lut4= 1.0,
      tphl$in0$lut4= 1.0;
      tplh$in3b$lut4= 1.0,
      tphl$in3b$lut4= 1.0,
      tplh$in2b$lut4= 1.0,
      tphl$in2b$lut4= 1.0,
      tplh$in1b$lut4= 1.0,
      tphl$in1b$lut4= 1.0,
      tplh$in0b$lut4= 1.0,
      tphl$in0b$lut4= 1.0;

    // path delays
     (cbit[15] *> lut4) = (tplh$cbit15$lut4, tphl$cbit15$lut4);
     (cbit[14] *> lut4) = (tplh$cbit14$lut4, tphl$cbit14$lut4);
     (cbit[13] *> lut4) = (tplh$cbit13$lut4, tphl$cbit13$lut4);
     (cbit[12] *> lut4) = (tplh$cbit12$lut4, tphl$cbit12$lut4);
     (cbit[11] *> lut4) = (tplh$cbit11$lut4, tphl$cbit11$lut4);
     (cbit[10] *> lut4) = (tplh$cbit10$lut4, tphl$cbit10$lut4);
     (cbit[9] *> lut4) = (tplh$cbit9$lut4, tphl$cbit9$lut4);
     (cbit[8] *> lut4) = (tplh$cbit8$lut4, tphl$cbit8$lut4);
     (cbit[7] *> lut4) = (tplh$cbit7$lut4, tphl$cbit7$lut4);
     (cbit[6] *> lut4) = (tplh$cbit6$lut4, tphl$cbit6$lut4);
     (cbit[5] *> lut4) = (tplh$cbit5$lut4, tphl$cbit5$lut4);
     (cbit[4] *> lut4) = (tplh$cbit4$lut4, tphl$cbit4$lut4);
     (cbit[3] *> lut4) = (tplh$cbit3$lut4, tphl$cbit3$lut4);
     (cbit[2] *> lut4) = (tplh$cbit2$lut4, tphl$cbit2$lut4);
     (cbit[1] *> lut4) = (tplh$cbit1$lut4, tphl$cbit1$lut4);
     (cbit[0] *> lut4) = (tplh$cbit0$lut4, tphl$cbit0$lut4);
     (in3 *> lut4) = (tplh$in3$lut4, tphl$in3$lut4);
     (in2 *> lut4) = (tplh$in2$lut4, tphl$in2$lut4);
     (in1 *> lut4) = (tplh$in1$lut4, tphl$in1$lut4);
     (in0 *> lut4) = (tplh$in0$lut4, tphl$in0$lut4);     
     (in3b *> lut4) = (tplh$in3b$lut4, tphl$in3b$lut4);
     (in2b *> lut4) = (tplh$in2b$lut4, tphl$in2b$lut4);
     (in1b *> lut4) = (tplh$in1b$lut4, tphl$in1b$lut4);
     (in0b *> lut4) = (tplh$in0b$lut4, tphl$in0b$lut4);     
  endspecify
`endif

   reg tmp;

   always @(in0 or in1 or in2 or in3 or in0b or in1b or in2b or in3b or cbit) begin

      tmp = in0 ^ in1 ^ in2 ^ in3;

      if ({in3, in2, in1, in0} != ~{in3b, in2b, in1b, in0b})
         lut4 = 1'bx;
      else if (tmp == 0 || tmp == 1)
         lut4 = cbit[{in3, in2, in1, in0}];
      else
         lut4 = lut_mux ({lut_mux (cbit[15:12], {in1, in0}), lut_mux (cbit[11:8], {in1, in0}), lut_mux (cbit[7:4], {in1, in0}), lut_mux (cbit[3:0], {in1, in0})}, {in3, in2});

   end


   function lut_mux;
   input [3:0] d;
   input [1:0] s;

      begin

         if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
            lut_mux = d[s];
         else if ((d[0] ^ d[1]) == 0 && (d[2] ^ d[3]) == 0 && (d[0] ^ d[2]) == 0)
            lut_mux = d[0];
         else if ((s[1] == 0) && (d[0] == d[1]))
            lut_mux = d[0];
         else if ((s[1] == 1) && (d[2] == d[3]))
            lut_mux = d[2];
         else if ((s[0] == 0) && (d[0] == d[2]))
            lut_mux = d[0];
         else if ((s[0] == 1) && (d[1] == d[3]))
            lut_mux = d[1];
         else
            lut_mux = 1'b0;

      end

   endfunction

   assign lut4vic = lut4;

endmodule // clut4

