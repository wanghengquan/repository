import os
import re
import glob
import time
import shutil
import platform

import xTools
import xReport
import xLatticeDev
import xCommandFlow


__author__ = 'syan'
# ------------- name ------- for Diamond -------- for DiamondNG
TCL_COMMAND = {"close"   : ["prj_project close", "prj_close"],
               "save"    : ["prj_project save", "prj_save"],
               "add_src" : ["prj_src add", "prj_add_source"],
               "new"     : ["prj_project new", "prj_create"],
               "open"    : ["prj_project open", "prj_open"],
               "set_syn" : ["prj_syn set", "prj_syn set"],
               "copy_sty": ["prj_strgy copy", "prj_copy_strategy"],
               "set_sty" : ["prj_strgy set", "prj_set_strategy"],
               "set_sty_val":["prj_strgy set_value", "prj_set_strategy_value"],
               "set_dev" : ["prj_dev set", "prj_set_device"],
               }

def is_lse_twr(twr_file):
    p = re.compile("Lattice\s+Synthesis\s+Timing\s+Report", re.I)
    i = 0
    for line in open(twr_file):
        if p.search(line):
            return 1
        i += 1
        if i > 30:
            break

def copy_impl_dir_to_target(src_impl, dst_impl, copy_ncd=False):
    if xTools.wrap_md(dst_impl, "Destination Implementation Path"):
        return 1
    for foo in os.listdir(src_impl):
        src_foo = os.path.join(src_impl, foo)
        dst_foo = os.path.join(dst_impl, foo)
        fname, fext = os.path.splitext(foo.lower())
        if re.search("_map$", fname):
            continue
        if fext == ".dir":
            if xTools.wrap_move_file_folder(src_foo, dst_foo):
                return 1
        # copy
        elif fext in (".prf", ".mrp") or re.search("\.p\d*t", fext):
            if xTools.wrap_cp_file(src_foo, dst_foo):
                return 1
        # move
        elif fext in (".twr", ".pad", ".par"):
            if fext == ".twr":  # LSE will generate the _lse.twr file
                if is_lse_twr(src_foo):
                    continue
            if xTools.wrap_move_file_folder(src_foo, dst_foo):
                return 1
        # del
        elif fext == ".ncd":
            if copy_ncd:
                if xTools.wrap_move_file_folder(src_foo, dst_foo):
                    return 1
            else:
                os.remove(src_foo)

def move_bak_results(tcl_file, impl_name, target_path, flow_sts):
    if flow_sts:
        ext_dir = "_Failed"
    else:
        ext_dir = ""
    target_path += ext_dir
    if xTools.wrap_md(target_path, "Target Path"):
        return 1
    tcl_name = xTools.get_fname(tcl_file)
    cur_dir = os.getcwd()
    try:
        for foo in os.listdir(cur_dir):
            abs_foo = os.path.join(cur_dir, foo)
            dst_foo = os.path.join(target_path, foo)
            if os.path.isfile(abs_foo):
                fname, fext = os.path.splitext(foo)
                if fname == tcl_name:
                    shutil.move(abs_foo, dst_foo)
                elif fext.lower() in (".ldf", ".lpf", ".sty", ".rdf"):
                    shutil.copy(abs_foo, dst_foo)
            else:
                if foo == impl_name:
                    if copy_impl_dir_to_target(abs_foo, dst_foo):
                        return 1
    except Exception, e:
        xTools.say_it(e)
        return 1

def create_empty_lpf(lpf_file):
    lpf_lines = ["BLOCK RESETPATHS ;", "BLOCK ASYNCPATHS ;", "BLOCK INTERCLOCKDOMAIN PATHS ;"]
    xTools.write_file(lpf_file, lpf_lines)

def wrap_run_tcl(tcl_mark_name, tcl_lines):
    tcl_file = tcl_mark_name + ".tcl"
    xTools.write_file(tcl_file, tcl_lines)
    sts = xTools.run_command("pnmainc %s" % tcl_file, tcl_mark_name+".log", tcl_mark_name+".time")
    return sts

def run_ldf_file(tcl_file, ldf_file, process_task, flow_settings=list(), is_ng_flow=False):
    """
    run test flow with ldf file
    use flow_settings can change any strategy settings
    process_task pairs can specify which process will be done

    flow_settings sample:
      ['prj_strgy set_value -strategy dsf par_place_iterator_start_pt=5',
       'prj_strgy set_value -strategy dsf map_io_reg=Both']

    process_task sample:
      [
      ("Map", "MapVerilogSimFile"),
      ("PAR", ""),
      ("Export", "TimingSimFileVHD"),
      ]

    @2016/10/18 ignore the failed export flow
    """
    if is_ng_flow:
        tcl_cmd = {key:value[1] for key, value in TCL_COMMAND.items()}
    else:
        tcl_cmd = {key:value[0] for key, value in TCL_COMMAND.items()}
    tcl_lines = list()
    tcl_lines.append('%s "%s"' % (tcl_cmd.get("open"), ldf_file))
    for setting in flow_settings:
        tcl_lines.append(setting)
    tcl_lines.append('%s "%s"' % (tcl_cmd.get("save"), ldf_file))
    for (process, task) in process_task:
        if task:
            task = "-task %s" % task
        _line = "prj_run %s %s -forceOne" % (process, task)
        if process == "Export":
            _line = "set r [catch {%s} msg]" % _line
            tcl_lines.append(_line)
            tcl_lines.append('puts "$msg"')
        else:
            tcl_lines.append(_line)
    tcl_lines.append('%s "%s"' % (tcl_cmd.get("save"), ldf_file))
    tcl_lines.append(tcl_cmd.get("close"))
    return wrap_run_tcl(xTools.get_fname(tcl_file), tcl_lines)

def get_clocks_from_mrp_file(mrp_file):
    """
    get clock list from lattice .mrp file
    """
    p_number_of_clocks = re.compile("Number\s+of\s+clocks:\s+(\d+)")
    p_net_clock = re.compile("Net\s+([^:]+):")
    p_number_of_clock_enables = re.compile("Number\s+of\s+Clock\s+Enables:")
    p_skip_list = [re.compile("^Page\s+\d+$"),
                   re.compile("^Design:\s+\S+\s+Date:"),
                   re.compile("^Design\s+Summary"),
                   re.compile("^-+$")]
    # -- get clock line list
    clock_number, clock_lines = 0, list()
    for line in open(mrp_file):
        if not clock_number:
            m_noc = p_number_of_clocks.search(line)
            if m_noc:
                clock_number = int(m_noc.group(1))
        else: # start getting the clock line
            line = line.strip()
            if p_number_of_clock_enables.search(line):
                break
            for p_skip in p_skip_list:
                if p_skip.search(line):
                    break
            else:
                clock_lines.append(line)
    clock_lines_string = " ".join(clock_lines)
    # -- get clocks list
    clocks = list()
    if clock_number:
        m_clock = p_net_clock.findall(clock_lines_string)
        for item in m_clock:
            clocks.append(re.sub("\s+", "", item))
    assert clock_number == len(clocks), "Mismatch clock number in <%s>" % os.path.abspath(mrp_file)
    return clocks

def update_lpf_file(lpf_file, fmax, all_clocks=list()):
    p_fre = re.compile('''^(FREQUENCY\s+\S+\s+"([^"]+)")\s+
                          ([\d\.]+\s+MHz)
                          ''', re.I | re.X)
    ori_lpf_lines = xTools.get_original_lines(lpf_file, all_clocks)
    new_lpf_lines = list()
    for line in ori_lpf_lines:
        line_strip = line.strip()
        new_line = line.rstrip()
        if line_strip.startswith("#"):
            new_lpf_lines.append(new_line)
            continue
        m_fre = p_fre.search(new_line)
        if not m_fre:
            new_lpf_lines.append(new_line)
        else:
            if all_clocks:
                continue
            else: # use current clocks
                new_line = p_fre.sub(r"\1 %.3f MHz" % fmax, line_strip)
                new_lpf_lines.append(new_line)
    if all_clocks:
        for item in all_clocks:
            new_lpf_lines.append('FREQUENCY NET "%s" %.3f MHz ; ' % (item, fmax))
    return xTools.write_file(lpf_file, new_lpf_lines)

def get_diamond_version():
    _path = os.getenv("MY_B_BIN")
    if not _path:
        return "", ""
    trce_cmd = os.path.join(_path, "trce")
    sts, text = xTools.get_status_output(trce_cmd)
    p = re.compile("""version\s+Diamond
                       .*\s+
                       (\d+\.\d+)
                       ([\d\.]+)""", re.X)
    big_version, small_version = "", ""
    for line in text:
        m = p.search(line)
        if m:
            big_version, small_version = m.group(1), m.group(2)
            break
    else:
         xTools.say_it("-Warning. Can not get diamond version from <trce>")
    return big_version, small_version

def _get_bali_version(raw_version):
    my_version = re.sub("\D", "", raw_version)
    return float(my_version)

