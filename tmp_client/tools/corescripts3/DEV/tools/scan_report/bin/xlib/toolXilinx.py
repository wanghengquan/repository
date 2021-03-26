import re
import shlex
from .xOS import not_exists, get_fname_ext
from .xTools import append_file
from .xReport import ScanBasic

p_clock = re.compile("^Timing constraint: Default period analysis for net", re.I)
# Timing constraint: Default period analysis for net
# "syncro_i/clk155mhzgen/CKOUT_i_m2"
# Timing constraint: Default period analysis for net "rstatus_ck_left_i_0_cb"
def get_clocks_from_map_twr(map_twr):
    if not_exists(map_twr, "_map.twr file"):
        return
    clocks = set()
    my_line = ""
    for line in open(map_twr):
        line = line.strip()
        if p_clock.search(line):
            my_line = line
        if my_line:
            if not line:
                # can get clock name
                my_line = shlex.split(my_line)
                clock_name = my_line[-1]
                clock_name = re.sub("\s+", "", clock_name)
                clocks.add(clock_name)
                my_line = ""
            else:
                line = " " + line
                my_line += line
    clock_list = list(clocks)
    clock_list.sort(key=str.lower)
    return clock_list

def update_ucf_file(ucf_file, clocks, tf):
    mhz_str = "%.2f MHz HIGH 50%%;" % tf
    ucf_lines = list()
    if clocks:
        for line in open(ucf_file):
            line = line.strip()
            if re.search("TIMESPEC", line):
                continue
            ucf_lines.append(line)
        ucf_lines.append("# clocks number: %s" % len(clocks))

        for i, clk in enumerate(clocks):
            ucf_lines.append('NET "%s" TNM_NET = %s;' % (clk, clk))
            new_spec = re.sub("\W", "__", clk)
            ucf_lines.append('TIMESPEC TS_%s = PERIOD "%s" %s' % (new_spec, new_spec, mhz_str))
            if not( (i+1)%5 ):
                ucf_lines.append("")
    else:
        for line in open(ucf_file):
            line = line.strip()
            line = re.sub('PERIOD\s+"([^"]+)".+', 'PERIOD "\\1" %s' % mhz_str, line)
            ucf_lines.append(line)
    append_file(ucf_file, ucf_lines, append=False)

def update_pcf_file(pcf_file, MHz):
    pcf_lines = open(pcf_file).readlines()
    ob_pcf = open(pcf_file, "w")
    for line in pcf_lines:
        line = re.sub('TS_\S+\s+[\*/]\s+\d+\s+HIGH', '%.3f MHz HIGH' % MHz, line)
        ob_pcf.write(line)
    ob_pcf.close()

