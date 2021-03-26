import re
from xml.etree import ElementTree
from .xLog import print_always, print_error
from .xOS import not_exists

__author__ = 'syan'

class ParseDevkit:
    def __init__(self, xml_file):
        self.xml_file = xml_file
        self.devkit_dict = dict()
        self.p_sko = re.compile("""(?P<speed>\d+L*)       # speed
                                   (?P<short_pkg>\D+)     # short_pkg name
                                   (?P<pkg_int>\d+)       # pkg number
                                   (?P<short_opt>\w)      # short_opt name
                                """, re.X)

        self.opt_dict = dict(COM="Commercial", IND="Industrial", AUTO="Automotive")

    def initialize(self):
        if not_exists(self.xml_file, "Diamond Devfile"):
            return 1
        xml_parser = ElementTree.parse(self.xml_file)
        family_table = xml_parser.findall("/Family")
        for item in family_table:
            family_name = item.get("name")
            t_family = dict(family=family_name)
            for part_table in item.getchildren():
                part_name = part_table.get("name")
                part_dict = dict()
                part_dict.update(t_family)
                part_dict.update(part_table.attrib)
                ori_opt = part_dict.get("opt")
                if ori_opt:  # mush have opt item
                    part_dict["opt"] = self.opt_dict.get(ori_opt)
                    self.devkit_dict[part_name] = part_dict

    def _get_pty_sko(self, a_devkit):
        """
        sko --- S: speed   K: package   O: opt
        """
        pty_sko = dict()
        a_devkit = re.split("-", a_devkit)
        pty_sko["pty"] = "-".join(a_devkit[0:-1])
        m_sko = self.p_sko.search(a_devkit[-1])
        if not m_sko:
            print_error("Wrong spelling in DEVKIT %s" % a_devkit)
            return
        for item in ("speed", "short_pkg", "pkg_int", "short_opt"):
            t_value = m_sko.group(item)
            if item == "pkg_int":
                t_value = int(t_value)
            elif item == "speed":
                t_value = self._get_spd_list(t_value)
            pty_sko[item] = t_value
        return pty_sko

    def _get_spd_list(self, spd):
        """
        change original speed string: a). 8 --> (8, ""); b) 6L --> (6, "L")
        """
        spd_list = list(spd)
        try:
            spd = (int(spd), "")
        except ValueError:
            spd = (int(spd_list[0]), spd_list[1])
        return spd

    def _get_std_devkit(self, raw_devkit, no_doubt=False):
        if not raw_devkit:
            # print_error("No devkit specified")
            return
        devkit = raw_devkit.upper()
        #
        std_devkit = self.devkit_dict.get(devkit)
        if std_devkit:  # try and get the standard DEVKIT directly, Great!
            return std_devkit
        if no_doubt:  # don't find the closest devkit
            print_error("Unknown devkit %s" % raw_devkit)
            return
        #
        raw_pty_sko = self._get_pty_sko(devkit)
        if not raw_pty_sko:
            return

        # match pty name
        std_group = dict()
        for part, part_detail in list(self.devkit_dict.items()):
            if part_detail.get("pty") == raw_pty_sko.get("pty"):
                my_pty_sko = self._get_pty_sko(part)
                if not my_pty_sko: # never got here!
                    print_error("You MUST update scripts after checking the DiamondDevFile.xml file!")
                    return
                std_group[part] = [part_detail, my_pty_sko]
        if not std_group:
            print_error("Unknown pty name: %s in %s" %(raw_pty_sko.get("pty"), raw_devkit))
            return

        # get minimum difference number for package
        min_diff = 10000
        for part, part_detail in list(std_group.items()):
            my_diff = abs(part_detail[1].get("pkg_int") - raw_pty_sko.get("pkg_int"))
            if my_diff <= min_diff:
                min_diff = my_diff

        # match opt, speed and minimum difference number
        for part, part_detail in list(std_group.items()):
            std_pty_sko = part_detail[1]
            my_diff = abs(std_pty_sko.get("pkg_int") - raw_pty_sko.get("pkg_int"))
            if my_diff != min_diff:
                std_group.pop(part)  # Pop it!
                continue
            pop_it = 0
            for item in ("short_opt", "speed", "short_pkg"):
                if std_pty_sko.get(item) != raw_pty_sko.get(item):
                    pop_it = 1
                    break
            if pop_it:
                std_group.pop(part)

        len_std = len(std_group)
        if not len_std:
            print_error("Not found opt_name/speed/pkg_name for %s" % raw_devkit)
        elif len_std > 1:
            print_always("Warning. more than one standard devkit for %s" % raw_devkit)

        for part, part_detail in list(std_group.items()):
            print_always("Convert devkit %s --> %s" % (raw_devkit, part))
            return part_detail[0]
    p_short_pkg = re.compile("^\d+L*", re.I)
    def get_std_devkit(self, raw_devkit):
        devkit_detail = self._get_std_devkit(raw_devkit)
        if devkit_detail:
            # get short_pkg, which is used for generating Synplify project file
            _name = devkit_detail.get("name")
            _name = re.split("-", _name)
            _short_pkg = self.p_short_pkg.sub("", _name[-1])
            devkit_detail["short_pkg"] = _short_pkg
        return devkit_detail

if __name__ == "__main__":
    xml_file = r"..\..\conf\DiamondDevFile.xml"
    my_test = ParseDevkit(xml_file)
    my_test.initialize()
    print(my_test.get_std_devkit("LFEC10E-3UQ218I"))
    print(my_test.get_std_devkit("LCMXO2-2000HC-6BG226I"))
    print(my_test.get_std_devkit("LCMXO2-2000HC-5BG256I"))


