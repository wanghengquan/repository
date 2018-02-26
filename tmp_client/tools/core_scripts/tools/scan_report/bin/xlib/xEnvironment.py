import os
import re
from xLog import print_error, wrap_debug
from xOS import not_exists, get_os_env_sep

__author__ = 'syan'

def set_lattice_environment(diamond, rtf, os_name, env_sep, dry_run):
    if diamond:
        diamond = os.path.abspath(diamond)
        foundry = os.path.join(diamond, "ispfpga")
        sv_cpld_bin = os.path.join(diamond, "bin", os_name)
        sv_fpga_bin = os.path.join(foundry, "bin", os_name)
        tcl_library = os.path.join(diamond, "tcltk", "lib", "tcl8.5")
    elif rtf:
        rtf = os.path.abspath(rtf)
        foundry = rtf
        sv_cpld_bin = os.path.join(rtf, "bin", os_name)
        sv_fpga_bin = sv_cpld_bin
        tcl_library = ""
    else:
        print_error("Neither Diamond nor RTF specified !!")
        return 1

    os.environ["FOUNDRY"] = foundry
    t_value = sv_cpld_bin + env_sep + sv_fpga_bin
    os.environ["PATH"] = t_value + env_sep + os.getenv("PATH", "")
    os.environ["LD_LIBRARY_PATH"] = t_value
    os.environ["QACPLDBIN"] = sv_cpld_bin
    os.environ["QAFPGABIN"] = sv_fpga_bin
    if tcl_library:
        os.environ["TCL_LIBRARY"] = tcl_library
    if dry_run:
        return
    for a_path in (foundry, sv_cpld_bin, sv_fpga_bin, tcl_library):
        if a_path:
            if not_exists(a_path, "Diamond Environment Path"):
                return 1

def set_iCEcube_environment(ice_cube, dry_run):
    os.environ["QAICEBIN"] = os.path.join(ice_cube, "sbt_backend", "bin", "win32", "opt")
    os.environ["QAICELIB"] = os.path.join(ice_cube, "sbt_backend")
    os.environ["QAICESYN"] = os.path.join(ice_cube, "sbt_backend", "bin", "win32", "opt")
    os.environ["SYNPLIFY_PATH"] = os.path.join(ice_cube, "synpbase")
    # set SYNPLIFY_PATH=D:\suzhilong\iCEcube2.2013.03\SBTools\synpbase
    # "D:\suzhilong\iCEcube2.2013.03\SBTools\sbt_backend\bin\win32\opt\synpwrap\synpwrap.exe"
    LSE_foundry = os.path.join(ice_cube, "LSE")
    os.environ["QAICELSE"] = os.path.join(LSE_foundry, "bin", "nt")
    os.environ["FOUNDRY"] = LSE_foundry

    if dry_run:
        return
    for key in ("QAICEBIN", "QAICELIB", "QAICESYN"):
        if not_exists(os.getenv(key), "iCEcube Environment Path"):
            return 1

class SetEnvironment:
    _vendor_path_conf_name = "vendor_path_conf"
    _default_env_conf_name = "default_environment_conf"

    def __init__(self, qa_options):
        self.qa_options = qa_options
        self.dry_run = qa_options.get("dry_run")
        self.x64 = qa_options.get("x64")
        self.vendor = qa_options.get("vendor")

        self.vendor_path = qa_options.get(self._vendor_path_conf_name, dict())
        self.default_env = qa_options.get(self._default_env_conf_name, dict())
        self.p_comma = re.compile("\s*;\s*")

    def process(self):
        self.os_name, self.env_sep = get_os_env_sep(self.x64)
        if self.vendor in("altera", "xilinx"):
            self.set_synplify_envs()

        if self.vendor == "lattice":
            if self.set_lattice_envs():
                return 1
        elif self.vendor == "altera":
            if self.set_altera_envs():
                return 1
        elif self.vendor == "xilinx":
            if self.set_xilinx_envs():
                return 1
        elif self.vendor == "cube":
            #-- if self.set_lattice_envs():
            #--     return 1
            #--
            ice_cube = self.get_real_setting("ice_cube")
            if set_iCEcube_environment(ice_cube, self.dry_run):
                return 1

        self.set_default_envs()
        wrap_debug(os.environ, "OS Environment")

    def get_real_setting(self, opt_name):
        my_value = self.qa_options.get(opt_name)
        if not my_value:
            my_value = self.vendor_path.get(opt_name, "NO %s" % opt_name)
        return my_value

    def set_default_envs(self):
        if self.default_env:
            for key, value in self.default_env.items():
                value = self.p_comma.split(value)
                value = self.env_sep.join(value)
                key = key.upper()
                os.environ[key] = value

    def set_synplify_envs(self):
        synplify = self.get_real_setting("synplify")
        os.environ["QASYNPLIFYBIN"] = synplify
        if not self.dry_run:
            return not_exists(synplify, "SynplifyPro Install path")

    def set_lattice_envs(self):
        diamond = self.qa_options.get("diamond")
        rtf = self.qa_options.get("rtf")
        if not (diamond or rtf):
            diamond = self.vendor_path.get("diamond")
            rtf = self.vendor_path.get("rtf")
        return set_lattice_environment(diamond, rtf, self.os_name, self.env_sep, self.dry_run)

    def set_altera_envs(self):
        quartus = self.get_real_setting("quartus")
        if not self.dry_run:
            if not_exists(quartus, "Quartus Path"):
                return 1
        os.environ["QUARTUS_ROOTDIR"] = quartus
        if self.x64:
            bin_name = "bin64"
        else:
            bin_name = "bin"
        os.environ["QAQUARTUSBIN"] = os.path.join(quartus, bin_name)

    def set_xilinx_envs(self):
        ise = self.get_real_setting("ise")
        if not self.dry_run:
            if not_exists(ise, "Xilinx ISE path"):
                return 1
        if self.x64:
            os.environ["QAISEBIN"] = os.path.join(ise, "bin", "nt64")
        else:
            os.environ["QAISEBIN"] = os.path.join(ise, "bin", "nt")
