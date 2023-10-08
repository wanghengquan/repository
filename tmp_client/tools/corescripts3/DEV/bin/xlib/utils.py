import os
import re
import sys
import time
import getpass
from . import xTools
import glob
import shlex
import shutil
from collections import OrderedDict
from .scanLib import utils as scan_utils
from .scanLib import xml2dict

__author__ = 'syan'


VHDL_FEXT_LIST = (".vho", ".vhd", ".vhdl", ".vhm", ".vhc")
vendor_settings_dict = {"Active":  ["onbreak {resume}", "onerror {quit}"],
                        "Modelsim":  ["onbreak {resume}", "onerror {quit -f}"],
                        "QuestaSim": ["onbreak {resume}", "onerror {quit -f}"],
                        "default":   ["onbreak {resume}", "onerror {quit -f}"],
                        "Riviera":   ["onbreak {resume}", "onerror {quit -force}"],
                        # -------------------------
                        }


def update_simulation_do_file(vendor_name, do_file, lst_precision, no_lst, todo_coverage, coverage_args, is_bit2sim):
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
        p11 = re.compile("configure\s+list\s+-strobeperiod")
        p2 = re.compile("asdb2.+(-time\s+\S+)")
        for i, item in enumerate(t_lines):
            if p1.search(item):
                t_lines[i] = "    configure list -strobestart {%s} -strobeperiod {%s}" % (in_blank_ps, in_blank_ns)
            elif p11.search(item):
                t_lines[i] = "    configure list -strobeperiod {%s}" % in_blank_ns
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
    if todo_coverage and vendor_name == "QuestaSim":
        t_lines = update_do_lines_with_coverage(t_lines, coverage_args)
    # //////////////////// Write the do file
    # vsim -L work %(sim_top)s  -L %(lib_name)s
    p_lib_order = re.compile(r"""(vsim\s+-L\s+)
                                 (work)
                                 (\s+\S+\s+-L\s+)
                                 (\S+)""", re.X)
    new_ob = open(do_file, "w")
    for item in t_lines:
        if is_bit2sim:
            item = p_lib_order.sub(r"\1\4\3\2", item)
        print(item, file=new_ob)
    new_ob.close()
    if vendor_name == "Active":
        xTools.write_file('library.cfg', ['$INCLUDE = "$ACTIVEHDLLIBRARYCFG"'])


def update_do_lines_with_coverage(now_lines, coverage_args):
    new_lines = list()
    p_vsim = re.compile("^vsim\s+-")   # vsim -voptargs=+acc -L
    p_voptargs = re.compile("-voptargs=(.+)")
    p_run_us = re.compile(r"^run\s+\d+")  # run 10 us
    for foo in now_lines:
        new_foo = foo.strip()
        m_vsim = p_vsim.search(new_foo)
        m_run_us = p_run_us.search(new_foo)
        if m_run_us:
            new_lines.append(foo)
            new_lines.append("    coverage report -output cover_report.txt -srcfile=* -assert -directive -cvg -codeAll")
        elif m_vsim:
            foo_list = shlex.split(foo)
            for i, item in enumerate(foo_list):
                m_voptargs = p_voptargs.search(item)
                if m_voptargs:  # vsim -voptargs=+acc -L work
                    foo_list[i] = '-voptargs="{} +cover={} -covercells" -coverage'.format(m_voptargs.group(1), coverage_args)
                    break
                elif item == "-voptargs":  # vsim -voptargs xxx
                    foo_list[i+1] = '"{} +cover={} -covercells" -coverage'.format(foo_list[i+1], coverage_args)
                    break
            # add a pair of " for item which has space
            new_foo_list = list()
            for item in foo_list:
                if item.startswith("-"):
                    new_foo_list.append(item)
                    continue
                if " " in item:
                    if not item.startswith('"'):
                        item = '"{}"'.format(item)
                new_foo_list.append(item)
            new_lines.append(" ".join(new_foo_list))
        else:
            new_lines.append(foo)
    return new_lines


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
            for k, v in list(more_args.items()):
                if v:
                    continue
                more_args[k] = k in foo
        else:
            new_lines.append(foo)

    if sv_lines:
        vlog_opt = "vlog -sv -mfcu -work work "
        for k, v in list(more_args.items()):
            if v:
                vlog_opt += ' {} '.format(k)
        for i, bar in enumerate(sv_lines):
            try:
                bar_list = shlex.split(bar)
            except ValueError:
                print("Warning. Cannot shlex split line: {}".format(bar))
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
    if is_vhdl:
        real_name = _t.get("vhdl", "not_found_vhd_file_in_ipx.vhd")
    else:
        for perhaps_name in ("verilog", "system_verilog"):
            real_name = _t.get(perhaps_name)
            if real_name:
                break
        else:
            real_name = "not_found_v_or_sv_file_in_ipx.v"
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


