#! -- coding: UTF-8 --

import os
import re
import traceback
import xTools
import csv

__author__ = 'syan'

def get_no_title_csv_line_list(csv_file, max_title=20):
    perhaps_titles = range(0, max_title)
    perhaps_titles = [str(item) for item in perhaps_titles]
    final_lines = list()
    final_lines.append(",".join(perhaps_titles))
    for line in open(csv_file):
        final_lines.append(line)
    csv_dict_list = list()
    my_reader = csv.DictReader(final_lines)
    for foo in my_reader:
        csv_dict_list.append([foo.get(bar) for bar in perhaps_titles])
    return csv_dict_list

def say_tb_error(debug=1):
    """
    print traceback error message.
    """
    if debug:
        traceback_string = traceback.format_exc()
        xTools.say_it(traceback_string, "", debug)

_boolean_states = {'1' : True,  'yes' : True,  'true'  : True,  'on' : True, '' : False,
                   '0' : False, 'no'  : False, 'false' : False, 'off': False}
def get_boolean(v):
    if v.lower() not in _boolean_states:
        raise ValueError, 'Not a boolean: %s' % v
    return _boolean_states[v.lower()]

def get_real_value(a_dict):
    b_dict = dict()
    for key, value in a_dict.items():
        if not value:
            continue
        if key.endswith("id") or key == "suite_mode":
            try:
                value = int(value)
            except ValueError:
                xTools.say_it("Error. please check %s:%s in %s" % (key, value, a_dict))
                return 1
        elif key in ("include_all", "show_announcement"):
            value = get_boolean(value)
        b_dict[key] = value
    return b_dict

def reorganize_conf_dict(conf_dict, support_list):
    new_conf_dict = dict((foo, list()) for foo in support_list)
    for section, section_dict in conf_dict.items():
        section = section.strip()
        section = section.split()
        _type, _name = section[0], " ".join(section[1:])
        if not _name:
            xTools.say_it("Error. Not found item name for %s" % section)
            return 1
        if _type in support_list:
            section_dict["name"] = _name
            new_section_dict = get_real_value(section_dict)
            if new_section_dict == 1:
                return 1
            new_conf_dict[_type].append(new_section_dict)
    return new_conf_dict


def get_suite_data(raw_data):
    suite_data = dict()
    for key, value in raw_data.items():
        if key in ("project_id", "project_name", "id"):
            continue
        suite_data[key] = value
    return suite_data

config_template = """[CaseInfo]
design_name = %s
"""
config_template_2 = """[LaunchCommand]
cmd = %s
"""

def get_type_id(type_string):
    """
    ## Types
    [{u'is_default': False, u'id': 1, u'name': u'Acceptance'},
    {u'is_default': False, u'id': 2, u'name': u'Accessibility'},
    {u'is_default': False, u'id': 3, u'name': u'Automated'},
    {u'is_default': False, u'id': 4, u'name': u'Compatibility'},
    {u'is_default': False, u'id': 5, u'name': u'Destructive'},
    {u'is_default': False, u'id': 6, u'name': u'Functional'},
    {u'is_default': False, u'id': 13, u'name': u'impl'},
    {u'is_default': True,  u'id': 7, u'name': u'Other'},
    {u'is_default': False, u'id': 8, u'name': u'Performance'},
    {u'is_default': False, u'id': 9, u'name': u'Regression'},
    {u'is_default': False, u'id': 10, u'name': u'Security'},
    {u'is_default': False, u'id': 11, u'name': u'Smoke & Sanity'},
    {u'is_default': False, u'id': 12, u'name': u'Usability'}]
    """

    type_dict = {'Acceptance'      : 1,
                 'Accessibility'   : 2,
                 'Automated'       : 3,
                 'Compatibility'   : 4,
                 'Destructive'     : 5,
                 'Functional'      : 6,
                 'impl'            : 13,
                 'Other'           : 7,
                 'Performance'     : 8,
                 'Regression'      : 9,
                 'Security'        : 10,
                 'Smoke'           : 11,  # Smoke replaced Smoke & Sanity
                 'Usability'       : 12,
                 'Manually'        : 13,
                 }
    code = type_dict.get(type_string)
    if type_string:
        if not code:
            xTools.say_it("Warning. Unknown type name: %s" % type_string)
    if not code:
        code = 6 # default is Functional
    return code

def get_priority_id(priority_string):
    """
    [{u'is_default': False, u'priority': 1, u'id': 1, u'short_name': u'Low', u'name': u'Low'},
    {u'is_default': True, u'priority': 2, u'id': 2, u'short_name': u'Medium', u'name': u'Medium'},
    {u'is_default': False, u'priority': 3, u'id': 3, u'short_name': u'High', u'name': u'High'},
    {u'is_default': False, u'priority': 4, u'id': 4, u'short_name': u'Critical', u'name': u'Critical'}]
    """
    priority_dict = {'Low' : 1,
                     'Medium' : 2,
                     'High' : 3,
                     'Critical' : 4,
                     }
    code = priority_dict.get(priority_string)
    if priority_string:
        if not code:
            xTools.say_it("Warning. Unknown priority name: %s" % priority_string)
    if not code:
        code = 2 # default is Medium
    return code

