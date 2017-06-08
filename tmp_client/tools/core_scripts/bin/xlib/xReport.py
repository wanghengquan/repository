import re

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

def time2secs(time_str):
    """ Convert original time string to seconds
        For example:
            1 mins 27 secs --> 87
            00:01:17       --> 77
            1 hrs 7 mins 54 secs --> 4074
            0h:06m:10s     --> 3610
    """
    try:
        new_time = time_str.split()
        hms = ["hrs", "mins", "secs"]
        if len(new_time) == 1: # 00:01:17
            new_time = re.split(":", time_str)
            new_time = [re.sub("\D", "", item) for item in new_time]
            new_time = [int(item) for item in new_time]
            hms_dict = dict(zip(hms, new_time))
        else:
            hms_dict = dict.fromkeys(hms, 0)
            for i, t_hms in enumerate(new_time):
                if hms_dict.has_key(t_hms):
                    hms_dict[t_hms] = int(new_time[i-1])
        in_secs = 3600
        secs = 0
        for key in hms:
            secs += (in_secs * hms_dict[key])
            in_secs /=60
        return str(secs)
    except (KeyError, ValueError):
        return time_str

def file_simple_parser(a_file, patterns, but_lines_number=0):
    i = 0
    for line in open(a_file):
        line = line.strip()
        i += 1
        for p in patterns:
            m = p.findall(line)
            if m:
                return m
        if but_lines_number:
            if i > but_lines_number:
                break

class ScanBasic:
    def __init__(self, last_number=800):
        self.patterns = dict()
        self.last_number = last_number

    def _get_keys(self):
        keys = self.patterns.keys()
        keys.sort()
        try:
            keys.remove("stop")
        except ValueError:
            pass
        return keys

    def get_title(self):
        return [re.sub("^\S+\s+", "", item) for item in self.keys]

    def get_data(self):
        t_data = list()
        for item in self.keys:
            value = self.data.get(item)
            value = str(value)
            if re.search("time$", item, re.I):
                value = time2secs(value)
            t_data.append(value)
        return t_data

    def reset(self):
        self.keys = self._get_keys()
        self.data = dict.fromkeys(self.keys, "NA")

    def scan_report(self, rpt_file):
        self.reset()
        line_count = get_file_line_count(rpt_file)
        if not line_count:
            return
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
                for line in open(rpt_file):
                    line = line.strip()
                    if stop_pattern:
                        if stop_pattern.search(line):
                            break
                    self._parse_line(key, line)

    def _get_string(self, m_0):
        if type(m_0) is str:
            return m_0
        else:
            return "/".join(m_0)

    def _parse_line(self, key, line):
        pattern = self.patterns.get(key)
        pattern_type = type(pattern)
        if pattern_type is list:
            for p in pattern:
                m = p.findall(line)
                if not m:
                    continue

                got_string = self._get_string(m[0])
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
                got_string = self._get_string(m[0])
                self.data[key] = re.sub(",", "", got_string)

rpt_pattern = [
"Total Input Pins                10",
"Total Logic Functions           8 ",
"  Total Output Pins             8 ",
"  Total Bidir I/O Pins          0 ",
"  Total Buried Nodes            0 ",
"Total Flip-Flops                8 ",
"  Total D Flip-Flops            8 ",
"  Total T Flip-Flops            0 ",
"  Total Latches                 0 ",
"Total Product Terms             24",
"                                  ",
"Total Reserved Pins             0 ",
"Total Locked Pins               9 ",
"Total Locked Nodes              0 ",
"                                  ",
"Total Unique Output Enables     0 ",
"Total Unique Clocks             1 ",
"Total Unique Clock Enables      1 ",
"Total Unique Resets             0 ",
"Total Unique Presets            0 ",

]

class ScanClassicRpt(ScanBasic):
    def __init__(self):
        ScanBasic.__init__(self)
        self.create_new_patterns()

    def create_new_patterns(self):
        ii = 1
        for line in rpt_pattern:
            line = line.strip()
            if not line:
                continue

            line = line.split()
            if line[0] != "Total":
                continue
            # Zhilong. previous is 01, 02, .., 18
            # Now is 0001, 0002, .., 0018
            key = "%04d %s" % (ii, "_".join(line[1:-1]))
            ii += 1
            pattern = re.compile("%s\s+(\d+)" % "\s+".join(line[:-1]))
            self.patterns[key] = pattern
        # Macrocells                         32       20     12    -->    62
        self.patterns["0999 Macrocells"] = re.compile("Macrocells\s+\d+\s+(\d+)")

class ScanReport:
    def __init__(self, job_dir, design, tag_name):
        self.job_dir = job_dir
        self.design = design
        self.tag_name = tag_name

    def process(self):
        return











