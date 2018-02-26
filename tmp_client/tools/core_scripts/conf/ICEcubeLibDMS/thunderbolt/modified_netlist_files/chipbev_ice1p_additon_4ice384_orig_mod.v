module sbox1m3to1_icc (in0, in1, in2, op, prog, c, cb);

//port signals
input in0, in1, in2;
output op;
input [1:0] c, cb;
input  prog;

reg op;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$in0$op= 1.0,
      tphl$in0$op= 1.0,
      tplh$in1$op= 1.0,
      tphl$in1$op= 1.0,
      tplh$in2$op= 1.0,
      tphl$in2$op= 1.0,
      tplh$c1$op= 1.0,
      tphl$c1$op= 1.0,
      tplh$c0$op= 1.0,
      tphl$c0$op= 1.0,
      tplh$cb1$op= 1.0,
      tphl$cb1$op= 1.0,
      tplh$cb0$op= 1.0,
      tphl$cb0$op= 1.0,
      tplh$prog$op= 1.0,
      tphl$prog$op= 1.0;

    // path delays
     (in0 *> op) = (tplh$in0$op, tphl$in0$op);
     (in1 *> op) = (tplh$in1$op, tphl$in1$op);
     (in2 *> op) = (tplh$in2$op, tphl$in2$op);
     (c1 *> op) = (tplh$c1$op, tphl$c1$op);
     (c0 *> op) = (tplh$c0$op, tphl$c0$op);
     (cb1 *> op) = (tplh$cb1$op, tphl$cb1$op);
     (cb0 *> op) = (tplh$cb0$op, tphl$cb0$op);
     (prog *> op) = (tplh$prog$op, tphl$prog$op);
  endspecify
`endif


always @(in0 or in1 or in2 or prog or c[1:0] or cb[1:0])
   if (prog) op = 1'bz;
   else if (c[1:0]==2'b00 && cb[1:0]==2'b11) op = 1'bz;
   else if (!prog && c[1:0]==2'b01 && cb[1:0]==2'b10) op = in0;
   else if (!prog && c[1:0]==2'b10 && cb[1:0]==2'b01) op = in1;
   else if (!prog && c[1:0]==2'b11 && cb[1:0]==2'b00) op = in2;
   else op = 1'bx;

endmodule // sbox1m3to1


module in_mux_nand_icc ( inmuxo, cbit, cbitb, min, op_bot, prog );

//the output signal
output  inmuxo;
//the input signals
//input [0:5]  cbit;
//input [0:5]  cbitb;
input [5:0]  cbit;
input [5:0]  cbitb;
input [15:0]  min;
input  op_bot;
input prog;

reg inmuxo;

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$min0$inmuxo= 1.0,
      tphl$min0$inmuxo= 1.0,
      tplh$min1$inmuxo= 1.0,
      tphl$min1$inmuxo= 1.0,
      tplh$min2$inmuxo= 1.0,
      tphl$min2$inmuxo= 1.0,
      tplh$min3$inmuxo= 1.0,
      tphl$min3$inmuxo= 1.0,
      tplh$min4$inmuxo= 1.0,
      tphl$min4$inmuxo= 1.0,
      tplh$min5$inmuxo= 1.0,
      tphl$min5$inmuxo= 1.0,
      tplh$min6$inmuxo= 1.0,
      tphl$min6$inmuxo= 1.0,
      tplh$min7$inmuxo= 1.0,
      tphl$min7$inmuxo= 1.0;
      tplh$min8$inmuxo= 1.0,
      tphl$min8$inmuxo= 1.0,
      tplh$min9$inmuxo= 1.0,
      tphl$min9$inmuxo= 1.0,
      tplh$min10$inmuxo= 1.0,
      tphl$min10$inmuxo= 1.0,
      tplh$min11$inmuxo= 1.0,
      tphl$min11$inmuxo= 1.0,
      tplh$min12$inmuxo= 1.0,
      tphl$min12$inmuxo= 1.0,
      tplh$min13$inmuxo= 1.0,
      tphl$min13$inmuxo= 1.0,
      tplh$min14$inmuxo= 1.0,
      tphl$min14$inmuxo= 1.0,
      tplh$min15$inmuxo= 1.0,
      tphl$min15$inmuxo= 1.0,
      tplh$op_bot$inmuxo= 1.0,
      tphl$op_bot$inmuxo= 1.0,
    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
     (op_bot*> inmuxo) = (tplh$op_bot$inmuxo, tphl$op_bot$inmuxo);
   endspecify
`endif