def create_case_data(raw_string):
    """
    {u'custom_fpga_pio': 45, u'type_id': 7, u'refs': None, u'priority_id': 2,
    u'custom_test_level': 1, u'created_on': 1471852816,
    u'custom_fpga_family': u'ecp5', u'milestone_id': None,
    u'title': u'test case 1', u'custom_fpga_slice': 100,
    u'custom_scenarios': None, u'created_by': 3, u'id': 78600,
    u'custom_config': u'[CaseInfo] \r\ndesign_name = yyy\r\n[LaunchCommand]\r\ncmd = xxx\r\n',
    u'custom_steps': None, u'updated_by': 3, u'section_id': 346,
    u'custom_description': None, u'custom_preconds': None,
    u'suite_id': 114, u'estimate_forecast': None,
    u'estimate': None, u'custom_expected': None,
    u'custom_fpga_flow': u'impl', u'custom_fpga_rtl': 1, u'updated_on': 1471852816}

   {'Machine': '', 'Slice': '', 'Title': 'simulation_flow/do_modelsim',
   'Section': 'simulation_flow', 'design_name': 'simulation_flow/do_modelsim',
   'Flow': '', 'System': '', 'Environment': '', 'Sorting': 'modelsim',
   'NoUse': '', 'TestScenarios': 'Different simulation test',
   'Type': 'Functional', 'LaunchCommand': 'cmd = --sim-all --sim-modelsim',
   'Software': 'modelsim=6.6d', 'CRs': '', 'Priority': 'Medium',
   'Description': 'Case demo and script regression case',
   'Family': '', 'PIO': '', 'CaseInfo': '', 'RTL': '',
   'TestLevel': '1', 'Update': '', 'Order': '20', 'Create': ''}

    """
    raw_dict = eval(raw_string)
    design_name = raw_dict.get("design_name")
    design_name = re.sub("//", "/", design_name)
    title = raw_dict.get("Title")
    if not title:
        title = design_name
    final_dict = dict()
    final_dict["title"] = title
    final_dict["type_id"] = get_type_id(raw_dict.get("Type", ""))
    final_dict["priority_id"] = get_priority_id(raw_dict.get("Priority", ""))

    int_values = [("custom_test_level", "TestLevel"),
                  ("custom_fpga_pio", "PIO"),
                  ("custom_fpga_slice", "Slice"),
                  ("custom_fpga_ebr", "EBR"),
                  ("custom_fpga_dsp", "DSP"),
                  ]
    for (db_column, column) in int_values:
        try:
            final_dict[db_column] = int(raw_dict.get(column))
        except (ValueError, TypeError):
            if db_column == "custom_test_level":
                final_dict[db_column] = 1

    string_text_values = [("Family", "custom_fpga_family"),
                          ("Flow", "custom_fpga_flow"),
                          ("Description", "custom_description"),
                          ("TestScenarios", "custom_scenarios"),]
    for (db_column, column) in string_text_values:
        item = raw_dict.get(db_column)
        if item:
            final_dict[column] = item

    rtl = raw_dict.get("RTL")
    _t_rtl = {"YES" : 1, "NO" : 2, "unknown" : 3}
    if rtl:
        _code =  _t_rtl.get(rtl)
        if _code:
            final_dict["custom_fpga_rtl"] = _code
    else:
        final_dict["custom_fpga_rtl"] = 3  # default is unknown

    testbench = raw_dict.get("TestBench")
    _t_testbench = {"YES": 1, "NO": 2, "unknown": 3}
    if testbench:
        _code = _t_testbench.get(testbench)
        if _code:
            final_dict["custom_test_bench"] = _code
    else:
        final_dict["custom_test_bench"] = 3  # default is unknown
    # /////////////////////
    # create custom_config
    lines = list()

    already_has_design_name = 0
    case_info = raw_dict.get("CaseInfo")
    lines.append("[CaseInfo]")
    if case_info:
        case_info = re.split("\s*;\s*", case_info)
        for hello in case_info:
            if re.search("design_name=", hello):
                already_has_design_name = 1
        lines += case_info
    if not already_has_design_name:
        lines.append("design_name = %s" % design_name)

    for key in ("Environment", "System", "LaunchCommand", "Software", "Machine"):
        value = raw_dict.get(key)
        if value:
            lines.append("[%s]" % key)
            pp = re.split("\s*;\s*", value)
            for la in pp:
                la = la.strip()
                if la:
                    lines.append(la)
    final_dict["custom_config"] = os.linesep.join(lines)
    # /////////////////////
    return final_dict
def string_to_int_list(raw_string):
    _list = re.split(",", raw_string)
    int_list = list()
    for item in _list:
        item = item.strip()
        if not item:
            continue
        int_list.append(int(item))
    return int_list

def update_dict(my_dict, key, value):
    if not my_dict.has_key(key):
        my_dict[key] = list()
    my_dict[key].append(value)







