import os
import sys
from statistics import geometric_mean
import shutil
import glob
from .scan_old import *
from collections import OrderedDict
from .scan_exceptions import CliIssue, PatternNotFound
from .scan_default import MAX_FMAX, SCAN_FMAX_END_CONSTRAINT, SCAN_FMAX_START_CONSTRAINT


def get_seed_folder(options):
    tag_path = os.listdir(options['tag_path'])
    tag_path.sort()
    seeds = OrderedDict()
    for real_name in ("fmax", "seed", "iteration"):   # find real name
        t_name = "Target_{}".format(real_name)
        for foo in tag_path:
            if foo.startswith(t_name):
                options['seed'] = real_name
                break
        else:
            continue
        break
    for folder in tag_path:
        if folder.startswith("Target_" + options['seed']):
            twr_file = get_file(os.path.join(options['tag_path'], folder, '*', '*.twr'))
            if not twr_file:
                continue
            if os.path.isfile(twr_file):
                seeds[folder] = get_fmax(twr_file, options['pap'], options['software'],
                                         fmax_sort=options.get("fmax_sort"), tag=options.get("tag"))
    max_target, max_fmax = None, 0
    for k, v in list(seeds.items()):
        try:
            float_v = float(v)
            if float_v > max_fmax:
                max_target = k
                max_fmax = float_v
        except Exception:
            pass
    if max_target:
        return seeds.get(max_target), max_target
    else:
        return "", ""


def get_config(args):
    conf_file = args['conf_file']
    top = os.path.join(args['top_dir'], args['design'])
    if conf_file is not None:
        configfile = os.path.join(top, conf_file)
        if os.path.isfile(configfile):
            return configfile
        else:
            configfile = os.path.join(sys.path[0], 'config', conf_file)
            if os.path.isfile(configfile):
                return configfile
    try:
        dirs = os.listdir(top)
    except Exception as e:
        dirs = []
        print(e)

    #configs = [os.path.join(top, d) for d in dirs
    #           if os.path.isfile(os.path.join(top, d)) and d.endswith('.scf')]
    configs = list()
    for foo in dirs:
        if foo == "scan_full.scf":   # try to use the latest one
            continue
        abs_foo = os.path.join(top, foo)
        if os.path.isfile(abs_foo) and foo.endswith(".scf"):
            configs.append(abs_foo)

    if not configs:
        print("Warning: No configure files found, use default config instead!")
        scan_full = os.path.join(top, 'scan_full.scf')
        if args['software'].lower() in ('radiant', 'diamond'):
            shutil.copy(os.path.join(sys.path[0], 'config/scan_full.scf'), scan_full)
            return scan_full
        else:
            raise CliIssue('--software=[radiant|diamond]')
    else:
        return configs[0]


def get_file(filename):
    files = glob.glob(filename)
    if not files:
        return None
#       raise FileNotExist('file ' + filename + ' not exist!')
    else:
        # Diamond will generate another twr file (xx_wrapper_lse.twr), try to omit it.
        is_yes = re.compile("Command Line:", re.I)
        if len(files) > 1:
            for foo in files:
                try:
                    with open(foo) as ob:
                        i = 0
                        for line in ob:
                            i += 1
                            if i > 100:
                                break
                            if is_yes.search(line):
                                return foo
                except:   # search udb file, not _syn|rtl|map.udb
                    for k in ("_syn.udb", "_rtl.udb", "_map.udb"):
                        if foo.endswith(k):
                            continue
                        if foo.endswith(".udb"):
                            return foo
        return files[0]  # update later if needed


def replace_tag(conf_file, args):
    if args.tag:
        with open(conf_file, 'r') as f:
            lines = f.readlines()

        with open(conf_file, 'w') as f:
            for line in lines:
                f.write(line.replace('*tag*', args.tag))


