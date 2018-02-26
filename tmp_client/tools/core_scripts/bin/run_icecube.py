__author__ = 'yzhao1'
###############################################
# Description: This is the entrance of ICEcube test flow
# Owner      : SWQA Auto Yzhao1
# Version    : 1.0
# Update     : None
###############################################
import os,sys,re,glob,copy,shutil
from xlib import xTools
import optparse
import ConfigParser
import traceback
from xlib import ice_batch_flow

class ice_flow:
    def __init__(self):
        self.scripts_options={}
        self.scan_result_reverse = ""
    def parse_option(self):
        self.parser = optparse.OptionParser()
        # public options for the case
        pub_group = optparse.OptionGroup(self.parser, "Public Options")
        pub_group.add_option("--ice", help="specify ice install path,you should specify to LSE parent directory")
        pub_group.add_option("--nt64",action="store_true",default=False,help="run icecube 64bit iCECUBE")
        pub_group.add_option("--top-dir", help="specify the top source path name")
        pub_group.add_option("--design", help="specify the design name")
        pub_group.add_option("--conf-file", help="specify the conf file name")
        pub_group.add_option("--info", help="specify info file name")
        pub_group.add_option("--job-dir", help="specify the job working path name")
        pub_group.add_option("--tag", default="_scratch", help="specify the job tag name, default is _scratch, " +
                                                               "which is created in the design job working path")
        pub_group.add_option("--pre-process", help="run pre-process for a case")
        pub_group.add_option("--post-process", help="run post-process for a case")
        pub_group.add_option("--scan", action="store_true",default=False, help="Scan for a case after flow over")
        pub_group.add_option("--scan-only", action="store_true",default=False, help="Just scan for a case")
        pub_group.add_option("--check-only", action="store_true",default=False, help="Just Check for a case")
        self.parser.add_option_group(pub_group)
        #project options for the case
        frontend_group = optparse.OptionGroup(self.parser, "Project Options")
        _choice_synthesis = ("synplify", "lse")
        _choice_goal = ("area", "timing")
        frontend_group.add_option("--synthesis", type="choice", choices=_choice_synthesis,
                                    help="specify synthesis name, else use default one")
        frontend_group.add_option("--goal", type="choice", choices=_choice_goal,
                                    help="specify synthesis optimization goal")
        frontend_group.add_option("--no-carry-chain", action="store_true",
                                  help="add '-use_carry_chain 0' for iCEcube2 lse flow")
        frontend_group.add_option("--family",help="specify the ice family")
        frontend_group.add_option("--device",help="specify the ice device")
        frontend_group.add_option("--package",help="specify the ice package")
        self.parser.add_option_group(frontend_group)
        #flow options for the case
        backend_group = optparse.OptionGroup(self.parser, "Implementation Options")
        # just add this now, it will be use for next developing
        backend_group.add_option("--pushbutton", action="store_true",default=True, help="default pushbutton flow, run till the run_bitmap")
        backend_group.add_option("--pack-area", action="store_true", help="add --pack_area in sbtplacer command line")

        self.parser.add_option_group(backend_group)
        # simulation options for the case
        sim_group = optparse.OptionGroup(self.parser, "Simulation Options")
        sim_group.add_option("--sim-vhd",action="store_true",default=False,help="run VHDL simulation")
        sim_group.add_option("--sim-verilog",action="store_true",default=False,help="run verilog simulation")
        #sim_group.add_option("--model-sim",help="specify model-sim install path and run simulation with it")
        #sim_group.add_option("--questa-sim",help="specify questa-sim install path and run simulation with it")
        sim_group.add_option("--sim-modelsim",action="store_true",default=False,help="run simulation with modelsim")
        sim_group.add_option("--sim-questasim",action="store_true",default=False,help="run simulation with questasim")
        sim_group.add_option("--modelsim-path",help="specify modelsim install path")
        sim_group.add_option("--questasim-path",help="specify questasim install path")
        sim_group.add_option("--post-syn",action="store_true",default=False,help="run post-syn simulation")
        sim_group.add_option("--post-map",action="store_true",default=False,help="run post-map simulation")
        sim_group.add_option("--post-par",action="store_true",default=False,help="run post-par simulation")
        sim_group.add_option("--dms",action="store_true",default=False,help="run dms simulation")
        sim_group.add_option("--x32",action="store_true",default=False,help="run dms simulation with 32bit lib")
        sim_group.add_option("--sim-time",default="all",help="specify the simulation time for post-syn/map/par.The default is 'all'. You can also set it as 'int' value ")
        self.parser.add_option_group(sim_group)
        # waiting for next step use
    def run_cmd_line_parser(self):
        '''
        At the options from command line
        '''
        self.parse_option()
        opts, args = self.parser.parse_args()
        _cmd_opts = eval(str(opts))
        #xTools.dict_none_to_new(self.scripts_options, _cmd_opts)
        self.scripts_options.update(_cmd_opts)
        ice_path = self.scripts_options.get("ice",'')
        if self.scripts_options.get("ice",''):
            self.scripts_options.update({'ice':ice_path})
            self.scripts_options.update({'icecube_path':ice_path})
        else:
            if os.environ.get("EXTERNAL_"+"ICECUBE"+"_PATH",""):
                self.scripts_options.update({"ice":os.environ.get("EXTERNAL_"+"ICECUBE"+"_PATH","")})
                self.scripts_options.update({"icecube_path":os.environ.get("EXTERNAL_"+"ICECUBE"+"_PATH","")})

        '''if self.scripts_options.get("model_sim"):
            self.scripts_options.update({"modelsim_path":self.scripts_options.get("model_sim")})
        else:
            self.scripts_options.update({"modelsim_path":""})
        if self.scripts_options.get("questa_sim"):
            self.scripts_options.update({"modelsim_path":self.scripts_options.get("questa_sim")})
        else:
            #self.scripts_options.update({"modelsim_path":""})
            pass'''
        if self.scripts_options.get("sim_modelsim") == True:
            if self.scripts_options.get("modelsim_path",""):
                pass
            elif os.environ.get("EXTERNAL_"+"MODELSIM"+"_PATH",""):
                self.scripts_options.update({"modelsim_path":os.environ.get("EXTERNAL_"+"MODELSIM"+"_PATH","")})
            else:
                pass
        if self.scripts_options.get("sim_questasim") == True:
            if self.scripts_options.get("questasim_path",""):
                pass
            elif os.environ.get("EXTERNAL_"+"QUESTASIM"+"_PATH",""):
                self.scripts_options.update({"questasim_path":os.environ.get("EXTERNAL_"+"QUESTASIM"+"_PATH","")})
            else:
                pass

    def merge_conf_options(self):
        '''
        get the conf file setting, and merge them with command options
        '''
        _conf = self.scripts_options.get("conf")
        if not _conf:
            _conf = os.path.join(os.path.dirname(sys.argv[0]), "..", "conf")
        if os.path.isdir(_conf):
            pass
        else:
            if xTools.not_exists(_conf, "Default Configuration Path"):
                return 1
        _conf = os.path.abspath(_conf)
        self.scripts_options["conf"] = _conf
        conf_files = glob.glob(os.path.join(_conf, "*.ini"))
        if not conf_files:
            xTools.say_it("-Error. Not found any ini file under %s" % _conf)
            return 1
        sts, conf_options = xTools.get_conf_options(conf_files)
        if sts:
            return 1
        #if conf_options.get("ice",""):
        #    conf_options["icecube_path"] = conf_options.get("ice","")
        self._merge_options(conf_options)
    def _merge_options(self, new_options):
        #xTools.dict_none_to_new(old_dict,new_dict): merge old and new. if item is not in old, add to old.
        for section, options in new_options.items():
            if section not in ("qa", "environment", "command", "cmd_flow", "sim"):
                pass
            if section == 'qa':
                xTools.dict_none_to_new(self.scripts_options, options)
                if(self.scripts_options.get("ice","")):
                    self.scripts_options["icecube_path"] = self.scripts_options.get("ice","")
            elif section == 'cmd':
                old_cmd = self.scripts_options.get('cmd', dict())
                new_cmd = copy.copy(options)
                xTools.dict_none_to_new(new_cmd, old_cmd)
                self.scripts_options['cmd'] = new_cmd
            else:
                old_cmd = self.scripts_options.get(section, dict())
                xTools.dict_none_to_new(old_cmd, options)
                self.scripts_options[section] = old_cmd
        if self.scripts_options.get("neg","").lower().strip() == "yes":
            self.scan_result_reverse = "1"
    def flatten_options_1st(self):
        '''
        set some usual options from command
        :return:
        '''
        self.conf = self.scripts_options.get("conf")
        self.top_dir = self.scripts_options.get("top_dir")
        self.design = self.scripts_options.get("design")
        self.info_file_name = self.scripts_options.get("info")
        self.job_dir = self.scripts_options.get("job_dir")
        self.tag = self.scripts_options.get("tag")
        self.devkit = self.scripts_options.get("devkit")
        self.family = self.scripts_options.get("family")
        self.device = self.scripts_options.get("device")
        self.package = self.scripts_options.get("package")
        self.scan_only = self.scripts_options.get("scan_only")
        self.check_only = self.scripts_options.get("check_only")
        self.scan = self.scripts_options.get("scan")

    def run_option_parser(self):
        '''
        Total option parse.
        cmd line options has the highest priority
        :return:
        '''
        self.run_cmd_line_parser()
        if self.merge_conf_options():
            return 1
        if self.flatten_options_1st():
            return 1
    def record_debug_message(self,dir=os.getcwd()):
        '''
        This function used to record the configure information into local_debug.ini file
        '''
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
        config.write(open(os.path.join(dir,"local_debug.ini"),"w"))
    def merge_local_options(self):
        '''
        Get the info/project options from the case directory
        :return:
        '''
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
        #self.flatten_options_1st()
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
    def run_pre_post_process(self,pre=0):
        '''
        This function will run pre/post process for the cases. the scripts should be passed
        through the command.
        The run path is case result path(job_dir/design)!
        '''
        if pre == 1:
            cmd = self.scripts_options.get("pre_process")
        else:
            cmd = self.scripts_options.get("post_process")
        if cmd.find(".py")!= -1:
            if cmd.find("python") == -1:
                cmd = "%s %s" % (sys.executable, cmd)
            else:
                pass
        xTools.say_it("Launching %s" % cmd)
        sts, text = xTools.get_status_output(cmd)
        xTools.say_it(text)
        return sts
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
        for conf_f in os.listdir(self.scripts_options["src_design"]):
            if conf_f.endswith(".conf"):
                try:
                    shutil.copy(os.path.join(self.src_design,conf_f),os.path.join(self.job_dir, self.design))
                except:
                    pass

    @property
    def process(self):
        head_lines = xTools.head_announce()
        self.run_option_parser()
        if self.sanity_check():
            return 1
        final_sts = 0
        try:
            play_lines, play_time = xTools.play_announce(self.src_design, self.dst_design)
            self.out_log = log_file = os.path.join(self.dst_design, "runtime_console.log")
            xTools.add_cmd_line_history(log_file)
            xTools.write_file(log_file, head_lines + play_lines)
            os.environ["BQS_L_O_G"] = log_file
            sts = 0
            if not sts:
                self.record_debug_message(self.dst_design)
            if not sts:
                sts = self.merge_local_options()
            if not sts:
                '''
                At here, we need to update check conf file if need. It's just a port for future use.
                '''
                pass
            if (not self.scan_only) and (not self.check_only):
                _recov = xTools.ChangeDir(self.dst_design)
                self.pre_process = self.scripts_options.get("pre_process")
                self.post_process = self.scripts_options.get("post_process")
                if self.pre_process:
                    self.run_pre_post_process(1)
                if not sts:
                    ice_flow_instance = ice_batch_flow.Run_iCEcube(self.scripts_options)
                    sts = ice_flow_instance.iCE_process
                    if sts:
                        print "run Fail"
                    #sts = self.run_ice_flow()
                xTools.stop_announce(play_time)
                final_sts = sts
                if self.post_process:
                    self.run_pre_post_process()
                _recov.comeback()
                if self.scan:
                    self.scan_resource()
        except Exception,e:
            print str(traceback.format_exc())
            pass
        if self.scan_only:
            self.scan_resource()
        check_sts = self.run_check_flow()
        #return final_sts
        return check_sts
    def scan_report(self):
        print "=======================Scan Report========================"
        scan_python = os.path.abspath(os.path.dirname(__file__)+"../../tools/scan_report/bin/run_scan_ice_general_flow.py")
        scan_python = os.path.abspath(scan_python)
        reverse = ""
        if self.scan_result_reverse:
            reverse = " --reverse="+self.scan_result_reverse
        cmd = "python"+ " " +scan_python+" --job-dir="+self.job_dir+" --design="+self.design + reverse
        #xTools.run_command(cmd, "run.log", "run.time")
        os.system(cmd)
    def scan_resource(self):
        print "=======================Scan Source Report========================"
        scan_python = os.path.abspath(os.path.dirname(__file__)+"../../tools/scan_report/bin/run_scan_ice.py")
        scan_python = os.path.abspath(scan_python)
        cmd = "python"+ " " +scan_python+" --job-dir="+self.job_dir+" --design="+self.design
        #xTools.run_command(cmd, "run.log", "run.time")
        os.system(cmd)

    def run_check_flow(self):
        # // run check flow always!
        report_path = os.getcwd();
        report = "check_flow.csv"
        check_py = os.path.join(os.path.dirname(__file__),'..','tools','check', "check.py")
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
            ### the conf file will be used as as family_device_package.conf
            [self.family2,self.device2,self.package2] = ["","",""]
            if not self.family:
                try:
                    [self.family2,self.device2,self.package2] = self.scripts_options.get("devkit","").split(",")
                except:
                    pass
            if self.family2.strip():
                self.family = self.family2
            if self.device2.strip():
                self.device = self.device2
            if self.package2.strip():
                self.package = self.package2
            _check_conf = self.family.strip()+"_"+self.device.strip()+"_"+self.package.strip()+".conf"
            if(os.path.isfile(os.path.join(self.src_design,_check_conf))):
                cmd_kwargs["conf_file"] ="--conf-file="+ _check_conf.replace(".conf","")
            else:
                #cmd_kwargs["conf_file"] = ""
                pass
        cmd_kwargs["report_path"] = "--report-path=%s" % report_path
        cmd_kwargs["tag"] = "--tag=%s" % self.tag
        cmd_kwargs["report"] = "--report=%s" % report
        cmd_line = r"%s %s " % (sys.executable, check_py)
        for key, value in cmd_kwargs.items():
            cmd_line += " %s " % value
        cmd_line = xTools.win2unix(cmd_line, 0)
        xTools.say_it(" Launching %s" % cmd_line)
        sts, text = xTools.get_status_output(cmd_line)
        xTools.say_it(text)
        return sts

if __name__ == '__main__':
    instance = ice_flow()
    try:
        sts =  instance.process
    except:
        sts = 1
    #sts = instance.process
    #print sts
    #instance.scan_report()
    sys.exit(sts)
