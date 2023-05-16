#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 1:27 PM 3/20/2023
  file: utils.py
  author: Shawn Yan
Description:

"""
import os
import re
import time
import glob
from collections import OrderedDict
from . import xml2dict


def dos2unix(a_path):
    return re.sub(r"\\", "/", a_path)


def get_simple_digit_str(a_float_int):
    """
    try to get a simple digit
    8923.0 -> 8923
    8364.3383248 -> 8364.33
    """
    int_value = int(a_float_int)
    if int_value == a_float_int:
        return str(int_value)
    return "%.3f" % a_float_int


def time2secs(time_str):
    try:
        time_str = float(time_str)
        return get_simple_digit_str(time_str)
    except (TypeError, ValueError):
        pass
    try:
        final_secs = 0
        new_time = re.split(r"\s+", time_str)
        day_hour_min_sec = {"days": 24*3600, "hrs": 3600, "mins": 60, "secs": 1}
        _keys = ("days", "hrs", "mins", "secs")
        if len(new_time) == 1:  # 01:02:03:04 or 01h:02m:03s
            new_time = re.split(":", time_str)
            new_time = [re.sub(r"\s+", "", item) for item in new_time]
            new_time = [re.sub(r"\D", "", item) for item in new_time]
            new_time = [float(item) for item in new_time]
            dhms_dict = dict(list(zip(_keys[-len(new_time):], new_time)))
        else:
            dhms_dict = dict.fromkeys(_keys, 0)
            for i, t in enumerate(new_time):
                if t in dhms_dict:
                    dhms_dict[t] = float(new_time[i-1])
        for key, value in list(day_hour_min_sec.items()):
            my_value = dhms_dict.get(key)
            if my_value:
                final_secs += my_value * value
        return get_simple_digit_str(final_secs)
    except (KeyError, ValueError, TypeError):
        return time_str


class YieldLines(object):
    def __init__(self):
        self.report_file = ""

    def open_report(self):
        try:
            self.rob = open(self.report_file, errors="ignore")
            # Note that ignoring encoding errors can lead to data loss.
        except IOError:
            # print("Warning. Not found report file: {}".format(self.report_file))
            self.rob = None

    def close_report(self):
        if self.rob:
            self.rob.close()

    def yield_lines(self, report_file):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            for i, line in enumerate(self.rob):
                line = line.strip()
                yield line
        self.close_report()

    def yield_head_lines(self, report_file, head=100):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            for i, line in enumerate(self.rob):
                if i >= head:
                    break
                line = line.strip()
                yield line
        self.close_report()

    def yield_tail_lines(self, report_file, tail=100):
        self.report_file = report_file
        self.open_report()
        if self.rob:
            line_count = 1
            for line_count, line in enumerate(self.rob):
                pass
            start_line = line_count - tail
            self.close_report()
            self.open_report()
            for i, line in enumerate(self.rob):
                if i <= start_line:
                    continue
                line = line.strip()
                yield line
        self.close_report()

    def yield_hook_lines(self, report_file, hook_dict):
        hook_before = hook_dict.get("before", 0)
        hook_after = hook_dict.get("after", 0)
        hook_pattern = hook_dict.get("pattern")
        self.report_file = report_file
        self.open_report()
        if self.rob:
            hook_index = 0
            for idx, line in enumerate(self.rob):
                if hook_pattern.search(line):
                    hook_index = idx
            min_index = hook_index - hook_before
            max_index = hook_index + hook_after
            self.close_report()
            self.open_report()
            for idx, line in enumerate(self.rob):
                if idx < min_index:
                    continue
                elif idx > max_index:
                    break
                line = line.strip()
                yield line
        self.close_report()


def get_rd_active_data(rd_project_file):
    with open(rd_project_file) as ob:
        project_data = xml2dict.parse(ob)
    for dp_name in ("BaliProject", "RadiantProject"):
        x_project_dict = project_data.get(dp_name)
        if x_project_dict:
            break
    else:
        return dict(), dict()
    _di = x_project_dict.get("@default_implementation", "NONE")
    raw_impl = x_project_dict.get("Implementation", dict())
    raw_impl = [raw_impl] if isinstance(raw_impl, dict) else raw_impl
    for foo in raw_impl:
        if foo.get("@title") == _di:
            return x_project_dict, foo
    return x_project_dict, dict()


def get_exist_file(file_basename, folder1, folder2=None):
    for perhaps_folder in (folder1, folder2):
        if not perhaps_folder:
            continue
        perhaps_file = os.path.join(perhaps_folder, file_basename)
        if os.path.isfile(perhaps_file):
            return perhaps_file


class FindFiles(object):
    def __init__(self, abs_tag, vendor_name, info):
        self.report_files_odict = OrderedDict()
        self.abs_tag = abs_tag
        self.vendor_name = vendor_name
        self.info = info

    def get_report_files_dict(self):
        return self.report_files_odict

    def process(self):
        self.get_project_dict()
        self.append_radiant_diamond_files()
        self.append_vivado_files()

    def get_project_dict(self):
        self.x_project, self.y_impl = dict(), dict()
        prj_file_ext_dict = dict(Radiant="*.rdf", Diamond="*.ldf", Vivado="*.xpr")
        project_files = glob.glob(os.path.join(self.abs_tag, prj_file_ext_dict.get(self.vendor_name)))
        if project_files:
            self.project_file = project_files[0]
            self.x_project, self.y_impl = get_rd_active_data(self.project_file)

    def append_radiant_diamond_files(self):
        if self.vendor_name not in ("Radiant", "Diamond"):
            return
        target_folders = glob.glob(os.path.join(self.abs_tag, "Target_*"))
        if not target_folders:
            target_folders = [self.abs_tag]
        if target_folders:
            target_folders.sort()
            for foo in target_folders:
                pd2 = os.path.dirname(self.project_file)
                pushbutton_or_target_name = os.path.basename(foo)
                if pushbutton_or_target_name == os.path.basename(self.abs_tag):
                    pushbutton_or_target_name = "pushbutton"
                this_list = list()
                # project file
                prj_file = get_exist_file(os.path.basename(self.project_file), foo, pd2)
                if prj_file:
                    this_list.append(prj_file)
                console_file = get_exist_file("runtime_console.log", foo, pd2)
                if console_file:
                    this_list.append(console_file)
                # result files
                _filename_prj = self.x_project.get("@title")
                _filename_impl = self.y_impl.get("@dir")
                _filename_only = "{}_{}".format(_filename_prj, _filename_impl)
                synthesis_name = self.y_impl.get("@synthesis")
                if synthesis_name == "synplify":
                    for fext in (".srr", ".vm", "_syn.psn"):
                        one_file = get_exist_file("{}/{}{}".format(_filename_impl, _filename_only, fext), foo, pd2)
                        if one_file:
                            this_list.append(one_file)
                else:  # LSE
                    one_file = get_exist_file("{}/synthesis.log".format(_filename_impl), foo, pd2)
                    if one_file:
                        this_list.append(one_file)
                    for fext in (".vm", "_syn.psn"):
                        one_file = get_exist_file("{}/{}{}".format(_filename_impl, _filename_only, fext), foo, pd2)
                        if one_file:
                            this_list.append(one_file)
                for fext in (".mrp", ".par", ".twr", ".pad", ".udb", "_map.udb"):
                    one_file = get_exist_file('{}/{}{}'.format(_filename_impl, _filename_only, fext), foo)
                    if one_file:
                        this_list.append(one_file)
                for udb2sv_file in ("test_udb2sv_map.v", "test_udb2sv_par.v"):
                    one_file = get_exist_file('{}/{}'.format(_filename_impl, udb2sv_file), foo)
                    if one_file:
                        this_list.append(one_file)
                for sim_type in ("rtl", "syn_vlg", "map_vlg", "par_vlg", "bit_vlg"):
                    one_file = get_exist_file("sim_{0}/run_sim_{0}.log".format(sim_type), foo)
                    if one_file:
                        this_list.append(one_file)
                self.report_files_odict[pushbutton_or_target_name] = this_list

    def append_vivado_files(self):
        if self.vendor_name != "Vivado":
            return
        xpr_file = self._get_xpr_file()
        if not xpr_file:
            print("Error. Cannot scan Vivado results due to not found xpr_file")
            return
        xpr_file = os.path.abspath(xpr_file)
        result_path = os.path.dirname(xpr_file)
        target_folders = glob.glob(os.path.join(result_path, "target_*"))
        if not target_folders:
            target_folders = [result_path]
        target_folders.sort()
        for foo in target_folders:
            pushbutton_or_target_name = os.path.basename(foo)
            if "target_" not in pushbutton_or_target_name:
                pushbutton_or_target_name = "pushbutton"
            this_list = list()
            for name_pattern in ("*.runs/impl_1/*utilization_placed.rpt",
                                 "*.runs/impl_1/*timing_summary_routed.rpt",
                                 "*.runs/impl_1/runme.log",
                                 "*.runs/synth_1/runme.log"):
                abs_pattern = os.path.join(foo, name_pattern)
                files = glob.glob(abs_pattern)
                if files:
                    this_list.append(files[0])
            if this_list:
                self.report_files_odict[pushbutton_or_target_name] = this_list

    def _get_xpr_file(self):
        if self.info:
            info_file = get_exist_file(self.info, self.abs_tag)
        else:
            info_file = glob.glob(os.path.join(self.abs_tag, "*.info"))
            if len(info_file) == 1:
                info_file = info_file[0]
            else:
                print("Error. Multi info file under {}".format(self.abs_tag))
                return
        p_xpr_file = re.compile(r"^xpr_file\s*=\s*(\S.+)")
        xpr_file = None
        with open(info_file) as ob:
            for line in ob:
                line = line.strip()
                m_xpr_file = p_xpr_file.search(line)
                if m_xpr_file:
                    xpr_file = m_xpr_file.group(1)
                    break
        if xpr_file:
            xpr_file = get_exist_file(xpr_file, self.abs_tag)
        return xpr_file


def get_valid_lines(rpt_file, start_pattern=None, end_pattern=None):
    with open(rpt_file) as ob:
        if start_pattern and end_pattern:
            will_yield = False
        else:
            will_yield = True
        for line_number, line in enumerate(ob):
            if will_yield:
                if end_pattern:
                    if end_pattern.search(line):
                        break
                yield line.strip()
            else:
                if start_pattern:
                    will_yield = start_pattern.search(line)
                    if will_yield:
                        yield line.rstrip()


class ScanVivadoTimingReport(object):
    def __init__(self, report_file):
        self.report_file = report_file
        self.p_start_constraint = re.compile(r"^Clock\s+Waveform\(ns\)")
        self.p_start_worst_slack = re.compile(r"Clock\s+WNS\(ns\)")
        self.p_end = re.compile(r"^\s*$")
        self.frequency_dict = dict()

    def get_twr_data(self):
        return self.frequency_dict

    def process(self):
        self.get_clock_constraint_period()
        self.get_clock_worst_slack()
        self.calculate_frequency()

    def get_clock_constraint_period(self):
        """
        Clock      Waveform(ns)         Period(ns)      Frequency(MHz)
        -----      ------------         ----------      --------------
        clk_1_mhz  {0.000 3.846}        7.692           130.005
        clk_8_mhz  {0.000 3.846}        7.692           130.005
        """
        valid_lines = get_valid_lines(self.report_file, start_pattern=self.p_start_constraint, end_pattern=self.p_end)
        self.clock_constraint_dict = dict()
        for foo in valid_lines:
            if foo is None:
                continue
            foo_list = foo.split()
            try:
                float(foo_list[-1])
                self.clock_constraint_dict[foo_list[0]] = float(foo_list[-2])
            except ValueError:
                continue

    def get_clock_worst_slack(self):
        """
        Clock             WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints    ...
        -----             -------      -------  ---------------------  -------------------    ...
        clk_1_mhz         -16.123      -63.896                      4                  529    ...
        clk_8_mhz          -0.872       -0.872                      1                  144    ...
        """
        valid_lines = get_valid_lines(self.report_file, start_pattern=self.p_start_worst_slack, end_pattern=self.p_end)
        self.clock_worst_slack_dict = dict()
        for foo in valid_lines:
            if foo is None:
                continue
            foo_list = foo.split()
            try:
                wns_float = float(foo_list[1])
                self.clock_worst_slack_dict[foo_list[0]] = wns_float
            except ValueError:
                continue

    def calculate_frequency(self):
        self.frequency_dict = dict()
        for clock_name, clock_period in list(self.clock_constraint_dict.items()):
            worst_slack_value = self.clock_worst_slack_dict.get(clock_name)
            if worst_slack_value:
                self.frequency_dict[clock_name] = dict(targetFmax=1000 / clock_period,
                                                       fmax=1000 / (clock_period - worst_slack_value),
                                                       slack=worst_slack_value)


class ScanRadiantTimingReport(YieldLines):
    def __init__(self):
        super(ScanRadiantTimingReport, self).__init__()
        self.twr_data = dict()
        self.p_check_start_message_list = (re.compile(r"\d+\s+Setup at Speed Grade.+at\s+([-\d]+)\s+Degrees"),
                                           re.compile(r"([.\d]+)\s+(Setup)\s+Summary\s+Report"))
        self.p_yes = re.compile("^=+$")
        # report_type is 1
        self.p_sep = re.compile(r"\s*\|\s*")
        self.set_of_titles = {"SDC Constraint", "Target", "Slack", "Levels", "Frequency"}
        self.p_row = re.compile(r"^[-|\s]+$")
        # report_type is 2
        self.p_constraint = re.compile(r"(create(_|_generated_)clock\s+-name.+)")
        #             Target |           5.398 ns |        185.254 MHz
        # Actual (all paths) |           5.154 ns |        194.024 MHz
        self.p_target = re.compile(r"Target\s+\|\s+.+\s+([\d.]+)\s+MHz")
        self.p_actual = re.compile(r"Actual\s+\Wall\s+paths\W\s+.+\s+([\d.]+)\s+MHz")

    def get_twr_data(self):
        return self.twr_data

    def process(self, twr_file):
        self.twr_data = dict()
        if not os.path.isfile(twr_file):
            print("Error. Not found .twr file {}".format(twr_file))
            return
        start_message_line = self.get_start_line(twr_file)
        raw_twr_data = self.get_raw_twr_data(twr_file, start_message_line, 1)
        if not raw_twr_data:
            raw_twr_data = self.get_raw_twr_data(twr_file, start_message_line, 2)
        if raw_twr_data:
            self.create_twr_data(raw_twr_data)

    def get_start_line(self, twr_file):
        lines = self.yield_head_lines(twr_file)
        start_dict = dict()
        for foo in lines:
            for p_s in self.p_check_start_message_list:
                m_s = p_s.search(foo)
                if m_s:
                    key = m_s.group(1)
                    try:
                        key = int(key)
                    except ValueError:
                        pass
                    start_dict[key] = foo
                    break
        if not start_dict:
            print("Warning: Cannot find start mark in {}".format(twr_file))
            return ""
        _keys = list(start_dict.keys())
        _keys.sort()
        return start_dict[_keys[0]]

    def get_raw_twr_data(self, twr_file, start_message_line, report_type=1):
        clock_value_dict = dict()
        start = 0
        whole_lines = self.yield_lines(twr_file)
        summary_titles = list()
        table_lines = list()
        table_line = ""
        raw_key = ""
        while True:
            try:
                line = next(whole_lines)
            except StopIteration:
                break
            if not start:
                start = start_message_line in line
                if start:
                    next_line = next(whole_lines)
                    if not self.p_yes.search(next_line):
                        start = False
            else:
                if report_type == 1:
                    list_of_line = self.p_sep.split(line)
                    if not summary_titles:
                        set_of_line = set(list_of_line)
                        if not (self.set_of_titles - set_of_line):  # find title
                            summary_titles = list_of_line
                    else:
                        if not line:
                            break
                        if self.p_row.search(line):
                            continue
                        if len(list_of_line) == len(summary_titles):
                            table_lines.append(table_line + line)
                            table_line = ""
                        else:
                            table_line += line
                elif report_type == 2:
                    m_constraint = self.p_constraint.search(line)
                    if m_constraint:
                        raw_key = m_constraint.group(1)  # always
                        clock_value_dict.setdefault(raw_key, dict())
                    if raw_key:
                        m_target = self.p_target.search(line)
                        m_actual = self.p_actual.search(line)
                        if m_target:
                            clock_value_dict[raw_key]["Target"] = m_target.group(1)
                        elif m_actual:
                            clock_value_dict[raw_key]["Actual"] = m_actual.group(1)
        if table_lines:
            for foo in table_lines:
                foo_list = self.p_sep.split(foo)
                clock_value_dict[foo_list[0]] = dict(zip(summary_titles, foo_list))
        return clock_value_dict

    def create_twr_data(self, raw_twr_data):
        # p_clk_name = re.compile(r"\[get_(port|pin|net)s{*([^]]+)}*]")  # get_ports | get_pins | get_nets
        # when use Lattice Standard timing report format, use -name $clk_name.
        p_clk_name = re.compile(r"-name([^-]+)-")
        for k, v in list(raw_twr_data.items()):
            short_k = re.sub(r"\s", "", k)
            m_clk_name = p_clk_name.search(short_k)
            if m_clk_name:
                clk_name = m_clk_name.group(1)
                clk_name = clk_name.strip("{")
                clk_name = clk_name.strip("}")
                #
                _target, _actual = v.get("Target"), v.get("Actual")
                if _target and _actual:
                    self.twr_data[clk_name] = dict(target_fmax=_target, fmax=_actual)
                else:
                    _target = v.get("Target", "")
                    _actual = v.get("Frequency", "")
                    _target_list = _target.split()
                    _actual_list = _actual.split()
                    this_clk_data = dict()
                    if len(_target_list) == 2 and len(_actual_list) == 2:
                        if _target_list[-1] == "ns" and _actual_list[-1] == "MHz":
                            df = "{:.3f}".format(1000/float(_target_list[0]))
                            this_clk_data = dict(targetFmax=df, fmax=_actual_list[0])
                    else:
                        if len(_actual_list) == 2:
                            this_clk_data["fmax"] = _actual_list[0]
                            this_clk_data["targetFmax"] = _target
                    if this_clk_data:
                        this_clk_data["logic_level"] = v.get("Levels")
                        this_clk_data["Slack"] = re.sub(r"\sns", "", v.get("Slack", ""))
                        self.twr_data[clk_name] = this_clk_data


class ElapsedTime:
    """
    Get elapsed time
    """

    def __init__(self):
        self.start_time = time.time()

    def __str__(self):
        elapsed_time = time.time() - self.start_time
        return "Elapsed Time: {:.2f} seconds".format(elapsed_time)

    def in_seconds(self):
        elapsed_time = time.time() - self.start_time
        return int(elapsed_time)


def get_number_loads_name(mrp_file, title, start_pattern, end_patterns):
    p_skipped = (re.compile(r"^Page\s+\d+"), re.compile("^-+$"), re.compile("Design.+Date:"))
    unique_mark = "Amsterdam-Holland"
    p_name_loads = re.compile(r"{}([^:]+):(\d+)loads,".format(unique_mark))
    mrp_lines = YieldLines().yield_lines(mrp_file)
    _dict = dict()
    m_start = None
    raw_lines = list()
    for line in mrp_lines:
        if not m_start:
            m_start = start_pattern.search(line)
            if m_start:
                _dict["{}Number".format(title)] = m_start.group(1)
        else:
            for ep in end_patterns:
                if ep.search(line):
                    break
            else:
                line = line.strip()
                if not line:
                    continue
                for pp in p_skipped:
                    if pp.search(line):
                        break
                else:
                    if line in ("Net", "Pin"):
                        line += unique_mark
                    else:
                        line = re.sub("(Net |Pin )", unique_mark, line)
                    raw_lines.append(line)
                continue
            break  # no more lines
    long_line = "".join(raw_lines)
    long_line = re.sub(r"\s+", "", long_line)  # remove spaces
    m_name_loads = p_name_loads.findall(long_line)
    if m_name_loads:
        loads_and_name_dict = dict()
        for (_name, _loads) in m_name_loads:
            int_key = int(_loads)
            loads_and_name_dict.setdefault(int_key, list())
            loads_and_name_dict[int_key].append(_name)
        max_key = max(list(loads_and_name_dict.keys()))
        name_list = loads_and_name_dict.get(max_key)
        len_name_list = len(name_list)
        base_num, base_name = str(max_key), name_list[0]
        if len_name_list > 1:
            base_num = '{}({})'.format(base_num, len_name_list)
            base_name += "..."
        _dict["{}MaxLoadNum".format(title)] = base_num
        _dict["{}MaxLoadName".format(title)] = base_name
    return _dict


def get_vivado_utilization_data(data_file, table_name, report_name_and_site_type_name_dict):
    """ Site Type  | Used | .... Util% |
    """
    ud = dict()
    p_table = re.compile(r'\d+\.\s+' + table_name + "$")
    p_next = re.compile("^-+$")
    data_lines = YieldLines().yield_lines(data_file)
    start_table, titles = False, list()
    simple_titles_set = {"Site Type", "Used", "Util%"}
    while True:
        try:
            line = next(data_lines)
        except StopIteration:
            break
        if start_table:
            line_list = re.split(r"\|", line)
            line_list = [item.strip() for item in line_list]
            line_set = set(line_list)
            if not (simple_titles_set - line_set):
                titles = line_list
                continue
            if titles:
                if not line:
                    break
                raw_data_dict = dict(zip(titles, line_list))
                for report_name, site_type_name in list(report_name_and_site_type_name_dict.items()):
                    if raw_data_dict.get("Site Type") != site_type_name:
                        continue
                    ud[report_name] = raw_data_dict.get("Used")
                    ud["{}_per".format(report_name)] = raw_data_dict.get("Util%")
        elif p_table.search(line):
            next_line = next(data_lines)
            if p_next.search(next_line):
                start_table = True
    return ud
