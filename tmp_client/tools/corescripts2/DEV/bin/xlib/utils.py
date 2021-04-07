import os
import re
import time
import string
import xTools
import glob
import shlex
import shutil
from collections import OrderedDict

__author__ = 'syan'


vendor_settings_dict = {"Active":  ["onbreak {resume}", "onerror {quit}"],
                        "Modelsim":  ["onbreak {resume}", "onerror {quit -f}"],
                        "QuestaSim": ["onbreak {resume}", "onerror {quit -f}"],
                        "default":   ["onbreak {resume}", "onerror {quit -f}"],
                        "Riviera":   ["onbreak {resume}", "onerror {quit -force}"],
                        # -------------------------
                        }


def update_simulation_do_file(vendor_name, do_file, lst_precision, no_lst):
    """ add resume/quit operation to the simulation do file.
    if do file version is < 2.2, the resume/quit line will be added
    into the file before the first uncomment line.
    """
    # /////////////////// add onbreak lines
    # will insert the will_add_list into the first uncomment line
    found_resume = xTools.simple_parser(do_file, [re.compile("onbreak\s+\{\s*resume"), ])
    found_quit = xTools.simple_parser(do_file, [re.compile("onerror\s+\{\s*quit"), ])
    original_lines = xTools.get_original_lines(do_file, read_only=True)
    if found_resume and found_quit:
        t_lines = [item.rstrip() for item in original_lines]
    else:
        will_add_list = vendor_settings_dict.get(vendor_name)
        if not will_add_list:
            default_add_list = vendor_settings_dict.get("default")
            xTools.say_it("Warning. Not support simulation tool: %s" % vendor_name)
            xTools.say_it("         Use default settings: %s" % default_add_list)
            will_add_list = default_add_list
        added_already = 0
        t_lines = list()
        for line in original_lines:
            line = line.rstrip()
            t_line = line.strip()
            if not t_line:
                t_lines.append(line)
            elif added_already:
                t_lines.append(line)
            else:
                if t_line.startswith("#"):
                    t_lines.append(line)
                else:
                    for item in will_add_list:
                        t_lines.append(item)
                    t_lines.append(line)
                    added_already = 1

    # //////////////////// generate lst file by force
    p_lst = [re.compile("^asdb2lst.+\.lst"),
             re.compile("^write list"),
             ]
    will_generate_lst = 0
    for item in t_lines:
        item = item.strip()
        for p in p_lst:
            if p.search(item):
                will_generate_lst = 1
                break
        if will_generate_lst:
            break
    ff = float(lst_precision)
    ii = int(ff)
    if ii == ff:
        in_blank_ps = "%d ps" % (ff * 10000)
        in_blank_ns = "%d ns" % ff
        in_ns = "%dns" % int(ff)
    else:
        in_blank_ps = "%d ps" % (ff * 10000)
        in_blank_ns = "%d ps" % (ff * 1000)
        in_ns = "%dps" % (ff * 1000)
    if will_generate_lst:  # change the lst_precision
        p1 = re.compile("configure list -strobestart")
        p2 = re.compile("asdb2.+(-time\s+\S+)")
        for i, item in enumerate(t_lines):
            if p1.search(item):
                t_lines[i] = "    configure list -strobestart {%s} -strobeperiod {%s}" % (in_blank_ps, in_blank_ns)
            else:
                m2 = p2.search(item)
                if m2:
                    _item = re.sub("\s+-time\s+\S+", " -time %s" % in_ns, item)
                    t_lines[i] = _item
    else:
        # replace 'add wave *' and 'run *ms'
        if vendor_name == "Modelsim":
            dd = t_lines[:]
            t_lines = list()
            p_add_wave = re.compile("^\s*add\s+wave", re.I)
            p_run_time = re.compile("^\s*run\s+\d\w+", re.I)
            for item in dd:
                if p_add_wave.search(item):
                    continue
                elif p_run_time.search(item):
                    t_lines.append("    add list -nodelta -hex -notrigger *")
                    t_lines.append("    configure list -usestrobe 1")
                    t_lines.append("    configure list -strobestart {%s} -strobeperiod {%s}" % (in_blank_ps, in_blank_ns))
                    t_lines.append(item)
                    if no_lst:
                        t_lines.append("    ## write list final_lst.lst")
                    else:
                        t_lines.append("    write list final_lst.lst")
                else:
                    t_lines.append(item)
    if vendor_name == "Modelsim":
        new_lines = combine_system_verilog_file_lines(t_lines)
        if new_lines:
            t_lines = new_lines[:]
    # //////////////////// Write the do file
    new_ob = open(do_file, "w")
    for item in t_lines:
        print >> new_ob, item
    new_ob.close()
    if vendor_name == "Active":
        xTools.write_file('library.cfg', ['$INCLUDE = "$ACTIVEHDLLIBRARYCFG"'])


