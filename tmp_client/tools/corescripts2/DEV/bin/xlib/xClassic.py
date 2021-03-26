import os
import re
import shlex

import yTools

__author__ = 'syan'


def classic_project_dict(syn_file):
    """
    get the original classic project dictionary.
    all the key is in lower.
    """
    project_dict = dict()
    for line in open(syn_file):
        line = line.strip()
        if not line:
            continue
        line = yTools.win2unix(line, 0)
        line = shlex.split(line)
        key = line[0].lower()
        value = line[1:]
        if project_dict.has_key(key):
            project_dict[key].append(value)
        else:
            project_dict[key] = [value]
    return project_dict

def get_value(key, a_dict):
    """get the value string from a dictionary like:
    SYNTHESIS_TOOL      : [['Precision']]
    """
    value = a_dict.get(key)
    if value:
        return value[0][0]
    return "no_%s" % key

def get_value_list(key, a_dict):
    """ get the value list from a dictionary like:
    MODULE              : [['ex2moore.v'], ['osc_pg.v'], ['comp.v'], ['reg8.v']]
    """
    value = a_dict.get(key)
    if value:
        return [item[0] for item in value]
    return list()

class ProjectKwargs:
    def __init__(self, syn_file, devkit):
        self.syn_file = syn_file
        self.devkit = devkit
        self.simple_keys = ("design", "devkit", "topmodule", "simulator_tool", "synthesis_tool")

    def get_prj_kwargs(self):
        topmodule = self.prj_kwargs.get("topmodule")
        if not topmodule:
            self.prj_kwargs["topmodule"] = self.prj_kwargs.get("design", "no_design")
        return self.prj_kwargs

    def process(self):
        self.prj_kwargs = dict()
        self.ori_syn_dict = classic_project_dict(self.syn_file)
        self.get_directly()
        self.get_combine()

    def get_directly(self):
        for item in self.simple_keys:
            self.prj_kwargs[item] = get_value(item, self.ori_syn_dict)
        if self.devkit:
            self.prj_kwargs["devkit"] = self.devkit

    def get_combine(self):
        """ Not in the simple keys list:
            modstyle stimulus module project entry
            will get module and stimulus
        """
        key_module = "module"
        key_sim = "stimulus"
        self.prj_kwargs[key_module] = get_value_list(key_module, self.ori_syn_dict)
        tt = get_value_list(key_sim, self.ori_syn_dict)
        if not tt:
            tt = get_value_list("testfixture", self.ori_syn_dict)
        self.prj_kwargs[key_sim] = tt
        self.prj_kwargs["tb_file_is"] = tt
def get_file_list(section_case, src_design):
    # say_it(section_case, "Section Case:")
    _file_list = section_case.get("file list")
    _file_list = re.split(",", _file_list)
    _file_list = [item.strip() for item in _file_list]

    file_list = list()
    tb_file = ""
    uut_name = ""
    p_tb = re.compile("(\w+)_tb$", re.I)

    for item in _file_list:
        fname = yTools.get_fname(item)
        fext = yTools.get_fext_lower(item)
        item = yTools.win2unix(item, 0)
        m_tb = p_tb.search(fname)
        if m_tb:
            tb_file = item
            continue
        if fext in (".v", ".vhd", ".sv"):
            file_list.append(item)
        else:
            yTools.say_it("Warning. %s found in _qas.info" % item)

    if tb_file:
        new_tb_file = yTools.get_relative_path(tb_file, src_design)
        if not os.path.isfile(new_tb_file):
            yTools.say_it("-Error. Not found testbench file: %s" % tb_file)
        else:
            base_module_name = section_case.get("topmodule")
            p_uut_name_verilog = re.compile("%s\s+(\w+)" % base_module_name)
            # add_16_SIGNED post(
            p_uut_name_vhdl = re.compile("(\S+)\s*:\s*%s" % base_module_name)
            # uut: mac_ecp4_m5678_09x09_ir_or_dc_mclk_up PORT MAP(
            fext = yTools.get_fext_lower(new_tb_file)
            if fext == ".v":
                matched_uut_name = yTools.simple_parser(new_tb_file, [p_uut_name_verilog,])
            else:
                matched_uut_name = yTools.simple_parser(new_tb_file, [p_uut_name_vhdl,])
            if not matched_uut_name:
                yTools.say_it("-Warning. can not find uut name in %s" % tb_file)
            else:
                uut_name = matched_uut_name[1].group(1)
    return tb_file, file_list, uut_name

def qas_kwargs(qas_file):
    sts, qas_dict = yTools.get_conf_options(qas_file)
    section_info = "Case Information"
    case_info_dict = qas_dict.get(section_info)
    prj_kwargs = dict()
    prj_kwargs["design"] = case_info_dict.get("design", "no_design")
    _module = case_info_dict.get("module")
    if _module:
        prj_kwargs["topmodule"] = yTools.get_fname(_module)
    else:
        prj_kwargs["topmodule"] = prj_kwargs["design"]
    case_info_dict["topmodule"] = prj_kwargs.get("topmodule")

    tb_file, file_list, uut_name = get_file_list(case_info_dict, os.path.dirname(qas_file))
    prj_kwargs["tb_file_is"] = tb_file
    prj_kwargs["file_list"] = file_list
    prj_kwargs["module"] = file_list
    prj_kwargs["uut_name"] = uut_name
    return prj_kwargs

def create_lse_env_file(env_file):
    lines = list()
    install_dir = os.getenv("MY_CLASSIC", "NotFoundClassicInstallPath")
    lines.append("FOUNDRY=%s/LSE" % install_dir)
    lines.append("PATH=%s/LSE/bin/nt;%%PATH%%" % install_dir)
    lines.append("")
    yTools.write_file(env_file, lines)

def get_template_file(conf_path, template_file):
    real_template_file = os.path.join(conf_path, "classic", template_file)
    if yTools.not_exists(real_template_file, template_file):
        return 1, ""
    return 0, real_template_file

def create_rsp_file(rsp_file, kwargs):
    """
    puts $rspFile "-i func_sim.tt4 -lib \"$install_dir/ispcpld/dat/lc4k\"
     -strategy top -sdfmdl \"$install_dir/ispcpld/dat/sdf.mdl\"
     -pla func_sim.tt4 -lci func_sim.lct -prj func_sim
     -dir \"$proj_dir\" -err automake.err
     -log func_sim.nrp -exf register_en_set.exf
    """
    # yTools.say_it(kwargs)
    line = " -i %(design)s.tt4 -lib %(install_dir)s/ispcpld/dat/%(diename)s " % kwargs
    line += " -strategy top -sdfmdl %(install_dir)s/ispcpld/dat/sdf.mdl " % kwargs
    line += " -pla %(design)s.tt4 -lci %(design)s.lct -prj %(design)s " % kwargs
    line += " -dir %(prj_dir)s -err automake.err -log %(design)s.nrp -exf %(topmodule)s.exf" % kwargs
    if kwargs.get("source_format") == "Pure Verilog HDL":
        line += " -netlist verilog"
    yTools.write_file(rsp_file, line)


if __name__ == "__main__":
    os.environ["MY_CLASSIC"] = "classic_path"
    create_lse_env_file("test.env")
