import re
import copy
import os
import glob
import sys
import optparse

from collections import OrderedDict

from xlib import xTools
from xlib import readXML


def get_clk_loads_net_from_mrp(mrp_file):
    """
    Radiant!
    """
    p_start = re.compile("Number of clocks:\s+(\d+)", re.I)
    p_stop = re.compile("Number of")
    # Pin CLK: 118 loads, 118 rising, 0 falling (Net: u2/CLK_c)
    p_focus = re.compile("""
                         ^(?P<noUse>Pin|Port|Net)\s*
                         (?P<clkName>[^:]+):\s+
                         (?P<loads>\d+)\s*loads,\s+
                         .+?
                         \(
                         (?P<noUse2>Net|Driver):\s+
                         (?P<net>[^\)]+)
                         \)
                         """, re.X)
    p_need_space = re.compile("\W$")
    rpt_ob = open(mrp_file)
    clk_number = -1
    t_line = list()
    happy_results = list()
    _keys = ("clkName", "loads", "net")
    p_skips = [re.compile("^Page\s+\d+$"), re.compile("^Design\s+Summary"), re.compile("^-+$")]
    while True:
        line = rpt_ob.readline()
        if not line:
            break
        line = line.strip()
        if clk_number == -1:
            m = p_start.search(line)
            if m:
                clk_number = int(m.group(1))
        else:
            if not line:
                continue
            for k in p_skips:
                if k.search(line):
                    break
            else:
                if line == "Pin":
                    line += " "
                if p_stop.search(line):
                    break
                if p_need_space.search(line):
                    line += " "
                t_line.append(line)
                temp_string = "".join(t_line)
                m_focus = p_focus.search(temp_string)
                if m_focus:
                    _values = [re.sub("\s+", "", m_focus.group(item)) for item in _keys]
                    happy_results.append(dict(list(zip(_keys, _values))))
                    t_line = list()
    if clk_number != -1:
        assert clk_number == len(happy_results), "Failed to match all clocks in %s" % mrp_file
    return happy_results


def get_pre_slack_level_actual_from_twr_old(twr_file):
    """
    Radiant!
    empty line after 'SETUP SUMMARY REPORT' is stop tag.
    OLD TWR FORMAT!
    """
    start = 0
    title = list()
    _t = list()
    _dict_list = list()
    for line in open(twr_file):
        one = line.rstrip()
        line = line.strip()
        if line.startswith("Preference"):
            line_list = re.split("\s*\|\s*", line)
        else:
            line_list = re.split("\s*\|\s*", one)

        if not start:
            if line == "SETUP SUMMARY REPORT":
                start = 1
            continue
        if not line:
            break  # stop here

        if line.startswith("Preference"):
            title = line_list
            continue
        if title:
            if len(line_list) < 3:  # -----, separate signs
                continue
            if line_list.count("") > 4:
                if line_list[0]:  # has value
                    _t += [line_list[0]]  # create_clock -name {CLK_c} -period 10 [ | | | | | |
            else:
                _t += line_list
                new_t = list()
                idx = -len(title) + 1
                idx_2 = len(_t) + idx
                new_t.append("".join(_t[:idx_2]))
                new_t += _t[idx:]
                _dict_list.append(dict(list(zip(title, new_t))))
                _t = list()
    return _dict_list


def get_pre_slack_level_actual_from_twr(twr_file):
    start = 0
    title = list()
    _t = list()
    _dict_list = list()
    p_start = re.compile("^[\d\.]+\s+Setup\s+Constraint\s+Slack\s+Summary")
    for line in open(twr_file):
        if not start:
            start = p_start.search(line)
            continue
        one = line.rstrip()
        line = line.strip()
        if not line:
            break
        line_list = re.split("\|", one)
        line_list = [item.rstrip() for item in line_list]
        if line_list[0].strip() == "SDC Constraint":
            title = [item.strip() for item in line_list]
            continue
        if title:
            if line_list.count("") == len(line_list):
                if _t:
                    real_t = ["".join([item[0] for item in _t])] + _t[-1][1:]
                    real_t = [item.strip() for item in real_t]
                    _dict_list.append(dict(list(zip(title, real_t))))
                    _t = list()
            else:
                if line_list[0].count("-") > 40:
                    continue
                _t.append(line_list)
    if _t:
        real_t = ["".join([item[0] for item in _t])] + _t[-1][1:]
        real_t = [item.strip() for item in real_t]
        _dict_list.append(dict(list(zip(title, real_t))))
    return _dict_list


class RootBasic:
    def __init__(self):
        """
        No use
        """
        self.title = list()
        self.data = list()

    def get_data(self):
        return self.data

    def get_title(self):
        return self.title

    def _initialize_data(self):
        self.data = ["NA"] * len(self.title)


class ScanBasic(RootBasic):
    def __init__(self, is_simple=1):
        RootBasic.__init__(self)
        self.is_simple = is_simple
        self.patterns = OrderedDict()
        self.hot_lines = list()
        self.create_patterns()  # should be rewrite on your demand
        self._create_title()
        self._initialize_data()

    def create_patterns(self):
        pass

    def _create_title(self):
        self.title = list(self.patterns.keys())

    def scan_file(self, rpt_file):
        self._initialize_data()
        self.data_dict = dict()
        if xTools.not_exists(rpt_file, "Report/Log file"):
            return 1
        self.rpt_file = rpt_file
        self.get_hot_lines()  # should be rewrite on your demand
        if not self.hot_lines:
            self.hot_lines = open(rpt_file)
        self.parse_hot_lines()
        self.more_steps()
        self.get_real_data()

    def get_real_data(self):
        self.data = list()
        p_is_time = re.compile("_time$", re.I)
        for key in list(self.patterns.keys()):
            my_value = self.data_dict.get(key, "NA")
            if p_is_time.search(key):
                my_value = xTools.time2secs(my_value)
            self.data.append(my_value)

    def get_hot_lines(self):
        pass

    def parse_hot_lines(self):
        local_patterns = copy.copy(self.patterns)
        for line in self.hot_lines:
            if not local_patterns:
                break  # search all items already
            line = line.rstrip()
            for key, pattern in list(local_patterns.items()):
                if not pattern:  # define in more steps
                    local_patterns.pop(key)
                    continue
                if isinstance(pattern, list) or isinstance(pattern, tuple):
                    biang = pattern[:]
                else:
                    biang = [pattern]
                for mian in biang:
                    m = mian.search(line)
                    if m:
                        local_patterns.pop(key)
                        try:
                            dd = m.group("no")
                        except IndexError:
                            dd = m.group(1)
                        self.data_dict[key] = dd
                        break

    def more_steps(self):
        pass


