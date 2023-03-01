from .process import *
from .scan_tools import *
import re
from .scan_default import Default
from collections import defaultdict


class ScanBasic(Process):
    def __init__(self, name):
        Process.__init__(self)
        self.name = name
        self.descriptor = ''
        self.files_patterns = {}
        self.files = {}
        self.patterns = {}

    def run(self):
        self.task_struct.name = self.descriptor
        options = self.task_struct.args.pop()

        if self.task_struct.args:
            self.files_patterns = Default(options).get_options()
            for args in self.task_struct.args:
                fargs = {i: args[i] for i in args if i in options['files']}
                oargs = {i: args[i] for i in args if i in options['patterns']}
                self.files = dict(options['files'], **fargs)
                self.patterns = dict(options['patterns'], **oargs)
                if 'cat' in args:
                    self.task_struct.name = args['cat']
                self.handle(options, args)
        else:
            return

    def handle(self, options, args):
        raise NotImplementedError

    def call_lower_method(self, method, options, patterns, handle_number=None):
        lm = method()
        if handle_number:
            lm.handle_number = handle_number
        lm.task_struct = self.task_struct
        for pattern in patterns:
            lm.handle(options, pattern)

    def handle_number(self, num):
        return num

    def add_to_process(self, p_name, result):
        for p in for_each_process():
            print((p.name, p_name))
            if p.name.lower() == p_name.lower():
                p.stack.append(result)
                return True
        else:
            return False


def change_to_seconds(key_name, raw_value):
    if key_name.endswith("_cpu_time"):
        x_list = re.split(":", raw_value)
        if len(x_list) == 3:
            x_list = [int(item) for item in x_list]
            raw_value = str(3600 * x_list[0] + 60 * x_list[1] + x_list[2])
    return raw_value


