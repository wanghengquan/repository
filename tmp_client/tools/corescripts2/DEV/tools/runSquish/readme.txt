python copy_suites.py
// copy suites to local folder
// modify the directory names

python gen_lines.py > run_all_squish.lines
// generate the batch lines file
// if found .conf and .map in a folder, it will be treated as a suite path
// all tst_xx will be treated as a case

python run_squish.py
// launch test flow

TIPS:
  How to launch the commands?
    1. change .lines to .bat and click it
    2. python tools\runLines\run_lines.py

//////////////////////////////////////////////////
---- Start running Squish test case ...
Usage: run_diamond.py [options]

Options:
  -h, --help         show this help message and exit
  --top-dir=TOP_DIR  specify top source path
  --design=DESIGN    specify design name
  --diamond=DIAMOND  specify Diamond path
  --aut=AUT          specify Squish AUT name
  --squish=SQUISH    specify Squish path
  --x86              run with x86 build


About AUT:
  1) you can specify the absolute path for the AUT. for example: --aut=C:\lscc\diamond\3.9_x64\bin\nt64\fpgae.exe
  2) you can specify with the AUT name. for example: --aut=fpgae.exe or --aut=fpgae
     The previous 2 samples is ok both on Windows and Linux, the scripts will try to find the right format for the aut file.
  3) default aut are pnmain.exe on Windows and diamond on Linux.
