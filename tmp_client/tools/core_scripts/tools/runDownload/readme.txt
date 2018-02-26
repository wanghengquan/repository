MAIL RECORD:
////////////////////////////////////////////////////////////////////////
More options:
--from-riviera    : simulation tool is Riviera.
--lst-type: choice of ("sim_rtl", "sim_map_vlg", "sim_par_vlg", "sim_map_vhd", "sim_par_vhd")



From: Shawn Yan
To: Jeffrey Ye
Subject: RE: scripts support for co-verification download testing

Hi Jeffrey.
Here is the plan for the scripts:
Python run_download.py --top-dir=xx --design=yy --jdv-exe=zz.exe --package=*.package --target-dir=aa --verbose   --step=30 --lineno=100

Top_dir: your top result path
Design: design name
Jdv-exe: makejdv.exe
Package: package file

--target-dir: a folder named $target_dir/$design will created and rbt/jed/bit, jdv file will be copied here. If verbose is true, pad file and lst file will be copied, too.
--step: an integer, select which line in lst file will be dumped to the jdv file.
--lineno: an integer, specify the maximum lines will be dumped to the jdv file


Any comments?


Shawn Yan

From: Shawn Yan
To: Jeffrey Ye
Subject: RE: scripts support for co-verification download testing

output:

rbt/jed/bit + jdv


jdv = sim + package
rbt/jed = flow gen!

sim = lst + pad




From: Jeffrey Ye
To: Shawn Yan
Cc: Jason Wang
Subject: scripts support for co-verification download testing

Hi Shawn,

Following is my request for scripts. You can find the original flow in folder "down".


1.  After running simulation, the scripts(trunk) will generate file ./sim_rtl/*.lst, I need the new scripts to convert it to a *.sim file.
2.  The flow is almost like simrel flow, but the format is different from "fc.avc".
3.  Pick the IO' names from lst file, find the corresponding site name and direction from PAD file.
4.  If there are "X", "?" in lst file, please change it to "0".
5.  In the generated *.sim file, the output signals: change "0" to "L", change "1" to "H".
6.  The format of sim file should follow the original scripts "gensim.pl"(refer to file "3_gen_sim.bat", using pin and vec file to generate sim file).
7.  In the generated sim file, I need to an option to control the line of data, i.e., if I set the line is 100, it just generate 100 line of data.
8.  After generate the sim file, please use "makejdv.exe" and "*.package" file to generate jdv file.(refer to file "5_gen_jdv.bat")
9.  Please copy all the generated files, JED and Bit(rbt) files to a new dir.




Thanks
Jeffrey Ye

/////////////////////////////////////////////////////////////////////



#### In .pad file
Pinout by Port Name:
+-----------+----------+--------------+-------+-----------+-----------------------------------+
| Port Name | Pin/Bank | Buffer Type  | Site  | BC Enable | Properties                        |
+-----------+----------+--------------+-------+-----------+-----------------------------------+
| Aclr      | N16/8    | LVCMOS25_IN  | PB4B  |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
| Clk_En    | G3/3     | LVCMOS25_IN  | PR29B |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
| Clock     | B10/0    | LVCMOS25_IN  | PT29A |           | PULL:DOWN CLAMP:ON HYSTERESIS:ON  |
| Q[0]      | F1/3     | LVCMOS25_OUT | PR35C |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[1]      | F2/3     | LVCMOS25_OUT | PR32A |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[2]      | H1/3     | LVCMOS25_OUT | PR35D |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[3]      | J2/3     | LVCMOS25_OUT | PR35A |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[4]      | J3/3     | LVCMOS25_OUT | PR29C |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[5]      | H3/3     | LVCMOS25_OUT | PR29A |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[6]      | H2/3     | LVCMOS25_OUT | PR29D |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
| Q[7]      | G1/3     | LVCMOS25_OUT | PR32B |           | DRIVE:8mA CLAMP:ON SLEW:SLOW      |
+-----------+----------+--------------+-------+-----------+-----------------------------------+


#### In lst file
       ps /sim_top/uut/Clock /sim_top/uut/Clk_En /sim_top/uut/Aclr /sim_top/uut/Q
        0                  X                   X                 X       XXXXXXXX
     5000                  X                   X                 X       XXXXXXXX
    10000                  X                   X                 X       XXXXXXXX
    15000                  0                   0                 1       00000000
    20000                  0                   0                 1       00000000
    25000                  0                   0                 1       00000000
    30000                  0                   0                 1       00000000



