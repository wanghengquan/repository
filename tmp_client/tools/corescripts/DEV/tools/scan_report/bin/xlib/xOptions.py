import os
import sys
import glob
import optparse

from xLog import set_logging_level, wrap_debug, print_error
from xOS import not_exists, wrap_md
from xConf import get_conf_options
from xTools import wrap_update_dict
from xFamily import get_family_by_vendor

def add_public_group(parser, vendor):
    public_group = optparse.OptionGroup(parser, "Public Options")
    # create choice list for synthesis and family
    _syn_dict = dict(lattice=("synp", "lse"), altera=("synp", "qis"), xilinx=("synp", "xst"), cube=("synp", "lse"))
    _synthesis = _syn_dict.get(vendor)
    _family = get_family_by_vendor(vendor)
    if not (_synthesis and _family):
        print_error("Unknown vendor name: %s" % vendor)
        return 1

    public_group.add_option("-d", "--debug", action="store_true", help="print debug message")
    public_group.add_option("-q", "--quiet", action="store_true", help="print as little as possible")
    public_group.add_option("-D", "--dry-run", action="store_true", help="dry run")
    public_group.add_option("-x", "--x64", action="store_true", help="run with x64-based tool")
    public_group.add_option("-C", "--conf", default="conf", help="specify configuration path name")
    public_group.add_option("-K", "--timeout", default=0, type="int", help="specify timeout for running command")
    public_group.add_option("--top-dir", help="specify top source path")
    public_group.add_option("--job-dir", default=os.getcwd(), help="specify job working path")
    public_group.add_option("--tag", default="", help="specify tag name for results file")
    public_group.add_option("--design", help="specify design name")
    public_group.add_option("--synthesis", type="choice", default="synp", choices=_synthesis,
        help="specify synthesis name")
    public_group.add_option("--family", type="choice", choices=_family, help="specify family name")
    public_group.add_option("--frequency", default=200, type="float",
        help="specify Synplify frequency constraint number, default is 200.00 MHz")
    public_group.add_option("--fanout", default=1000, type="int",
        help="specify Synplify fanout limit number, default is 1000")
    public_group.add_option("--pushbutton", action="store_true", help="run pushbutton flow")
    public_group.add_option("--fmax-sweep", type="int", nargs=3, help="specify fmax sweeping range")
    public_group.add_option("--smoke", action="store_true", help="only run the minimize fmax point")
    public_group.add_option("--till-map", action="store_true", help="run flow till map")
    public_group.add_option("--scan", action="store_true", help="scan report only")
    public_group.add_option("-t", "--thread", type="int", default=1, help="specify the thread number for run sweeping flow")
    parser.add_option_group(public_group)

def add_lattice_group(parser):
    lattice_group = optparse.OptionGroup(parser, "Lattice Options")
    # create choice list for lse_goal
    _lse_goal = ("Timing", "Balanced", "Area")
    default_goal = _lse_goal[0]

    lattice_group.add_option("--diamond", help="specify Diamond install path")
    lattice_group.add_option("--rtf", help="specify RTF env path")
    lattice_group.add_option("--devkit", help="specify Lattice Devkit")
    lattice_group.add_option("--run-lse", action="store_true", help="run Lattice LSE flow")
    lattice_group.add_option("--run-lse-only", action="store_true", help="run Lattice LSE flow only")
    lattice_group.add_option("--lse-goal", type="choice", choices=_lse_goal, default=default_goal,
        help="specify LSE optimization goal, default is <%s>" % default_goal)
    lattice_group.add_option("--run-synpwrap", action="store_true", help="run Lattice Synplify flow")
    lattice_group.add_option("--run-synpwrap-only", action="store_true", help="run Lattice Synplify flow only")
    lattice_group.add_option("--seed-sweep", type="int", nargs=2,
        help="specify Lattice placement iteration start point and end point")
    lattice_group.add_option("--pap", action="store_true", help="dump Lattice Performance Achievement Percentage data")
    lattice_group.add_option("-c", "--pack-factor", type="int", default=-1, help="specify number of map_pack_logic_blk_util")
    lattice_group.add_option("--run-be", action="store_true", help="run Lattice BE flow")
    # ------------------------
    lattice_group.add_option("--file", action="store_true", help="specify flow configuration file")
    # ------------------------
    parser.add_option_group(lattice_group)

def add_xilinx_group(parser):
    xilinx_group = optparse.OptionGroup(parser, "Xilinx Options")
    xilinx_group.add_option("--synplify", help="specify SynplifyPro install path")
    xilinx_group.add_option("--ise", help="specify Xilinx ISE install path")
    xilinx_group.add_option("--run-synplify", action="store_true", help="run SynplifyPro flow")
    xilinx_group.add_option("--run-synplify-only", action="store_true", help="run SynplifyPro flow only")
    xilinx_group.add_option("--run-xst", action="store_true", help="run Xilinx XST flow")
    xilinx_group.add_option("--run-xst-only", action="store_true", help="run Xilinx XST flow only")
    parser.add_option_group(xilinx_group)