def combine_system_verilog_file_lines(raw_lines):
    new_lines = list()
    sv_lines = list()
    p_sv_line = re.compile("^vlog.+\.sv", re.I)
    more_args = {"+define+SV_IO_UNFOLD": "", "-sv2k12": ""}
    final_index_number = 0
    for i, foo in enumerate(raw_lines):
        if p_sv_line.search(foo):
            new_lines.append("# SystemVerilog # {}".format(foo))
            sv_lines.append(foo)
            final_index_number = i
            for k, v in more_args.items():
                if v:
                    continue
                more_args[k] = k in foo
        else:
            new_lines.append(foo)

    if sv_lines:
        vlog_opt = "vlog -sv -mfcu -work work "
        for k, v in more_args.items():
            if v:
                vlog_opt += ' {} '.format(k)
        for i, bar in enumerate(sv_lines):
            try:
                bar_list = shlex.split(bar)
            except ValueError:
                print "Warning. Cannot shlex split line: {}".format(bar)
                return
            sv_file = bar_list[-1]
            start_tag = vlog_opt if not i else "   "
            if i == len(sv_lines) - 1:
                break_tag = ""
            else:
                break_tag = ' \\'
            new_lines.insert(final_index_number+i+1, '{} "{}" {}'.format(start_tag, sv_file, break_tag))
    return new_lines


def get_module_file(ipx_file):
    """
    Get real module file from ipx file for Radiant case
    :param ipx_file:
    :return:
    """
    p_format = re.compile('source_format="VHDL"', re.I)
    is_vhdl, _t = 0, dict()
    p_name_type = re.compile('File.+name="(.+?)"\s+type="top_level_(.+?)"', re.I)
    try:
        ipx_ob = open(ipx_file)
    except:
        xTools.say_it("Warning. Not found ipx file: %s" % ipx_file)
        return
    for line in ipx_ob:
        if not is_vhdl:
            is_vhdl = p_format.search(line)
        m_name_type = p_name_type.search(line)
        if m_name_type:
            _name, _type = m_name_type.group(1), m_name_type.group(2)
            _t[_type] = _name

    real_name = _t.get("vhdl", "xxxx.vhd") if is_vhdl else _t.get("verilog", "xxxx.v")
    return xTools.get_relative_path(real_name, xTools.get_file_dir(ipx_file))


def get_module_file_from_sbx(sbx_file):
    p1 = re.compile("<spirit:file>")
    p2 = re.compile("<spirit:name>(.+)</spirit:name>")
    start = 0
    for line in open(sbx_file):
        if not start:
            start = p1.search(line)
        else:
            m2 = p2.search(line)
            if m2:
                return xTools.get_relative_path(m2.group(1), os.path.dirname(sbx_file), os.getcwd())


def disable_sdc_ldc_file(project_dict):
    source_list = project_dict.get("source", list())
    flow_settings = list()
    for item in source_list:
        short_type_name = item.get("type_short")
        if short_type_name in ("LDC", "SDC", "PDC"):
            flow_settings.append('prj_disable_source "%s"' % item.get("name", "NoFileName"))
    return flow_settings


def _create_group(clk_list):
    new_list = ['-group [get_clocks {%s}]' % item for item in clk_list]
    new_string = " ".join(new_list)
    return "set_clock_groups %s -physically_exclusive" % new_string


def write_pdc_file(pdc_file, clk_data):
    clk_list = [foo.get("clkName") for foo in clk_data]
    lines = ["create_clock -name {%s} -period 100 [get_nets {%s}]" % (bar, bar) for bar in clk_list]
    if clk_list:
        lines.append(_create_group(clk_list))
    xTools.append_file(pdc_file, lines, append=False)


