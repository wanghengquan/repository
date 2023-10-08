import re
import os
import time
from . import xTools
import random
from xml.etree import ElementTree

__author__ = 'syan'

def create_diamond_dev_xml(xml_file):
    if os.path.isfile(xml_file):
        return
    # for NG flow, NG has not the file createdevfile
    sts, text = xTools.get_status_output("createdevfile")
    for item in text:
        if "is not recognized as an internal or external command" in item: # Windows
            return 1
        if "Command not found" in item: # Linux
            return 1
    create_cmd = "createdevfile -file %s" % xml_file
    sts = xTools.run_command(create_cmd, "create_dev_xml.log", "create_dev_xml.time")
    if sts:
        sts = xTools.wrap_cp_file("default.xml", xml_file)
    return sts

class DevkitParser:
    def __init__(self, xml_file):
        self.xml_file = xml_file
        self.devkit_dict = dict()
        self.p_sko = re.compile("""(?P<speed>\d+L*)       # speed
                                   (?P<short_pkg>\D+)     # short_pkg name
                                   (?P<pkg_int>\d+)       # pkg number
                                   (?P<short_opt>\w)      # short_opt name
                                """, re.X)

        self.opt_dict = dict(COM="Commercial", IND="Industrial", AUTO="Automotive")

    def process(self):
        if not os.path.isfile(self.xml_file):
            if self.create_dev_xml_file():
                return 1
        else:
            # check the xml file, make sure its ok
            while 1:
                sts = xTools.simple_parser(self.xml_file, [re.compile("</DiamondDevKit>")], but_lines=3)
                if not sts:
                    xTools.say_it("check %s after 15 seconds" % self.xml_file)
                    time.sleep(15)
                    continue
                break
        xml_parser = ElementTree.parse(self.xml_file)
        family_table = xml_parser.findall("Family")
        for item in family_table:
            family_name = item.get("name")
            family_text = item.get("text")
            t_family = dict(family=family_name, text=family_text)
            try:
                real_data = item.getchildren()  # python 3.8
            except AttributeError:
                real_data = item  # python 3.10
            for part_table in real_data:
                part_name = part_table.get("name")
                part_dict = dict()
                part_dict.update(t_family)
                part_dict.update(part_table.attrib)
                ori_opt = part_dict.get("opt")
                if ori_opt:  # mush have opt item
                    part_dict["ori_opt"] = ori_opt
                    part_dict["opt"] = self.opt_dict.get(ori_opt)
                    self.devkit_dict[part_name] = part_dict

    def create_dev_xml_file(self):
        xml_file = xTools.win2unix(self.xml_file)
        xml_path = os.path.dirname(xml_file)
        recov = xTools.ChangeDir(xml_path)
        lock_file = "gen_xml.lock"
        sts = xTools.run_safety(create_diamond_dev_xml, lock_file, xml_file)
        while True:
            if not os.path.isfile(lock_file):
                break
            try:
                os.remove(lock_file)
                break
            except OSError:
                xTools.say_it("Try to remove %s in %s" % (lock_file, os.getcwd()))
                time.sleep(3)
        recov.comeback()
        return sts

    def _get_pty_sko(self, a_devkit):
        """
        sko --- S: speed   K: package   O: opt
        """
        pty_sko = dict()
        a_devkit = re.split("-", a_devkit)
        pty_sko["pty"] = "-".join(a_devkit[0:-1])
        m_sko = self.p_sko.search(a_devkit[-1])
        if not m_sko:
            xTools.say_it("Wrong spelling in DEVKIT %s" % a_devkit)
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
            xTools.say_it("Unknown devkit %s" % raw_devkit)
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
                    xTools.say_it("You MUST update scripts after checking the DiamondDevFile.xml file!")
                    return
                std_group[part] = [part_detail, my_pty_sko]
        if not std_group:
            xTools.say_it("Unknown pty name: %s in %s" %(raw_pty_sko.get("pty"), raw_devkit))
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
            xTools.say_it("Not found opt_name/speed/pkg_name for %s" % raw_devkit)
        elif len_std > 1:
            xTools.say_it("Warning. more than one standard devkit for %s" % raw_devkit)

        for part, part_detail in list(std_group.items()):
            xTools.say_it("Convert devkit %s --> %s" % (raw_devkit, part))
            return part_detail[0]
    p_short_pkg = re.compile("^\d+L*", re.I)
    p_family_name = re.compile("lattice", re.I)
    def get_std_devkit(self, devkit):
        devkit_detail = self._get_std_devkit(devkit)
        if not devkit_detail:
            # re-generate the xml file and try to get the right settings
            old_xml_file = self.xml_file
            self.xml_file += ".%d" % random.randint(1, 100000)
            self.process()
            devkit_detail = self._get_std_devkit(devkit)
            if devkit_detail:
                while True:
                    if xTools.wrap_cp_file(self.xml_file, old_xml_file, force=True):
                        time.sleep(3)
                    else:
                        break
            os.remove(self.xml_file)

            self.xml_file = old_xml_file

        if devkit_detail:
            # get short_pkg, which is used for generating Synplify project file
            _name = devkit_detail.get("name")
            _name = re.split("-", _name)
            _short_pkg = self.p_short_pkg.sub("", _name[-1])
            devkit_detail["short_pkg"] = _short_pkg
            devkit_detail["short_pty"] = re.sub("-", "_", devkit_detail.get("pty"))
            _family = devkit_detail.get("family")
            if self.p_family_name.search(_family):
                _family = _family.upper()
                _family = re.sub("LATTICE", "LATTICE-", _family)
            devkit_detail["short_family"] = _family

        return devkit_detail

if __name__ == "__main__":
    my_test = DevkitParser(r"D:\new_scripts\merge\conf\DiamondDevFile.xml")
    my_test.process()
    t = my_test.get_std_devkit("LCMXO2-1200HC-4MG132C")
    xTools.say_it(t)
