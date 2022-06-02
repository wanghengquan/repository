
from .__default__ import ALL_METHODS, Default, SectionInfo, ConfigIssue
import os
from collections import OrderedDict
from .tools import log, get_index, find_str_in_file, get_index_list_from_file_by_string
import logging
import glob
import re
import hashlib
from .history_funcs import check_sdf, compare_par
import unittest
import difflib
from . import tools


class Method(object):
    """
        All your own method should be applied here.
        New method is son of Method. It should have a handle function.
        It has two parameters: task and section.
        task is the things write in config file in method section with value not be '0', such as : 'check_lines_1', etc.
        section is a dict contains specific info, such as {'file': './', 'check_1': 'PASS'}, etc.
        task must start with func_name.
    """
    def __init__(self):
        self.__name__ = None
        self.section_infos = []
        self.conf = ''
        self.show = False
        self.ret = Default.PASS

    def must_have_param(self, section, params):
        all_have = True
        for p in params:
            if p not in section:
                self.log_error('Parameter {0} not set, please set first!'.format(p))
                all_have = False
        return all_have

    def plugin(self):
        ALL_METHODS.append(self)

    def plugout(self):
        try:
            ALL_METHODS.remove(self)
        except ValueError as e:
            log(e, logging.ERROR)

    def do(self, queue, env):
        #empty = queue.empty()
        self.section_infos = OrderedDict()
        self.env = env
        self.conf = env.conf_file

        while not queue.empty():
            self.ret = Default.PASS
            section_info = SectionInfo().sectioninfo()
            task = queue.get()

            try:
                section = env.conf_sections[task]
            except Exception as e:
                section = None
                self.log_error(repr(e))

            for key, _ in list(section_info.items()):
                if key in list(section.keys()):
                    section_info[key] = section[key]
            log('-------- ' + task, logging.INFO)

            try:
                self.pre_handle(task, section)
            except ConfigIssue as e:
                raise ConfigIssue(e.msg)
            except Exception as e:
                self.ret = Default.FAIL
                self.log_error(repr(e))

            section_info['result'] = self.ret
            section_info['show'] = self.show
            self.section_infos.update({task: section_info})

        return self.section_infos  # , empty

    def pre_handle(self, task, section):
        if 'show' in list(section.keys()) and section['show'] != '0':
            self.show = True
        self.handle(task, section)

    def handle(self, task, section):
        return

    @staticmethod
    def log_error(msg):
        msg = '            ' + msg
        logging.error(msg)

    @staticmethod
    def log_info(msg):
        msg = '             ' + msg
        logging.info(msg)


class PollMethods:
    """ Schedule """
    def __init__(self, env):
        self.env = env

    def do(self):
        check_data_section = OrderedDict()
        for task_method, task_queue in list(self.env.conf_tasks.items()):
            #r, empty = task_method.do(task_queue, self.env)
            if not task_queue.empty():
                r = task_method.do(task_queue, self.env)
                check_data_section.update(r)
        return check_data_section


def get_using_simulation_tool(log_file):
    p_tools = dict(questasim=re.compile("QuestaSim.+Compiler", re.I),
                   modelsim=re.compile(r"\s+ModelSim\s+", re.I),
                   riviera=re.compile("Aldec.+RIVIERA", re.I),
                   activehdl=re.compile("active.+vsim", re.I),
                   )
    with open(log_file) as ob:
        for line in ob:
            for k, v in list(p_tools.items()):
                if v.search(line):
                    return k
    return "modelsim"


class CheckSimulationFlow(Method):
    def __init__(self):
        super(CheckSimulationFlow, self).__init__()
        self.__name__ = "check_simulation_flow"
        self.valid_choices = ("rtl",
                              "syn_vlg", "syn_vhd",
                              "map_vlg", "map_vhd",
                              "par_vlg", "par_vhd")

    def handle(self, task, section):
        self.ret = Default.FAIL
        will_check_flow_list = section.get("check_flow")
        self.section = section
        if will_check_flow_list:
            will_check_flow_list = re.split(",", will_check_flow_list)
        else:
            raise ConfigIssue(task + " have no value for key 'check_flow'")
        for chk_name in will_check_flow_list:
            chk_name = chk_name.strip()
            if not chk_name:
                continue
            if chk_name not in self.valid_choices:
                self.log_error("Warning. Unknown name {} for {}".format(chk_name, self.__name__))
                continue
            self.check_files(chk_name)
            if self.ret == Default.FAIL:
                return
        self.ret = Default.PASS

    def check_files(self, chk_name):
        if self.get_log_file(chk_name):
            return 1
        use_grep = True if self.section.get("use_grep", "") == "1" else False
        simulation_tool = get_using_simulation_tool(self.log_file)
        if simulation_tool in ("activehdl", "riviera"):
            default_pass = "VSIM: Simulation has finished"
            pass_list = list()
            for k, v in list(self.section.items()):
                if k.startswith("asim_pass"):
                    pass_list.append(v)
            if not pass_list:
                pass_list.append(default_pass)
            tmp_ret = [find_str_in_file(item, self.log_file, grep=use_grep) for item in pass_list]
            if None in tmp_ret:
                self.ret = Default.FAIL
            else:
                self.ret = Default.PASS
        else:
            default_failed_list = [re.compile(r"#\s+\*\*\s+Error:"),
                                   re.compile(r"Error\s+loading\s+design"),
                                   re.compile(r"#\s+Errors:\s+[1-9]")]
            customer_failed_list = list()
            for k, v in list(self.section.items()):
                if k.startswith("msim_fail"):
                    customer_failed_list.append(v)
            if customer_failed_list:
                for foo in customer_failed_list:
                    ret = find_str_in_file(foo, self.log_file, grep=use_grep)
                    if ret:
                        self.ret = Default.FAIL
                        return
            else:
                for foo in default_failed_list:
                    with open(self.log_file) as ob:
                        for line in ob:
                            if foo.search(line):
                                self.ret = Default.FAIL
                                return
            self.ret = Default.PASS

    def get_log_file(self, chk_name):
        log_file_key = "{}_file".format(chk_name)
        log_file = self.section.get(log_file_key, "_scratch/sim_{0}/run_sim_{0}.log".format(chk_name))
        if not os.path.isfile(log_file):
            log_files = glob.glob(log_file)
            if not log_files:
                self.log_error("Not found file: {}".format(log_file))
                self.ret = Default.FAIL
                return 1
            else:
                log_file = log_files[0]
        self.log_file = log_file


