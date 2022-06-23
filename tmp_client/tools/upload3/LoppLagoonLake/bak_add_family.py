import os
import re
from capuchin import xTools

p = re.compile('device="([^"]+)"')


def get_device(rdf_file):
    with open(rdf_file) as ob:
        for line in ob:
            m = p.search(line)
            if m:
                raw_device = m.group(1)
                raw_device_list = re.split("-", raw_device)
                return raw_device_list[0]


def main(top_dir):
    total_devices = list()
    for foo in os.listdir(t):
        abs_foo = os.path.join(top_dir, foo)
        info_file = os.path.join(abs_foo, "run_info.ini")
        if os.path.isfile(info_file):
            print(info_file, xTools.get_file_format(info_file))
            rdf_files = list()
            for a, b, c in os.walk(abs_foo):
                if ".svn" in b:
                    b.remove(".svn")
                for item in c:
                    if item.endswith(".rdf"):
                        rdf_file = os.path.join(a, item)
                        rdf_files.append(rdf_file)                     
            devices = [get_device(item) for item in rdf_files]
            if not devices:
                continue
            total_devices.extend(devices)
            info_lines = open(info_file).readlines()
            with open(info_file, "w") as ob:
                for line in info_lines:
                    print(line, file=ob, end="")
                    if line.startswith("design_name"):
                        print("family={0}".format(*devices), file=ob, end=os.linesep)
            # print(info_file, len(rdf_files), rdf_files, )

    x = list(set(total_devices))
    x.sort()
    print(x)

       
if __name__ == "__main__":
    t = r"D:\DayDayClean\all_cr_cases"
    main(t)
