// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WHAT'S RUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   Reusable Unified Testbench (RUT) is designed for team-based validation    //
// which can help to both raise our test level and reduce test cycle.          //
//   RUT deliver a common library which contain many packed tasks for different//
// modules.                                                                    //
//   RUT will use limited SystemVerilog features which will help to develop the//
// library greatly.                                                            //
//                                                                             //
// NOTE:                                                                       //
// Copyright by Software Validation team from Lattice Semiconductor Corporation//
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE DESCRIPTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// ----------------------------------------------------------------------------//
//   this file contain all the tasks/functions that can be used to verify      //
// efb/power/pcs module                                                        //
// ----------------------------------------------------------------------------//
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> VERSION CONTROL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
// File Name: efb_i2c.v                                                        //
// Owner: Weixing Tan                                                          //
// Version History:                                                            //
//   Version   Data             Modifier            Comments                   //
//   V0.1      12.30.2014     Weixing Tan      initial Version                 //
//   V0.2      03.16.2015     Weixing Tan      unify format                    //
//                                                                             //                              //
// ----------------------------------------------------------------------------//





`include "./RUT_lib/global_param_sets.v"
`include "./RUT_lib/efb_power_pcs/module_param_sets_05.v"
`include "./local_param_sets.v"

module task_sets_efb(wb_cyc_i,wb_stb_i,wb_clk_i,wb_we_i,wb_adr_i,wb_dat_i,wb_ack_o,wb_dat_o,i2c1_scl);
    input wire wb_clk_i;
    output reg wb_cyc_i;
    output reg wb_stb_i;
    output reg wb_we_i;
    output reg [7:0] wb_adr_i;
    output reg [7:0] wb_dat_i;
    input wire [7:0] wb_dat_o;
    input wire wb_ack_o;
    input wire i2c1_scl;

task automatic I2C_initial();
begin : I2C_initial1

    reg TRRDY = 0;
    //reg [7:0] WB_RETURN_DATA = 8'h00;
    reg [7:0] wb_return_data = 8'h00;

    wb_write({`I2C_SLAVE_ADDRESS_0501,`I2C_WRITE_0501},`I2C_1_TXDR_0501);//send slave address + W

    wb_write(8'h90,`I2C_1_CMDR_0501);//1001_0000 generate start + write t slave

    while(TRRDY == 0)
    begin
        wb_read(8'hzz,`I2C_1_SR_0501,wb_return_data);
        //$display("%h\n",wb_return_data);
        TRRDY = wb_return_data[2];
    end
end
endtask

task automatic I2C_secondary_initial();
begin : I2C_secondary_initial1
	reg BUSY = 1;
    //reg TRRDY = 0;

    reg [7:0] wb_return_data = 8'h00;
    wb_write(8'h04,`I2C_2_CMDR_0501);
    wb_write(8'h00,`I2C_2_IRQ_EN_0501);

    while(BUSY == 1)
    begin
        wb_read(8'hzz,`I2C_2_SR_0501,wb_return_data);
        $display("%h\n",wb_return_data);
        BUSY = wb_return_data[6];
        $display("%d\n",BUSY);
    end

//bohong    wb_read(8'hzz, `I2C_2_RXDR_0501 ,wb_return_data);//discard
//bohong    wb_read(8'hzz, `I2C_2_RXDR_0501 ,wb_return_data);//discard
//bohong    wb_write(8'h00,`I2C_2_CMDR_0501);
    wb_write(8'h04,`I2C_2_IRQ_EN_0501);
end
endtask


task automatic I2C_secondary_read(output reg[7:0] out_data);
begin : I2C_secondary_read1
    reg TRRDY = 0;
    reg [7:0] wb_return_data = 8'h00;

    while(TRRDY == 0)
    begin
        wb_read(8'hzz,`I2C_2_SR_0501,wb_return_data);
        $display("%h\n",wb_return_data);
        TRRDY = wb_return_data[2];
        $display("%d\n",TRRDY);
    end

    wb_read(8'hzz, `I2C_2_RXDR_0501 ,out_data);
    wb_write(8'h04,`I2C_2_IRQ_EN_0501);
end
endtask


task automatic I2C_WRITE_data(input reg[7:0] input_data, output reg out_data);
begin : I2C_WRITE_data1
//task automatic I2C_WRITE_data(input reg[7:0] input_data);

//    reg TRRDY = 0;
	reg out_data = 0;
    reg [7:0] WB_RETURN_DATA = 8'h00;
    wb_write(input_data,`I2C_1_TXDR_0501);//push data to MASTER TX
    wb_write(8'h10,`I2C_1_CMDR_0501);//0001_0000 write t slave

    while(out_data == 0)
    begin
        wb_read(8'hzz,`I2C_1_SR_0501,WB_RETURN_DATA);
        //$display("%h",WB_RETURN_DATA);
        out_data = WB_RETURN_DATA[2];
    end
end
endtask



//when doing nothing or end with write operation, using this
task automatic I2C_WRITE_ending();
begin : I2C_WRITE_ending1
    wb_write(8'h40,`I2C_1_CMDR_0501);//0100_0000 stop
end
endtask



task automatic I2C_READ_begin();
begin : I2C_READ_begin1
    reg SRW = 0;

    reg [7:0] wb_return_data = 8'h00;

    wb_write({`I2C_SLAVE_ADDRESS_0501,`I2C_READ_0501},`I2C_1_TXDR_0501);//send slave address + W

    wb_write(8'h90,`I2C_1_CMDR_0501);//1001_0000 generate start + write t slave

    while(SRW == 0)  //slave receive
    begin
        wb_read(8'hzz,`I2C_1_SR_0501,wb_return_data);
        //$display("%h\n",wb_return_data);
        SRW = wb_return_data[4];
    end

    wb_write(8'h20,`I2C_1_CMDR_0501);//read
end
endtask


task automatic I2C_READ(output reg[7:0] output_data);
begin : I2C_READ_05011
    reg TRRDY = 0;

    reg [7:0] wb_return_data = 8'h00;

    //wb_write({`I2C_SLAVE_ADDRESS_0501,`I2C_READ_0501},`I2C_1_TXDR_0501);//send slave address + W

    //wb_write(8'h90,`I2C_1_CMDR_0501);//1001_0000 generate start + write t slave

    while(TRRDY == 0)  //slave receive
    begin
        wb_read(8'hzz,`I2C_1_SR_0501,wb_return_data);
        //$display("%h\n",wb_return_data);
        TRRDY = wb_return_data[2];
    end
    //$display("%h",TRRDY);
    wb_read(8'hzz, `I2C_1_RXDR_0501 ,output_data);
end
endtask


task automatic I2C_READ_last_data(output reg[7:0] output_data);
begin : I2C_READ_last_data1
    reg TRRDY = 0;
    reg [7:0] wb_return_data = 8'h00;
    repeat(8) @(posedge i2c1_scl);  //should be between 2~7;

    wb_write(8'h68,`I2C_1_CMDR_0501);//1001_0000 generate start + write t slave

    while(TRRDY == 0)  //slave receive
    begin
        wb_read(8'hzz,`I2C_1_SR_0501,wb_return_data);
        //$display("%h\n",wb_return_data);
        TRRDY = wb_return_data[2];
    end
    wb_read(8'hzz, `I2C_1_RXDR_0501 ,output_data);
end
endtask

task wb_write(input reg[7:0] datai, input reg[7:0] ufm_address);
begin : wb_write1
    @(posedge wb_clk_i); //edge 0
    begin
        {wb_cyc_i, wb_stb_i} <= 2'b11;
        wb_we_i<= 1'b1;  //1 means write
        wb_adr_i <= ufm_address;
        wb_dat_i <= datai;
    end

    @(posedge wb_clk_i); //edge 1
    wait(wb_ack_o == 1'b1);

    @(posedge wb_clk_i); //edge 2
    {wb_cyc_i, wb_stb_i} <= 2'b00; //end of this cycle
    wait(wb_ack_o == 1'b0);
end
endtask


task wb_read(input reg[7:0] datai, input reg[7:0] ufm_address,output reg[7:0] vaild_data);
begin : wb_read1
   @(posedge wb_clk_i);  //edge 0
    begin
        {wb_cyc_i, wb_stb_i} <= 2'b11;         // 0 means read
        wb_we_i <= 1'b0;				  //we_i = 0 means read, 1 means write
        wb_adr_i <= ufm_address;
        wb_dat_i <= datai;
    end

    @(posedge wb_clk_i); //edge 1
    wait(wb_ack_o == 1'b1);
    //vaild_data <= wb_dat_o;

    @(posedge wb_clk_i); //edge 2
    vaild_data <= wb_dat_o;
    {wb_cyc_i, wb_stb_i} <= 2'b00; //end of this cycle
    wait(wb_ack_o == 1'b0);
end
endtask


endmodule