def get_ipm_vo_file(ipm_file):
    ipm_file_root_path = os.path.dirname(ipm_file)
    ipm_filename = os.path.splitext(os.path.basename(ipm_file))[0]
    vo_files = glob.glob(os.path.join(ipm_file_root_path, "ipm", ipm_filename, "*.vo"))
    if vo_files:
        return vo_files[0]


def disable_sdc_ldc_file(project_dict, keep_pdc=False):
    source_list = project_dict.get("source", list())
    flow_settings = list()
    for item in source_list:
        type_name = item.get("type")
        if "Constraints File" in type_name:
            if keep_pdc:
                if item.get("type_short") == "PDC":
                    continue
            flow_settings.append('prj_disable_source "%s"' % item.get("name", "NoFileName"))
    return flow_settings


def _create_group(clk_list):
    new_list = ['-group [get_clocks {%s}]' % item for item in clk_list]
    new_string = " ".join(new_list)
    return "set_clock_groups %s -physically_exclusive" % new_string


def _get_original_pdc_lines(project_file_path, project_dict):
    source_list = project_dict.get("source")
    original_pdc_file = ""
    for foo in source_list:
        if foo.get("type_short") == "PDC":
            pdc_file_in_project = xTools.get_relative_path(foo.get("name"), project_file_path)
            if os.path.isfile(pdc_file_in_project):
                original_pdc_file = pdc_file_in_project
    lines = list()
    if original_pdc_file:
        with open(original_pdc_file) as ob:
            for line in ob:
                short_line = line.strip()
                line = line.rstrip()
                if short_line.startswith("#"):
                    continue
                if "create_clock" in line:
                    continue
                if "set_clock_groups" in line:
                    continue
                lines.append(line)
    return lines


def write_pdc_file(pdc_file, clk_data, project_file_path, project_dict):
    lines = _get_original_pdc_lines(project_file_path, project_dict)
    clk_list = [foo.get("clkName") for foo in clk_data]
    lines.extend(["create_clock -name {%s} -period 100 [get_nets {%s}]" % (bar, bar) for bar in clk_list])
    if clk_list:
        lines.append(_create_group(clk_list))
    xTools.append_file(pdc_file, lines, append=False)


def update_pdc_file(pdc_file, fmax, fixed_clock):
    pdc_lines = list()
    _period = "%.3f" % (1000.0/fmax)
    pdc_lines.append("#----  Target Frequency: %d MHz (%s ns)" % (fmax, _period))
    p_name = re.compile(r"\[get_(port|pin|net)s\s*{*([^]]+)}*]")  # get_ports | get_pins | get_nets
    with open(pdc_file) as pdc_ob:
        for line in pdc_ob:
            this_period = None
            if line.startswith("#---- "):
                continue
            if fixed_clock:
                m_name = p_name.search(line)
                if m_name:
                    clk_name = m_name.group(2)
                    clk_name = clk_name.strip('}')
                    clk_name = clk_name.strip('{')
                    fixed_frequency = fixed_clock.get(clk_name)
                    if fixed_frequency:
                        pdc_lines.append("#---- Special Frequency {}".format(fixed_clock))
                        this_period = "%.3f" % (1000.0/fixed_frequency)
            if not this_period:
                this_period = _period
            new_line = re.sub("\s-period\s+\S+\s", " -period %s " % this_period, line)
            pdc_lines.append(new_line)
    with open(pdc_file, 'w') as pdc_w:
        for foo in pdc_lines:
            print(foo.rstrip(), file=pdc_w)


def _remove_braces(raw_string):
    raw_string = raw_string.strip('{')
    raw_string = raw_string.strip('}')
    return raw_string


