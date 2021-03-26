import os
import sys
import re
import glob
import time
from . import xTools
from . import xLattice
import shutil

__author__ = 'syan'

v_file_lines = """
// pseudo_pullup.v
// This file is for VHDL simulation.

module pseudo_pullup
(
    output pullup_output
);

// pragma translate_off
pullup pullup_inst1(pullup_output);
// pragma translate_on

endmodule

"""


def get_radiant_lib_file(family_path):
    t = list()
    if os.path.basename(family_path) == "pmi":
        # c:\radiant_auto\ng3_0.30\cae_library\simulation\verilog\pmi
        pmi_f = re.sub("cae_library.+", "ip/pmi/pmi.f", family_path)
        pmi_f = xTools.win2unix(pmi_f, 0)
        if os.path.exists(pmi_f):
            t.append(pmi_f)
            return t

    hdl_path, family = os.path.split(family_path)
    if family == "iCE40UP":
        my_dirs = ("iCE40UP",)
    elif family == "ap6a00":
        my_dirs = (family, "applatform")
    else:
        my_dirs = ("uaplatform", family)
    cds_files = [glob.glob(os.path.join(hdl_path, item, "convertDeviceString*")) for item in my_dirs]
    for foo in cds_files:
        for bar in foo:
            xTools.wrap_cp_file(bar, os.path.basename(bar), force=True)
    _vhdl = os.path.join(hdl_path, "..", "..", "synthesis", "vhdl", "{}.vhd".format(family))
    if os.path.isfile(_vhdl):
        t.append(os.path.abspath(_vhdl))
    for foo in my_dirs:
        f_files = glob.glob(os.path.join(hdl_path, foo, "*.f"))
        if not f_files:
            f_files = glob.glob(os.path.join(hdl_path, foo, "*.v"))
        for bar in f_files:
            if 'convertDeviceString' in bar:
                continue
            t.append(bar)
    return t


def get_lib_file(hdl_type, family_path, bb_file, is_ng_flow):
    lib_files = list()

    if is_ng_flow:
        if hdl_type == "verilog":
            return get_radiant_lib_file(family_path)
        elif hdl_type == "vhdl":
            # TODO: not support vhdl @ 2018/6/14
            tt = os.path.basename(family_path)
            t2 = os.path.dirname(family_path)
            t3 = os.path.dirname(t2)
            family_path = os.path.join(t3, "verilog", tt)
            return get_radiant_lib_file(family_path)

    p_hdl_type = re.compile(r"(.+)\Wvhdl\W(\w+)$")
    if hdl_type == "verilog":
        for foo in os.listdir(family_path):
            fext = xTools.get_fext_lower(foo)
            if fext == ".v":
                lib_files.append(os.path.join(family_path, foo))
            elif fext == ".vhd":
                xTools.say_it("Warning. found vhd file in %s" % family_path)
    else:  # vhdl
        mti_path = os.path.join(family_path, "mti")
        src_path = os.path.join(family_path, "src")

        list_v, list_vhd = list(), list()
        m = p_hdl_type.search(family_path)
        if m:
            outside_verilog_path = os.path.join(m.group(1), "verilog", m.group(2))
            if xTools.not_exists(outside_verilog_path, "Verilog simulation path"):
                pass
            else:
                for v_file in ("GSR.v", "PUR.v"):
                    real_v = os.path.join(outside_verilog_path, v_file)
                    if os.path.isfile(real_v):
                        list_v.append(real_v)
        pseudo_v = "pseudo_pullup.v"
        if os.path.isfile(pseudo_v):
            pass
        else:
            xTools.write_file(pseudo_v, v_file_lines)
        list_v.append(os.path.abspath(pseudo_v))
        if not os.path.isdir(src_path):
            return lib_files

        for foo in os.listdir(src_path):
            fext = xTools.get_fext_lower(foo)
            abs_foo = os.path.join(src_path, foo)
            if fext == ".v":
                list_v.append(abs_foo)
            elif fext == ".vhd":
                list_vhd.append(abs_foo)
            else:
                xTools.say_it("Warning. found unknown file %s" % abs_foo)

        # /**********************************
        # No mti path for family prism. So use raw order
        # ***********************************/
        if os.path.isdir(mti_path):
            recov = xTools.ChangeDir(mti_path)
            if sys.platform[:3] == "win":
                bat_file = "orc_cmpl.bat"
            else:
                bat_file = "orc_cmpl.csh"
            already_have_v = 0
            for line in open(bat_file):
                line = line.strip()
                if line.startswith("rem"):
                    continue
                if not line: continue
                line_list = re.split(r"\s+", line)
                if line_list[0] in ("vcom", "vlog"):
                    hdl_file = os.path.abspath(line_list[-1])
                    if os.path.isfile(hdl_file):
                        lib_files.append(hdl_file)
                    else:
                        if re.search(r"\*\.v", line_list[-1]):
                            lib_files += list_v
                            already_have_v = 1
                        else:
                            xTools.say_it("Warning. un-support line: %s" % line)
            if not already_have_v:
                lib_files = list_v + lib_files
            recov.comeback()
        else:
            lib_files += list_v
    if bb_file:
        lib_files.append(bb_file)
    return lib_files


