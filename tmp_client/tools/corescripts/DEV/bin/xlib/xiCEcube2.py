import re
import os

import xTools
from  xCommandFlow import LatticeBatchFlow, CommandFlow

__author__ = 'syan'

# "D:/lscc/iCEcube2.2014.04prod/sbt_backend/bin/win32/opt\edifparser.exe"
# "D:\lscc\iCEcube2.2014.04prod\sbt_backend\devices\ICE40R04.dev"
# "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt/col_01_get_ports.edf "
# "D:/test/01_col_01_get_ports/par/col_01_get_ports_Implmnt\sbt\netlist"
# "-pSWG25TR" -c --devicename iCE40LM4K
edifparser = r'''%(ice_opt_path)s\edifparser.exe
             "%(dev_file)s"
             "%(cwd)s/%(implmnt_path)s/%(ProjectName)s.edf "
             "%(cwd)s/%(implmnt_path)s\sbt\netlist"
             "-p%(DevicePackage)s" -c --devicename %(DeviceFamily)s%(Device)s'''

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
            --lib-file "%(lib_file)s" --effort_level std
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
             --package %(DevicePackage)s --outdir "./%(implmnt_path)s/sbt/outputs/packer"
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
                --lib "./%(implmnt_path)s/sbt/netlist/oadb-%(DesignCell)s" --view rt
                --device "%(dev_file)s" --splitio
                --in-sdc-file "./%(implmnt_path)s/sbt/outputs/packer/%(DesignCell)s_pk.sdc"
                --out-sdc-file "./%(implmnt_path)s/sbt/outputs/netlister/%(DesignCell)s_sbt.sdc" '''


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
             --low_power on --init_ram on --init_ram_bank %(BitmapInitRamBank)s --frequency low --warm_boot on'''

class iCEcubeFlow(LatticeBatchFlow):
    def __init__(self, template_dict):
        LatticeBatchFlow.__init__(self, template_dict)
        self.create_ice_default_template()

    def create_ice_default_template(self):
        def one_space(a_string):
            return re.sub("\s+", " ", a_string)

        self.default_tmpl = dict(edifparser = one_space(edifparser), sbtplacer = one_space(sbtplacer),
            packer_drc = one_space(packer_drc), packer = one_space(packer),
            sbrouter = one_space(sbrouter), netlister = one_space(netlister),
            sbtimer = one_space(sbtimer), bitmap = one_space(bitmap))