def update_diamond_version(ldf_file, current_version):
    """
    make sure the old diamond can launch the project file which was created in new diamond
    """
    if not current_version:
        return
    p_version = re.compile('BaliProject.+version=\W([\d\.]+)\W')
    ldf_version = xReport.file_simple_parser(ldf_file, [p_version])
    if not ldf_version:
        # change error to warning and do nothing
        xTools.say_it("-Warning. Not found BaliProject version in %s" % ldf_file)
        return
    ldf_version = ldf_version[0]
    if _get_bali_version(ldf_version) <= _get_bali_version(current_version):
        return
    # only updated when use old diamond launch new diamond project file
    xTools.say_it("Change BaliProject version from %s to %s" % (ldf_version, current_version))
    ldf_lines = open(ldf_file).readlines()
    new_ldf = open(ldf_file, "w")
    for line in ldf_lines:
        m_version = p_version.search(line)
        if m_version:
            line = re.sub('version=\W([\d\.]+)\W', 'version="%s"' % current_version, line)
        new_ldf.write(line)
    new_ldf.close()

class LatticeEnvironment:
    def __init__(self, flow_options):
        self.x86 = flow_options.get("x86")
        self.loose_match = xTools.get_true(flow_options, "loose_match")
        self.diamond = flow_options.get("diamond")
        self.diamond_lin = flow_options.get("diamond_lin")
        self.diamond_sol = flow_options.get("diamond_sol")
        self.diamond_fe = flow_options.get("diamond_fe")
        self.diamond_be = flow_options.get("diamond_be")
        self.rtf = flow_options.get("rtf")
        self.environment = flow_options.get("environment")
        self.set_env = flow_options.get("set_env")
        self.modelsim_path = flow_options.get("modelsim_path")
        self.simrel_path = flow_options.get("simrel_path")
        self.questasim_path = flow_options.get("questasim_path")
        self.riviera_path = flow_options.get("riviera_path")
        self.run_modelsim = xTools.get_true(flow_options, "run_modelsim")
        self.run_questasim = xTools.get_true(flow_options, "run_questasim")
        self.run_riviera = xTools.get_true(flow_options, "run_riviera")
        self.sim_rtl = xTools.get_true(flow_options, "sim_rtl")
        self.sim_syn_vlg = xTools.get_true(flow_options, "sim_syn_vlg")
        self.sim_syn_vhd = xTools.get_true(flow_options, "sim_syn_vhd")
        self.sim_map_vlg = xTools.get_true(flow_options, "sim_map_vlg")
        self.sim_map_vhd = xTools.get_true(flow_options, "sim_map_vhd")
        self.sim_par_vlg = xTools.get_true(flow_options, "sim_par_vlg")
        self.sim_par_vhd = xTools.get_true(flow_options, "sim_par_vhd")
        self.sim_all = xTools.get_true(flow_options, "sim_all")
        self.run_simrel = flow_options.get("run_simrel")
        self.debug = flow_options.get("debug")
        self.sim_vendor_name = ""

    def process(self):
        self.set_fixed_env()
        self.ori_path_value = os.getenv("PATH", "")
        self.on_win, self.nt_lin = xTools.get_os_name(self.x86)
        if self.loose_match:
            self.on_win, self.nt_lin_64 = xTools.get_os_name(0)
            self.on_win, self.nt_lin_86 = xTools.get_os_name(1)
        if self.rtf:
            if xTools.not_exists(self.rtf, "RTF Path"):
                return 1
            _rtf = os.path.abspath(self.rtf)
            os.environ["FOUNDRY"] = _rtf
            os.environ["PATH"] = os.path.join(_rtf, "bin", self.nt_lin)
        else:
            if self.get_diamond_fe_be():
                return 1
            if self.get_sim_vendor_name():
                return 1

        sts = self.set_fe_env()
        if sts:
            return sts
        # set environment for pre/post process
        self.set_pre_post_environment()

    def set_pre_post_environment(self):
        """Will set environment for:
        INTERNAL_DIAMOND_PATH:     from the final trunk diamond value
        INTERNAL_MODELSIM_PATH:    from the final trunk modelsim_path value
        INTERNAL_QUESTASIM_PATH:    from the final trunk questasim_path value
        INTERNAL_RIVIERA_PATH:       from the final trunk riviera_path value
        INTERNAL_ICECUBE_PATH:      from the final trunk icecube_path value
        """
        os.environ["INTERNAL_DIAMOND_PATH"] = os.path.dirname(os.getenv("FOUNDRY", "NoDiamond"))
        os.environ["INTERNAL_MODELSIM_PATH"] = self.modelsim_path
        os.environ["INTERNAL_QUESTASIM_PATH"] = self.questasim_path
        os.environ["INTERNAL_RIVIERA_PATH"] = self.riviera_path
        os.environ["INTERNAL_ICECUBE_PATH"] = "NotSupportICECUBE in run_lattice.py"

    def will_run_simulation(self):
        return self.sim_vendor_name

    def set_fixed_env(self):
        if self.environment:
            for key, value in self.environment.items():
                env_key = key.upper()
                if type(value) is list:
                    value = os.pathsep.join(value)
                if env_key in ("PATH", "LD_LIBRARY_PATH"):
                    value = os.pathsep.join([value, os.getenv(env_key, "")])
                os.environ[env_key] = value
        if self.set_env:
            env_list = re.split(";", self.set_env)
            for item in env_list:
                xTools.say_it("Set %s" % item)
                env_val = re.split("=", item)
                if len(env_val) != 2:
                    xTools.say_it("Warning. Can not set %s" % item)
                    continue
                env_key, env_value = env_val
                os.environ[env_key.strip()] = env_value.strip()

    def get_right_diamond(self, diamond_path):
        if not self.loose_match:
            return diamond_path
        diamond_86 = re.sub("_x64$", "", diamond_path)
        diamond_64 = diamond_86 + "_x64"
        tmp_nt_lin = [  (diamond_64, self.nt_lin_64),
                        (diamond_86, self.nt_lin_86), ]
        if self.x86:
            tmp_nt_lin.reverse()
        for (d, n) in tmp_nt_lin:
            dn = os.path.join(d, "bin", n)
            if os.path.isdir(dn):
                self.nt_lin = n
                return d
        return diamond_path # original path

    def get_diamond_fe_be(self):
        if self.diamond_fe or self.diamond_be:
            pass
        else:
            if self.on_win:
                _diamond = self.diamond
            elif self.nt_lin.startswith("lin"):
                _diamond = self.diamond_lin
            elif self.nt_lin.startswith("sol"):
                _diamond = self.diamond_sol
            else:
                xTools.say_it("-Error. Check get_os_name() please.")
                return 1
            self.diamond_fe = self.diamond_be = _diamond
        self.diamond_fe = self.get_right_diamond(self.diamond_fe)
        self.diamond_be = self.get_right_diamond(self.diamond_be)
        if xTools.not_exists(self.diamond_fe, "Diamond Frontend"):
            return 1
        if xTools.not_exists(self.diamond_be, "Diamond Backend"):
            return 1

    def set_fe_env(self):
        if self.set_diamond_env(self.diamond_fe):
            return 1

    def set_be_env(self):
        if self.diamond_fe == self.diamond_be:
            return
        return self.set_diamond_env(self.diamond_be)

    def set_diamond_env(self, diamond):
        if self.rtf:
            return
        diamond = os.path.abspath(diamond)
        _foundry = os.path.join(diamond, "ispfpga")
        _path_a = os.path.join(diamond, "bin", self.nt_lin)
        _path_b = os.path.join(_foundry, "bin", self.nt_lin)
        os.environ["MY_A_BIN"] = _path_a
        os.environ["MY_B_BIN"] = _path_b
        if xTools.not_exists(_path_a, "Diamond Path"):
            return 1
        if xTools.not_exists(_path_b, "Diamond Path"):
            return 1
        path_list = [_path_a, _path_b, self.ori_path_value]
        if self.sim_vendor_name:
            path_list.insert(0, self.sim_vendor_name)
            os.environ["SIM_VENDOR_BIN"] = self.sim_vendor_name
        if self.on_win:
            exe_path = "NT"
        else:
            exe_path = "unix"
        os.environ["MY_EXE"] = os.path.join(diamond, "ispfpga", "userware", exe_path, "bin", self.nt_lin)
        os.environ["FOUNDRY"] = _foundry
        os.environ["PATH"] = os.pathsep.join(path_list)
        if not self.on_win:
            os.environ["LD_LIBRARY_PATH"] = os.pathsep.join(path_list[:-1] + [os.path.join(diamond, "tcltk", "lib")])
            os.environ["TCL_LIBRARY"] = os.path.join(diamond, "tcltk", "lib", "tcl8.5")

    def get_sim_vendor_name(self):
        will_run_sim = 0
        for item in (self.sim_all, self.sim_rtl,
                     self.sim_syn_vhd, self.sim_syn_vlg,
                     self.sim_map_vhd, self.sim_map_vlg,
                     self.sim_par_vhd, self.sim_par_vlg ):
            if item:
                will_run_sim = 1
                break
        self.sim_vendor_name = ""
        if will_run_sim:
            if self.run_modelsim:
                self.sim_vendor_name = self.modelsim_path
            elif self.run_questasim:
                self.sim_vendor_name = self.questasim_path
            elif self.run_riviera:
                self.sim_vendor_name = self.riviera_path
            else: # Active-HDL
                self.sim_vendor_name = os.path.join(self.diamond_fe, "active-hdl", "BIN")
            if xTools.not_exists(self.sim_vendor_name, "Simulation Vendor Tool Path"):
                return 1

