#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from .config import Environment
from .__default__ import Default, ConfigIssue
import re
from collections import OrderedDict
import time
import logging
from .history_funcs import get_message
import sys
import glob
from jira import JIRA
import shutil
from .pattern import FILE_PATTERNS


def get_valid_crs(cr_note):
    valid_crs = list()
    p_cr = re.compile(r"((SOF|DNG)-\d+)", re.I)
    m_all = p_cr.findall(cr_note)
    options = dict(server="http://jira",
                   basic_auth=Default.AUTHS[0])

    try:
        jira_api = JIRA(**options)
    except Exception as e:
        log('cr_note: Cannot Link to JIRA server')
        return list()

    done_statuses = ("Verified", "Closed")
    try:
        for (cr_name, cr_num) in m_all:
            cr_name = cr_name.upper()
            try:
                cr_status = jira_api.issue(cr_name)
                status = cr_status.fields.status.name
                if status in done_statuses:
                    log('cr_note: %-20s has been verified!' % cr_name)
                else:
                    valid_crs.append(cr_name)
                    log('cr_note: %-20s is a valid CR!' % cr_name)
            except Exception as e:
                log('cr_note: %-20s Not Exists!' % cr_name)
    finally:
        jira_api.close()
        return valid_crs


def order_cr(cr_list):
    _ = []
    for i in cr_list:
        _ += i.replace(' ', '').split(',')
    crs = list(set(_))

    def get_cr_numb(cr):
        cr_grep = re.compile(r'(^SOF-|^DNG-)(?P<numb>\d+)', re.I)
        p = cr_grep.match(cr)
        if p:
            return int(p.group('numb'))
        else:
            return -1

    return sorted(crs, key=get_cr_numb, reverse=True)


def get_designs(args):
    top = os.path.abspath(args.top_dir)
    if not os.path.isdir(top):
        raise ConfigIssue
    design = args.design
    designs = OrderedDict()
    set_log(top)
    if design:
        design = os.path.join(top, design)
        if not os.path.isdir(design):
            raise ConfigIssue
        conf_files = get_conf_files(design, args)
        designs[design] = conf_files
    else:
        design = get_dirs(top)
        for d in design:
            conf_files = get_conf_files(d, args)
            designs[d] = conf_files
    return designs


_KEYCRE = re.compile(r"%\(([^)]+)\)s")
_KEY_TEMP = "LATTE-LATTICE-LSCC-LSH"
def replace_tag(conf_file, args):
    lines = list()
    # add encoding for UnicodeDecodeError: 'gbk' codec can't decode byte 0x93 in position : illegal multibyte sequence
    with open(conf_file, "r", encoding="utf-8") as in_ob:
        for line in in_ob:
            lines.append(line)
    with open(conf_file, 'w') as f:
        for line in lines:
            if args.tag:
                line = line.replace('*tag*', args.tag)
            if "%" in line:
                if "%%" in line:
                    pass
                elif not _KEYCRE.search(line):   # same as Python2.7
                    line = re.sub("%", "%%", line)
            line = re.sub(r'\\r\\n', _KEY_TEMP, line)
            line = re.sub("\\r", "", line)
            line = re.sub(_KEY_TEMP, '\r\n', line)
            if line:
                f.write(line)

def get_category(args):
    preset_options = args.preset_options
    sections = []
    if preset_options == 'check_normal':
        return sections
    for key, value in list(FILE_PATTERNS.items()):
        if value['func'] and value['func'](preset_options) == 1:
            sections.append(key)
    return sections


def check_one_config(conf_file, args):
    from .method import PollMethods
    replace_tag(conf_file, args)
    env = Environment(conf_file, get_category(args))
    if env.isvalid_config():
        """ Build a schedule """
        sched = PollMethods(env)
        ret = sched.do()
        check_data_config = {'section_info': ret, 'case_info': env.conf_info}
        return check_data_config


def get_dirs(top):
    dirs = os.listdir(top)
    return [os.path.join(top, d) for d in dirs
            if os.path.isdir(os.path.join(top, d))]


