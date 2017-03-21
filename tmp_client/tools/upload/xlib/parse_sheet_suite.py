import os
import re
import xTools

__author__ = 'syan'

def get_suite(suite_csv):
    start = 0
    old_key = ""
    suite_dict = dict()
    for line in open(suite_csv):
        line = line.strip()
        if line.startswith("END"):
            break
        if not start:
            if line.startswith("[suite_info]"):
                start = 1
        else:
            if line.startswith("["):
                break
            line_list = re.split("\s*,\s*", line)
            if line_list[0]:
                suite_dict[line_list[0]] = [line_list[1]]
                old_key = line_list[0]
            else:
                try:
                    if line_list[1]:
                        suite_dict[old_key].append(line_list[1])
                except IndexError:
                    pass
    return suite_dict

def create_suite_ini_lines(suite_csv):
    suite_dict = get_suite(suite_csv)
    ini_lines = list()
    suite_name = suite_dict.get("suite_name")
    if suite_name:
        suite_name = suite_name[0]
    else:
        print "Error. suite_name not specified!"
        return 1
    ini_lines.append("[suite %s]" % suite_name)
    description = list()
    des_keys = ["CaseInfo", "Environment", "LaunchCommand", "Machine", "Software", "System",]
    for key, value in suite_dict.items():
        if key == "suite_name":
            continue
        if key in des_keys:
            description.append("  %s[%s]%s" % (xTools.start_mark, key, xTools.end_mark))
            for foo in value:
                foo = foo.strip()
                if not foo:
                    continue
                pp = re.split("\s*;\s*", foo)
                for la in pp:
                    la = la.strip()
                    if la:
                        description.append("  %s%s%s" % (xTools.start_mark,la, xTools.end_mark))
        else:
            ini_lines.append("%s = %s" % (key, " ".join(value)))
    ini_lines.append("description = %s" % os.linesep.join(description))
    return ini_lines

if __name__ == "__main__":
    print create_suite_ini_lines(r"test\suite.csv")