def update_pdc_file(pdc_file, fmax):
    pdc_lines = list()
    _period = "%.3f" % (1000.0/fmax)
    pdc_lines.append("#----  Target Frequency: %d MHz (%s ns)" % (fmax, _period))
    with open(pdc_file) as pdc_ob:
        for line in pdc_ob:
            if line.startswith("#---- "):
                continue
            new_line = re.sub("\s-period\s+\S+\s", " -period %s " % _period, line)
            pdc_lines.append(new_line)
    with open(pdc_file, 'w') as pdc_w:
        for foo in pdc_lines:
            print >> pdc_w, foo.rstrip()


def _remove_braces(raw_string):
    raw_string = raw_string.strip('{')
    raw_string = raw_string.strip('}')
    return raw_string


def write_ldc_fdc_file(ldc_fdc_file, clocks, general_frequency=50):
    clocks = map(_remove_braces, clocks)
    with open(ldc_fdc_file, 'w') as new:
        print >> new, "# General frequency %.3f MHz" % general_frequency
        _period = "%.3f" % (1000.0/general_frequency)
        for clk in clocks:
            print >> new, "create_clock -name {%s} -period %s [get_ports {%s}]" % (clk, _period, clk)
        if len(clocks) > 1:
            print >> new, _create_group(clocks)


def rewrite_ldc_fdc_file(ldc_fdc_file, clock_frequency, inc_per):
    with open(ldc_fdc_file, 'w') as new:
        print >> new, "# Update @ %s" % time.ctime()
        contents = list()
        for clk in clock_frequency:
            one = clk.get("SDCConstraint")
            two = clk.get("Frequency")
            new_two = get_new_constraint(two, inc_per)
            if new_two:
                print >> new, "# %s" % ", ".join(one + [two])
                contents.append(one + [new_two[-1]])
        for item in contents:
            print >> new, "create_clock -name {%s} -period %s [%s {%s}]" % (item[1], item[-1], item[0], item[1])
        if len(contents) > 1:
            t = [item[1] for item in contents]
            print >> new, _create_group(t)


def rewrite_lpf_file(lpf_file, clock_frequency, inc_per):
    with open(lpf_file, 'w') as new:
        print >> new, "# Update @ %s" % time.ctime()
        print >> new, "BLOCK RESETPATHS ;"
        print >> new, "BLOCK ASYNCPATHS ;"
        print >> new, "BLOCK INTERCLOCKDOMAIN PATHS ;"
        for clk in clock_frequency:
            one = clk.get("Preference")
            two = clk.get("Actual")
            new_two = get_new_constraint(two, inc_per)
            if new_two:
                print >> new, 'FREQUENCY %s "%s" %s MHz ;' % (one[0], one[1], new_two[0])


def get_constraint_file(ldf_rdf_dict):
    _ts = "type_short"
    _ex = 'excluded'
    short_names = ["LDC", "PDC", "SDC", "FDC", "LPF", "PRF"]
    c_files = list()

    for src in ldf_rdf_dict.get("source", list()):
        ts = src.get(_ts)
        ex = src.get(_ex)
        if ex == "TRUE":
            continue
        if ts in short_names:
            c_files.append([ts, src.get("name")])
    return c_files


def get_net_clk_names(mrp_file, is_ng_flow):
    p1 = re.compile("Number\s+of\s+clocks:\s+(\d+)", re.I)
    p2 = re.compile("Number\s+of\s+")
    skip_pats = (
        re.compile("^$"),
        re.compile("page\s+\d+", re.I),
        re.compile("Date:\s+\d+", re.I),
        re.compile("Design Summary", re.I),
        re.compile("^-+$"),
    )
    if is_ng_flow:
        p_net = re.compile("Driver:\s+Port\s+([^\)]+)\)")
    else:
        p_net = re.compile("Driver:\s+PIO\s+([^\)]+)\)")

    hot_lines = list()
    clk_num = 0
    for line in open(mrp_file):
        line = line.rstrip()
        if not clk_num:
            m = p1.search(line)
            if m:
                clk_num = int(m.group(1))
            continue
        if p2.search(line):
            break
        for sp in skip_pats:
            if sp.search(line):
                break
        else:
            hot_lines.append(line)
    long_lines = " ".join(hot_lines)
    nets = p_net.findall(long_lines)
    # assert clk_num == len(nets), "Not find all clocks in %s (%d != %d)" % (mrp_file, clk_num, len(nets))
    f = lambda x: x.replace(" ", "")
    return map(f, nets)


