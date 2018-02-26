import os
import sys
import shutil
import optparse
from xlib import xTools

__author__ = 'syan'

def update_tsv(tsv_file, ldf_file):
    tsv_lines = list()
    tsv_lines.append('"location"' + "\t" + '"prj"')
    tsv_lines.append('".."' + "\t" + '"%s"' % os.path.basename(ldf_file))
    return xTools.write_file(tsv_file, tsv_lines)

class RunGUI:
    def __init__(self, diamond, ldf_file, base_suite, squish, x86):
        self.diamond = diamond
        self.ldf_file = ldf_file
        self.base_suite = base_suite
        self.squish = squish
        self.x86 = x86

    def process(self):
        if self.copy_suite_files():
            return 1
        if self.launch_it():
            return 1

    def copy_suite_files(self):
        ldf_dir = os.path.dirname(self.ldf_file)
        self.new_suite = os.path.join(ldf_dir, os.path.basename(self.base_suite))
        if xTools.remove_dir_without_error(self.new_suite):
            return 1
        try:
            shutil.copytree(self.base_suite, self.new_suite)
        except Exception, e:
            xTools.say_it(e)
            return 1
        # update tsv file
        for root, dirs, files in os.walk(self.new_suite):
            for item in files:
                fext = xTools.get_fext_lower(item)
                if fext == ".tsv":
                    if update_tsv(os.path.join(root, item), self.ldf_file):
                        return 1

    def launch_it(self):
        cmd_kwargs = dict()
        cmd_kwargs["run_squish_py"] = os.path.join(xTools.get_file_dir(sys.argv[0]), "run_squish.py")
        cmd_kwargs["diamond"] = self.diamond
        cmd_kwargs["squish"] = self.squish
        cmd_kwargs["suite"] = self.new_suite
        cmd_kwargs["rpt_dir"] = os.path.join(os.path.dirname(self.ldf_file), "GUI_RPT")
        cmd_kwargs["x86"] = "--x86" if self.x86 else ""

        cmd_line = r"python %(run_squish_py)s --diamond=%(diamond)s --squish=%(squish)s " \
                    "--suite=%(suite)s --rpt-dir=%(rpt_dir)s %(x86)s" % cmd_kwargs
        new_base_dir = os.path.dirname(self.ldf_file)
        _recov = xTools.ChangeDir(new_base_dir)
        sts = xTools.run_command(cmd_line, "GUI_FLOW.log", "GUI_FLOW.time")
        _recov.comeback()
        return sts

def main():
    _default_suite = os.path.join(xTools.get_file_dir(sys.argv[0]), "xlib", "BasicSuite")
    parser = optparse.OptionParser()
    parser.add_option("--diamond", default="DiamondInstallPath", help="specify Diamond Install Path")
    parser.add_option("--ldf-file", default="LDF_FILE", help="specify the Diamond project file")
    parser.add_option("--base-suite", default=_default_suite, help="specify basic suite path")
    parser.add_option("--squish", help="specify Squish Install Path")
    parser.add_option("--x86", action="store_true", help="run with 32-bit vendor tool")

    opts, args = parser.parse_args()
    diamond = opts.diamond
    ldf_file = opts.ldf_file
    base_suite = opts.base_suite
    squish = opts.squish
    x86 = opts.x86

    if xTools.not_exists(diamond, "Diamond Install Path"):
        return 1
    diamond = os.path.abspath(diamond)
    if xTools.not_exists(ldf_file, "Diamond Project (ldf) File"):
        return 1
    ldf_file = os.path.abspath(ldf_file)
    if xTools.not_exists(base_suite, "Base Suite Path"):
        return 1
    base_suite = os.path.abspath(base_suite)
    if xTools.not_exists(squish, "Squish Install Path"):
        return 1
    squish = os.path.abspath(squish)

    my_gui_flow = RunGUI(diamond, ldf_file, base_suite, squish, x86)
    sts = my_gui_flow.process()
    return sts


if __name__ == "__main__":
    my_test = main()
    sys.exit(my_test)