wire tmp;
  primit_in_mux in_mux9 (tmp, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);

always @ (prog or tmp or op_bot or cbit or cbitb)
begin
	if	(cbitb!== ~cbit)
		inmuxo = 1'bx;	
	else if (prog)
	     if (cbit[5]) inmuxo = op_bot & op_bot;		
	     else inmuxo = 1'b0;
	else if (!prog && cbit[5])
		inmuxo = tmp || op_bot;
        else
		inmuxo	=	tmp;	
end		

endmodule  //in_mux_nand_icc

module in_mux_thunder (inmuxo, inmuxo2, cbit, cbitb, min, prog);

//the output signal
output inmuxo;
output inmuxo2;

//the input signals
input [15:0] min;
input [4:0] cbit, cbitb;
input  prog;

  primit_in_mux I2 (inmuxo2, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);
  primit_in_mux I_orig (inmuxo, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$min0$inmuxo= 1.0,
      tphl$min0$inmuxo= 1.0,
      tplh$min1$inmuxo= 1.0,
      tphl$min1$inmuxo= 1.0,
      tplh$min2$inmuxo= 1.0,
      tphl$min2$inmuxo= 1.0,
      tplh$min3$inmuxo= 1.0,
      tphl$min3$inmuxo= 1.0,
      tplh$min4$inmuxo= 1.0,
      tphl$min4$inmuxo= 1.0,
      tplh$min5$inmuxo= 1.0,
      tphl$min5$inmuxo= 1.0,
      tplh$min6$inmuxo= 1.0,
      tphl$min6$inmuxo= 1.0,
      tplh$min7$inmuxo= 1.0,
      tphl$min7$inmuxo= 1.0,
      tplh$min8$inmuxo= 1.0,
      tphl$min8$inmuxo= 1.0,
      tplh$min9$inmuxo= 1.0,
      tphl$min9$inmuxo= 1.0,
      tplh$min10$inmuxo= 1.0,
      tphl$min10$inmuxo= 1.0,
      tplh$min11$inmuxo= 1.0,
      tphl$min11$inmuxo= 1.0,
      tplh$min12$inmuxo= 1.0,
      tphl$min12$inmuxo= 1.0,
      tplh$min13$inmuxo= 1.0,
      tphl$min13$inmuxo= 1.0,
      tplh$min14$inmuxo= 1.0,
      tphl$min14$inmuxo= 1.0,
      tplh$min15$inmuxo= 1.0,
      tphl$min15$inmuxo= 1.0,
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$cbit4$inmuxo= 1.0,
      tphl$cbit4$inmuxo= 1.0,
      tplh$cbit3$inmuxo= 1.0,
      tphl$cbit3$inmuxo= 1.0,
      tplh$cbit2$inmuxo= 1.0,
      tphl$cbit2$inmuxo= 1.0,
      tplh$cbit1$inmuxo= 1.0,
      tphl$cbit1$inmuxo= 1.0,
      tplh$cbit0$inmuxo= 1.0,
      tphl$cbit0$inmuxo= 1.0,
      tplh$cbitb4$inmuxo= 1.0,
      tphl$cbitb4$inmuxo= 1.0,
      tplh$cbitb3$inmuxo= 1.0,
      tphl$cbitb3$inmuxo= 1.0,
      tplh$cbitb2$inmuxo= 1.0,
      tphl$cbitb2$inmuxo= 1.0,
      tplh$cbitb1$inmuxo= 1.0,
      tphl$cbitb1$inmuxo= 1.0,
      tplh$cbitb0$inmuxo= 1.0,
      tphl$cbitb0$inmuxo= 1.0;

    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (cbit[4] *> inmuxo) = (tplh$cbit4$inmuxo, tphl$cbit4$inmuxo);
     (cbit[3] *> inmuxo) = (tplh$cbit3$inmuxo, tphl$cbit3$inmuxo);
     (cbit[2] *> inmuxo) = (tplh$cbit2$inmuxo, tphl$cbit2$inmuxo);
     (cbit[1] *> inmuxo) = (tplh$cbit1$inmuxo, tphl$cbit1$inmuxo);
     (cbit[0] *> inmuxo) = (tplh$cbit0$inmuxo, tphl$cbit0$inmuxo);
     (cbitb[4] *> inmuxo) = (tplh$cbitb4$inmuxo, tphl$cbitb4$inmuxo);
     (cbitb[3] *> inmuxo) = (tplh$cbitb3$inmuxo, tphl$cbitb3$inmuxo);
     (cbitb[2] *> inmuxo) = (tplh$cbitb2$inmuxo, tphl$cbitb2$inmuxo);
     (cbitb[1] *> inmuxo) = (tplh$cbitb1$inmuxo, tphl$cbitb1$inmuxo);
     (cbitb[0] *> inmuxo) = (tplh$cbitb0$inmuxo, tphl$cbitb0$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
     (prog *> inmuxo2) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (cbit[4] *> inmuxo2) = (tplh$cbit4$inmuxo, tphl$cbit4$inmuxo);
     (cbit[3] *> inmuxo2) = (tplh$cbit3$inmuxo, tphl$cbit3$inmuxo);
     (cbit[2] *> inmuxo2) = (tplh$cbit2$inmuxo, tphl$cbit2$inmuxo);
     (cbit[1] *> inmuxo2) = (tplh$cbit1$inmuxo, tphl$cbit1$inmuxo);
     (cbit[0] *> inmuxo2) = (tplh$cbit0$inmuxo, tphl$cbit0$inmuxo);
     (cbitb[4] *> inmuxo2) = (tplh$cbitb4$inmuxo, tphl$cbitb4$inmuxo);
     (cbitb[3] *> inmuxo2) = (tplh$cbitb3$inmuxo, tphl$cbitb3$inmuxo);
     (cbitb[2] *> inmuxo2) = (tplh$cbitb2$inmuxo, tphl$cbitb2$inmuxo);
     (cbitb[1] *> inmuxo2) = (tplh$cbitb1$inmuxo, tphl$cbitb1$inmuxo);
     (cbitb[0] *> inmuxo2) = (tplh$cbitb0$inmuxo, tphl$cbitb0$inmuxo);
     (min[0] *> inmuxo2) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo2) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo2) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo2) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo2) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo2) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo2) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo2) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo2) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo2) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo2) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo2) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo2) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo2) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo2) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo2) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
  endspecify