def write_ldc_fdc_file(ldc_fdc_file, clocks, general_frequency=50):
    clocks = list(map(_remove_braces, clocks))
    with open(ldc_fdc_file, 'w') as new:
        print("# General frequency %.3f MHz" % general_frequency, file=new)
        _period = "%.3f" % (1000.0/general_frequency)
        for clk in clocks:
            print("create_clock -name {%s} -period %s [get_ports {%s}]" % (clk, _period, clk), file=new)
        if len(clocks) > 1:
            print(_create_group(clocks), file=new)


def rewrite_ldc_fdc_file(ldc_fdc_file, clock_frequency, inc_per):
    with open(ldc_fdc_file, 'w') as new:
        print("# Update @ %s" % time.ctime(), file=new)
        contents = list()
        for clk in clock_frequency:
            one = clk.get("SDCConstraint")
            two = clk.get("Frequency")
            new_two = get_new_constraint(two, inc_per)
            if new_two:
                print("# %s" % ", ".join(one + [two]), file=new)
                contents.append(one + [new_two[-1]])
        for item in contents:
            print("create_clock -name {%s} -period %s [%s {%s}]" % (item[1], item[-1], item[0], item[1]), file=new)
        if len(contents) > 1:
            t = [item[1] for item in contents]
            print(_create_group(t), file=new)


def rewrite_lpf_file(lpf_file, clock_frequency, inc_per):
    with open(lpf_file, 'w') as new:
        print("# Update @ %s" % time.ctime(), file=new)
        print("BLOCK RESETPATHS ;", file=new)
        print("BLOCK ASYNCPATHS ;", file=new)
        print("BLOCK INTERCLOCKDOMAIN PATHS ;", file=new)
        for clk in clock_frequency:
            one = clk.get("Preference")
            two = clk.get("Actual")
            new_two = get_new_constraint(two, inc_per)
            if new_two:
                print('FREQUENCY %s "%s" %s MHz ;' % (one[0], one[1], new_two[0]), file=new)


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
    new_list = list()
    for foo in nets:
        foo = foo.replace(" ", "")
        if foo[0] == "{":
            foo = foo[1:-1]  # remove { and }
        new_list.append(foo)
    return new_list


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
                tt = re.split(r"\|", line)
                x = list()
                for foo in tt:
                    x.append(foo.strip())
                self.hot_lines.append(x)

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
                _name = m_clk_name.group(2)
                if _name.startswith('{'):
                    _name = _name[1:-1]
                item[0] = [m_clk_name.group(1), _name]
                self.clock_freq.append(dict(list(zip(titles, item))))
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
        for k, v in list(self.sorted_dict.items()):
            clock_names.append(" -group [get_clocks {}]".format(v[0]))
        clock_names_string = " ".join(clock_names)
        self.remove_repeated_lines()
        pdc_lines = list()
        for k, v in list(self.sorted_dict.items()):
            pdc_lines.append(v[1])
        if pdc_lines:
            if len(clock_names) > 1:
                pdc_lines.append("set_clock_groups {} -logically_exclusive".format(clock_names_string))
        return pdc_lines

    def sort_by_tag(self):
        self.sorted_dict = OrderedDict()
        for t in self.tags_clock:
            for k, v in list(self.clock_line_dict.items()):
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
    this_tb_files = list()
    for x in file_dict_list:
        _t_y_p_e = x.get("type")
        if not _t_y_p_e.startswith("testbench_"):
            continue
        _n_a_m_e = x.get("name")
        raw_tb_file = xTools.get_abs_path(_n_a_m_e, os.path.dirname(ipx_file))
        if os.path.exists(raw_tb_file):
            src_path = os.path.dirname(raw_tb_file)
            dst_path = os.path.join(working_directory, "testbench")
            if os.path.isdir(dst_path):
                shutil.rmtree(dst_path)
            shutil.copytree(src_path, dst_path)
            dst_file = os.path.join(dst_path, os.path.basename(_n_a_m_e))
            this_tb_file = os.path.relpath(dst_file, working_directory)
            if "tb_top" in this_tb_file:
                this_tb_files.append(this_tb_file)
            else:
                this_tb_files.insert(len(this_tb_files)-1, this_tb_file)
    return this_tb_files


