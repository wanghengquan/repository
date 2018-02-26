rem svn export http://d25315/E60/trunk E60_xo2 --username=public --password=lattice 
rem cd E60_xo2
python for_svn.py  --suite=S24_sc   --top-dir=D:\new_all\trunk   --run-synpwrap  --job-dir=D:\new_all\run\run2  --x64 --diamond=C:\lscc\diamond\2.2_x64
cmd