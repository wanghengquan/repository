cd %~dp0
set FOUNDRY=C:\diamond3.0.0.63\diamond\3.0_x64\ispfpga

C:\diamond3.0.0.63\diamond\3.0_x64\ispfpga\bin\nt64\scuba.exe -w -n ddram_16x11_sap -lang vhdl -synth synplify -bus_exp 7 -bb -arch sa5p00 -dram -type ramdps -raddr_width 4 -rwidth 11 -waddr_width 4 -wwidth 11 -rnum_words 16 -wnum_words 16 -outData UNREGISTERED -e 
C:\diamond3.0.0.63\diamond\3.0_x64\ispfpga\bin\nt64\scuba.exe -w -n scfifo_sap -lang vhdl -synth synplify -bus_exp 7 -bb -arch sa5p00 -type ebfifo -sync_mode -depth 16 -width 8 -no_enable -pe 2 -pf 14 -sync_reset -e 