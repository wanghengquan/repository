import os
import re
from xTools import time2secs, get_file_line_count

__author__ = 'syan'

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
            elif key[0] == "m":
                self.m_func(key, rpt_file)

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

    def m_func(self, key, rpt_file):
        # for base dir name
        t_value = os.path.dirname(rpt_file)
        t_value = os.path.basename(t_value)
        self.data[key] = t_value