def update_synthesis_tool(ldf_file, synthesis, devkit):
    """
    Modify synthesis name in the ldf file
    use raw spelling for device setting. raised by Ling
    """
    ldf_lines = open(ldf_file).readlines()
    new_ldf = open(ldf_file, "w")
    p_synthesis = re.compile('\s+synthesis="[^"]+"\s+')
    p_device =    re.compile('\s+device="[^"]+"\s+')
    new_string = ' synthesis="%s" ' % synthesis
    for line in ldf_lines:
        new_line = p_synthesis.sub(new_string, line)
        if devkit:
            new_line = p_device.sub(' device="%s" ' % devkit, new_line)
        new_ldf.write(new_line)
    new_ldf.close()

class UpdateLDF:
    def __init__(self, ldf_file, final_ldf_file, empty_lpf, copy_all=""):
        self.ldf_file = ldf_file
        self.ldf_dir = os.path.dirname(self.ldf_file)
        self.final_ldf_file = final_ldf_file
        self.empty_lpf = empty_lpf
        self.copy_all = copy_all
        self.p_source = re.compile('source\s+name="([^"]+)"', re.I)
        # self.p_strategy = re.compile('strategy\s+name.+\s+file="([^"]+)"', re.I)
        # <Strategy file="./Strategy1.sty" name="Strategy1"/>
        # <Strategy name="Strategy1" file="Strategy1.sty"/>
        self.p_strategy = re.compile('<strategy.+file="(\S+\.sty)"', re.I)

        # LDF include path
        self.p_inc_path_name = re.compile('name="include\s+path"')
        self.p_inc_path_list = re.compile('value="([^"]+)"')

    def process(self):
        self.copy_ngo_file_if_have()
        final_lines = list()
        for line in open(self.ldf_file):
            m_source = self.p_source.search(line)
            m_strategy = self.p_strategy.search(line)
            src_file = ""
            if m_source:
                src_file = m_source.group(1)
            elif m_strategy:
                src_file = m_strategy.group(1)
            if src_file:
                real_src_file = xTools.get_relative_path(src_file, self.ldf_dir)
                fext = xTools.get_fext_lower(real_src_file)
                if fext in (".sty", ".lpf"):
                    _t = os.path.basename(real_src_file)
                    if fext == ".sty":
                        self.update_sty_file(real_src_file, _t)
                        # pty file
                        pty_file = re.sub("_setting\.sty$", ".pty", real_src_file)
                        if os.path.isfile(pty_file):
                            self.update_sty_file(pty_file, os.path.basename(pty_file))
                    elif fext == ".lpf":
                        self.update_lpf_file(real_src_file, _t)
                    real_src_file = _t

                if re.search("\(", src_file):
                    # <Source name="../import/PCK_CRC32_D8_(AAL5).vhd" type="VHDL" type_short="VHDL">
                    src_file = re.sub("\(", r"\(", src_file)
                    src_file = re.sub("\)", r"\)", src_file)
                line = re.sub(src_file, real_src_file, line)
            else:
                line = self.update_inc_path(line)
            line = line.rstrip()
            final_lines.append(line)
        xTools.write_file(self.final_ldf_file, final_lines)


    def copy_ngo_file_if_have(self):
        """
        copy all files/dirs under $ldf_file base path if copy_all is True
        """
        if self.copy_all:
            for foo in os.listdir(self.ldf_dir):
                abs_foo = os.path.join(self.ldf_dir, foo)
                if os.path.exists(foo):
                    continue
                if os.path.isfile(abs_foo):
                    shutil.copy2(abs_foo, foo)
                else:
                    shutil.copytree(abs_foo, foo)
        else:
            for foo in os.listdir(self.ldf_dir):
                fext = xTools.get_fext_lower(foo)
                hot_exts = [".ngo"]
                if fext in hot_exts:
                    src_ngo = os.path.join(self.ldf_dir, foo)
                    dst_ngo = foo
                    if xTools.wrap_cp_file(src_ngo, dst_ngo):
                        return 1

    def update_inc_path(self, line):
        m_inc_path_name = self.p_inc_path_name.search(line)
        if m_inc_path_name:
            m_path_list = self.p_inc_path_list.search(line)
            if m_path_list:
                path_string = m_path_list.group(1)
                path_list = re.split("\s*;\s*", path_string)
                new_inc_list = [xTools.get_relative_path(item, self.ldf_dir) for item in path_list]
                line = re.sub(path_string, ";".join(new_inc_list), line)
        return line

    def update_sty_file(self, sty_file, new_sty):
        # ///////////////////
        # <Property name="PROP_BD_EdfInLibPath" value="../others" time="0"/>
        p_sty1 = re.compile('Path"\s+value="([^"]+)"')
        p_sty2 = re.compile('Num[^"]+Path"\s+value="') # <Property name="PROP_SYN_EdfNumCritPath" value="3" time="0"/>
        # <Property name="PROP_MAP_GuideFileMapDes" value="guide_map.ncd" time="0"/>
        # <Property name="PROP_PAR_ParNCDGuideFile" value="" time="0"/>
        # <Property name="PROP_PAR_ParMultiNodeList" value="node_file.txt" time="0"/>
        p_sty_file = re.compile('''(PROP_PAR_ParMultiNodeList|
                                    PROP_PAR_ParNCDGuideFile|
                                    PROP_MAP_GuideFileMapDes)"\s+
                                    value="([^"]+)"''', re.X)

        if xTools.not_exists(sty_file, "Strategy File"):
            return
        else:
            new_lines = list()
            for line in open(sty_file):
                m_sty1 = p_sty1.search(line)
                m_sty2 = p_sty2.search(line)
                if m_sty1 and (not m_sty2):
                    old_value = m_sty1.group(1)
                    old_value_list = re.split(";", old_value)
                    new_value_list = list()
                    for item in old_value_list:
                        item = item.strip()
                        if not item:
                            continue
                        new_value_list.append(xTools.get_relative_path(item, self.ldf_dir))
                    # in case of . in old_value
                    old_value = re.sub("\.", "\.", old_value)
                    line = re.sub(old_value, ";".join(new_value_list), line)
                else:
                    m_file = p_sty_file.search(line)
                    if m_file:
                        need_file = m_file.group(2)
                        src_need_file = xTools.get_relative_path(need_file, self.ldf_dir)
                        dst_need_file = os.path.basename(need_file)
                        property_name = m_file.group(1)
                        self.update_node_file(src_need_file, dst_need_file, property_name)
                        line = p_sty_file.sub('%s" value="%s"' % (property_name, dst_need_file), line)
                line = line.rstrip()
                new_lines.append(line)
            xTools.write_file(new_sty, new_lines)

    def update_node_file(self, src_node_file, dst_node_file, property_name):
        if xTools.not_exists(src_node_file, "Source node file"):
            return 1
        if property_name != "PROP_PAR_ParMultiNodeList":
            return xTools.wrap_cp_file(src_node_file, dst_node_file)
        sts, conf_options = xTools.get_conf_options(src_node_file)
        if sts:
            return 1
        platform_name = platform.uname()
        host_type, host_name = platform_name[0], platform_name[1]
        if host_type == "Linux":
            host_type = "linux"
        else:
            host_type = "pc"
        if len(conf_options) == 1: # only one section
            corenum, env, workdir = "", "", ""
            for key, value in conf_options.items():
                corenum = value.get("corenum")
                env = value.get("env")
                workdir = value.get("workdir")
            dst_lines = list()
            dst_lines.append("[%s]" % host_name)
            dst_lines.append("system = %s" % host_type)
            if corenum:
                dst_lines.append("corenum = %s" % corenum)
            if host_type != "pc":
                if env:
                    dst_lines.append("env = %s" % env)
                if workdir:
                    new_workdir = os.path.basename(workdir)
                    dst_lines.append("workdir = %s" % xTools.win2unix(new_workdir, use_abs=1))
            xTools.write_file(dst_node_file, dst_lines)
        else:
            return xTools.wrap_cp_file(src_node_file, dst_node_file)

    def update_lpf_file(self, lpf_file, new_lpf):
        if self.empty_lpf:
            create_empty_lpf(new_lpf)
        else:
            xTools.wrap_cp_file(lpf_file, new_lpf)

p_pmi_family = re.compile('pmi_family\s+=?>?:?\s+[^"]*"([^"]+)"')

