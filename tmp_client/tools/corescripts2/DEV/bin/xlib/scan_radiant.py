import re
import copy
import os
import glob
import sys
import optparse

from collections import OrderedDict

import xTools
import readXML


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
                    happy_results.append(dict(zip(_keys, _values)))
                    t_line = list()
    if clk_number != -1:
        assert clk_number == len(happy_results), "Failed to match all clocks in %s" % mrp_file
    return happy_results

def get_pre_slack_level_actual_from_twr(twr_file):
    """
    Radiant!
    empty line after 'SETUP SUMMARY REPORT' is stop tag.
    """
    start = 0
    title = list()
    _t = list()
    _dict_list = list()
    for line in open(twr_file):
        line = line.strip()
        if not start:
            if line == "SETUP SUMMARY REPORT":
                start = 1
            continue
        if not line:
            break # stop here

        line_list = re.split("\s*\|\s*", line)
        if line.startswith("Preference"):
            title = line_list
            continue
        if title:
            if len(line_list) < 3: # -----, separate signs
                continue
            if line_list.count("") > 4:
                if line_list[0]: # has value
                    _t += [line_list[0]] # create_clock -name {CLK_c} -period 10 [ | | | | | |
            else:
                _t += line_list
                new_t = list()
                idx = -len(title) + 1
                idx_2 = len(_t) + idx
                new_t.append("".join(_t[:idx_2]))
                new_t += _t[idx:]
                _dict_list.append(dict(zip(title, new_t)))
                _t = list()
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
        self.title = self.patterns.keys()

    def scan_file(self, rpt_file):
        self._initialize_data()
        self.data_dict = dict()
        if xTools.not_exists(rpt_file, "Report/Log file"):
            return 1
        self.rpt_file = rpt_file
        self.get_hot_lines() # should be rewrite on your demand
        if not self.hot_lines:
            self.hot_lines = open(rpt_file)
        self.parse_hot_lines()
        self.more_steps()
        self.get_real_data()

    def get_real_data(self):
        self.data = list()
        p_is_time = re.compile("_time$", re.I)
        for key in self.patterns.keys():
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
                break # search all items already
            for key, pattern in local_patterns.items():
                if not pattern: # define in more steps
                    local_patterns.pop(key)
                    continue
                m = pattern.search(line)
                if m:
                    local_patterns.pop(key)
                    self.data_dict[key] = m.group(1)
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
        self.patterns["Register"] = re.compile("Number of slice registers:\s+(\d+)")
        self.patterns["LUT"] = re.compile("Number of LUT4s:\s+(\d+)")
        self.patterns["IO"] = re.compile("Number of PIO sites used:\s+(\d+)")
        self.patterns["EBR"] = re.compile("Number of EBRs:\s+(\d+)")
        self.patterns["DSP"] = re.compile("Number of DSPs:\s+(\d+)")
        self.patterns["DistributedRAM"] = ""
        self.patterns["CCU"] = ""

        self.patterns["clkNumber"] = re.compile("Number of clocks:\s+(\d+)")
        self.patterns["maxLoads"] = ""
        self.patterns["totalLoads"] = ""
        self.patterns["map_cpu_Time"] = re.compile("Total CPU Time:\s+(.+)")
        self.patterns["map_real_Time"] = re.compile("Total REAL Time:\s+(.+)")
        self.patterns["map_peak_Memory"] = re.compile("Peak Memory Usage:\s+(\d+)")

        self.p_start = self.patterns["clkNumber"]
        self.p_stop = re.compile("Number of")
        self.p_loads = re.compile(":\s+(\d+)\s+loads,\s+\d+\s+rising")

    def more_steps(self):
        clk_loads_net = get_clk_loads_net_from_mrp(self.rpt_file)
        loads = [int(item.get("loads")) for item in clk_loads_net]
        self.data_dict["maxLoads"] = str(max(loads))
        self.data_dict["totalLoads"] = str(sum(loads))