class ScanPattern(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_pattern')

    def handle(self, options, args):
        start_pattern = args['start_pattern'] if 'start_pattern' in args else None
        stop_pattern = args['stop_pattern'] if 'stop_pattern' in args else None
        design = options['design']
        filename = get_file(os.path.join(design, args['file']))
        if not filename:
            return
        with open(filename, 'r') as f:
            for line in get_part_lines(f, start_pattern, stop_pattern):
                if 'flags' in args:
                    m = re.search(args['pattern'], line, args['flags'])
                else:
                    m = re.search(args['pattern'], line)
                if m:
                    if len(m.groups()) == 0:
                        self.out({args['keyword']: 'PASS'})
                        return
                    if args['keyword'] in m.groupdict():
                        ret = self.handle_number(m.group(args['keyword']))
                    else:
                        ret = self.handle_number(m.group(1))
                        # sim_rtl_cpu_time 0:02:01 to 121
                        ret = change_to_seconds(args['keyword'], ret)
                    self.out({args['keyword']: ret})
                    return


class ScanStrings(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_strings')

    def handle(self, options, args):
        adder = []
        design = options['design']
        patterns = sorted([i for i in args if i.startswith('pattern')], key=lambda j: int(j[8:]))
        filename = get_file(os.path.join(design, args['file']))
        if not filename:
            return
        with open(filename, 'r') as f:
            for line in f:
                delete = []
                for p in patterns:
                    m = re.search(args[p], line)
                    if m:
                        adder.append(m.group(1))
                        delete.append(p)
                for d in delete:
                    patterns.remove(d)
        '''
        if len(patterns) > 0:
            raise PatternNotFound(patterns[0], args[patterns[0]])
        '''
        join = args['join'] if 'join' in args else ''
        result = {args['keyword']: join.join(adder)}
        self.out(result)


class ScanNumbers(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_numbers')

    def handle(self, options, args):
        start_pattern = args['start_pattern'] if 'start_pattern' in args else None
        stop_pattern = args['stop_pattern'] if 'stop_pattern' in args else None
        keyword_num = args['keyword_num'] if 'keyword_num' in args else None
        matchs = []
        maps = defaultdict(list)
        mrp_file = get_file(os.path.join(options['design'], args['file']))
        if not mrp_file:
            return
        tmp_str = ''
        with open(mrp_file, 'r') as f:
            for line in get_part_lines(f, start_pattern, stop_pattern, flags=re.I):
                if line.endswith('Pin')or re.search('\W$', line):
                    line += ' '
                tmp_str += line
        for p in args:
            if p.startswith('pattern_'):
                find_all = re.finditer(args[p], tmp_str)
                if find_all:
                    for m in find_all:
                        if keyword_num:
                            matchs.append(m.group(args['keyword_num']))
                            maps[m.group(args['keyword_num'])].append(m.group(args['keyword']))
                        else:
                            matchs.append(m.group(args['keyword']))
        if matchs:
            matchs = [int(i) for i in matchs]
            val = eval(args['operator'])(matchs)
            if keyword_num and str(val) in maps:
                ret = maps[str(val)][0]
                self.out({keyword_num: str(val) + '(' + str(len(maps[str(val)])) + ')'})
            else:
                ret = str(self.handle_number(val))
            self.out({args['keyword']: ret})


class ScanPrjInfo(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_prj_info')
        self.descriptor = 'Project Info'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        pattern_args = [
            {
                'file': self.files['prj_info_synthesis_file'],
                'pattern': self.patterns['prj_info_synthesis_pattern'],
                'keyword': 'synthesis'
            },
            {
                'file': self.files['prj_info_version_file'],
                'pattern': self.patterns['prj_info_version_pattern'],
                'keyword': 'version'
            },
        ]

        string_args_1 = [
            {
                'file': self.files['prj_info_device_file'],
                'pattern_1': self.patterns['prj_info_device_pattern'][0],
                'pattern_2': self.patterns['prj_info_device_pattern'][1],
                'keyword': 'device',
                'join': '-'
            },
        ]

        self.call_lower_method(ScanPattern, options, pattern_args)
        self.call_lower_method(ScanStrings, options, string_args_1)

        design = options['design']
        filename = get_file(os.path.join(design, self.files['prj_info_HDL_type_file']))
        self.out({'HDL_type': get_hdl_type(self.patterns['prj_info_HDL_type_pattern'],
                                           self.patterns['prj_info_HDL_type_exclude_pattern'],
                                           filename)})


class ScanTiming(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_timing')
        self.descriptor = 'Timing'
        self.twr_file = None
        self.pap = None
        self.raw_list = None
        self.clkname = None

    def handle_number(self, num):
        return get_simple_digit_str(float(num) * 1000)

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def out(self, ret):
        if self.pap:  # dump pap and pap_fmax only
            _ = dict()
            for k, v in list(ret.items()):
                if k == "pap":
                    _["pap"] = v
                elif k == "fmax":
                    _["pap_fmax"] = v
            if _:
                self.task_struct.stack.append(_)
        else:
            _ = dict()
            for k, v in list(ret.items()):
                if k == "pap":
                    _["fmax_pap"] = v
                else:
                    _[k] = v
            if _:
                self.task_struct.stack.append(_)

    def handle_diamond(self, options, args):
        self.twr_file = get_file(self.files['timing_seed_file'])
        if not self.twr_file:
            return
        self.raw_list = parse_twr_diamond(self.twr_file)
        self.parse_fmax = parse_fmax_diamond
        if not self.create_data_a():
            self.create_data_c()
        self.get_more_data()

        pattern_args = [
            {
                'file': self.files['timing_scoreHold_file'],
                'pattern': self.patterns['timing_scoreHold_pattern'],
                'keyword': 'scoreHold'
            },
            {
                'file': self.files['timing_scoreSetup_file'],
                'pattern': self.patterns['timing_scoreSetup_pattern'],
                'keyword': 'scoreSetup'
            },
        ]

        numbers_args_1 = [
            {
                'file': self.files['timing_totalloads_file'],
                'pattern_1': self.patterns['timing_totalloads_pattern'],
                'start_pattern': 'Number of clocks:\s+(\d+)',
                'stop_pattern': 'Number of',
                'operator': 'sum',
                'keyword': 'totalLoads',
            },
            {
                'file': self.files['timing_maxloads_file'],
                'pattern_1': self.patterns['timing_maxloads_pattern'],
                'start_pattern': 'Number of clocks:\s+(\d+)',
                'stop_pattern': 'Number of',
                'operator': 'max',
                'keyword': 'maxLoads',
            },
        ]

        self.call_lower_method(ScanPattern, options, pattern_args, handle_number=self.handle_number)
        self.call_lower_method(ScanNumbers, options, numbers_args_1)

    def handle_radiant(self, options, args):
        self.twr_file = get_file(self.files['timing_seed_file'])
        if not self.twr_file:
            return
        self.raw_list = parse_twr_radiant(self.twr_file)
        self.parse_fmax = parse_fmax_radiant
        if not self.create_data_a():
            self.create_data_b()
        self.get_more_data()

        pattern_args = [
            {
                'file': self.files['timing_scoreHold_file'],
                'pattern': self.patterns['timing_scoreHold_pattern'],
                'keyword': 'scoreHold'
            },
            {
                'file': self.files['timing_scoreSetup_file'],
                'pattern': self.patterns['timing_scoreSetup_pattern'],
                'keyword': 'scoreSetup'
            },
        ]

        numbers_args_1 = [
            {
                'file': self.files['timing_totalloads_file'],
                'pattern_1': self.patterns['timing_totalloads_pattern'],
                'start_pattern': 'Number of clocks:\s+(\d+)',
                'stop_pattern': 'Number of',
                'operator': 'sum',
                'keyword': 'totalLoads',
            },
            {
                'file': self.files['timing_maxloads_file'],
                'pattern_1': self.patterns['timing_maxloads_pattern'],
                'start_pattern': 'Number of clocks:\s+(\d+)',
                'stop_pattern': 'Number of',
                'operator': 'max',
                'keyword': 'maxLoads',
            },
        ]

        self.call_lower_method(ScanPattern, options, pattern_args, handle_number=self.handle_number)
        self.call_lower_method(ScanNumbers, options, numbers_args_1)

    def get_more_data(self):
        p1 = re.compile(self.patterns['timing_constraint_coverage_pattern'])
        p2 = re.compile(self.patterns['timing_total_neg_slack_setup_pattern'])
        p3 = re.compile(self.patterns['timing_total_neg_slack_hold_pattern'])
        p_loop = re.compile(self.patterns['timing_CombineLoop_pattern'])
        loop_no = 0
        for line in open(self.twr_file):
            line = line.strip()
            m1 = p1.search(line)
            if m1:
                self.out({"constraint_coverage": m1.group(1)})
            else:
                m2 = p2.search(line)
                m3 = p3.search(line)
                if m2:
                    self.out({"total_neg_slack_setup": m2.group(1)})
                if m3:
                    self.out({"total_neg_slack_hold": m3.group(1)})
                else:
                    m_loop = p_loop.search(line)
                    if m_loop:
                        loop_no += 1
        self.out({'CombineLoop': str(loop_no)})

    def create_data_a(self):
        tfl = list()
        for item in self.raw_list:
            new_item = self.parse_fmax(item)
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
            self.out({"fmax": get_simple_digit_str(_got_it["fmax"])})
            self.out({"targetFmax": get_simple_digit_str(_got_it.get("targetFmax"))})
            self.out({"clkName": _got_it["clkName"]})
            self.clkname = _got_it['clkName']
            self.out({"logic_level": _got_it["logic_level"]})
            self.out({"pap": "%.3f%%" % (100*_got_it["pap"])})
            if 'fmax_type' in _got_it:
                self.out({'fmax_type': _got_it['fmax_type']})
        else:
            return 1

    def create_data_b(self):
        p_route_logic = re.compile(self.patterns['timing_route_logic_pattern'], re.X)
        p_path_delay = re.compile(self.patterns['timing_path_delay_pattern'])
        p_arrive_time = re.compile(self.patterns['timing_arrive_time_pattern'])
        p1_start = re.compile(self.patterns['timing_setup_path_pattern'])
        p2_start = re.compile(self.patterns['timing_path_pattern'])
        start = _route_percent = _logic_percent = 0
        double_edge_list = list()
        for line in open(self.twr_file):
            if not start:
                m = p1_start.search(line)
                if m:
                    this_clk = m.group(2)
                    if this_clk == self.clkname:
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
                        self.out({"route_delay": get_simple_digit_str(_rd)})
                        self.out({"cell_delay": get_simple_digit_str(_cd)})
                        break
        double_edge_set = set(double_edge_list)
        lens = len(double_edge_set)
        if lens == 1:
            self.out({"doubleEdge": "No"})
        elif lens == 2:
            self.out({"doubleEdge": "Yes"})
        else:
            self.out({"doubleEdge": "Unknown"})

    def create_data_c(self):
        p_route_logic = re.compile(self.patterns['timing_route_logic_pattern'])
        p_fre_clk = re.compile('^Preference: FREQUENCY[^"]+"([^"]+)"')
        start = 0
        rpt_ob = open(self.twr_file)
        while True:
            line = rpt_ob.readline()
            if not line:
                break
            if not start:
                m_fre_clk = p_fre_clk.search(line)
                if m_fre_clk:
                    fre_clk = m_fre_clk.group(1)
                    if fre_clk == self.clkname:
                        start = 1
                continue
            m_lrl = p_route_logic.search(line)
            if m_lrl:
                self.out({"logic": m_lrl.group("logic")})
                self.out({"route": m_lrl.group("route")})
                delay_ns = float(m_lrl.group("delay"))
                self.out({"logic_level": m_lrl.group("level")})
                _cell_delay = delay_ns * remove_percent_to_float(m_lrl.group("logic")) / 100.0
                self.out({"cell_delay": "%.3f" % _cell_delay})
                _routing_delay = delay_ns * remove_percent_to_float(m_lrl.group("route")) / 100.0
                self.out({"route_delay": "%.3f" % _routing_delay})
                break


class ScanTimingFMAX(ScanTiming):
    def __init__(self):
        ScanTiming.__init__(self)
        self.pap = False


class ScanTimingPAP(ScanTiming):
    def __init__(self):
        ScanTiming.__init__(self)
        self.pap = True


class ScanResource(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_resource')
        self.descriptor = 'Resource'

    def handle_number(self, num):
        return get_simple_digit_str(float(num) / 2.0)

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns_1 = {}
        for f in self.files:
            if f.startswith('resource_'):
                keyword = re.search(r'resource_(.+?)_file', f).group(1)
                patterns_1[keyword] = {
                    'file': self.files[f],
                    'pattern': self.patterns[f.replace('file', 'pattern')],
                    'keyword': keyword
                }

        patterns_1['clkNumber']['flags'] = re.I
        patterns_1['clkEnNumber']['flags'] = re.I
        patterns_1['LSRNumber']['flags'] = re.I
        patterns_1.pop('CARRY')
        patterns_1.pop('clkMaxLoad')
        patterns_1.pop('clkEnMaxLoad')
        patterns_1.pop('LSRMaxLoad')

        patterns_2 = [
            {
                'file': self.files['resource_CARRY_file'],
                'pattern_1': self.patterns['resource_CARRY_pattern'][0],
                'pattern_2': self.patterns['resource_CARRY_pattern'][1],
                'operator': 'sum',
                'keyword': 'CARRY',
            },
        ]

        patterns_3 = [
            {
                'file': self.files['resource_clkMaxLoad_file'],
                'pattern_1': self.patterns['resource_clkMaxLoad_pattern'],
                'start_pattern': self.patterns['resource_clkMaxLoad_start_pattern'],
                'stop_pattern': self.patterns['resource_clkMaxLoad_stop_pattern'],
                'operator': 'max',
                'keyword': 'clkMaxLoadName',
                'keyword_num': 'clkMaxLoadNum',
            },
            {
                'file': self.files['resource_clkEnMaxLoad_file'],
                'pattern_1': self.patterns['resource_clkEnMaxLoad_pattern'],
                'start_pattern': self.patterns['resource_clkEnMaxLoad_start_pattern'],
                'stop_pattern': self.patterns['resource_clkEnMaxLoad_stop_pattern'],
                'operator': 'max',
                'keyword': 'clkEnMaxLoadName',
                'keyword_num': 'clkEnMaxLoadNum',
            },
            {
                'file': self.files['resource_LSRMaxLoad_file'],
                'pattern_1': self.patterns['resource_LSRMaxLoad_pattern'],
                'start_pattern': self.patterns['resource_LSRMaxLoad_start_pattern'],
                'stop_pattern': self.patterns['resource_LSRMaxLoad_stop_pattern'],
                'operator': 'max',
                'keyword': 'LSRMaxLoadName',
                'keyword_num': 'LSRMaxLoadNum',
            },
        ]
        self.call_lower_method(ScanPattern, options, patterns_1.values())
        self.call_lower_method(ScanNumbers, options, patterns_2, handle_number=self.handle_number)
        self.call_lower_method(ScanNumbers, options, patterns_3)


class ScanLSE(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_lse')
        self.descriptor = 'LSE'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns_1 = {}
        for f in self.files:
            if f.startswith('lse_'):
                keyword = re.search(r'^(.+?)_file', f).group(1)
                patterns_1[keyword] = {
                    'file': self.files[f],
                    'pattern': self.patterns[f.replace('file', 'pattern')],
                    'keyword': keyword,
                    'start_pattern': self.patterns['lse_start_pattern'],
                    'stop_pattern': self.patterns['lse_stop_pattern'],
                }
        patterns_1.pop('lse_ebr')
        patterns_1.pop('lse_carry')

        patterns_2 = [
            {
                'file': self.files['lse_ebr_file'],
                'pattern_1': self.patterns['lse_ebr_pattern'][0],
                'pattern_2': self.patterns['lse_ebr_pattern'][1],
                'keyword': 'lse_ebr',
                'operator': 'sum',
            }
        ]
        patterns_3 = [
            {
                'file': self.files['lse_ebr_file'],
                'pattern_1': self.patterns['lse_carry_pattern'][0],
                'pattern_2': self.patterns['lse_carry_pattern'][1],
                'keyword': 'lse_carry',
                'operator': 'max',
            }
        ]
        self.call_lower_method(ScanPattern, options, patterns_1.values())
        self.call_lower_method(ScanNumbers, options, patterns_2)
        self.call_lower_method(ScanNumbers, options, patterns_3)

        carry = even = odd = lut = 0
        for i in self.task_struct.stack:
            if 'lse_carry' in i:
                carry = int(i['lse_carry'])
            if 'lse_even' in i:
                even = int(i['lse_even'])
            if 'lse_lut4' in i:
                lut = int(i['lse_lut4'])
            if 'lse_odd' in i:
                odd = int(i['lse_odd'])
        if lut != 0:
            # lut = lut + 2 * carry - 2 * even - 3 * odd
            lut = lut + 2 * carry
        if carry != 0:
            # carry = 2 * carry - even - 2 * odd
            carry = carry
        for i in self.task_struct.stack:
            if 'lse_carry' in i:
                i['lse_carry'] = str(carry)
            if 'lse_lut4' in i:
                i['lse_lut4'] = str(lut)


class ScanPAR(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_par')
        self.descriptor = 'PAR'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns_1 = {}
        for f in self.files:
            if f.startswith('par_'):
                keyword = re.search(r'^(.+?)_file', f).group(1)
                patterns_1[keyword] = {
                    'file': self.files[f],
                    'pattern': self.patterns[f.replace('file', 'pattern')],
                    'keyword': keyword,
                    'start_pattern': self.patterns['par_start_pattern'],
                }
        patterns_1['par_signals'].pop('start_pattern')
        self.call_lower_method(ScanPattern, options, patterns_1.values())


class ScanCPU(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_cpu')
        self.descriptor = 'CPU Time'

    def handle_number(self, num):
        return time2secs(num)

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns_1 = {}
        for f in self.files:
            if f.startswith('cpu_'):
                keyword = re.search(r'cpu_(.+?)_file', f).group(1)
                patterns_1[keyword] = {
                    'file': self.files[f],
                    'pattern': self.patterns[f.replace('file', 'pattern')],
                    'keyword': keyword,
                }
        patterns_1.pop('synp_Time')
        patterns_1['Router_cpu_Time']['stop_pattern'] = self.patterns['cpu_router_stop_pattern']
        patterns_1['par_cpu_Time']['start_pattern'] = self.patterns['cpu_par_start_pattern']
        patterns_1['par_real_Time']['start_pattern'] = self.patterns['cpu_par_start_pattern']
        patterns_1['postsyn_real_Time']['start_pattern'] = self.patterns['cpu_postsyn_start_pattern']
        patterns_1['postsyn_real_Time']['stop_pattern'] = self.patterns['cpu_postsyn_stop_pattern']
        patterns_1['postsyn_cpu_Time']['start_pattern'] = self.patterns['cpu_postsyn_start_pattern']
        patterns_1['postsyn_cpu_Time']['stop_pattern'] = self.patterns['cpu_postsyn_stop_pattern']
        #
        run_pb_log = patterns_1["postsyn_cpu_Time"].get("file")
        log2sim_log = os.path.join(os.path.dirname(run_pb_log), "log2sim.log")
        patterns_1["log2sim_cpu_Time"] = dict(file=log2sim_log,
                                              pattern=r'Elapsed Time: ([\d\.]+)', keyword='log2sim_cpu_Time')
        patterns_1["backanno_cpu_Time"] = dict(file=run_pb_log, pattern=r'Total CPU Time:\s+(.+)',
                                               keyword='backanno_cpu_Time',
                                               start_pattern=r'backanno:\s+version')
        patterns_1["bitgen_cpu_Time"] = dict(file=run_pb_log, pattern=r'Total CPU Time:\s+(.+)',
                                             keyword='bitgen_cpu_Time',
                                             start_pattern='Bitstream generation complete')
        #

        self.call_lower_method(ScanPattern, options, patterns_1.values(), handle_number=self.handle_number)

        filename = get_file(self.files['cpu_synp_Time_file'])
        if filename:
            synp_cpu_Time, synp_real_Time = get_run_time(filename, self.patterns['cpu_synp_Time_pattern'])
            self.out({'synp_cpu_Time': synp_cpu_Time})
            self.out({'synp_real_Time': synp_real_Time})

        Total_cpu_time = 0
        Total_real_time = 0
        for i in self.task_struct.stack:
            if 'Placer_cpu_Time' in i or 'Router_cpu_Time' in i:
                continue
            else:
                for j in i:
                    if j.endswith('cpu_Time'):
                        Total_cpu_time += float(i[j])
                        if j == 'lse_cpu_Time':
                            Total_real_time += float(i[j])
                    elif j.endswith('real_Time'):
                        Total_real_time += float(i[j])
        self.out({'Total_cpu_time': get_simple_digit_str(Total_cpu_time)})
        self.out({'Total_real_time': get_simple_digit_str(Total_real_time)})
        # placer time and router time for Diamond
        if options['software'] != "diamond":
            return

        diamond_placer_time = -1
        diamond_router_time = -1
        for xx in self.task_struct.stack:
            if "Placer_cpu_Time" in xx:
                diamond_placer_time = xx["Placer_cpu_Time"]
            elif "Router_cpu_Time" in xx:
                diamond_router_time = xx["Router_cpu_Time"]
        if diamond_placer_time == -1 or diamond_router_time == -1:
            pass
        else:
            try:
                yy = "{} - {}".format(diamond_router_time, diamond_placer_time)
                yy = eval(yy)
                self.out(dict(Router_cpu_Time="{}".format(yy)))
            except Exception:
                pass


class ScanMemory(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_memory')
        self.descriptor = 'Memory'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns_1 = {}
        for f in self.files:
            if f.startswith('memory_'):
                keyword = re.search(r'memory_(.+?)_file', f).group(1)
                patterns_1[keyword] = {
                    'file': self.files[f],
                    'pattern': self.patterns[f.replace('file', 'pattern')],
                    'keyword': keyword,
                }
        patterns_1.pop('synp_peak_Memory')
        patterns_1.pop('postsyn_peak_Memory')

        patterns_2 = [
            {
                'file': self.files['memory_synp_peak_Memory_file'],
                'pattern_1': self.patterns['memory_synp_peak_Memory_pattern'],
                'operator': 'max',
                'keyword': 'synp_peak_Memory',
            }
        ]

        patterns_3 = [
            {
                'file': self.files['memory_postsyn_peak_Memory_file'],
                'pattern': self.patterns['memory_postsyn_peak_Memory_pattern'],
                'keyword': 'postsyn_peak_Memory',
                'start_pattern': self.patterns['memory_postsyn_peak_Memory_start_pattern'],
            }
        ]

        self.call_lower_method(ScanPattern, options, patterns_1.values())
        self.call_lower_method(ScanNumbers, options, patterns_2)
        self.call_lower_method(ScanPattern, options, patterns_3)


class ScanCoverage(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_coverage')
        self.descriptor = 'Coverage'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns = [
            {
                'file': os.path.join(options['tag_path'], "sim_rtl", "cover_report.txt"),
                'pattern': r'Total Coverage By [^:]+: ([\.\d]+%)',
                # Total Coverage By Instance (filtered view): 37.17%
                'keyword': 'rtl_sim_coverage',
            },

        ]
        self.call_lower_method(ScanPattern, options, patterns)


class ScanErrors(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_errors')
        self.descriptor = 'Errors'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns = [
            {
                'file': self.files['comments_mapComments_file'],
                'pattern': self.patterns['comments_mapComments_pattern'],
                'keyword': 'mapErrors',
            },
            {
                'file': self.files['comments_parComments_file'],
                'pattern': self.patterns['comments_parComments_pattern'],
                'keyword': 'parErrors',
            },
        ]
        self.call_lower_method(ScanPattern, options, patterns)


class ScanMilestone(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_milestone')
        self.descriptor = 'Milestone'
        self.milestone = ['Synthesis', 'Map', 'Par', 'BitGen']

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns = [
            {
                'file': self.files['milestone_Synplify_file'],
                'pattern': self.patterns['milestone_Synplify_pattern'],
                'keyword': 'Synplify',
            },
            {
                'file': self.files['milestone_LSE_file'],
                'pattern': self.patterns['milestone_LSE_pattern'],
                'keyword': 'LSE',
            },
            {
                'file': self.files['milestone_Map_file'],
                'pattern': self.patterns['milestone_Map_pattern'],
                'keyword': 'Map',
            },
            {
                'file': self.files['milestone_Par_file'],
                'pattern': self.patterns['milestone_Par_pattern'],
                'keyword': 'Par',
            },
        ]
        self.call_lower_method(ScanPattern, options, patterns)

        pre_result = {}
        while self.task_struct.stack:
            i = self.task_struct.stack.pop()
            pre_result = dict(pre_result, **i)
        if 'Synplify' in pre_result or 'LSE' in pre_result:
            pre_result['Synthesis'] = 'PASS'
        for s in self.milestone:
            if s in pre_result:
                self.out({s: 'PASS'})
            else:
                self.out({s: 'FAIL'})


class ScanSimulation(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self, name='scan_simulation')
        self.descriptor = 'Simulation'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        old_file = self.files['simulation_sim_time_file']
        root_folder = os.path.dirname(old_file)
        pattern1 = [
            {
                'file': self.files['simulation_sim_time_file'],
                'pattern': self.patterns['simulation_sim_time_pattern'],
                'start_pattern': self.patterns['simulation_sim_rtl_start_pattern'],
                'stop_pattern': self.patterns['simulation_sim_time_stop_pattern'],
                'keyword': 'sim_rtl_time',
            },
            {
                'file': self.files['simulation_sim_time_file'],
                'pattern': self.patterns['simulation_sim_time_pattern'],
                'start_pattern': self.patterns['simulation_sim_syn_start_pattern'],
                'stop_pattern': self.patterns['simulation_sim_time_stop_pattern'],
                'keyword': 'sim_syn_time',
            },
            {
                'file': self.files['simulation_sim_time_file'],
                'pattern': self.patterns['simulation_sim_time_pattern'],
                'start_pattern': self.patterns['simulation_sim_map_start_pattern'],
                'stop_pattern': self.patterns['simulation_sim_time_stop_pattern'],
                'keyword': 'sim_map_time',
            },
            {
                'file': self.files['simulation_sim_time_file'],
                'pattern': self.patterns['simulation_sim_time_pattern'],
                'start_pattern': self.patterns['simulation_sim_par_start_pattern'],
                'stop_pattern': self.patterns['simulation_sim_time_stop_pattern'],
                'keyword': 'sim_par_time',
            },

            {
                'file': os.path.join(root_folder, "sim_rtl", "run_sim_rtl.log"),
                'pattern': r"Elapsed time:\s*(\S+)",
                'start_pattern': r"Loading\s+work\.",
                'keyword': 'sim_rtl_cpu_time',
            },
            {
                'file': os.path.join(root_folder, "sim_syn_vlg", "run_sim_syn_vlg.log"),
                'pattern': r"Elapsed time:\s*(\S+)",
                'start_pattern': r"Loading\s+work\.",
                'keyword': 'sim_syn_vlg_cpu_time',
            },
            {
                'file': os.path.join(root_folder, "sim_map_vlg", "run_sim_map_vlg.log"),
                'pattern': r"Elapsed time:\s*(\S+)",
                'start_pattern': r"Loading\s+work\.",
                'keyword': 'sim_map_vlg_cpu_time',
            },
            {
                'file': os.path.join(root_folder, "sim_par_vlg", "run_sim_par_vlg.log"),
                'pattern': r"Elapsed time:\s*(\S+)",
                'start_pattern': r"Loading\s+work\.",
                'keyword': 'sim_par_vlg_cpu_time',
            },
            #
        ]
        # parse 'simstats' data
        _p = r"mem:\s+size\s+during\s+sim.+\s+([\d\.]+\s+\w+)"
        _sp = r"Loading\s+work\."
        _file = os.path.join(root_folder, "{0}", "run_{0}.log")
        for k in ("sim_rtl", "sim_syn_vlg", "sim_map_vlg", "sim_par_vlg"):
            pattern1.append(dict(file=_file.format(k), pattern=_p, start_pattern=_sp, keyword='{}_Memory'.format(k)))
        #
        pattern2 = [
            {
                'file': self.files['simulation_sim_tool_file'],
                'pattern_1': self.patterns['simulation_sim_active_tool_pattern'],
                'pattern_2': self.patterns['simulation_sim_active_version_pattern'],
                'pattern_3': self.patterns['simulation_sim_riviera_tool_pattern'],
                'pattern_4': self.patterns['simulation_sim_riviera_version_pattern'],
                'pattern_5': self.patterns['simulation_sim_questa_tool_pattern'],
                'pattern_6': self.patterns['simulation_sim_questa_version_pattern'],
                'pattern_7': self.patterns['simulation_sim_modelsim_tool_pattern'],
                'pattern_8': self.patterns['simulation_sim_modelsim_version_pattern'],
                'keyword': 'sim_tool',
                'join': '-',
            },
        ]

        self.call_lower_method(ScanPattern, options, pattern1)
        self.call_lower_method(ScanStrings, options, pattern2)


class ScanFileSize(ScanBasic):
    def __init__(self):
        super(ScanFileSize, self).__init__(name="scan_file_size")
        self.descriptor = 'File Size'

    def handle(self, options, args):
        eval('self.handle_' + options['software'])(options, args)

    def handle_diamond(self, options, args):
        self.handle_radiant(options, args)

    def handle_radiant(self, options, args):
        patterns = dict()
        patterns["syn_vm_size"] = ".vm"
        patterns["map_udb_size"] = "_map.udb"
        patterns["syn_vo_size"] = "_syn.vo"
        patterns["par_udb_size"] = ".udb"
        patterns["par_vo_size"] = "_vo.vo"
        patterns["export_bit_size"] = (".bin", ".bit")

        file_root_path = os.path.join(options['tag_path'], "*")
        design = options['design']
        for k, v in list(patterns.items()):
            if isinstance(v, str):
                v = [v]
            for foo in v:
                my_file = get_file(os.path.join(design, file_root_path, "*" + foo))
                if my_file:
                    self.out({k: str(round(os.path.getsize(my_file)/1024, 1))})   # KB