def update_vhd_file(vhd_file, family_name):
    """
    Tony asked. update pmi vhd file with new family name
    """
    vhd_file_lines = open(vhd_file).readlines()
    vhd_ob = open(vhd_file, "w")
    for line in vhd_file_lines:
        m = p_pmi_family.search(line)
        if m:
            old_name = m.group(1)
            line = re.sub('"%s"' % old_name, '"%s"' % family_name, line)
        vhd_ob.write(line)
    vhd_ob.close()

def update_include_line(v_file, diamond, family_name):
    """
    Previous only change the first 10 lines.
    But sometimes the hdl file may have multi-lines for comments
    so change the method: replace the line only before found the module line.
    """
    p_include = re.compile("^(\s*\Winclude\s+\S+cae_library)")
    p_module = re.compile("^module\s+", re.I)
    p_family = re.compile('pmi_family\s*=\s*"([^"]+)"')
    new_library = xTools.win2unix(r'`include "%s\cae_library' % diamond, 0)
    v_syn_file = os.path.splitext(v_file)[0] + "_syn.v"
    will_be_upd = [v_file]
    if os.path.isfile(v_syn_file):
        will_be_upd.append(v_syn_file)

    for item in will_be_upd:
        item_lines = open(item).readlines()
        new_ob = open(item, "w")
        updated_ok = 0
        for i, line in enumerate(item_lines):
            if not updated_ok:
                tmp_line = line.strip()
                if re.search("^//", tmp_line):
                    pass
                else:
                    if p_module.search(tmp_line):
                        updated_ok = 1
                    else:
                        line = p_include.sub(new_library, line)
            m = p_family.search(line)
            if m:
                old_name = m.group(1)
                line = re.sub('"%s"' % old_name, '"%s"' % family_name, line)
            new_ob.write(line)
        new_ob.close()

