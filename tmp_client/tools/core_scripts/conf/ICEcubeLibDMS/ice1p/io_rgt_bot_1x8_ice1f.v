// Library - ice1chip, Cell - io_rgt_bot_1x8_ice1f, View - schematic
// LAST TIME SAVED: Mar 10 17:31:55 2011
// NETLIST TIME: Jun 29 10:32:25 2011
`timescale 1ns / 1ns 

module io_rgt_bot_1x8_ice1f ( cf_r[191:0], fabric_out_01,
     fabric_out_02, fabric_out_08, padeb[12:0], pado[12:0], sdo,
     slf_op_01[3:0], slf_op_02[3:0], slf_op_03[3:0], slf_op_04[3:0],
     slf_op_05[3:0], slf_op_06[3:0], slf_op_07[3:0], slf_op_08[3:0],
     tck_pad, tclk_o, tdi_pad, tms_pad, SP4_h_l_01[47:0],
     SP4_h_l_02[47:0], SP4_h_l_03[47:0], SP4_h_l_04[47:0],
     SP4_h_l_05[47:0], SP4_h_l_06[47:0], SP4_h_l_07[47:0],
     SP4_h_l_08[47:0], SP12_h_l_01[23:0], SP12_h_l_02[23:0],
     SP12_h_l_03[23:0], SP12_h_l_04[23:0], SP12_h_l_05[23:0],
     SP12_h_l_06[23:0], SP12_h_l_07[23:0], SP12_h_l_08[23:0], bl[17:0],
     pgate[127:0], reset_b[127:0], sp4_v_b_13_09[15:0],
     sp4_v_t_08[15:0], vdd_cntl[127:0], wl[127:0], bnl_op_13_09[7:0],
     bs_en, ceb, glb_netwk_col[7:0], hiz_b, hold,
     jtag_rowtest_mode_rowu2_b, jtag_rowtest_mode_rowu3_b, last_rsr[2],
     last_rsr[3], lft_op_01[7:0], lft_op_02[7:0], lft_op_03[7:0],
     lft_op_04[7:0], lft_op_05[7:0], lft_op_06[7:0], lft_op_07[7:0],
     lft_op_08[7:0], mode, mux_jtag_sel_b, padin[12:0], prog, r, sdi,
     sdo_enable, shift, tclk, tnl_op_08[7:0], totdopad, trstb_pad,
     update );
output  fabric_out_01, fabric_out_02, fabric_out_08, sdo, tck_pad,
     tclk_o, tdi_pad, tms_pad;


input  bs_en, ceb, hiz_b, hold, jtag_rowtest_mode_rowu2_b,
     jtag_rowtest_mode_rowu3_b, mode, mux_jtag_sel_b, prog, r, sdi,
     sdo_enable, shift, tclk, totdopad, trstb_pad, update;

output [3:0]  slf_op_01;
output [3:0]  slf_op_08;
output [3:0]  slf_op_07;
output [3:0]  slf_op_02;
output [3:0]  slf_op_06;
output [12:0]  pado;
output [3:0]  slf_op_03;
output [191:0]  cf_r;
output [12:0]  padeb;
output [3:0]  slf_op_05;
output [3:0]  slf_op_04;

inout [23:0]  SP12_h_l_02;
inout [23:0]  SP12_h_l_06;
inout [23:0]  SP12_h_l_07;
inout [23:0]  SP12_h_l_03;
inout [47:0]  SP4_h_l_04;
inout [17:0]  bl;
inout [23:0]  SP12_h_l_04;
inout [47:0]  SP4_h_l_05;
inout [15:0]  sp4_v_t_08;
inout [47:0]  SP4_h_l_01;
inout [47:0]  SP4_h_l_06;
inout [47:0]  SP4_h_l_02;
inout [23:0]  SP12_h_l_05;
inout [47:0]  SP4_h_l_08;
inout [47:0]  SP4_h_l_03;
inout [15:0]  sp4_v_b_13_09;
inout [127:0]  reset_b;
inout [127:0]  vdd_cntl;
inout [127:0]  wl;
inout [23:0]  SP12_h_l_01;
inout [127:0]  pgate;
inout [23:0]  SP12_h_l_08;
inout [47:0]  SP4_h_l_07;

input [7:0]  lft_op_01;
input [7:0]  lft_op_06;
input [7:0]  lft_op_04;
input [7:0]  lft_op_03;
input [7:0]  lft_op_05;
input [7:0]  lft_op_07;
input [7:0]  lft_op_02;
input [7:0]  lft_op_08;
input [7:0]  tnl_op_08;
input [2:3]  last_rsr;
input [7:0]  bnl_op_13_09;
input [12:0]  padin;
input [7:0]  glb_netwk_col;
supply1 vdd_;
supply0 gnd_;
//wire vddp_ = test.cds_globalsInst.vddp_;
supply0 GND_;
supply1 VDD_;

// Buses in the design

wire  [0:15]  net544;

wire  [0:15]  net400;

wire  [0:1]  net507;

wire  [0:7]  net584;

wire  [7:0]  glb_netwk_t;

wire  [11:36]  cf_rd;

wire  [0:1]  net345;

wire  [0:15]  net472;

wire  [7:0]  colbuf_cntl_t;

wire  [0:15]  net652;

wire  [0:1]  net350;

wire  [0:7]  net548;

wire  [7:0]  colbuf_cntl_b;

wire  [0:1]  net352;

wire  [0:15]  net580;

wire  [0:7]  net346;

wire  [0:1]  net344;

wire  [0:7]  net349;

wire  [0:15]  net616;

wire  [0:7]  net476;

wire  [0:1]  net360;

wire  [7:0]  glb_netwk_b;

wire  [0:1]  net363;

wire  [11:36]  cf_rp;

wire  [0:15]  net508;

wire  [0:1]  net361;

wire  [0:7]  net440;



mux2_hvt I_mux_jtagcf_2_ ( .in1(cf_rp[36]), .in0(gnd_),
     .out(cf_rd[36]), .sel(mux_jtag_sel_b));
mux2_hvt I_mux_jtagcf_1_ ( .in1(cf_rp[12]), .in0(gnd_),
     .out(cf_rd[12]), .sel(mux_jtag_sel_b));
mux2_hvt I_mux_jtagcf_0_ ( .in1(cf_rp[11]), .in0(gnd_),
     .out(cf_rd[11]), .sel(mux_jtag_sel_b));
bram_bufferx4 I_muxedjtagbuf_2_ ( .in(cf_rd[36]), .out(cf_r[36]));
bram_bufferx4 I_muxedjtagbuf_1_ ( .in(cf_rd[12]), .out(cf_r[12]));
bram_bufferx4 I_muxedjtagbuf_0_ ( .in(cf_rd[11]), .out(cf_r[11]));
clk_col_buf_x8_ice8p I_clk_colbuf12kx8_bot (
     .colbuf_cntl(colbuf_cntl_b[7:0]), .col_clk(glb_netwk_b[7:0]),
     .clk_in(glb_netwk_col[7:0]));
clk_col_buf_x8_ice8p I_clk_colbuf12kx8_top (
     .colbuf_cntl(colbuf_cntl_t[7:0]), .col_clk(glb_netwk_t[7:0]),
     .clk_in(glb_netwk_col[7:0]));
tiehi4x I482 ( .tiehi(tievdd));
tielo4x I483 ( .tielo(tiegnd));
tckbufx32_ice8p I_tmsbuf ( .in(tms), .out(tms_pad));
tckbufx32_ice8p I_tckbuf ( .in(tck), .out(tck_pad));
tckbufx32_ice8p I_tdibuf ( .in(tdi), .out(tdi_pad));
tckbufx32_ice8p I_tck_halfbankcenter ( .in(tclk), .out(tclk_o));
io_col4_rgt_ice8p_v2 I_io_00_02 ( .slf_op(slf_op_02[3:0]),
     // .cdone_in(trstb_pad), .spioeb({sdo_enable, tievdd}),
     .cdone_in(mux_jtag_sel_b), .spioeb({sdo_enable, tievdd}),
     .tnl_op(lft_op_03[7:0]), .spi_ss_in_b({nc_ss, tck}), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_02[23:0]),
     .spiout({totdopad, tiegnd}), .sp4_v_b(net580[0:15]), .prog(prog),
     .cf({cf_r[47:37], cf_rp[36], cf_r[35:24]}),
     .vdd_cntl(vdd_cntl[31:16]), .lft_op(lft_op_02[7:0]),
     .padin(padin[3:2]), .mode(mode), .wl(wl[31:16]), .pado(pado[3:2]),
     .sp4_v_t(net400[0:15]), .padeb(padeb[3:2]),
     .reset(reset_b[31:16]), .bl(bl[17:0]), .cbit_colcntl(net346[0:7]),
     .sdo(net405), .fabric_out(fabric_out_02),
     .glb_netwk(glb_netwk_b[7:0]), .pgate(pgate[31:16]), .sdi(net585),
     .sp4_h_l(SP4_h_l_02[47:0]), .bnl_op(lft_op_01[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_08 ( .slf_op(slf_op_08[3:0]),
     .cdone_in(tievdd), .spioeb({tievdd, tievdd}),
     .tnl_op(tnl_op_08[7:0]), .spi_ss_in_b(net361[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_08[23:0]),
     .spiout({tiegnd, tiegnd}), .sp4_v_b(net472[0:15]), .prog(prog),
     .cf(cf_r[191:168]), .vdd_cntl(vdd_cntl[127:112]),
     .lft_op(lft_op_08[7:0]), .padin(padin[12:11]), .mode(mode),
     .wl(wl[127:112]), .pado(pado[12:11]), .sp4_v_t(sp4_v_t_08[15:0]),
     .padeb(padeb[12:11]), .reset(reset_b[127:112]), .bl(bl[17:0]),
     .cbit_colcntl(net440[0:7]), .sdo(sdo), .fabric_out(fabric_out_08),
     .glb_netwk(glb_netwk_t[7:0]), .pgate(pgate[127:112]),
     .sdi(net477), .sp4_h_l(SP4_h_l_08[47:0]),
     .bnl_op(lft_op_07[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_07 ( .slf_op(slf_op_07[3:0]),
     .cdone_in(jtag_rowtest_mode_rowu3_b), .spioeb({tievdd, tiegnd}),
     .tnl_op(lft_op_08[7:0]), .spi_ss_in_b(net352[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_07[23:0]),
     .spiout({tiegnd, last_rsr[3]}), .sp4_v_b(net544[0:15]),
     .prog(prog), .cf(cf_r[167:144]), .vdd_cntl(vdd_cntl[111:96]),
     .lft_op(lft_op_07[7:0]), .padin(padin[10:9]), .mode(mode),
     .wl(wl[111:96]), .pado(pado[10:9]), .sp4_v_t(net472[0:15]),
     .padeb(padeb[10:9]), .reset(reset_b[111:96]), .bl(bl[17:0]),
     .cbit_colcntl(net476[0:7]), .sdo(net477), .fabric_out(net478),
     .glb_netwk(glb_netwk_t[7:0]), .pgate(pgate[111:96]), .sdi(net549),
     .sp4_h_l(SP4_h_l_07[47:0]), .bnl_op(lft_op_06[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_05 ( .slf_op(slf_op_05[3:0]),
     .cdone_in(tievdd), .spioeb({tievdd, tievdd}),
     .tnl_op(lft_op_06[7:0]), .spi_ss_in_b(net345[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_05[23:0]),
     .spiout({tiegnd, tiegnd}), .sp4_v_b(net652[0:15]), .prog(prog),
     .cf(cf_r[119:96]), .vdd_cntl(vdd_cntl[79:64]),
     .lft_op(lft_op_05[7:0]), .padin(net507[0:1]), .mode(mode),
     .wl(wl[79:64]), .pado(net507[0:1]), .sp4_v_t(net508[0:15]),
     .padeb(net363[0:1]), .reset(reset_b[79:64]), .bl(bl[17:0]),
     .cbit_colcntl(colbuf_cntl_t[7:0]), .sdo(net513),
     .fabric_out(net514), .glb_netwk(glb_netwk_t[7:0]),
     .pgate(pgate[79:64]), .sdi(net657), .sp4_h_l(SP4_h_l_05[47:0]),
     .bnl_op(lft_op_04[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_06 ( .slf_op(slf_op_06[3:0]),
     .cdone_in(jtag_rowtest_mode_rowu2_b), .spioeb({tievdd, tiegnd}),
     .tnl_op(lft_op_07[7:0]), .spi_ss_in_b(net360[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_06[23:0]),
     .spiout({tiegnd, last_rsr[2]}), .sp4_v_b(net508[0:15]),
     .prog(prog), .cf(cf_r[143:120]), .vdd_cntl(vdd_cntl[95:80]),
     .lft_op(lft_op_06[7:0]), .padin(padin[8:7]), .mode(mode),
     .wl(wl[95:80]), .pado(pado[8:7]), .sp4_v_t(net544[0:15]),
     .padeb(padeb[8:7]), .reset(reset_b[95:80]), .bl(bl[17:0]),
     .cbit_colcntl(net548[0:7]), .sdo(net549), .fabric_out(net550),
     .glb_netwk(glb_netwk_t[7:0]), .pgate(pgate[95:80]), .sdi(net513),
     .sp4_h_l(SP4_h_l_06[47:0]), .bnl_op(lft_op_05[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_01 ( .slf_op(slf_op_01[3:0]),
     .cdone_in(mux_jtag_sel_b), .spioeb({tievdd, tievdd}),
     .tnl_op(lft_op_02[7:0]), .spi_ss_in_b({tms, tdi}), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_01[23:0]),
     .spiout({tiegnd, tiegnd}), .sp4_v_b(sp4_v_b_13_09[15:0]),
     .prog(prog), .cf({cf_r[23:13], cf_rp[12], cf_rp[11], cf_r[10:0]}),
     .vdd_cntl(vdd_cntl[15:0]), .lft_op(lft_op_01[7:0]),
     .padin(padin[1:0]), .mode(mode), .wl(wl[15:0]), .pado(pado[1:0]),
     .sp4_v_t(net580[0:15]), .padeb(padeb[1:0]), .reset(reset_b[15:0]),
     .bl(bl[17:0]), .cbit_colcntl(net584[0:7]), .sdo(net585),
     .fabric_out(fabric_out_01), .glb_netwk(glb_netwk_b[7:0]),
     .pgate(pgate[15:0]), .sdi(sdi), .sp4_h_l(SP4_h_l_01[47:0]),
     .bnl_op(bnl_op_13_09[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_03 ( .slf_op(slf_op_03[3:0]),
     .cdone_in(tievdd), .spioeb({tievdd, tievdd}),
     .tnl_op(lft_op_04[7:0]), .spi_ss_in_b(net350[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_03[23:0]),
     .spiout({tiegnd, tiegnd}), .sp4_v_b(net400[0:15]), .prog(prog),
     .cf(cf_r[71:48]), .vdd_cntl(vdd_cntl[47:32]),
     .lft_op(lft_op_03[7:0]), .padin({padin[4], padin_nc}),
     .mode(mode), .wl(wl[47:32]), .pado({pado[4], pado_nc}),
     .sp4_v_t(net616[0:15]), .padeb({padeb[4], padeb_nc}),
     .reset(reset_b[47:32]), .bl(bl[17:0]), .cbit_colcntl(net349[0:7]),
     .sdo(net621), .fabric_out(net622), .glb_netwk(glb_netwk_b[7:0]),
     .pgate(pgate[47:32]), .sdi(net405), .sp4_h_l(SP4_h_l_03[47:0]),
     .bnl_op(lft_op_02[7:0]));
io_col4_rgt_ice8p_v2 I_io_00_04 ( .slf_op(slf_op_04[3:0]),
     .cdone_in(tievdd), .spioeb({tievdd, tievdd}),
     .tnl_op(lft_op_05[7:0]), .spi_ss_in_b(net344[0:1]), .hold(hold),
     .update(update), .shift(shift), .hiz_b(hiz_b), .bs_en(bs_en),
     .r(r), .tclk(tclk_o), .ceb(ceb), .sp12_h_l(SP12_h_l_04[23:0]),
     .spiout({tiegnd, tiegnd}), .sp4_v_b(net616[0:15]), .prog(prog),
     .cf(cf_r[95:72]), .vdd_cntl(vdd_cntl[63:48]),
     .lft_op(lft_op_04[7:0]), .padin(padin[6:5]), .mode(mode),
     .wl(wl[63:48]), .pado(pado[6:5]), .sp4_v_t(net652[0:15]),
     .padeb(padeb[6:5]), .reset(reset_b[63:48]), .bl(bl[17:0]),
     .cbit_colcntl(colbuf_cntl_b[7:0]), .sdo(net657),
     .fabric_out(net658), .glb_netwk(glb_netwk_b[7:0]),
     .pgate(pgate[63:48]), .sdi(net621), .sp4_h_l(SP4_h_l_04[47:0]),
     .bnl_op(lft_op_03[7:0]));

endmodule
