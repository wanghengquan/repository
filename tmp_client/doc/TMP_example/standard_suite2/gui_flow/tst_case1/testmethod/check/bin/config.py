import configparser
from .__default__ import Default, CaseInfo, ConfigIssue
import logging
import re
from . import tools


class Environment(Default):
    """ Parse config file """
    def __init__(self, conf_file, flags=None):
        super(Environment, self).__init__()
        # self.parser = configparser.ConfigParser(interpolation=None)
        self.parser = configparser.ConfigParser()
        self.conf_file = conf_file
        self.flags = flags
        self.flow = set()
        try:
            self.parser.read(self.conf_file)
            self.conf_info = self._get_conf_info()
            self.conf_sections = self._get_sections()
            self.conf_tasks = self._get_tasks()
            self.value_dict = tools.run_get_value_function(self.parser, self.conf_file)
        except ConfigIssue as e:
            raise ConfigIssue('invalid config: {0}'.format(e.msg))
        except Exception as e:
            raise ConfigIssue('invalid config: %s' % repr(e))

    def _get_conf_info(self):
        try:
            r = dict(self.parser.items('configuration information', dict()))
        except Exception as e:
            r = dict()
        caseinfo = CaseInfo().caseinfo()
        caseinfo.update(r)
        return {key.lower(): value.strip() for key, value in list(caseinfo.items())}

    def _get_tasks(self):
        methods = self.get_all_methods()

        for method, enable in self.parser.items('method'):
            if method in self.conf_sections and enable != '0':
                for i in list(methods.keys()):
                    if method.startswith(i.__name__):
                        methods[i].put(method)
        return methods

    def _get_sections(self):
        from .tools import log_a_line
        log_a_line(title='Config_handle')
        sections = {}
        for method, _ in self.parser.items('method'):
            try:
                i = {key.lower(): value.strip()
                     for key, value in list(dict(self.parser.items(method)).items())}
                if self._check_pattern(method, i):
                    sections[method] = i
                else:
                    log_a_line('section ignored', method)
                    # logging.log(300, 'section ignored: {0}'.format(method))
            except configparser.NoSectionError as e:
                raise ConfigIssue(repr(e))
        if not sections:
            raise ConfigIssue('empty config, no section checked!')
        return sections

    def _check_pattern(self, method, configs):
        if not self.flags:
            return True

        for flag in self.flags:
            if flag not in self.FILE_PATTERNS:
                raise ConfigIssue('check section {0} is not support'.format(flag))
            for f in self.FLOW:
                if 'impl_' + f in flag:
                    self.flow.add(f)

        for f in self.FILE_PATTERNS['uniform_funcs']['pattern']:
            if method.startswith(f):
                return True

        if method.startswith('check_radiant_flow') or method.startswith('check_diamond_flow'):
            want_test_flows = configs['check_flow'].split(',')
            tmp = []
            for c in want_test_flows:
                if c.strip() in self.flow:
                    tmp.append(c)
            if not tmp:
                return False
            configs['check_flow'] = ','.join(tmp)
            return True

        if method.startswith('check_sim'):
            if 'rtl' in method and  'sim_rtl' not in self.flags:
                return False
            if 'syn' in method and  'sim_synthesis' not in self.flags:
                return False
            if 'map' in method and 'sim_map' not in self.flags:
                return False
            if 'par' in method and 'sim_par' not in self.flags:
                return False
            if 'bit' in method and 'sim_bit' not in self.flags:
                return False
            return True
        if method.startswith("check_value"):
            return True

        if 'file' not in configs:
            raise ConfigIssue('file not in section {0}'.format(method))
        filename = configs['file']
        for pattern in self.FILE_PATTERNS['uniform_files']['pattern']:
            if re.search(pattern, filename):
                return True

        category = []
        for key, value in list(self.FILE_PATTERNS.items()):
            for p in value['pattern']:
                if re.search(p, filename):
                    category.append(key)
        if not category:
            from .tools import log_a_line
            log_a_line('file pattern', method, 'file {0} not in any category'.format(filename))
            return True
        for cg in category:
            if cg in self.flags:
                return True

        return False

    def isvalid_config(self):
        reserved_sections = ['configuration information', 'method']
        section_in_method = sorted([i[0] for i in self.parser.items('method')])
        section_below = list()
        for foo in self.parser.sections():
            if foo.startswith("_"):
                continue
            if foo in reserved_sections:
                continue
            section_below.append(foo)
        section_below.sort()
        if section_below == section_in_method:
            return True
        else:
            raise ConfigIssue('invalid config: \nsection in method: %s, \nsection below    : %s' %
                              (str(section_in_method), str(section_below)))
