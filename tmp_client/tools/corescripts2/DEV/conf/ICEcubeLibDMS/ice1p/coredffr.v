//************************************************
//Title:    coredffr
//Design:   cordeffr.v
//Author:  
//Company:  SiliconBlue Technologies, Inc.
//Version:  D0.2
//
//INIT: March 15, 2007
//
//Revision : June 9, 2007  Modify name, add purst.
//           and change polarity
//************************************************
`timescale 1ns/10ps
module coredffr (q, d, purst, S_R, cbit, clk, clkb);
output q;
input d, purst, S_R, clk, clkb;
input [1:0] cbit;


`ifdef TIMINGCHECK
reg NOTIFIER;

  specify
    specparam
    tplh$sr$q = 1.0,
    tphl$sr$q = 1.0,
    tplh$purst$q = 1.0,
    tphl$purst$q  = 1.0,
    tplh$clk$q = 1.0,
    tphl$clk$q = 1.0,
    tsetup$d$clk = 1.0,
    thold$d$clk	= 1.0,
    tsetup$srsr$clk = 1.0,
    thold$srsr$clk = 1.0,
    tminpwh$sr     = 1.0,
    tminpwl$clk    = 1.0,
    tminpwh$clk    = 1.0;

//path delays
    if (S_R == 1'b0)
      (posedge clk *> (q +: d)) = (tplh$clk$q, tphl$clk$q);
    (posedge purst *> (q  +: 0) ) = (tplh$purst$q, tphl$purst$q);
    if (cbit[1:0] == 2'b10)
      (posedge S_R *> (q  +: 1) ) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b11)
      (posedge S_R *> (q  +: 0) ) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b00)
      (posedge clk *> (q +: 1)) = (tplh$sr$q, tphl$sr$q);
    if (cbit[1:0] == 2'b01)
      (posedge clk *> (q +: 0)) = (tplh$sr$q, tphl$sr$q);

//timing checks     
    $setuphold(posedge clk &&& (S_R == 1'b0), posedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);
    $setuphold(posedge clk &&& (S_R == 1'b0), negedge d, tsetup$d$clk, thold$d$clk, NOTIFIER);    
    $setuphold(posedge clk &&& (cbit[1] == 1'b0), posedge S_R , tsetup$srsr$clk, thold$srsr$clk, NOTIFIER);
    $width(posedge S_R &&& (cbit[1] == 1'b1), tminpwh$sr, 0, NOTIFIER);
    $width(negedge clk, tminpwl$clk, 0, NOTIFIER);
    $width(posedge clk, tminpwh$clk, 0, NOTIFIER); 
   endspecify
`endif

reg qint = 0;  
wire intasr;
assign intasr = purst || (S_R && cbit[1]);

assign q = (((purst ^ S_R ^ cbit[0] ^ cbit[1])==1) || ((purst ^ S_R ^ cbit[0] ^ cbit[1])==0)) ? qint : 1'b0;

always @(posedge intasr or posedge clk)
   if (S_R && cbit===2'b11) qint <= 1;
   else if (!purst && S_R && cbit===2'b10) qint <= 0;
   else if (purst && !S_R) qint <= 0;
   else begin
      if (!purst && S_R && cbit===2'b00) qint <= 1'b0;
      else if (!purst && S_R && cbit===2'b01) qint <= 1'b1;
      else if (!purst&& !S_R) qint <= d;
      end
      
endmodule // coredffr