"""
3.2.1  Setup Constraint Slack Summary
--------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
                                        |             |             |        |   Actual (flop to flop)   |                |
             SDC Constraint             |   Target    |    Slack    | Levels |   Period    |  Frequency  |  Items Scored  |  Timing Error
-------------------------------------------------------------------------------------------------------------------------------------------
                                        |             |             |        |             |             |                |
create_clock -name {CPUHWR_N} -period 4
.167 -waveform {0.000 2.083} [get_ports
 CPUHWR_N]                              |    4.167 ns |    3.262 ns |    2   |    0.905 ns |1104.972 MHz |        2       |        0
                                        |             |             |        |             |             |                |
create_clock -name {CISCLK2} -period 4.
167 -waveform {0.000 2.083} [get_ports
CISCLK2]                                |    4.167 ns |    0.575 ns |    5   |    3.592 ns | 278.396 MHz |       66       |        0
                                        |             |             |        |             |             |                |
create_clock -name {CISCLK1} -period 4.
167 -waveform {0.000 2.083} [get_ports
CISCLK1]                                |    4.167 ns |    0.727 ns |    5   |    3.440 ns | 290.698 MHz |       66       |        0
                                        |             |             |        |             |             |                |
create_clock -name {CISCLK3} -period 4.
167 -waveform {0.000 2.083} [get_ports
CISCLK3]                                |    4.167 ns |    0.557 ns |    5   |    3.610 ns | 277.008 MHz |       66       |        0
                                        |             |             |        |             |             |                |
create_clock -name {CPULWR_N} -period 4
.167 -waveform {0.000 2.083} [get_ports
 CPULWR_N]                              |    4.167 ns |    3.253 ns |    2   |    0.914 ns |1094.092 MHz |        2       |        0
                                        |             |             |        |             |             |                |
create_clock -name {SYSCLK} -period 7.7
52 -waveform {0.000 3.876} [get_ports S
YSCLK]                                  |    0.003 ns |   -0.097 ns |    2   |    7.610 ns | 131.406 MHz |      23965     |        1
                                        |             |             |        |             |             |                |
create_clock -name {CLK} -period 20 [ge
t_ports CLK]                            |   20.000 ns |   16.776 ns |    1   |    3.224 ns | 310.174 MHz |      1489      |        0
                                        |             |             |        |             |             |                |
create_clock -name {clk_core} -period 2
0 -waveform {0.000 10.000} [get_ports c
lk_core]                                |   20.000 ns |    9.749 ns |    5   |   10.251 ns |  97.551 MHz |      31971     |        0
-------------------------------------------------------------------------------------------------------------------------------------------

Report Summary
--------------
----------------------------------------------------------------------------
Preference                              |   Constraint|       Actual|Levels
----------------------------------------------------------------------------
                                        |             |             |
FREQUENCY PORT "clk125m" 240.000000 MHz |             |             |
;                                       |  240.000 MHz|  163.559 MHz|   9 *
                                        |             |             |
FREQUENCY PORT "clk50m" 240.000000 MHz  |             |             |
;                                       |  240.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
FREQUENCY PORT "clk77m" 240.000000 MHz  |             |             |
;                                       |  240.000 MHz|  124.347 MHz|   1 *
                                        |             |             |
FREQUENCY PORT "cpu_rd_b" 240.000000    |             |             |
MHz ;                                   |  240.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
FREQUENCY PORT "cpu_wr_b" 217.000000    |             |             |
MHz ;                                   |  217.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
FREQUENCY PORT "gmii_rx_clk_phy_0"      |             |             |
240.000000 MHz ;                        |  240.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
FREQUENCY PORT "gmii_rx_clk_phy_1"      |             |             |
240.000000 MHz ;                        |  240.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
FREQUENCY PORT "spi3_clk" 167.000000    |             |             |
MHz ;                                   |  167.000 MHz|  163.079 MHz|   7 *
                                        |             |             |
FREQUENCY PORT "ssmii_rx_clk_phy"       |             |             |
240.000000 MHz ;                        |  240.000 MHz|  200.000 MHz|   0 *
                                        |             |             |
----------------------------------------------------------------------------
"""