class CheckValue(Method):
    def __init__(self):
        super(CheckValue, self).__init__()
        self.__name__ = "check_value"

    def handle(self, task, section):
        self.ret = Default.FAIL
        judge_string = section.get("judge")
        try:
            real_judge_string = judge_string.format(**self.env.value_dict)
        except KeyError:
            raise ConfigIssue("not specified all value for {}".format(judge_string))
        x_out = '"{}": {}'.format(judge_string, real_judge_string)
        if 'None' in real_judge_string:
            self.log_error('Failed due to None in string {}'.format(x_out))
            self.ret = Default.FAIL
            return
        try:
            judge_result = eval(real_judge_string)
            self.log_info('Judging {}, the Result is: {}'.format(x_out, judge_result))
            if judge_result is False:
                self.log_error("Expression {} IS FAIL".format(x_out))
                self.ret = Default.FAIL
                return
        except TypeError:
            raise ConfigIssue('cannot get judge result for {}'.format(x_out))
        self.ret = Default.PASS


class CheckSdfSimulation(Method):
    def __init__(self):
        super(CheckSdfSimulation, self).__init__()
        self.__name__ = "check_sdf_simflow"
        self.default_file = "_scratch/sim_par_vlg/run_sim_par_vlg.log"

    def handle(self, task, section):
        self.ret = Default.FAIL
        this_file = section.get("file", self.default_file)
        use_grep = True if section.get("use_grep", "") == "1" else False
        if not os.path.isfile(this_file):
            self.ret = Default.FAIL
            return
        #
        tool_name = get_using_simulation_tool(this_file)
        is_modelsim = (tool_name == "modelsim")
        #
        pass_list = [x for x in list(section.keys()) if x.startswith("passkey")]
        if not pass_list:
            if is_modelsim:
                check_pass_dict = dict(passkey1='SDF Backannotation Successfully',
                                       passkey2='Errors: 0')
            else:
                check_pass_dict = dict(passkey1='VSIM: Simulation has finished')
        else:
            check_pass_dict = dict()
            for k in pass_list:
                check_pass_dict[k] = section.get(k)

        for one, two in list(check_pass_dict.items()):
            start_index = -1
            if is_modelsim:
                with open(this_file) as ob:
                    for start_index, line in enumerate(ob):
                        if line.startswith("# Loading work"):
                            break
            ret = find_str_in_file(two, this_file, start=start_index, grep=use_grep)
            if not ret:
                self.log_error('Not found {} in {}'.format(two, this_file))
                self.ret = Default.FAIL
                return
        #
        fail_list = [x for x in list(section.keys()) if x.startswith("failkey")]
        if fail_list:
            check_fail_dict = dict()
            for k in fail_list:
                check_fail_dict[k] = section.get(k)
        else:
            if is_modelsim:
                check_fail_dict = dict(failkey1='Failed to parse SDF',
                                       failkey2='Error loading design')
            else:
                check_fail_dict = dict(failkey1='SDF: 0 SDF entries loaded',
                                       failkey2='SDF: Error')
        for one, two in list(check_fail_dict.items()):
            ret = find_str_in_file(two, this_file, grep=use_grep)
            if ret:
                self.log_error("Found failed message {} in {}".format(two, this_file))
                self.ret = Default.FAIL
                return
        self.ret = Default.PASS   # Finally pass :)


class CheckLines(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_lines'

    def handle(self, task, section):
        all_options = sorted(section.keys())
        matchs = [(i, section[i]) for i in all_options if i.startswith('check_')]
        if 'use_grep' in section and section['use_grep'] == '1':
            use_grep = True
        else:
            use_grep = False
        if not all_options[0].startswith('check_'):
            raise ConfigIssue(task + ' have no check_*')
        first_match = section[all_options[0]]
        matchs.remove((all_options[0], first_match))
        times = section['times'] if 'times' in section else None
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)
        if not filename:
            self.log_error(section['file'] + ' not found!')
            self.ret = Default.FAIL
            return
        else:
            filename = filename[0]
        anchor = find_str_in_file(first_match, filename, grep=use_grep)
        anchor_list = get_index_list_from_file_by_string(first_match, filename, grep=use_grep)
        if anchor is None:
            self.ret = Default.FAIL
            self.log_error('check_1: ' + first_match + ' not found!')
            return
        self.log_info('check_1: ' + first_match + ' found!')
        if matchs or times:
            if times:
                for _ in range(int(times)-1):
                    _offset = find_str_in_file(first_match, filename, start=anchor, grep=use_grep)
                    if _offset is None:
                        self.log_error('first match do not appear enough times')
                        self.ret = Default.FAIL
                        return
                    anchor = anchor + _offset + 1
                self.log_info('check_1 has been found ' + times + ' times')
            if times:
                bingo_point = int(times) - 1
            else:
                bingo_point = 0
            for ka, a in enumerate(anchor_list):
                if times:
                    if ka != bingo_point:  # not greedy match
                        continue
                if len(anchor_list) > 1:
                    self.log_info("Check the following lines after line number {}".format(a))
                got_it = 1
                for m in matchs:
                    offset = get_index(all_options[0], m[0])
                    if find_str_in_file(m[1], filename, offset+a, a+1, grep=use_grep) is None:
                        self.log_info(m[0] + ': ' + m[1] + ' not found, check fail!')
                        got_it = 0
                        break
                    self.log_info(m[0] + ': ' + m[1] + ' found!')
                if got_it:
                    return
            self.log_error("Cannot search all lines for {}, check fail!".format(task))
            self.ret = Default.FAIL


