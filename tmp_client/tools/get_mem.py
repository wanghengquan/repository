import os
import sys
import psutil

top_dir = os.getcwd()

ON_WIN = sys.platform.startswith("win")
if not ON_WIN:
    sys.exit('0')
mem_tuple= psutil.virtual_memory()
mem_usage = mem_tuple[2]
print (int(mem_usage))