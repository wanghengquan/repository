"""python scan_lse.py --top-dir=\\d27406\D\sally\NG_Case\results_10b58_100\ng_source --vendor=ng
python scan_lse.py --top-dir=\\d27406\D\sally\NG_Case\To_LSV\iceCube2_2016.08 --vendor=ice
"""

import re
import os
import glob

from xlib.xTools import time2secs

__author__ = 'syan'

def get_file_line_count(a_file):
    count = -1
    try:
        for count, line in enumerate(open(a_file, "rU")):
            pass
    except IOError:
        pass
    count += 1
    return count


def scan_timing_rpt(timing_rpt_file):
    """

    :param timing_rpt_file:
    :return:
    """
    rpt_titles = ["clkName", "targetFmax", "fmax"]
    rpt_data = ["NA"] * len(rpt_titles)
    if not os.path.isfile(timing_rpt_file):
        return rpt_titles, rpt_data

    # Clock: pwm|clk_int_sig  | Frequency: 81.71 MHz  | Target: 200.00 MHz  |
    p_cft = re.compile("""Clock:\s+(\S+)
                     \s+\|\s+
                     Frequency:\s+([\d\.]+)\s+MHz
                     \s+\|\s+
                     Target:\s+([\d\.]+)\s+MHz
                     """, re.X)
    p_start = re.compile("1::Clock Frequency Summary") # show up 2 times
    p_stop = re.compile("End of Clock Frequency Summary")

    show_up_time = 0
    old_fmax = 100000
    for line in open(timing_rpt_file):
        if show_up_time < 2:
            if p_start.search(line):
                show_up_time += 1
        else: # already shown up 2 times
            if p_stop.search(line):
                break
            m_cft = p_cft.search(line)
            if m_cft:
                _clk_name, _fmax, _target_fmax = m_cft.group(1), m_cft.group(2), m_cft.group(3)
                _fmax_float = float(_fmax)
                if _fmax_float < old_fmax:
                    rpt_data = [_clk_name, _target_fmax, _fmax]
                    old_fmax = _fmax_float
    return rpt_titles, rpt_data



def get_string(raw_string):
        if type(raw_string) is str:
            return raw_string
        else: # is a list
            return "/".join(raw_string)

class ScanBasic:
    def __init__(self, last_number=800):
        self.patterns = dict()
        self.last_number = last_number

    def _get_keys(self):
        keys = list(self.patterns.keys())
        keys.sort()
        for item in ("start", "stop"):
            try:
                keys.remove(item)
            except ValueError:
                pass
        return keys

    def get_title(self):
        return [re.sub("^\S+\s+", "", item) for item in self.keys]

    def get_data(self):
        t_data = list()
        #print self.keys
        for item in self.keys:
            #print item
            value = self.data.get(item)
            #print value
            value = str(value)
            if re.search("time$", item, re.I):
                value = time2secs(value)
            t_data.append(value)
        #print t_data    
        return t_data

    def reset(self):
        self.keys = self._get_keys()
        self.data = dict.fromkeys(self.keys, "NA")

    def scan_report(self, rpt_file):
        self.reset()
        line_count = get_file_line_count(rpt_file)
        if not line_count:
            return
        start_pattern = self.patterns.get("start")
        stop_pattern = self.patterns.get("stop")
        from_this_line = line_count - self.last_number
        for key in self.keys:
            if key[0] == "1":  # only scan the line after from_this_line
                for line_no, line in enumerate(open(rpt_file)):
                    if line_no < from_this_line:
                        continue
                    line = line.strip()
                    self._parse_line(key, line)
            elif key[0] == "0":
                if not start_pattern:
                    start = 1 # always
                else:
                    start =0
                for line in open(rpt_file):
                    if not start:
                        start = start_pattern.search(line)
                    else:
                        line = line.strip()
                        if stop_pattern:
                            if stop_pattern.search(line):
                                break
                        self._parse_line(key, line)

    def _parse_line(self, key, line):
        pattern = self.patterns.get(key)
        pattern_type = type(pattern)
        if pattern_type is list:
            for p in pattern:
                m = p.findall(line)
                if not m:
                    continue

                got_string = get_string(m[0])
                try:
                    got_string = int(got_string)
                except ValueError:
                    pass
                key_content = self.data.get(key)
                if key_content == "NA":
                    self.data[key] = got_string
                else:
                    try:
                        self.data[key] += (0+got_string)
                    except TypeError:
                        self.data[key] = str(key_content) + "-" + str(got_string)
        else:  # single pattern
            m = pattern.findall(line)
            if m:
                got_string = get_string(m[0])
                self.data[key] = re.sub(",", "", got_string)