`endif

endmodule // in_mux_icc
module in_mux_icc (inmuxo, cbit, cbitb, min, prog);

//the output signal
output inmuxo;

//the input signals
input [15:0] min;
input [4:0] cbit, cbitb;
input  prog;

  primit_in_mux in_mux10 (inmuxo, min[15], min[14], min[13], min[12], min[11],
      min[10], min[9], min[8], min[7], min[6], min[5], min[4], 
      min[3], min[2], min[1], min[0], cbit[4], cbit[3], cbit[2], 
      cbit[1], cbit[0], cbitb[4], cbitb[3], cbitb[2], cbitb[1], cbitb[0], prog);

`ifdef TIMINGCHECK
  specify
    // delay parameters
    specparam
      tplh$min0$inmuxo= 1.0,
      tphl$min0$inmuxo= 1.0,
      tplh$min1$inmuxo= 1.0,
      tphl$min1$inmuxo= 1.0,
      tplh$min2$inmuxo= 1.0,
      tphl$min2$inmuxo= 1.0,
      tplh$min3$inmuxo= 1.0,
      tphl$min3$inmuxo= 1.0,
      tplh$min4$inmuxo= 1.0,
      tphl$min4$inmuxo= 1.0,
      tplh$min5$inmuxo= 1.0,
      tphl$min5$inmuxo= 1.0,
      tplh$min6$inmuxo= 1.0,
      tphl$min6$inmuxo= 1.0,
      tplh$min7$inmuxo= 1.0,
      tphl$min7$inmuxo= 1.0,
      tplh$min8$inmuxo= 1.0,
      tphl$min8$inmuxo= 1.0,
      tplh$min9$inmuxo= 1.0,
      tphl$min9$inmuxo= 1.0,
      tplh$min10$inmuxo= 1.0,
      tphl$min10$inmuxo= 1.0,
      tplh$min11$inmuxo= 1.0,
      tphl$min11$inmuxo= 1.0,
      tplh$min12$inmuxo= 1.0,
      tphl$min12$inmuxo= 1.0,
      tplh$min13$inmuxo= 1.0,
      tphl$min13$inmuxo= 1.0,
      tplh$min14$inmuxo= 1.0,
      tphl$min14$inmuxo= 1.0,
      tplh$min15$inmuxo= 1.0,
      tphl$min15$inmuxo= 1.0,
      tplh$prog$inmuxo= 1.0,
      tphl$prog$inmuxo= 1.0,
      tplh$cbit4$inmuxo= 1.0,
      tphl$cbit4$inmuxo= 1.0,
      tplh$cbit3$inmuxo= 1.0,
      tphl$cbit3$inmuxo= 1.0,
      tplh$cbit2$inmuxo= 1.0,
      tphl$cbit2$inmuxo= 1.0,
      tplh$cbit1$inmuxo= 1.0,
      tphl$cbit1$inmuxo= 1.0,
      tplh$cbit0$inmuxo= 1.0,
      tphl$cbit0$inmuxo= 1.0,
      tplh$cbitb4$inmuxo= 1.0,
      tphl$cbitb4$inmuxo= 1.0,
      tplh$cbitb3$inmuxo= 1.0,
      tphl$cbitb3$inmuxo= 1.0,
      tplh$cbitb2$inmuxo= 1.0,
      tphl$cbitb2$inmuxo= 1.0,
      tplh$cbitb1$inmuxo= 1.0,
      tphl$cbitb1$inmuxo= 1.0,
      tplh$cbitb0$inmuxo= 1.0,
      tphl$cbitb0$inmuxo= 1.0;

    // path delays
     (prog *> inmuxo) = (tplh$prog$inmuxo, tphl$prog$inmuxo);
     (cbit[4] *> inmuxo) = (tplh$cbit4$inmuxo, tphl$cbit4$inmuxo);
     (cbit[3] *> inmuxo) = (tplh$cbit3$inmuxo, tphl$cbit3$inmuxo);
     (cbit[2] *> inmuxo) = (tplh$cbit2$inmuxo, tphl$cbit2$inmuxo);
     (cbit[1] *> inmuxo) = (tplh$cbit1$inmuxo, tphl$cbit1$inmuxo);
     (cbit[0] *> inmuxo) = (tplh$cbit0$inmuxo, tphl$cbit0$inmuxo);
     (cbitb[4] *> inmuxo) = (tplh$cbitb4$inmuxo, tphl$cbitb4$inmuxo);
     (cbitb[3] *> inmuxo) = (tplh$cbitb3$inmuxo, tphl$cbitb3$inmuxo);
     (cbitb[2] *> inmuxo) = (tplh$cbitb2$inmuxo, tphl$cbitb2$inmuxo);
     (cbitb[1] *> inmuxo) = (tplh$cbitb1$inmuxo, tphl$cbitb1$inmuxo);
     (cbitb[0] *> inmuxo) = (tplh$cbitb0$inmuxo, tphl$cbitb0$inmuxo);
     (min[0] *> inmuxo) = (tplh$min0$inmuxo, tphl$min0$inmuxo);
     (min[1] *> inmuxo) = (tplh$min1$inmuxo, tphl$min1$inmuxo);
     (min[2] *> inmuxo) = (tplh$min2$inmuxo, tphl$min2$inmuxo);
     (min[3] *> inmuxo) = (tplh$min3$inmuxo, tphl$min3$inmuxo);
     (min[4] *> inmuxo) = (tplh$min4$inmuxo, tphl$min4$inmuxo);
     (min[5] *> inmuxo) = (tplh$min5$inmuxo, tphl$min5$inmuxo);
     (min[6] *> inmuxo) = (tplh$min6$inmuxo, tphl$min6$inmuxo);
     (min[7] *> inmuxo) = (tplh$min7$inmuxo, tphl$min7$inmuxo);
     (min[8] *> inmuxo) = (tplh$min8$inmuxo, tphl$min8$inmuxo);
     (min[9] *> inmuxo) = (tplh$min9$inmuxo, tphl$min9$inmuxo);
     (min[10] *> inmuxo) = (tplh$min10$inmuxo, tphl$min10$inmuxo);
     (min[11] *> inmuxo) = (tplh$min11$inmuxo, tphl$min11$inmuxo);
     (min[12] *> inmuxo) = (tplh$min12$inmuxo, tphl$min12$inmuxo);
     (min[13] *> inmuxo) = (tplh$min13$inmuxo, tphl$min12$inmuxo);
     (min[14] *> inmuxo) = (tplh$min14$inmuxo, tphl$min14$inmuxo);
     (min[15] *> inmuxo) = (tplh$min15$inmuxo, tphl$min15$inmuxo);
  endspecify