class ScanMrpFile(ScanBasic):
    """
    Scan .mrp file
    """

    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns["Register"] = re.compile("Number of.+registers:\s+(\d+)")
        self.patterns["Register_per"] = re.compile("Number of.+registers:\s+\d+.+\((.+)\)")
        # Number of LUT4s:             1 out of  5280 (<1%)
        self.patterns["LUT"] = re.compile("Number of LUT4s:\s+(\d+)")
        self.patterns["LUT_per"] = re.compile("Number of LUT4s:.+out\s+of\s+\d+\s+\((.+)\)")
        #    Number of IO sites used:   32 out of 56 (57%)
        #    Number of PIOs used:         277 out of   312 (89%)
        self.patterns["IO"] = re.compile("Number of P?[IO sites|IOs].+used:\s+(\d+)")
        self.patterns["IO_per"] = re.compile("Number of P?[IO sites|IOs].+used:\s+\d+.+\((.+)\)")
        #    Number of EBRs:             0 out of 30 (0%)
        #    Number of Block RAMs:          208 out of 264 (78%)
        self.patterns["EBR"] = re.compile("Number of (?P<name>EBRs|Block\s+RAMs):\s+(?P<no>\d+)")
        self.patterns["DSP"] = re.compile("Number of DSPs:\s+(\d+)")
        self.patterns["CARRY"] = re.compile("Number\s+of\s+ripple\s+logic:\s+(\d+)")
        self.patterns["DistributedRAM"] = re.compile("Number\s+used\s+as\s+distributed\s+RAM:\s+(\d+)")
        self.patterns["CCU"] = ""

        self.patterns["clkNumber"] = re.compile("Number of clocks:\s+(\d+)", re.I)
        self.patterns["maxLoads"] = ""
        self.patterns["totalLoads"] = ""
        self.patterns["map_cpu_Time"] = re.compile("Total CPU Time:\s+(.+)")
        self.patterns["map_real_Time"] = re.compile("Total REAL Time:\s+(.+)")
        self.patterns["map_peak_Memory"] = re.compile("Peak Memory Usage:\s+(\d+)")
        """
        Number of PREADD9:       32 out of 440 (7%)
        Number of MULT9:         32 out of 440 (7%)
        Number of MULT18:        16 out of 220 (7%)
        Number of M18X36:        0 out of 110 (0%)
        Number of MULT36:        4 out of 55 (7%)
        Number of ACC54:         0 out of 110 (0%)
        Number of REG18:         16 out of 440 (3%)
        """
        self.patterns["DSP_PREADD9"] = re.compile("Number of PREADD9:\s+(\d+)")
        self.patterns["DSP_MULT9"] = re.compile("Number of MULT9:\s+(\d+)")
        self.patterns["DSP_MULT18"] = re.compile("Number of MULT18:\s+(\d+)")
        self.patterns["DSP_M18X36"] = re.compile("Number of M18X36:\s+(\d+)")
        self.patterns["DSP_MULT36"] = re.compile("Number of MULT36:\s+(\d+)")
        self.patterns["DSP_ACC54"] = re.compile("Number of ACC54:\s+(\d+)")
        self.patterns["DSP_REG18"] = re.compile("Number of REG18:\s+(\d+)")
        self.patterns["mapComments"] = re.compile("(ERROR\s+-\s+.{1,135})")

        self.p_start = self.patterns["clkNumber"]
        self.p_stop = re.compile("Number of")
        self.p_loads = re.compile(":\s+(\d+)\s+loads,\s+\d+\s+rising")

    def more_steps(self):
        clk_loads_net = get_clk_loads_net_from_mrp(self.rpt_file)
        if not clk_loads_net:
            return
        loads = [int(item.get("loads")) for item in clk_loads_net]
        self.data_dict["maxLoads"] = str(max(loads))
        self.data_dict["totalLoads"] = str(sum(loads))
        _carry = self.data_dict.get("CARRY", "NA")
        if _carry != "NA":
            self.data_dict["CARRY"] = xTools.get_simple_digit_str(2 * float(_carry))


class ScanRunPBLog(ScanBasic):
    """
    Scan run_pb.log file
    """

    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns = OrderedDict()
        self.patterns["version"] = None
        self.patterns["postsyn_cpu_Time"] = re.compile("Total CPU Time:\s+(.+)")
        self.patterns["postsyn_real_Time"] = re.compile("Total REAL Time:\s+(.+)")
        self.patterns["postsyn_peak_Memory"] = re.compile("Peak Memory Usage:\s+(\d+)")

        self.p_start = re.compile("Command Line: postsyn")
        self.p_stop = re.compile("Copyright")

    def get_hot_lines(self):
        start = 0
        for line in open(self.rpt_file):
            if not start:
                start = self.p_start.search(line)
                continue
            if start:
                self.hot_lines.append(line)
                if self.p_stop.search(line):
                    break

    def more_steps(self):
        _t = [re.compile("Lattice\s+Radiant\s+Software\s+Version\s+(.+)"),
              re.compile("version\s+Radiant\s+Software\s+(.+)")]
        with open(self.rpt_file) as one:
            for line in one:
                got_it = 0
                for _this_p in _t:
                    _m = _this_p.search(line)
                    if _m:
                        this_v = _m.group(1)
                        this_v = re.sub("\(64-bit\)", "", this_v)
                        this_v = this_v.strip()
                        self.data_dict["version"] = this_v
                        got_it = 1
                        break
                if got_it:
                    break


