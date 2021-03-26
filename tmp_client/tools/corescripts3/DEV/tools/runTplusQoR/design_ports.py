design_port_dict = dict()
design_port_dict["01_Arith_DCT"] = ['clk']
design_port_dict["01_Arith_Gaussian"] = ['clk']
design_port_dict["01_Arith_ecpu"] = ['CLK']
design_port_dict["01_Arith_radix_fft"] = ['clk']
design_port_dict["05_Crypto_AES"] = ['CLK_I']
design_port_dict["05_Crypto_Grain"] = ['CLK_I']
design_port_dict["05_Crypto_SHA2"] = ['clk']
design_port_dict["05_Crypto_Simon"] = ['clk']
design_port_dict["06_DSP_Adaptive_LMS"] = ['clock']
design_port_dict["06_DSP_IIP_low_pass"] = ['CLK']
design_port_dict["06_DSP_IIR_bessel6"] = ['clock']
design_port_dict["06_DSP_IIR_bessel8"] = ['clock']
design_port_dict["06_DSP_IIR_butterworth"] = ['clock']
design_port_dict["07_ECC_CF_vhd"] = ['clock_c']
design_port_dict["07_ECC_CF_vlg"] = ['clock_c']
design_port_dict["07_ECC_Constellation_Encoder"] = ['clk']
design_port_dict["10_Other_fabric_analysis_pwm_driver"] = ['clk']
design_port_dict["10_Other_fm_receiver"] = ['clk']
design_port_dict["10_Other_glue"] = ['iClkFast', 'iClkSlow']
design_port_dict["10_Other_ima_adpcm_encoder"] = ['wb_clk_i']
design_port_dict["10_Other_keyboardcontroller"] = ['clk_in']
design_port_dict["10_Other_lcd_controller16x2"] = ['clk']
design_port_dict["10_Other_portkey"] = ['clk']
design_port_dict["10_Other_timer8254"] = ['PCLK', 'clk0', 'clk1', 'clk2']
design_port_dict["11_Processor_68hc05"] = ['clk']
design_port_dict["11_Processor_8080_core"] = ['clock']
design_port_dict["11_Processor_AVR_Core_for_CPL"] = ['clk']
design_port_dict["11_Processor_Brainfuck_CPU"] = ['clk']
design_port_dict["11_Processor_CPU_MCS"] = ['sysclk']
design_port_dict["11_Processor_Cpu_Generator"] = ['clk_in']
design_port_dict["11_Processor_IC682_vhd"] = ['CA1', 'CB1', 'e']
design_port_dict["11_Processor_McAdam"] = ['clock']
design_port_dict["11_Processor_NextZ80"] = ['CLK']
design_port_dict["11_Processor_Open8_uRIS"] = ['Clock']
design_port_dict["11_Processor_SAYEH"] = ['clk']
design_port_dict["11_Processor_T80_cp"] = ['CLK_n']
design_port_dict["11_Processor_cpu6502_tc"] = ['clk_clk_i']
design_port_dict["11_Processor_v586"] = ['CLK']
design_port_dict["11_powertop_sb"] = ['clk']
design_port_dict["13_System_ctl_pic"] = ['CLK_I']
design_port_dict["144_SPI_core"] = ['clk_i']
design_port_dict["145_SPI_Flash_controller"] = ['clk_in']
design_port_dict["147_Unsigned_serial_divider"] = ['clk_i']
design_port_dict["14_Video_ctl_lcd1"] = ['clk']
design_port_dict["173_UART16750"] = ['CLK']
design_port_dict["26_dirac_decoder"] = ['CLOCK']
design_port_dict["88_Manchester_Decoder_for_Wireless"] = ['clk_i']
design_port_dict["D1126"] = ['i_osc_clk']
design_port_dict["I2CButtons"] = ['i_clk', 'i_scl', 'io_sda']
design_port_dict["I2CPWM"] = ['i_SCL', 'i_clk', 'io_SDA']
design_port_dict["I2C_Slave"] = ['i_clk', 'io_scl', 'io_sda']
design_port_dict["Innolux_LCD"] = ['sys_clk']
design_port_dict["Keypad_Scanner"] = ['i_clk']
design_port_dict["RC4_PRNG"] = ['clk_sys']
design_port_dict["Touch_Screen_Controller"] = ['i_clk']
design_port_dict["UART"] = ['clk_sys']

import os
import time


def get_ldc_fdc_lines(ports):
    lines = list()
    lines.append("## Set 1MHz for design @ %s" % time.ctime())
    ports = [item.strip() for item in ports]
    for p in ports:
        lines.append("create_clock -period 1000 -name %s [get_ports {%s}]" % (p, p))
    if len(ports) > 1:
        _group = ["-group [get_clocks %s]" % item for item in ports]
        lines.append("set_clock_groups %s -logically_exclusive" % " ".join(_group))
    return lines


def update_folder(top_dir, dc_fext):
    for design in os.listdir(top_dir):
        ports = design_port_dict.get(design)
        if not ports:
            continue
        new_lines = get_ldc_fdc_lines(ports)
        new_lines = "\n".join(new_lines)
        design_path = os.path.join(top_dir, design)
        for a, b, c in os.walk(design_path):
            for foo in c:
                foo_lower = foo.lower()
                if foo_lower.endswith(dc_fext):
                    b = open(os.path.join(a, foo), "w")
                    print(new_lines, file=b)
                    b.close()


update_folder(r"D:\chuang-qian-mingyue-guang\Radiant3506_1MHz\ng_source_ldc", ".ldc")
update_folder(r"D:\chuang-qian-mingyue-guang\Radiant3506_1MHz\ng_source_fdc", ".fdc")




