//module chip_lvs

module P_11_LPHVT(D,S,G,B);
inout D;
input B,G,S;
pmos (D, S, G); // D S G for ltile
endmodule

module N_11_LPHVT(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

module P_25OD33_LP(D,S,G,B);
inout D;
input B,G,S;
pmos (D, S, G); // D S G for ltile
endmodule

module N_25OD33_LP(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

module N_25OD33_LPNVT(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

/*
module P_25_LP(D,S,G,B);
inout S,D;
input B,G;
pmos (D, S, G); // D S G for ltile
endmodule
*/
module N_25_LP(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

module P_11_LPRVT(D,S,G,B);
inout S,D;
input B,G;
pmos (D, S, G); // D S G for ltile
endmodule

module N_11_LPRVT(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

module P_25_LPNVT(D,S,G,B);
inout D;
input B,G,S;
pmos (D, S, G); // D S G for ltile
endmodule

module N_25_LPNVT(D,S,G,B);
inout D;
input B,G,S;
nmos (D, S, G); // D S G
endmodule

module PNP_V45X45_LP(C,B,E);
inout E;
input C,B;
nmos (E, B, C); 
endmodule


module RM8 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;
tran t1(MINUS, PLUS);
endmodule

module RM7 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;
tran t1(MINUS, PLUS);
endmodule

module RM6 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;
tran t1(MINUS, PLUS);
endmodule

module RM3 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;
tran t1(MINUS, PLUS);
endmodule

module RM4 (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;
tran t1(MINUS, PLUS);
endmodule

module NCAP_25_LP (MINUS, PLUS);
	inout MINUS;
	inout	PLUS;

tran t1(MINUS, PLUS);
endmodule

module primRes3  (MINUS, PLUS, B);
	inout MINUS;
	inout	PLUS;
	inout B;
tran t1(MINUS, PLUS);
endmodule