def get_fmax(twr_file, pap, software, tag, fmax_sort):
    if software == "radiant":
        parsed_twr = eval('parse_twr_'+software)(twr_file, fmax_sort, tag)
    else:
        parsed_twr = eval('parse_twr_' + software)(twr_file)
    parse_fmax = eval('parse_fmax_'+software)
    tfl = list()
    for item in parsed_twr:
        new_item = parse_fmax(item)
        if new_item:
            wang = "%s/%s" % (new_item.get("fmax"), new_item.get("targetFmax"))
            try:
                x = float("%.5f" % eval(wang))
            except:
                x = -1
            new_item["pap"] = x
            tfl.append(new_item)
    if tfl:
        if pap:
            peter = "pap"
        else:
            peter = "fmax"
        _fmax = [foo.get(peter) for foo in tfl]
        real_fmax = min(_fmax)
        real_idx = _fmax.index(real_fmax)
        _got_it = tfl[real_idx]
        return get_simple_digit_str(_got_it["fmax"])
    else:
        return None


def get_part_lines(f, start_pattern, stop_pattern, flags=None):
    while True:
        if start_pattern is None:
            break
        line = f.readline()
        if not line:
            return
        if not isinstance(line, str):
            try:
                line = str(line, encoding='utf-8')
            except UnicodeDecodeError:
                line = ""
        if flags:
            m = re.search(start_pattern, line, flags)
        else:
            m = re.search(start_pattern, line)
        if m:
            yield line.strip()
            break

    while True:
        line = f.readline()
        if line:
            if not isinstance(line, str):
                try:
                    line = str(line, encoding='utf-8')
                except UnicodeDecodeError:
                    line = ""
            line = line.strip()
            if stop_pattern:
                if flags:
                    m = re.search(stop_pattern, line, flags)
                else:
                    m = re.search(stop_pattern, line)
                if m:
                    return
                else:
                    yield line.strip()
            else:
                yield line.strip()
        else:
            return


def parse_twr_diamond(twr_file):
    raw_list = []
    start_pattern = re.compile("^Report\s+Summary")
    target_pattern = re.compile('FREQUENCY.+?"(?P<clkName>.+?)"[^\d]*?[\d\.]+.*?MHz[^\d-]*?(?P<targetFmax>[\d\.]+)'
                                '.*?MHz[^\d]*?(?P<fmax>[\d\.]+).*?MHz\|(?P<Levels>\d+)')
    stop_pattern = re.compile("^$")
    with open(twr_file, 'r') as f:
        target_lines = []
        for line in get_part_lines(f, start_pattern, stop_pattern):
            target_lines.append(line.replace(' ', '').strip())
    target_line = ''.join(target_lines)
    target = re.finditer(target_pattern, target_line)
    for p in target:
        raw_list.append(
            {
                'clkName': p.group('clkName'),
                'targetFmax': p.group('targetFmax'),
                'fmax': p.group('fmax'),
                'Levels': p.group('Levels')
            }
        )
    return raw_list


def get_part_lines_blocks(f, start_line, stop_line):
    tmp = []
    with open(f, 'r') as fp:
        while fp.readline():
            for l in get_part_lines(fp, start_line, stop_line):
                if l and not re.match(r'(-+|\++|\s+)', l):
                    tmp.append(l)
            yield tmp
            tmp = []