def get_conf_files(top, args):
    """
    conf_file = args.def_conf
    if conf_file is not None:
        configfile = os.path.join(sys.path[0], 'config', conf_file)
        if os.path.isfile(configfile):
            return [configfile]
    """
    conf_file = args.conf_file
    configs = list()
    if conf_file is not None:
        _list = re.split(",", conf_file)
        for _ in _list:
            configfile = os.path.join(top, _)
            if os.path.isfile(configfile):
                configs.append(configfile)
            else:
                config_dev = os.path.join(sys.path[0], 'config', conf_file)
                if os.path.isfile(config_dev):
                    shutil.copy(config_dev, configfile)
                    configs.append(configfile)
                else:
                    raise ConfigIssue('Configure file {0} not found!'.format(_))
    if configs:
        return configs
    try:
        dirs = os.listdir(top)
    except Exception as e:
        dirs = []
        print(e)

    configs = [os.path.join(top, d) for d in dirs
               if os.path.isfile(os.path.join(top, d)) and d.endswith('.conf')]
    if not configs:
        log("Warning: No configure files found, use auto.conf instead!")
        trunk_cmd = args.case_command
        auto_conf = os.path.join(top, 'auto.conf')
        configs = [auto_conf]

        if '--run-par-trce' in trunk_cmd or args.partrce_check:
            conf = os.path.join(sys.path[0], 'config/par_trace_check.conf')
            with open(conf, 'r') as f:
                lines = f.readlines()
                lines.append('file=%s/*/*.twr\n' % args.tag)

        elif '--run-map ' in trunk_cmd or '--till-map' in trunk_cmd \
                or '--run-map-trce' in trunk_cmd or args.map_check:
            conf = os.path.join(sys.path[0], 'config/map_check.conf')
            with open(conf, 'r') as f:
                lines = f.readlines()
                lines.append('file=%s/*/*.mrp\n' % args.tag)

        elif args.lse_check or '--synthesis=lse' in trunk_cmd:
            conf = os.path.join(sys.path[0], 'config/lse.conf')
            with open(conf, 'r') as f:
                lines = f.readlines()
                lines.append('file=%s/*/synthesis.log\n' % args.tag)

        elif args.synp_check or '--synthesis-only' in trunk_cmd:
            conf = os.path.join(sys.path[0], 'config/synp.conf')
            with open(conf, 'r') as f:
                lines = f.readlines()
                lines.append('file=%s/*/*.srr\n' % args.tag)

        else:
            conf = os.path.join(sys.path[0], 'config/par.conf')
            with open(conf, 'r') as f:
                lines = f.readlines()
                lines.append('file=%s/*/*.par\n' % args.tag)

        with open(auto_conf, 'w') as f:
            f.writelines(lines)

    if Default.CHOSE_CONF_FILE_ALL or args.all_conf:
        return configs
    if Default.CHOSE_CONF_FILE_FIRST_ONE:
        return [configs[0]]


def start_check_flow(designs, args):
    check_data_design = OrderedDict()
    for design, conf_files in list(designs.items()):
        if len(conf_files) == 0:
            continue
        check_data_design[design] = {}
        os.chdir(design)
        for conf_file in conf_files:
            start_time = time.ctime()
            log(50 * '-' + ' check begin ' + 50 * '-', logging.INFO)
            log('begin to check: ' + conf_file, logging.INFO)
            r = check_one_config(conf_file, args)
            r['SOF'] = start_time
            end_time = time.ctime()
            r['EOF'] = end_time
            check_data_design[design][conf_file] = r
            log('end to check: ' + conf_file, logging.INFO)
        os.chdir(Default.BASE_PATH)
    return check_data_design


def show_check_data_detail(check_data_designs):
    for design, check_data_config in list(check_data_designs.items()):
        log('\n+- design : ' + design)
        for conf_file, check_data_section in list(check_data_config.items()):
            log('+\n+-- config file : ' + conf_file)
            section_info = check_data_section['section_info']
            case_info = check_data_section['case_info']
            start_time = check_data_section['SOF']
            end_time = check_data_section['EOF']
            log(start_time)
            for key_case, value_case in list(case_info.items()):
                log('+---- ' + key_case + ' : ' + value_case)
            for key_sec, value_sec in list(section_info.items()):
                log('+\n+-------- ' + str(key_sec))
                for key, value in list(value_sec.items()):
                    log('+-------------------- ' + key + ': ' + str(value))
            log(end_time)


def show_check_data_simply(check_data_designs):
    log('\n' + 50*'-' + ' report begin ' + 50*'-', logging.INFO)
    for design, check_data_config in list(check_data_designs.items()):
        log('\nBegin to check case: ' + design)
        for conf_file, check_data_section in list(check_data_config.items()):
            log('Begin to check config: ' + conf_file)
            section_info = check_data_section['section_info']
            case_info = check_data_section['case_info']
            start_time = check_data_section['SOF']
            end_time = check_data_section['EOF']
            log(start_time)
            for key, value in list(section_info.items()):
                log('Come Into the ' + str(key))
                r = 'pass' if value['result'] else 'fail'
                log('In ' + str(key) + ': ' + r)
            if case_info['logic_result']:
                log(case_info['logic_result'])
            log('End check data: ' + end_time)


