__author__ = 'yzhao1'
###########################################
# Update 12/2 remove -t 1ns for Rachel's need
############################################
import sys,os,re,shutil,time
import xTools
import platform


def add_lib_cfg():
    xTools.write_file('library.cfg', ['$INCLUDE = "$ACTIVEHDLLIBRARYCFG"'])


class Run_iCEcube:
    def __init__(self, flow_options):

        self.run_synthesis  = 1
        self.run_edifparser = 1
        self.run_sbtplacer  = 1
        self.run_packer_drc = 1
        self.run_packer     = 1
        self.run_sbrouter   = 1
        self.run_netlister  = 1
        self.run_sbtimer    = 1
        self.run_bitmap     = 1
        self.sim_vhd    = 0
        self.sim_verilog = 0
        self.sim_dms = 0
        self.post_syn = 0
        self.post_map = 0
        self.post_par = 0
        self.trigger_unit = "U1" # used for fe simulation
        self.all_tb_files = [] # used for multi-tbs
        self.pack_area = flow_options.get("pack_area")
        if flow_options.get("post_syn"):
            self.run_synthesis  = 1
            self.run_edifparser = 0
            self.run_sbtplacer  = 0
            self.run_packer_drc = 0
            self.run_packer     = 0
            self.run_sbrouter   = 0
            self.run_netlister  = 0
            self.run_sbtimer    = 0
            self.run_bitmap     = 0
            self.post_syn       = 1
        elif flow_options.get("post_map"):
            self.run_synthesis  = 1
            self.run_edifparser = 1
            self.run_sbtplacer  = 1
            self.run_packer_drc = 1
            self.run_packer     = 1
            self.run_sbrouter   = 1
            self.run_netlister  = 1
            self.run_sbtimer    = 1
            self.run_bitmap     = 1
            self.post_map       = 1
        elif flow_options.get("post_par"):
            self.run_synthesis  = 1
            self.run_edifparser = 1
            self.run_sbtplacer  = 1
            self.run_packer_drc = 1
            self.run_packer     = 1
            self.run_sbrouter   = 1
            self.run_netlister  = 1
            self.run_sbtimer    = 1
            self.run_bitmap     = 1
            self.post_par       = 1
        elif flow_options.get("dms"):
            self.run_synthesis  = 1
            self.run_edifparser = 1
            self.run_sbtplacer  = 1
            self.run_packer_drc = 1
            self.run_packer     = 1
            self.run_sbrouter   = 1
            self.run_netlister  = 1
            self.run_sbtimer    = 1
            self.run_bitmap     = 1
            self.sim_dms = 1
        else:
            pass
        if flow_options.get("x32"):
            self.dms_32 = 1
        else:
            self.dms_32 = 0
        # this is used for rachel
        self.tb_top = flow_options.get("tb_top","tb")
        self.sim_step = flow_options.get("sim_step","")
        if self.sim_step:
            self.sim_step = "-t 1ps"
        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\edifparser.exe"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt/col_01_get_ports.edf "
        # "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist"
        # "-pSWG25TR" -c --devicename iCE40LM4K
        edifparser = r'''%(ice_opt_path)s/edifparser.exe
                     "%(dev_file)s"
                     "%(cwd)s/%(implmnt_path)s/%(ProjectName)s.edf "
                     "%(cwd)s/%(implmnt_path)s/sbt/netlist"
                     "-p%(DevicePackage)s" %(pcf_file)s  %(ip_file)s -c --devicename %(DeviceFamily)s%(Device)s'''

        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\sbtplacer.exe"
        # --des-lib "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # --outdir "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\placer"
        # --device-file "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # --package SWG25TR --deviceMarketName iCE40LM4K
        # --sdc-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\Temp/sbt_temp.sdc"
        # --lib-file "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ice40LM4K.lib" --effort_level std
        # --out-sdc-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\placer\top_pl.sdc"
        sbtplacer = '''%(ice_opt_path)s/sbtplacer.exe
                    --des-lib "%(cwd)s/%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                    --outdir "%(cwd)s/%(implmnt_path)s/sbt/outputs/placer"
                    --device-file "%(dev_file)s"
                    --package %(DevicePackage)s --deviceMarketName %(DeviceFamily)s%(Device)s
                    --sdc-file "%(cwd)s/%(implmnt_path)s/sbt/Temp/sbt_temp.sdc"
                    --lib-file "%(lib_file)s"
                    --effort_level std
                    --out-sdc-file "%(cwd)s/%(implmnt_path)s/sbt/outputs/placer/%(DesignCell)s_pl.sdc"'''

        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\packer.exe"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # --package SWG25TR --outdir "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\packer"
        # --DRC_only  --translator "D:\lscc\iCEcube2.2014.04prod\sbt_backend\bin\sdc_translator.tcl"
        # --src_sdc_file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\placer\top_pl.sdc"
        # --dst_sdc_file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\packer\top_pk.sdc"
        # --devicename iCE40LM4K
        packer_drc = '''%(ice_opt_path)s/packer.exe
                        "%(dev_file)s"
                        "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                        --package %(DevicePackage)s --outdir "./%(implmnt_path)s/sbt/outputs/packer"
                        --DRC_only  --translator "%(sdc_translator)s"
                        --src_sdc_file "./%(implmnt_path)s/sbt/outputs/placer/%(DesignCell)s_pl.sdc"
                        --dst_sdc_file "./%(implmnt_path)s/sbt/outputs/packer/%(DesignCell)s_pk.sdc"
                        --devicename %(DeviceFamily)s%(Device)s'''

        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\packer.exe"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # --package SWG25TR --outdir "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\packer"
        # --translator "D:\lscc\iCEcube2.2014.04prod\sbt_backend\bin\sdc_translator.tcl"
        # --src_sdc_file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\placer\top_pl.sdc"
        # --dst_sdc_file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\packer\top_pk.sdc"
        # --devicename iCE40LM4K
        packer = '''%(ice_opt_path)s/packer.exe
                     "%(dev_file)s"
                     "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                     --package %(DevicePackage)s
                     --outdir "./%(implmnt_path)s/sbt/outputs/packer"
                     --translator "%(sdc_translator)s"
                     --src_sdc_file "./%(implmnt_path)s/sbt/outputs/placer/%(DesignCell)s_pl.sdc"
                     --dst_sdc_file "./%(implmnt_path)s/sbt/outputs/packer/%(DesignCell)s_pk.sdc"
                     --devicename %(DeviceFamily)s%(Device)s'''

        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\bin\win32\opt\sbrouter.exe"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # "D:\test\01_col_01_get_ports\par\col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ice40LM4K.lib"
        # "D:\test\01_col_01_get_ports\par\col_01_get_ports_Implmnt\sbt\outputs\packer\top_pk.sdc"
        # --outdir "D:\test\01_col_01_get_ports\par\col_01_get_ports_Implmnt\sbt\outputs\router"
        # --sdf_file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\simulation_netlist\top_sbt.sdf"
        # --pin_permutation
        sbrouter = '''%(ice_opt_path)s/sbrouter.exe
                      "%(dev_file)s"
                      "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                      "%(lib_file)s"
                      "./%(implmnt_path)s/sbt/outputs/packer/%(DesignCell)s_pk.sdc"
                      --outdir "./%(implmnt_path)s/sbt/outputs/router"
                      --sdf_file "./%(implmnt_path)s/sbt/outputs/simulation_netlist/%(DesignCell)s_sbt.sdf"
                      --pin_permutation '''
        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\netlister.exe"
        # --verilog "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\simulation_netlist\top_sbt.v"
        # --vhdl "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt/sbt/outputs/simulation_netlist\top_sbt.vhd"
        # --lib "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top" --view rt
        # --device "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev" --splitio
        # --in-sdc-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\packer\top_pk.sdc"
        # --out-sdc-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\netlister\top_sbt.sdc"
        netlister = '''%(ice_opt_path)s/netlister.exe
                        --verilog "./%(implmnt_path)s/sbt/outputs/simulation_netlist/%(DesignCell)s_sbt.v"
                        --vhdl "./%(implmnt_path)s/sbt/outputs/simulation_netlist/%(DesignCell)s_sbt.vhd"
                        --lib "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                        --view rt
                        --device "%(dev_file)s"
                        --splitio
                        --in-sdc-file "./%(implmnt_path)s/sbt/outputs/packer/%(DesignCell)s_pk.sdc"
                        --out-sdc-file "./%(implmnt_path)s/sbt/outputs/netlister/%(DesignCell)s_sbt.sdc" '''
        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\bitmap.exe"
        # "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
        # --design "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # --device_name iCE40LM4K --package SWG25TR
        # --outdir "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\bitmap"
        # --low_power on --init_ram on --init_ram_bank 1111 --frequency low --warm_boot on
        bitmap = '''%(ice_opt_path)s/bitmap.exe
                     "%(dev_file)s"
                     --design "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                     --device_name %(DeviceFamily)s%(Device)s --package %(DevicePackage)s
                     --outdir "./%(implmnt_path)s/sbt/outputs/bitmap"
                     --low_power on
                     --init_ram on
                     --init_ram_bank 1111
                     --frequency low
                     --warm_boot on'''
        #--tile_bit_usage moved in bitmap
        # "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\sbtimer.exe"
        # --des-lib "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist\oadb-top"
        # --lib-file "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ice40LM4K.lib"
        # --sdc-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\netlister\top_sbt.sdc"
        # --sdf-file "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\outputs\simulation_netlist\top_sbt.sdf"
        # --report-file "D:\test\01_col_01_get_ports\par\col_01_get_ports_Implmnt\sbt\outputs\timer\top_timing.rpt"
        # --device-file "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev" --timing-summary
        sbtimer = '''%(ice_opt_path)s/sbtimer.exe
                      --des-lib "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s"
                      --lib-file "%(lib_file)s"
                      --sdc-file "./%(implmnt_path)s/sbt/outputs/netlister/%(DesignCell)s_sbt.sdc"
                      --sdf-file "./%(implmnt_path)s/sbt/outputs/simulation_netlist/%(DesignCell)s_sbt.sdf"
                      --report-file "./%(implmnt_path)s/sbt/outputs/timer/%(DesignCell)s_timing.rpt"
                      --device-file "%(dev_file)s" --timing-summary'''
        self.flow_options = flow_options
        if self.flow_options.get("sim_vhd",""):
            self.sim_vhd = 1
        if self.flow_options.get("sim_verilog",""):
            self.sim_verilog = 1
        self.default_tmpl = dict(edifparser = self.one_space(edifparser), sbtplacer = self.one_space(sbtplacer),
            packer_drc = self.one_space(packer_drc), packer = self.one_space(packer),
            sbrouter = self.one_space(sbrouter), netlister = self.one_space(netlister),
            sbtimer = self.one_space(sbtimer), bitmap = self.one_space(bitmap))
        self.tb_file = ''
    def one_space(self,a_string):
        #print a_string
        return re.sub("\s+", " ", a_string)
    def iCEcube_check_environment(self):
        '''
        Check the icecube path and set environment
        :return:
        '''
        iCEcube_path = self.flow_options.get("icecube_path")
        if xTools.not_exists(iCEcube_path, "iCEcube path"):
            return 1
        self.ice_root_path = iCEcube_path
        if platform.system()!= 'Windows':
            t_os = "lin"
        else:
            t_os = "nt"

        if self.flow_options.get("nt64"):
            t_os += "64"
        if platform.system()!= 'Windows':
            self.ice_opt_path = xTools.win2unix(os.path.join(iCEcube_path, "sbt_backend", "bin", "linux", "opt"))
            if self.flow_options.get("nt64"):
                self.lse_exe = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", t_os, "synthesis"))
            else:
                self.lse_exe = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", "lin", "synthesis"))
            self.synpwrap_exe = xTools.win2unix(os.path.join(self.ice_opt_path, "synpwrap","synpwrap"))
        else:
            self.ice_opt_path = xTools.win2unix(os.path.join(iCEcube_path, "sbt_backend", "bin", "win32", "opt"))
            self.lse_exe = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", t_os, "synthesis.exe"))
            self.synpwrap_exe = xTools.win2unix(os.path.join(self.ice_opt_path, "synpwrap", "synpwrap.exe"))
        os.environ["FOUNDRY"] = xTools.win2unix(os.path.join(iCEcube_path, "LSE"))
        os.environ["SYNPLIFY_PATH"] = xTools.win2unix(os.path.join(iCEcube_path, "synpbase"))
        os.environ["MODEL_TECH"] = xTools.win2unix(os.path.join(iCEcube_path, "Aldec","Active-HDL","BIN"))
        #os.environ["LM_LICENSE_FILE"] = "1700@linux19v"
        if platform.system()!= "Windows":
            os.environ["TCL_LIBRARY"] = xTools.win2unix(os.path.join(iCEcube_path,"sbt_backend","bin","linux","lib","tcl8.4"))
            os.environ["LD_LIBRARY_PATH"] = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", t_os))+\
                                        ":"+xTools.win2unix(os.path.join(self.ice_opt_path, "synpwrap"))+\
                                        ":"+xTools.win2unix(os.path.join(iCEcube_path,"sbt_backend","lib","linux","opt"))
            if self.flow_options.get("modelsim_path",""):
                os.environ["AMS_MODEL_TECH"] = self.flow_options.get("modelsim_path","")
            #elif self.flow_options.get("questasim_path",""):
            #    os.environ["AMS_MODEL_TECH"] = self.flow_options.get("questasim_path","")
        else:
            os.environ["TCL_LIBRARY"] = xTools.win2unix(os.path.join(iCEcube_path,"sbt_backend","bin","win32","lib","tcl8.4"))
            #os.environ["PATH"] = os.environ["PATH"]+";"+xTools.win2unix(os.path.join(iCEcube_path,"sbt_backend","bin","linux","lib","tcl8.4"))
            os.environ["LD_LIBRARY_PATH"] = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", t_os))+\
                                        ";"+xTools.win2unix(os.path.join(self.ice_opt_path, "synpwrap"))
        os.environ["UNBLOCK_LEDDIP_THUNDER"] = "1"
        for env_k,env_v in self.flow_options.get('environment',{}).items():
            if type(env_v) is list:
                if platform.system()!= "Windows":
                    os.environ[env_k.upper()] = ":".join(env_v)
                else:
                    os.environ[env_k.upper()] = ";".join(env_v)
            else:
                os.environ[env_k.upper()] = env_v
    @property
    def iCE_process(self):
        '''
        Begin to run ice flow
        :return:
        '''
        sts = self.iCEcube_check_environment()
        if sts:
            return 1
        if self.prepare_run_flow():
            return 1
        if self.run_synthesis:
            if self.synthesis == "synplify":

                if platform.system()!= "Windows":
                    template_file = os.path.join(self.conf, "ice_synthesis", "run_synplify_linux.prj")
                    prj_file = "run_synplify_linux.prj"
                else:
                    template_file = os.path.join(self.conf, "ice_synthesis", "run_synplify.prj")
                    prj_file = "run_synplify.prj"
            else:

                if platform.system()!= "Windows":
                    template_file = os.path.join(self.conf, "ice_synthesis", "run_lse_linux.synproj")
                    prj_file = "run_lse_linux.synproj"
                else:
                    template_file = os.path.join(self.conf, "ice_synthesis", "run_lse.synproj")
                    prj_file = "run_lse.synproj"
            if xTools.not_exists(template_file, "Template file"):
                return 1
            if self.kwargs.get("DeviceFamily") == "iCE40UP":
                self.old_family = ""
                self.old_devic = ""
                pass
                #self.old_family = "iCE40UP"
                #self.old_device = self.kwargs["Device"]
                #self.kwargs["DeviceFamily"] = 'iCE5LP'
                #self.kwargs["Device"] = "4K"
            else:
                self.old_family = ""
            xTools.generate_file(prj_file, template_file, self.kwargs)
            if self.synthesis == "synplify":
                syn_cmd = "%s -prj %s" % (self.synpwrap_exe, prj_file)
            else:
                self.no_carry_chain = self.flow_options.get("no_carry_chain")
                if self.no_carry_chain:
                    add_options = "-use_carry_chain 0"
                else:
                    add_options = ""
                syn_cmd = "%s %s -f %s" % (self.lse_exe, add_options, prj_file)
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_synthesis Fail"
                #return 1
        if self.post_syn:
            '''
            Run post syn simulation
            '''

            if self.flow_options["modelsim_path"] and self.flow_options.get("sim_modelsim"):
                self.post_sim(self.flow_options["modelsim_path"],"post_syn",self.synthesis)
            elif self.flow_options["questasim_path"] and self.flow_options.get("sim_questasim"):
                self.post_sim(self.flow_options["questasim_path"],"post_syn",self.synthesis)
            else:
                self.post_sim(synthesis_tool=self.synthesis)
        if self.run_edifparser:
            # get the real command
            # run command
            syn_cmd = self.default_tmpl.get('edifparser')
            DP = self.kwargs.get("DevicePackage")
            DF = self.kwargs.get("DeviceFamily")
            if DP == "SWG16TR" and  DF == "iCE40":
                d_f = self.kwargs["dev_file"]
                new_d_f = re.sub("ICE40P05.dev","ICE40P01.dev",d_f)
                #new_d_f = d_f.replace("ICE40P05.dev","ICE40P01.dev")
                self.kwargs["dev_file"] = new_d_f
            else:
                pass
            syn_cmd = syn_cmd % self.kwargs
            if platform.system()!= 'Windows':
                syn_cmd = re.sub('.exe',' ',syn_cmd)
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_edifparser Fail"
                #return 1
        if self.old_family:
            self.kwargs["DeviceFamily"] = self.old_family
            self.kwargs["Device"] = self.old_device
        if self.run_sbtplacer:
            syn_cmd = self.default_tmpl.get('sbtplacer')
            syn_cmd = syn_cmd % self.kwargs
            if platform.system()!= 'Windows':
               syn_cmd = re.sub('.exe',' ',syn_cmd)
            if self.pack_area:
                syn_cmd += "  --pack_area"
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_sbtplacer Fail"
                #return 1
        if self.post_map:
            '''
            Run post map simulation
            '''
            pass
        if self.run_packer_drc:
            syn_cmd = self.default_tmpl.get('packer_drc')
            syn_cmd = syn_cmd % self.kwargs
            if platform.system()!= 'Windows':
                syn_cmd = re.sub('.exe',' ',syn_cmd)
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_packer_drc Fail"
                #return 1
        if self.run_packer:
            syn_cmd = self.default_tmpl.get('packer')
            if platform.system()!= 'Windows':
               syn_cmd = re.sub('.exe',' ',syn_cmd)
            syn_cmd = syn_cmd % self.kwargs
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_packer Fail"
                #return 1
        if self.run_sbrouter:
            syn_cmd = self.default_tmpl.get('sbrouter')
            if platform.system()!= 'Windows':
                syn_cmd = re.sub('.exe',' ',syn_cmd)
            syn_cmd = syn_cmd % self.kwargs
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_sbrouter Fail"
                #return 1

        if self.run_netlister:
            syn_cmd = self.default_tmpl.get('netlister')
            if platform.system()!= 'Windows':
               syn_cmd = re.sub('.exe',' ',syn_cmd)
            syn_cmd = syn_cmd % self.kwargs
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_netlister Fail"
                #return 1

        if self.run_sbtimer:
            syn_cmd = self.default_tmpl.get('sbtimer')
            if platform.system()!= 'Windows':
                syn_cmd = re.sub('.exe',' ',syn_cmd)
            syn_cmd = syn_cmd % self.kwargs
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_sbtimer Fail"
                #return 1

        if self.run_bitmap:
            syn_cmd = self.default_tmpl.get('bitmap')
            if platform.system()!= 'Windows':
                syn_cmd = re.sub('.exe',' ',syn_cmd)
            syn_cmd = syn_cmd % self.kwargs
            sts = xTools.run_command(syn_cmd, "run.log", "run.time")
            if sts:
                print "run_bitmap Fail"
                #return 1
        if self.post_par:
            '''
            run post par simulation
            '''
            if self.flow_options["modelsim_path"] and self.flow_options.get("sim_modelsim"):
                self.post_sim(self.flow_options["modelsim_path"],"post_par",self.synthesis)
            elif self.flow_options["questasim_path"] and self.flow_options.get("sim_questasim"):
                self.post_sim(self.flow_options["questasim_path"],"post_par",self.synthesis)
            else:
                self.post_sim(step="post_par",synthesis_tool=self.synthesis)
        else:

            if self.sim_verilog:
                if self.flow_options.get("modelsim_path","") :
                    stat = self.run_sim_verilog_modelsim()
                else:
                    stat = self.run_sim_verilog()
                if stat:
                    print "post_par sim_verilog Fail"
                    #return 1
            if self.sim_vhd:
                if self.flow_options.get("modelsim_path",""):
                    stat = self.run_sim_vhdl_modelsim()
                else:
                    stat = self.run_sim_vhdl()
                if stat:
                    print "post_par sim_vhd Fail"
                    #return 1
        if self.sim_dms:
            self.run_DMS()
    def get_synp_source_files(self, src_files):
        '''
        Get the synplify format file according to the src list
        '''
        final_lines = list()
        for item in src_files:
            src_file = item[-1]
            pre_str = self.get_lse_pre_str(src_file)
            if not pre_str:
                continue
            if pre_str == "-ver":
                final_lines.append('add_file -verilog "%s"' % src_file)
            elif pre_str == "-constraint":
                final_lines.append('add_file -constraint "%s"' % src_file)
            elif pre_str == "-input_edif":
                # add_file -edif -lib work "../../../day2/ice_case/06_c5/gen_edf.edf"
                final_lines.append('add_file -edif -lib work "%s"' % src_file)
            else:
                if len(item) > 1:
                    lib_name = item[1]
                else:
                    lib_name = "work"
                final_lines.append('add_file -vhdl -lib %s "%s"' % (lib_name, src_file))
        return os.linesep.join(final_lines)

    def get_lse_source_files(self, src_files):
        '''
        Get the LSE format file according to the src list
        '''
        lse_source_files = list()
        for item in src_files:
            src_file = item[-1]
            pre_str = self.get_lse_pre_str(src_file)
            if not pre_str:
                continue
            if pre_str == "-constraint":
                temp_line = src_file
                lse_source_files.append(("-sdc", temp_line))
                continue
            if len(item) > 1:
                lib_name = '-lib "%s" %s' % (item[1], pre_str)
            else:
                if pre_str == "-vhd":
                    lib_name = '-lib "work" %s' % pre_str
                else:
                    lib_name = pre_str
            lse_source_files.append((lib_name, src_file))

        final_lines = list()

        old_lib_name = "", ""
        for i, (lib_name, src_file) in enumerate(lse_source_files):
            if not i:
                final_lines.append('%s "%s"' % (lib_name, src_file))
                old_lib_name = lib_name
            else:
                new_lib_name = lib_name
                if new_lib_name == old_lib_name:
                    final_lines.append(src_file)
                else:
                    final_lines.append('%s "%s"' % (lib_name, src_file))
                    old_lib_name = new_lib_name
        return os.linesep.join(final_lines)

    def get_lse_pre_str(self, src):
        #xTools.get_fext_lower(src)  return the lower postfix of the file
        fext = xTools.get_fext_lower(src)
        if fext in (".v", ".vo"):
            pre_str = "-ver"
        elif fext in (".vhd", ".vhdl", ".vho"):
            pre_str = "-vhd"
        elif fext in (".sdc",):
            pre_str = "-constraint"
        elif fext in (".edf", ".edn"):
            pre_str = "-input_edif"
        else:
            xTools.say_it("Warning. Unknown source file: %s" % src)
            pre_str = ""
        return pre_str

    def prepare_run_flow(self):
        '''
        Before run the ice flow, we need to:
        1. create a dictionary which will be used to write the template for flow
        2. create needed directory for flow, if the flow is not created, the flow cannot run smoothly
        :return:
        '''
        self.conf = self.flow_options.get("conf")
        same_ldf_dir = self.flow_options.get("same_ldf_dir")
        use_ice_prj = self.flow_options.get("use_ice_prj")
        self.kwargs = dict()
        if use_ice_prj:
            '''
            This is support ICEcube project format
            '''
            _project = self.flow_options.get("Project")
            implmnt_path = _project.get("Implementations")
            if not implmnt_path:
                xTools.say_it("-Error. Not found Implementations in project file")
                return 1
            self.kwargs["ProjectName"] =  _project.get("ProjectName", "DEF_PRJ_NAME")
            self.kwargs["implmnt_path"] = implmnt_path
            _src_files = _project.get("ProjectVFiles")
            _sdc_file = _project.get("ProjectCFiles")
            if _sdc_file:
                _sdc_file = xTools.get_relative_path(_sdc_file, same_ldf_dir)
            sdc_file = self.flow_options.get("sdc_file")
            ldc_file = self.flow_options.get("ldc_file")
            pcf_file = self.flow_options.get("pcf_file")
            if pcf_file:
               pcf_file = "-y"+xTools.get_relative_path(pcf_file, same_ldf_dir)
            else:
               pcf_file = ""
            if sdc_file:
                sdc_file = xTools.get_relative_path(sdc_file, same_ldf_dir)
            if ldc_file:
                ldc_file = xTools.get_relative_path(ldc_file, same_ldf_dir)

            _src_files = re.split(",", _src_files)
            _src_files = [re.sub("=\w+", "", item) for item in _src_files]
            _src_files = [[xTools.get_relative_path(item, same_ldf_dir)] for item in _src_files]
            #####################
            _implmnt = self.flow_options.get(implmnt_path)
            if not _implmnt:
                xTools.say_it("Error. Not found section: %s" % implmnt_path)
                return 1
            self.kwargs["DeviceFamily"] = _implmnt.get("DeviceFamily")
            self.kwargs["Device"] = _implmnt.get("Device")
            self.kwargs["DevicePackage"] = _implmnt.get("DevicePackage")
        else:
            _devkit = self.flow_options.get("devkit")
            _top_name = self.flow_options.get("top_module")
            _src_files = self.flow_options.get("src_files")
            ip_file = self.flow_options.get("ip")
            _sdc_file = ""
            for item in _src_files:
                if item.endswith(".sdc") or item.endswith(".SDC"):
                    _sdc_file = item
                    break
            sdc_file = self.flow_options.get("sdc_file")
            ldc_file = self.flow_options.get("ldc_file")
            pcf_file = self.flow_options.get("pcf_file")
            self.tb_file = self.flow_options.get("tb_file")
            if sdc_file:
                sdc_file = xTools.get_relative_path(sdc_file, same_ldf_dir)
            if ldc_file:
                ldc_file = xTools.get_relative_path(ldc_file, same_ldf_dir)
            if pcf_file:
                pcf_file = xTools.get_relative_path(pcf_file, same_ldf_dir)
                pcf_file = "-y"+pcf_file
            else:
                pcf_file = ""
            if ip_file:
                ip_file = '"-'+"i"+os.path.join(same_ldf_dir,ip_file.strip("\\").strip("/"))+'"'
            else:
                ip_file = ""
            self.kwargs["ip_file"] = ip_file.replace("\\","/")

            if self.tb_file:
                if type(self.tb_file) is list:
                    pass
                else:
                    self.tb_file = re.split(',', self.tb_file)
                for temp_tb in self.tb_file:
                    temp_tb = xTools.get_abs_path( temp_tb, same_ldf_dir)
                    self.tb_file = temp_tb
                    if self.get_my_trigger(self.tb_file) == "U1" and (not self.trigger_unit):
                        self.trigger_unit = "U1"
                    else:
                        try:
                            self.trigger_unit = self.get_my_trigger(self.tb_file)
                        except:
                            self.trigger_unit = "U1"
                    self.all_tb_files.append(temp_tb)

            else:
                self.trigger_unit = "U1"

            _src_files = [[xTools.get_relative_path(item.strip("/").strip("\\"), same_ldf_dir)] for item in _src_files]
            self.relpath_src_files = _src_files
            implmnt_path = _top_name + "_Implmnt"
            _implmnt = dict()
            self.kwargs["ProjectName"] = _top_name
            self.kwargs["implmnt_path"] = implmnt_path
            self.kwargs["source_files"] = _src_files
            _devkit_temp = _devkit.replace(",","")
            _devkit_temp = _devkit_temp.strip()
            # Shawn
            if self.flow_options.get("family"):
                self.kwargs["DeviceFamily"] = self.flow_options.get("family", "NoFamily")
                self.kwargs["Device"] = self.flow_options.get("device", "NoDevice")
                self.kwargs["DevicePackage"] = self.flow_options.get("package", "NoPackage")
            elif _devkit and _devkit_temp: #----------------------this may be a bug-------------
                _dev_list = re.split("\s*,\s*", _devkit)
                for id1,_dev_list_item in enumerate(_dev_list):
                    _dev_list_item = _dev_list_item.strip()
                    if id1 == 0:
                        if _dev_list_item:
                            self.kwargs["DeviceFamily"] = _dev_list_item
                        else:
                            if self.flow_options.get("family"):
                                self.kwargs["DeviceFamily"] = self.flow_options.get("family")
                            else:
                                xTools.say_it("Error: please specify family in the command or local inf file")
                                return 1
                    if id1 == 1:
                        if _dev_list_item:
                            self.kwargs["Device"] = _dev_list_item
                        else:
                             if self.flow_options.get("device"):
                                 self.kwargs["Device"] = self.flow_options.get("device")
                             else:
                                 xTools.say_it("Error: please specify device in the command or local inf file")
                                 return 1
                    if id1 == 2:
                        if _dev_list_item:
                            self.kwargs["DevicePackage"] = _dev_list_item
                        else:
                            if self.flow_options.get("package"):
                                self.kwargs["DevicePackage"] = self.flow_options.get("package")
                            else:
                                xTools.say_it("Error: please specify package in the command or local inf file")
                                return 1

                #self.kwargs["DeviceFamily"], self.kwargs["Device"], self.kwargs["DevicePackage"] = _dev_list
            else:
                xTools.say_it("Error. Not found devkit settings")
                return 1
        # --------------
        self.synthesis = self.flow_options.get("synthesis")
        if not self.synthesis:
            self.synthesis = "synplify"
        if self.synthesis == "synplify":
            _source_files = self.get_synp_source_files(_src_files)
            if sdc_file:
                sdc_file = "add_file -constraint %s" % sdc_file
            elif _sdc_file:
                sdc_file = "add_file -constraint %s" % _sdc_file
            else:
                sdc_file = ""
        else:
            _source_files = self.get_lse_source_files(_src_files)
            if ldc_file:
                sdc_file = "-sdc %s" % ldc_file
            elif sdc_file:
                sdc_file = "-sdc %s" % sdc_file
            else:
                sdc_file = ""
        self.kwargs["source_files"] = _source_files
        self.kwargs["sdc_file"] = sdc_file
        self.kwargs["pcf_file"] = pcf_file
        # --------------
        _goal = self.flow_options.get("goal")
        _frequency = self.flow_options.get("frequency")
        if not _frequency:
            if self.synthesis == "lse":
                if _goal == "area":
                   _frequency = 200
                elif _goal == "timing":
                    _frequency = 100
                else:
                    _frequency = 200
                    _goal = "area"
            else:# for synplify pro, _goal is not useful in the prj file.
                if _goal == "area":
                   _frequency = 1
                elif _goal == "timing":
                    _frequency = 100
                else:
                    _frequency = 100
                    _goal = ""
        _mixed_drivers = xTools.get_true(self.flow_options, "mixed_drivers")
        if _mixed_drivers:
            _mixed_drivers = "-resolve_mixed_drivers 1"  # For LSE
        else:
            _mixed_drivers = ""
        self.kwargs["mixed_drivers"] = _mixed_drivers
        if not _goal:
            _goal = "Timing"
        self.kwargs["goal"] = _goal
        self.kwargs["frequency"] = _frequency
        _DesignCell  = _implmnt.get("DesignCell")
        if not _DesignCell:
            _DesignCell = self.kwargs["ProjectName"]
        self.kwargs["DesignCell"] = _DesignCell
        self.kwargs["cwd"] = xTools.win2unix(os.getcwd())
        self.kwargs["ice_opt_path"] = self.ice_opt_path

        ice_map_file = os.path.join(self.conf, "ice_synthesis", "ice.map")
        # get_conf_options used to get the ice dev and lib file
        sts, ice_map_options = xTools.get_conf_options(ice_map_file, key_lower=False)
        if sts:
            return sts
        _family = ice_map_options.get(self.kwargs.get("DeviceFamily"))
        if not _family:
            xTools.say_it("Warning. Not support Family: %s" % self.kwargs.get("DeviceFamily"))
            return 1
        dev_lib = _family.get(self.kwargs.get("Device"))
        #print self.kwargs.get("Device")
        if not dev_lib:
            xTools.say_it("Warning. Not support %s" % self.kwargs.get("Device"))
            return 1
        dev, lib = re.split("\s*,\s*", dev_lib)
        self.kwargs["dev_file"] = os.path.abspath(os.path.join(self.ice_root_path, "sbt_backend", "devices", dev))
        self.kwargs["lib_file"] = xTools.win2unix(os.path.join(self.ice_root_path, "sbt_backend", "devices", lib))
        # create dir
        _sbt_path = os.path.join(os.getcwd(), implmnt_path, "sbt")
        for item in ("bitmap",
                     "gui",
                     "netlister",
                     "packer",
                     "placer",
                     "router",
                     "simulation_netlist",
                     "timer"):
            tt = os.path.join(_sbt_path, "outputs", item)
            xTools.wrap_md(tt, "ice results path")
        for item in ("netlist", "sds"):
            tt = os.path.join(_sbt_path, "outputs", item)
            xTools.wrap_md(tt, "ice results path")
        self.kwargs["sdc_translator"] = os.path.abspath(os.path.join(self.ice_root_path, r"sbt_backend/bin/sdc_translator.tcl"))

        info_line = "%s%s-%s" % (self.kwargs["DeviceFamily"], self.kwargs["Device"], self.kwargs["DevicePackage"])
        xTools.append_file(os.path.join(_sbt_path, "outputs", "device_info.txt"), info_line, False)

        ###For some case, need to copy special file from case directory to local directory
        special_files = self.flow_options.get("sim_mem","")
        if special_files:
            special_files_list = special_files.split(",")
            for temp_file in special_files_list:
                temp_file_abspath = os.path.join(self.flow_options.get("src_design",""),temp_file)
                if os.path.isfile(temp_file_abspath):
                    try:
                        shutil.copy(temp_file_abspath,self.flow_options.get("dst_design",""))
                    except:
                        print "Error:Cannot copy ",temp_file_abspath," to local path"
        ####


    def run_sim_verilog(self):
        '''self.synthesis
        1. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vlib.exe work
        2. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vlog.exe  ../LSE/rev_1/bank_hold_sbt.v
        3. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vlog.exe  +incdir+D:/ICE/regresion_win4/common +incdir+D:/ICE/adec_sim/new/bank_hold D:/ICE/adec_sim/new/bank_hold/tb.v
        4. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vsimsa.exe -do vsim_postrt.do
        5. copy all new created files to sim_verilog
        :return:
        '''
        try:
            shutil.rmtree("sim_verilog")
        except:
            pass
        sim_dir = "sim_verilog"
        os.makedirs(sim_dir)
        _recov = xTools.ChangeDir(sim_dir)
        iCEcube_path = self.flow_options.get("icecube_path")
        adec_bin = xTools.win2unix(os.path.join(iCEcube_path, "Aldec","Active-HDL","BIN"))
        adec_do = "aldec_veilog.do"
        do_lines = []
        do_lines.append("vlib  work \nvdel -lib work -all\nvlib work\n")
        sbt_v = ""
        for root,dirs,fs in os.walk(".."):
            for f in fs:
                if f.endswith("_sbt.v"):
                    sbt_v = xTools.win2unix(os.path.join(root,f))
        if not sbt_v:
            print "Error, can not get any _sbt.v from this design"
            return 1
        else:
            do_lines.append("vlog "+sbt_v+"\n")
            for temp_tb in self.all_tb_files:
                if temp_tb.endswith(".v") or temp_tb.endswith(".V"):
                    do_lines.append("vlog "+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" ../"+temp_tb+"\n")
                else:
                    do_lines.append("vcom "+" ../"+temp_tb+"\n")

            #do_lines.append("vsim  tb -t 1ns -l sim.log -L ovi_ice -lib work\nrun -all\nexit")
            do_lines.append("vsim  %s %s  -l sim.log -L ovi_ice -lib work\nrun -all\nexit"%(self.tb_top,self.sim_step))
            do_hand = file(adec_do,"w")
            for single_l in do_lines:
                do_hand.write(single_l)
            do_hand.close()
            add_lib_cfg()
            cmd4 = xTools.win2unix(os.path.join(adec_bin,"vsimsa.exe")) +" -do "+adec_do
            sts = xTools.run_command(cmd4, "../run.log", "run.time")
            if sts:
                return 1
            _recov.comeback()

    def run_sim_vhdl(self):
        #1. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vlib.exe work
        #2. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vcom.exe  D:/lscc/iCEcube2.2015.04Prod/sbt_backend/../vhdl/vcomponent_vital.vhd
        #3. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vcom.exe  ../LSE/rev_1/bank_hold_sbt.vhd
        #4. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vlog.exe  +incdir+D:/ICE/regresion_win4/common +incdir+D:/ICE/adec_sim/new/bank_hold D:/ICE/adec_sim/new/bank_hold/tb.v
        #5. D:/lscc/iCEcube2.2015.04Prod/Aldec/Active-HDL/BIN/vsimsa.exe -do vsim_vhdl.do
        #6. copy all new created files to sim_vhdl
        try:
            shutil.rmtree("sim_vhdl")
        except:
            pass
        sim_dir = "sim_vhdl"
        os.makedirs(sim_dir)
        _recov = xTools.ChangeDir(sim_dir)
        iCEcube_path = self.flow_options.get("icecube_path")
        adec_bin = xTools.win2unix(os.path.join(iCEcube_path, "Aldec","Active-HDL","BIN"))
        adec_do = "aldec_vhdl.do"
        do_lines = []
        do_lines.append("vlib  work \nvdel -lib work -all\nvlib work\n")
        sbt_v = ""

        for root,dirs,fs in os.walk(".."):
            for f in fs:
                if f.endswith("_sbt.vhd"):
                    sbt_v = xTools.win2unix(os.path.join(root,f))
        if not sbt_v:
            print "Error, can not get any _sbt.vhd from this design"
            return 1
        else :
            #do_lines.append("vcom "+ " "+xTools.win2unix(os.path.join(iCEcube_path,"vhdl","vcomponent_vital.vhd")+"\n"))
            do_lines.append("vcom "+sbt_v+"\n")
            for temp_tb in self.all_tb_files:
                if temp_tb.endswith(".v") or temp_tb.endswith(".V"):
                    do_lines.append("vlog "+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" ../"+temp_tb+"\n")
                else:
                    do_lines.append("vcom "+" ../"+temp_tb+"\n")

                #do_lines.append("vlog "+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+temp_tb+"\n")

            #do_lines.append("vsim  tb -t 1ns -l sim.log -L ice -lib work\nrun -all\nexit")
            do_lines.append("vsim  %s %s  -l sim.log -L ice -lib work\nrun -all\nexit"%(self.tb_top,self.sim_step))
            do_hand = file(adec_do,"w")
            for single_line in do_lines:
                do_hand.write(single_line)
            do_hand.close()
            add_lib_cfg()
            cmd4 = xTools.win2unix(os.path.join(adec_bin,"vsimsa.exe")) +" -do "+adec_do
            sts = xTools.run_command(cmd4, "../run.log", "run.time")
            if sts:
                return 1
            _recov.comeback()

    def model_sim_ICE_compile(self,V_LIB,init_lib_files=[],vhdl=0):
        '''
        As in the ice_lib directory, there just .v file
        :param V_LIB:
        :return:
        cd D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504Prod_VHDL_LIB
        vlib  work
        vdel -lib work -all
        vlib work

        vcom D:/lscc/iCEcube2.2015.04Prod/vhdl/vcomponent_vital.vhd
        vcom D:/lscc/iCEcube2.2015.04Prod/vhdl/sb_ice_syn_vital.vhd
        vcom D:/lscc/iCEcube2.2015.04Prod/vhdl/sb_ice_lc_vital.vhd
        q -f
        '''
        os.makedirs(V_LIB)
        V_LIB = xTools.win2unix(V_LIB)
        file_lock = file(os.path.join(V_LIB,"lock.file"),"w")
        file_lock.close()
        do_file = "init_lib.do"
        do_lines = ['cd '+V_LIB+"\n"]
        do_lines.append("vlib  work \nvdel -lib work -all\nvlib work\n")
        lib_files = []
        if init_lib_files:
            for single_f in init_lib_files:
                if single_f.endswith(".v"):
                    lib_files.append("vlog " +xTools.win2unix( single_f ) + "\n")
                elif single_f.endswith(".vhd"):
                    lib_files.append("vcom " +xTools.win2unix( single_f ) + "\n")
                else:
                    pass
        else:
            # This is the default ice lib files
            lib_dir = os.path.join(os.path.dirname(__file__),"..","..","conf","ice_lib")
            for root,dirs,fs in os.walk(lib_dir):
                for single_f in fs:
                    if single_f.endswith(".v"):
                        lib_files.append("vlog " +xTools.win2unix( os.path.join(root,single_f)) + "\n")
        do_lines += lib_files
        do_lines.append("q -f\n")
        do_hand = file(do_file,"w")
        for single_l in do_lines:
            #print single_l
            do_hand.write(single_l)
        do_hand.close()
        if(self.flow_options.get("sim_modelsim","") == True):
            modelsim_path = self.flow_options.get("modelsim_path","")
        else:
            modelsim_path = self.flow_options.get("questasim_path","")
        if not modelsim_path:
            print "Error: You shoudl specify modelsim install path"
            shutil.rmtree(V_LIB)
            return 1
        if not os.path.isdir(modelsim_path):
            print "Error: Can not find modelsim path:%s"%modelsim_path
            shutil.rmtree(V_LIB)
            return 1
        if platform.system() == "Windows":
            cmd1 =  xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) + " -do "+do_file +" -c -l ice_lib.log"
        else:
            cmd1 =  xTools.win2unix(os.path.join(modelsim_path,"vsim")) + " -do "+do_file +" -c -l ice_lib.log"
        sts = xTools.run_command(cmd1, "run.log", "run.time")
        if sts:
            shutil.rmtree(V_LIB)
            return 1
        os.remove(os.path.join(V_LIB,"lock.file"))

    def model_sim_lib_compile(self,V_LIB,vhdl=0):
        os.makedirs(V_LIB)
        V_LIB = xTools.win2unix(V_LIB)
        do_lines = ["cd "+V_LIB+"\n"]
        do_lines.append("vlib  work\nvdel -lib work -all \nvlib work\n")
        if vhdl == 0:
            #system("$toolpathHash{vlog} $ENV{SBT_DIR}/../verilog/sb_ice_lc.v >> vsim_lib_postrt.run");
            #system("$toolpathHash{vlog} $ENV{SBT_DIR}/../verilog/sb_ice_syn.v >> vsim_lib_postrt.run");
            #system("$toolpathHash{vlog} $ENV{SBT_DIR}/../verilog/ABIPTBS8.v >> vsim_lib_postrt.run");
            #system("$toolpathHash{vlog} $ENV{SBT_DIR}/../verilog/ABIWTCZ4.v >> vsim_lib_postrt.run");
            lib_files = ["sb_ice_lc.v","sb_ice_syn.v","ABIPTBS8.v","ABIWTCZ4.v"]
        else:
            #system("$toolpathHash{vcom} $ENV{SBT_DIR}/../vhdl/vcomponent_vital.vhd >> vsim_lib_vhdl.run");
            #system("$toolpathHash{vcom} $ENV{SBT_DIR}/../vhdl/sb_ice_syn_vital.vhd >> vsim_lib_vhdl.run");
            #system("$toolpathHash{vcom} $ENV{SBT_DIR}/../vhdl/sb_ice_lc_vital.vhd >> vsim_lib_vhdl.run");
            lib_files = ["vcomponent_vital.vhd","sb_ice_syn_vital.vhd","sb_ice_lc_vital.vhd"]
        file_lock = file(os.path.join(V_LIB,"lock.file"),"w")
        file_lock.close()
        #/tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlib    work
        if(self.flow_options.get("sim_modelsim","") == True):
            modelsim_path = self.flow_options.get("modelsim_path","")
        else:
            modelsim_path = self.flow_options.get("questasim_path","")
        ice_build = self.flow_options.get("icecube_path")
        if not modelsim_path:
            print "Error: You shoudl specify modelsim install path"
            shutil.rmtree(V_LIB)
            return 1
        if not os.path.isdir(modelsim_path):
            print "Error: Can not find modelsim path:%s"%modelsim_path
            shutil.rmtree(V_LIB)
            return 1
        if vhdl == 0:
            for lib in lib_files:
                lib = xTools.win2unix(os.path.join(ice_build,"verilog",lib))
                do_lines.append("vlog "+lib+"\n")
        else:
            vhdl_do = "vhdl_lib.do"
            for lib in lib_files:
                lib = xTools.win2unix(os.path.join(ice_build,"vhdl",lib))
                do_lines.append("vcom "+lib+"\n")
        do_lines.append("q -f\n")
        do_file = "ICE_lib.do"
        file_hand = file(do_file,"w")
        for single_l in do_lines:
            file_hand.write(single_l)
        file_hand.close()
        if platform.system() == "Windows":
            cmd = xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) + " -do " +do_file+" -c -l ICE_lib.log"
        else:
            cmd = xTools.win2unix(os.path.join(modelsim_path,"vsim")) + " -do " +do_file+" -c -l ICE_lib.log"
        sts = xTools.run_command(cmd, "run.log", "run.time")
        if sts:
            shutil.rmtree(V_LIB)
            return 1
        #for item in os.listdir("work"):
        #    shutil.move(os.path.join("work",item),V_LIB)
        #shutil.rmtree("work")
        os.remove(os.path.join(V_LIB,"lock.file"))


    def run_sim_verilog_modelsim(self):
        '''
        At here, the script will run verilog simulation with modelsim
        1. check whether the lib has been compiled, or the script will compile the lib first.
            the lib stored under trunk/conf/sim/ICE_build/V_LIB
        2. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlib    work
        3. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlog     ../SYNTH/rev_1/bank_hold_sbt.v
        4. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlog    +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/testcases/Integtation/bank_hold /lsh/sw/qa/qa_store/qa-test/lyan/icecube/testcases/Integtation/bank_hold/tb.v
        5. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vsim    -t 1ns -c -novopt -do vsim_postrt.do -l sim.log -L /lsh/sw/qa/qa_store/qa-test/lyan/icecube/run/8/s_s/run/LIB_POSTRT tb

        '''
        try:
            shutil.rmtree("modelsim_verilog")
        except:
            pass
        sim_dir = "modelsim_verilog"
        os.makedirs(sim_dir)
        _recov = xTools.ChangeDir(sim_dir)
        ice_build = os.path.basename( self.flow_options.get("icecube_path"))
        ICE_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",ice_build)+"_ICE_LIB")
        while True:
            if os.path.isdir(ICE_LIB) and os.path.isfile(os.path.join(ICE_LIB,"lock.file")):
                print "Please wait, the simulation lib is creating now"
                time.sleep(10)
            elif os.path.isdir(ICE_LIB) and (not os.path.isfile(os.path.join(ICE_LIB,"lock.file")) ):
                time.sleep(1)
                break
            else:
                if self.model_sim_ICE_compile(ICE_LIB):
                    print "Error: can not comiple lib "
                    return 1
                break
        V_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",ice_build)+"_V_LIB")
        while True:
            if os.path.isdir(V_LIB) and os.path.isfile(os.path.join(V_LIB,"lock.file")):
                time.sleep(10)
            elif os.path.isdir(V_LIB) and (not os.path.isfile(os.path.join(V_LIB,"lock.file")) ):
                time.sleep(1)
                break
            else:
                if self.model_sim_lib_compile(V_LIB):
                    print "Error: can not comiple lib "
                    return 1
                break
        do_lines =["vlib  work \n","vdel -lib work -all\n","vlib work\n"]
        if(self.flow_options.get("sim_modelsim","") == True):
            modelsim_path = self.flow_options.get("modelsim_path","")
        else:
            modelsim_path = self.flow_options.get("questasim_path","")
        sbt_v = ''
        for root,dirs,fs in os.walk(".."):
            for f in fs:
                if f.endswith("_sbt.v"):
                    sbt_v = xTools.win2unix(os.path.join(root,f))
        if not sbt_v:
            print "Error, Can not find _sbt.v file"
            return 1
        do_lines.append("vlog "+sbt_v+"\n")
        for temp_tb in self.all_tb_files:
            if temp_tb.endswith(".v") or temp_tb.endswith(".V"):
                do_lines.append("vlog"+" "+"+incdir+"+xTools.win2unix(ICE_LIB)+"/work"+ " "+"+incdir+"+xTools.win2unix(V_LIB)+"/work"+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+temp_tb +"\n")
            else:
                #do_lines.append("vcom"+" "+"+"+xTools.win2unix(ICE_LIB)+"/work"+ " "+"+incdir+"+xTools.win2unix(V_LIB)+"/work"+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+self.tb_file +"\n")
                do_lines.append("vcom"+" "+temp_tb +"\n")

        # This is the old:do_lines.append("vlog"+" "+"+incdir+"+xTools.win2unix(ICE_LIB)+"/work"+ " "+"+incdir+"+xTools.win2unix(V_LIB)+"/work"+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+self.tb_file +"\n")
        #do_lines.append("vsim -t 1ns -c -novopt  -l sim.log -L "+xTools.win2unix(V_LIB)+"/work tb\n")
        do_lines.append("vsim %s %s -c -novopt  -l sim.log -L "%(self.tb_top,self.sim_step)+xTools.win2unix(V_LIB)+"/work tb\n")
        top_module = self.flow_options.get("top_module")
        do_lines.append("run -all\nwrite list %s.lst\nq -f\n"%top_module)

        do_hand = file("vsim_verilog.do","w")
        for single_line in do_lines:
            do_hand.write(single_line)
        do_hand.close()
        if platform.system() == "Windows":
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) + \
               " -do vsim_verilog.do -c -l vsim_verilog.log  "
        else:
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim")) + \
               " -do vsim_verilog.do -c -l vsim_verilog.log  "
        sts = xTools.run_command(cmd4, "../run.log", "run.time")
        if sts:
            return 1
        _recov.comeback()

    def run_sim_vhdl_modelsim(self):
        '''
        At here, the script will run verilog simulation with modelsim
        1. check whether the lib has been compiled, or the script will compile the lib first.
            the lib stored under trunk/conf/sim/ICE_build/V_LIB
        2. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlib    work
        2.1 /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlib ice
        2.2 /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vmap ice /lsh/sw/qa/qa_store/qa-test/lyan/icecube/run/8/s_s/run/LIB_VHDL
        3. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vcom    ../SYNTH/rev_1/bank_hold_sbt.vhd
        4. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vlog      +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/testcases/Integtation/bank_hold /lsh/sw/qa/qa_store/qa-test/lyan/icecube/testcases/Integtation/bank_hold/tb.v
        5. /tools/dist/mentor/ams/ams2011.1/questasim/v10.0b/bin/vsim   -t 1ns -c -novopt -do vsim_vhdl.do -l sim.log -L  /lsh/sw/qa/qa_store/qa-test/lyan/icecube/run/8/s_s/run/LIB_VHDL tb

        '''
        try:
            shutil.rmtree("modelsim_vhdl")
        except:
            pass
        sim_dir = "modelsim_vhdl"
        os.makedirs(sim_dir)
        _recov = xTools.ChangeDir(sim_dir)
        ice_build = os.path.basename( self.flow_options.get("icecube_path"))
        ICE_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",ice_build)+"_ICE_LIB")
        ICE_LIB = xTools.win2unix(ICE_LIB)
        while True:
            if os.path.isdir(ICE_LIB) and os.path.isfile(os.path.join(ICE_LIB,"lock.file")):
                time.sleep(10)
            elif os.path.isdir(ICE_LIB) and (not os.path.isfile(os.path.join(ICE_LIB,"lock.file")) ):
                time.sleep(1)
                break
            else:
                if self.model_sim_ICE_compile(ICE_LIB):
                    print "Error: can not comiple lib "
                    return 1
                break
        V_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",ice_build)+"_VHDL_LIB")
        V_LIB = xTools.win2unix(V_LIB)
        while True:
            if os.path.isdir(V_LIB) and os.path.isfile(os.path.join(V_LIB,"lock.file")):
                time.sleep(10)
            elif os.path.isdir(V_LIB) and (not os.path.isfile(os.path.join(V_LIB,"lock.file")) ):
                time.sleep(1)
                break
            else:
                if self.model_sim_lib_compile(V_LIB,1):
                    print "Error: can not comiple lib "
                    return 1
                break
        if(self.flow_options.get("sim_modelsim","") == True):
            modelsim_path = self.flow_options.get("modelsim_path","")
        else:
            modelsim_path = self.flow_options.get("questasim_path","")

        sbt_v = ''
        for root,dirs,fs in os.walk(".."):
            for f in fs:
                if f.endswith("_sbt.vhd"):
                    sbt_v = xTools.win2unix(os.path.join(root,f))
        if not sbt_v:
            print "Error, Can not find _sbt.vhd file"
            return 1
        '''
        vlib  work
        vdel -lib work -all
        vlib work

        vmap ice D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504Prod_VHDL_LIB/work

        vcom -work D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504Prod_VHDL_LIB/work -refresh

        vcom  D:/ICE/adec_sim/new/job/bank_hold/_scratch/bank_hold_Implmnt/sbt/outputs/simulation_netlist/bank_hold_sbt.vhd

        vlog +incdir+D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504_ICE_LIB/work +incdir+D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504_VHDL_LIB/work +incdir+D:/ICE/adec_sim/new/bank_hold D:/ICE/adec_sim/new/bank_hold/tb.v
        vsim -t 1ns -c -novopt  -l sim.log -L D:/Users/DEV/ICEcube/svn/trunk/conf/iCEcube2201504_VHDL_LIB/work tb
        #vsim tb -L ice -L work -l sim.log -novopt
        #vsim work.tb -L ice -L work -l sim.log -novopt
        run -all
        q -f
        '''
        do_lines =["vlib  work \n","vdel -lib work -all\n","vlib work\n"]
        do_lines.append("vmap ice "+V_LIB+"/work"+"\n")
        do_lines.append("vcom -work "+V_LIB+"/work"+" -refresh\n")
        do_lines.append("vcom "+sbt_v+"\n")
        #self.tb_file = xTools.win2unix( os.path.abspath(self.tb_file) )
        for temp_tb in self.all_tb_files:
            if temp_tb.endswith(".v") or temp_tb.endswith(".V"):
                do_lines.append("vlog"+" "+"+incdir+"+xTools.win2unix(ICE_LIB)+"/work"+ " "+"+incdir+"+xTools.win2unix(V_LIB)+"/work"+" "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+temp_tb +"\n")
            else:
                do_lines.append("vcom"+" "+temp_tb +"\n")

        #do_lines.append("vlog"+" "+"+incdir+"+ICE_LIB+ "/work "+"+incdir+"+V_LIB+"/work "+"+incdir+"+self.flow_options.get("same_ldf_dir")+" "+self.tb_file +"\n")
        #do_lines.append("vsim -t 1ns -c -novopt  -l sim.log -L "+V_LIB+"/work tb\n")
        do_lines.append("vsim %s %s -c -novopt  -l sim.log -L "%(self.tb_top,self.sim_step)+V_LIB+"/work tb\n")
        top_module = self.flow_options.get("top_module")
        do_lines.append("run -all\nwrite list %s.lst\nq -f\n"%top_module)
        #do_lines.append("run -all\nq -f\n")
        do_hand =  file("vhdl_modelsim.do","w")
        for single_line in do_lines:
            do_hand.write(single_line)
        do_hand.close()
        if platform.system() == "Windows":
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) + \
               " -do vhdl_modelsim.do -c -l vhdl_modelsim.log  "
        else:
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim")) + \
               " -do vhdl_modelsim.do -c -l vhdl_modelsim.log  "
        sts = xTools.run_command(cmd4, "../run.log", "run.time")
        if sts:
            return 1
        _recov.comeback()

    @staticmethod
    def read_pcf_log(log_file=''):#used for DMS
        all_lines = file(log_file).readlines()
        # for each line, it will be:INPUT  reset     location (8, 31, 0)     D7
        line_pattern = re.compile("(INPUT|OUTPUT|INOUT)\s+(\S+)\s+location\s+\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)")
        io_dict = {}
        for line in all_lines:
            line = line.strip()
            line_search = line_pattern.search(line)
            if not line_search:
                print 'Error: the line format is not right, pls check'
                return -1
            else:
                io_type = line_search.group(1)
                io_name = line_search.group(2)
                io_x = line_search.group(3)
                io_y = line_search.group(4)
                io_z = line_search.group(5)
                io_dict[io_name] = [io_type,io_x,io_y,io_z]
        return io_dict
    @staticmethod
    def read_init_io(init_io_file=''):#used for DMS
        all_lines = file(init_io_file).readlines()
        #for each line, it should be:(5, 0, 0) uio_bbank[0]
        line_pattern = re.compile("\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\)\s*(\S+)")
        init_io_dict = {}
        for line in all_lines:
            line = line.strip()
            if not line:
                continue
            line_search = line_pattern.search(line)
            if line_search:
                #init_io_dict[line_search.group(4)] = [line_search.group(1),line_search.group(2),line_search.group(3)]
                init_io_dict[line_search.group(1)+"_"+line_search.group(2)+"_"+line_search.group(3)] = line_search.group(4)
        return init_io_dict
    @staticmethod
    def write_io_v(io_dict={},init_io_dict={},seperate=0):#used for DMS
        io_lines = []
        for io_name,io_profile in io_dict.items():
            io_type = io_profile[0]
            io_x = io_profile[1]
            io_y = io_profile[2]
            io_z = io_profile[3]
            init_io_name = init_io_dict.get(io_x+"_"+io_y+"_"+io_z,"")
            temp_line = ''
            if not init_io_name:
                print "Error: can not get init io name from init file:",io_x,io_y,io_z;
                return -1
            if io_type.lower() == "input":
                temp_line = "assign "+init_io_name+" = "+io_name+";\n"
            elif io_type.lower() == "output":
                temp_line = "assign "+io_name+" = "+init_io_name+";\n"
            elif io_type.lower() == "inout":
                temp_line = "via via_"+re.sub("\W","_",io_name)+"("+init_io_name+","+io_name+");\n"
            else:
                print "Error: Can not support type:",io_type
                return -1
            io_lines.append(temp_line)
        if seperate:
            temp_file_hand = file("io.v","w")
            temp_file_hand.writelines(io_lines)
            temp_file_hand.close()
        return io_lines
    def add_sim_lines(self,lib_dir,src_dir,LIB,top_tb="tb"):
        '''
        This function should be done before run dffess.do file
        4.  vlib  work
        5.  vlog/vcom  Verilog/vhdl files
        6.  for TB file, vlog/vcom should +define+CHIP +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common/iceth4k
        7.  vlog  +define+CHIP /lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common/iceth4k/via.v
        8.  vsim  -64 +nowarnTFMPC -novopt -c -do vsim_DMS.do -l sim.log -L  /lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common/LIB_iceth4k_64 tb
        :return:
        '''
        all_lines = []
        LIB = xTools.win2unix(LIB)
        all_lines.append('vlib  work\nvdel -lib work -all\nvlib work\n')
        for source_f in self.relpath_src_files:
            source_f = source_f[-1]
            if source_f.endswith(".v") or source_f.endswith(".V"):
                all_lines.append("vlog"+" "+xTools.win2unix(source_f)+"\n")
            else:
                all_lines.append("vcom"+" "+xTools.win2unix(source_f) +"\n")
        for tb in self.all_tb_files: #### At here, we need to change the directory
            #vlog  +define+CHIP +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common/thunderplus +incdir+/lsh/sw/qa/qa_store/qa-test/lyan/icecube/dms_case/counter_thunder_plus /lsh/sw/qa/qa_store/qa-test/lyan/icecube/dms_case/counter_thunder_plus/tb_counter.v
            if tb.endswith(".v") or tb.endswith(".V"):
                temp_line = "vlog  +define+CHIP +incdir+"+xTools.win2unix(lib_dir)
                temp_line += " +incdir+"+xTools.win2unix(src_dir)+" "
                temp_line += tb
                all_lines.append(temp_line+"\n")
            else:
                temp_line = "vcom  +define+CHIP +incdir+"+xTools.win2unix(lib_dir)
                temp_line += " +incdir+"+xTools.win2unix(src_dir)+" "
                temp_line += tb
                all_lines.append(temp_line+"\n")
        all_lines.append("vlog  +define+CHIP "+xTools.win2unix(lib_dir)+"/via.v \n")
        file_hand = file("vsim_DMS_pre.do","w")
        file_hand.writelines(all_lines)
        file_hand.close()
        file_hand = file("vsim_DMS.do","w")
        file_hand.write("do vsim_DMS_pre.do\n")
        if self.dms_32 and platform.system().lower().find("window")!= -1:
            sim_line = "vsim  +nowarnTFMPC -novopt -c  -l sim2.log -L "+ xTools.win2unix(LIB)+" "+top_tb+"\n"
        else:
            sim_line = "vsim  +nowarnTFMPC -novopt -c  -l sim2.log -L "+ xTools.win2unix(LIB)+" "+top_tb+"\n"
        file_hand.write(sim_line)
        file_hand.write("do dffess.do\nrun -all\nq -f")
        file_hand.close()
    def downloadLib(self,lib_name):
        '''
        This function used to get the simulation downlaod file from svn
        '''
        try:
            SVN_DIR = "http://lshlabd0011/icecube2/trunk/general/DMS/DMSLib"
            lib_name_dir = os.path.join(SVN_DIR,lib_name)
            lib_name_dir = re.sub(r"\\","/",lib_name_dir)
            V_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf","ICEcubeLibDMS",lib_name)
            try:
                os.makedirs(V_LIB)
            except:
                print "Error: Can not mkdir ",V_LIB
                return 1
            file_lock = file(os.path.join(V_LIB,"lock.file"),"w")
            file_lock.close()
            cmd = "svn export "+lib_name_dir+" "+V_LIB +" --force --username=guest --password=welcome --no-auth-cache --non-interactive"
            print cmd
            os.system(cmd)
            os.remove(os.path.join(V_LIB,"lock.file"))
            if os.path.isdir(V_LIB):
                return 0
            else:
                return 1
        except:
            V_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf","ICEcubeLibDMS",lib_name)
            shutil.rmtree(V_LIB)

    def run_DMS(self):
        '''
        To run DMS, the full icecube flow should be run(to bitstream)
        1. write io.v
        2. write do file
        3. run do file
        :return:
        '''
        try:
            shutil.rmtree("DMS")
        except:
            pass
        old_file_list = os.listdir(os.getcwd())
        pcf_file = ""
        for root,dirs,fs in os.walk(os.getcwd()):
            if not root.endswith("packer"):
                continue
            for f in fs:
                if f.endswith("io_pcf.log"):
                    pcf_file = os.path.join(root,f)
                    break
        if not pcf_file:
            print "Error: Can not find pcf file for:",os.getcwd()
            return -1
        io_dict = self.read_pcf_log(pcf_file)
        '''
        ice8p   iCE40-8K
        ice1p   iCE40-1K
        ice384p iCE40-384
        ice3p5  iCE40LM
        iceth4k iCE40LP
        thunderbolt iCE40UL
        thunderplus iCE40UP
        iCE5LP/thunder iceth4k
        '''
        lib_dict = {"iCE40-LP8K":"ice8p","iCE40-LP1K":"ice1p","iCE40-LP384":"ice384p","iCE40LM":"ice3p5",
                    "iCE40LP":"iceth4k","iCE40UL":"thunderbolt","iCE40UP":"thunderplus","iCE5LP":"iceth4k"
                    }
        family = self.kwargs.get("DeviceFamily","")
        lib_dir = lib_dict.get(family,"")
        if not lib_dir:
            device = self.kwargs.get("Device","")
            lib_dir = lib_dict.get(family+"-"+device,"")
            if not lib_dict:
                print "Error: can not find corresponding lib name:",family,lib_dir
                return -1
        full_lib_dir = os.path.join(os.path.dirname(__file__),"..","..","conf","ICEcubeLibDMS",lib_dir)
        init_io_file = os.path.join(full_lib_dir,"IO_"+lib_dir+".txt")
        if not os.path.isfile(init_io_file):
            print "Error: Can not find init IO file:",init_io_file
            return -1
        init_io_dict = self.read_init_io(init_io_file)
        io_lines = self.write_io_v(io_dict,init_io_dict)
        if type(io_lines) is list:
            pass
        else:
            return -1
        file_hand = file("io.v","w")
        file_hand.writelines(io_lines)
        file_hand.close()

        cbit_file = os.path.join(full_lib_dir,"cbit_conv2mti_"+lib_dir+".txt") #"cbit_conv2mti_thunderplus.txt"
        glb_dir = os.getcwd()
        glb_file = ""
        for temp_root,ds,fs in os.walk(glb_dir):
            for f in fs:
                if f.endswith("_glb.txt"):
                    glb_file = os.path.join(temp_root,f)
                    break
        if not glb_file:
            print "Error: can not find glb file under:",glb_dir
            return -1
        #glb_file = "counter_bitmap_glb.txt"
        cmd = "awk -f "+cbit_file+" "+glb_file + ">dffess.do"
        bat_file_hand = file("produce_dffess.py","w")
        io_bat_line = "import sys,os,re\n"
        io_bat_line += "sys.path.append( "+'"'+xTools.win2unix( os.path.dirname(__file__) )+'"'+" )\n"
        io_bat_line += "import "+os.path.basename(__file__).replace(".py","")+"\n"
        io_bat_line += "io_dict="+os.path.basename(__file__).replace(".py","")+".Run_iCEcube."+"read_pcf_log(r"+'"'+pcf_file+'"'+")\n"
        io_bat_line += "init_io_dict="+os.path.basename(__file__).replace(".py","")+".Run_iCEcube."+"read_init_io(r"+'"'+init_io_file+'"'+")\n"
        io_bat_line += os.path.basename(__file__).replace(".py","")+".Run_iCEcube."+"write_io_v(io_dict,init_io_dict,1)\n"
        bat_file_hand.write(io_bat_line)
        bat_file_hand.write("os.system(r"+'"'+cmd+'"'+")\n")
        bat_file_hand.close()
        os.system(cmd)
        if os.path.isfile("dffess.do"):
            pass
        else:
            print "Error: Can not find dffess.do"
            return -1
        rritrim_file = os.path.join(full_lib_dir,"..","public","rritrim.txt")
        if os.path.isfile(rritrim_file):
            pass
        else:
            print "Error: Can not find file:",rritrim_file
            return -1
        shutil.copyfile(rritrim_file,os.path.basename(rritrim_file))
        if(self.flow_options.get("sim_modelsim","") == True):
            modelsim_path = self.flow_options.get("modelsim_path","")
        elif(self.flow_options.get("sim_questasim","") == True):
            modelsim_path = self.flow_options.get("questasim_path","")
        else:
            modelsim_path = " "
        if not modelsim_path:
            print "Error: You shoudl specify modelsim install path"
            return 1
        if not os.path.isdir(modelsim_path):
            print "Error: Can not find modelsim path:%s"%modelsim_path
            return 1
        #modelsim_path = self.flow_options.get("modelsim_path","")
        if self.dms_32:
            LIB = os.path.join(os.path.dirname(__file__),"..","..","conf","ICEcubeLibDMS","LIB_"+lib_dir+"_32")
        else:
            LIB = os.path.join(os.path.dirname(__file__),"..","..","conf","ICEcubeLibDMS","LIB_"+lib_dir)
        flag = 0
        while True:
            if os.path.isdir(LIB) and os.path.isfile(os.path.join(LIB,"lock.file")):
                time.sleep(10)
            elif os.path.isdir(LIB) and (not os.path.isfile(os.path.join(LIB,"lock.file")) ):
                time.sleep(1)
                break
            else:
                if self.dms_32:
                    LIB_dir = "LIB_"+lib_dir+"_32"
                else:
                    LIB_dir = "LIB_"+lib_dir
                if self.downloadLib(LIB_dir):
                    print "Error: can not download lib "
                    return 1
                break
            flag += 1
            if flag > 10*6*3:
                break
        self.add_sim_lines(full_lib_dir,self.flow_options.get("same_ldf_dir"),LIB,self.tb_top)
        #8. vsim  -64 +nowarnTFMPC -novopt -c -do vsim_DMS.do -l sim.log -L   \
        # /lsh/sw/qa/qa_store/qa-test/lyan/icecube/regression_flow/common/LIB_iceth4k_64 tb
        if self.dms_32:
            bit_32_64 = ''
        else:
            if  platform.system().lower().find("window") == -1:
                bit_32_64 = '-64'
            else:
                bit_32_64 = ' '
        if platform.system() == "Windows":
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) + \
               " "+bit_32_64+" -do vsim_DMS.do -c -l vsim_DMS.log  "

        else:
            cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim")) + \
               " "+bit_32_64+" -do vsim_DMS.do -c -l vsim_DMS.log  "
        sts = xTools.run_command(cmd4, "run.log", "run.time")
        if sts:
            return 1
        new_file_list = os.listdir(os.getcwd())
        try:
            os.makedirs("DMS")
        except:
            pass
        for f_d in new_file_list:
            if f_d in old_file_list:
                pass
            else:
                shutil.move(f_d,"DMS")

    def get_my_trigger(self,a_file):
        p1 = re.compile("(uut)", re.I)
        p2 = re.compile("\s(u1)", re.I)
        if os.path.isfile(a_file):
            pass
        else:
            return ""
        for line in open(a_file):
            line = line.strip()
            m1 = p1.search(line)
            m2 = p2.search(line)
            if m1:
                return m1.group(1)
            elif m2:
                return m2.group(1)
        return "U1"
    def post_sim(self,modelsim_tool='',step='post_syn',synthesis_tool='lse'):
        '''
        modelsim: the default is aldec, you can specify modelsim /questim here
        step: the default is post_syn. you can alo specify post_par, post_map here
            but for most map, need sdc file. this is not very use for ice. just ingore it.
        synthesis_tool: you can specify lse/synplify
        entry_type: you can specif verilog or vhdl
        0: we need to make sure the detail input of the case.(which synthesis)
        1. write do file
        2. copy all new created files to sim_verilog
        :return:
        '''
        bat_script = '''vlib work
%(add_src_files)s
%(add_post_sim_line)s
%(add_tb_files)s
radix -hex
vsim +access +r -asdb %(design)s.asdb work.%(testbench)s -L %(sname)s -t 1ns
trace -ports %(trigger_unit)s/*
run %(sim_runtime)s
asdb2ctf -writenew off -strobe -time 5ns -deltacolumn off -radix hex %(design)s.asdb %(design)s_post.lst
'''
        bat_script_modelsim = '''
onerror {quit -f}
vlib work
%(add_vmap_line)s
%(add_src_files)s
%(add_post_sim_line)s
%(add_tb_files)s
%(add_vsim_line)s
add list -nodelta -hex -notrigger *
configure list -usestrobe 1
configure list -strobestart {50000 ps} -strobeperiod {5 ns}
run %(sim_runtime)s
write list %(design)s_post.lst
quit -f
'''
        top_module = self.flow_options.get("top_module")
        if modelsim_tool:
            bat_script = bat_script_modelsim
        else:
            pass
        for sim_flag,language in enumerate([self.sim_verilog,self.sim_vhd]):
            working_directory_name = step
            if not language:
                continue
            else:
               if sim_flag:
                   working_directory_name = "vhdl_"+working_directory_name
               else:
                   working_directory_name = "verilog_"+working_directory_name
            try:
                shutil.rmtree(working_directory_name)
            except:
                pass
            os.makedirs(working_directory_name)
            _recov = xTools.ChangeDir(working_directory_name)
            iCEcube_path = self.flow_options.get("icecube_path")
            adec_bin = xTools.win2unix(os.path.join(iCEcube_path, "Aldec","Active-HDL","BIN"))
            prim_v_list = []
            if step == "post_syn":
                for root,dirs,fs in os.walk(".."):
                    for f in fs:
                        if f.endswith("_prim.v") or f.endswith(".vm") or f.endswith(".vhm"):
                            prim_v_list.append(xTools.win2unix(os.path.join(root,f)) )
                if not prim_v_list:
                    print "Error, can not get any _prim.v/vm/vhm from this design"
                    return 1
            else:
                post_sim_line = ''
                if step == "post_syn":
                    if synthesis_tool != "lse":
                        if sim_flag:#vhdl
                            for prim_v in prim_v_list:
                                if prim_v.endswith(".vhm"):
                                    post_sim_line = "vcom "+prim_v
                                    break

                        else:#verilog
                            for prim_v in prim_v_list:
                                if prim_v.endswith(".vm"):
                                    post_sim_line = "vlog "+prim_v
                                    break
                    else:
                       for prim_v in prim_v_list:
                                if prim_v.endswith("_prim.v"):
                                    post_sim_line = "vlog "+prim_v
                                    break
                elif step == "post_par":
                    if not sim_flag:#verilog
                        sbt_v = ''
                        for root,dirs,fs in os.walk(".."):
                            for f in fs:
                                if f.endswith("_sbt.v"):
                                    sbt_v = xTools.win2unix(os.path.join(root,f))
                                    post_sim_line = "vlog "+sbt_v
                                    break
                        if not sbt_v:
                            print "Error, Can not find _sbt.v file"
                            return 1
                    else:#vhd
                        sbt_vhd = ''
                        for root,dirs,fs in os.walk(".."):
                            for f in fs:
                                if f.endswith("_sbt.vhd"):
                                    sbt_vhd = xTools.win2unix(os.path.join(root,f))
                                    post_sim_line = "vcom "+sbt_vhd
                                    break
                        if not sbt_vhd:
                            print "Error, Can not find _sbt.vhd file"
                            return 1
                if not post_sim_line:
                    print "Error, can not get any _prim.v/vm/vhm from this design, please check"
                    return 1
                top_module = self.flow_options.get("top_module")
                if self.flow_options.get("sim_time"):
                    if(self.flow_options.get("sim_time") == "all"):
                        sim_runtime = "-all"
                    else:
                        try:
                            sim_runtime = int(self.flow_options.get("sim_time"))
                            sim_runtime = str(sim_runtime)+" us"
                        except:
                            sim_runtime = "10 us"
                else:
                    sim_runtime = 10
                    sim_runtime = str(sim_runtime)+" us"
                src_file_lines =''
                tb_file_lines = ''
                if not self.all_tb_files:
                    if self.tb_file.endswith(".v") or self.tb_file.endswith(".V"):
                        tb_file_lines +=  "vlog +incdir+"+xTools.win2unix(self.flow_options.get("same_ldf_dir")) +" "+ self.tb_file+"\n"
                    else:
                        tb_file_lines +=  "vcom "+ self.tb_file+"\n"
                else:
                    for temp_tb in self.all_tb_files:
                        if temp_tb.endswith(".v") or temp_tb.endswith(".V"):
                            tb_file_lines +=  "vlog +incdir+"+xTools.win2unix(self.flow_options.get("same_ldf_dir"))+" "+ temp_tb+"\n"
                        else:
                            tb_file_lines +=  "vcom "+ temp_tb+"\n"
                sname = "ovi_ice"
                if sim_flag:#vhdl
                    sname = "ice"
                if not modelsim_tool:
                    do_file = "run_activehdl.do"
                    add_lib_cfg()
                    cmd4 = xTools.win2unix(os.path.join(adec_bin,"vsimsa.exe")) +" -do "+do_file
                    add_vsim_line = ''
                    add_vmap_line = ''
                else:
                    do_file = "run_modelsim.do"
                    #modelsim_path = modelsim_tool
                    if(self.flow_options.get("sim_modelsim","") == True):
                        modelsim_path = self.flow_options.get("modelsim_path","")
                    else:
                        modelsim_path = self.flow_options.get("questasim_path","")
                    if platform.system() == "Windows":
                        cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim.exe")) +" -c -do "+do_file
                    else:
                        cmd4 = xTools.win2unix(os.path.join(modelsim_path,"vsim"))  +" -c -do "+do_file
                    modelsim_build_info = re.sub("\W","",modelsim_path)
                    if not sim_flag:
                        tool_ICE_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",modelsim_build_info)+"_ICE_LIB_Verilog")
                    else:
                        tool_ICE_LIB = os.path.join(os.path.dirname(__file__),"..","..","conf",re.sub("\W","",modelsim_build_info)+"_ICE_LIB_VHD")
                    while True:
                        if os.path.isdir(tool_ICE_LIB) and os.path.isfile(os.path.join(tool_ICE_LIB,"lock.file")):
                            print "Please wait, the simulation lib is creating now"
                            time.sleep(10)
                        elif os.path.isdir(tool_ICE_LIB) and (not os.path.isfile(os.path.join(tool_ICE_LIB,"lock.file")) ):
                            time.sleep(1)
                            break
                        else:
                            ice_build = self.flow_options.get("icecube_path")
                            ice_build_verilog = xTools.win2unix(os.path.join(ice_build,"verilog"))
                            ice_build_vhd = xTools.win2unix(os.path.join(ice_build,"vhdl"))
                            if not sim_flag:#verilog
                                tool_lib_files = [xTools.win2unix(os.path.join(ice_build_verilog,lib_f)) for lib_f in [
                                            "ABIPTBS8.v","ABIWTCZ4.v","sb_ice_ipenc_modelsim.v","sb_ice_syn.v","sb_ice_lc.v"] ]
                            else:
                                tool_lib_files = [xTools.win2unix(os.path.join(ice_build_verilog,lib_f)) for lib_f in [
                                            "ABIPTBS8.v","ABIWTCZ4.v","sb_ice_ipenc_modelsim.v","sb_ice_syn.v","sb_ice_lc.v"] ]
                                tool_lib_files += [xTools.win2unix(os.path.join(ice_build_vhd,lib_f)) for lib_f in [
                                                  "vcomponent_vital.vhd","sb_ice_syn_vital.vhd","sb_ice_lc_vital.vhd" ]]
                            if self.model_sim_ICE_compile(tool_ICE_LIB,tool_lib_files):
                                print "Error: can not comiple lib "
                                return 1
                            break
                    add_vmap_line = "vmap %s "%sname+xTools.win2unix(tool_ICE_LIB)+"/work"+"\n"
                    add_vsim_line = "vsim  -novopt -L %s %s -t 1ns"%(sname,self.tb_top)

                open(do_file, "w").write(bat_script % {"design": top_module,
                                                              "sname": sname,
                                                              "trigger_unit": self.trigger_unit,
                                                              "sim_runtime": sim_runtime,
                                                              "add_src_files": src_file_lines,
                                                              "add_post_sim_line": post_sim_line,
                                                              "add_tb_files": tb_file_lines,
                                                              "add_vsim_line":add_vsim_line,
                                                              "add_vmap_line":add_vmap_line,
                                                              "testbench":self.tb_top})
                sts = xTools.run_command(cmd4, "../run.log", "run.time")
                if sts:
                    return 1
                _recov.comeback()








if __name__ == "__main__":
    pass