def get_twr_value_one_constraint(block, clk_info):
    tmp = {}
    fmax_type = 0
    patterns = {
        'SDC Constraint': re.compile(SCAN_FMAX_START_CONSTRAINT),
        'Original_period': re.compile(SCAN_FMAX_START_CONSTRAINT),
        'Timing Error': re.compile(r'^(?P<score>\d*).+?(?P<Timing_error>\d+).+?$'),
        'logic_level': re.compile(r'Logic Level\s+:\s+(?P<level>\d+)'),
        'mpw_cell': re.compile(r'MPW Cell\s+:\s+(?P<mpw_cell>.+?)$'),
        'mpw_period': re.compile(r'MPW Period\s+:\s+(?P<mpw_period>[.\-\d]+)\s*ns'),
        'setup_constraint': re.compile(r'Setup Constraint\s+:\s+(?P<setup_constraint>[.\-\d]+)\s*ns'),
        'slack': re.compile(r'Path Slack\s+:\s+(?P<slack>[.\-\d]+)\s*ns'),
    }
    sdc = block.pop(0)
    paths = block.pop(0)
    Frequency_c = None

    timing_error = patterns['Timing Error'].match(paths)
    if not timing_error:
        return
    clkname = patterns['Original_period'].search(sdc).group('clkname')
    Original_period = clk_info[clkname]
    tmp['targetFmax'] = 1000 / Original_period
    tmp['clkName'] = clkname

    for l in block:
        Logic_level = patterns['logic_level'].search(l)
        MPW_Cell = patterns['mpw_cell'].search(l)
        MPW_Period = patterns['mpw_period'].search(l)
        Target = patterns['setup_constraint'].search(l)
        Slack = patterns['slack'].search(l)

        if Logic_level:
            tmp['logic_level'] = Logic_level.group('level')
        if MPW_Cell and 'SEIO' in MPW_Cell.group('mpw_cell'):
            tmp['MPW Cell'] = MPW_Cell.group('mpw_cell')
        if 'MPW Cell' in tmp and MPW_Period:
            Frequency_c = 1000 / float(MPW_Period.group('mpw_period'))
        if Target:
            tmp['Target'] = float(Target.group('setup_constraint'))
        if Slack:
            tmp['Slack'] = float(Slack.group('slack'))
    if 'Target' not in tmp:
        return dict()
    if Original_period == tmp['Target']:
        freq_t = 1000 / (Original_period - tmp['Slack'])
    else:
        freq_t = 1000 / (Original_period - Original_period / tmp['Target'] * tmp['Slack'])
        fmax_type = 1
    if freq_t < 0:
        freq_t = MAX_FMAX
    if Frequency_c:
        if Frequency_c < freq_t:
            freq_t = Frequency_c
            fmax_type = 2

    tmp['Timing Error'] = timing_error.group('Timing_error')
    tmp['SDC Constraint'] = patterns['SDC Constraint'].search(sdc).group('Constraint')
    tmp['Items Scored'] = patterns['Timing Error'].match(paths).group('score')
    tmp['fmax'] = freq_t
    tmp['fmax_type'] = fmax_type
    return tmp


def get_clk_info(twr_file):
    clk_info = {}
    clk_pattern = re.compile(r'From\s*(?P<clk_name>.+?)\s*\|\s*Target\s*\|\s*(?P<period>[\d.\-]+)\s*ns.+?$')
    for clk_block in get_part_lines_blocks(twr_file, 'Single Clock Domain', 'Clock Domain Crossing'):
        for s in clk_block:
            p = clk_pattern.search(s)
            if p:
                clk_info[p.group('clk_name').strip()] = float(p.group('period'))
                break
    return clk_info


def parse_twr_radiant_old(twr_file):
    """
    1. Start from SCAN_FMAX_START_PRE
    2. Every constraint begin with SCAN_FMAX_START_CONSTRAINT
    3. End for every constraint SCAN_FMAX_END_CONSTRAINT
    4. Rules for fmax
        1)  If there is 0 path or endpoint/startpoint, ignore this clock constraint
        2)  If the constraint has path
            a.  If original period ==  Setup Constraint, Freq = 1000 / (original period - slack)
            b.  If original period !=  Setup Constraint, Weight freq = 1000 / (original period - original period/actual setup constraint * current slack)
            c.  If the MPW cell of Minimum Pulse Width Report is not SEIO18/SEIO33, Freq = 1000/MPW Period, if the MPW cell of Minimum Pulse Width Report is SEIO18/SEIO33, ignore this MPW.
            d.  Pick the min clock frequency for a/b and c as frequency of this constraint.
    :param twr_file:
    :return:
    """
    ret = []
    clk_info = get_clk_info(twr_file)
    for block in get_part_lines_blocks(twr_file, SCAN_FMAX_START_CONSTRAINT, SCAN_FMAX_END_CONSTRAINT):
        if block:
            values_for_one_constraint = get_twr_value_one_constraint(block, clk_info)
            if values_for_one_constraint:
                ret.append(values_for_one_constraint)
    return ret


