import os
import re
import sys
import shutil
import glob
import configparser

from . import xConvert
from . import xTools
from . import xLattice
from . import xSimulation
from . import xRadiantIPgen
from .xOptions import XOptions
from .xReport import ScanReport
from . import xCommandFlow
from . import xiCEcube2
from . import xDMSsta
from . import qas
from . import utils

__author__ = 'syan'


class FlowLattice(XOptions):
    def __init__(self, private_options):
        XOptions.__init__(self, private_options)
        self.sbx_file = ""

    def process(self):
        head_lines = xTools.head_announce()

        if self.run_option_parser():
            return 1

        xTools.say_it(dict(os.environ), "Original Environments:", self.debug)

        if self.sanity_check():
            return 1

        play_lines, play_time = xTools.play_announce(self.src_design, self.dst_design)
        self.out_log = log_file = os.path.join(self.dst_design, "runtime_console.log")
        xTools.add_cmd_line_history(log_file)
        xTools.append_file(log_file, head_lines + play_lines)
        os.environ["BQS_L_O_G"] = log_file
        _recov = xTools.ChangeDir(self.dst_design)
        sts = 0
        if self.scan_only:
            self.scan_report()
            self.check_only = True
        if self.check_only:
            sts2 = self.run_check_flow()
            _recov.comeback()
            return sts2

        if not sts:
            self.record_debug_message()
            if self.run_ice:
                pass
            else:
                sts = self.create_env_setter()
        try:
            xTools.remove_license_setting(phase="LATTICE_LICENSE_WINREG_OR_FLEXLMRC")
        except:
            pass  # DO not care
        utils.add_license_control()
        if not sts:
            sts = self.merge_local_options()

        if not sts:
            sts = self.copy_update_conf_file()
        xTools.say_it(dict(os.environ), "Original Environments:", self.debug)

        self.pre_process = self.scripts_options.get("pre_process")
        self.post_process = self.scripts_options.get("post_process")

        self.delete_sedisable_if_needed()

        if self.is_ng_flow:
            os.environ["YOSE_RADIANT"] = "1"
        # dump check and scan_report Python file
        self.run_check_flow(dump_only=1)

        cmd_file = None
        cmd_ret = None
        # run normal flow
        if self.pre_process:
            xLattice.run_pre_post_process(self.src_design, self.pre_process)
        if self.scan_rpt or self.scan_pap_rpt:
            self.scan_report(dump_only=1)
        try:
            if not sts:
                if self.dms_standalone:
                    sts = self.run_dms_standalone_flow()
                elif self.run_ice:
                    sts = self.run_ice_flow()
                else:
                    self.synthesis_only = xTools.get_true(self.scripts_options, "synthesis_only")
                    if self.env_setter.will_run_simulation():
                        sts = self.run_simulation_flow()
                    else:
                        cmd_file = self.scripts_options.get("cmd_file")
                        if cmd_file:
                            sts = self.run_cmd_file_only(cmd_file)
                            cmd_ret = sts
                        else:
                            if self.is_ng_flow:
                                _ldf_file = self.scripts_options.get("rdf_file")
                            else:
                                _ldf_file = self.scripts_options.get("ldf_file")
                            if _ldf_file:
                                sts = self.run_tcl_flow()
                            elif "cmd_flow" in self.scripts_options:
                                sts = self.run_cmd_flow()
                            else:
                                sts = self.run_tcl_flow()
            xTools.stop_announce(play_time)
        except Exception as e:
            xTools.say_tb_msg()
            xTools.say_it("Error. %s" % e)

        if self.post_process:
            xLattice.run_pre_post_process(self.src_design, self.post_process)
        self.copy_to_another_location_if_needed()
        if self.run_ice:
            final_sts = sts
        else:
            if not cmd_file:
                final_sts = self.run_check_flow()
            else:
                _conf = self.scripts_options.get("check_conf")
                if _conf:
                    final_sts = self.run_check_flow()
                else:
                    self.print_check_standard_output(cmd_ret)
                    final_sts = 201 if cmd_ret else 200
        if self.scan_rpt or self.scan_pap_rpt:
            self.scan_report()
        self.run_final_closing_flow()
        _recov.comeback()
        return final_sts

    def run_final_closing_flow(self):
        # current working directory: $design/_scratch
        # 1. stop Simrel inner flow
        timeout_file = "../_timeout.py"
        p_nnn = re.compile(r'"(nc stop \S+)"')
        line_m = xTools.simple_parser(timeout_file, [p_nnn])
        if line_m:
            m = line_m[1]
            nc_stop_line = m.group(1)
            print(("Try to kill Simrel process: {}".format(nc_stop_line)))
            os.system(nc_stop_line)
        # end of 1.

    @staticmethod
    def print_check_standard_output(cmd_ret):
        if cmd_ret:
            print("- Final check status: 201")
            print("- Failed")
            print("<status>Failed</status>")
        else:
            print("- Final check status: 200")
            print("- Passed")
            print("<status>Passed</status>")

    @staticmethod
    def run_cmd_file_only(cmd_file):
        _x_recov = xTools.ChangeDir("..")  # get out of _scratch
        ################
        execute_dict = dict()
        execute_dict[".sh"] = ("bash", None)
        execute_dict[".csh"] = ("csh", None)
        execute_dict[".bat"] = ("bash", "")
        execute_dict[".cmd"] = ("bash", "")
        execute_dict[".py"] = (sys.executable, sys.executable)
        execute_dict[".pl"] = ("perl", "perl")
        ################
        t = cmd_file.lower()
        t = t.split()
        for k, v in list(execute_dict.items()):
            if t[0].endswith(k):
                my_v = v[1] if sys.platform.startswith("win32") else v[0]
                if my_v is None:
                    print(("Error. Cannot execute {} on {} platform".format(cmd_file, sys.platform)))
                    this_cmd_line = ""
                    break
                this_cmd_line = "{} {}".format(my_v, cmd_file)
                break
            elif len(t) > 1:
                if t[1].endswith(k):
                    this_cmd_line = cmd_file
                    break
        else:
            this_cmd_line = cmd_file
        if this_cmd_line:
            #
            real_script_file = ""
            max_index = 2
            for i, foo in enumerate(this_cmd_line.split()):
                if i >= max_index:
                    break
                if os.path.isfile(foo):
                    real_script_file = foo
            if real_script_file:
                os.chdir(os.path.dirname(os.path.abspath(real_script_file)))  # NOT NEED COME BACK
            #
            sts = xTools.run_command(this_cmd_line, "run_batch.log", "run_batch.time")
        else:
            sts = 1
        _x_recov.comeback()
        return sts

    def delete_sedisable_if_needed(self):
        now_environment = self.scripts_options.get("environment")
        _v = xTools.get_true(now_environment, "delete_sedisable")
        if _v:
            try:
                os.environ.pop("SEDISABLE")
            except:
                pass

    def scan_report(self, dump_only=0):
        tag_dir = os.getcwd()
        design_dir, tag = os.path.split(tag_dir)
        job_dir, design = os.path.split(design_dir)
        if self.is_ng_flow:
            software = 'radiant'
        else:
            software = 'diamond'
        scan_py = os.path.join(os.path.dirname(__file__), '..', '..', 'tools', 'scanReport', "scan_report.py")
        args = "--top-dir=%s --design=%s --tag=%s --software %s --rpt-dir %s" % (job_dir, design, tag, software, self.top_dir)
        if self.scripts_options.get("seed_sweep"):
            args += " --seed seed"
        if self.scripts_options.get("fmax_sort") == "geomean":
            args += " --fmax-sort geomean"
        if xTools.not_exists(scan_py, "Scan scripts"):
            return 1
        scan_py = os.path.abspath(scan_py)
        cmd_line = "%s %s %s" % (sys.executable, scan_py, args)
        if self.scan_pap_rpt:
            cmd_line += " --pap "
        #
        if self.is_ng_flow:
            scan_py = os.path.join(os.path.dirname(__file__), '..', '..', 'tools', 'scanReport', "new_scan.py")
            scan_py = os.path.abspath(scan_py)
            args = "--top-dir {} --design {} --tag {} --vendor Radiant".format(job_dir, design, tag)
            raw_ic = self.scripts_options.get("ignore_clock")
            raw_cc = self.scripts_options.get("care_clock")
            if raw_ic:
                args += " --ignore-clock {}".format(" ".join(raw_ic))
            if raw_cc:
                args += " --care-clock {}".format(" ".join(raw_cc))
            cmd_line = "{} {} {}".format(sys.executable, scan_py, args)
        #
        cmd_line = xTools.win2unix(cmd_line, 0)
        if dump_only:
            timeout_py = xTools.win2unix(os.path.join("..", "_timeout.py"))
            xTools.append_file(timeout_py, ["import os", "os.system('%s')" % cmd_line, ""])
            return
        xTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        xTools.say_raw(text)

    def run_check_flow(self, dump_only=0):
        if not dump_only:
            _do_not_check = self.scripts_options.get("no_check")
            if _do_not_check:
                sts, text = 200, ("Not executed check flow, always return Passed", "Final check status: 200", "Passed")
                xTools.say_it(text)
                return sts
        report_path = self.scripts_options.get("cwd")
        if not self.check_rpt:
            report = "check_flow.csv"
        else:
            _check_rpt = xTools.get_abs_path(self.check_rpt, report_path)
            report_path, report = os.path.split(_check_rpt)

        check_py = os.path.join(os.path.dirname(__file__),'..','..','tools','check', "check.py")
        check_py = os.path.abspath(check_py)
        if xTools.not_exists(check_py, "source script file"):
            return 1

        cmd_kwargs = dict()
        if not dump_only:
            xx = self.original_options.get("check_sections")
            yy = self.original_options.get("check_smart")
            if os.getenv("INNER_APB_FLOW"):
                yy = True
                self.original_options["run_export_bitstream"] = False
            new_args = list()
            if not (xx or yy):
                new_args.append("check_normal")
            else:
                if xx:
                    new_args.extend(["now_chk_{}".format(foo) for foo in xx])
                else:
                    new_args.extend(["now_chk_{}".format(foo) for foo in self.valid_check_items])
                if yy:
                    new_args.append("now_chk_smart")
                has_synthesis_name = False
                for k, v in list(self.original_options.items()):
                    if v:
                        if k == "synthesis":
                            new_args.append(v)
                            has_synthesis_name = True
                        else:
                            new_args.append(k)
                if not has_synthesis_name:
                    project_files = glob.glob(os.path.join(self.job_dir, self.design, self.tag, "*.*df"))
                    if not project_files:
                        pass
                    try:
                        got_name = xTools.simple_parser(project_files[0], [re.compile('synthesis="([^"]+)"')])
                        new_args.append(got_name[1].group(1))
                    except:
                        new_args.append("lse")

            cmd_kwargs["preset_options"] = "--preset-options={}".format("+".join(new_args))
        cmd_kwargs["top_dir"] = "--top-dir=%s" % self.job_dir
        cmd_kwargs["design"] = "--design=%s" % self.design

        _check_conf = self.scripts_options.get("check_conf")
        if _check_conf:
            cmd_kwargs["conf_file"] = "--conf-file=%s" % _check_conf
        else:
            cmd_kwargs["conf_file"] = ""
        cmd_kwargs["report_path"] = "--report-path=%s" % report_path
        cmd_kwargs["tag"] = "--tag=%s" % self.tag
        cmd_kwargs["report"] = "--report=%s" % report
        cmd_kwargs["rerun_path"] = "--rerun-path=%s" % report_path
        # NEW check flow
        if self.scripts_options.get("synthesis_only"):
            _ = self.scripts_options.get("synthesis")
            if _ == "lse":
                cmd_kwargs["lse_check"] = "--lse-check"
            else:
                cmd_kwargs["synp_check"] = "--synp-check"
        else:
            for _ in ("run_par_trace", "run_par", "pushbutton"):
                if self.scripts_options.get(_):
                    if self.scripts_options.get("till_map"): # till map has higher priority
                        pass
                    else:
                        cmd_kwargs["partrce_check"] = "--partrce-check"
            else:
                for _ in ("run_map", "till_map", "run_map_trace"):
                    if self.scripts_options.get(_):
                        cmd_kwargs["map_check"] = "--map-check"
        if self.is_ng_flow:
            cmd_kwargs["vendor"] = "--vendor radiant"
        else:
            cmd_kwargs["vendor"] = "--vendor diamond"
        #

        cmd_line = r"%s %s " % (sys.executable, check_py)
        for key, value in list(cmd_kwargs.items()):
            cmd_line += " %s " % value

        cmd_line = xTools.win2unix(cmd_line, 0)
        if dump_only:
            timeout_py = xTools.win2unix(os.path.join("..", "_timeout.py"))
            xTools.write_file(timeout_py, ["import os", "os.system('%s')" % cmd_line, ""])
            return
        xTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        xTools.say_it(text)
        return sts

    def run_ice_flow(self):
        my_flow = xiCEcube2.Run_iCEcube(self.scripts_options)
        sts = my_flow.iCE_process()
        return sts

    def run_dms_standalone_flow(self):
        my_flow = xDMSsta.DMSStandalone(self.scripts_options)
        sts = my_flow.process()
        return sts

    def record_debug_message(self):
        def __get_value(value):
            if not value:
                value = ""
            if type(value) is list:
                value = list(map(str, value))
                joint_string = ">%s     <" % os.linesep
                value = "<%s>" % joint_string.join(value)
            elif isinstance(value, bool):
                value = "1"
            if not isinstance(value, str):  # on Unix, configparser option value MUST be string
                value = str(value)
            return value
        config=configparser.ConfigParser()
        section_qa = "qa"
        config.add_section(section_qa)
        for section, foo in list(self.scripts_options.items()):
            if type(foo) is dict:
                config.add_section(section)
                for key, bar in list(foo.items()):
                    config.set(section, key, __get_value(bar))
            else:
                config.set(section_qa, section, __get_value(foo))
        config.write(open("local_debug.ini","w"))

    def run_scan_only_flow(self):
        if not self.job_dir:
            self.job_dir = os.getcwd()
        if xTools.not_exists(self.job_dir, "Job Working Path"):
            return 1
        my_scan = ScanReport(self.job_dir, self.design, self.tag)
        return my_scan.process()

    def sanity_check(self):
        # get src_design and dst_design
        if self.top_dir:
            if not self.design:
                xTools.say_it("-Error. No design name specified")
                return 1
            self.top_dir = os.path.abspath(self.top_dir)
        else:
            if self.design:
                if os.path.isabs(self.design):
                    xTools.say_it("-Warning. <--design=[single design_name or relative design path for top_dir]> is nicer")
                self.top_dir = os.getcwd()
            else:
                self.top_dir, self.design = os.path.split(os.getcwd())
        self.src_design = xTools.get_abs_path(self.design, self.top_dir)
        if xTools.not_exists(self.top_dir, "Top Source path"):
            return 1
        if xTools.not_exists(self.src_design, "Source Design"):
            return 1
        if self.job_dir:
            self.job_dir = os.path.abspath(self.job_dir)
        else:
            self.job_dir = self.top_dir
        self.dst_design = os.path.join(self.job_dir, self.design, self.tag)
        if xTools.wrap_md(self.dst_design, "Job Working Design Path"):
            return 1
        self.scripts_options["src_design"] = self.src_design
        self.scripts_options["dst_design"] = self.dst_design

    def get_ice_project_options(self, project_file):
        _prj_options = dict()
        p = re.compile("\[(.+)\]")
        section_name = ""
        for line in open(project_file):
            line = line.strip()
            if not line:
                continue
            m = p.search(line)
            if m:
                section_name = m.group(1)
                continue
            if section_name:
                key_value = _prj_options.get(section_name, dict())

                _kv_list = re.split("=", line)
                if len(_kv_list) == 1:
                    key_value[_kv_list[0]] = ""
                else:
                    key_value[_kv_list[0]] = "=".join(_kv_list[1:])
                _prj_options[section_name] = key_value
        return _prj_options

    def merge_local_options(self):
        if self.scuba_type:
            big_version, small_version = xLattice.get_diamond_version()
            xml_file = os.path.join(self.conf, "DiamondDevFile_%s%s.xml" % (big_version, small_version))
            my_convert = xConvert.ConvertScubaCase(self.src_design, self.devkit, xml_file, self.scuba_type, self.scripts_options)
            sts = my_convert.process()
            if sts:
                return 1
            if self.scuba_only:
                return 1
        if self.info_file_name:
            t = os.path.join(self.src_design, self.info_file_name)
            if xTools.not_exists(t, "user specified info file"):
                return 1
            info_file = [t]
            len_info_file = 1
        else:
            info_file = glob.glob(os.path.join(self.src_design, "*.info"))
            len_info_file = len(info_file)
            if len_info_file > 1:
                xTools.say_it("-Error. Found %d info file under %s" % (len_info_file, self.src_design))
                return 1

        if self.run_ice:
            if not len_info_file:  # read the project file directly
                ice_prj_files = glob.glob(os.path.join(self.src_design, "par", "*.project"))
                if not ice_prj_files:
                    ice_prj_files = glob.glob(os.path.join(self.src_design, "synthesis", "*", "*.project"))
                if not ice_prj_files:
                    ice_prj_files = glob.glob(os.path.join(self.src_design, "project", "*", "*", "*.project"))
                if xTools.check_file_number(ice_prj_files, "iCEcube2 project file"):
                    return 1
                local_options = self.get_ice_project_options(ice_prj_files[0])
                self._merge_options(local_options)
                self.scripts_options["same_ldf_dir"] = os.path.dirname(ice_prj_files[0])
                self.scripts_options["use_ice_prj"] = 1

            else:
                sts, info_dict = xTools.get_conf_options(info_file)
                if sts:
                    return 1
                qa_info_dict = info_dict.get("qa")
                if qa_info_dict:
                    project_file = qa_info_dict.get("project_file")
                else:
                    project_file = ""

                if project_file:
                    local_options = self.get_ice_project_options(project_file)
                    self.scripts_options["same_ldf_dir"] = os.path.dirname(project_file)
                    self.scripts_options["use_ice_prj"] = 1
                    self._merge_options(local_options)
                else:
                    self.scripts_options["same_ldf_dir"] = os.path.dirname(info_file[0])
                    self._merge_options(info_dict)

        else:
            if not len_info_file:  # No info file found
                whole_fext_list = ("bat", "cmd", "py", "pl", "sh", "csh")
                valid_fext_list = whole_fext_list[:-2] if sys.platform.startswith("win32") else whole_fext_list
                valid_file_list = ["run.{}".format(item) for item in valid_fext_list]
                got_run_xxx_file = False
                for a, b, c in os.walk(self.src_design):
                    for a_file in c:
                        if a_file in valid_file_list:
                            self.scripts_options["cmd_file"] = os.path.normpath(os.path.join(a, a_file))
                            got_run_xxx_file = True
                            break
                    if got_run_xxx_file:
                        break
                else:
                    if self.is_ng_flow:
                        prj_fext = "*.rdf"
                    else:
                        prj_fext = "*.ldf"
                    for p in [os.path.join(self.src_design, "par"), self.src_design]:
                        ldf_file = glob.glob(os.path.join(p, prj_fext))
                        if ldf_file:
                            break
                    if xTools.check_file_number(ldf_file, "Diamond Project File"):
                        return 1
                    if self.is_ng_flow:
                        self.scripts_options["rdf_file"] = ldf_file[0]
                    else:
                        self.scripts_options["ldf_file"] = ldf_file[0]

                others_path = os.path.join(self.src_design, "others")
                if os.path.isdir(others_path):
                    self.scripts_options["others_path"] = "./others"
            else:
                sts, local_options = xTools.get_conf_options(info_file)
                if sts:
                    return 1
                real_info_file = info_file[0]
                if xTools.get_fname(real_info_file) == "_qas":
                    new_local_options = qas.get_local_bqs_options(self.conf, local_options,
                                                                  self.src_design, self.is_ng_flow)
                    if not new_local_options:
                        xTools.say_it("-Error. can not get the local info options from _qas.info file")
                        return 1
                    self._merge_options(new_local_options)
                    # self.generate_check_conf_file(real_info_file)
                else:
                    self._merge_options(local_options)
        try:
            self.scripts_options["info"] = real_info_file
        except:
            pass
        xTools.say_it(self.scripts_options, "Final Options", self.debug)
        if self.is_ng_flow:
            gen_ip_sts = None
            if self.is_ng_flow and self.run_ipgen:
                _info = self.scripts_options.get("info")
                rdf_file = self.scripts_options.get("rdf_file", "NotFound_rdf")
                info_dir = os.path.dirname(_info) if os.path.isfile(_info) else os.getcwd()
                abs_rdf_file = xTools.get_abs_path(rdf_file, info_dir)
                gen_ip_sts = self.run_ipgen_for_radiant(abs_rdf_file)
            if gen_ip_sts:
                return 1


    def generate_check_conf_file(self, real_info_file):
        """
        Zhilong need rtl/map_vlg check conf file
        """
        base_dir = os.path.dirname(real_info_file)
        conf_file = glob.glob(os.path.join(base_dir, "*.conf"))
        if len(conf_file) >= 1:
            pass
        else:
            if not self.env_setter.will_run_simulation():
                return
            new_conf = os.path.join(base_dir, "check_rtl_mapvlg.conf")
            conf_kwargs = dict()
            conf_kwargs["_design_name"] = os.path.basename(self.src_design)
            conf_kwargs["src_top_module"] = self.scripts_options.get("sim", dict()).get("src_top_module")
            new_lines = qas.qas_check_conf_template % conf_kwargs
            xTools.write_file(new_conf, new_lines)

    def copy_update_conf_file(self):
        if self.top_dir == self.job_dir:
            return
        if self.check_conf:
            d = self.check_conf
        else:
            d = "*.conf"
        # will copy conf file to src_design to dirname(_dst_design)
        conf_files = glob.glob(os.path.join(self.src_design, d))
        if not conf_files: # not found conf file
            return
        if len(conf_files) > 1:
            xTools.say_it("Warning. Found more than 1 conf file under %s" % self.src_design)
            return 1
        # now find a conf file
        # update it!
        src_conf = conf_files[0]
        dst_conf = os.path.join(os.path.dirname(self.dst_design), os.path.basename(src_conf))
        p_golden = re.compile("^golden_file\s*=\s*(.+)$", re.I)
        ob_dst = open(dst_conf, "w")
        for line in open(src_conf):
            m_golden = p_golden.search(line)
            if m_golden:
                golden_file = m_golden.group(1)
                real_golden_file = xTools.get_abs_path(golden_file, self.src_design)
                if not os.path.isfile(real_golden_file):
                    real_golden_file = golden_file
                print("golden_file = %s" % real_golden_file, file=ob_dst)
            else:
                ob_dst.write(line)
        ob_dst.close()

    def create_env_setter(self):
        self.env_setter = xLattice.LatticeEnvironment(self.scripts_options)
        sts = self.env_setter.process()
        if sts:
            return sts

    def run_cmd_flow(self):
        my_cmd_flow = xCommandFlow.CommandFlow(self.scripts_options)
        sts = my_cmd_flow.process()
        return sts

    def run_simulation_flow(self):
        xTools.say_it("-- Will launch simulation flow ...")
        if self.create_final_ldf_file():
            pass  # do Not care the implementation flow status, will run simulation flow straightly
        if self.dry_run:
            return
        if self.synthesis_only:
            return
        my_tcl_flow = xLattice.RunTclFlow(self.scripts_options, self.final_ldf_file, self.final_ldf_dict, "")
        sts = my_tcl_flow.process_tcl_flow_only()
        if sts:
            return sts
        my_sim_flow = xSimulation.RunSimulationFlow(self.scripts_options, self.final_ldf_file, self.final_ldf_dict)
        sts = my_sim_flow.process()
        return sts

    def run_tcl_flow(self):
        if self.create_final_ldf_file():
            return 1
        if self.dry_run:
            return 1
        if self.synthesis_only:
            return
        my_tcl_flow = xLattice.RunTclFlow(self.scripts_options, self.final_ldf_file, self.final_ldf_dict,
                                          self.special_frequency)
        sts = my_tcl_flow.process()
        return sts

    def create_final_ldf_file(self):
        my_create = xLattice.CreateDiamondProjectFile(self.scripts_options)
        sts = my_create.process()
        self.final_ldf_file = my_create.final_ldf_file
        try:
            self.final_ldf_dict = xLattice.parse_ldf_file(self.final_ldf_file, self.is_ng_flow)
        except:
            self.final_ldf_dict = dict()
            xTools.say_it("-Error. Can not parse ldf file: %s" % self.final_ldf_file)
            return 1
        # after synthesis, set the backend environment
        if self.run_ice:
            pass
        elif self.env_setter.set_be_env():
            return 1
        if sts:
            xTools.say_it("Error. Failed to create/update/run-synthesis flow")
            return 1
        self.run_postsyn_if_needed()
        self.special_frequency = my_create.special_frequency
        current_diamond_version, small_version = xLattice.get_diamond_version()
        return xLattice.update_diamond_version(self.final_ldf_file, current_diamond_version)

    def run_postsyn_if_needed(self):
        if self.env_setter.diamond_fe == self.env_setter.diamond_be:  # for both Diamond and Radiant
            return
        p_postsyn = re.compile("Command\s+Line:\s+(postsyn.+)")
        # current folder is _scratch
        log_file = "rub_pb.log"
        res = xTools.simple_parser(log_file, [p_postsyn], but_lines=300)
        if res:
            cmd_line = res[1].group(1)
            cmd_list = cmd_line.split()
            new_cmd_list = list()
            for item in cmd_list:
                if item.endswith(".ldc"):
                    item = os.path.relpath(item, os.getcwd())
                elif item.endswith(".vm") or item.endswith(".udb"):
                    for foo in os.listdir("."):
                        if os.path.isfile(os.path.join(foo, item)):
                            item = "./{}/{}".format(foo, item)
                            break
                new_cmd_list.append(item)
            new_postsyn_command = " ".join(new_cmd_list)
            xTools.run_command(new_postsyn_command, "new_postsyn.log", "new_postsyn.time")

    def run_ipgen_for_radiant(self, abs_rdf_file):
        for a, b, c in os.walk(self.src_design):
            for item in c:
                if item.endswith(".sbx"):
                    self.sbx_file = os.path.join(a, item)
                elif item.endswith(".cfg"):
                    _cfg = os.path.join(a, item)
                    my_ipgen = xRadiantIPgen.UpdateRadiantIP(_cfg, self.sbx_file, self.scripts_options, abs_rdf_file,
                                                             os.path.dirname(os.getenv("FOUNDRY")))
                    if my_ipgen.process():
                        return 1

    def rerun_sbx_tcl(self):
        self.p_sbx = re.compile("-path\s+\{([^\}]+)\}")
        _source = self.final_ldf_dict.get("source")
        sts = 0
        for foo in _source:
            if foo.get("type_short") == "SBX":
                sbx_file = xTools.win2unix(foo.get("name"))
                if os.path.isfile(sbx_file):
                    path1 = os.path.dirname(sbx_file)
                    # remove all .v/.vhd under this folder
                    for hdl in os.listdir(path1):
                        if xTools.get_fext_lower(hdl) in (".vhd", ".v"):
                            la = os.path.join(path1, hdl)
                            xTools.say_it(".. removing %s" % la)
                            os.remove(la)
                    path1 = os.path.dirname(path1)
                    _this_recov = xTools.ChangeDir(path1)
                    tcl_files = glob.glob(os.path.join(path1, "*.tcl"))
                    if not tcl_files:
                        xTools.say_it("Error. Not found tcl file for %s" % sbx_file)
                        continue
                    for tcl in tcl_files:
                        tcl = xTools.win2unix(tcl, 0)
                        tcl_lines = xTools.get_original_lines(tcl)
                        need_run = 0
                        new_lines = list()
                        for line in tcl_lines:
                            line = line.rstrip()
                            if self.p_sbx.search(line):
                                need_run = 1
                                line = self.p_sbx.sub("-path {%s}" % sbx_file, line)
                            new_lines.append(line)
                        if need_run:
                            xTools.write_file(tcl, new_lines)
                            cmd = "pnmainc %s" % tcl
                            _name = xTools.get_fname(tcl)
                            sts = xTools.run_command(cmd, "run_%s.log" % _name, "run_%s.time" % _name)
                            if sts:
                                break
                    _this_recov.comeback()
        return sts

    def copy_to_another_location_if_needed(self):
        bak_tag = self.scripts_options.get("bak_tag")
        if bak_tag:
            tag_dir = os.path.join(os.path.dirname(self.dst_design), bak_tag)
            msg = "copy {} to {}".format(self.dst_design, tag_dir)
            if os.path.isdir(tag_dir):
                xTools.remove_dir_without_error(tag_dir)
            try:
                shutil.copytree(self.dst_design, tag_dir)
                print("Success: {}".format(msg))
            except:
                print("Failed: {}".format(msg))
