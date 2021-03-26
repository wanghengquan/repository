import re


def parse_twr_radiant_old(twr_file):
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
                    _dict_list.append(dict(zip(title, real_t)))
                    _t = list()
            else:
                if line_list[0].count("-") > 40:
                    continue
                _t.append(line_list)
    if _t:
        real_t = ["".join([item[0] for item in _t])] + _t[-1][1:]
        real_t = [item.strip() for item in real_t]
        _dict_list.append(dict(zip(title, real_t)))
    return _dict_list


def parse_fmax_radiant(one_dict):
    return one_dict


def parse_fmax_diamond(one_dict):
    preference = one_dict.get("SDC Constraint") if 'SDC Constraint' in one_dict else None
    levels = one_dict.get("Levels")
    # Constraint = one_dict.get("Constraint")
    # Slack = one_dict.get("Slack")
    p_period = re.compile("-period\s*([\d\.]+)")
    if preference:
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
    if preference:
        m_clk_name = p_clk_name.search(preference)
        if m_clk_name:
            clk_name = re.sub("\s+", "", m_clk_name.group(2))
            t["clkName"] = clk_name
        else:
            return
    else:
        t['clkName'] = one_dict.get('clkName')
    # _cons = float(re.sub("ns", "", Constraint))
    # _slack = float(re.sub("ns", "", Slack))
    #
    # if period == _cons:
    #     t["fmax"] = 1000/ (_cons - _slack)
    # else:
    #     t["fmax"] = 1000/ (2 * (_cons - _slack))
    if 'fmax' in one_dict:
        t['fmax'] = float(one_dict.get('fmax'))
    else:
        try:
            t["fmax"] = float(re.sub("MHz", "", one_dict.get("Frequency")))
        except:
            return
    t["logic_level"] = levels
    if 'targetFmax' in one_dict:
        t['targetFmax'] = float(one_dict.get('targetFmax'))
    else:
        t["targetFmax"] = 1000.0 / period
    if 'fmax_type' in one_dict:
        t['fmax_type'] = one_dict['fmax_type']
    return t


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


def get_run_time(f, patterns):
    raw_time_list = list()
    for line in open(f):
        for p in patterns:
            m = p.findall(line)
            if m:
                raw_time_list.append(m)
    _t = dict()
    for i, item in enumerate(raw_time_list):
        foo_tuple = item[0]
        if foo_tuple[1] == "successful!":
            continue
        foo_key = foo_tuple[0]
        new_time = [float(time2secs(item)) for item in foo_tuple[1:]]
        if foo_key in ("syn_nfilter", "c_hdl"):
            _t[foo_key] = new_time
        elif foo_key in ("Mapper", ):
            previous_item_tag = raw_time_list[i - 1][0][0]
            if previous_item_tag in ("Pre-mapping", "Mapper"):
                _t[previous_item_tag] = new_time
    real_time, cpu_time = 0, 0
    for key, value in _t.items():
        real_time += value[0]
        cpu_time += value[1]
    return time2secs(cpu_time), time2secs(real_time)


def time2secs(time_str):
    try:
        time_str = float(time_str)
        return get_simple_digit_str(time_str)
    except:
        pass
    try:
        final_secs = 0
        new_time = re.split("\s+", time_str)
        day_hour_min_sec = {"days" : 24*3600, "hrs" : 3600, "mins" : 60, "secs" : 1}
        _keys = ("days", "hrs", "mins", "secs")
        if len(new_time) == 1: # 01:02:03:04 or 01h:02m:03s
            new_time = re.split(":", time_str)
            new_time = [re.sub("\s+", "", item) for item in new_time]
            new_time = [re.sub("\D", "", item) for item in new_time]
            new_time = [float(item) for item in new_time]
            dhms_dict = dict(zip(_keys[-len(new_time):], new_time))
        else:
            dhms_dict = dict.fromkeys(_keys, 0)
            for i, t in enumerate(new_time):
                if dhms_dict.has_key(t):
                    dhms_dict[t] = float(new_time[i-1])
        for key, value in day_hour_min_sec.items():
            my_value = dhms_dict.get(key)
            if my_value:
                final_secs += my_value * value
        return get_simple_digit_str(final_secs)
    except (KeyError, ValueError):
        return time_str


def get_hdl_type(p1, p2, f):
    p_type = re.compile(p1)
    p_excluded = re.compile(p2)
    type_in_file = set()
    with open(f) as one:
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
    return _



def remove_percent_to_float(a_string):
    new_string = re.sub("%", "", a_string)
    return float(new_string)