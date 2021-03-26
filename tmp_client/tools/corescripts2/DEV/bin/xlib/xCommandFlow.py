import os
import re
import xTools
import xLatticeDev
import xLattice
__author__ = 'syan'

class LatticeBatchFlow:
    """
    source input file can be .edf/.edi/.ngd/_map.ncd/.ncd and .lpf/.prf file
    """
    def __init__(self, template_dict):
        self.template_dict = template_dict
        self.log_file = "_batch_flow.log"
        self.time_file = "_batch_flow.time"
        self.create_default_template_dict()

    def create_default_template_dict(self):
        self.default_tmpl = dict(
            # ///edif2ngd  -l "LatticeECP4UM" -d LFE4UM-45F "PrjName_Impl.edi" "PrjName_Impl.ngo"
            # ///ngdbuild  -a "LatticeECP4UM" -d LFE4UM-45F  "PrjName_Impl.ngo" "PrjName_Impl.ngd"
            edif2ngd = 'edif2ngd -l "%(family)s" -d %(pty)s "%(edf_file)s" "%(ngo_file)s"',
            ngdbuild = 'ngdbuild -a "%(family)s" -d %(pty)s "%(ngo_file)s" "%(ngd_file)s"',

            # ///map -a "LatticeECP4UM" -p LFE4UM-45F -t CABGA554 -s 8 -oc Commercial   "PrjName_Impl.ngd" -o
            # ///    "PrjName_Impl_map.ncd" -pr "PrjName_Impl.prf" -mp "PrjName_Impl.mrp" "PrjName.lpf"
            # ///trce -v 1 -gt -mapchkpnt 0 -sethld -o PrjName_Impl.tw1 PrjName_Impl_map.ncd PrjName_Impl.prf
            # ///ldbanno "PrjName_Impl_map.ncd" -n Verilog -o "PrjName_Impl_mapvo.vo" -w -neg
            # ///ldbanno "PrjName_Impl_map.ncd" -n VHDL -o "PrjName_Impl_mapvho.vho" -w -neg
            map = 'map -a "%(family)s" -p %(pty)s -t %(pkg)s -s %(spd)s -oc %(opt)s "%(ngd_file)s"'\
                  ' -o "%(map_ncd)s" -pr "%(prf_file)s" -mp "%(mrp_file)s" -lpf "%(lpf_file)s"',
            map_trce = 'trce -v 1 -gt -mapchkpnt 0 -sethld -o "%(tw1_file)s" "%(map_ncd)s" "%(prf_file)s"',
            map_vsim = 'ldbanno "%(map_ncd)s" -n Verilog -o "%(map_vo)s" -w -neg',
            map_vhdsim = 'ldbanno "%(map_ncd)s" -n VHDL -o "%(map_vho)s" -w -neg',

            # ///par -w -l 5 -i 6 -t 1 -c 0 -e 0 -exp parUseNBR=1:parCDP=auto:parCDR=1:parPathBased=OFF
            # ///    PrjName_Impl_map.ncd PrjName_Impl.dir/5_1.ncd PrjName_Impl.prf
            # ///trce -v 10 -gt -sethld -sp 8 -sphld m -o PrjName_Impl.twr PrjName_Impl.ncd PrjName_Impl.prf
            # ///iotiming  "PrjName_Impl.ncd" "PrjName_Impl.prf"
            par = 'par -w -l 5 -i 6 -t 1 -c 0 -e 0 -exp parUseNBR=1:parCDP=auto:parCDR=1:parPathBased=OFF'\
                  ' "%(map_ncd)s" "%(par_ncd)s" %(prf_file)s',
            par_trce = 'trce -v 10 -gt -sethld -sphld m -o %(twr_file)s %(par_ncd)s %(prf_file)s',
            trce = 'trce -v 10 -gt -sethld -sphld m -o %(twr_file)s %(par_ncd)s %(prf_file)s',
            par_iotiming = 'iotiming  "%(par_ncd)s" "%(prf_file)s"',

            # ///ldbanno "PrjName_Impl.ncd" -n Verilog  -o "PrjName_Impl_vo.vo" -w -neg
            # ///ldbanno "PrjName_Impl.ncd" -n VHDL -o "PrjName_Impl_vho.vho"   -w -neg
            export_vsim = 'ldbanno "%(par_ncd)s" -n Verilog -o "%(par_vo)s" -w -neg',
            export_vhdsim = 'ldbanno "%(par_ncd)s" -n VHDL -o "%(par_vho)s" -w -neg',
        )

    def run_flow(self, cmd_name, cmd_args, seed_number=0):
        cmd_template = self.template_dict.get(cmd_name)
        if not cmd_template:
            cmd_template = self.default_tmpl.get(cmd_name)
        if not cmd_template:
            xTools.say_it("- Error. Not support %s" % cmd_name)
            return 1
        sts, cmd = xTools.get_cmd(cmd_template, cmd_args)
        if sts:
            return 1
        if cmd_name == "par":
            if seed_number:
                cmd = re.sub("-t\s+\d+", "-t %d" % seed_number, cmd)
        return xTools.run_command(cmd, self.log_file, self.time_file)


