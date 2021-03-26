from argparse import ArgumentParser
from .__default__ import Default


class CheckParser(ArgumentParser):
    """ Command line parser"""
    def __init__(self, args=None):
        super(CheckParser, self).__init__()
        self.args = args

    def parse_args(self, args=None, namespace=None):

        self.args, no_options = super(CheckParser, self)\
            .parse_known_args(args, namespace)

        return self.args


parser = CheckParser()


environ = parser.add_argument_group(title='Environment Arguments')


environ.add_argument(
    "--top-dir",
    help="specify top working directory",
    default=Default.TOP_DIR
)

environ.add_argument(
    "--design",
    help="specify design name",
    default=Default.DESIGN
)

environ.add_argument(
    "--conf-file",
    help="specify configure file if you know",
    default=Default.CONF_FILE
)

environ.add_argument(
    "--def-conf",
    help="specify default configure",
    default=Default.DEF_CONF
)

environ.add_argument(
    "--report-path",
    help="specify where you want to store the report",
    default=Default.REPORT_PATH
)

environ.add_argument(
    "--tag",
    help="replace the tag in the conf file",
    default=Default.TAG
)

environ.add_argument(
    "--report",
    default=Default.REPORT,
    help="specify report name, default is check.csv"
)

environ.add_argument(
    "--rerun-path",
    default=Default.RERUN_PATH,
    help="specify the directory for the rerun.bat to be stored"
)

environ.add_argument(
    "--lse-check",
    action="store_true",
    help="Just Check lse(create conf file)"
)

environ.add_argument(
    "--synp-check",
    action="store_true",
    help="Just Check synplify(create conf file)"
)

environ.add_argument(
    "--map-check",
    action="store_true",
    help="Just Check map(create conf file)"
)

environ.add_argument(
    "--partrce-check",
    action="store_true",
    help="Just Check partrce(create conf file)"
)

environ.add_argument(
    "--case-command",
    default=Default.CASE_CMD,
    help="specify case command, create conf file according to the command"
)

environ.add_argument(
    "--debug",
    action="store_true",
    help="Debug model"
)

environ.add_argument(
    "--detail",
    action="store_true",
    help="Show detail report"
)

environ.add_argument(
    "--all-conf",
    action="store_true",
    help="Check all config files"
)

environ.add_argument(
    "--preset-options",
    default='check_normal',
    help="argument from dev, chose sections to check"
)

environ.add_argument(
    "--vendor",
    default='radiant',
    help="specify vendor name, default is radiant"
)
