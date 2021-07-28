import configparser
from .process import *
from .scan_tools import *
from .scan_default import Default
from .scan_exceptions import *


class Config:
    """ Parse config file """
    def __init__(self):
        self.parser = configparser.ConfigParser()
        self.args = OrderedDict()

    def parse_args(self, cmd_options):
        options = vars(cmd_options)
        config_file = get_config(options)

        try:
            self.parser.read(config_file)
        except Exception as e:
            raise ConfigIssue(repr(e))
        self.isvalid_config()

        sections = self.parser.sections()
        for s in sections:
            self.args[s] = {i: j for i, j in self.parser.items(s)}
        software = options['software'].lower()

        ''' merge cmd and config options '''
        top_dir = os.path.abspath(options['top_dir'])
        tag_path = os.path.join(top_dir, options['design'], options['tag'])
        options['tag_path'] = tag_path
        for item in os.listdir(tag_path):
            if item.startswith("Target_fmax"):
                options['sweep'] = True
                options['seed'], options['seed_folder'] = get_seed_folder(options)
                break
        else:
            options['sweep'] = False
            options['seed'], options['seed_folder'] = -1, ''
        options['design'] = os.path.join(top_dir, options['design'])
        options['conf_file'] = config_file
        files_patterns = Default(options).get_options()
        sweep = 'sweep' if options['sweep'] else 'no_sweep'
        options['files'] = files_patterns[software][sweep]['file']
        options['patterns'] = files_patterns[software][sweep]['pattern']

        ''' each method will have one option and some args'''
        for p in for_each_process():
            for m in self.args['scan_method']:
                if m.startswith(p.p.name) and self.args['scan_method'][m] == '1':
                    p.args.append(dict(self.args[m], **self.args['general information']))
            p.args.append(options)

    def isvalid_config(self):
        reserved_sections = ['general information', 'scan_method']
        section_in_method = sorted([i[0] for i in self.parser.items('scan_method')])
        section_below = sorted([i for i in self.parser.sections() if i not in reserved_sections])
        if section_below == section_in_method:
            return True
        else:
            raise ConfigIssue('invalid config: \nsection in method: %s, \nsection below    : %s' %
                              (str(section_in_method), str(section_below)))


scf_parser = Config()
