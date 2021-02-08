import os
import sys
import psutil

top_dir = os.getcwd()

ON_WIN = sys.platform.startswith("win")
if not ON_WIN:
    sys.exit('0')
cpu_usage = psutil.cpu_percent(interval=5)
print (int(cpu_usage))