class CreateDiamondProjectFile:
    """
    if run PMI cases:
        1) update include line in the .v, or:
        2) copy the current pmi_def.vhd to the source path
    """
    def __init__(self, flow_options):
        self.is_ng_flow = flow_options.get("is_ng_flow")
        self.ldf_file = flow_options.get("ldf_file")
        if self.is_ng_flow:
            self.ldf_file = flow_options.get("rdf_file")
        self.others_path = flow_options.get("others_path")
        self.devkit = flow_options.get("devkit")
        self.top_module = flow_options.get("top_module")
        self.project_name = flow_options.get("project_name", "PrjName")
        self.impl_name = flow_options.get("impl_name", "Impl")
        self.impl_dir = self.impl_name
        self.lpf_file = flow_options.get("lpf_file")
        if not self.lpf_file:
            self.lpf_file = flow_options.get("base_lpf")
        self.seed_lpf = flow_options.get("seed_lpf")
        self.src_files = flow_options.get("src_files")
        self.inc_path = flow_options.get("inc_path")
        self.edf_file = flow_options.get("edf_file")
        self.copy_all = xTools.get_true(flow_options, "copy_all")

        self.use_sdc = xTools.get_true(flow_options, "use_sdc")
        self.seed_sweep = flow_options.get("seed_sweep")
        self.src_design = flow_options.get("src_design")
        self.dst_design = flow_options.get("dst_design")

        self.strategy = flow_options.get("strategy")
        self.goal = flow_options.get("goal")
        self.synthesis = flow_options.get("synthesis")
        self.run_scuba = flow_options.get("run_scuba")
        self.fanout = flow_options.get("fanout")
        self.frequency = flow_options.get("frequency")
        self.mixed_drivers = xTools.get_true(flow_options, "mixed_drivers")
        self.block_lpf = xTools.get_true(flow_options, "block_lpf")
        self.empty_lpf = xTools.get_true(flow_options, "empty_lpf")
        self.set_strategy = flow_options.get("set_strategy")
        self.pmi = xTools.get_true(flow_options, "pmi")
        self.use_ori_clks = xTools.get_true(flow_options, "use_ori_clks")
        self.synthesis_done = xTools.get_true(flow_options, "synthesis_done")
        self.synthesis_only = xTools.get_true(flow_options, "synthesis_only")
        self.run_synthesis = xTools.get_true(flow_options, "run_synthesis")
        if self.synthesis_only:
            self.run_synthesis = True
        self.clean = xTools.get_true(flow_options, "clean")
        self.dry_run = xTools.get_true(flow_options, "dry_run")
        self.flow_options = flow_options

        self.map_done = xTools.get_true(flow_options, "map_done")

        self.scuba_type = flow_options.get("scuba_type")
        self.sim_rtl = xTools.get_true(flow_options, "sim_rtl")
        self.sim_others = 0  # used with scuba_type
        for item in ("sim_map_vlg", "sim_map_vhd", "sim_par_vlg", "sim_par_vhd", "sim_all", "sim_syn_vhd", "sim_syn_vlg"):
            if xTools.get_true(flow_options, item):
                self.sim_others = 1
                break
        if self.is_ng_flow:
            self.tcl_cmd = {key:value[1] for key, value in TCL_COMMAND.items()}
        else:
            self.tcl_cmd = {key:value[0] for key, value in TCL_COMMAND.items()}
        for item in ("sim_syn_vhd", "sim_syn_vlg"):
            if xTools.get_true(flow_options, item):
                self.run_synthesis = True
                break
    def process(self):
        if self.ldf_file:
            if self.get_real_ldf_file():
                return 1
            self.final_ldf_file = os.path.basename(self.ldf_file)
        else:
            if self.is_ng_flow:
                self.final_ldf_file = self.project_name + ".rdf"
            else:
                self.final_ldf_file = self.project_name + ".ldf"
        if self.map_done:
            return

        if self.synthesis_done:
            return
        if self.src_files or self.edf_file or self.ldf_file:
            if self.clean:
                xTools.remove_dir_without_error(self.dst_design)
                xTools.wrap_md(self.dst_design, "Job Working Design Path")
            else:
                xTools.remove_dir_without_error(self.impl_dir)
            # can use tcl console
            if self.copy_other_files():
                return 1

            if self.ldf_file:
                sts = self.update_ldf_file()
            else:
                sts = self.generate_ldf_file()
            if sts:
                return 1
            self.ldf_dict = parse_ldf_file(self.final_ldf_file, self.is_ng_flow)
            if not self.ldf_dict:
                return 1
            # xTools.say_it(self.ldf_dict)
            impl_node = self.ldf_dict.get("impl")
            self.impl_name = impl_node.get("title")
            if self.run_scuba:
                source_files = self.ldf_dict.get("source")
                _a_sts, new_source_files = run_scuba_flow(source_files, self.run_scuba)
                if _a_sts:
                    return 1
                self.update_ldf_and_dict(new_source_files)
                self.new_src_files = new_source_files[:]

            if not sts:
                sts = self.add_strategy_and_synthesis()
            return sts
        else:
            xTools.say_it("-Error. No src_files/edf_file/ldf_file found, can't use tcl flow")
            return 1

    def get_real_ldf_file(self):
        """ support match character for ldf_file option in info file, Yibin asked!
        """
        sts = 0
        if re.search("\*", self.ldf_file):
            _local_recov = xTools.ChangeDir(self.src_design)
            _ldf_files = glob.glob(self.ldf_file)
            if xTools.check_file_number(_ldf_files, "LDF file"):
                sts = 1
            ldf_gotten = _ldf_files[0]
            self.ldf_file = os.path.abspath(ldf_gotten)
            _local_recov.comeback()
        return sts

    def update_ldf_and_dict(self, new_source_files):

        def _update_ldf_file(ldf_file, ori_file, new_file):
            src = xTools.win2unix(ori_file, 0)
            dst = xTools.win2unix(new_file, 0)
            ldf_lines = open(ldf_file).readlines()
            ldf_ob = open(ldf_file, "w")
            p_src = re.compile(src)
            for line in ldf_lines:
                if p_src.search(line):
                    fext = xTools.get_fext_lower(dst)
                    if fext == ".v":
                        hdl = "Verilog"
                    else:
                        hdl = "VHDL"
                    new_line = '        <Source name="%s" type="%s" type_short="%s">' % (dst, hdl, hdl)
                    print >> ldf_ob, new_line
                else:
                    ldf_ob.write(line)
            ldf_ob.close()

        update_ldf_mark = 0
        for ori_file, new_file in new_source_files:
            if not new_file:
                continue
            update_ldf_mark = 1
            _update_ldf_file(self.final_ldf_file, ori_file, new_file)

        if update_ldf_mark:
            self.ldf_dict = parse_ldf_file(self.final_ldf_file, self.is_ng_flow)

    def copy_other_files(self):
        if self.others_path:
            hot_files = (".ngc", ".hex", ".mif", ".ngo", ".txt", ".mem", "", ".prf", ".rom")  # add the file without extension
            # add .prf for 1TX/2TX design, which should use run_trce.prf for trce flow
            _others_path = xTools.get_relative_path(self.others_path, self.src_design)
            if xTools.not_exists(_others_path, "Others Path"):
                return 1
            for foo in os.listdir(_others_path):
                fname, fext = os.path.splitext(foo.lower())
                if fext in hot_files:
                    if foo == ".recovery":
                        continue
                    abs_foo = os.path.join(_others_path, foo)
                    if os.path.isfile(abs_foo):
                        xTools.wrap_cp_file(abs_foo, foo)

    def update_ldf_file(self):
        real_ldf_file = xTools.get_abs_path(self.ldf_file, self.src_design)
        if xTools.not_exists(real_ldf_file, "Source LDF file"):
            return 1
        my_update = UpdateLDF(real_ldf_file, self.final_ldf_file, self.empty_lpf, self.copy_all)
        if my_update.process():
            return 1

    def generate_ldf_file(self):
        if not self.is_ng_flow:
            _lpf_file = self.get_lpf_file()
        else:
            _lpf_file = ""
        tcl_lines = list()
        if not self.devkit:
            xTools.say_it("-Error. No devkit specified to create a Diamond project file")
            return 1
        _t_line = '%s -name "%s" -impl "%s" ' % (self.tcl_cmd.get("new"), self.project_name, self.impl_name)
        if self.synthesis:
            syn_tool = self.synthesis
        else:
            syn_tool = "lse"
        if self.is_ng_flow:
            _t_line += '-dev %s -synthesis "%s"' % (self.devkit, syn_tool)
        else:
            _t_line += '-dev %s -synthesis "%s" -lpf "%s"' % (self.devkit, syn_tool, _lpf_file)
        tcl_lines.append(_t_line)
        if self.src_files:
            _src = self.src_files
        else:
            _src = self.edf_file
        _src_files = xTools.get_src_files(_src, self.src_design)

        for item_list in _src_files:
            if len(item_list) > 1:
                lib_name = "-work %s" % item_list[1]
            else:
                lib_name = ""
            real_file = item_list[-1]
            fext = xTools.get_fext_lower(real_file)
            if fext == ".sdc":
                if not self.use_sdc:
                    continue
            if self.pmi:  # use the synthesis model in the file
                new_real_file = os.path.splitext(real_file)[0] + "_syn.v"
                if os.path.isfile(new_real_file):
                    real_file = new_real_file
            tcl_lines.append('%s "%s" %s' % (self.tcl_cmd.get("add_src"), real_file, lib_name))
        if self.update_pmi_files(_src_files):
            return 1
        tcl_lines.append('%s %s' % (self.tcl_cmd.get("save"), self.final_ldf_file))
        tcl_lines.append(self.tcl_cmd.get("close"))
        if wrap_run_tcl("create_ldf", tcl_lines):
            return 1
        self.add_config_to_ldf()

    def update_pmi_files(self, _src_files):
        if not self.pmi:
            return
        _diamond = os.getenv("FOUNDRY")
        if not _diamond:
            xTools.say_it("Error. Not set the Environment value for FOUNDRY")
            return 1
        pmi_def_vhd = os.path.join(_diamond,  "vhdl", "data", "pmi", "pmi_def.vhd")
        _diamond = os.path.dirname(_diamond)

        # -------------
        conf = self.flow_options.get("conf")
        big_version, small_version = get_diamond_version()
        xml_file = os.path.join(conf, "DiamondDevFile_%s%s.xml" % (big_version, small_version))

        device_parser = xLatticeDev.DevkitParser(xml_file)
        if device_parser.process():
            return 1

        device_detail = device_parser.get_std_devkit(self.devkit)
        if not device_detail:
            return 1
        family_name = device_detail.get("family")
        if not family_name:
            xTools.say_it("Error. Not found family name from %s" % self.devkit)
            return 1
        family_name = re.sub("Lattice", "", family_name)
        family_name = re.sub("Mach", "", family_name) # Tony need standard family name
        # -------------


        for item_list in _src_files:
            real_file = item_list[-1]
            fext = xTools.get_fext_lower(real_file)
            if fext == ".v":
                update_include_line(real_file, _diamond, family_name)
            elif re.search("pmi_def\.vhd", real_file):
                if xTools.wrap_cp_file(pmi_def_vhd, real_file): # update pmi_def.vhd
                    return 1
            elif fext == ".vhd":
                update_vhd_file(real_file, family_name)

    def get_lpf_file(self):
        if self.seed_sweep:
            _lpf_file = self.seed_lpf
        else:
            _lpf_file = self.lpf_file
        if not _lpf_file:
            _lpf_file = self.project_name + ".lpf"
            create_empty_lpf(_lpf_file)
        else:
            _lpf_file = xTools.get_relative_path(_lpf_file, self.src_design)
            _t = os.path.basename(_lpf_file)
            if self.empty_lpf:
                create_empty_lpf(_t)
            else:
                if xTools.not_exists(_lpf_file, "LPF File"):
                    return 1
                xTools.wrap_cp_file(_lpf_file, _t)
            _lpf_file = _t
        return _lpf_file

    def add_config_to_ldf(self):
        if self.top_module or self.inc_path:
            ldf_lines = open(self.final_ldf_file).readlines()
            _t_ldf_ob = open(self.final_ldf_file, 'w')
            p_should_add = re.compile("<Implementation\s+")
            for line in ldf_lines:
                _t_ldf_ob.write(line)
                if p_should_add.search(line):
                    print >> _t_ldf_ob, "    <Options>"
                    if self.inc_path:
                        _inc_path = xTools.to_abs_list(self.inc_path, self.src_design)
                        print >> _t_ldf_ob, '        <Option name="include path" value="%s"/>' % ";".join(_inc_path)
                    if self.top_module:
                        print >> _t_ldf_ob, '        <Option name="top" value="%s"/>' % self.top_module
                    print >> _t_ldf_ob, "    </Options>"
            _t_ldf_ob.close()
    def add_strategy_and_synthesis(self):
        # update diamond version in ldf file
        current_version, small_version = get_diamond_version()
        if update_diamond_version(self.final_ldf_file, current_version):
            return 1
        if self.scuba_type:
            if self.sim_others:
                pass
            elif self.sim_rtl:
                return

        add_lines = list()
        add_lines.append('%s "%s"' % (self.tcl_cmd.get("open"), self.final_ldf_file))
        if not self.synthesis:
            _synthesis = xReport.file_simple_parser(self.final_ldf_file, [re.compile('Implementation.+\s+synthesis="([^"]+)"')])
            if not _synthesis:
                xTools.say_it("-Warning. No synthesize tool found in %s, use Synplify by default." % self.final_ldf_file)
                self.synthesis = "synplify"
                add_lines.append('%s "%s"' % (self.tcl_cmd.get("set_syn"), self.synthesis))
            else:
                self.synthesis = _synthesis[0]
        update_synthesis_tool(self.final_ldf_file, self.synthesis, self.devkit)
        if self.synthesis == "lse":
            pre_syn = "lse"
        elif self.synthesis == "synplify":
            pre_syn = "syn"
        elif self.synthesis == "precision":
            pre_syn = "pre"
        else:
            xTools.say_it("-Error. Unknown synthesize tool name: %s" % self.synthesis)
            return 1

        if self.strategy:
            gui_name = self.strategy.capitalize()
            sty_name = "my_%s" % self.strategy
            add_lines.append('%s -from "%s" -name "%s" -file "%s.sty"' % (self.tcl_cmd.get("copy_sty"), gui_name, sty_name, sty_name))
            add_lines.append('%s "%s"' % (self.tcl_cmd.get("set_sty"), sty_name))
        else:
            sty_name = xReport.file_simple_parser(self.final_ldf_file, [re.compile('default_strategy="([^"]+)"')])
            if not sty_name:
                xTools.say_it('-Error. Not found default_strategy name in %s' % self.final_ldf_file)
                return 1
            sty_name = sty_name[0]
            if sty_name in ("Timing", "Area", "Quick"):
                new_sty = "my_%s" % sty_name
                add_lines.append('%s -from "%s" -name "%s" -file "%s.sty"' % (self.tcl_cmd.get("copy_sty"), sty_name, new_sty, new_sty))
                add_lines.append('%s "%s"' % (self.tcl_cmd.get("set_sty"), new_sty))
                sty_name = new_sty
        pre_set = '%s -strategy %s' % (self.tcl_cmd.get("set_sty_val"), sty_name)
        if self.goal and self.synthesis == "lse":
            add_lines.append("%s lse_opt_goal=%s" % (pre_set, self.goal.capitalize()))
        elif self.goal and self.synthesis == "synplify":
            if self.goal == "area":
                _bool_str = "True"
            else:
                _bool_str = "False"
            add_lines.append("%s syn_area=%s" % (pre_set, _bool_str))
        if self.fanout:
            if self.synthesis == "lse":
                add_lines.append("%s %s_max_fanout_limit=%s" % (pre_set, pre_syn, self.fanout))
            elif self.synthesis == "synplify":
                add_lines.append("%s %s_fanout_limit=%s" % (pre_set, pre_syn, self.fanout))

        if self.frequency:
            add_lines.append("%s %s_frequency=%s" % (pre_set, pre_syn, self.frequency))

        if self.mixed_drivers:
            add_lines.append("%s %s_resolved_mixed_drivers=True" % (pre_set, pre_syn))

        if self.block_lpf:
            add_lines.append("%s %s_use_lpf_file=False" % (pre_set, pre_syn))

        if self.set_strategy:
            if type(self.set_strategy) is not list:
                self.set_strategy = re.split(",", self.set_strategy)
            for item in self.set_strategy:
                item = item.strip()
                if item.startswith("par_cmdline_args"):
                    item = "{%s}" % item
                add_lines.append('%s %s' % (pre_set, item))
        add_lines.append('%s "%s"' % (self.tcl_cmd.get("save"), self.final_ldf_file))
        if self.dry_run:
            pass
        if self.run_synthesis:
            add_lines.append("prj_run Synthesis")
        elif self.sim_rtl:
            if self.sim_others:
                add_lines.append("prj_run Synthesis")

        add_lines.append('%s "%s"' % (self.tcl_cmd.get("save"), self.final_ldf_file))
        add_lines.append(self.tcl_cmd.get("close"))

        # if wrap_run_tcl("set_strategy_and_run", add_lines):
        # updated for new log name
        if wrap_run_tcl("synthesis_flow", add_lines):
            return 1