class ScanLdfFile(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns["device"] = re.compile('\s+device="([^"]+)"\s+')
        self.patterns["synthesis"] = re.compile('\s+synthesis="([^"]+)"\s+')
        self.patterns["HDL_type"] = None

    def more_steps(self):
        sp = re.compile('performance_grade="([^"]+)"\s+')
        with open(self.rpt_file) as one:
            for line in one:
                m_sp = sp.search(line)
                if m_sp:
                    cur_device = self.data_dict.get("device", "NoDevice")
                    self.data_dict["device"] = cur_device + "-" + m_sp.group(1)
                    break

        p_type = re.compile('<Source name.+type="([^"]+)"')
        p_excluded = re.compile('excluded="TRUE">')
        type_in_file = set()
        with open(self.rpt_file) as one:
            for line in one:
                if p_excluded.search(line):
                    continue
                m_type = p_type.search(line)
                if m_type:
                    type_name = m_type.group(1)
                    if type_name in ("SBX", "IPX"):
                        type_name = "Verilog"
                    type_in_file.add(type_name)
        _all = ["Verilog", "VHDL"]
        my_set = set(_all)
        chk_set = my_set - type_in_file
        if len(chk_set) == 0:
            _ = "MixedHDL"
        elif len(chk_set) == 1:
            if "Verilog" in chk_set:
                _ = "VHDL"
            else:
                _ = "Verilog"
        else:
            _ = "Unknown"
        self.data_dict["HDL_type"] = _


class ScanParFile(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.p_cpu_time = "Placer_cpu_Time"
        self.r_cpu_time = "Router_cpu_Time"
        self.t_cpu_time = "par_cpu_Time"
        self.t_real_time = "par_real_Time"
        self.patterns["Slice"] = re.compile('^\s+SLICE\s+(\d+)/\d+\s+\S+\s+used')  # SLICE  134/2640   5% used
        self.patterns["Slice_per"] = re.compile('^\s+SLICE\s+\d+/\d+\s+(\S+)\s+used')
        self.patterns["par_signals"] = re.compile("Number\s+of\s+Signals:\s+(.+)")
        self.patterns["par_connections"] = re.compile("Number\s+of\s+Connections:\s+(.+)")
        # after PAR current memory 414.790 Mbytes/maximum (recorded) memory 423.391 Mbytes
        # after PAR current memory 97.972 Mbytes/peak memory 171.745 Mbytes
        self.patterns["ParPeakMem"] = re.compile("after\s+PAR.+memory\s+([\d\.]+)\s+\S+$")

        # PAR_SUMMARY::Timing score<setup/<ns>> = 10673.908
        # PAR_SUMMARY::Timing score<hold /<ns>> = 0.000
        self.patterns["scoreSetup"] = re.compile("PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)")
        self.patterns["scoreHold"] = re.compile("PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)")
        # Info: Initial congestion level at 75% usage is 2
        # Info: Initial congestion area  at 75% usage is 171 (1.19%)
        self.patterns["par_congestion_level"] = re.compile("Initial\s+congestion\s+level\s+at.+is\s+(\d+)")
        self.patterns["par_congestion_area"] = re.compile("Initial\s+congestion\s+area.+is\s+(\d+)")
        self.patterns["par_congestion_area_per"] = re.compile("Initial\s+congestion\s+area.+is\s+\d+\s+\(([^\)]+)\)")
        self.patterns["parComments"] = re.compile("(ERROR\s+-\s+.{1,135})")
        for k in (self.p_cpu_time, self.r_cpu_time, self.t_cpu_time, self.t_real_time):
            self.patterns[k] = None

    def get_hot_lines(self):
        start = 0
        self.p_start = re.compile("Number\s+of\s+Signals:\s+(.+)")
        for line in open(self.rpt_file):
            if not start:
                start = self.p_start.search(line)
                if start:
                    self.hot_lines.append(line)
            else:
                self.hot_lines.append(line)

    def more_steps(self):
        # for scoreSetup/scoreHold value
        def _multi_1000(key):
            value = self.data_dict.get(key)
            if value:
                new_value = float(value) * 1000
                self.data_dict[key] = xTools.get_simple_digit_str(new_value)
        _multi_1000("scoreSetup")
        _multi_1000("scoreHold")
        self.get_par_cpu_real_time()
        self.get_placer_cpu_time()
        self.get_router_cpu_time()

    def get_par_cpu_real_time(self):
        line_cnt = xTools.get_file_line_count(self.rpt_file)
        # only scan the last 50 lines
        p1 = re.compile("Total\s+CPU\s+Time:(.+)")
        p2 = re.compile("Total\s+REAL\s+Time:(.+)")
        start_line_num = line_cnt - 50
        res1 = res2 = "NA"
        for count, line in enumerate(open(self.rpt_file, "rU")):
            if count < start_line_num:
                continue
            line = line.strip()
            m1 = p1.search(line)
            if m1:
                res1 = m1.group(1)
            else:
                m2 = p2.search(line)
                if m2:
                    res2 = m2.group(1)
        self.data_dict[self.t_cpu_time] = res1
        self.data_dict[self.t_real_time] = res2

    def get_placer_cpu_time(self):
        p = re.compile("Total\s+Placer\s+CPU\s+time:([^,]+),")
        with open(self.rpt_file) as ob:
            for line in ob:
                m = p.search(line)
                if m:
                    self.data_dict[self.p_cpu_time] = m.group(1)
                    return

    def get_router_cpu_time(self):
        """
        Total CPU time 2 mins 39 secs
        Total REAL time: 2 mins 42 secs
        Completely routed.
        End of route.
        :return:
        """
        p1 = re.compile("Total\s+CPU\s+time\s+(.+)")
        p2 = re.compile("End\s+of\s+route")
        with open(self.rpt_file) as ob:
            _t = ""
            for line in ob:
                if _t:
                    if p2.search(line):
                        break
                else:
                    m1 = p1.search(line)
                    if m1:
                        _t = m1.group(1)
            if _t:
                self.data_dict[self.r_cpu_time] = _t.strip()


class ScanSynthesisLog(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        # Peak Memory Usage: 180.957  MB
        # Elapsed CPU time for LSE flow : 6.037  secs
        self.patterns["lse_peak_Memory"] = [re.compile("Peak Memory Usage:\s+([\d\.]+)"),
                                            re.compile("Peak Memory Usage:\s+-([d\.]+)")
                                            ]
        self.patterns["lse_cpu_Time"] = [re.compile("CPU time for LSE flow :\s+([\d\.]+)\s+secs"),
                                         re.compile("Total\s+CPU\s+Time:\s+(.+)")
                                         ]
        self.patterns["lse_reg"] = ""
        self.patterns["lse_carry"] = ""
        self.patterns["lse_io"] = ""
        self.patterns["lse_lut4"] = ""
        self.patterns["lse_ebr"] = ""
        self.patterns["lse_dsp"] = ""
        self.patterns["lse_odd"] = ""
        self.patterns["lse_even"] = ""

    def get_hot_lines(self):
        line_cnt = xTools.get_file_line_count(self.rpt_file)
        # only scan the last 50 lines
        start_line_num = line_cnt - 50
        for count, line in enumerate(open(self.rpt_file, "rU")):
            if count < start_line_num:
                continue
            self.hot_lines.append(line)

    def more_steps(self):
        ng_lse_patterns = {
            "REG": re.compile("Number of register bits\s*=>\s*(\d+)"),
            "CARRY": re.compile("FA2\s*=>\s*(\d+)"),  # CARRY = #CCU2E x2
            "IO": re.compile("BB_B\s*=>\s*(\d+)"),
            "LUT4": re.compile("LUT4\s*=>\s*(\d+)"),  # LUT4 = #LUT4 + #CCU2E x2
            "EBR_1": re.compile("EBR_B\s*=>\s*(\d+)"),
            "EBR_2": re.compile("VFB_B\s*=>\s*(\d+)"),
            "DSP": re.compile("MAC16\s*=>\s*(\d+)"),
            "ODD": re.compile("Number of odd-length carry chains :\s*(\d+)"),
            "EVEN": re.compile("Number of even-length carry chains :\s*(\d+)"),
        }
        p_start = re.compile("Begin Area Report")
        p_stop = re.compile("Begin Clock Report")
        start = 0
        t_data = dict()
        with open(self.rpt_file) as rpt_ob:
            for line in rpt_ob:
                if not start:
                    start = p_start.search(line)
                elif p_stop.search(line):
                    break
                else:
                    for k, p in list(ng_lse_patterns.items()):
                        m = p.search(line)
                        if m:
                            t_data[k] = int(m.group(1))
                            ng_lse_patterns.pop(k)
                            break
        for (fk, nk) in (("lse_reg", "REG"), ("lse_io", "IO"), ("lse_dsp", "DSP"),
                         ("lse_odd", "ODD"), ("lse_even", "EVEN")):
            self.data_dict[fk] = str(t_data.get(nk, "NA"))

        _carry = t_data.get("CARRY")
        _lut4 = t_data.get("LUT4")
        _ebr_1 = t_data.get("EBR_1")
        _ebr_2 = t_data.get("EBR_2")
        odd = t_data.get("ODD", 0)
        even = t_data.get("EVEN", 0)

        if _carry:
            _carry *= 2
            # New Radiant Carry = original Radiant Carry - even - 2 * odd
            final_carry = _carry - even - 2 * odd
            # final_carry = _carry
            self.data_dict["lse_carry"] = str(final_carry)

        if not _carry:
            _carry = 0
        if _lut4:
            # New Radiant LUT = original Radiant LUT- 2 * even - 3 * odd
            tu = _lut4 + _carry - 2 * even - 3 * odd
            # t = _lut4
            self.data_dict["lse_lut4"] = str(tu)

        if _ebr_1 or _ebr_2:
            if not _ebr_1:
                _ebr_1 = 0
            if not _ebr_2:
                _ebr_2 = 0
            self.data_dict["lse_ebr"] = str(_ebr_1 + _ebr_2)


class ScanSrrFile(RootBasic):
    def __init__(self):
        RootBasic.__init__(self)
        self.title = ["synp_cpu_Time", "synp_real_Time", "synp_peak_Memory"]
        self._initialize_data()

    def scan_file(self, srr_file):
        self._initialize_data()
        self.data_dict = dict()
        if xTools.not_exists(srr_file, "Srr File"):
            return 1
        self.rpt_file = srr_file
        self.get_run_time()
        self.get_memory()
        self.data = [self.data_dict.get(key, "NA") for key in self.title]

    def get_run_time(self):
        p_successful = re.compile("(Pre-mapping|Mapper)\s+(successful!)")
        # At Mapper Exit (Real Time elapsed 0h:00m:01s; CPU Time elapsed 0h:00m:01s;
        p_time = re.compile("""At\s+(Mapper|c_hdl|syn_nfilter|c_vhdl)\s+
                               Exit\s+
                               \(Real\s+Time\s+elapsed\s+(\S+);\s+
                               CPU\s+Time\s+elapsed\s+(\S+)""", re.X)
        patterns = [p_successful, p_time]
        raw_time_list = list()
        for line in open(self.rpt_file):
            for p in patterns:
                m = p.findall(line)
                if m:
                    raw_time_list.append(m)
        # - [('syn_nfilter', '0h:00m:01s', '0h:00m:01s;')]
        # - [('c_hdl', '0h:00m:14s', '0h:00m:12s;')]
        # - [('syn_nfilter', '0h:00m:01s', '0h:00m:01s;')]
        # - [('Pre-mapping', 'successful!')]
        # - [('Mapper', '0h:00m:02s', '0h:00m:02s;')]
        # - [('Mapper', 'successful!')]
        # - [('Mapper', '0h:01m:10s', '0h:01m:09s;')]
        _t = dict()
        # syn_nfilter, c_hdl: use the last one
        # Mapper: check previous settings, Pre-mapping and Mapper
        for i, item in enumerate(raw_time_list):
            foo_tuple = item[0]  # from re findall
            if foo_tuple[1] == "successful!":
                continue
            foo_key = foo_tuple[0]
            new_time = [float(xTools.time2secs(item)) for item in foo_tuple[1:]]
            if foo_key in ("syn_nfilter", "c_hdl"):
                _t[foo_key] = new_time
            elif foo_key in ("Mapper", ):
                # check the previous settings
                previous_item_tag = raw_time_list[i - 1][0][0]
                if previous_item_tag in ("Pre-mapping", "Mapper"):
                    _t[previous_item_tag] = new_time
        real_time, cpu_time = 0, 0
        for key, value in list(_t.items()):
            real_time += value[0]
            cpu_time += value[1]
        self.data_dict["synp_cpu_Time"] = xTools.get_simple_digit_str(cpu_time)
        self.data_dict["synp_real_Time"] = xTools.get_simple_digit_str(real_time)

    def get_memory(self):
        """
        get the max value for peak memory
        """
        # Memory used current: 109MB peak: 143MB
        p_mem = re.compile("Memory used current:\s+\S+\s+peak:\s+(\d+)")
        raw_memories = list()
        for line in open(self.rpt_file):
            m_mem = p_mem.search(line)
            if m_mem:
                raw_memories.append(int(m_mem.group(1)))
        if raw_memories:
            self.data_dict["synp_peak_Memory"] = str(max(raw_memories))


def _parse_fmax(one_dict):
    preference = one_dict.get("SDC Constraint")
    levels = one_dict.get("Levels")
    # Constraint = one_dict.get("Constraint")
    # Slack = one_dict.get("Slack")
    p_period = re.compile("-period\s*([\d\.]+)")
    m = p_period.search(preference)
    if m:
        period = m.group(1)
        period = float(period)
    else:
        return dict()

    # for k in (Constraint, Slack):
    #    if not re.search("ns", k): # must have ns
    #        return dict()

    t = dict()
    p_clk_name = re.compile("get_(ports|nets|pins)\s*([^\]]+)\]")
    # create_clock -name {osc_clk} -period 11
    # .297 -waveform {0.000 5.649} [get_pins
    # i_osc_clk_ibuf.bb_inst/O]
    # p_clk_name = re.compile("create_clock\s+-name\s+\{(.+?)\}")
    m_clk_name = p_clk_name.search(preference)
    if m_clk_name:
        clk_name = re.sub("\s+", "", m_clk_name.group(2))
        t["clkName"] = clk_name
    else:
        xTools.say_it("Error. Not found clk name from: %s" % preference)
        return

    # _cons = float(re.sub("ns", "", Constraint))
    # _slack = float(re.sub("ns", "", Slack))
    #
    # if period == _cons:
    #     t["fmax"] = 1000/ (_cons - _slack)
    # else:
    #     t["fmax"] = 1000/ (2 * (_cons - _slack))
    try:
        t["fmax"] = float(re.sub("MHz", "", one_dict.get("Frequency")))
    except:
        return
    t["logic_level"] = levels
    t["targetFmax"] = 1000.0 / period
    return t


class ScanTwrFile(RootBasic):
    def __init__(self, pap):
        RootBasic.__init__(self)
        self.pap = pap
        self.title = ["targetFmax", "fmax", "clkName", "route_delay", "cell_delay", "logic_level", "doubleEdge",
                      "constraint_coverage", "total_neg_slack_setup", "total_neg_slack_hold", "pap", "CombineLoop"]
        self._initialize_data()

    def scan_file(self, twr_file):
        self._initialize_data()
        if xTools.not_exists(twr_file, "Twr File"):
            return 1
        self.rpt_file = twr_file
        self.raw_list = get_pre_slack_level_actual_from_twr(self.rpt_file)
        self.data_dict = dict()
        if not self.create_data_a():
            self.create_data_b()
        self.get_more_data()
        self.data = [self.data_dict.get(key, "NA") for key in self.title]

    def get_more_data(self):
        p1 = re.compile("Constraint Coverage:\s+(.+)")
        p2 = re.compile("Total Negative Slack:.+([\d\.]+)\s+ns\s+\(setup\)")
        p3 = re.compile("Total Negative Slack:.+([\d\.]+)\s+ns\s+\(hold\)")
        p_loop = re.compile("\++\s+Loop\d+")
        loop_no = 0
        for line in open(self.rpt_file):
            line = line.strip()
            m1 = p1.search(line)
            if m1:
                self.data_dict["constraint_coverage"] = m1.group(1)
            else:
                m2 = p2.search(line)
                m3 = p3.search(line)
                if m2:
                    self.data_dict["total_neg_slack_setup"] = m2.group(1)
                if m3:
                    self.data_dict["total_neg_slack_hold"] = m3.group(1)
                else:
                    m_loop = p_loop.search(line)
                    if m_loop:
                        loop_no += 1
        self.data_dict["CombineLoop"] = str(loop_no)

    def create_data_a(self):
        tfl = list()
        for item in self.raw_list:
            new_item = _parse_fmax(item)
            if new_item:
                wang = "%s/%s" % (new_item.get("fmax"), new_item.get("targetFmax"))
                new_item["pap"] = float("%.5f" % eval(wang))
                tfl.append(new_item)
        if tfl:
            if self.pap:
                peter = "pap"
            else:
                peter = "fmax"
            _fmax = [foo.get(peter) for foo in tfl]
            real_fmax = min(_fmax)
            real_idx = _fmax.index(real_fmax)
            _got_it = tfl[real_idx]
            self.data_dict["fmax"] = xTools.get_simple_digit_str(_got_it["fmax"])
            self.data_dict["targetFmax"] = xTools.get_simple_digit_str(_got_it.get("targetFmax"))
            self.data_dict["clkName"] = _got_it["clkName"]
            self.data_dict["logic_level"] = _got_it["logic_level"]
            self.data_dict["pap"] = "%.3f%%" % (100*_got_it["pap"])
        else:
            return 1
            # xTools.say_it(self.data_dict)

    def create_data_b(self):
        p_route_logic = re.compile("""Delay\s+Ratio\s+:\s+
                                      ([\d\.]+)%
                                      \s+\(route\),\s+
                                      ([\d\.]+)%
                                      \s+\(logic\)
                                      """, re.X)
        p_path_delay = re.compile("\+\s+Data Path Delay\s+([\d\.]+)")
        # Destination Clock Arrival Time (CK00:F#1)     5.000
        # Source Clock Arrival Time (CK00:R#1)   0.000
        p_arrive_time = re.compile("Clock\s+Arrival\s+Time.+?:(\w+)")
        # p1_start = re.compile("Constraint\s+:.+get_(ports|nets)\s+([^\]]+)\]")
        p1_start = re.compile("^[\d\.]+\s+Setup path details for constraint:.+get_(ports|nets)\s+([^\]]+)\]")
        p2_start = re.compile("\++\s*Path\s+1\s+\++")

        start = _route_percent = _logic_percent = 0
        double_edge_list = list()
        for line in open(self.rpt_file):
            if not start:
                m = p1_start.search(line)
                if m:
                    this_clk = m.group(2)
                    if this_clk == self.data_dict["clkName"]:
                        start = 1
            else:
                m_arrive_time = p_arrive_time.search(line)

                if m_arrive_time:
                    double_edge_list.append(m_arrive_time.group(1))
                if start == 1:
                    if p2_start.search(line):
                        start = 2
                elif start == 2:
                    m_route_logic = p_route_logic.search(line)
                    if m_route_logic:
                        _route_percent, _logic_percent = m_route_logic.group(1), m_route_logic.group(2)
                        start = 3
                elif start == 3:
                    m_path_delay = p_path_delay.search(line)
                    if m_path_delay:
                        _rd = eval("%s * %s / 100" % (m_path_delay.group(1), _route_percent))
                        _cd = eval("%s * %s / 100" % (m_path_delay.group(1), _logic_percent))
                        self.data_dict["route_delay"] = xTools.get_simple_digit_str(_rd)
                        self.data_dict["cell_delay"] = xTools.get_simple_digit_str(_cd)
                        break
        double_edge_set = set(double_edge_list)
        lens = len(double_edge_set)
        if lens == 1:
            self.data_dict["doubleEdge"] = "No"
        elif lens == 2:
            self.data_dict["doubleEdge"] = "Yes"
        else:
            self.data_dict["doubleEdge"] = "Unknown"


def get_new(raw_list):
    new_list = list()
    for foo in raw_list:
        for bar in foo:
            if "," in bar:
                bar = '"%s"' % bar
            new_list.append(bar)
    return new_list


class ScanRadiant:
    def __init__(self):
        pass

    def has_sweeping_results(self):
        for item in os.listdir(self.tag_path):
            if item.startswith("Target_"):
                return 1

    def process(self, arg_list=None):
        self.get_options(arg_list)
        for design in self.designs:
            self.design = design
            self.tag_path = os.path.join(self.top_dir, self.design, self.tag)
            if xTools.not_exists(self.tag_path, "Tag Path"):
                continue
            self._process()

    def _process(self):
        self.p1 = ScanLdfFile()
        self.p2 = ScanMrpFile()
        self.p3 = ScanParFile()
        self.p4 = ScanSynthesisLog()
        self.p5 = ScanSrrFile()
        self.p6 = ScanRunPBLog()
        self.p7 = ScanTwrFile(self.pap)

        scan_methods = [self.p1, self.p2, self.p3, self.p4, self.p5, self.p6, self.p7]
        title = [method.get_title() for method in scan_methods]

        if self.has_sweeping_results():
            self.run_scan_sweeping_results()
        else:
            self.run_scan_file()
        data = [method.get_data() for method in scan_methods]
        self.t_cpu = self.t_real = "NA"
        cpu_time_list = list()
        real_time_list = list()

        for i, foo in enumerate(title):
            for j, bar in enumerate(foo):
                if not bar.endswith("Time"):
                    continue
                my_time = data[i][j]
                if my_time == "NA":
                    continue
                my_time = float(my_time)
                if bar in ("Placer_cpu_Time", "Router_cpu_Time"):  # skip them
                    continue
                elif bar.endswith("cpu_Time"):
                    cpu_time_list.append(my_time)
                    if bar == "lse_cpu_Time":
                        real_time_list.append(my_time)
                elif bar.endswith("real_Time"):
                    real_time_list.append(my_time)
        self.t_cpu = xTools.get_simple_digit_str(sum(cpu_time_list))
        self.t_real = xTools.get_simple_digit_str(sum(real_time_list))
        report_file = os.path.join(self.rpt_dir, self.rpt_file)
        # -----------------------------------------
        final_titles = ["Design",
                        "version",
                        "device",
                        "HDL_type",
                        "synthesis",
                        "Register", "Register_per",
                        "Slice",
                        "Slice_per", "LUT",
                        "LUT_per",
                        "IO", "IO_per",
                        "EBR",
                        "DSP",
                        "DSP_PREADD9",
                        "DSP_MULT9",
                        "DSP_MULT18",
                        "DSP_M18X36",
                        "DSP_MULT36",
                        "DSP_ACC54",
                        "DSP_REG18",
                        "CARRY",
                        "DistributedRAM",
                        "CCU",
                        "clkNumber",
                        "maxLoads",
                        "totalLoads",
                        "scoreSetup",
                        "scoreHold",
                        "targetFmax",
                        "fmax",
                        "pap",
                        "CombineLoop",
                        "clkName",
                        "route_delay",
                        "cell_delay",
                        "logic_level",
                        "doubleEdge",
                        "lse_peak_Memory",
                        "lse_cpu_Time",
                        "lse_reg",
                        "lse_carry",
                        "lse_io",
                        "lse_lut4",
                        "lse_ebr",
                        "lse_dsp",
                        "lse_odd",
                        "lse_even",
                        "synp_cpu_Time",
                        "synp_real_Time",
                        "synp_peak_Memory",
                        "postsyn_cpu_Time",
                        "postsyn_real_Time",
                        "postsyn_peak_Memory",
                        "map_cpu_Time",
                        "map_real_Time",
                        "map_peak_Memory",
                        "Placer_cpu_Time", "Router_cpu_Time", "par_cpu_Time", "par_real_Time",
                        "par_signals",
                        "par_connections",
                        "par_congestion_level", "par_congestion_area", "par_congestion_area_per",
                        "ParPeakMem",
                        "Total_cpu_time",
                        "Total_real_time",
                        "constraint_coverage", "total_neg_slack_setup", "total_neg_slack_hold",
                        "mapComments", "parComments",
                        "Last_step", ]

        if not os.path.isfile(report_file):
            xTools.write_file(report_file, ",".join(final_titles))
        new_title = get_new(title)
        new_data = get_new(data)
        new_data_dict = dict(list(zip(new_title, new_data)))
        new_data_dict["Design"] = self.design
        new_data_dict["Total_cpu_time"] = self.t_cpu
        new_data_dict["Total_real_time"] = self.t_real
        new_data_dict["Last_step"] = self.last_step
        xTools.append_file(report_file, ",".join(new_data_dict.get(key, "NA") for key in final_titles))
        #
        print("===TMP Detail===")
        replace_p = re.compile("[^<]/")
        for key in final_titles:
            if key == "Design":
                continue
            print("\t<%s>%s</%s>" % (key, new_data_dict.get(key, "NA"), key))
        print()
        print("===TMP end===")

    def get_options(self, arg_list=list()):
        parser = optparse.OptionParser()
        parser.add_option("--top-dir", default=os.getcwd(), help="specify top results path")
        parser.add_option("--design", help="specify design name")
        parser.add_option("--tag", default="_scratch", help="specify _scratch name")
        parser.add_option("--rpt-dir", help="specify report file path")
        parser.add_option("--rpt-file", help="specify report file name")
        parser.add_option("--pap", action="store_true", help="get pap data")
        if not arg_list:
            arg_list = sys.argv[1:]
        opts, args = parser.parse_args(arg_list)
        self.top_dir = opts.top_dir
        self.design = opts.design
        self.tag = opts.tag
        self.rpt_dir = opts.rpt_dir
        self.rpt_file = opts.rpt_file
        if not self.rpt_file:
            self.rpt_file = os.path.basename(self.top_dir) + "_old.csv"
        self.pap = opts.pap

        if xTools.not_exists(self.top_dir, "Top results path"):
            return 1
        self.top_dir = os.path.abspath(self.top_dir)
        #
        self.designs = list()
        if self.design:
            self.designs.append(self.design)
        else:
            fds = os.listdir(self.top_dir)
            fds.sort(key=str.lower)
            for foo in fds:
                if foo == ".svn":
                    continue
                abs_foo = os.path.join(self.top_dir, foo)
                if os.path.isdir(abs_foo):
                    self.designs.append(foo)
        if not self.rpt_dir:
            self.rpt_dir = os.getcwd()
        else:
            if xTools.wrap_md(self.rpt_dir, "Report Path"):
                return 1
            self.rpt_dir = os.path.abspath(self.rpt_dir)

    def run_scan_sweeping_results(self):
        self.last_step = ""
        ldf_files = glob.glob(os.path.join(self.tag_path, "*.rdf"))
        if not ldf_files:
            self.last_step = "No Ldf Created!"
            return
        self.p1.scan_file(ldf_files[0])
        ldf_dict = readXML.parse_ldf_file(ldf_file=ldf_files[0], for_radiant=1)
        _prj_name = ldf_dict.get("bali", dict()).get("title")
        _impl_name = ldf_dict.get("impl", dict()).get("dir")
        dst_fname = "%s_%s" % (_prj_name, _impl_name)
        if (not _prj_name) or (not _impl_name):
            self.last_step = "Failed to Parse ldf file"
            return
        fds = os.listdir(self.tag_path)
        fds.sort()
        max_fmax = 0
        max_fmax_folder = ""
        for foo in fds:
            if foo.startswith("Target_"):
                twr_file = os.path.join(self.tag_path, foo, _impl_name, dst_fname+".twr")
                if os.path.isfile(twr_file):
                    self.p7.scan_file(twr_file)
                    dd = dict(list(zip(self.p7.get_title(), self.p7.get_data())))
                    cur_fmax = dd.get("fmax", "-1")
                    try:
                        f_cur_fmax = float(cur_fmax)
                    except ValueError:
                        f_cur_fmax = -1
                    if f_cur_fmax > max_fmax:
                        max_fmax = f_cur_fmax
                        max_fmax_folder = foo
        if not max_fmax_folder:
            return
        mrp_file = os.path.join(self.tag_path, max_fmax_folder, _impl_name, dst_fname+".mrp")
        par_file = os.path.join(self.tag_path, max_fmax_folder, _impl_name, dst_fname+".par")
        synthesis_log = os.path.join(self.tag_path, _impl_name, "synthesis.log")
        srr_file = os.path.join(self.tag_path, _impl_name, dst_fname+".srr")
        run_pb_log = os.path.join(self.tag_path, "run_till_map.log")
        twr_file = os.path.join(self.tag_path, max_fmax_folder, _impl_name, dst_fname+".twr")
        self.p2.scan_file(mrp_file)
        self.p3.scan_file(par_file)
        self.p4.scan_file(synthesis_log)
        self.p5.scan_file(srr_file)
        self.p6.scan_file(run_pb_log)
        self.p7.scan_file(twr_file)

    def run_scan_file(self):
        self.last_step = ""
        ldf_files = glob.glob(os.path.join(self.tag_path, "*.rdf"))
        if not ldf_files:
            self.last_step = "No Ldf Created!"
            return
        self.p1.scan_file(ldf_files[0])
        ldf_dict = readXML.parse_ldf_file(ldf_file=ldf_files[0], for_radiant=1)
        # - bali                : {'device': 'ITPA08-6CM225C', 'default_implementation': 'impl1', 'version': '3.2', 'title': 'top'}
        # - impl                : {'default_strategy': 'Strategy1', 'synthesis': 'lse', 'description': 'impl1', 'dir': 'impl1', 'title': 'impl1'}
        # - source              : [{'type': 'Verilog', 'name': '../source/dig_convert_g4board_f.v', 'type_short': 'Verilog'},
        # {'type': 'Verilog', 'name': '..//source/module_top.v', 'type_short': 'Verilog'}]
        _prj_name = ldf_dict.get("bali", dict()).get("title")
        _impl_name = ldf_dict.get("impl", dict()).get("dir")
        if (not _prj_name) or (not _impl_name):
            self.last_step = "Failed to Parse ldf file"
            return
        fname = os.path.join(self.tag_path, _impl_name, "%s_%s" % (_prj_name, _impl_name))
        mrp_file = fname + ".mrp"
        mrp_file2 = "{}_map.mrp".format(fname)
        # ng1_2.323, rename as jedi_project_impl_1_map.mrp
        # find par file in .dir
        # par_file = fname + ".par"
        par_files = glob.glob(os.path.join(self.tag_path, _impl_name, "*.dir", "*.par"))
        if par_files:
            par_file = par_files[0]
        else:
            par_file = "NoParFile"
        synthesis_log = os.path.join(self.tag_path, _impl_name, "synthesis.log")
        srr_file = fname + ".srr"
        run_pb_log = os.path.join(self.tag_path, "run_pb.log")
        if not os.path.isfile(run_pb_log):
            run_pb_log = os.path.join(self.tag_path, "run_till_map.log")
        twr_file = fname + ".twr"
        if xTools.not_exists(srr_file, "Srr file") and xTools.not_exists(synthesis_log, "lse log"):
            self.last_step = "No synthesis log file"
        else:
            if os.path.isfile(srr_file):
                if xTools.simple_parser(srr_file, [re.compile("Mapper successful!"), ], but_lines=20):
                    self.last_step = ""
                else:
                    self.last_step = "Synthesis Failed"
            elif os.path.isfile(synthesis_log):
                self.last_step = ""

        if not self.last_step:
            if not os.path.isfile(mrp_file):
                mrp_file = mrp_file2
            if xTools.not_exists(mrp_file, "mrp file"):
                self.last_step = "No Mrp File"
            else:
                _t = xTools.simple_parser(mrp_file, [re.compile("Number of errors:\s+(\d+)"), ])
                if _t:
                    number_is = _t[1].group(1)
                    if number_is == '0':
                        self.last_step = ''
                    else:
                        self.last_step = 'Mrp failed'

        if not self.last_step:
            if xTools.not_exists(par_file, "par file"):
                self.last_step = "No par file"
            else:
                if xTools.simple_parser(par_file, [re.compile("All signals are completely routed")], 50):
                    self.last_step = ""
                else:
                    self.last_step = "par failed"

        if not self.last_step:
            if xTools.not_exists(twr_file, "twr_file"):
                self.last_step = "No twr file"
            else:
                pass

        if not self.last_step:
            self.last_step = "par done!"

        self.p2.scan_file(mrp_file)
        self.p3.scan_file(par_file)
        self.p4.scan_file(synthesis_log)
        self.p5.scan_file(srr_file)
        self.p6.scan_file(run_pb_log)
        self.p7.scan_file(twr_file)


if __name__ == "__main__":
    t = ScanRadiant()
    t.process()