def get_bb_file(bb_path, vhd_ver, family, sim_vendor):
    if sim_vendor != "Riviera":
        return

    _file1 = "%s_black_boxes-aldec.vp" % family
    _file2 = "%s_black_boxes_vhdlib-aldec.vp" % family

    if vhd_ver == "verilog":
        maybe_file = [_file1]
    else:
        maybe_file = [_file2, _file1]

    for item in maybe_file:
        bb_file = os.path.join(bb_path, item)
        if os.path.isfile(bb_file):
            return bb_file
    xTools.say_it("Warning. Not found blackbox (vp) file for %s" % family)

def get_lib_file_dict(cae_path, hdl_type, family, sim_vendor, is_ng_flow):
    """
    cae_path    D:\lscc\diamond\3.5_x64\cae_library
    hdl_type    verilog or vhdl or mixed_hdl
    family      ec, ecp, ecp2, ...
    """
    if hdl_type == "mixed_hdl":
        hdl_dirs = ["vhdl", "verilog"]
    else:
        hdl_dirs = [hdl_type]
    lib_file_dict = dict()
    for item in hdl_dirs:
        bb_file = get_bb_file(os.path.join(cae_path, "simulation", "blackbox"), item, family, sim_vendor)
        lib_files = get_lib_file(item, os.path.join(cae_path, "simulation", item, family), bb_file, is_ng_flow)
        lib_file_dict[item] = lib_files
    return lib_file_dict


def vcom_vlog_file_lines(hdl_files, vcom_cmd, vlog_cmd, work_name, vendor_tool=""):
    cmpl_lines = list()
    _is_ice = re.search("ice40up", work_name.lower())
    is_riviera_tplus = ("Riviera" in vendor_tool) and _is_ice or ("Active" in vendor_tool)
    for item in hdl_files:
        fext = xTools.get_fext_lower(item)
        if fext == ".v":
            cmd_exe = vlog_cmd
            if is_riviera_tplus:
                item = " -v2k5 " + item
            if "ovi" not in work_name:
                if "Riviera" in vendor_tool:
                    item = " +define+mixed_hdl " + item
        elif fext == ".vhd":
            cmd_exe = vcom_cmd
        elif fext == ".vp":
            cmd_exe = vlog_cmd
            item = " -v2k " + item
        elif fext == ".f":
            cmd_exe = vlog_cmd
            if re.search("(lifcl|jd5d00|lfcpnx)", work_name.lower()) and "QuestaSim" in vendor_tool:
                cmd_exe += " -sv -mfcu "
            elif "Modelsim" in vendor_tool and os.getenv("YOSE_RADIANT") == "1" and not _is_ice:
                cmd_exe += " -sv -mfcu "
            _path, _file = os.path.split(item)
            if "Active" in vendor_tool:
                two_k_five = "-sv2k5" if re.search("(lifcl|jd5d00)", work_name.lower()) else "-v2k5"
                item = "{} -f {} +incdir+{} ".format(two_k_five, item, _path)
            elif is_riviera_tplus:
                _fo = xTools.win2unix(os.getenv("FOUNDRY"))
                for line in open(item):
                    line = line.strip()
                    line = re.sub("\$FOUNDRY", _fo, line)
                    if line.endswith(".v"):
                        cmpl_lines.append("%s -work %s -v2k5 %s" % (cmd_exe, work_name, line))
                    else:
                        cmpl_lines.append("%s -work %s %s" % (cmd_exe, work_name, line))
                item = ""
            else:
                item = "-f {} +incdir+{} ".format(item, _path)
        else:
            xTools.say_it("Warning. Unknown file %s" % item)
            continue
        if item:
            cmpl_lines.append("%s -work %s %s" % (cmd_exe, work_name, item))
    return cmpl_lines