def generate_bit2sim_vo_file(impl_path, udb_file, foundry_path):
    kept_keys = ("ENV", "LD_LIBRARY_PATH", "PATH", "FOUNDRY")
    current_values = dict(zip(kept_keys, list(os.getenv(foo) for foo in kept_keys)))
    radiant_bit2sim = os.getenv("EXTERNAL_BIT2SIM_RADIANT")
    if radiant_bit2sim:
        foundry_path = "/lsh/sw/qa/qadata/radiant/lin/{}/ispfpga".format(radiant_bit2sim)
    verific_lib = "/tools/dist/verific/sv/Jul21/pythonmain/install"
    env_python27 = os.getenv("EXTERNAL_PYTHON27_EXECUTABLE")
    if env_python27:
        python27 = env_python27
    else:
        python27 = "/lsh/sw/qa/lshqa/qa_home/qa_tools/python27_x64/bin/python"
    is_using_env = os.getenv("ENV") or os.getenv("env")
    if is_using_env:   # FOUNDRY : /home/rel/ng2022_1.236/rtf/ispfpga
        build_name = os.path.basename(os.path.abspath(os.path.join(foundry_path, "..", "..")))
    else:
        build_name = os.path.basename(os.path.dirname(foundry_path))
    new_values = dict()
    x = "ng2023_1p.43"
    if x in build_name:
        build_name = x
    _env = new_values["ENV"] = "/home/rel/{}/env/fpga".format(build_name)
    bin_lin = "{}/bin/lin64".format(_env)
    new_values["LD_LIBRARY_PATH"] = "{}:{}:{}".format(verific_lib, bin_lin, os.getenv("LD_LIBRARY_PATH"))
    new_values["PATH"] = "{}:{}".format(bin_lin, os.getenv("PATH"))
    new_values["FOUNDRY"] = foundry_path
    args = dict(py27=python27, impl=impl_path, udb=udb_file, vo="bit2sim_netlist", env=_env)
    if is_using_env:
        cmd_line = "{py27} {env}/base/database/basdn/tools/bit2sim/bit2sim.py -w -i {impl}/{udb}".format(**args)
    else:
        cmd_line = "{py27} {env}/bin/lin64/bit2sim/bit2sim.py -w -i {impl}/{udb}".format(**args)
    lines = list()
    for k, v in list(new_values.items()):
        os.environ[k] = v
        lines.append("setenv {} {}".format(k, v))
    lines.append(cmd_line)
    xTools.write_file("gen_vo.csh", lines)
    xTools.run_command(cmd_line, "test_bit2sim.log", "test_bit2sim.time")
    for k, v in list(current_values.items()):
        if not v:
            os.environ.pop(k)
        else:
            os.environ[k] = v
    vo_file = args.get("vo") + '.vo'
    if os.path.isfile(vo_file):
        return vo_file
    print("Warning. cannot generate bit2sim.vo file")


def update_bit2sim_vo_file(source_files, dev_lib_path, foundry_path):
    dd = os.path.basename(dev_lib_path)
    dd = re.sub("ovi_", "", dd)
    new_path = os.path.join(foundry_path, "..", "cae_library", "simulation", "verilog", "ap6a00", "ebr_package.sv")
    new_path = xTools.win2unix(new_path, 1)
    p_ebr = re.compile('"ebr_package.sv"')
    for foo in source_files:
        foo_lines = open(foo).readlines()
        with open(foo, "w") as wob:
            for line in foo_lines:
                m_ebr = p_ebr.search(line)
                if m_ebr:
                    line = p_ebr.sub('"{}"'.format(new_path), line)
                print(line, file=wob, end="")


def add_license_control():
    return
    try:
        user = getpass.getuser()
        if sys.platform.startswith("win"):
            layout_path = os.path.join(r"C:\Users\%s\AppData\Roaming\LatticeSemi\DiamondNG" % user)
        else:
            layout_path = "/users/%s/.config/LatticeSemi/DiamondNG" % user
        ini_file = os.path.join(layout_path, ".setting.ini")
        p = re.compile("AllowLicenseControl=(.+)")
        with open(ini_file) as ob:
            for line in ob:
                m = p.search(line)
                if m:
                    if m.group(1) == "true":
                        return  # do not change
        ini_lines = open(ini_file).readlines()
        with open(ini_file, "w") as ob:
            for line in ini_lines:
                if p.search(line):
                    continue
                print(line, file=ob, end="")
                if "[General]" in line:
                    print("AllowLicenseControl=true", file=ob)
    except:
        pass