def get_status_from_check_data(check_data_designs):
    status = {}
    for design, check_data_config in list(check_data_designs.items()):
        for conf_file, check_data_section in list(check_data_config.items()):
            section_info = check_data_section['section_info']
            case_info = check_data_section['case_info']
            status[design + '&&' + conf_file] = True, case_info
            for method, sections in list(section_info.items()):
                if sections['result'] is False:
                    status[design + '&&' + conf_file] = False, method, case_info
    return status


def get_section_result(check_result):
    final_result = OrderedDict()
    for name, results in list(check_result.items()):
        if results[0]:
            final_result[name] = 'Passed', None
        elif not results[1] or results[2] == '0':
            final_result[name] = 'Failed', None
        else:
            valid_crs = get_valid_crs(results[1])
            if valid_crs:
                final_result[name] = 'SW_Issue', valid_crs
            else:
                final_result[name] = 'Failed', None
    return final_result


def get_logic_result(condition, results):
    ops = Default.OPs
    priority = Default.PRIORITY
    if not condition:
        condition = '&&'.join(list(results.keys()))
    stack_numb = []
    stack_op = []
    stack_tmp = []
    result = re.split(r'(\(|\)|&&|\|\|)', condition.replace(' ', ''))
    for elem in result:
        elem = elem.strip()
        if not elem:
            continue
        if elem in ops:
            if stack_op and stack_op[-1] != '(':
                stack_tmp.append(stack_op.pop())
            stack_op.append(elem)
        elif elem == '(':
            stack_op.append(elem)
        elif elem == ')':
            out = stack_op.pop()
            while out != '(':
                stack_tmp.append(out)
                out = stack_op.pop()
        else:
            if elem not in list(results.keys()):
                stack_tmp.append((priority['NA'], 'NA'))
            elif results[elem][0].startswith('Passed'):
                stack_tmp.append((priority['Passed'], results[elem]))
            elif results[elem][0].startswith('SW_Issue'):
                stack_tmp.append((priority['SW_Issue'], results[elem]))
            elif results[elem][0] == 'Failed':
                stack_tmp.append((priority['Failed'], results[elem]))
    while stack_op:
        stack_tmp.append(stack_op.pop())

    for elem in stack_tmp:
        if isinstance(elem[0], int):
            stack_numb.append(elem)
        else:
            numb1 = stack_numb.pop()
            numb2 = stack_numb.pop()
            stack_numb.append(calc(numb1, numb2, elem))
    if len(stack_numb) > 1:
        raise ConfigIssue('logic_result error! check your config file!')

    return stack_numb.pop()


def calc(num1, num2, op):
    numb1 = num1[0]
    numb2 = num2[0]
    if numb1 == numb2 == Default.PRIORITY['SW_Issue']:
        return num1[0], ('SW_Issue', list(set(num1[1][1] + num2[1][1])))
    elif numb2 >= 0 > numb1:
        return num2
    elif numb2 < 0 <= numb1:
        return num1
    elif numb1 < 0 and numb2 < 0:
        return -1, 'NA'
    elif op == '&&':
        return num1 if numb1 > numb2 else num2
    elif op == '||':
        return num1 if numb1 < numb2 else num2


