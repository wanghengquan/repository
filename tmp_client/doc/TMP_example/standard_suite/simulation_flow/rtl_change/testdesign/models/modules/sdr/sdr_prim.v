// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.5.0.91
// Netlist written on Mon May 11 16:17:58 2015
//
// Verilog Description of module sdr
//

module sdr (clkin, reset, sclk, datain, q) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(8[8:11])
    input clkin /* synthesis black_box_pad_pin=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(9[16:21])
    input reset;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(10[16:21])
    output sclk;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(12[17:21])
    input [7:0]datain;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(11[22:28])
    output [7:0]q;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(13[23:24])
    
    wire sclk /* synthesis is_clock=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(12[17:21])
    
    wire scuba_vhi, Inst1_IB7, Inst1_IB6, Inst1_IB5, Inst1_IB4, Inst1_IB3, 
        Inst1_IB2, Inst1_IB1, Inst1_IB0, GND_net;
    
    IFS1P3DX Inst2_IFS1P3DX6 (.D(Inst1_IB6), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[6])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(40[14] 41[30])
    defparam Inst2_IFS1P3DX6.GSR = "ENABLED";
    IFS1P3DX Inst2_IFS1P3DX5 (.D(Inst1_IB5), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[5])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(43[14] 44[30])
    defparam Inst2_IFS1P3DX5.GSR = "ENABLED";
    IFS1P3DX Inst2_IFS1P3DX4 (.D(Inst1_IB4), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[4])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(46[14] 47[30])
    defparam Inst2_IFS1P3DX4.GSR = "ENABLED";
    IFS1P3DX Inst2_IFS1P3DX3 (.D(Inst1_IB3), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[3])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(49[14] 50[30])
    defparam Inst2_IFS1P3DX3.GSR = "ENABLED";
    IFS1P3DX Inst2_IFS1P3DX2 (.D(Inst1_IB2), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[2])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(52[14] 53[30])
    defparam Inst2_IFS1P3DX2.GSR = "ENABLED";
    IFS1P3DX Inst2_IFS1P3DX1 (.D(Inst1_IB1), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[1])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(55[14] 56[30])
    defparam Inst2_IFS1P3DX1.GSR = "ENABLED";
    VHI scuba_vhi_inst (.Z(scuba_vhi));
    IFS1P3DX Inst2_IFS1P3DX0 (.D(Inst1_IB0), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[0])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(60[14] 61[30])
    defparam Inst2_IFS1P3DX0.GSR = "ENABLED";
    IB Inst1_IB7_c (.I(datain[7]), .O(Inst1_IB7)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(63[8:51])
    GSR GSR_INST (.GSR(scuba_vhi));
    IB Inst3_IB (.I(clkin), .O(sclk)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(34[8:43])
    IFS1P3DX Inst2_IFS1P3DX7 (.D(Inst1_IB7), .SP(scuba_vhi), .SCLK(sclk), 
            .CD(reset), .Q(q[7])) /* synthesis syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(37[14] 38[30])
    defparam Inst2_IFS1P3DX7.GSR = "ENABLED";
    IB Inst1_IB6_c (.I(datain[6]), .O(Inst1_IB6)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(66[8:51])
    IB Inst1_IB5_c (.I(datain[5]), .O(Inst1_IB5)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(69[8:51])
    IB Inst1_IB4_c (.I(datain[4]), .O(Inst1_IB4)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(72[8:51])
    IB Inst1_IB3_c (.I(datain[3]), .O(Inst1_IB3)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(75[8:51])
    IB Inst1_IB2_c (.I(datain[2]), .O(Inst1_IB2)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(78[8:51])
    IB Inst1_IB1_c (.I(datain[1]), .O(Inst1_IB1)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(81[8:51])
    IB Inst1_IB0_c (.I(datain[0]), .O(Inst1_IB0)) /* synthesis IO_TYPE="LVCMOS25", syn_instantiated=1 */ ;   // //d27550/test_dir/be_validation/trts/01_projects/04_snow/04_sysio_logic/01_sdr/01_rx_b16_f200_normal/models/modules/sdr/sdr.v(84[8:51])
    PUR PUR_INST (.PUR(scuba_vhi));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i43 (.Z(GND_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