def old_parse_ldf_file(ldf_file):
    from xml.etree import ElementTree
    if xTools.not_exists(ldf_file, "Ldf File"):
        return
    root = ElementTree.parse(ldf_file)
    ldf_dict = dict()

    def get_node(node_name):
        node = root.getiterator(node_name)
        if not node:
            xTools.say_it("-Error. Not found node %s in %s" % (node_name, ldf_file))
            return ""
        return node

    # BaliProject
    bali_node = get_node("BaliProject")
    if bali_node:
        ldf_dict["bali"] = bali_node[0].attrib

    # Implementation
    impl_node = get_node("Implementation")
    if impl_node:
        ldf_dict["impl"] = impl_node[0].attrib
    # Source
    src_node = get_node("Source")
    if src_node:
        src_list = list()
        for child in src_node:
            src_list.append(child.attrib)
        ldf_dict["source"] = src_list
    return ldf_dict

def parse_ldf_file(ldf_file, for_radiant):
    import readXML
    return readXML.parse_ldf_file(ldf_file=ldf_file, for_radiant=for_radiant)

def get_task_list(flow_options, user_options):
    task_list = list()
    till_map = flow_options.get("till_map")
    for (task_name, task_cmd) in [
        ["translate",       ["Translate", ""]],
        ["map",             ["Map", ""]],
        ["map_trace",       ["Map", "MapTrace"]],
        ["map_vlg",         ["Map", "MapVerilogSimFile"]],
        ["map_vhd",         ["Map", "MapVHDLSimFile"]],
        ["par",             ["PAR", ""]],
        ["par_trace",       ["PAR", "PARTrace"]],
        ["par_ta",          ["PAR", "IOTiming"]],
        ["par_power",       ["PAR", "PowerCal"]],
        ["export_ibis",     ["Export", "IBIS"]],
        ["export_ami",      ["Export", "IBIS_AMI"]],
        ["export_vlg",      ["Export", "TimingSimFileVlg"]],
        ["export_vhd",      ["Export", "TimingSimFileVHD"]],
        ["export_jedec",    ["Export", "Jedecgen"]],
        ["export_bitstream",["Export", "Bitgen"]],
        ["export_prom",     ["Export", "Promgen"]],

    ]:
        if till_map and task_name == "par":
            break
        option_name = "run_%s" % task_name
        if flow_options.get(option_name) or user_options.get(option_name):
            task_list.append(task_cmd)
    xo3l_name = "run_export_xo3l"
    if flow_options.get(xo3l_name) or user_options.get(xo3l_name):
        task_list.append(["Export", "Jedec4Xo3l"])
        task_list.append(["Export", "Bitgen4Xo3l"])
    return task_list


def no_space(a_string):
    return re.sub("\s+", "", a_string)

flow_support_dict = dict()
                  # Family                            # Jedec  # Bitstream
flow_support_dict["ECP5U"             ]  = no_space(" 0        1   ")
flow_support_dict["ECP5UM"            ]  = no_space(" 0        1   ")
flow_support_dict["ECP5UM5G"          ]  = no_space(" 0        1   ")
flow_support_dict["LIFDB1"            ]  = no_space(" 0        1   ")
flow_support_dict["LIFMD"             ]  = no_space(" 1        1   ") # new version support
flow_support_dict["LatticeEC"         ]  = no_space(" 0        1   ")
flow_support_dict["LatticeECP"        ]  = no_space(" 0        1   ")
flow_support_dict["LatticeECP2"       ]  = no_space(" 0        1   ")
flow_support_dict["LatticeECP2M"      ]  = no_space(" 0        1   ")
flow_support_dict["LatticeECP3"       ]  = no_space(" 0        1   ")
flow_support_dict["LatticeSC"         ]  = no_space(" 0        1   ")
flow_support_dict["LatticeSCM"        ]  = no_space(" 0        1   ")
flow_support_dict["LatticeXP"         ]  = no_space(" 1        0   ")
flow_support_dict["LatticeXP2"        ]  = no_space(" 1        0   ")
flow_support_dict["MachXO"            ]  = no_space(" 1        0   ")
flow_support_dict["MachXO2"           ]  = no_space(" 1        1   ")
flow_support_dict["MachXO3L"          ]  = no_space(" 1        1   ")
flow_support_dict["MachXO3LF"         ]  = no_space(" 1        1   ")
flow_support_dict["Platform Manager"  ]  = no_space(" 1        0   ")
flow_support_dict["Platform Manager 2"]  = no_space(" 0        1   ")
flow_support_dict["PRISM"             ]  = no_space(" 0        1   ")


