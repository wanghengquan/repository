#! --coding:utf-8--
import re
import csv
import copy
import utils
import xTools

__author__ = 'syan'

def get_raw_cases(case_csv):
    raw_cases_lines = dict()
    csv_ob = open(case_csv)
    old_group = 0
    for line in csv_ob:
        line = line.strip()
        if line.startswith("Order"):
            old_group += 1
        if old_group:
            if raw_cases_lines.has_key(old_group):
                raw_cases_lines[old_group].append(line)
            else:
                raw_cases_lines.setdefault(old_group, [line])
    raw_cases_dict = dict()
    for key, value in raw_cases_lines.items():
        new_value = csv.DictReader(value)
        raw_cases_dict[key] = new_value
    return raw_cases_dict

def get_macro(suite_csv):
    macro_dict = dict()
    necessary_dict = dict()
    key_sn = 0
    suite_csv_line_list = utils.get_no_title_csv_line_list(suite_csv)
    for line_list in suite_csv_line_list:
        key_word = line_list[0]
        if key_word == "END":
            break
        if key_word in ("project_id", "suite_name"):
            necessary_dict[key_word] = line_list[1]
        if key_word == "[macro]":
            key_sn += 1
            continue
        if key_sn:
            if macro_dict.has_key(key_sn):
                macro_dict[key_sn].append(line_list)
            else:
                macro_dict[key_sn] = [line_list]
    return macro_dict, necessary_dict

def _cmd2dict(raw_cmd):
    cmd_list = re.split("\s*;\s*", raw_cmd)
    _dict = dict()
    p = re.compile("([^=]+)=(.+)")
    for item in cmd_list:
        item = item.strip()
        if not item:
            continue
        m = p.search(item)
        if m:
            _dict[m.group(1).strip()] = m.group(2)
    return _dict

def merge_cmd(old_cmd, new_cmd):
    old_cmd_dict = _cmd2dict(old_cmd)
    new_cmd_dict = _cmd2dict(new_cmd)
    for key, value in old_cmd_dict.items():
        if new_cmd_dict.has_key(key):
            if key == "cmd":
                new_cmd_dict[key] = value + " " + new_cmd_dict.get(key)
            else:
                pass
        else:
            new_cmd_dict[key] = value
    new_line = list()
    for key, value in new_cmd_dict.items():
        new_line.append("%s = %s" % (key, value))
    return ";".join(new_line)

def remove_blanks(case):
    new_case = dict()
    for k, v in case.items():
        new_case[k.strip()] = v.strip()
    return new_case

def get_case_list(one_case, macro_dict):
    """
    match one macro, will create a case.
    not any match, will create a case.

    """
    case_list = list()
    p_equal = re.compile("=(.+)")
    has_changes = 0
    for key_sn, macro_list in macro_dict.items():
        new_case = copy.copy(one_case)
        for cat in macro_list:
            if len(cat) < 3:
                continue
            condition_or_action, key_word, expression = cat[0:3]
            if condition_or_action == "condition":
                case_value = new_case.get(key_word, "").strip()
                if not case_value:
                    break
                else:
                    m = p_equal.search(expression)
                    if m:
                        dragon = re.split("\s*;\s*", case_value)
                        if not m.group(1).strip() in dragon:
                            break
                        else:
                            new_case[key_word] = m.group(1).strip()
            elif condition_or_action == "action":
                new_case = execute_action(new_case, key_word, expression)
        if new_case != one_case:
            has_changes = 1
            case_list.append(new_case)
    if not has_changes:
        case_list.append(one_case)
    case_list = map(remove_blanks, case_list)
    return case_list


def execute_action(raw_dict, key_word, suite_content):
    new_dict = dict()
    for key, value in raw_dict.items():
        if key != key_word:
            new_dict[key] = value
            continue
        # key == key_word
        if key == "LaunchCommand":
            new_dict[key] = merge_cmd(value, suite_content)
        elif key in ("CaseInfo", "Environment", "Software", "System", "Machine"):
            value = value.strip()
            if not value:
                new_dict[key] = suite_content
            else:
                new_dict[key] = value
        else:
            new_dict[key] = suite_content
    return new_dict

def get_section_ini_lines(case_csv, suite_csv):
    """
    use updated section name in suite sheet if have

    """
    cases_dict = get_raw_cases(case_csv)
    macro_dict, necessary_dict = get_macro(suite_csv)
    section_dict = dict()
    for key, value in cases_dict.items():
        for one_case in value:
            if one_case.get("NoUse") == "YES":
                continue
            design_name = one_case.get("design_name")
            if not design_name:
                continue
            design_name = re.sub("//", "/", design_name)
            one_case["design_name"] = design_name
            case_dict_list = get_case_list(one_case, macro_dict)
            for item in case_dict_list:
                section_name = item.get("Section", "")
                if not section_name:
                    xTools.say_it("  Warning. Use default Section name for design: %s!" % design_name)
                    section_name = "Test Cases"
                my_case = "   %s %s %s" % (xTools.start_mark, item, xTools.end_mark)
                if section_dict.has_key(section_name):
                    section_dict[section_name].append(my_case)
                else:
                    section_dict[section_name] = list()
                    section_dict[section_name].append('[section %s]' % section_name)
                    for a, b in necessary_dict.items():
                        section_dict[section_name].append("%s = %s" % (a, b))
                    section_dict[section_name].append("case_list = %s" % my_case)
    return section_dict

if __name__ == "__main__":
    bb = get_section_ini_lines("test/case.csv", "test/suite.csv")
    for jj, mm in bb.items():
        for dog in mm:
            print dog
        print "---"