super_run = CommandFlow(dict())
class Run_iCEcube:
    def __init__(self, flow_options):
        self.flow_options = flow_options

    def iCE_process(self):
        sts = self.check_iCEcube()
        if sts:
            return 1

        if self.prepare_kwargs():
            return 1

        self.runit = iCEcubeFlow(dict())
        if self.synthesis == "lse":
            # modify self.runit.default_tmpl
            # self.update_default_tmpl()
            pass

        if self.run_test_process():
            return 1

    def update_default_tmpl(self):
        ori_tmpl = self.runit.default_tmpl
        new_tmpl = dict()
        for key, value in ori_tmpl.items():
            if key == "edifparser":
                value = re.sub("\s+-c\s+", " ", value)
            elif key == "sbtplacer":
                value = re.sub("--sdc-file\s+\S+", "", value)
            elif key in ("packer_drc", "packer"):
                value = re.sub("--src_sdc_file\s+\S+", "", value)
                value = re.sub("--dst_sdc_file\s+\S+", "", value)
                value = re.sub("--translator\s+\S+", "", value)
            elif key == "netlister":
                value = re.sub("--in-sdc-file\s+\S+", "", value)
                value = re.sub("--out-sdc-file\s+\S+", "", value)
            elif key == "sbtimer":
                value = re.sub("--sdc-file\s+\S+", "", value)
            elif key == "sbrouter":
                value = re.sub('\s+\S+_pk\.sdc"', " ", value)
            new_tmpl[key] = value
        self.runit.default_tmpl = new_tmpl

    def check_iCEcube(self):
        iCEcube_path = self.flow_options.get("icecube_path")
        if xTools.not_exists(iCEcube_path, "iCEcube path"):
            return 1
        self.ice_root_path = iCEcube_path
        self.ice_opt_path = xTools.win2unix(os.path.join(iCEcube_path, "sbt_backend", "bin", "win32", "opt"))
        self.lse_exe = xTools.win2unix(os.path.join(iCEcube_path, "LSE", "bin", "nt", "synthesis.exe"))
        self.synpwrap_exe = xTools.win2unix(os.path.join(self.ice_opt_path, "synpwrap", "synpwrap.exe"))

        os.environ["FOUNDRY"] = xTools.win2unix(os.path.join(iCEcube_path, "LSE"))
        os.environ["SYNPLIFY_PATH"] = xTools.win2unix(os.path.join(iCEcube_path, "synpbase"))

    def prepare_kwargs(self):
        self.conf = self.flow_options.get("conf")
        same_ldf_dir = self.flow_options.get("same_ldf_dir")
        use_ice_prj = self.flow_options.get("use_ice_prj")
        self.kwargs = dict()
        if use_ice_prj:
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
            _sdc_file = ""
            for item in _src_files:
                fext = xTools.get_fext_lower(item)
                if fext == ".sdc":
                    _sdc_file = item
                    break
            sdc_file = self.flow_options.get("sdc_file")
            ldc_file = self.flow_options.get("ldc_file")
            if sdc_file:
                sdc_file = xTools.get_relative_path(sdc_file, same_ldf_dir)
            if ldc_file:
                ldc_file = xTools.get_relative_path(ldc_file, same_ldf_dir)
            _src_files = [[xTools.get_relative_path(item, same_ldf_dir)] for item in _src_files]

            implmnt_path = _top_name + "_Implmnt"
            _implmnt = dict()
            self.kwargs["ProjectName"] = _top_name
            self.kwargs["implmnt_path"] = implmnt_path
            self.kwargs["source_files"] = _src_files
            _dev_list = re.split("\s*,\s*", _devkit)

            self.kwargs["DeviceFamily"], self.kwargs["Device"], self.kwargs["DevicePackage"] = _dev_list

        # --------------
        self.synthesis = self.flow_options.get("synthesis")

        if not self.synthesis:
            self.synthesis = "synplify"
        if self.synthesis == "synplify":
            _source_files = super_run.get_synp_source_files(_src_files)

            if sdc_file:
                kk = sdc_file
            elif _sdc_file:
                kk = _sdc_file
            else:
                kk = ""
            if kk:
                sdc_file = "add_file -constraint %s" % kk
            else:
                sdc_file = ""
        else:
            _source_files = super_run.get_lse_source_files(_src_files)
            if ldc_file:
                sdc_file = "-sdc %s" % ldc_file
            else:
                sdc_file = ""
        self.kwargs["source_files"] = _source_files
        self.kwargs["sdc_file"] = sdc_file
        # --------------

        _goal = self.flow_options.get("goal")
        _frequency = self.flow_options.get("frequency")
        if not _frequency:
            if self.synthesis == "lse":
                _frequency = 200
            else:
                _frequency = "Auto"
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
        sts, ice_map_options = xTools.get_conf_options(ice_map_file, key_lower=False)
        if sts:
            return sts

        _family = ice_map_options.get(self.kwargs.get("DeviceFamily"))
        if not _family:
            xTools.say_it("Warning. Not support Family: %s" % self.kwargs.get("DeviceFamily"))
            return 1
        dev_lib = _family.get(self.kwargs.get("Device"))
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
        self.kwargs["sdc_translator"] = os.path.abspath(os.path.join(self.ice_root_path, r"sbt_backend\bin\sdc_translator.tcl"))

        info_line = "%s%s-%s" % (self.kwargs["DeviceFamily"], self.kwargs["Device"], self.kwargs["DevicePackage"])
        xTools.append_file(os.path.join(_sbt_path, "outputs", "device_info.txt"), info_line, False)

        tool_options = self.flow_options.get("tool options", dict())
        _BitmapInitRamBank = tool_options.get("BitmapInitRamBank")
        if not _BitmapInitRamBank:
            _BitmapInitRamBank = "1111"
        self.kwargs["BitmapInitRamBank"] = _BitmapInitRamBank


    def run_test_process(self):
        # synthesize flow
        if self.synthesis == "synplify":
            template_file = os.path.join(self.conf, "ice_synthesis", "run_synplify.prj")
            prj_file = "run_synplify.prj"
        else:
            template_file = os.path.join(self.conf, "ice_synthesis", "run_lse.synproj")
            prj_file = "run_lse.synproj"
        if xTools.not_exists(template_file, "Template file"):
            return 1
        xTools.generate_file(prj_file, template_file, self.kwargs)

        if self.synthesis == "synplify":
            syn_cmd = "%s -prj %s" % (self.synpwrap_exe, prj_file)
        else:
            syn_cmd = "%s -f %s" % (self.lse_exe, prj_file)

        sts = xTools.run_command(syn_cmd, "run_synthesis.log", "run_synthesis.time")
        if sts:
            return 1

        for command in ("edifparser", "sbtplacer", "packer_drc", "packer", "sbrouter", "netlister", "sbtimer", "bitmap"):
            sts = self.runit.run_flow(command, self.kwargs)
            if sts:
                return sts

if __name__ == "__main__":
    pp = iCEcubeFlow(dict())
    kk = pp.default_tmpl
    import xTools
    xTools.say_it(kk)