def add_altera_group(parser):
    altera_group = optparse.OptionGroup(parser, "Altera Options")
    altera_group.add_option("--synplify", help="specify SynplifyPro install path")
    altera_group.add_option("--quartus", help="specify Altera QuartusII install path")
    altera_group.add_option("--run-synplify", action="store_true", help="run SynplifyPro flow")
    altera_group.add_option("--run-synplify-only", action="store_true", help="run SynplifyPro flow only")
    parser.add_option_group(altera_group)

def add_cube_group(parser):
    _lse_goal = ("Timing", "Balanced", "Area")
    default_goal = _lse_goal[0]
    cube_group = optparse.OptionGroup(parser, "iCEcube Options")
    cube_group.add_option("--ice-cube", help="specify iCEcube install path")
    cube_group.add_option("--run-lse", action="store_true", help="run iCEcube LSE flow")
    cube_group.add_option("--lse-goal", type="choice", choices=_lse_goal, default=default_goal,
        help="specify LSE optimization goal, default is <%s>" % default_goal)
    cube_group.add_option("--run-synpro", action="store_true", help="run iCEcube Synplify flow")
    cube_group.add_option("--run-lse-only", action="store_true", help="run iCEcube LSE flow only")
    cube_group.add_option("--run-synpro-only", action="store_true", help="run iCEcube Synplify flow only")
    cube_group.add_option("--devkit", help="specify iCE <family,device,package,PowerGrade>")
    parser.add_option_group(cube_group)

add_vendor = dict(lattice=add_lattice_group, xilinx=add_xilinx_group, altera=add_altera_group, cube=add_cube_group)

class Options:
    def __init__(self, private_options):
        self.private_options = private_options
        self.vendor = private_options.get("vendor", "lattice")
        self.qa_options = dict()

    def get_qa_options(self):
        return self.qa_options

    def process(self, raw_opt=sys.argv):
        if self.create_parser():
            return 1

        opts, args = self.parser.parse_args(raw_opt)

        self.cmd_options = eval(str(opts))
        self.qa_options = dict(self.private_options)
        self.qa_options["vendor"] = self.vendor
        wrap_update_dict(self.qa_options, self.cmd_options)

        if self.set_logger():
            return 1

        if self.create_conf_options():
            return 1
        wrap_update_dict(self.qa_options, self.conf_options)
        self.update_qa_options()
        wrap_debug(self.qa_options, "QA Options:")

    def create_parser(self):
        self.parser = optparse.OptionParser()
        if add_public_group(self.parser, self.vendor):
            return 1
        add_func = add_vendor.get(self.vendor)
        add_func(self.parser)

    def set_logger(self):
        debug = self.qa_options.get("debug")
        quiet = self.qa_options.get("quiet")
        rpt_dir = self.qa_options.get("job_dir")
        if wrap_md(rpt_dir, "job ID path"):
            return 1
        rpt_dir = os.path.abspath(rpt_dir)
        self.qa_options["job_dir"] = rpt_dir
        set_logging_level(debug, quiet, rpt_dir)

    def create_conf_options(self):
        _conf = self.qa_options.get("conf")
        if not_exists(_conf):
            # unix cannot find </trunk/bin/runLattice.py/../../conf> path
            #_scripts_path = os.path.abspath(sys.argv[0])
            #_conf = os.path.join(os.path.dirname(_scripts_path), "..", _conf)
            _conf = os.path.join(os.path.dirname(__file__), "..",'..', _conf)
        if not_exists(_conf, "Configuration path"):
            return 1
        _conf = os.path.abspath(_conf)
        self.qa_options["conf"] = _conf

        conf_files = glob.glob(os.path.join(_conf, "*.conf"))
        self.conf_options = get_conf_options(conf_files)

    def update_qa_options(self):
        for item in (("run_lse_only", "run_lse", "lse"),
                     ("run_synpwrap_only", "run_synpwrap", "synp"),
                     ("run_synplify_only", "run_synplify", "synp"),
                     ("run_xst_only", "run_xst", "xst"),
                     ("run_synpro_only", "run_synpro", "synp"),
                     ):
            if self.qa_options.get(item[0]):
                self.qa_options["synthesis"] = item[-1]
                self.qa_options["run_synthesis"] = 1
                self.qa_options[item[1]] = 1
                self.qa_options["run_synthesis_only"] = 1
                break
            elif self.qa_options.get(item[1]):
                self.qa_options["synthesis"] = item[-1]
                self.qa_options["run_synthesis"] = 1
                self.qa_options["run_synthesis_only"] = 0
                break

if __name__ == "__main__":
    test = Options(dict())
    test.process()


