import re
import os
import json

_BASIC_PATTERNS = dict(family=re.compile(r"^Family:\s+(\S+)"),
                       device=re.compile(r"^Device:\s+(\S+)"),
                       package=re.compile(r"^Package:\s+(\S+)"),
                       performance=re.compile(r"(?:Performance Grade|Performance):\s+(\S+)"))

_STATUS_PATTERNS = dict(package_status=re.compile(r"Package Statu.+?:\s+(\S+)"),
                        hardware_status=re.compile(r"Performance\s+Hardware\s+Data\s+Statu.+?:\s+(\S+)"))

FILE_PATTERNS = dict()
# .mrp
# Family:  LIFCL
# Device:  LIFCL-17
# Package: CSFBGA121
# Performance Grade:  7_High-Performance_1.0V
FILE_PATTERNS["map"] = {**_BASIC_PATTERNS}

# .par
# Package Status:                     Final          Version 23.
# Performance Hardware Data Status:   Final          Version 117.1.
# Family:  LIFCL
# Device:  LIFCL-17
# Package: CSFBGA121
# Performance Grade:   7_High-Performance_1.0V
FILE_PATTERNS["par"] = {**_BASIC_PATTERNS, **_STATUS_PATTERNS}

# .twr
# Family:          LIFCL
# Device:          LIFCL-17
# Package:         CSFBGA121
# Performance:     7_High-Performance_1.0V
# Package Status:                     Final          Version 23
# Performance Hardware Data Status :   Final Version 117.1
FILE_PATTERNS["twr"] = {**_BASIC_PATTERNS, **_STATUS_PATTERNS}

# .bgn
# Bitstream Status: Final           Version 10.0.
FILE_PATTERNS["bitstream"] = dict(hardware_status=re.compile(r"Bitstream\s+Status:\s+(\S+)"))

#.ibs
# [Notes]          Device: LIFCL-17     Final
FILE_PATTERNS["ibis"] = dict(device=re.compile(r"\[Notes\]\s+Device:\s+(\S+)"),
                             hardware_status=re.compile(r"\[Notes\]\s+Device:\s+\S+\s+(\S+)"))

# sso_rpt.htm
# Target Device         : LIFCL-17
# Target Package        : CSFBGA121
# Target Performance    : 7_High-Performance_1.0V
# SSO Data Revision     : Final	Version 1.0
FILE_PATTERNS["sso"] = dict(device=re.compile(r"Target\s+Device\s+:\s+(\S+)"),
                            package=re.compile(r"Target\s+Package\s+:\s+(\S+)"),
                            performance=re.compile(r"Target\s+Performance\s+:\s+(\S+)"),
                            hardware_status=re.compile(r"SSO\s+Data\s+Revision\s+:\s+(\S+)"))

# power_top.html
FILE_PATTERNS["power"] = dict(hello=re.compile(r"Power\s+Model\s+Status"),
                              hardware_status=re.compile(r'<font\s+class="table">(.+?)</font>'))


def scan_a_file(key_name, report_file):
    file_data = dict()
    patterns = FILE_PATTERNS.get(key_name)
    if os.path.isfile(report_file):
        p_hello = patterns.get("hello")
        if p_hello:
            hs_string = "hardware_status"
            p_hs = patterns.get(hs_string)
            with open(report_file) as rob:
                start = 0
                for line in rob:
                    if not start:
                        start = p_hello.search(line)
                    else:
                        m_hs = p_hs.search(line)
                        if m_hs:
                            file_data[hs_string] = m_hs.group(1)
                            break
        else:
            with open(report_file) as rob:
                for line in rob:
                    if len(file_data) == len(patterns):
                        break
                    for k, p in list(patterns.items()):
                        if not file_data.get(k):
                            m = p.search(line)
                            if m:
                                file_data[k] = m.group(1)
    res = dict()
    for k, none_p in list(patterns.items()):
        res["{1}_{0}".format(key_name, k)] = file_data.get(k, "NA")
    return res


def scan_hardware_data(design_path):
    tag_folder = os.path.join(design_path, "_scratch")
    file_itself = os.path.join(tag_folder, "impl1", "8_bit_counter_impl1")
    files = dict(map=file_itself + ".mrp",
                 par=file_itself + ".par",
                 twr=file_itself + ".twr",
                 bitstream=file_itself + ".bgn",
                 ibis=os.path.join(tag_folder, "impl1", "IBIS", "8_bit_counter_impl1.ibs"),
                 sso=os.path.join(tag_folder, "impl1", "sso_rpt.htm"),
                 power=os.path.join(tag_folder, "Untitled_power_top.html")
                 )
    hw_data = dict()
    for k, report_file in list(files.items()):
        file_data = scan_a_file(k, report_file)
        hw_data.update(file_data)
    tmp_json_dict = dict(Report=hw_data)
    print(json.dumps(tmp_json_dict))
    with open(os.path.join(tag_folder, "HardwareStatus.json"), "w") as wob:
        print(json.dumps(hw_data, indent=2), file=wob)


if __name__ == "__main__":
    scan_hardware_data(r"D:\Days30\cherry_package_status\tst_LIFCL_17_7MG121I")