def get_final_status(check_data_designs, args):
    #   ret = OrderedDict()
    my_final_status = list()
    for design, check_data_config in list(check_data_designs.items()):
        result = []
        all_cr = []
        all_defects = []
        """ In order to dump log for which one conf_file has non-passed status when using multi-conf files
            add a general set to save the failed file info
        """
        set_of_failed_in_file = set()

        for _, check_data_section in list(check_data_config.items()):
            real_file = os.path.relpath(_, design)
            section_info = check_data_section['section_info']
            logic_condition = check_data_section['case_info']['logic_result']
            cr_status = check_data_section['case_info']['cr_status']
            cr_note = check_data_section['case_info']['cr_note'] if str(cr_status) != '0' else None
            all_cr += [i.strip() for i in check_data_section['case_info']['cr_note'].split(',')]

            tmp_check_result = OrderedDict()
            check_shows = OrderedDict()
            for section_method, section_result in list(section_info.items()):
                tmp_check_result[section_method] = [section_result['result'], section_result['cr_note'],
                                                    section_result['cr_status']]
                check_shows[section_method] = section_result['show']
                all_cr += [i.strip() for i in section_result['cr_note'].split(',')]

            log_a_line(title='CR validation: {}'.format(os.path.basename(_)), start_new_line=True)

            final_section_result = get_section_result(tmp_check_result)

            try:
                final_result = get_logic_result(logic_condition, final_section_result)
            except Exception as e:
                raise ConfigIssue('logic_result error! check your config file!' + repr(e))

            if final_result[0] == Default.PRIORITY['Failed'] and cr_note:
                valid_crs = get_valid_crs(cr_note)
                if valid_crs:
                    final_result = (Default.PRIORITY['SW_Issue'], ('SW_Issue', valid_crs))
                if valid_crs:
                    all_defects.append(', '.join(valid_crs))

            if final_result[0] == Default.PRIORITY['NA']:
                raise ConfigIssue('logic_result error! check your config file!')

            result.append(final_result)

            check_results_shows = []
            if logic_condition:
                log_a_line(title='logic result', head='logic result', section=logic_condition)
            log_a_line(title='section_result')
            for name, final_sec_ret in list(final_section_result.items()):
                if final_sec_ret[0] != "Passed":
                    set_of_failed_in_file.add(real_file)
                new_name = name
                name_suffix = section_info.get(name, dict()).get("title", "")
                if name_suffix:
                    new_name += " ({})".format(name_suffix)  # add title description if exist
                if final_sec_ret[1]:
                    tmp = final_sec_ret[0] + '     ' + ': ' + ', '.join(final_sec_ret[1])
                    log_a_line(head='section result', section=new_name, result=tmp)
                    all_defects.append(', '.join(final_sec_ret[1]))
                else:
                    log_a_line(head='section result', section=new_name, result=final_sec_ret[0])
                if check_shows[name]:
                    check_results_shows.append(name[6:] + ':' + final_sec_ret[0])

            log_a_line(title='defects', head='defects', section=', '.join(order_cr(all_defects)))
            log_a_line(title='defects_history', head='defects_history',
                       section=', '.join(order_cr([i for i in all_cr if i])))
            if set_of_failed_in_file:
                failed_string = "; Dump-not-passed-file: {}".format(",".join(set_of_failed_in_file))
            else:
                failed_string = ""
            kc_string = ", ".join(check_results_shows)
            log_a_line(title='section show', head='key_check', section=kc_string + failed_string)

            flow_results = get_flow_result(design, args)
            flow_results_list = []
            if flow_results['synp'] or flow_results['lse']:
                flow_results_list.append('Synthesis:Passed')
            else:
                flow_results_list.append('Synthesis:Failed')
            if flow_results['map']:
                flow_results_list.append('Map:Passed')
            else:
                flow_results_list.append('Map:Failed')
            if flow_results['par']:
                flow_results_list.append('Par:Passed')
            else:
                flow_results_list.append('Par:Failed')
            if flow_results['download']:
                flow_results_list.append('Bitgen:Passed')
            else:
                flow_results_list.append('Bitgen:Failed')
            log_a_line(title='milestone', head='milestone', section=', '.join(flow_results_list))

            """ for one config """
            my_final_status.append(final_result)
    old_code = None
    final_status = None
    for (_code, _detail) in my_final_status:
        if old_code is None:
            old_code = _code
            final_status = (_code, _detail)
        elif _code > old_code:
            old_code = _code
            final_status = (_code, _detail)
    return final_status


def create_check_report(check_data_design, args):
    report_lines = ['Area,Type,Case, Device_syn,Result,Reason,Comments\n']
    status = get_status_from_check_data(check_data_design)
    for design_config, details in list(status.items()):
        design, config = design_config.split('&&')
        case = os.path.basename(design.rstrip('/'))
        caseinfo = details[-1]
        result = str(details[0])
        if not details[0]:
            reason = get_message(design)
            comments = find_a_error(config, args)
        else:
            reason = ''
            comments = config
        line_detail = caseinfo['area'] + ', ' + caseinfo['type'] + ', ' + case + ', ' + ', '
        line_detail += (result + ', ' + reason + ', ' + comments + '\n')
        report_lines.append(line_detail)

    with open(os.path.abspath(args.top_dir) + '/check_' +
              '_'.join(time.ctime().split()).replace(':', '_') + '.csv', 'w') as f:
        f.writelines(report_lines)