`endif

endmodule // in_mux_icc

module clk_mux12to1_icc	(
							clk,
							clkb,
							cbit,
							cbitb,
							cenb,
							min,
							prog
							);

input	[11:0]	min;
input	[5:0]	cbit;
input	[5:0]	cbitb;
input			cenb;
input			prog;

output			clk;
output			clkb;


assign	clkb=~clk;

reg		sel_temp;

always	@ (min, cbit, cbitb, cenb, prog)
begin
	if	(cbit!=~cbitb)
		sel_temp	=	1'bx;
	else
	if	(cbit[5]===1'b1)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = min[0];
		4'b0001	:	sel_temp = min[1];
		4'b0010	:	sel_temp = min[2];
		4'b0011	:	sel_temp = min[3];
		4'b0100	:	sel_temp = min[4];
		4'b0101	:	sel_temp = min[5];
		4'b0110	:	sel_temp = min[6];
		4'b0111	:	sel_temp = min[7];
		4'b1000	:	sel_temp = min[8];
		4'b1001	:	sel_temp = min[9];
		4'b1010	:	sel_temp = min[10];
		4'b1011	:	sel_temp = min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
	if	(cbit[5]===1'b0)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = ~min[0];
		4'b0001	:	sel_temp = ~min[1];
		4'b0010	:	sel_temp = ~min[2];
		4'b0011	:	sel_temp = ~min[3];
		4'b0100	:	sel_temp = ~min[4];
		4'b0101	:	sel_temp = ~min[5];
		4'b0110	:	sel_temp = ~min[6];
		4'b0111	:	sel_temp = ~min[7];
		4'b1000	:	sel_temp = ~min[8];
		4'b1001	:	sel_temp = ~min[9];
		4'b1010	:	sel_temp = ~min[10];
		4'b1011	:	sel_temp = ~min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
		sel_temp = 1'bx;	
end

//assign	clk	=	~(sel_temp || prog || cbitb[4] || cenb);
reg q_cenb;
always @(sel_temp or prog or cbitb[4] or cenb)
	if (prog||cbitb[4])  q_cenb = 1'b1;
	else if (sel_temp) q_cenb = cenb;

assign	clk	=~(sel_temp || q_cenb);

endmodule  //clk_mux12to1_icc
module clk_mux12to1_icc2	(
							clk,
							clkb,
							cbit,
							cbitb,
							cenb,
							min,
							prog
							);

input	[11:0]	min;
input	[5:0]	cbit;
input	[5:0]	cbitb;
input			cenb;
input			prog;

output			clk;
output			clkb;


assign	clkb=~clk;

reg		sel_temp;

always	@ (min, cbit, cbitb, cenb, prog)
begin
	if	(cbit!=~cbitb)
		sel_temp	=	1'bx;
	else
	if	(cbit[5]===1'b1)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = min[0];
		4'b0001	:	sel_temp = min[1];
		4'b0010	:	sel_temp = min[2];
		4'b0011	:	sel_temp = min[3];
		4'b0100	:	sel_temp = min[4];
		4'b0101	:	sel_temp = min[5];
		4'b0110	:	sel_temp = min[6];
		4'b0111	:	sel_temp = min[7];
		4'b1000	:	sel_temp = min[8];
		4'b1001	:	sel_temp = min[9];
		4'b1010	:	sel_temp = min[10];
		4'b1011	:	sel_temp = min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
	if	(cbit[5]===1'b0)
		case	(cbit[3:0])
		4'b0000	:	sel_temp = ~min[0];
		4'b0001	:	sel_temp = ~min[1];
		4'b0010	:	sel_temp = ~min[2];
		4'b0011	:	sel_temp = ~min[3];
		4'b0100	:	sel_temp = ~min[4];
		4'b0101	:	sel_temp = ~min[5];
		4'b0110	:	sel_temp = ~min[6];
		4'b0111	:	sel_temp = ~min[7];
		4'b1000	:	sel_temp = ~min[8];
		4'b1001	:	sel_temp = ~min[9];
		4'b1010	:	sel_temp = ~min[10];
		4'b1011	:	sel_temp = ~min[11];
		default	:	sel_temp = 1'bx;
		endcase
	else
		sel_temp = 1'bx;	
end

//assign	clk	=	~(sel_temp || prog || cbitb[4] || cenb);
reg q_cenb;
always @(sel_temp or prog or cbitb[4] or cenb)
	if (prog||cbitb[4])  q_cenb = 1'b1;
	else if (sel_temp) q_cenb = cenb;

assign	clk	=~(sel_temp || q_cenb);

endmodule  //clk_mux12to1_icc2