def change_dot_lib_name(new_lib):
    new_name = os.path.join(new_lib, "{}.lib".format(os.path.basename(new_lib)))
    for foo in os.listdir(new_lib):
        if foo.endswith(".lib"):
            os.rename(os.path.join(new_lib, foo), new_name)
            break


def compile_library(*args):
    diamond_path, hdl_type, family, sim_name, sim_bin_path, sim_vendor, is_ng_flow = args
    # family = family.lower()  # change case due to Linux platform
    cae_path = os.path.join(diamond_path, "cae_library")
    if os.getenv("BALI_USE_FOUNDRY_OUTSIDE") == "1":
        cae_path = os.path.join(diamond_path, "rtf", "cae_library")
    lib_file_dict = get_lib_file_dict(cae_path, hdl_type, family, sim_vendor, is_ng_flow)
    if is_ng_flow:
        no_ovi_sim_name = re.sub("ovi_", "", sim_name)
        has_ovi_sim_name = "ovi_" + no_ovi_sim_name
        if os.path.isdir(no_ovi_sim_name):
            x2y = (no_ovi_sim_name, has_ovi_sim_name)
        elif os.path.isdir(has_ovi_sim_name):
            x2y = (has_ovi_sim_name, no_ovi_sim_name)
        else:
            x2y = None
        if x2y:
            try:
                if not os.path.exists(x2y[1]):
                    shutil.copytree(x2y[0], x2y[1])
                    change_dot_lib_name(x2y[1])
            except OSError:
                pass
            return

    compile_bat_file = "Compile_%s.bat" % sim_name
    bat_lines = list()
    on_win, os_name = xTools.get_os_name()
    if on_win:
        x = "rem set FOUNDRY="
    else:
        x = "# setenv FOUNDRY "
    bat_lines.append('{}{}'.format(x, os.getenv("FOUNDRY")))

    vlib_cmd = "%s/vlib" % sim_bin_path
    vcom_cmd = "%s/vcom" % sim_bin_path
    vlog_cmd = "%s/vlog" % sim_bin_path
    vhdl_files = lib_file_dict.get("vhdl")
    verilog_files = lib_file_dict.get("verilog")
    bat_lines.append("%s/vmap -del %s" % (sim_bin_path, sim_name))
    if vhdl_files:
        bat_lines.append("%s %s" % (vlib_cmd, sim_name))
        bat_lines += vcom_vlog_file_lines(vhdl_files, vcom_cmd, vlog_cmd, sim_name, vendor_tool=sim_vendor)
    elif verilog_files:
        bat_lines.append("%s %s" % (vlib_cmd, sim_name))
        bat_lines += vcom_vlog_file_lines(verilog_files, vcom_cmd, vlog_cmd, sim_name, vendor_tool=sim_vendor)
    else:
        if family != "pmi":
            xTools.say_it("Error. Cannot find HDL library files in {} for {}".format(cae_path, family))
        return 1
    xTools.write_file(compile_bat_file, bat_lines)
    if not on_win:
        compile_bat_file = "sh %s" % compile_bat_file
    sts = xTools.run_command(compile_bat_file, "%s.log" % sim_name, "%s.time" % sim_name)
    return sts