class RunTclFlow:
    def __init__(self, flow_options, final_ldf_file, final_ldf_dict):
        self.flow_options = flow_options
        self.final_ldf_dict = final_ldf_dict
        self.final_ldf_file = final_ldf_file
        self.is_ng_flow = flow_options.get("is_ng_flow")
        if self.is_ng_flow:
            self.tcl_cmd = {key:value[1] for key, value in TCL_COMMAND.items()}
        else:
            self.tcl_cmd = {key:value[0] for key, value in TCL_COMMAND.items()}

    def update_flow_options_for_export_cmd(self):
        # /*
        #  */
        device = self.final_ldf_dict.get("bali", dict()).get("device")
        if not self.is_ng_flow:
            big_version, small_version = get_diamond_version()
            xml_file = os.path.join(self.flow_options.get("conf"), "DiamondDevFile_%s%s.xml" % (big_version, small_version))
            my_parser = xLatticeDev.DevkitParser(xml_file)
            if my_parser.process():
                return 1
            device_detail = my_parser.get_std_devkit(device)
            family = device_detail.get("family")
            if not family:
                return 1
        else:
            # TODO: support NG family
            family = "MayBeItIsRadiantFamily:%s" % device
        support_flow = flow_support_dict.get(family)
        if not support_flow:
            xTools.say_it("Warning.  Please contact with developer to support New Family %s" % family)
            support_flow = "11"

        if support_flow == "10": # outside in GUI: jedec, inner TCL command: bitstream
            if self.flow_options.get("run_export_jedec"):
                self.flow_options["run_export_jedec"] = 0
                self.flow_options["run_export_bitstream"] = 1
        else:
            if self.flow_options.get("run_export_jedec"):
                if support_flow[0] == "0":
                    xTools.say_it("Msg: no run run_export_jedec for family %s" % family)
                    self.flow_options["run_export_jedec"] = 0

            if self.flow_options.get("run_export_bitstream"):
                if support_flow[1] == "0":
                    xTools.say_it("Msg: no run run_export_bitstream for family %s" % family)
                    self.flow_options["run_export_bitstream"] = 0


    def process(self):
        self.src_design = self.flow_options.get("src_design")
        self.flatten_options()
        if self.update_flow_options_for_export_cmd():
            return 1
        if self.dsp:
            sts = self.run_dsp_test_flow()
        elif self.pushbutton:
            sts = self.run_pushbutton_flow()
        elif self.fmax_seed:
            sts = self.run_fmax_seed_flow()
        elif self.seed_sweep:
            sts = self.run_seed_flow()
        elif self.fmax_sweep:
            sts = self.run_fmax_flow()
        else:
            sts = self.run_pushbutton_flow()
        if self.flow_options.get("dms"):
            import xDMS
            dms_flow = xDMS.RunDMSFlow(self.project_name, self.impl_name, self.impl_dir,
                                       self.flow_options.get("conf"),
                                       self.flow_options.get("questasim_path"),
                                       self.flow_options.get("sim"))
            dms_flow.process()
        return sts


    def flatten_options(self):
        self.use_ori_clks = xTools.get_true(self.flow_options, "use_ori_clks")
        self.synthesis = self.flow_options.get("synthesis")
        self.pushbutton = xTools.get_true(self.flow_options, "pushbutton")
        self.synthesis_only = xTools.get_true(self.flow_options, "synthesis_only")
        if self.synthesis_only:
            self.run_synthesis = 1
        else:
            self.run_synthesis = xTools.get_true(self.flow_options, "run_synthesis")
        self.till_map = xTools.get_true(self.flow_options, "till_map")
        self.map_done = xTools.get_true(self.flow_options, "map_done")
        self.double_step = xTools.get_true(self.flow_options, "double_step")
        self.smoke = xTools.get_true(self.flow_options, "smoke")
        self.dsp = xTools.get_true(self.flow_options, "dsp")
        _seed_sweep = self.flow_options.get("seed_sweep")
        _fmax_sweep = self.flow_options.get("fmax_sweep")
        _fmax_range = self.flow_options.get("fmax_range")
        self.fmax_seed = xTools.get_true(self.flow_options, "fmax_seed")
        #
        if _seed_sweep:
            self.seed_sweep = xTools.get_xrange(_seed_sweep)
        else:
            self.seed_sweep = list()

        if _fmax_sweep:
            self.fmax_sweep = xTools.get_xrange(_fmax_sweep)
        elif _fmax_range:
            self.fmax_sweep = xTools.get_xrange(_fmax_range)
        else:
            self.fmax_sweep = list()
        #

        bali_node = self.final_ldf_dict.get("bali")
        impl_node = self.final_ldf_dict.get("impl")
        source_node = self.final_ldf_dict.get("source")
        self.project_name = bali_node.get("title")

        self.impl_name = bali_node.get("default_implementation")
        self.impl_dir = impl_node.get("dir")
        if not self.impl_dir:
            self.impl_dir = self.impl_name

        self.sty_name = impl_node.get("default_strategy")
        for item in source_node:
            if item.get("excluded") == "TRUE":
                continue
            if item.get("syn_sim") == "SimOnly":
                continue
            if item.get("type_short") == "LPF":
                self.lpf_file = item.get("name")
                break
            if item.get("type").lower() == "logic preference":
               self.lpf_file = item.get("name")
               break
        else:
            xTools.say_it("-Error. Not found lpf file in %s" % self.final_ldf_file)
            return 1

    def run_pushbutton_flow(self):
        """
        if both run_map_trce and pushbutton is True, the flow should run pushbutton (par trace) as default.
        """
        user_options = dict()
        if self.till_map:
            return self._run_till_map_flow()
        task_list = get_task_list(self.flow_options, user_options)
        if self.synthesis_only:
            return

        if not task_list:
            if self.run_synthesis:
                pass
            else:
                user_options = dict(run_par_trace=1)
                task_list = get_task_list(dict(), user_options)
        # User must specify which flow will be executed!
        sts = run_ldf_file("run_pb.tcl", self.final_ldf_file, task_list, is_ng_flow=self.is_ng_flow)
        self.run_ncl_flow()
        self.run_bitmap_flow()
        return sts

    def run_bitmap_flow(self):
        _export_task = ("run_export_bitstream", "run_export_jedec")
        for foo in _export_task:
            if self.flow_options.get(foo):
                bitgen = "%s/bitgen -simbitmap -w " % xTools.win2unix(os.getenv("MY_B_BIN"))
                par_udb_file ="./%s/%s_%s.udb" % (self.impl_name, self.project_name, self.impl_name)
                if os.path.isfile(par_udb_file):
                    _recov = xTools.ChangeDir(self.impl_name)
                    cmd_line = bitgen + os.path.basename(par_udb_file)
                    xTools.run_command(cmd_line, "sim_bit_map.log", "sim_bit_map.time")
                    _recov.comeback()
                break

    def run_ncl_flow(self):
        if not self.flow_options.get("run_ncl"):
            return
        ncd2ncl = "%s/ncd2ncl" % xTools.win2unix(os.getenv("MY_EXE"))
        sts = 0
        par_ncd_name ="./%s/%s_%s" % (self.impl_name, self.project_name, self.impl_name)
        map_ncd_name = "%s_map" % par_ncd_name
        cmd_list = list()
        if os.path.isfile(map_ncd_name+".ncd"):
            cmd_list.append("%s %s.ncd %s.ncl" % (ncd2ncl, map_ncd_name, map_ncd_name))
        if os.path.isfile(par_ncd_name+".ncd"):
            cmd_list.append("%s %s.ncd %s.ncl" % (ncd2ncl, par_ncd_name, par_ncd_name))
        if cmd_list:
            for item in cmd_list:
                sts = xTools.run_command(item, "ncd2ncl.log", "ncd2ncl.time")
        return sts

    def run_fmax_seed_flow(self):
        if not self.fmax_sweep:
            xTools.say_it("-Error. Not found fmax sweeping range for fmax_seed flow")
            return 1
        if not self.seed_sweep:
            xTools.say_it("-Error. Not found seed sweeping range for fmax_seed flow")
            return 1

        if self.till_map:
            sts = self._run_till_map_flow()
            return sts
        else:
            if self.re_write_lpf_file():
                return 1
        for i, fmax in enumerate(self.fmax_sweep):
            if self.skip(i): continue
            update_lpf_file(self.lpf_file, fmax)
            for ii, seed in enumerate(self.seed_sweep):
                if self.skip(ii): continue
                run_mark = "Target_fmax_%06.2f_seed_%02d" % (fmax, seed)
                xTools.say_it("-- Launching Test flow: %s" % run_mark)
                process_task = get_task_list(self.flow_options, dict(run_map=1, run_par_trace=1))
                pre_set = "%s -strategy %s" % (self.tcl_cmd.get("set_sty_val"), self.sty_name)
                flow_settings = ["%s par_place_iterator_start_pt=%d par_save_best_result=1" % (pre_set, seed)]
                sts = run_ldf_file(run_mark+".tcl", self.final_ldf_file, process_task, flow_settings, is_ng_flow=self.is_ng_flow)
                self.run_ncl_flow()
                move_bak_results(run_mark+".tcl", self.impl_dir, run_mark, sts)
                if self.smoke:
                    return
    def run_seed_flow(self):
        for ii, seed in enumerate(self.seed_sweep):
            if self.skip(ii): continue
            run_mark = "Target_seed_%02d" % seed
            xTools.say_it("--Launch Test flow: %s" % run_mark)
            process_task = get_task_list(self.flow_options, dict(run_par_trace=1))

            pre_set = "%s -strategy %s" % (self.tcl_cmd.get("set_sty_val"), self.sty_name)
            flow_settings = ["%s par_place_iterator_start_pt=%d par_save_best_result=1" % (pre_set, seed)]
            sts = run_ldf_file(run_mark+".tcl", self.final_ldf_file, process_task, flow_settings, is_ng_flow=self.is_ng_flow)
            self.run_ncl_flow()
            move_bak_results(run_mark+".tcl", self.impl_dir, run_mark, sts)
            if self.smoke:
                return

    def run_fmax_flow(self):
        if self.till_map:
            sts = self._run_till_map_flow()
            return sts
        elif self.map_done:
            pass
        else:
            if self.re_write_lpf_file():
                return 1

        map_done_recov = None
        if self.map_done:
            while True:
                if os.path.isfile("till_map_done"):
                    break
                else:
                    print "Warning. Previous till map flow not done yet!"
                    time.sleep(15)
            # copy and change dir to the new tag
            till_map_results = os.getcwd()
            new_dir = till_map_results + "_%03d_%03d" % (self.fmax_sweep[0], self.fmax_sweep[-1])
            shutil.copytree(till_map_results, new_dir)
            map_done_recov = xTools.ChangeDir(new_dir)

        for i, fmax in enumerate(self.fmax_sweep):
            if self.skip(i): continue
            update_lpf_file(self.lpf_file, fmax)
            run_mark="Target_fmax_%06.2fMHz" % fmax
            xTools.say_it("--Launch Test flow: %s" % run_mark)
            process_task = get_task_list(self.flow_options, dict(run_map=1, run_par_trace=1))
            sts = run_ldf_file(run_mark+".tcl", self.final_ldf_file, process_task, is_ng_flow=self.is_ng_flow)
            self.run_ncl_flow()
            move_bak_results(run_mark+".tcl", self.impl_dir, run_mark, sts)
            if self.smoke:
                return
        if map_done_recov:
            map_done_recov.comeback()

    def _run_till_map_flow(self):
        process_task = [["Map", "MapTrace"]]
        sts = run_ldf_file("run_till_map.tcl", self.final_ldf_file, process_task, is_ng_flow=self.is_ng_flow)
        self.run_ncl_flow()
        mrp_file = os.path.join(".", self.impl_dir, "%s_%s.mrp" % (self.project_name, self.impl_name))
        if xTools.not_exists(mrp_file, "map report file"):
            return 1
        clks = get_clocks_from_mrp_file(mrp_file)
        update_lpf_file(self.lpf_file, 88, clks)
        a = open("till_map_done", "w")
        a.close()
        return sts

    def re_write_lpf_file(self):
        if self.use_ori_clks:
            pass
        else:
            sts = self._run_till_map_flow()
            if sts:
                return 1

    def skip(self, number):
        if self.double_step:
            if number%2: return 1

    def run_dsp_test_flow(self):
        self.create_cmd_kwargs()
        self.new_command_settings = self.update_edif2ngd_cmd()
        if self.new_command_settings == 1:
            return 1

        self.cmd_list1, self.cmd_list2 = self.create_cmd_list()
        if self.pushbutton:
            sts = self.run_dsp_pushbutton_flow(self.cmd_list1+self.cmd_list2)
        elif self.seed_sweep:
            sts = self.run_dsp_seed_sweeping_flow()
        elif self.fmax_sweep:
            sts = self.run_dsp_fmax_sweeping_flow()
        else:
            sts = self.run_dsp_pushbutton_flow(self.cmd_list1+self.cmd_list2)
        return sts

    def run_dsp_fmax_sweeping_flow(self):
        xTools.say_it("Warning. Not support fmax sweeping flow for DSP cases")
        return

    def run_dsp_seed_sweeping_flow(self):
        i, failed_case = 0, 0
        sts = self.run_dsp_pushbutton_flow(self.cmd_list1+[self.cmd_list2[0]])
        if sts:
            return 1

        for ii, seed in enumerate(self.seed_sweep):
            if self.skip(ii): continue
            i += 1
            run_mark = "Target_seed_%02d" % seed
            xTools.say_it("-- Launching Test flow: %s" % run_mark)
            sts = self.run_dsp_pushbutton_flow(self.cmd_list2[1:], seed)
            if sts:
                failed_case += 1
            copy_impl_dir_to_target(self.impl_dir, run_mark, copy_ncd=True)
        if failed_case == i:
            xTools.say_it("All seed sweeping flow failed!")
            return 1


    def create_cmd_list(self):
        if self.synthesis == "lse":
            cmd_list1 = []
        else:
            cmd_list1 = ["edif2ngd", "ngdbuild"]
        if self.till_map:
            cmd_list2 = ["map"]
        else:
            cmd_list2 = ["map", "par", "trce"]
        return cmd_list1, cmd_list2

    def run_dsp_pushbutton_flow(self, my_cmd_list, seed_number=0):
        self.batch_cmd = xCommandFlow.LatticeBatchFlow(self.new_command_settings)
        for cmd in my_cmd_list:
            if cmd == "trce":
                par_ncd = self.cmd_kwargs.get("par_ncd")
                if os.path.isfile(par_ncd):
                    pass
                else:
                    par_ncd_list = glob.glob(os.path.join("./%s/*.dir/*.ncd" % self.impl_dir))
                    if xTools.check_file_number(par_ncd_list, "par_ncd file"):
                        return 1
                    self.cmd_kwargs["par_ncd"] = xTools.win2unix(par_ncd_list[0], use_abs=0)
            sts = self.batch_cmd.run_flow(cmd, self.cmd_kwargs, seed_number)
            if sts:
                return sts

    def update_edif2ngd_cmd(self):
        p_ip_path = re.compile("@\(ip_path\)s")
        command_settings = self.flow_options.get("command")
        new_command_settings = dict()

        for key, value in command_settings.items():
            if key != "edif2ngd":
                new_command_settings[key] = value
                continue
            if p_ip_path.search(value):
                ip_path = self.flow_options.get("ip_path")
                if not ip_path:
                    xTools.say_it("Error. Not found ip_path in info file")
                    return 1
                ip_path = xTools.get_relative_path(ip_path, self.src_design)
                new_value = p_ip_path.sub('-ip "%s"' % ip_path, value)
                new_command_settings[key] = new_value
            else:
                new_command_settings[key] = value
        return new_command_settings

    def create_cmd_kwargs(self):
        bali_node = self.final_ldf_dict.get("bali")
        impl_node = self.final_ldf_dict.get("impl")
        source_node = self.final_ldf_dict.get("source")

        device = bali_node.get("device")
        prj_name = bali_node.get("title")
        impl_dir = impl_node.get("dir")
        impl_name = impl_node.get("title")

        lpf_file = ""
        for item in source_node:
            type_short = item.get("type_short")
            excluded_tag = item.get("excluded")
            if excluded_tag == "TRUE":
                continue
            if item.get("syn_sim") == "SimOnly":
                continue
            if type_short == "LPF":
                lpf_file = item.get("name")
        if not lpf_file:
            xTools.say_it("Error. Not found lpf file")
            return 1

        file_name = "./%s/%s_%s" % (impl_dir, prj_name, impl_name)
        self.cmd_kwargs = dict(project_name=file_name,
            edf_file=file_name+".edi",
            ngo_file=file_name+".ngo",
            ngd_file=file_name+".ngd",
            map_ncd=file_name+"_map.ncd",
            prf_file=file_name + ".prf",
            mrp_file=file_name+".mrp",
            lpf_file=lpf_file,
            tw1_file=file_name+".tw1",
            par_ncd=file_name+".ncd",
            twr_file=file_name+".twr"
        )
        conf = self.flow_options.get("conf")
        big_version, small_version = get_diamond_version()
        xml_file = os.path.join(conf, "DiamondDevFile_%s%s.xml" % (big_version, small_version))

        device_parser = xLatticeDev.DevkitParser(xml_file)
        if device_parser.process():
            return 1

        device_detail = device_parser.get_std_devkit(device)
        # xTools.say_it(device_detail)
        for item in ("family", "pty", "pkg", "spd", "opt"):
            self.cmd_kwargs[item] = device_detail.get(item)

