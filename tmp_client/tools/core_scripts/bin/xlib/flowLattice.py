import os
import re
import sys
import glob
import ConfigParser

import xConvert
import xTools
import xLattice
import xSimulation
from xOptions import XOptions
from xReport import ScanReport
import xCommandFlow
import xiCEcube2
import qas

__author__ = 'syan'


def run_pre_post_process(base_path, pp_scripts):
    """
    add function for getting the real scripts if it has command arguments
    """

    pp_scripts_list = re.split("\s+", pp_scripts)
    real_pp = xTools.get_abs_path(pp_scripts_list[0], base_path)
    if xTools.not_exists(real_pp, "pre/post process scripts"):
        return 1
    start_from_dir, pp = os.path.split(real_pp)
    _recov = xTools.ChangeDir(start_from_dir)
    fext = xTools.get_fext_lower(real_pp)
    if fext == ".py":
        cmd_line = "%s %s " % (sys.executable, pp)
    elif fext == ".pl":
        cmd_line = "perl %s " % pp
    else:
        xTools.say_it("Unknown pre/post process scripts: %s" % pp)
        return 1
    if len(pp_scripts_list) > 1:
        cmd_line += " ".join(pp_scripts_list[1:])
    xTools.say_it("Launching %s" % cmd_line)
    #sts, text = xTools.get_status_output(cmd_line)
    #xTools.say_it(text)
    sts = os.system(cmd_line)
    _recov.comeback()
    return sts


class FlowLattice(XOptions):
    def __init__(self, private_options):
        XOptions.__init__(self, private_options)

    def process(self):
        head_lines = xTools.head_announce()

        if self.run_option_parser():
            return 1

        xTools.say_it(dict(os.environ), "Original Environments:", self.debug)
        if self.scan_only:
            return self.run_scan_only_flow()

        if self.sanity_check():
            return 1

        play_lines, play_time = xTools.play_announce(self.src_design, self.dst_design)
        self.out_log = log_file = os.path.join(self.dst_design, "runtime_console.log")
        xTools.add_cmd_line_history(log_file)
        xTools.append_file(log_file, head_lines + play_lines)
        os.environ["BQS_L_O_G"] = log_file
        _recov = xTools.ChangeDir(self.dst_design)
        sts = 0

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
        if not sts:
            sts = self.merge_local_options()

        if not sts:
            sts = self.copy_update_conf_file()
        xTools.say_it(dict(os.environ), "Original Environments:", self.debug)

        self.pre_process = self.scripts_options.get("pre_process")
        self.post_process = self.scripts_options.get("post_process")
        # run normal flow
        if self.pre_process:
            run_pre_post_process(self.src_design, self.pre_process)
        try:
            if not sts:
                if self.run_ice:
                    sts = self.run_ice_flow()
                else:
                    self.synthesis_only = xTools.get_true(self.scripts_options, "synthesis_only")
                    if self.env_setter.will_run_simulation():
                        sts = self.run_simulation_flow()
                    else:
                        if self.is_ng_flow:
                            _ldf_file = self.scripts_options.get("rdf_file")
                        else:
                            _ldf_file = self.scripts_options.get("ldf_file")
                        if _ldf_file:
                            sts = self.run_tcl_flow()
                        elif self.scripts_options.has_key("cmd_flow"):
                            sts = self.run_cmd_flow()
                        else:
                            sts = self.run_tcl_flow()
            xTools.stop_announce(play_time)
        except Exception, e:
            xTools.say_it("Error. %s" % e)

        if self.post_process:
            run_pre_post_process(self.src_design, self.post_process)

        if self.run_ice:
            final_sts = sts
        else:
            final_sts = self.run_check_flow()
        if self.scan_rpt:
            self.scan_report()
        _recov.comeback()
        return final_sts

    def scan_report(self):
        if self.is_ng_flow:
            scan_py = os.path.join(os.path.dirname(__file__),'..','..','tools','scan_report', "bin", "scan_radiant.py")
        else:
            scan_py = os.path.join(os.path.dirname(__file__),'..','..','tools','scan_report', "bin", "run_scan_lattice_step_general_case.py")
        if xTools.not_exists(scan_py, "Scan scripts"):
            return 1
        tag_dir = os.getcwd()
        design_dir, tag = os.path.split(tag_dir)
        job_dir, design = os.path.split(design_dir)
        args = "special-structure=%s --job-dir=%s --design=%s" % (tag, job_dir, design)

        cmd_line = "%s %s %s" % (sys.executable, scan_py, args)
        xTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        xTools.say_raw(text)

    def run_check_flow(self):
        # // run check flow always!
        report_path = self.scripts_options.get("cwd")
        #if(os.path.abspath(report_path) == os.path.abspath(self.job_dir)):# update by Yzhao1
        #    report_path = os.path.join(self.job_dir,self.design)
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
        #

        cmd_line = r"%s %s " % (sys.executable, check_py)
        for key, value in cmd_kwargs.items():
            cmd_line += " %s " % value

        cmd_line = xTools.win2unix(cmd_line, 0)
        xTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        xTools.say_it(text)
        return sts

    def run_ice_flow(self):
        my_flow = xiCEcube2.Run_iCEcube(self.scripts_options)
        sts = my_flow.iCE_process()
        return sts


    def record_debug_message(self):
        def __get_value(value):
            if not value:
                value = ""
            if type(value) is list:
                joint_string = ">%s     <" % os.linesep
                value = "<%s>" % joint_string.join(value)
            return value
        config=ConfigParser.ConfigParser()
        section_qa = "qa"
        config.add_section(section_qa)
        for section, foo in self.scripts_options.items():
            if type(foo) is dict:
                config.add_section(section)
                for key, bar in foo.items():
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
            if not len_info_file: # No info file found
                if self.is_ng_flow:
                    prj_fext = "*.rdf"
                else:
                    prj_fext = "*.ldf"
                ldf_file = list()
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
        xTools.say_it(self.scripts_options, "Final Options", self.debug)

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
                print >> ob_dst, "golden_file = %s" % real_golden_file
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
        my_tcl_flow = xLattice.RunTclFlow(self.scripts_options, self.final_ldf_file, self.final_ldf_dict)
        sts = my_tcl_flow.process()
        return sts

    def create_final_ldf_file(self):
        my_create = xLattice.CreateDiamondProjectFile(self.scripts_options)
        sts = my_create.process()
        if sts:
            xTools.say_it("Error. Failed to create/update project file")
            return 1
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
        current_diamond_version, small_version = xLattice.get_diamond_version()
        return xLattice.update_diamond_version(self.final_ldf_file, current_diamond_version)


