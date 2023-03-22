from argparse import ArgumentParser
import os


class ScanParser(ArgumentParser):
    """ Command line parser"""
    def __init__(self, args=None):
        super(ScanParser, self).__init__()
        self.args = args

    def parse_args(self, args=None, namespace=None):
        self.args, no_options = super(ScanParser, self)\
            .parse_known_args(args, namespace)

        return self.args


cmd_parser = ScanParser()

options = cmd_parser.add_argument_group(title='Commandline Arguments')

options.add_argument(
    "--top-dir",
    help="specify top working directory",
    default=os.getcwd()
)

options.add_argument(
    "--design",
    help="specify design",
    default=''
)

options.add_argument(
    "--tag",
    default="_scratch",
    help="specify _scratch name"
)

options.add_argument(
    "--rpt-dir",
    help="specify report file path"
)

options.add_argument(
    "--rpt-file",
    help="specify report file name"
)

options.add_argument(
    "--conf-file",
    help="specify config file",
    default=''
)

options.add_argument(
    "--pap",
    action="store_true",
    help="get pap data"
)

options.add_argument(
    "--seed",
    default="fmax",
    help="seed"
)

options.add_argument(
    "--software",
    default="radiant",
    help="radiant or diamond"
)
options.add_argument("--fmax-sort", choices=("max", "geomean"), default="max", help="specify fmax sort way")
options.add_argument(
    "--debug",
    action="store_true",
    help="Debug model"
)