# ////////////////////////////////////////
# iCEcube2 post-LSE report (from _scratch\synthesis.log or run.log)
# EDF Parser run-time
# Placer run-time +
# DRC Checker run-time +
# Packer run-time +
# Router run-time +
# Netlister run-time
# Bitmap run-time

ice_lse_patterns = {
    "001 lse_reg"   : re.compile("Number of register bits\s*=>\s*(\d+)"),
    "002 lse_carry" : re.compile("SB_CARRY\s*=>\s*(\d+)"),
    "003 lse_io"    : [re.compile("SB_IO\s*=>\s*(\d+)"), re.compile("SB_GB_IO\s*=>\s*(\d+)")],
    "004 lse_lut4"  : re.compile("SB_LUT4\s*=>\s*(\d+)"),
    "005 lse_ebr"   : [re.compile("SB_RAM256x16\s*=>\s*(\d+)"),re.compile("SB_RAM512x8\s*=>\s*(\d+)"),re.compile("SB_RAM1024x4\s*=>\s*(\d+)"),re.compile("SB_RAM2048x2\s*=>\s*(\d+)")],
    "006 lse_dsp"   : re.compile("SB_MAC16\s*=>\s*(\d+)"),
    "007 lse_peak_Memory" : re.compile("Peak\s+Memory\s+Usage:\s+([\.\d]+)"),
    "008 lse_cpu_Time" : re.compile("Elapsed\s+CPU\s+time\s+for\s+LSE\s+flow\s+:\s+(.+)"),
    "009 placer_Time" : re.compile("Placer\s+run-time:\s+([\d\.]+)"),
    "011 drc_Time" : re.compile("DRC\s+Checker\s+run-time:\s+([\d\.]+)"),
    "012 packer_Time" : re.compile("Packer\s+run-time:\s+([\d\.]+)"),
    "013 router_Time" : re.compile("Router\s+run-time\s+:\s+([\d\.]+)"),
    }

# ////////////////////////////////////////////
# NG post-LSE report (from \_scratch\impl1\synthesis.log)
ng_lse_patterns = {
    "001 REG"   : re.compile("Number of register bits\s*=>\s*(\d+)"),
    "002 CARRY" : re.compile("FA2\s*=>\s*(\d+)"),  #CARRY = #CCU2E x2
    "003 IO"    : re.compile("BB_B\s*=>\s*(\d+)"),
    "004 LUT4"  : re.compile("LUT4\s*=>\s*(\d+)"),  #LUT4 = #LUT4 + #CCU2E x2
 #   "005 EBR"   : [re.compile("PDP4KA\s*=>\s*(\d+)"),re.compile("SP256KA\s*=>\s*(\d+)")],
    "005 EBR"   : [re.compile("EBR_B\s*=>\s*(\d+)"),re.compile("VFB_B\s*=>\s*(\d+)")],
    "006 DSP"   : re.compile("MAC16\s*=>\s*(\d+)"),
    "stop"      : re.compile("End Area Report"),
}

# ///////////////////////////////////////////
# iCEcube2 post-PAR report (from _scratch\run.log)
ice_post_patterns = {
    "001 LUT"   : re.compile("Number of LUTs\s*:\s*(\d+)"),
    "002 Register"    : re.compile("Number of DFFs\s*:\s*(\d+)"),
    "003 CARRY"  : re.compile("Number of Carrys\s*:\s*(\d+)"),
    "004 EBR"    : [re.compile("Number of RAMs\s*:\s*(\d+)"),re.compile("Number of ROMs\s*:\s*(\d+)")],
    "005 IO"     : [re.compile("Number of GBIOs\s*:\s*(\d+)"),re.compile("Number of IOs\s*:\s*(\d+)")],
    "006 DSP"    : re.compile("Number of DSPs\s*:\s*(\d+)"),
    "start"      : re.compile("Final Design Statistics"),
    }

