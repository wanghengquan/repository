
`timescale 1ns/1ns
`include "nvcm_defines.v"

module nvcm_model (
	rst_b,
	clk,
	
	force_pgm_err,
	force_rowadd,
	force_coladd,
	force_blkadd,
	
	fsm_nv_bstream,
	fsm_nv_rri_trim,
	fsm_nv_sisi_ui,
	fsm_nv_redrow,
//	fsm_redrowadd,
	
	fsm_coladd,
	fsm_rowadd,
	fsm_blkadd,
	fsm_pgm,
	fsm_rd,
	fsm_pgmhv,
	fsm_din,
	fsm_sample,
	nv_dataout
);

// Parameter declarations
parameter Tp = 1;

parameter bstream_file_name   = "mboot_bstream.txt";
parameter rritrim_file_name   = "rritrim.txt";
parameter redrow_file_name   = "redrow.txt";
parameter AddrRANGE = 18'h3FFFF;
parameter MaxData = 255;

input	wire rst_b;
input  	wire clk;

input			fsm_nv_bstream ;
input			fsm_nv_rri_trim;
input			fsm_nv_sisi_ui;
input			fsm_nv_redrow;
//input	[3:0]	fsm_redrowadd;

input	[`MAX_COLADD_BN -1:0]	fsm_coladd;
input	[`MAX_ROWADD_BN -1:0]	fsm_rowadd;
input	[`MAX_BLKADD_BN -1:0]	fsm_blkadd;
input			fsm_pgm;
input			fsm_rd;
input			fsm_pgmhv;
input			fsm_din;
input			fsm_sample;
output 	[8:0]	nv_dataout;
reg 	[8:0]	nv_dataout;


////////////////////////////////////////////////
// Variable declaration
////////////////////////////////////////////////
reg	[8:0]	nvcm_bank [`MAX_ROWADD:0][`MAX_COLADD:0];
reg	[8:0]	red_bank [15:0][`MAX_COLADD:0];
reg	[8:0]	rritrim_bank [`MAX_COLADD:0];
reg	[8:0]	sisiui_bank [`MAX_COLADD:0];

reg	[8:0]	bstream_1row [`MAX_COLADD:0];
reg	[8:0] tmp_data;
/*
reg 	[7:0]	force_pgm_err;
reg	[`MAX_COLADD_BN -1:0]	force_coladd;
reg	[`MAX_ROWADD_BN -1:0]	force_rowadd;
reg	[`MAX_BLKADD_BN -1:0]	force_blkadd;
*/
input 	[7:0]	force_pgm_err;
input	[`MAX_COLADD_BN -1:0]	force_coladd;
input	[`MAX_ROWADD_BN -1:0]	force_rowadd;
input	[`MAX_BLKADD_BN -1:0]	force_blkadd;

///////////////////////////////////
// module body
///////////////////////////////////
/*
initial
begin
	force_pgm_err = 0;
	force_coladd =0;
	force_rowadd =0;
	force_blkadd =0;
end
*/
initial
begin: Init_nvcm
    integer i, j, k;

       for (j=0;j<=`MAX_ROWADD ;j=j+1)
         for (k=0;k<=`MAX_COLADD ;k=k+1)
        begin
            nvcm_bank[j][k] = 0;
        end
		
         for (k=0;k<=`MAX_COLADD ;k=k+1)
        begin
			bstream_1row[k] = 0;
        end
		
//  		$readmemh(bstream_file_name, bstream_1row);
		  
         for (k=0;k<=`MAX_COLADD ;k=k+1)
        begin
			nvcm_bank[0][k] = bstream_1row[k];
        end
end
	
initial
begin: Init_red
    integer i, j, k;

       for (j=0;j<=15 ;j=j+1)
         for (k=0;k<=`MAX_COLADD ;k=k+1)
        begin
            red_bank[j][k] = 0;
        end
end
	
initial
begin: Init_rritrim_sisiui
    integer i, j, k;

         for (k=0;k<=`MAX_COLADD ;k=k+1)
        begin
            rritrim_bank[k] = 0;
            sisiui_bank[k] = 0;
        end
		
  		$readmemh(rritrim_file_name, rritrim_bank);
end


always @(posedge clk or negedge rst_b)
begin
	if (!rst_b)
		tmp_data =  0;
	else if (fsm_nv_bstream && fsm_pgm && fsm_pgmhv)
		begin
		tmp_data = nvcm_bank[fsm_rowadd][fsm_coladd];
		tmp_data[fsm_blkadd] = fsm_din;
		
		if ((force_pgm_err > 0) && 
			(force_rowadd == fsm_rowadd) && (force_coladd == fsm_coladd))
			begin
				if ((force_pgm_err == 1) && (force_blkadd == fsm_blkadd))
					tmp_data[fsm_blkadd] = !fsm_din;
				else if (force_pgm_err >= 2)
					tmp_data[fsm_blkadd] = !fsm_din;
			end
		nvcm_bank[fsm_rowadd][fsm_coladd] = tmp_data;
		end
end	

always @(posedge clk or negedge rst_b)
begin
	if (!rst_b)
		tmp_data =  0;
	else if (fsm_nv_redrow && fsm_pgm && fsm_pgmhv)
		begin
		tmp_data = red_bank[fsm_rowadd[3:0]][fsm_coladd];
		tmp_data[fsm_blkadd] = fsm_din;
		red_bank[fsm_rowadd[3:0]][fsm_coladd] = tmp_data;
		end
end	

always @(posedge clk or negedge rst_b)
begin
	if (!rst_b)
		tmp_data =  0;
	else if (fsm_nv_rri_trim && fsm_pgm && fsm_pgmhv)
		begin
		tmp_data = rritrim_bank[fsm_coladd];
		tmp_data[fsm_blkadd] = fsm_din;
		rritrim_bank[fsm_coladd] = tmp_data;
		end
end	

always @(posedge clk or negedge rst_b)
begin
	if (!rst_b)
		tmp_data =  0;
	else if (fsm_nv_sisi_ui && fsm_pgm && fsm_pgmhv)
		begin
		tmp_data = sisiui_bank[fsm_coladd];
		tmp_data[fsm_blkadd] = fsm_din;
		sisiui_bank[fsm_coladd] = tmp_data;
		end
end	

always @(posedge fsm_sample or negedge rst_b)
begin
	if (!rst_b)
		nv_dataout <= #Tp 0;
	else if (fsm_nv_bstream)
		nv_dataout <= #Tp nvcm_bank[fsm_rowadd][fsm_coladd];
	else if (fsm_nv_redrow)
		nv_dataout <= #Tp red_bank[fsm_rowadd[3:0]][fsm_coladd];
	else if (fsm_nv_rri_trim)
		nv_dataout <= #Tp rritrim_bank[fsm_coladd];
	else if (fsm_nv_sisi_ui)
		nv_dataout <= #Tp sisiui_bank[fsm_coladd];
end	

endmodule