def get_sdc_constraint_lines(twr_file):
    start = False
    p_start = re.compile("SDC Constraints$")
    p_start_next = re.compile("={15}")
    sdc_lines = list()
    with open(twr_file) as ob:
        while True:
            line = ob.readline()
            if not line:
                break
            line = line.strip()
            if p_start.search(line):
                next_line = ob.readline()
                start = p_start_next.search(next_line)
                continue
            if start:
                if not line:
                    break
                sdc_lines.append(line)
    return sdc_lines


def get_clock_target_slack(twr_file):
    extractor = scan_utils.ScanRadiantTimingReport()
    extractor.process(twr_file)
    return extractor.get_twr_data()


def to_int_or_float(raw_string):
    raw_string = re.sub("(ns|MHz)", "", raw_string)
    try:
        v_final = int(raw_string)
    except ValueError:
        try:
            v_final = float(raw_string)
        except ValueError:
            v_final = raw_string
    return v_final


def create_iteration_flow_pdc_file(pdc_file, pdc_lines, clock_target_slack, iter_per, fixed_clock,
                                   clock_custom_hdl_dict, original_constraint_lines, constraint_fext,
                                   project_path, project_dict):
    new_pdc_lines = list()  # do not copy original pdc file lines_get_original_pdc_lines(project_path, project_dict)
    p_custom_hdl = re.compile(r"-name([^-]+)-.+\[get_[^s]+s(.+)\]")
    for line in original_constraint_lines:
        short_line = re.sub(r"\s", "", line)
        m_custom_hdl = p_custom_hdl.search(short_line)
        if not m_custom_hdl:
            new_pdc_lines.append(line)
        else:
            clk_custom, clk_hdl = m_custom_hdl.group(1), m_custom_hdl.group(2)
            clk_custom = clk_custom.strip("{}")
            final_frequency = 0
            if clk_custom in fixed_clock:
                final_frequency = fixed_clock.get(clk_custom)
                timing_data = fixed_clock
            else:
                timing_data = clock_target_slack.get(clk_custom)
                if not timing_data:
                    new_pdc_lines.append(line)
                    continue
                try:
                    now_fmax = float(timing_data.get("fmax"))
                except (ValueError, TypeError):
                    new_pdc_lines.append(line)
                    continue
                slack_value = timing_data.get("Slack")
                if slack_value is None:
                    try:
                        slack_value = eval("{fmax} - {targetFmax}".format(**timing_data))
                    except (ValueError, TypeError):
                        slack_value = 0
                else:
                    try:
                        slack_value = float(slack_value)
                    except (ValueError, TypeError):
                        slack_value = 0
                if slack_value == 0:
                    new_pdc_lines.append(line)
                    continue
                elif slack_value > 0:
                    final_frequency = (1 + iter_per / 100) * now_fmax
                else:
                    final_frequency = (1 + iter_per / 200) * now_fmax
            if final_frequency == 0:
                new_pdc_lines.append(line)
            else:
                new_pdc_lines.append("# {}: {}".format(clk_custom, timing_data))
                whole_period = 1000 / final_frequency
                half_period = whole_period / 2
                line = re.sub(r"-period \S+", "-period {:.3f}".format(whole_period), line)
                line = re.sub(r"-waveform\s+\{.+\}", "-waveform {0.000 %.3f}" % half_period, line)
                new_pdc_lines.append(line)
    with open(pdc_file, "w", newline="\n") as ob:
        for line in new_pdc_lines:
            print(line, file=ob)
        print("# Change Percentage: {}".format(iter_per), file=ob)


def compare_timing_data(old_data, new_data):
    def __dict2string(a_dict):
        if not a_dict:
            return ""
        data_list = list()
        for clk, clk_data in list(a_dict.items()):
            data_list.append("{}_{}".format(clk, clk_data.get("fmax")))
        data_list.sort()
        return "".join(data_list)
    old_string = __dict2string(old_data)
    new_string = __dict2string(new_data)
    return old_string == new_string