class CommandFlow:
    def __init__(self, flow_options):
        self.flow_options = flow_options
        self.section_flow = flow_options.get("cmd_flow")
        self.section_cmd = flow_options.get("command")

    def process(self):
        self.flatten_options()
        self.batch_flow = LatticeBatchFlow(self.section_cmd)
        if self.par_ncd:
            sts = self.run_from_par_ncd()
        elif self.map_ncd:
            sts = self.run_from_map_ncd()
        elif self.ngd_file:
            sts = self.run_from_ngd_file()
        elif self.edf_file:
            sts = self.run_from_edf_file()
        elif self.src_files:
            sts = self.run_from_src_files()
        else:
            xTools.say_it("-Error. No input files found for running command flow")
            sts = 1
        return sts

    def flatten_options(self):
        self.src_design = self.flow_options.get("src_design")
        self.project_name = self.flow_options.get("project_name")
        self.impl_name = self.flow_options.get("impl_name", "Impl")
        self.devkit = self.flow_options.get("devkit")
        self.lpf_file = self.flow_options.get("lpf_file")
        if not self.lpf_file:
            self.lpf_file = self.flow_options.get("base_lpf")
        self.src_files = self.flow_options.get("src_files")
        self.inc_path = self.flow_options.get("inc_path")
        self.others_path = self.flow_options.get("others_path")
        self.top_module = self.flow_options.get("top_module")
        self.map_ncd = self.flow_options.get("map_ncd")
        self.par_ncd = self.flow_options.get("par_ncd")
        self.prf_file = self.flow_options.get("prf_file")
        self.ngd_file = self.flow_options.get("ngd_file")
        self.edf_file = self.flow_options.get("edf_file")

        self.run_scuba = self.section_flow.get("run_scuba")
        self.run_synthesis = xTools.get_true(self.section_flow, "run_synthesis")
        self.synthesis = self.section_flow.get("synthesis")
        self.synp_goal = self.section_flow.get("synp_goal")
        self.run_translate = xTools.get_true(self.section_flow, "run_translate")
        self.run_map = xTools.get_true(self.section_flow, "run_map")
        self.run_map_trce = xTools.get_true(self.section_flow, "run_map_trce")
        self.run_par = xTools.get_true(self.section_flow, "run_par")
        self.run_trce = xTools.get_true(self.section_flow, "run_par_trce")
        self.conf = self.flow_options.get("conf")
        big_version, small_version = xLattice.get_diamond_version()
        self.xml_file = os.path.join(self.conf, "DiamondDevFile_%s%s.xml" % (big_version, small_version))

    def create_dev_parser(self):
        self.devkit_parser = xLatticeDev.DevkitParser(self.xml_file)
        if self.devkit_parser.process():
            return 1

    def run_it(self, run_type_name_list, kwargs):
        for (run_type, run_name) in run_type_name_list:
            if run_type:
                sts = self.batch_flow.run_flow(run_name, kwargs)
                if sts:
                    return 1

    def update_project_name(self, src_base_file):
        upn = self.project_name
        if upn:
            pass
        else:
            # upn = xTools.get_fname(src_base_file)
            upn = "PrjName"  # as per Jason's mind, use the same PrjName as the tcl flow.
        return upn

    def create_default_kwargs(self, project_name):
        # Jason Wang, use default project name and impl name for command flow
        project_name = "%s_%s" % (self.project_name, self.impl_name)
        dk = dict()
        dk["edf_file"] = project_name + ".edf"
        dk["ngo_file"] = project_name + ".ngo"
        dk["ngd_file"] = project_name + ".ngd"
        dk["map_ncd"] = project_name + "_map.ncd"
        dk["prf_file"] = project_name + ".prf"
        dk["mrp_file"] = project_name + ".mrp"
        dk["lpf_file"] = project_name + '.lpf'
        dk["par_ncd"] = project_name + ".ncd"
        dk["twr_file"] = project_name + ".twr"
        dk["tw1_file"] = project_name + ".tw1"
        dk["project_name"] = project_name
        return dk


    def run_from_par_ncd(self):
        sts, par_ncd = self.check_exists(self.par_ncd, "par ncd file")
        if not sts:
            sts, prf_file = self.check_exists(self.prf_file, "prf file")
        else:
            prf_file = ""
        if sts:
            return 1
        _project_name = self.update_project_name(par_ncd)
        kwargs = dict(twr_file=_project_name+".twr", par_ncd=par_ncd, prf_file=prf_file, project_name=_project_name)
        run_type_name_list = [(self.run_trce, "par_trce"),]
        sts = self.run_it(run_type_name_list, kwargs)
        return sts

    def run_from_map_ncd(self):
        sts, map_ncd = self.check_exists(self.map_ncd, "map ncd file")
        if not sts:
            sts, prf_file = self.check_exists(self.prf_file, "prf file")
        else:
            prf_file = ""
        if sts:
            return 1
        _project_name = self.update_project_name(map_ncd)
        _project_name = re.sub("_map$", "", _project_name)
        kwargs = self.create_default_kwargs(_project_name)

        kwargs["map_ncd"] = map_ncd
        kwargs["prf_file"] = prf_file

        run_type_name_list = ((self.run_map_trce, "map_trce"), (self.run_par, "par"), (self.run_trce, "par_trce"))
        sts = self.run_it(run_type_name_list, kwargs)
        return sts

    def run_from_ngd_file(self):
        sts, ngd_file = self.check_exists(self.ngd_file, "ngd file")
        if not sts:
            sts, lpf_file = self.check_exists(self.lpf_file, "lpf file")
        else:
            lpf_file = ""
        if sts:
            return 1
        kwargs = self.create_dev_for_kwargs()
        _project_name = self.update_project_name(ngd_file)
        kd = self.create_default_kwargs(_project_name)
        xTools.dict_none_to_new(kwargs, kd)

        kwargs["ngd_file"] = ngd_file
        kwargs["lpf_file"] = lpf_file

        run_type_name_list = ((self.run_map, "map"), (self.run_map_trce, "map_trce"),
                              (self.run_par, "par"), (self.run_trce, "par_trce"))
        sts = self.run_it(run_type_name_list, kwargs)
        return sts

    def run_from_edf_file(self):
        sts, edf_file = self.check_exists(self.edf_file, "edf file")
        if not sts:
            sts, lpf_file = self.check_exists(self.lpf_file, "lpf file")
        else:
            lpf_file = ""
        if sts:
            return 1
        kwargs = self.create_dev_for_kwargs()
        _project_name = self.update_project_name(edf_file)
        kd = self.create_default_kwargs(_project_name)
        xTools.dict_none_to_new(kwargs, kd)
        kwargs["edf_file"] = edf_file
        kwargs["lpf_file"] = lpf_file
        run_type_name_list = [(self.run_map, "map"), (self.run_map_trce, "map_trce"),
                              (self.run_par, "par"), (self.run_trce, "par_trce")]
        if self.run_translate:
            run_type_name_list.insert(0, (1, "ngdbuild"))
            run_type_name_list.insert(0, (1, "edif2ngd"))
        sts = self.run_it(run_type_name_list, kwargs)
        return sts

    def run_from_src_files(self):
        kwargs = self.create_dev_for_kwargs()
        if not self.project_name:
            self.project_name = "PrjName"
        if not self.impl_name:
            self.impl_name = "Impl"
        _project_name = "%s_%s" % (self.project_name, self.impl_name)

        sts, lpf_file = self.check_exists(self.lpf_file, "lpf file")
        if sts:
            #return 1
            pass # Peter need run LSE only. DO NOT NEED LPF FILE

        kd = self.create_default_kwargs(_project_name)
        xTools.dict_none_to_new(kwargs, kd)
        kwargs["lpf_file"] = lpf_file

        if self.run_synthesis_flow(kwargs):
            return 1
        if self.run_translate_flow(kwargs):
            return 1

        run_type_name_list = [(self.run_map, "map"), (self.run_map_trce, "map_trce"),
                              (self.run_par, "par"), (self.run_trce, "par_trce")]
        sts = self.run_it(run_type_name_list, kwargs)
        return sts

    def run_synthesis_flow(self, kwargs):
        src_files = xTools.get_src_files(self.src_files, self.src_design)
        if self.run_scuba:
            for item in src_files:
                real_file = item[-1]
                sts = xLattice.run_scuba_by_file(real_file, self.run_scuba)
                if sts == 1:
                    return 1
        if self.synthesis == "lse":
            self.run_lse_flow(src_files, kwargs)
        elif self.synthesis == "synplify":
            self.run_synplify_flow(src_files, kwargs)
        elif not self.synthesis:
            xTools.say_it("-Error. No synthesis name specified")
            return 1

    def run_translate_flow(self, kwargs):
        if self.synthesis == "lse":
            return
        if self.run_translate:
            run_type_name_list= ( (1, "edif2ngd"), (1, "ngdbuild") )
            sts = self.run_it(run_type_name_list, kwargs)
            return sts

    def check_exists(self, a_file, comments):
        if not a_file:
            xTools.say_it("-Warning. No specified for %s" % comments)
            return 1, ""
        new_file = xTools.get_relative_path(a_file, self.src_design)
        if xTools.not_exists(new_file, comments):
            return 1, ""
        return 0, new_file

    def create_dev_for_kwargs(self):
        tiny_kwargs = dict()
        if self.devkit:
            if self.create_dev_parser():
                return 1
            devkit_detail = self.devkit_parser.get_std_devkit(self.devkit)
            if not devkit_detail:
                return 1
            will_use_keys = ("family", "pty", "pkg", "spd", "opt", "short_pkg", "short_pty", "short_family")
            for key in will_use_keys:
                tiny_kwargs[key] = devkit_detail.get(key)
        return tiny_kwargs

    def run_lse_flow(self, src_files, kwargs):
        synthesis_cmd = self.section_cmd.get("synthesis")
        new_src_files = self.get_lse_source_files(src_files)
        if not self.run_synthesis:
            return
        if synthesis_cmd:
            sts, lse_cmd = xTools.get_cmd(synthesis_cmd, dict(src_files=new_src_files))
            if sts:
                return 1
            # sometimes the user do NOT use -f for specify the source files
            lse_cmd = re.sub("\s+", " ", lse_cmd)
            sts = xTools.run_command(lse_cmd, "my_run_lse.log", "my_run_lse.time")
            return sts
        # ---------------------
        if not self.synp_goal:
            self.synp_goal = "Timing"
        else:
            self.synp_goal = self.synp_goal.capitalize()
        kwargs["goal"] = self.synp_goal

        _tm = ""
        if self.top_module:
            _tm = "-top %s" % self.top_module
        kwargs["top_module"] = _tm

        if self.inc_path:
            _inc_path = xTools.to_abs_list(self.inc_path, self.src_design)
        else:
            _inc_path = list()
        _inc_path.append(xTools.win2unix(os.getcwd()))
        kwargs["search_path"] = '"%s"' % '" '.join(_inc_path)
        kwargs["source_files"] = new_src_files

        synproj_template = os.path.join(self.conf, "synthesis", "run_lse.synproj")
        if xTools.not_exists(synproj_template, "LSE Project Template"):
            return 1
        lse_synproj_file = "run_lse.synproj"
        xTools.generate_file(lse_synproj_file, synproj_template, kwargs)

        lse_cmd = "synthesis -f %s" % lse_synproj_file
        sts = xTools.run_command(lse_cmd, "my_run_lse.log", "my_run_lse.time")
        return sts

    def run_synplify_flow(self, src_files, kwargs):
        if not self.run_synthesis:
            return
        kwargs["source_files"] = self.get_synp_source_files(src_files)
        if self.inc_path:
            _inc_path = xTools.to_abs_list(self.inc_path, self.src_design)
        else:
            _inc_path = list()
        _inc_path.append(xTools.win2unix(os.getcwd()))
        kwargs["search_path"] ="{%s}" % ";".join(_inc_path)
        if self.top_module:
            _tm = 'set_option -top_module "%s"' % self.top_module
        else:
            _tm = ''
        kwargs["top_module"] = _tm

        prj_template = os.path.join(self.conf, "synthesis", "run_synplify.prj")
        if xTools.not_exists(prj_template, "Synplify Project Template"):
            return 1
        synplify_prj_file = "run_synplify.prj"
        xTools.generate_file(synplify_prj_file, prj_template, kwargs)

        synplify_cmd = 'synpwrap -prj "%s"' % synplify_prj_file
        sts = xTools.run_command(synplify_cmd, "my_run_synplify.log", "my_run_synplify.time")
        return sts

    def get_synp_source_files(self, src_files):
        final_lines = list()
        for item in src_files:
            src_file = item[-1]
            pre_str = self.get_lse_pre_str(src_file)
            if not pre_str:
                continue
            if pre_str == "-ver":
                final_lines.append('add_file -verilog "%s"' % src_file)
            else:
                if len(item) > 1:
                    lib_name = item[1]
                else:
                    lib_name = "work"
                final_lines.append('add_file -vhdl -lib %s "%s"' % (lib_name, src_file))
        return os.linesep.join(final_lines)

    def get_lse_source_files(self, src_files):
        lse_source_files = list()
        for item in src_files:
            src_file = item[-1]
            pre_str = self.get_lse_pre_str(src_file)
            if not pre_str:
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
        fext = xTools.get_fext_lower(src)
        if fext in (".v", ".vo"):
            pre_str = "-ver"
        elif fext in (".vhd", ".vhdl", ".vho"):
            pre_str = "-vhd"
        else:
            #xTools.say_it("Warning. Unknown source file: %s" % src)
            pre_str = ""
        return pre_str

if __name__ == "__main__":
    test_src = []




























