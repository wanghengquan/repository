import os
import sys
import platform


def machine():
    """Return type of machine."""
    if os.name == 'nt' and sys.version_info[:2] < (2,7):
        return os.environ.get("PROCESSOR_ARCHITEW6432",
               os.environ.get('PROCESSOR_ARCHITECTURE', ''))
    else:
        return platform.machine()
        
def os_bits(machine=machine()):
    if "64" in machine:
        return "64b"
    else:
        return "32b"

def get_Windows_name():
    import subprocess, re
    o = subprocess.Popen('systeminfo', stdout=subprocess.PIPE).communicate()[0]
    try: o = str(o, "latin-1")  # Python 3+
    except: pass
    os_search = re.search("OS Name:\s*(.*)", o)
    if(os_search):
        return os_search.group(1).strip()
    else:
        return "unknown"
        
if (platform.system() == 'Linux'):
    dist_tuple = platform.dist()
    os_type = dist_tuple[0]
    main_version = dist_tuple[1].split(".")[0]
    os_name = os_type  + main_version
elif (platform.system() == 'Windows'):
    os_info = get_Windows_name()
    if "Vista" in os_info:
        os_name = "vista"
    elif "XP" in os_info:
        os_name = "xp"
    elif "Windows 7" in os_info:
        os_name = "win7"
    elif "Windows 8" in os_info:
        os_name = "win8"
    elif "Windows 10" in os_info:
        os_name = "win10"
    else:
        os_name = "unknown"
else:
	os_name = "unknown"

os_bit = os_bits()

print os_name + "_" + os_bit
	