def find_a_error(config, args):
    check = os.path.abspath(args.top_dir) + '/check.log'
    with open(check, 'r') as f:
        for line in f.readlines():
            if config in line and 'ERROR' in line:
                return line.split('ERROR :')[-1].lstrip()
    return 'Check log file for details'


def set_log(top):
    filename = top + '/check.log'
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s :    %(message)s',
                        datefmt='%a, %d %b %Y %H:%M:%S',
                        filename=filename,
                        filemode='w')
    console = logging.StreamHandler()
    console.setLevel(100)
    formatter = logging.Formatter('%(message)s')
    console.setFormatter(formatter)
    logging.getLogger('').addHandler(console)


def log(msg, level=200):
    logging.log(level, msg)


def find_msg_in_file(msg, filename):
    ret = False
    with open(filename, 'r') as f:
        for line in f.readlines():
            if msg in line:
                ret = True
                break
    return ret


def get_index(line0, line1):
    if not (isinstance(line0, str) and isinstance(line1, str)):
        return None

    return int(line1.split('_')[-1]) - int(line0.split('_')[-1])


def find_str_in_file(string, filename, index=None, start=-1, grep=False):
    """
    :param string:
    :param filename:
    :param index: point a line where str should be
    :param start: from where search start
    :param grep: re pattern
    :return: line number if str found else None
    """
    string = string.replace(' ', '').strip()
    lines = try_to_get_lines_from_file(filename)
    if index is not None:
        if grep:
            if re.search(string, lines[index].replace(' ', '').strip()):
                return index
            else:
                return None
        else:
            if string in lines[index].replace(' ', '').strip():
                return index
            else:
                return None
    for num, line in enumerate(lines[start+1:], 0):
        if grep:
            if re.search(string, line.replace(' ', '').strip()):
                return num
        else:
            if string in line.replace(' ', '').strip():
                return num
    return None


def try_to_get_lines_from_file(a_file):
    lines = list()
    try:
        with open(a_file, 'r') as f:
            old_lines = f.readlines()
            for foo in old_lines:
                lines.append(foo)
    except UnicodeDecodeError:
        with open(a_file, 'rb') as f:
            old_lines = f.readlines()
            for foo in old_lines:
                try:
                    x = re.sub(b"\W", b"", foo)
                    x = str(x, encoding="utf-8")
                    lines.append(x)
                except UnicodeDecodeError:
                    pass
    return lines


def get_index_list_from_file_by_string(string, filename, index=None, start=-1, grep=False):
    """
    :param string:
    :param filename:
    :param index: point a line where str should be
    :param start: from where search start
    :param grep: use regular expression
    :return: index list
    """
    string = string.replace(' ', '').strip()
    lines = try_to_get_lines_from_file(filename)
    if index is not None:
        if grep:
            if re.search(string, lines[index].replace(' ', '').strip()):
                return [index]
            else:
                return None
        else:
            if string in lines[index].replace(' ', '').strip():
                return [index]
            else:
                return None
    index_list = list()
    for num, line in enumerate(lines[start+1:], 0):
        if grep:
            if re.search(string, line.replace(' ', '').strip()):
                index_list.append(num)
        else:
            if string in line.replace(' ', '').strip():
                index_list.append(num)
    if index_list:
        return index_list
    return None


def get_flow_result(design, args):
    os.chdir(design)
    if args.vendor == "radiant":
        from .method import CheckRadiantFlow as CheckFlow
    else:
        from .method import CheckDiamondFlow as CheckFlow
    check_flow = CheckFlow()
    all_flows = ['synp', 'lse', 'map', 'par', 'download']
    ret = OrderedDict()
    for flow in all_flows:
        check_flow.handle('', {'check_flow': flow, 'debug': True})
        ret[flow] = check_flow.ret
    os.chdir(Default.BASE_PATH)
    return ret


def log_a_line(head=None, section=None, result=None, title=None, start_new_line=False):
    if start_new_line:
        log("")
    if title:
        len_title_ = (100 - len(title)) / 2
        len_title_ = int(len_title_)
        log('-' * len_title_ + title + '-' * (100 - len_title_ - len(title)))
    if head:
        len_head_sp = (20 - len(head)) / 2
        len_head_sp = int(len_head_sp)
        msg = '<' + ' ' * len_head_sp + head + ' ' * (20 - len_head_sp - len(head)) + '>'
        msg += '    ' + section
        if result:
            msg += ' ' * (20 - len(section)) + ':' + '     ' + result
        log(msg)