class GetSimulationLibrary:
    def __init__(self, diamond_path, sim_vendor_name, sim_bin_path, hdl_type, family,
                 root_lib_path, is_ng_flow, sim_lib_folder):
        """
        hdl_type: verilog or vhdl
        """
        self.diamond_path = diamond_path
        self.sim_vendor_name = sim_vendor_name
        self.sim_bin_path = xTools.win2unix(sim_bin_path, 0)
        self.hdl_type = hdl_type
        self.family = family
        self.root_lib_path = root_lib_path
        self.is_ng_flow = is_ng_flow
        self.sim_lib_name = ""
        self.sim_lib_folder = sim_lib_folder

    def get_sim_lib_path(self):
        base_dir = os.path.basename(self.sim_lib_path)
        if self.family != "pmi":
            base_dir = re.sub("ovi_", "", base_dir)
            base_dir = "ovi_%s" % base_dir
            sim_lib_path = os.path.dirname(self.sim_lib_path)
            _my = os.path.join(sim_lib_path, base_dir)
        else:
            _my = self.sim_lib_path
        if self.sim_vendor_name == "Riviera":
            _my = os.path.join(_my, base_dir + ".lib")
        return xTools.win2unix(_my)

    def process(self):
        # use longer wait time for compiling simulation library from 5x30 to 20x60
        self.create_sim_lib_path()
        base_dir = os.path.dirname(self.sim_lib_path)
        if xTools.wrap_md(base_dir, "Simulation Library Path"):
            return 1
        recov = xTools.ChangeDir(base_dir)
        lock_file = "%s.lock" % self.sim_name
        if os.path.isdir(self.sim_lib_path):
            xTools.say_it("Check %s" % self.sim_lib_path)
            i = 0
            while True:
                if os.path.isfile(lock_file):
                    xTools.say_it("Message. found lock file: %s" % lock_file)
                    time.sleep(20)
                    i += 1
                else:
                    break
                if i > 300:
                    try:
                        os.remove(lock_file)
                    except:
                        break
                    break
        else:
            xTools.wrap_md(os.path.dirname(self.sim_lib_path), "simulation library path")
            args = (self.diamond_path, self.hdl_type, self.family, self.sim_name, self.sim_bin_path, self.sim_vendor_name, self.is_ng_flow)
            xTools.run_safety(compile_library, lock_file, *args)
            try:
                os.remove(lock_file)
            except:
                pass
        recov.comeback()

    def create_sim_lib_path(self):
        self.sim_name = self.family
        if self.hdl_type == "verilog" and self.sim_name != "pmi":
            self.sim_name = "ovi_" + self.sim_name
        real_path = os.path.join(self.sim_lib_folder, self.sim_name)
        self.sim_lib_path = xTools.win2unix(real_path, 0)


def get_sim_tool_version(tool_bin):
    """
    vsim -version
    # Questa Sim-64 vsim 10.6b Simulator 2017.05 May 26 2017
    Aldec, Inc. Riviera-PRO version 2014.10.81.5580 built for Windows64 on October 24, 2014
    Model Technology ModelSim SE-64 vsim 10.1c Simulator 2012.07 Jul 28 2012
    Aldec, Inc. Active-HDL version 10.5.191.6746 built for Windows on November 17, 2017.
    """
    cmd = "{}/vsim -version".format(xTools.win2unix(tool_bin))
    sts, text = xTools.get_status_output(cmd)
    p = re.compile(r"(Riviera|ModelSim|Questa|Active-HDL).+(vsim|version)\s+(\S+)")
    for line in text:
        m = p.search(line)
        if m:
            return [m.group(1), m.group(3)]


if __name__ == "__main__":
    # a = get_lib_file_dict(r"D:\lscc\diamond\3.5_x64\cae_library", "vhdl", "ecp5u")
    # xTools.say_it(a)
    os.environ["FOUNDRY"] = r"D:\lscc\diamond\3.5_x64\ispfpga"
    os.environ["PATH"] = r"D:\lscc\diamond\3.5_x64\ispfpga\bin\nt64;D:\lscc\diamond\3.5_x64\bin\nt64;%s" % os.getenv("path")
    tst = GetSimulationLibrary(r"D:\lscc\diamond\3.5_x64", "questasim",
                r"C:\questa_sim64_10.1a\win64",
                "verilog", "ecp5u", r"D:\YibinSun\shawn", 0)
    tst.process()