# ////////////////////////////////////////
# NG post-PAR report (from \_scratch\impl1\<>_impl1.mrp)
ng_post_patterns = {
    "001 LUT4"   : re.compile("Number of LUT4s\s*:\s*(\d+)"),
    "002 REG"    : re.compile("Number of.+registers\s*:\s*(\d+)"),
    "003 CARRY"  : re.compile("Number of ripple logic\s*:\s*(\d+)"),
    "004 EBR"    : re.compile("Number of EBRs\s*:\s*(\d+)"),
    "005 IO"     : re.compile("Number of PIO sites used\s*:\s*(\d+)"),
    "006 DSP"    : re.compile("Number of DSPs\s*:\s*(\d+)"),
    "start"      : re.compile("Design Summary"),
    }

class ScanICEPost(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = ice_post_patterns

class ScanICELSE(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = ice_lse_patterns
        
    

class ScanNGPost(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = ng_post_patterns

    def get_data(self):
        t_data = list()
        # get real carry
        raw_carry = self.data.get("003 CARRY")
        if raw_carry != "NA":
            raw_carry = int(raw_carry) * 2
        for item in self.keys:
            value = self.data.get(item)
            value = str(value)
            if re.search("time$", item, re.I):
                value = time2secs(value)
            elif item == "003 CARRY":
                value = str(raw_carry)
            t_data.append(value)
        return t_data

class ScanNGLSE(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = ng_lse_patterns

    def get_data(self):
        t_data = list()
        # get real carry
        raw_carry = self.data.get("002 lse_carry")
        if raw_carry != "NA":
            raw_carry = int(raw_carry) * 2
        for item in self.keys:
            value = self.data.get(item)
            value = str(value)
            if re.search("time$", item, re.I):
                value = time2secs(value)
            elif item == "002 lse_carry":
                value = str(raw_carry)
            elif item == "004 lse_lut4":
                if raw_carry != "NA":
                    if value != "NA":
                        value = str(int(value) + raw_carry)
            t_data.append(value)
        return t_data
def main():
    import optparse
    parser = optparse.OptionParser()
    parser.add_option("--top-dir", help="specify top result path")
    parser.add_option("--rpt-file", default="report_iCEcube.csv", help="specify target report file")
    opts, args = parser.parse_args()
    top_dir = opts.top_dir
    report_file = opts.rpt_file
    aaa = ScanICELSE()
    bbb = ScanICEPost()

    aaa.scan_report("")
    bbb.scan_report("")
    twr_t, twr_d = scan_timing_rpt("")
    titles = ["Design"] + aaa.get_title() + bbb.get_title() + twr_t + ["par_cpu_Time"]
    rpt_file = report_file
    if os.path.isfile(rpt_file):
        report = open(rpt_file, "a")
    else:
        report = open(rpt_file, "w")
        print(",".join(titles), file=report)

    for a, b, c in os.walk(top_dir):
        if  os.path.basename(a) == "_scratch":
            design_name = os.path.dirname(re.sub(".+\W%s\W" % os.path.basename(top_dir), "", a))
            design_name = re.sub(r"\\", "/", design_name)
            file1 = os.path.join(a, "run.log")
            timing_rpt_grep = os.path.join(a, "*_Implmnt", "sbt", "outputs", "timer", "*timing.rpt")
            timing_rpt = glob.glob(timing_rpt_grep)
            aaa.scan_report(file1)
            bbb.scan_report(file1)
            if timing_rpt:
                time_rpt_file = timing_rpt[0]
                _t, _d = scan_timing_rpt(time_rpt_file)
            else:
                _d = ["", "", ""]
            total_time = get_total_time(aaa.get_title(), aaa.get_data())
            print("Scanning %s" % design_name)
            print(",".join([design_name] + aaa.get_data() + bbb.get_data() + _d + [total_time]), file=report)
    report.close()


def get_total_time(title, data):
    p = dict(list(zip(title, data)))
    t_time = 0
    for key in ("placer_Time", "drc_Time", "packer_Time", "router_Time"):
        try:
            t_time += float(p.get(key))
        except:
            pass
    return "%.3f" % t_time


if __name__ == "__main__":
    main()





