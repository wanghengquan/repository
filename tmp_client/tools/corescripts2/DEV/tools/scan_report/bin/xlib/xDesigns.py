import os
import re
import glob

from xOS import not_exists
from xLog import print_error, print_always, wrap_debug
from xFamily import get_std_family_vendor

class CreateDesigns:
    def __init__(self, qa_options):
        self.qa_options = qa_options

        self.design = qa_options.get("design")
        self.top_dir = qa_options.get("top_dir")
        self.job_dir = qa_options.get("job_dir")
        self.family = qa_options.get("family")
        self.vendor = qa_options.get("vendor")
        self.synthesis = qa_options.get("synthesis")

        self.design_dict = dict()
        self.p_family = re.compile("_qa_(\w+)\.info$")
        self.ecp2_ecp2m = ("ecp2", "ecp2m")

    def get_design_dict(self):
        """
        Key: info file, value: (design_name, family_name)
        """
        return self.design_dict

    def process(self):
        if self.get_family_vendor():
            return 1

        if self.get_real_top_dir():
            return 1

        if self.create_design_dict():
            return 1

    def get_family_vendor(self):
        if self.family:
            _family, _vendor = get_std_family_vendor(self.family)
            if _vendor != self.vendor:
                print_error("Never got here!")
                return 1
            self.family = _family

    def get_real_top_dir(self):
        if self.top_dir:
            if not_exists(self.top_dir, "Base top source path"):
                return 1
            self.real_top_dir = os.path.abspath(self.top_dir)
        else:
            self.real_top_dir = self.job_dir

    def create_design_dict(self):
        raw_design_list = os.listdir(self.real_top_dir)
        if self.design:
            design_list = list()
            if self.design in raw_design_list:
                design_list.append(self.design)
            else:
                print_error("Not found design %s in %s" % (self.design, self.real_top_dir))
                return 1
        else:
            design_list = raw_design_list[:]

        if not design_list:
            print_error("Not found any design in %s" % self.real_top_dir)
            return 1

        for a_design in design_list:
            design_dir = os.path.join(self.real_top_dir, a_design)
            info_files = glob.glob(os.path.join(design_dir, "*.info"))
            if not info_files:  # not a design name
                continue
            for qa_info in info_files:
                m = self.p_family.search(qa_info)
                if not m:
                    print_always("Warning. can not parse %s" % qa_info)
                    continue
                cur_family, cur_vendor = get_std_family_vendor(m.group(1))
                if not cur_family:
                    print_error("Unknown family %s in %s" % (m.group(1), os.path.basename(qa_info)))
                    continue
                t_dict = dict(design=a_design, family=cur_family)

                add_it = 0
                if self.family:  # if family name defined
                    if self.family in self.ecp2_ecp2m:
                        if cur_family in self.ecp2_ecp2m:
                            add_it = 1
                    elif cur_family == self.family:
                        add_it = 1
                else:
                    if cur_vendor == self.vendor:
                        add_it = 1
                if add_it:
                    self.design_dict[qa_info] = t_dict
        if not self.design_dict:
            print_error("Not found info file for all designs")
            return 1

        wrap_debug(self.design_dict, "Design Dictionary:")
