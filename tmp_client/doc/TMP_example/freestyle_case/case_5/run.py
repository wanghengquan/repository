import os
import sys
import time

#print sys.argv[1]
print time.ctime()
os.system("par -w -n 1 -t 1 -s 1 -cores 1 -exp parPathBased=OFF top_impl1_map.udb top_impl1.udb")
os.system("timing -sethld -v 10 -u 10 -endpoints 10 -nperend 1 -sp High-Performance_1.2V -hsp m -pwrprd -html -rpt top_impl1.twr top_impl1.udb")