class ScanRunPBLog(ScanBasic):
    """
    Scan run_pb.log file
    """
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns = OrderedDict()
        self.patterns["version"] = re.compile("\s+version\s+(Diamond.+)")
        self.patterns["postsyn_cpu_Time"] = re.compile("Total CPU Time:\s+(.+)")
        self.patterns["postsyn_real_Time"] = re.compile("Total REAL Time:\s+(.+)")
        self.patterns["postsyn_peak_Memory"] = re.compile("Peak Memory Usage:\s+(\d+)")

        self.p_start = re.compile("Command Line: postsyn")
        self.p_stop = self.patterns["version"]

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

class ScanLdfFile(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns["device"] = re.compile('\s+device="([^"]+)"\s+')
        self.patterns["synthesis"] = re.compile('\s+synthesis="([^"]+)"\s+')

class ScanParFile(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        self.patterns["Slice"] = re.compile('^\s+SLICE\s+(\d+)/\d+\s+\S+\s+used') # SLICE  134/2640   5% used
        self.patterns["par_cpu_Time"] = re.compile("Total CPU  time to completion:\s+(.+)")
        self.patterns["par_real_Time"] = re.compile("Total REAL time to completion:\s+(.+)")
        self.patterns["par_peak_Memory"] = re.compile("after PAR current memory .+peak memory ([\d\.]+)")
        # PAR_SUMMARY::Timing score<setup/<ns>> = 10673.908
        # PAR_SUMMARY::Timing score<hold /<ns>> = 0.000
        self.patterns["scoreSetup"] = re.compile("PAR_SUMMARY::Timing score<setup/<ns>> =\s+([\d\.]+)")
        self.patterns["scoreHold"] =  re.compile("PAR_SUMMARY::Timing score<hold /<ns>> =\s+([\d\.]+)")

    def more_steps(self):
        # for scoreSetup/scoreHold value
        def _multi_1000(key):
            value = self.data_dict.get(key)
            if value:
                new_value = float(value) * 1000
                self.data_dict[key] = xTools.get_simple_digit_str(new_value)
        _multi_1000("scoreSetup")
        _multi_1000("scoreHold")

class ScanSynthesisLog(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)

    def create_patterns(self):
        # Peak Memory Usage: 180.957  MB
        # Elapsed CPU time for LSE flow : 6.037  secs
        self.patterns["lse_peak_Memory"] = re.compile("Peak Memory Usage:\s+([\d\.]+)")
        self.patterns["lse_cpu_Time"] = re.compile("CPU time for LSE flow :\s+([\d\.]+)\s+secs")

    def get_hot_lines(self):
        line_cnt = xTools.get_file_line_count(self.rpt_file)
        # only scan the last 50 lines
        start_line_num = line_cnt - 50
        for count, line in enumerate(open(self.rpt_file, "rU")):
            if count < start_line_num:
                continue
            self.hot_lines.append(line)

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
        p_time = re.compile("At (Mapper|c_hdl|syn_nfilter) Exit \(Real Time elapsed (\S+); CPU Time elapsed (\S+)")
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
            foo_tuple = item[0] # from re findall
            if foo_tuple[1] == "successful!":
                continue
            foo_key = foo_tuple[0]
            new_time = [float(xTools.time2secs(item)) for item in foo_tuple[1:]]
            if foo_key in ("syn_nfilter", "c_hdl"):
                _t[foo_key] = new_time
            elif foo_key in ("Mapper", ):
                # check the previous settings
                previous_item_tag = raw_time_list[i-1][0][0]
                if previous_item_tag in ("Pre-mapping", "Mapper"):
                    _t[previous_item_tag] = new_time
        real_time, cpu_time = 0, 0
        for key, value in _t.items():
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
    Preference = one_dict.get("Preference")
    Levels = one_dict.get("Levels")
    Constraint = one_dict.get("Constraint")
    Slack = one_dict.get("Slack")

    for k in (Constraint, Slack):
        if not re.search("ns", k): # must have ns
            return

    t = dict()
    p_clk_name = re.compile("get_(ports|nets)\s+([^\]]+)\]")
    m_clk_name = p_clk_name.search(Preference)
    if m_clk_name:
        clk_name = re.sub(" ", "", m_clk_name.group(2))
        t["clkName"] = clk_name
    else:
        xTools.say_it("Error. Not found clk name from: %s" % Preference)
        return

    _cons = float(re.sub("ns", "", Constraint))
    _slack = float(re.sub("ns", "", Slack))

    t["targetFmax"] = 1000/_cons
    t["fmax"] = 1000/ (_cons - _slack)
    t["logic_level"] = Levels

    return t

class ScanTwrFile(RootBasic):
    def __init__(self):
        RootBasic.__init__(self)
        self.title = ["targetFmax", "fmax", "clkName", "route_delay", "cell_delay", "logic_level"]
        self._initialize_data()

    def scan_file(self, twr_file):
        self._initialize_data()
        if xTools.not_exists(twr_file, "Twr File"):
            return 1
        self.rpt_file = twr_file
        self.raw_list = get_pre_slack_level_actual_from_twr(self.rpt_file)
        self.data_dict = dict()
        self.create_data_a()
        self.create_data_b()
        self.data = [self.data_dict.get(key, "NA") for key in self.title]

    def create_data_a(self):
        tfl = list()
        for item in self.raw_list:
            new_item = _parse_fmax(item)
            if new_item:
                tfl.append(new_item)

        if tfl:
            _fmax = [foo.get("fmax") for foo in tfl]
            real_fmax = min(_fmax)
            real_idx = _fmax.index(real_fmax)
            _got_it = tfl[real_idx]

            self.data_dict["fmax"] = xTools.get_simple_digit_str(real_fmax)
            self.data_dict["targetFmax"] = xTools.get_simple_digit_str(_got_it.get("targetFmax"))
            self.data_dict["clkName"] = _got_it["clkName"]
            self.data_dict["logic_level"] = _got_it["logic_level"]

    def create_data_b(self):
        p_route_logic = re.compile("""Delay\s+Ratio\s+:\s+
                                      ([\d\.]+)%
                                      \s+\(route\),\s+
                                      ([\d\.]+)%
                                      \s+\(logic\)
                                      """, re.X)
        p_path_delay = re.compile("\+\s+Data Path Delay\s+([\d\.]+)")
        p1_start = re.compile("Constraint\s+:.+get_(ports|nets)\s+([^\]]+)\]")
        p2_start = re.compile("\++\s+Path\s+1\s+\++")

        start = _route_percent = _logic_percent = 0
        for line in open(self.rpt_file):
            if not start:
                m = p1_start.search(line)
                if m:
                    this_clk = m.group(2)
                    if this_clk == self.data_dict["clkName"]:
                        start = 1
            elif start == 1:
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
                    _rd = eval( "%s * %s / 100" % (m_path_delay.group(1), _route_percent) )
                    _cd = eval( "%s * %s / 100" % (m_path_delay.group(1), _logic_percent) )
                    self.data_dict["route_delay"] = xTools.get_simple_digit_str(_rd)
                    self.data_dict["cell_delay"] = xTools.get_simple_digit_str(_cd)
                    break

def list2str(a_list):
    return ",".join([",".join(item) for item in a_list])

class ScanRadiant:
    def __init__(self):
        pass

    def process(self, arg_list=list()):
        self.get_options(arg_list)

        self.p1 = ScanLdfFile()
        self.p2 = ScanMrpFile()
        self.p3 = ScanParFile()
        self.p4 = ScanSynthesisLog()
        self.p5 = ScanSrrFile()
        self.p6 = ScanRunPBLog()
        self.p7 = ScanTwrFile()


        scan_methods = [self.p1, self.p2, self.p3, self.p4, self.p5, self.p6, self.p7]
        title = [method.get_title() for method in scan_methods]
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
                if bar.endswith("cpu_Time"):
                    cpu_time_list.append(my_time)
                    if bar == "lse_cpu_Time":
                        real_time_list.append(my_time)
                elif bar.endswith("real_Time"):
                    real_time_list.append(my_time)
        self.t_cpu = xTools.get_simple_digit_str(sum(cpu_time_list))
        self.t_real = xTools.get_simple_digit_str(sum(real_time_list))
        report_file = os.path.join(self.rpt_dir, "report.csv")
        if not os.path.isfile(report_file):
            xTools.write_file(report_file, "Design,%s,Total_cpu_Time,Total_real_Time,Last_step" % list2str(title))
        xTools.append_file(report_file, "%s,%s,%s,%s,%s" % (self.design, list2str(data), self.t_cpu, self.t_real, self.last_step))

    def get_options(self, arg_list=list()):
        parser = optparse.OptionParser()
        parser.add_option("--top-dir", help="specify top results path")
        parser.add_option("--design", help="specify design name")
        parser.add_option("--tag", default="_scratch", help="specify _scratch name")
        parser.add_option("--rpt-dir", help="specify report file path")
        if not arg_list:
            arg_list = sys.argv[1:]
        opts, args = parser.parse_args(arg_list)
        self.top_dir = opts.top_dir
        self.design = opts.design
        self.tag = opts.tag
        self.rpt_dir = opts.rpt_dir

        if xTools.not_exists(self.top_dir, "Top results path"):
            return 1
        self.top_dir = os.path.abspath(self.top_dir)
        if not self.design:
            xTools.say_it("Error. Need design name for scanning results")
            return 1
        self.tag_path = os.path.join(self.top_dir, self.design, self.tag)
        if xTools.not_exists(self.tag_path, "Tag Path"):
            return 1
        if not self.rpt_dir:
            self.rpt_dir = self.top_dir
        else:
            if xTools.wrap_md(self.rpt_dir, "Report Path"):
                return 1
            self.rpt_dir = os.path.abspath(self.rpt_dir)

    def run_scan_file(self):
        self.last_step = "Done"
        ldf_files = glob.glob(os.path.join(self.tag_path, "*.ldf"))
        if not ldf_files:
            self.last_step = "No Ldf Created!"
            return
        self.p1.scan_file(ldf_files[0])
        ldf_dict = readXML.parse_ldf_file(ldf_file=ldf_files[0])
        # - bali                : {'device': 'ITPA08-6CM225C', 'default_implementation': 'impl1', 'version': '3.2', 'title': 'top'}
        # - impl                : {'default_strategy': 'Strategy1', 'synthesis': 'lse', 'description': 'impl1', 'dir': 'impl1', 'title': 'impl1'}
        # - source              : [{'type': 'Verilog', 'name': '../source/dig_convert_g4board_f.v', 'type_short': 'Verilog'},
        #                          {'type': 'Verilog', 'name': '..//source/module_top.v', 'type_short': 'Verilog'}]
        _prj_name = ldf_dict.get("bali", dict()).get("title")
        _impl_name = ldf_dict.get("impl", dict()).get("dir")
        if (not _prj_name) or (not _impl_name):
            self.last_step = "Failed to Parse ldf file"
            return
        fname = os.path.join(self.tag_path, _impl_name, "%s_%s" % (_prj_name, _impl_name))
        mrp_file = fname + ".mrp"
        par_file = fname + ".par"
        synthesis_log = os.path.join(self.tag_path, _impl_name, "synthesis.log")
        srr_file = fname + ".srr"
        run_pb_log = os.path.join(self.tag_path, "run_pb.log")
        twr_file = fname + ".twr"
        if xTools.not_exists(srr_file, "Srr file") and xTools.not_exists(synthesis_log, "lse log"):
            self.last_step = "Synthesis Failed"
        if xTools.not_exists(mrp_file, "mrp file"):
            self.last_step = "map failed"
        if xTools.not_exists(par_file, "par file"):
            self.last_step = "par failed"
        if xTools.not_exists(twr_file, "twr_file"):
            self.last_step = "par failed"
        self.p2.scan_file(mrp_file)
        self.p3.scan_file(par_file)
        self.p4.scan_file(synthesis_log)
        self.p5.scan_file(srr_file)
        self.p6.scan_file(run_pb_log)
        self.p7.scan_file(twr_file)

if __name__ == "__main__":
    my_scan = ScanRadiant()
    my_scan.process()


    # ---------------------------------------------------
    print "done"