class GetClockFreq(object):
    def __init__(self, twr_file, is_ng_flow=True, debug=False):
        self.twr_file = twr_file
        self.is_ng_flow = is_ng_flow
        self.debug = debug

    def process(self):
        self.create_patterns()
        self.get_hot_lines()
        self.get_real_list()
        self.get_clock_freq()

    def create_patterns(self):
        if self.is_ng_flow:
            self.p_start = re.compile("Setup Constraint Slack Summary")
            self.first_title = "SDC Constraint"
            self.p_clk_name = re.compile(r"""\[
                                             (get_ports|get_nets)
                                             (.+)
                                             \]$""", re.X)
        else:
            self.p_start = re.compile("Report Summary")
            self.first_title = "Preference"
            self.p_clk_name = re.compile('FREQUENCY([^"]+)"([^"]+)"')
        self.p_following = re.compile("^-+$")

    def get_hot_lines(self):
        self.hot_lines = list()
        rpt = open(self.twr_file)
        started = False
        while True:
            line = rpt.readline()
            if not line:
                break
            if not started:
                m_start = self.p_start.search(line)
                if m_start:
                    line = rpt.readline()
                    line = line.strip()
                    if self.p_following.search(line):
                        started = True
            else:
                line = line.strip()
                if not line:
                    break
                if self.p_following.search(line):
                    continue
                t = re.split("\|", line)
                t = map(string.strip, t)
                self.hot_lines.append(t)

    def get_real_list(self):
        self.real_list = list()
        temp_line = list()
        for line in self.hot_lines:
            if not self.real_list:
                if line[0] == self.first_title:
                    self.real_list.append(line)
            else:
                if line.count("") == len(line):  # new line
                    if temp_line:
                        self.real_list.append(temp_line)
                        temp_line = list()
                else:
                    if not temp_line:
                        temp_line = line[:]
                    else:
                        t = list()
                        for i in range(len(line)):
                            try:
                                new_item = "%s%s" % (temp_line[i], line[i])
                            except IndexError:
                                new_item = line[i]
                            t.append(new_item)
                        temp_line = t[:]
        if temp_line:
            self.real_list.append(temp_line)
        self.real_list = [[foo.replace(" ", "") for foo in item] for item in self.real_list]
        xTools.say_it(self.real_list, "Clock Frequency List", self.debug)

    def get_clock_freq(self):
        titles = self.real_list[0]
        self.clock_freq = list()
        for item in self.real_list[1:]:
            raw_cons = item[0]
            m_clk_name = self.p_clk_name.search(raw_cons)
            if m_clk_name:
                item[0] = [m_clk_name.group(1), m_clk_name.group(2)]
                self.clock_freq.append(dict(zip(titles, item)))
        xTools.say_it(self.clock_freq, "Clock Frequency", self.debug)


def get_new_constraint(cur_frequency, increase_percentage):
    cur_frequency = re.sub("MHz", "", cur_frequency)
    try:
        cur_frequency_float = float(cur_frequency)
        cur_frequency_int = int(cur_frequency_float)
    except:  # no frequency number
        return
    new_frequency = 0
    if cur_frequency_float == cur_frequency_int:
        if divmod(cur_frequency_int, 100)[1] == 0:
            new_frequency = cur_frequency_int
    if not new_frequency:
        new_frequency = cur_frequency_float + cur_frequency_float * increase_percentage / 100.0
        if new_frequency > 400:
            new_frequency = 400
    new_frequency = int(new_frequency)
    return ["%d" % new_frequency, "%.3f" % (1000.0 / new_frequency)]