def get_dev_pac_pdc_from_mrp_file(mrp_file):
    """
    get dev, pac and pdc file for sso flow
    """
    dpp_pattern = dict(dev=re.compile(r"Device:\s+(\S+)"),
                       pac=re.compile(r"Package:\s+(\S+)"),
                       pdc=re.compile(r"Command\s+line:.+\s+-pdc\s+(.+?)\s+-\w"))
    dpp = dict.fromkeys(dpp_pattern.keys(), "")
    raw_lines = list()
    with open(mrp_file) as ob:
        for line in ob:
            line = line.strip()
            line += " "
            raw_lines.append(line)
            if "Design Summary" in line:
                break
    raw_long_line = "".join(raw_lines)
    for k, p in list(dpp_pattern.items()):
        m = p.search(raw_long_line)
        if m:
            real_data = m.group(1)
            if k == "pdc":
                real_data = re.sub(r"\s", "", real_data)
                real_data = "-c {}".format(xTools.win2unix(real_data, 0))
            dpp[k] = real_data
    return dpp


def get_power_tcl_lines(power_settings, impl_name, project_name):
    if not power_settings.get('run_power'):
        return None
    lines = list()
    lines.append("pwc_new_project auto_power.pcf -udb {0}/{1}_{0}.udb".format(impl_name, project_name))
    lines.append('pwc_set_processtype "{pwr_type}"'.format(**power_settings))
    lines.append('pwc_set_ambienttemp {pwr_at}'.format(**power_settings))
    lines.append('pwc_set_thetaja {pwr_etga}'.format(**power_settings))
    # lines.append('pwc_set_af {pwr_af} -keepClkAF 1'.format(**power_settings))
    lines.append('pwc_set_af {pwr_af} '.format(**power_settings))
    x_twr_mode = power_settings.get("pwr_fre_twr")
    power_settings["twr_opt"] = ' -usefreqtwr 1 -freqtwropt {}'.format(x_twr_mode) if x_twr_mode else ""
    lines.append('pwc_set_freq -freq {pwr_fre}{twr_opt}'.format(**power_settings))
    lines.append('pwc_calculate')
    lines.append('pwc_gen_report auto_power_result.pwr')
    lines.append('pwc_gen_htmlreport auto_power_result.html')
    lines.append('pwc_save_project auto_power.pcf')
    return lines


def run_encryption(lattice_project_file, encryption_key_file, encryption_factor):
    p_is_model_file = re.compile(r"models\W")
    if not os.path.isfile(lattice_project_file):
        print("Error. Not found {}".format(lattice_project_file))
        return
    if not os.path.isfile(encryption_key_file):
        print("Error. Not found {}".format(encryption_key_file))
        return
    if encryption_factor is None:
        return
    hdl_files = dict()
    with open(lattice_project_file) as ob:
        project_data = xml2dict.parse(ob)
        for k, v in list(project_data.items()):  # RadiantProject or BaliProject
            _impl = v.get("Implementation")
            next_impl = [_impl] if isinstance(_impl, dict) else _impl  # to a list
            for a_impl in next_impl:
                _source = a_impl.get("Source")
                next_source = [_source] if isinstance(_source, dict) else _source
                for foo in next_source:
                    _type_short, hdl_file = foo.get("@type_short"), foo.get("@name")
                    _is_sim_file = foo.get("@syn_sim")
                    if _is_sim_file == "SimOnly":
                        continue
                    if not _type_short:
                        continue
                    _type_short = _type_short.lower()
                    if p_is_model_file.search(hdl_file):
                        continue
                    hdl_files.setdefault(_type_short, list())
                    hdl_files[_type_short].append(xTools.get_abs_path(hdl_file, os.path.dirname(lattice_project_file)))
    for hdl_type in ("verilog", "vhdl"):
        hello_files = hdl_files.get(hdl_type)
        if not hello_files:
            continue
        hello_files.sort()
        min_number, max_number = 6, 20
        if len(hello_files) < min_number:
            deal_files = hello_files[:]
        else:
            deal_files = hello_files[::encryption_factor]
            if len(deal_files) < min_number:  # -2, -1, 0, 1, 2
                deal_files = list()
                for i in range(-2, 3):
                    deal_files.append(hello_files[i])
        for i, a_file in enumerate(deal_files):
            if i > max_number:
                break
            ori_file = a_file + ".bak"
            if not os.path.isfile(ori_file):
                shutil.copy2(a_file, ori_file)
            # add "" for the file like "05_ELSA_48E/source/(ELSA_48E)_ELSA_48E_TOP_mod_sap.v"
            enc_cmd = 'encrypt_hdl -k "{}" -l {} -o "{}" "{}"'.format(encryption_key_file, hdl_type, a_file, ori_file)
            xTools.run_command(enc_cmd, "run_encrypt_hdl_flow.log", "run_encrypt_hdl_flow.time")