class ScanXilinxTwr:
    def __init__(self):
        self.title = ["targetFmax", "fmax", "clkName", "logic", "route", "level"]
        self.create_patterns()
        self.all_raw_data = list()

    def get_title(self):
        return self.title

    def create_patterns(self):
        self.p_clock_start = re.compile("^Timing constraint: Default period analysis for net", re.I)
        self.p_clock = re.compile("^Source Clock:\s+(\S+)")
        self.p_min_period = re.compile("^Minimum period is\s+([\d\.]+)ns")
        # (20.7% logic, 79.3% route)
        self.p_logic_route = re.compile("""\(
                                (?P<logic>[\d\.]+%)\s+logic,\s+
                                (?P<route>[\d\.]+%)\s+route
                                \)
                                """, re.VERBOSE)
        self.p_level = re.compile("\(Levels of Logic =\s+(\d+)\)", re.I)
        self.p_tf = re.compile("\s+([\d\.]+)\s+MHz")

    def scan_report(self, rpt_file, hot_clk=""):
        self.all_raw_data = list()
        if not_exists(rpt_file, "report file"):
            return 1
        self.rpt_file = rpt_file
        self.get_target_fmax()
        self.all_raw_data = list()

        start = 0
        t_dict = dict()
        for line in open(rpt_file):
            line = line.strip()
            if not start:
                if self.p_clock_start.search(line):
                    start = 1
                continue

            m_clock = self.p_clock.search(line)
            m_min_period = self.p_min_period.search(line)
            m_logic_route = self.p_logic_route.search(line)
            m_level = self.p_level.search(line)
            if m_clock:
                _clk_name = m_clock.group(1)
                if hot_clk:
                    if _clk_name != hot_clk:
                        t_dict = dict()
                        start = 0
                        continue
                t_dict["clkName"] = m_clock.group(1)
            elif m_min_period:
                _ns = m_min_period.group(1)
                _mhz = eval("1000.0/%s" % _ns)
                t_dict["fmax"] = "%.3f" % _mhz
                t_dict["targetFmax"] = self.target_fmax
            elif m_level:
                t_dict["level"] = m_level.group(1)
            elif m_logic_route:
                t_dict["logic"] = m_logic_route.group("logic")
                t_dict["route"] = m_logic_route.group("route")
                start = 0
                self.all_raw_data.append(t_dict)
                t_dict = dict()

    def get_target_fmax(self):
        ucf_file = get_fname_ext(self.rpt_file)[0] + ".ucf"
        if not_exists(ucf_file, "UCF file"):
            self.target_fmax = "-"
        else:
            for line in open(ucf_file):
                m_tf = self.p_tf.search(line)
                if m_tf:
                    self.target_fmax = m_tf.group(1)
                    break
            else:
                self.target_fmax = "NA"

    def _get_float(self, raw_str):
        raw_str = re.sub("\D+", "", raw_str)
        return float(raw_str)

    def _get_minimize(self, key):
        min_data = dict()
        for item in self.all_raw_data:
            new_value = item.get(key)
            old_value = min_data.get(key)
            if not old_value:
                min_data = item
            else:
                new_value = self._get_float(new_value)
                old_value = self._get_float(old_value)
                if old_value > new_value:
                    min_data = item
            #return min_data
        return [min_data.get(item, "NA") for item in self.title]

    def get_data(self):
        return self._get_minimize("fmax")

    def get_central_fmax(self):
        fmax_minimize = self._get_minimize("fmax")
        fmax_idx = self.title.index("fmax")
        return fmax_minimize[fmax_idx]

    def get_all_data(self):
        all_data = list()
        for item in self.all_raw_data:
            t_data = [item.get(foo) for foo in self.title]
            all_data.append(t_data)
        return all_data

class ScanXilinxMrp(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "001 Device" : [re.compile("^Target Device\s+:\s+(\S+)"),
                            re.compile("^Target Package\s+:\s+(\S+)"),
                            re.compile("^Target Speed\s+:\s+-(\S+)")],
            # Target Device  : xc6slx25t
            # Target Package : csg324
            # Target Speed   : -4
            # -----
            "002 Register" : re.compile("^Number of Slice Registers:\s+(\S+)"),
            "003 LUT" : re.compile("^Number of Slice LUTs:\s+(\S+)"),
            # Number of Slice Registers:  1,097 out of  30,064    3%
            # Number of Slice LUTs:       967 out of  15,032    6%
        }
        self.reset()

class ScanXilinxTime(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.patterns = {
            "002 ngdbuild" : re.compile("^([\.\d]+)\s+,\s+\S+ngdbuild\s+"),
            "003 map" : re.compile("^([\.\d]+)\s+,\s+\S+map\s+"),
            "004 par" : re.compile("^([\.\d]+)\s+,\s+\S+par\s+"),
            "005 trce" : re.compile("^([\.\d]+)\s+,\s+\S+trce\s+")
        }
        self.reset()



if __name__ == "__main__":
    twr_file = r"d:\virtex5_synp.twr"
    pp = ScanXilinxTwr()
    pp.scan_report(twr_file)
    print(pp.get_data())
    print(pp.get_central_fmax())
    print(pp.get_all_data())

    print('-' * 100)

    pp.scan_report(twr_file, "dram_clk")
    print(pp.get_data())
    print(pp.get_central_fmax())
    print(pp.get_all_data())
