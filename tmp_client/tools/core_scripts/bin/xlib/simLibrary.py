import os
import sys
import re
import time
import xTools
import xLattice

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

def get_lib_file(hdl_type, family_path, bb_file, is_ng_flow):
    lib_files = list()

    if is_ng_flow:
        family = os.path.basename(family_path)
        if hdl_type == "verilog":
            # append file family.v to lib_files
            # copy other verilog files into cwd due to source line: `include "xxxx.v"
            for foo in os.listdir(family_path):
                fname, fext = os.path.splitext(foo.lower())
                if fext != ".v":
                    continue
                abs_foo = os.path.join(family_path, foo)
                if fname == family:
                    lib_files.append(abs_foo)
                else:
                    if xTools.wrap_cp_file(abs_foo, foo, force=True):
                        return list()
        elif hdl_type == "vhdl":
            maybe_file = family_path + ".vhd"
            if os.path.isfile(maybe_file):
                lib_files.append(maybe_file)
        return lib_files

    p_hdl_type = re.compile("(.+)\Wvhdl\W(\w+)$")
    if hdl_type == "verilog":
        for foo in os.listdir(family_path):
            fext = xTools.get_fext_lower(foo)
            if fext == ".v":
                lib_files.append(os.path.join(family_path, foo))
            elif fext == ".vhd":
                xTools.say_it("Warning. found vhd file in %s" % family_path)
    else: # vhdl
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
                if line.startswith("rem"): continue
                if not line: continue
                line_list = re.split("\s+", line)
                if line_list[0] in ("vcom", "vlog"):
                    hdl_file = os.path.abspath(line_list[-1])
                    if os.path.isfile(hdl_file):
                        lib_files.append(hdl_file)
                    else:
                        if re.search("\*\.v", line_list[-1]):
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

def vcom_vlog_file_lines(hdl_files, vcom_cmd, vlog_cmd, work_name):
    cmpl_lines = list()
    for item in hdl_files:
        fext = xTools.get_fext_lower(item)
        if fext == ".v":
            cmd_exe = vlog_cmd
        elif fext == ".vhd":
            cmd_exe = vcom_cmd
        elif fext == ".vp":
            cmd_exe = vlog_cmd
            item += "  -v2k"
        else:
            xTools.say_it("Warning. Unknown file %s" % item)
            continue
        cmpl_lines.append("%s -work %s %s" % (cmd_exe, work_name, item))
    return cmpl_lines

def compile_library(*args):
    diamond_path, hdl_type, family, sim_name, sim_bin_path, sim_vendor, is_ng_flow = args
    family = family.lower()  # change case due to Linux platform
    cae_path = os.path.join(diamond_path, "cae_library")
    lib_file_dict = get_lib_file_dict(cae_path, hdl_type, family, sim_vendor, is_ng_flow)
    compile_bat_file = "Compile_%s.bat" % sim_name
    bat_lines = list()
    vlib_cmd = "%s/vlib" % sim_bin_path
    vcom_cmd = "%s/vcom" % sim_bin_path
    vlog_cmd = "%s/vlog" % sim_bin_path
    vhdl_files = lib_file_dict.get("vhdl")
    verilog_files = lib_file_dict.get("verilog")
    bat_lines.append("%s/vmap -del %s" % (sim_bin_path, sim_name))
    if vhdl_files:
        bat_lines.append( "%s %s" % (vlib_cmd, sim_name))
        bat_lines += vcom_vlog_file_lines(vhdl_files, vcom_cmd, vlog_cmd, sim_name)
    elif verilog_files:
        bat_lines.append( "%s %s" % (vlib_cmd, sim_name))
        bat_lines += vcom_vlog_file_lines(verilog_files, vcom_cmd, vlog_cmd, sim_name)
    xTools.write_file(compile_bat_file, bat_lines)
    on_win,  os_name = xTools.get_os_name()
    if not on_win:
        compile_bat_file = "sh %s" % compile_bat_file
    sts = xTools.run_command(compile_bat_file, "%s.log" % sim_name, "%s.time" % sim_name)
    return sts

class GetSimulationLibrary:
    def __init__(self, diamond_path, sim_vendor_name, sim_bin_path, hdl_type, family, root_lib_path, is_ng_flow):
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

    def get_sim_lib_path(self):
        base_dir = os.path.basename(self.sim_lib_path)
        base_dir = re.sub("ovi_", "", base_dir)
        base_dir = "ovi_%s" % base_dir
        sim_lib_path = os.path.dirname(self.sim_lib_path)
        _my = os.path.join(sim_lib_path, base_dir)
        if self.sim_vendor_name == "Riviera":
           _my = os.path.join(_my, base_dir + ".lib")
        return _my

    def process(self):
        self.create_sim_lib_path()
        base_dir = os.path.dirname(self.sim_lib_path)
        if xTools.wrap_md(base_dir, "Simulation Library Path"):
            return 1
        recov = xTools.ChangeDir(base_dir)
        lock_file = "%s.lock" % self.sim_name
        if os.path.isdir(self.sim_lib_path):
            xTools.say_it("Check %s" % self.sim_lib_path)
            while True:
                if os.path.isfile(lock_file):
                    xTools.say_it("Message. found lock file: %s" % lock_file)
                    time.sleep(5)
                else:
                    break
        else:
            xTools.wrap_md(self.sim_lib_path, "simulation library path")
            args = (self.diamond_path, self.hdl_type, self.family, self.sim_name, self.sim_bin_path, self.sim_vendor_name, self.is_ng_flow)
            xTools.run_safety(compile_library, lock_file, *args)
            os.remove(lock_file)
        recov.comeback()

    def create_sim_lib_path(self):
        diamond_version = xLattice.get_diamond_version()
        ver_name = "Diamond" + "".join(diamond_version)
        self.sim_name = self.family
        if self.hdl_type == "verilog":
            self.sim_name = "ovi_" + self.sim_name
        real_path = os.path.join(self.root_lib_path, self.sim_vendor_name, ver_name, self.sim_name)
        self.sim_lib_path = xTools.win2unix(real_path, 0)


if __name__ == "__main__":
    # a = get_lib_file_dict(r"D:\lscc\diamond\3.5_x64\cae_library", "vhdl", "ecp5u")
    # xTools.say_it(a)
    os.environ["FOUNDRY"] = r"D:\lscc\diamond\3.5_x64\ispfpga"
    os.environ["PATH"] = r"D:\lscc\diamond\3.5_x64\ispfpga\bin\nt64;D:\lscc\diamond\3.5_x64\bin\nt64;%s" % os.getenv("path")
    tst = GetSimulationLibrary(r"D:\lscc\diamond\3.5_x64", "questasim",
                r"C:\questa_sim64_10.1a\win64",
                "verilog", "ecp5u", r"D:\YibinSun\shawn", 0)
    tst.process()