## -- For update models

def get_top_name(src_file):
    top_name = xReport.file_simple_parser(src_file, [re.compile("^entity\s+(\S+)"), re.compile("^module\s+(\S+)\s*\(*")], 120)
    if not top_name:
        return
    else:
        return top_name[0]

def run_scuba_by_file(src_file, run_scuba):
    """
    if NO update, return None
    else:
        if update failed, return 1,1
        else return src_file and new_file

        First check the lpc file
        then the srp file
        the original file at last.
    """

    p_lang = re.compile("\s+-lang\s+(\S+)\s+")
    top_name = get_top_name(src_file)
    if not top_name:
        return
    bn = os.path.splitext(src_file)[0]
    srp_file = bn + ".srp"
    if os.path.isfile(srp_file):
        scuba_src_site = srp_file
    else:
        scuba_src_site = src_file
    ori_scuba_cmd_line = xReport.file_simple_parser(scuba_src_site, [re.compile("\S+scuba\.exe(.+)"), re.compile("\S+\Wscuba(.+)")], 80)
    if not ori_scuba_cmd_line: # maybe it is not a model file
        return

    # --------------
    scuba_arguments = ori_scuba_cmd_line[0]
    scuba_arguments = re.sub("\W+$", "", scuba_arguments)  # remove */
    if not re.search("\s+-n\s+", scuba_arguments):
        scuba_arguments += " -n %s" % top_name
    _ = os.path.join(os.getenv("MY_B_BIN", "NO_DiamondBinPath"), "scuba")
    scuba_cmd = "%s %s" % (_, scuba_arguments)

    _recov = xTools.ChangeDir(os.path.dirname(src_file))

    # /*
    #  */
    if run_scuba == "normal":
        new_src_file = ""
    else:
        new_src_file = ""
        print scuba_cmd
        m_lang = p_lang.search(scuba_cmd)
        if not m_lang:
            xTools.say_it("Fatal Error. Not found -lang in %s" % scuba_cmd)
            return [1, 1]
        ori_lang = m_lang.group(1)
        if ori_lang == "vhdl":
            if run_scuba in ("verilog", "reverse"):
                scuba_cmd = p_lang.sub(" -lang verilog ", scuba_cmd)
                new_src_file = os.path.splitext(src_file)[0] + ".v"
            else:
                new_src_file = os.path.splitext(src_file)[0] + ".vhd"
        elif ori_lang == "verilog":
            if run_scuba in ("vhdl", "reverse"):
                scuba_cmd = p_lang.sub(" -lang vhdl ", scuba_cmd)
                new_src_file = os.path.splitext(src_file)[0] + ".vhd"
            else:
                new_src_file = os.path.splitext(src_file)[0] + ".v"
    sts = xTools.run_command(scuba_cmd, "run_scuba.log", "run_scuba.time")
    _recov.comeback()
    if sts:
        return [1, 1]
    else:
        return [src_file, new_src_file]

def run_scuba_flow(source_list, run_scuba):
    new_source_list = list()
    for item in source_list:
        if item.get("excluded") == "TRUE":
            continue
        if item.get("syn_sim") == "SimOnly":
            continue
        if item.get("type_short") in ("VHDL", "Verilog"):
            src_file = item.get("name")
            tt = run_scuba_by_file(src_file, run_scuba)
            if not tt:
                pass
            else:
                if tt[0] == 1:
                    return 1, ""
                new_source_list.append(tt)
    return 0, new_source_list

if __name__ == "__main__":
    pass