#
class GetPDCLines(object):
    def __init__(self, tws_tw1_file):
        self.tws_tw1_file = tws_tw1_file
        self.p1 = re.compile(r"\d\.\d\s+SDC Constraints")
        self.p2 = re.compile("^=+$")
        self.p_name = re.compile(r"-name\s+(\{[^\}]+\})\s+")
        self.tags_clock = ["create_clock", "create_generated_clock"]
        self.tag_group = "set_clock_groups"

    def get_lines(self):
        self.get_sdc_lines()
        self.get_clock_line_dict()
        self.sort_by_tag()
        clock_names = list()
        for k, v in self.sorted_dict.items():
            clock_names.append(" -group [get_clocks {}]".format(v[0]))
        clock_names_string = " ".join(clock_names)
        self.remove_repeated_lines()
        pdc_lines = list()
        for k, v in self.sorted_dict.items():
            pdc_lines.append(v[1])
        if pdc_lines:
            if len(clock_names) > 1:
                pdc_lines.append("set_clock_groups {} -logically_exclusive".format(clock_names_string))
        return pdc_lines

    def sort_by_tag(self):
        self.sorted_dict = OrderedDict()
        for t in self.tags_clock:
            for k, v in self.clock_line_dict.items():
                if v[1].startswith(t):
                    self.sorted_dict[k] = v

    def get_sdc_lines(self):
        self.sdc_lines = list()
        with open(self.tws_tw1_file) as ob:
            start = 0
            while True:
                line = ob.readline()
                if not line:
                    break
                line = line.strip()
                if not start:
                    if self.p1.search(line):
                        line = ob.readline()  # read a line at once
                        line = line.strip()
                        if self.p2.search(line):
                            start = 1
                else:
                    if not line:
                        break
                    self.sdc_lines.append(line)

    @staticmethod
    def simple_name(clock_name):
        clock_name = re.sub(r'\s', "", clock_name)
        clock_name = re.sub(r'\W', "", clock_name)
        return clock_name

    def get_clock_line_dict(self):
        self.clock_line_dict = OrderedDict()
        for foo in self.sdc_lines:
            m_name = self.p_name.search(foo)
            if m_name:
                self.clock_line_dict[self.simple_name(m_name.group(1))] = [m_name.group(1), foo]

    def remove_repeated_lines(self):
        run_options_txt_files = glob.glob("./*/run_options.txt")
        synproj_files = glob.glob("./*/*.synproj")
        if run_options_txt_files:
            prj_file = run_options_txt_files[0]
            p = re.compile(r'add_file\s+-\S+constraint\s+"([^"]+)"')
        elif synproj_files:
            prj_file = synproj_files[0]
            p = re.compile(r'-sdc\s+"([^"]+)"')
        else:
            return
        with open(prj_file) as ob:
            for line in ob:
                m = p.search(line)
                if m:
                    original_constraint_file = m.group(1)
                    break
            else:
                return
        # sometimes the flow will auto-gen ldc file (test_impl1_cpe.ldc) instead of using original ldc file in rdf file
        original_constraint_file = xTools.get_abs_path(original_constraint_file, os.path.dirname(prj_file))
        with open(original_constraint_file) as ob:
            for line in ob:
                m_name = self.p_name.search(line)
                if m_name:
                    simple_name = self.simple_name(m_name.group(1))
                    if simple_name in self.sorted_dict:
                        self.sorted_dict.pop(simple_name)


def create_default_strategy_file(is_ng_flow, sty_file):
    sty_lines = '<?xml version="1.0" encoding="UTF-8"?>\n' \
                '<!DOCTYPE strategy>\n' \
                '<Strategy version="1.0" predefined="0" description="default strategy" label="default">\n' \
                '</Strategy>'
    if is_ng_flow:  # for future updates
        x = sty_lines
    else:
        x = sty_lines
    xTools.write_file(sty_file, x)


def prepare_ipx_testbench_files(ipx_file, working_directory):
    """copy testbench directory to local simulation working directory
    """
    file_dict_list = list()
    with open(ipx_file) as ob:
        for line in ob:
            file_dict = dict()
            line = line.strip()
            line_list = shlex.split(line)
            if "<File" not in line_list:
                continue
            for foo in line_list[1:]:
                k_and_v = re.split("=", foo)
                file_dict[k_and_v[0]] = re.sub("/>", "", k_and_v[1])
            if file_dict:
                file_dict_list.append(file_dict)
    this_tb_file = ""
    for x in file_dict_list:
        _t_y_p_e = x.get("type")
        if "testbench_" not in _t_y_p_e:
            continue
        _n_a_m_e = x.get("name")
        if "tb_top.v" in _n_a_m_e:
            raw_tb_file = xTools.get_abs_path(_n_a_m_e, os.path.dirname(ipx_file))
            if os.path.exists(raw_tb_file):
                src_path = os.path.dirname(raw_tb_file)
                dst_path = os.path.join(working_directory, "testbench")
                if os.path.isdir(dst_path):
                    shutil.rmtree(dst_path)
                shutil.copytree(src_path, dst_path)
                dst_file = os.path.join(dst_path, os.path.basename(_n_a_m_e))
                this_tb_file = os.path.relpath(dst_file, working_directory)
                break
    return xTools.win2unix(this_tb_file, use_abs=0)


if __name__ == "__main__":
    t = GetClockFreq("x.twr", is_ng_flow=True, debug=True)
    t.process()
    print t.clock_freq