class CheckNo(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_no'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)[0]
        if 'use_grep' in section and section['use_grep'] == '1':
            use_grep = True
        else:
            use_grep = False
        if os.path.isfile(filename):
            ret = find_str_in_file(section['check_line'], filename, grep=use_grep)
            if ret is not None:
                self.ret = Default.FAIL
                self.log_error('check no failed!')
            else:
                self.log_info('check_no pass!')
        else:
            self.log_error(task + (20-len(task)) * ' ' + ': FAIL  : ' + filename + ' is not a file!')
            self.ret = Default.FAIL


class CheckSynpro(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_synpro'
        self.error_flag = '@E:'
        self.safe_flag = 'Mapper successful'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)[0]
        with open(filename, 'r') as f:
            for line in f.readlines():
                if line.startswith(self.error_flag):
                    self.log_error('no ' + self.safe_flag + ' in file ' + filename)
                    self.ret = Default.FAIL
                    return
                if self.safe_flag in line:
                    self.ret = Default.PASS
                    return
        self.ret = Default.FAIL
        return


class CheckLse(CheckSynpro):
    def __init__(self):
        CheckSynpro.__init__(self)
        self.__name__ = 'check_lse'
        self.error_flag = 'ERROR'
        self.safe_flag = 'CPU time for LSE flow'


class CheckMap(CheckSynpro):
    def __init__(self):
        CheckSynpro.__init__(self)
        self.__name__ = 'check_map'
        self.error_flag = 'ERROR'
        self.safe_flag = 'Peak Memory Usage'


class CheckPartrce(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_partrce'
        self.safe_flag = ['Cumulative negative slack',
                          'End of Detailed Report for timing paths']

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        files = glob.glob(filename)
        if not files:
            self.log_error('file ' + filename + 'not found!')
            self.ret = Default.FAIL
            return
        for fn in files:
            with open(fn, 'r') as f:
                for line in f.readlines():
                    for flag in self.safe_flag:
                        if flag in line:
                            self.log_info('"{0}" found in file {1}!'.format(flag, fn))
                            self.ret = Default.PASS
                            return
        self.log_error('no "' + '" or "'.join(self.safe_flag) + '" found in file ' + filename)
        self.ret = Default.FAIL
        return


class CheckRadiantFlow(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_radiant_flow'
        self.basic_flow = {
            'synp': {'sub_path': '_scratch/*/*.srr', 'check_string': 'Mapper successful!'},
            'lse': {'sub_path': '_scratch/*/synthesis.log', 'check_string': 'CPU Time'},
            'map': {'sub_path': '_scratch/*/*.mrp', 'check_string': 'Number of errors:  0'},
            'par': {'sub_path': '_scratch/*/*.par', 'check_string': 'All signals are completely routed'},
            'ibis': {'sub_path': '_scratch/*/IBIS/*.ibs', 'check_string': 'FILE_EXISTS'},
            'bitstream': {'sub_path': '_scratch/*/*.bit;_scratch/*/*.bin;_scratch/*/*.rbt', 'check_string': 'FILE_EXISTS'},
            'jedec': {'sub_path': '_scratch/*/*.jed', 'check_string': 'FILE_EXISTS'},
            'download': {
                'sub_path': '_scratch/*/*.bit;_scratch/*/*.rbt;_scratch/*/*.jed;_scratch/*/*.bin;'
                            '_scratch/*/*.hex;_scratch/*/*.nvcm',
                'check_string': 'FILE_EXISTS'},
            'prom': {'sub_path': '_scratch/*/*.mcs', 'check_string': 'FILE_EXISTS'}
        }
        self.logic_flow = {
            'synthesis': 'synp | lse'
        }

    @staticmethod
    def file_not_empty(flow_name, filename):
        flag = False
        files = glob.glob(filename)
        if not files:
            return flag
        for f in files:
            if flow_name == "bitstream":
                if re.search(r"\Wsim_\w+", f):  # wrong bin file in sim_par_vlg/init.bin for checking bitstream
                    continue
            if os.path.getsize(f) != 0:
                flag = True
                break
        return flag

    def handle(self, task, section):
        self.ret = Default.PASS
        support_check_flow = list(self.basic_flow.keys()) + list(self.logic_flow.keys())
        under_check_flow = [i.strip() for i in section['check_flow'].split(',')]

        for i in under_check_flow:
            if i not in support_check_flow:
                self.ret = Default.FAIL
                self.log_error('Unsupported check flow exist: ' + i)
                return

        self.log_info('under check flow: {0}'.format(', '.join(under_check_flow)))

        self.basic_result = {}
        for flow in self.basic_flow:
            # if check_radiant_flow has synthesis, basic flow will check lse and synp by default
            if flow in ("synp", "lse"):
                if flow not in under_check_flow:
                    if "synthesis" not in under_check_flow:
                        continue
                else:
                    pass  # will check later
            elif flow not in under_check_flow:
                continue
            check_info = self.basic_flow[flow]
            check_string = check_info['check_string']
            uncheck_files = [os.path.abspath(filename) for filename in check_info['sub_path'].split(';')]

            if check_string == 'FILE_EXISTS':
                ret = []
                for uncheck_file in uncheck_files:
                    ret.append(self.file_not_empty(flow, uncheck_file))
                if any(ret):
                    self.basic_result[flow] = True
                else:
                    self.basic_result[flow] = False
            else:
                for uncheck_file in uncheck_files:
                    uncheck_file = glob.glob(uncheck_file)
                    if not uncheck_file:
                        self.basic_result[flow] = False
                        continue
                    uncheck_file = uncheck_file[0]
                    ret = find_str_in_file(check_info['check_string'], uncheck_file)
                    if ret is None:
                        self.basic_result[flow] = False
                        continue
                    self.basic_result[flow] = True

        if 'debug' in section and section['debug']:
            pass
        else:
            for k, v in list(self.basic_result.items()):
                r = ' pass!' if v else ' fail!'
                self.log_info('check flow ' + k + r)

        ret = []
        for i in under_check_flow:
            if i in self.basic_result:
                ret.append(self.basic_result[i])
            else:
                logic = self.logic_flow[i]
                logic = [i.strip() for i in re.split('(\+|\|)', logic.replace(' ', ''))]
                check_str = ''
                for i in logic:
                    if i in self.basic_result:
                        check_str += str(self.basic_result[i])
                    else:
                        check_str += str(i)
                ret.append(eval(check_str))
        self.ret = all(ret)


class CheckDiamondFlow(CheckRadiantFlow):
    def __init__(self):
        CheckRadiantFlow.__init__(self)
        self.__name__ = 'check_diamond_flow'
        self.basic_flow = {
            'synp': {'sub_path': '_scratch/*/*.srr', 'check_string': 'Mapper successful!'},
            'lse': {'sub_path': '_scratch/*/synthesis.log', 'check_string': 'CPU time for LSE flow'},
            'map': {'sub_path': '_scratch/*/*.mrp', 'check_string': 'Number of errors:  0'},
            'par': {'sub_path': '_scratch/*/*.par', 'check_string': 'All signals are completely routed'},
            'ibis': {'sub_path': '_scratch/*/IBIS/*.ibs;_scratch/*/IBIS/*', 'check_string': 'IBIS'},
            'bitstream': {'sub_path': '_scratch/*/*.bit;_scratch/*/*.bin;_scratch/*/*.rbt', 'check_string': 'FILE_EXISTS'},
            'jedec': {'sub_path': '_scratch/*/*.jed', 'check_string': 'FILE_EXISTS'},
            'download': {
                'sub_path': '_scratch/*/*.bit;_scratch/*/*.rbt;_scratch/*/*.jed;_scratch/*/*.bin;'
                            '_scratch/*/*.hex;_scratch/*/*.nvcm',
                'check_string': 'FILE_EXISTS'},
            'prom': {'sub_path': '_scratch/*/*.mcs', 'check_string': 'FILE_EXISTS'}
        }
        self.logic_flow = {
            'synthesis': 'synp | lse'
        }


class CheckRbt(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_rbt'

    @staticmethod
    def get_rbt_data(rbt_file):
        _data = dict()
        with open(rbt_file) as ob:
            for i, line in enumerate(ob):
                if i > 30:  # ONLY parse 30 lines
                    break
                line = line.strip()
                if not line:
                    continue
                line = re.sub(r"\s", "", line)
                line_list = re.split(":", line)
                if len(line_list) > 1:
                    _data[line_list[0]] = ":".join(line_list[1:])
        return _data

    def handle_for_rbt_file(self, old_rbt_file, new_rbt_file):
        must_be_same_titles = ("Rows", "Cols", "Bits", "BitstreamCRC", "FileFormat")  # no space
        must_be_diff_titles = ("Date",)
        old_dict = self.get_rbt_data(old_rbt_file)
        new_dict = self.get_rbt_data(new_rbt_file)
        for k in must_be_same_titles:
            old_v, new_v = old_dict.get(k), new_dict.get(k)
            if old_v != new_v:
                self.log_error("value {} and {} for {} should be same!".format(old_v, new_v, k))
                self.ret = Default.FAIL
                return
        for k in must_be_diff_titles:
            old_v, new_v = old_dict.get(k), new_dict.get(k)
            if old_v == new_v and new_v:
                self.log_error("value {} for {} should be different.".format(new_v, k))
                self.ret = Default.FAIL
                return
        self.log_info('check rbt pass!')

    def handle(self, task, section):
        try:
            compare_file = os.path.abspath(section['compare_file'])
            compare_file = glob.glob(compare_file)[0]
            golden_file = os.path.abspath(section['golden_file'])
            golden_file = glob.glob(golden_file)[0]
        except Exception:
            self.log_error("Cannot find golden_file and/or compare_file")
            self.ret = Default.FAIL
            return
        return self.handle_for_rbt_file(golden_file, compare_file)


class CheckBlock(Method):
    def __init__(self, sim_type=False):
        Method.__init__(self)
        self.__name__ = 'check_block'
        self.sim_type = sim_type

    def handle(self, task, section):
        try:
            compare_file = os.path.abspath(section['compare_file'])
            compare_file = glob.glob(compare_file)[0]
            golden_file = os.path.abspath(section['golden_file'])
            golden_file = glob.glob(golden_file)[0]
        except Exception:
            self.log_error("Cannot find golden_file and/or compare_file")
            self.ret = Default.FAIL
            return

        # DO NOT COMPARE EMPTY LINE
        with open(golden_file, 'r') as f:
            md5_golden = hashlib.md5()
            len_golden = 0
            for line in f:
                line = line.strip()
                if not line:
                    continue
                else:
                    len_golden += 1
                if self.sim_type:
                    line = re.sub(r'[uwxzUWZX\-?]', '0', line)
                md5_golden.update(line.encode('utf-8'))

        index = 0
        while True:
            md5_compare = hashlib.md5()
            with open(compare_file, 'r') as f:
                for _ in range(index):
                    if not f.readline():
                        self.ret = Default.FAIL
                        return
                index += 1
                m = 0
                while True:
                    line = f.readline()
                    if not line:
                        self.ret = Default.FAIL
                        return
                    line = line.strip()
                    if not line:
                        continue
                    m += 1
                    if self.sim_type:
                        line = re.sub(r'[uwxzUWZX\-?]', '0', line)
                    md5_compare.update(line.encode('utf-8'))
                    if m == len_golden:
                        break
                if md5_compare.hexdigest() == md5_golden.hexdigest():
                    self.log_info('check block pass!')
                    return


class SimCheckBlock(CheckBlock):
    def __init__(self):
        CheckBlock.__init__(self)
        self.__name__ = 'sim_check_block'
        self.sim_type = True


class CheckLst(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_lst'

    def compare(self, lc, lg):
        lc_list = re.split(r'\s*', lc.strip())
        lg_list = re.split(r'\s*', lg.strip())
        if not len(lc_list) == len(lg_list):
            return False
        for i, s in enumerate(lc_list):
            if s == '?' or lg_list[i] == '?':
                continue
            elif s != lg_list[i]:
                return False
        return True

    def handle(self, task, section):
        compare_file = glob.glob(os.path.abspath(section['compare_file']))
        golden_file = glob.glob(os.path.abspath(section['golden_file']))
        if not compare_file or not golden_file:
            raise ConfigIssue('no compare_file or golden_file')
        compare_file = compare_file[0]
        golden_file = golden_file[0]

        fc = open(compare_file, 'r+')
        fg = open(golden_file, 'r+')

        lc = fc.readline()
        lg = fg.readline()
        line = 0
        while (lc and lg):
            line += 1
            if not self.compare(lc, lg):
                self.ret = Default.FAIL
                self.log_error('compare fail in line ' + str(line))
                return
            lc = fc.readline()
            lg = fg.readline()
        self.log_info('check lst pass!')


class CheckData(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_data'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)
        if not filename:
            raise ConfigIssue('file ' + section['file'] + ' not found!')
        filename = filename[0]

        start_line = section['start_line']
        times = section['times'] if 'times' in section else None
        result = section['result']
        lines = sorted([i for i in section if re.match(r'line\d+', i)], key=lambda i:int(i[4:]))

        anchor = find_str_in_file(start_line, filename)
        if anchor is None:
            self.ret = Default.FAIL
            self.log_error('start_line: ' + start_line + ' not found!')
            return
        self.log_info('start_line: ' + start_line + ' found!')
        if times:
            for _ in range(int(times)-1):
                _offset = find_str_in_file(start_line, filename, start=anchor)
                if _offset is None:
                    self.log_error('start_line do not appear enough times')
                    self.ret = Default.FAIL
                    return
                anchor = anchor + _offset + 1
            self.log_info('start_line has been found ' + times + ' times')

        def get_num(line, i):
            word = line.split()[i - 1]
            pattern = re.search(r'([\-\d\\.]+)', word)
            if pattern:
                return '{0:.3f}'.format(float(pattern.group(1)))
            else:
                raise ConfigIssue('word {0} of line {1} contains no number!'.format(i, line))

        with open(filename, 'r') as f:
            all_lines = f.readlines()[anchor - 1:]

        if ',' not in result:
            result_n = result
        else:
            ln, i = result.split(',')
            ln, i = int(ln.strip()), int(i.strip())
            result_n = get_num(all_lines[ln], i)

        exp = ''
        for l in lines:
            words = section[l].split(',')
            if len(words) == 1:
                if l == lines[-1]:
                    exp += ''.join(words)
                else:
                    raise ConfigIssue(l + ' config error!')
            elif len(words) == 2:
                if l == lines[-1]:
                    exp += get_num(all_lines[int(words[0].strip())], int(words[1].strip()))
                else:
                    exp += ''.join(words)
            elif len(words) == 3:
                exp += get_num(all_lines[int(words[0].strip())], int(words[1].strip())) + words[2]
            else:
                raise ConfigIssue(l + ' config error!')

        if abs(abs(float(eval(str(exp)))) - abs(float(result_n))) >= 0.001:
            self.log_error('abs of ' + exp + ' != ' + result_n + ', failed!')
            self.ret = Default.FAIL
        else:
            self.log_info('abs of ' + exp + ' == ' + result_n + ', pass!')


class CheckFlow(CheckPartrce):
    def __init__(self):
        CheckPartrce.__init__(self)
        self.__name__ = 'check_flow'
        self.safe_flag = ['All signals are completely routed']


class CheckMultiline(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_multiline'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)[0]
        check_line = section['check_line'].replace(' ', '').replace('\n', '')
        lines = ''
        with open(filename, 'r') as f:
            for line in f.readlines():
                lines += line.replace(' ', '').strip()

        if check_line in lines:
            self.log_info('check_line pass!')
        else:
            self.ret = Default.FAIL
            self.log_error('check line failed!')


class CheckGrep(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_grep'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        perhaps_files = glob.glob(filename)
        if perhaps_files:
            filename = perhaps_files[0]
        else:
            self.ret = Default.FAIL
            return

        grep_str = section['grep'].replace(r'\;', ';')
        modifier = section['modifier'] if 'modifier' in section else ''
        action = section['action'] if 'action' in section else ''
        flag = 0
        if modifier.find('re.DOTALL') != -1 or modifier.find('re.S') != -1:
            flag = re.S
        if modifier.find('re.IGNORECASE') != -1 or modifier.find('re.I') != -1:
            flag = flag | re.I
        if modifier.find('re.LOCALE') != -1 or modifier.find('re.L') != -1:
            flag = flag | re.L
        if modifier.find('re.MULTILINE') != -1 or modifier.find('re.M') != -1:
            flag = flag | re.M
        if modifier.find('re.VERBOSE') != -1 or modifier.find('re.X') != -1:
            flag = flag | re.X
        if flag != 0:
            comp = re.compile(grep_str, flag)
        else:
            comp = re.compile(grep_str)

        self.ret = Default.FAIL
        with open(filename, 'r') as f:
            for line in f.readlines():
                if comp.search(line):
                    self.ret = Default.PASS
                    break

        if action.upper() == 'NEGATIVE':
            self.ret = not self.ret


class CheckComparepar(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_compare_par'

    def handle(self, task, section):
        par_dir = os.path.abspath(section['par_dir'])
        mode = section['mode']
        try:
            result_single, info = compare_par.run(par_dir, mode)
        except Exception as e:
            result_single, info = ['Fail', 'Can not excute compare_par script' + repr(e)]

        if result_single == 'Fail':
            self.ret = Default.FAIL
            self.log_error('check compare par failed: ' + info)


class CheckSdf(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_sdf'

    def handle(self, task, section):
        sdf_dir = os.path.abspath(section['sdf_dir'])
        try:
            result_single, info = check_sdf.run_sdf_check(sdf_dir)
        except Exception as e:
            result_single, info = ['Fail', 'Can not excute check_sdf script' + repr(e)]

        if result_single == 'Fail':
            self.ret = Default.FAIL
            self.log_error('check sdf failed: ' + info)


class CheckFile(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_file'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        reverse = section['reverse'] if 'reverse' in list(section.keys()) else ''
        files = glob.glob(filename)
        if len(files) == 0:
            self.ret = Default.FAIL
        if reverse == '1':
            self.ret = not self.ret


class CheckClkReference(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_clk_reference'

    def is_legal(self, actual_value, init_result, allowance, lut=False):
        if actual_value == 0 or init_result == 0:
            if actual_value != init_result:
                self.log_error('check error: actual_value=%f, init_result=%f' % (actual_value, init_result))
                return Default.FAIL
            else:
                self.log_info('check pass: actual_value=%f, init_result=%f' % (actual_value, init_result))
                return Default.PASS

        percent = (actual_value - init_result) * 100.0 / init_result
        if percent > allowance * -1 and not lut:
            self.log_info('check pass: actual_value=%f, actual_offset=%f%%, init_result=%f, allowance> -%f%%'
                          % (actual_value, percent, init_result, allowance))
            return Default.PASS
        elif percent < allowance and lut:
            self.log_info('check pass: actual_value=%f, actual_offset=%f%%, init_result=%f, allowance< %f%%'
                          % (actual_value, percent, init_result, allowance))
            return Default.PASS
        else:
            self.log_error('check error: actual_value=%f, actual_offset=%f%%, init_result=%f, allowance=%f%%'
                           % (actual_value, percent, init_result, allowance))
            return Default.FAIL

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)[0]
        pattern = section['check_pattern']
        init_result = float(section['init_result'])
        allowance = float(section['allowance'])
#       clk_name = section['clk_name']
        comp = re.compile(pattern, re.I)

        with open(filename, 'r') as f:
            for line in f.readlines():
                search_result = comp.search(line)
                if search_result:
                    clk_value = float(search_result.group(2))
                    self.ret = self.is_legal(clk_value, init_result, allowance)
                    return

        self.log_error('check clk error: can not find pattern!')
        self.ret = Default.FAIL


class CheckLutReference(CheckClkReference):
    def __init__(self):
        CheckClkReference.__init__(self)
        self.__name__ = 'check_lut_reference'

    def handle(self, task, section):
        filename = os.path.abspath(section['file'])
        filename = glob.glob(filename)[0]
        pattern = section['check_pattern']
        init_result = float(section['init_result'])
        allowance = float(section['allowance'])
        comp = re.compile(pattern, re.I)

        with open(filename, 'r') as f:
            for line in f.readlines():
                search_result = comp.search(line)
                if search_result:
                    clk_value = float(search_result.group(1))
                    self.ret = self.is_legal(clk_value, init_result, allowance, lut=True)
                    return

        self.log_error('check clk error: can not find pattern!')
        self.ret = Default.FAIL


class CheckBinary(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_binary'

    def handle(self, task, section):
        compare_file = os.path.abspath(section['compare_file'])
        golden_file = os.path.abspath(section['golden_file'])
        partial = True if 'partial' in section and section['partial'] == '1' else False
        compare_file = glob.glob(compare_file)[0]
        golden_file = glob.glob(golden_file)[0]
        compare_bin = b''
        golden_bin = b''

        with open(compare_file, 'rb') as f:
            bit = f.read(1024)
            while len(bit) > 0:
                compare_bin += bit
                bit = f.read(1024)

        with open(golden_file, 'rb') as f:
            bit = f.read(1024)
            while len(bit) > 0:
                golden_bin += bit
                bit = f.read(1024)

        if partial:
            result = (golden_bin in compare_bin)
        else:
            result = (compare_bin == golden_bin)
        if not result:
            self.ret = Default.FAIL
            self.log_error('check binary file fail!')
        else:
            self.log_info('check binary pass!')


class CheckSim(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'NULL'
        self.path = './_scratch/sim_rtl'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'

    def handle(self, task, section):
        if 'file' in list(section.keys()):
            self.filename = section['file']
        if 'language' in list(section.keys()):
            self.language = section['language'].lower()
        if 'passkey' in list(section.keys()):
            self.passkey = section['passkey']
        if 'failkey' in list(section.keys()):
            self.failkey = section['failkey']

        if self.language == 'vhdl' and self.__name__ != 'check_sim_rtl':
            self.path = self.path[:-4] + '_vhd'

        filename = os.path.join(self.path, self.filename)
        filename = os.path.abspath(filename)
        filename = glob.glob(filename)

        if not filename:
            self.ret = Default.FAIL
            self.log_error('file ' + self.filename + ' not exist!')
            return
        else:
            filename = filename[0]

        if find_str_in_file(self.passkey, filename) is None:
            self.ret = Default.FAIL
            self.log_error(self.passkey + ' not found in ' + filename)
            return

        if find_str_in_file(self.failkey, filename) is not None:
            self.ret = Default.FAIL
            self.log_error(self.failkey + ' found in ' + filename)
            return

        self.log_info(self.__name__ + ' pass!')


class CheckRtlSim(CheckSim):
    def __init__(self):
        CheckSim.__init__(self)
        self.__name__ = 'check_sim_rtl'
        self.path = './_scratch/sim_rtl'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'


class CheckSynSim(CheckSim):
    def __init__(self):
        CheckSim.__init__(self)
        self.__name__ = 'check_sim_syn'
        self.path = './_scratch/sim_syn_vlg'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'


class CheckMapSim(CheckSim):
    def __init__(self):
        CheckSim.__init__(self)
        self.__name__ = 'check_sim_map'
        self.path = './_scratch/sim_map_vlg'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'


class CheckParSim(CheckSim):
    def __init__(self):
        CheckSim.__init__(self)
        self.__name__ = 'check_sim_par'
        self.path = './_scratch/sim_par_vlg'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'
        

class CheckBitSim(CheckSim):
    def __init__(self):
        CheckSim.__init__(self)
        self.__name__ = 'check_sim_bit'
        self.path = './_scratch/sim_bit_vlg'
        self.filename = 'outlog.log'
        self.language = 'verilog'
        self.passkey = 'PASS'
        self.failkey = 'FAIL'        


class CheckResource(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'NULL'
        self.file = ''

    def handle(self, task, section):
        filename = os.path.abspath(self.file)
        filename = glob.glob(filename)
        if not filename:
            self.log_error('.mrp file not found!')
            self.ret = Default.FAIL
            return
        else:
            filename = filename[0]

        ret = []
        for resource in section :
            if re.match(r'^check\d$', resource):
                if find_str_in_file(section[resource], filename):
                    ret.append(True)
                    self.log_info('check resource ' + section[resource] + ' PASS')
                else:
                    ret.append(False)
                    self.log_error('check resource ' + section[resource] + ' FAIL')


class CheckResPar(CheckResource):
    def __init__(self):
        CheckResource.__init__(self)
        self.__name__ = 'check_res_par'
        self.file = './_scratch/*/*.par'


class CheckResMap(CheckResource):
    def __init__(self):
        CheckResource.__init__(self)
        self.__name__ = 'check_res_map'
        self.file = './_scratch/*/*.mrp'


class CheckClk(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'NULL'
        self.file = ''

    @staticmethod
    def find_str_with_wrap(s, f, wrap_list):
        ret = False
        wrapped_list = [i.format(s) for i in wrap_list]
        for r in wrapped_list:
            if find_str_in_file(r, f):
                ret = True
                break
        return ret

    def handle(self, task, section):
        filename = os.path.abspath(self.file)
        filename = glob.glob(filename)
        if not filename:
            self.log_error(self.file + ': file not found!')
            self.ret = Default.FAIL
            return
        else:
            filename = filename[0]

        try:
            clk_num = section['clk_num']
            clk_enable = section['clk_enable']
        except Exception:
            raise ConfigIssue('wrong option in ' + self.__name__)

        if self.__name__ == 'check_clks_lse':
            lsefile = glob.glob(os.path.abspath('./_scratch/*/*.lsedata'))
            if not lsefile:
                self.log_error('file lsedata not found!')
                self.ret = Default.FAIL
                return
            lsefile = lsefile[0]
            found_clk_num = self.find_str_with_wrap(clk_num, lsefile, Default.CLK_NUMS)
            if not found_clk_num:
                self.log_error('check clk numbers fail in lsedata file!')
                self.ret = Default.FAIL
                return

        found_clk_num = self.find_str_with_wrap(clk_num, filename, Default.CLK_NUMS)
        if not found_clk_num:
            self.log_error('check clk numbers fail!')
        else:
            self.log_info('check clk numbers pass!')

        found_clk_en = self.find_str_with_wrap(clk_enable, filename, Default.CLK_ENABLES)
        if not found_clk_en:
            self.log_error('check clk enables fail!')
        else:
            self.log_info('check clk enables pass!')

        if found_clk_num and found_clk_en:
            self.ret = Default.PASS
        else:
            self.ret = Default.FAIL


class CheckClkLse(CheckClk):
    def __init__(self):
        CheckClk.__init__(self)
        self.__name__ = 'check_clks_lse'
        self.file = './_scratch/*/synthesis.log'


class CheckClkMap(CheckClk):
    def __init__(self):
        CheckClk.__init__(self)
        self.__name__ = 'check_clks_map'
        self.file = './_scratch/*/*.mrp'


class CheckSta(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'NULL'
        self.file = ''
        self.check_input = True
        self.check_output = True
        self.check_max = True
        self.check_min = True
        self.check_coverage = False

    def handle(self, task, section):
        filename = os.path.abspath(self.file)
        filename = sorted(glob.glob(filename))
        try:
            if 'lse' in self.__name__:
                filename = filename[1]
            else:
                filename = filename[0]
        except Exception:
            raise ConfigIssue(self.__name__ + ' fail, twr file not exist!')

        ret = []
        for sta_check in section :
            if re.match(r'^check\d$', sta_check):
                s = section[sta_check].split('@')
                times = None
                if len(s) == 2:
                    sta, paths = s
                elif len(s) == 3:
                    sta, paths, times = s
                    times = re.search(r'times=(\d)', times.strip())
                    if not times:
                        raise ConfigIssue('wrong times= option in ' + self.__name__)
                    else:
                        times = times.group(1)
                else:
                    raise ConfigIssue(self.__name__ + ' incorrect!')
                if times is None:
                    ln = find_str_in_file(sta, filename)
                    if not ln:
                        ret.append(False)
                        self.log_error(sta_check + ' not found!')
                    else:
                        found = False
                        for i in range(Default.STA_MAXLINES):
                            for pattern in Default.STA_PATTERNS:
                                if find_str_in_file(pattern.format(paths), filename, index=ln + i + 1):
                                    found = True
                                    break
                            if found:
                                ret.append(True)
                                self.log_info(sta_check + ' found!')
                                break
                        if not found:
                            ret.append(False)
                            self.log_error(sta_check + ' not found!')
                else:
                    start_point = -1
                    ln = None
                    for _ in range(int(times)):
                        print(sta)
                        ln = find_str_in_file(sta, filename, start=start_point)
                        if ln is None:
                            ret.append(False)
                            self.log_error(sta_check + ' not found enough times!')
                            break
                        start_point += ln + 1
                    if ln is None:
                        continue
                    found = False
                    for i in range(Default.STA_MAXLINES):
                        for pattern in Default.STA_PATTERNS:
                            if find_str_in_file(pattern.format(paths), filename, index=start_point + i + 1):
                                found = True
                                break
                        if found:
                            ret.append(True)
                            self.log_info(sta_check + ' found!')
                            break
                    if not found:
                        ret.append(False)
                        self.log_error(sta_check + ' not found!')
        self.ret = all(ret)


class CheckStaLse(CheckSta):
    def __init__(self):
        CheckSta.__init__(self)
        self.__name__ = 'check_sta_lse'
        self.file = './_scratch/*/*.twr'


class CheckStaPar(CheckSta):
    def __init__(self):
        CheckSta.__init__(self)
        self.__name__ = 'check_sta_par'
        self.file = './_scratch/*/*.twr'


class CheckSimrel(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'check_simrel'
        self.avc = './_scratch/simrel/fc.avc'
        self.out = './_scratch/simrel/fc.out'
        self.shift = 0
        self.lines = 10
        self.ignore = 0
        self.acc = 1.0
        self.signals = None
        self.diff = difflib.SequenceMatcher(None)
        self.columns = 0
        self.signal_shift = {}

    def handle(self, task, section):
        if 'avc' in section:
            self.avc = section['avc']
        if 'out' in section:
            self.out = section['out']
        if 'shift' in section:
            self.shift = int(section['shift'])
        if 'ignore' in section:
            self.ignore = int(section['ignore'])
        if 'acc' in section:
            self.acc = float(section['acc'])
        if 'signals' in section:
            self.signals = self.get_signals(section['signals'])
        self.get_columns()
        try:
            ratio = self.cmp()
            self.log_info('ratio: {0}, acc: {1}'.format(ratio, self.acc))
            if ratio >= self.acc:
                self.ret = Default.PASS
            else:
                self.ret = Default.FAIL
            return
        except IOError:
            logging.error('{0} or {1} not exist!'.format(self.avc, self.out))
            self.ret = Default.FAIL

    def get_columns(self):
        found = set()
        with open(self.avc, 'r') as f:
            l = f.readline()
            if self.signals:
                signals = f.readline().split()
                signals.reverse()
                for sig, shift in list(self.signals.items()):
                    for signal in signals:
                        if re.match(sig, signal):
                            self.signal_shift[signals.index(signal)] = int(shift)
                            found.add(sig)
                for i in self.signals:
                    if i not in found:
                        self.log_error('signal {0} not found!'.format(i))
            while l and not l.startswith('r1'):
                l = f.readline()
            self.columns += l.count('L') + l.count('H') + l.count('X')

    def get_signals(self, s):
        list_s = s.replace('[', '\[').replace(']', '\]').split(',')
        keys = []
        values = []
        for item in list_s:
            try:
                key, value = item.split(':')
                keys.append(key.strip())
                values.append(value.strip())
            except:
                raise ConfigIssue('Parameter signals of simrel fault, except format: key1:value1, key2:value2...')
        return dict(list(zip(keys, values)))

    def get_strip_content(self, s, column):
        p = re.search(r'([LHX]+)', s)
        if p:
            return p.group(1)[-1 * int(column) - 1]
        else:
            return ''

    def get_file_content(self, filename, column, shift=False):
        with open(filename, 'r') as f:
            ret = ''
            l = f.readline()
            cnt = 0
            ignore = -1
            while l and l.startswith('#'):
                l = f.readline()
            while l and ignore < self.ignore:
                l = f.readline()
                ignore += 1
            nshift = 0
            if shift:
                if self.signal_shift:
                    if  column in self.signal_shift:
                        nshift = self.signal_shift[column]
                elif self.shift:
                    nshift = self.shift
            for _ in range(nshift):
                l = f.readline()
            while l and cnt <= self.lines:
                ret += self.get_strip_content(l, column)
                l = f.readline()
                cnt += 1
                if cnt == self.lines:
                    yield ret
                    ret = ''
                    cnt = 0

    def calc(self, s1, s2):
        self.diff.set_seqs(s1, s2)
        return self.diff.ratio()

    def cmp_column(self, column, shift1=None, shift2=None):
        tmp = 0.0
        cnt = 0
        f1_iter = self.get_file_content(self.avc, column, shift1)
        f2_iter = self.get_file_content(self.out, column, shift2)
        try:
            c1 = next(f1_iter)
            c2 = next(f2_iter)
            while c1 and c2:
                cnt += 1
                tmp += 1 - self.calc(c1, c2)
                c1 = next(f1_iter)
                c2 = next(f2_iter)
        except StopIteration:
            tmp = tmp / cnt * 100
            return max(0, (1 - tmp))

    def cmp(self):
        ratio1 = ratio2 = 0
        for column in range(self.columns):
            ratio1 += self.cmp_column(column, shift1=True)
            ratio2 += self.cmp_column(column, shift2=True)
        return max(ratio1, ratio2) / self.columns


class CheckNumber(Method):
    def __init__(self):
        Method.__init__(self)
        self.__name__ = 'NULL'
        self.operations = ['>', '<', '=']
        self.tolerance = 0.0
        self.group_name = None
        self.must_params = ['file', 'pattern', 'golden']
        self.op = ''

    def handle(self, task, section):
        self.ret = Default.FAIL  # initialize
        if not self.must_have_param(section, self.must_params):
            self.ret = Default.FAIL
            return
        _ = glob.glob(section['file'])
        if not _:
            self.log_error('file {0} not exist!'.format(section['file']))
            self.ret = Default.FAIL
            return
        filename = _[0]
        pattern, _nouse = tools.string2re(section.get('pattern'))
        if pattern is None:
            self.log_error("No valid pattern in check settings")
            self.ret = Default.FAIL
            return
        before_pattern, before_pattern_string = None, None
        pattern_window_max = 10
        sub_p = re.compile(r"before_pattern_(\w+)")
        for k, v in list(section.items()):
            sub_m = sub_p.search(k)
            if sub_m:
                before_pattern, before_pattern_string = tools.string2re(v)
                try:
                    pattern_window_max = int(sub_m.group(1))
                except Exception:
                    pattern_window_max = 10
                break

        golden = section.get("golden")
        formula = section.get("formula")
        if golden:
            golden = float(golden)
        elif formula:
            golden = eval(formula)
        else:
            self.log_error("Not specified golden or formula value")
            self.ret = Default.FAIL
            return
        if 'tolerance' in section:
            self.tolerance = float(section['tolerance'])
        else:
            self.tolerance = 0
        self.group_name = section.get('group_name')
        error_message = ""
        with open(filename, 'r') as f:
            pattern_window_wid = 0
            for line in f:
                if before_pattern:
                    if not pattern_window_wid:
                        bp = before_pattern.search(line)
                        if bp:
                            pattern_window_wid = 1
                        else:
                            line = re.sub(r"\s+", "", line)
                            if before_pattern_string in line:
                                pattern_window_wid = 1
                    else:
                        pattern_window_wid += 1
                        if pattern_window_wid > pattern_window_max:
                            pattern_window_wid = 0
                else:
                    pattern_window_wid = 1   # always 1
                if not pattern_window_wid:
                    continue
                p = pattern.search(line)
                if p:
                    pattern_window_wid = 0
                    try:
                        if not self.group_name:
                            compare = p.group(1)
                        else:
                            compare = p.group(self.group_name)
                    except Exception:
                        self.log_error('group {0} not found in search pattern!'.format(self.group_name))
                        self.ret = Default.FAIL
                        return
                    if not re.match(r'^[\d.\-]+$', compare):
                        self.log_error('found none numeric pattern {0}!'.format(compare))
                        self.ret = Default.FAIL
                        return
                    compare = float(compare)
                    if self.op == '>':
                        if compare <= golden:
                            self.ret = Default.FAIL
                        else:
                            self.ret = Default.PASS
                            return  # passed
                    elif self.op == "<":
                        if compare >= golden:
                            self.ret = Default.FAIL
                        else:
                            self.ret = Default.PASS
                            return  # passed
                    elif self.op == '=':
                        right_value = golden * (1 + self.tolerance)
                        left_value = golden * (1 - self.tolerance)
                        big_value = max(left_value, right_value)
                        small_value = min(left_value, right_value)
                        if compare > big_value or compare < small_value:
                            self.ret = Default.FAIL
                            error_message = "check value {} not in ({}, {})".format(compare, small_value, big_value)
                        else:
                            self.ret = Default.PASS
                            return  # passed
        if error_message:
            self.log_error(error_message)


class CheckGreater(CheckNumber):
    def __init__(self):
        CheckNumber.__init__(self)
        self.__name__ = 'check_greater'
        self.op = '>'


class CheckLess(CheckNumber):
    def __init__(self):
        CheckNumber.__init__(self)
        self.__name__ = 'check_less'
        self.op = '<'


class CheckAlmost(CheckNumber):
    def __init__(self):
        CheckNumber.__init__(self)
        self.__name__ = 'check_almost'
        self.must_params = ['file', 'pattern', 'tolerance']
        self.op = '='


class TestMethods(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    @classmethod
    def setUpClass(cls):
        cls.check_lines = CheckLines()
        cls.check_no = CheckNo()
        cls.test_file = 'test_file.txt'

    @classmethod
    def tearDownClass(cls):
        pass

    def test_check_lines(self):
        task = 'check_lines'
        section1 = {
            'file': self.test_file,
            'check_1': 'Hold path details for constraint: set_output_delay -clock [get_clocks CK_c] 4',
            'check_3': '0 paths scored '
        }
        self.check_lines.handle(task, section1)
        self.assertTrue(self.check_lines.ret)

        section2 = {
            'file': self.test_file,
            'check_1': 'Hold path details for constraint\: set_output_delay \-clock \[get_clocks .+?\] \d+',
            'check_3': '0 paths scored ',
            'use_grep': '1',
        }
        self.check_lines.handle(task, section2)
        self.assertTrue(self.check_lines.ret)

        section3 = {
            'file': self.test_file,
            'check_1': 'Hold path details for constraint\: set_output_delay \-clock \[get_clocks .+?\] \d+',
            'times': '2',
            'check_3': '0 paths scored ',
            'use_grep': '1',
        }
        self.check_lines.handle(task, section3)
        self.assertTrue(self.check_lines.ret)

    def test_check_no(self):
        task = 'check_no'
        section2 = {
            'file': self.test_file,
            'check_line': 'No this line',
        }
        self.check_no.handle(task, section2)
        self.assertTrue(self.check_no.ret)

        section1 = {
            'file': self.test_file,
            'check_line': 'Hold path details for constraint: set_output_delay -clock [get_clocks CK_c] 4',
        }
        self.check_no.handle(task, section1)
        self.assertFalse(self.check_no.ret)