def get_real_file(file_string, root_path):
    raw_string = re.sub(r"\\", "/", file_string)
    abs_file = os.path.relpath(raw_string, root_path)
    if os.path.isfile(abs_file):
        return abs_file
    _files = glob.glob(abs_file)
    if _files:
        return _files[0]


def string2re(raw_string, re_flag=None):
    if not raw_string:
        return None, None
    raw_string = raw_string.strip()
    if not raw_string:
        return None, None
    shorten_string = re.sub(r"\s+", "", raw_string)
    raw_string = re.sub(r"\s+", r"\\s+", raw_string)
    raw_string = re.sub(r'"', r'\"', raw_string)
    if re_flag:
        flag_str = ', {}'.format(re_flag)
    else:
        flag_str = ''
    raw_string = 're.compile("""{}"""{})'.format(raw_string, flag_str)
    return eval(raw_string), shorten_string


class GetStringFromFile(object):
    """Supported keys:
               file
               pattern | (pattern_1, pattern_2, ...)
               [before_pattern_$d]
               [default_value]
               [p_index | p_name]
               [p_flags]
        """
    def __init__(self, conf_file, section_dict):
        self.conf_file = os.path.abspath(conf_file)
        self.section_dict = section_dict

    def process(self):
        self.default_value = self.section_dict.get("default_value")
        self.p_index = self.section_dict.get("p_index")
        if self.p_index:
            self.p_index = int(self.p_index)
        self.p_name = self.section_dict.get("p_name")
        self.this_string = self.default_value
        if self.get_report_file():
            return
        if self.get_pattern_list():
            return
        if self.get_before_tag():
            return
        if self.parse_this_string():
            return

    def get_report_file(self):
        if "file" not in self.section_dict:
            raise ConfigIssue(" not found value for 'file'")
        self.report_file = get_real_file(self.section_dict.get("file"), os.path.dirname(self.conf_file))
        if not self.report_file:
            return 1

    def get_pattern_list(self):
        self.pattern_list = list()
        tmp_list = list()
        if "pattern" in self.section_dict:
            tmp_list.append(self.section_dict.get("pattern"))
        else:
            keys = list(self.section_dict.keys())
            keys.sort()
            for k in keys:
                v = self.section_dict.get(k)
                if k.startswith("pattern_"):
                    tmp_list.append(v)
        self.pattern_list = [string2re(item, self.section_dict.get("p_flags"))[0] for item in tmp_list]

    def get_before_tag(self):
        self.before_tag = list()
        p_before = re.compile(r"before_pattern_(\d+)")
        for k, v in list(self.section_dict.items()):
            m_before = p_before.search(k)
            if m_before:
                self.before_tag.append((int(m_before.group(1)),
                                        string2re(v)))
        if len(self.before_tag) > 1:
            raise ConfigIssue("no more than 1 before_pattern_$d can be specified.")

    def parse_this_string(self):
        if not self.before_tag:
            with open(self.report_file) as ob:
                for line in ob:
                    self.this_string = self._get_it(line)
                    if self.this_string:
                        return 
        else:
            search_window, start_pattern = self.before_tag[0]
            m_start = None
            with open(self.report_file) as ob:
                counter = 0
                for line in ob:
                    if not m_start:
                        m_start = start_pattern[0].search(line)
                        if m_start:
                            counter = 0
                    else:
                        counter += 1
                        if counter >= search_window:
                            m_start = None
                        self.this_string = self._get_it(line)
                        if self.this_string:
                            return

    def _get_it(self, line):
        for p in self.pattern_list:
            m = p.search(line)
            if m:
                if self.p_index:
                    return m.group(self.p_index)
                elif self.p_name:
                    return m.group(self.p_name)
                else:
                    return m.group(1)


def run_get_value_function(conf_parser, conf_file):
    value_dict = dict()
    for section_name in conf_parser.sections():
        m_get_value = Default.P_FUNCTION_GET_VALUE.search(section_name)
        if not m_get_value:
            continue
        value_name = m_get_value.group(1)
        section_dict = dict()
        for option_name in conf_parser.options(section_name):
            section_dict[option_name] = conf_parser.get(section_name, option_name)
        my_parser = GetStringFromFile(conf_file, section_dict)
        my_parser.process()
        value_dict[value_name] = my_parser.this_string
    return value_dict