def parse_twr_radiant(twr_file, sort_type="fmax", tag="_scratch"):
    """
    [
      {
        "targetFmax": 239.98080153587713,
        "clkName": "wr_n_x",
        "MPW Cell": "SEIO33_CORE",
        "logic_level": "2",
        "Target": 4.167,
        "Slack": 3.539,
        "Timing Error": "1",
        "SDC Constraint": "create_clock -name {wr_n_x} -period 4.167 [get_ports wr_n_x]",
        "Items Scored": "6",
        "fmax": 200.0,
        "fmax_type": 2
      },
      ..
    ]
    """
    sdc_lines = get_sdc_constraint_lines(twr_file)
    clock_target_slack_dict = get_clock_target_slack(twr_file)
    ret = list()
    p_name = re.compile(r"\s+-name\s+(\S+)")
    p_period = re.compile(r"\s+-period\s*(\S+)")
    for foo in sdc_lines:
        m_name = p_name.search(foo)
        m_period = p_period.search(foo)
        original_period = 0
        if m_period:
            original_period = float(m_period.group(1))
        if not m_name:
            continue
        my_raw_name = m_name.group(1)
        real_target_slack = clock_target_slack_dict.get(my_raw_name)
        if not real_target_slack:
            continue
        if not original_period:
            original_period = real_target_slack[0]
        _t = dict()
        _t["SDC Constraint"] = foo
        _t["targetFmax"] = 1000 / original_period
        my_name = my_raw_name.strip("{")
        my_name = my_name.strip("}")
        _t["clkName"] = my_name
        _t["Slack"] = real_target_slack[-1]
        # raw_fmax = 1000 / (real_target_slack[0] - real_target_slack[1])
        # fmax_offset = original_period / real_target_slack[0]
        # if fmax_offset > 1.2:
        #     fmax_offset = 2
        # else:
        #     fmax_offset = 1
        # _t["fmax"] = raw_fmax / fmax_offset
        _t["fmax"] = real_target_slack[3]
        _t["logic_level"] = real_target_slack[2]
        ret.append(_t)
    if sort_type == "geomean":
        geomean_data = dict()
        for k in ("SDC Constraint", "targetFmax", "clkName", "Slack", "logic_level"):
            geomean_data[k] = 0
        m = re.search("\W{}\W(\w+)\W".format(tag), twr_file)
        geomean_data["fmax_type"] = m.group(1) if m else ""
        raw_fmax_list = [foo.get("fmax") for foo in ret]
        geomean_data["fmax"] = geometric_mean(raw_fmax_list)
        return [geomean_data]
    else:
        return ret


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
    p_diamond_style_start = re.compile(r'SDC\s+Constraint\s+\|\s+Target\s+|\s+Slack\s+\|')
    clock_target_slack_dict = dict()
    p_clock = re.compile(r"-name\s+(\S+)")
    p_target_slack = re.compile(r"""\|\s+
                                    ([-\d.]+)\s+ns\s+\|\s+
                                    ([-\d.]+)\s+ns\s+\|\s+
                                    (\d+)\s+\|\s+""", re.X)
    p_new_content = re.compile(r"^[\s|]+$")
    real_lines = list()
    temp_line = ""
    with open(twr_file) as ob:
        start = False
        for line in ob:
            if not start:
                start = p_diamond_style_start.search(line)
            else:
                line = line.strip()
                if not line:
                    break
                if p_new_content.search(line):
                    temp_line = re.sub(r"\s*-(period|name)\s*", r" -\1 ", temp_line)
                    real_lines.append(temp_line)
                    temp_line = ""
                else:
                    temp_line += line
    if temp_line:
        real_lines.append(temp_line)
    for foo in real_lines:
        m_clock = p_clock.search(foo)
        if m_clock:
            now_clock = m_clock.group(1)
            clock_target_slack_dict[now_clock] = now_list = list()
            summary_list = re.split(r"\s*\|\s*", foo)
            _target, _slack, _levels, _frequency = summary_list[1], summary_list[2], summary_list[3], summary_list[5]
            if "ns" in _target and "ns" in _slack and "MHz" in _frequency:
                _ = [_target, _slack, _levels, _frequency]
                now_list.extend([to_int_or_float(item) for item in _])
    return clock_target_slack_dict


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
