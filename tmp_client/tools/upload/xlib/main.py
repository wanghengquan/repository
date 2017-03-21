#! -- coding: UTF-8 --
import os
import time
import optparse

import xTools
import utils
import testrailAPI


__author__ = 'syan'


class CommandEntry:
    def __init__(self):
        self.default_suite_mode = 3
        self.default_show_announcement = 1
        self.support_list = ("project", "suite", "section", "milestone", "run", "plan")

    def process(self, options_list):
        xTools.say_it("-- Start Command Entry ... <%s>" % time.ctime())
        _etime = xTools.ElapsedTime()
        _etime.play()
        if self.run_option_parser(options_list):
            return 1
        sts, self.conf_dict = xTools.get_conf_options(self.ini_file)
        if sts:
            return 1
        self.api = testrailAPI.TestRailAPI(self.username, self.password, self.testrail)
        try:
            sts = self.flow_based_on_ini()
        except:
            utils.say_tb_error()
            sts = 1
        xTools.say_it("-- End of Command Entry ... <%s>" % time.ctime())
        _etime.stop()
        xTools.say_it(_etime)
        return sts

    def run_option_parser(self, options_list):
        parser = optparse.OptionParser()
        parser.add_option("--debug", action="store_true", help="print debug message")
        parser.add_option("--file", help="specify initial configuration file")
        parser.add_option("--clean", action="store_true", help="make suite/cases clean")
        parser.add_option("--username", help="specify TestRail username")
        parser.add_option("--password", help="specify TestRail password")
        parser.add_option("--testrail", help="specify TestRail URL, format: http://$server/testrail")


        opts, args = parser.parse_args(options_list)
        self.debug = opts.debug
        self.clean = opts.clean
        self.ini_file = opts.file
        self.username = opts.username
        self.password = opts.password
        self.testrail = opts.testrail
        if xTools.not_exists(self.ini_file, "Initial Configuration File"):
            return 1
        self.ini_dir = os.path.dirname(self.ini_file)

    def flow_based_on_ini(self):
        xTools.say_it(" + Process of configuration data ...")
        self.new_conf_dict = utils.reorganize_conf_dict(self.conf_dict, self.support_list)
        if self.new_conf_dict == 1:
            return 1
        xTools.say_it(self.new_conf_dict, "New Configuration Dictionary", self.debug)

        if self.flow_of_project():
            return 1
        if self.flow_of_suite():
            return 1

        if self.clean:
            if self.flow_clean_section():
                return 1

        if self.flow_of_section():
            return 1

        if self.flow_milestone():
            return 1

        if self.flow_run():
            return 1

    def flow_of_project(self):
        xTools.say_it(" + Process of Project ...")
        self.pass_on_project_id = 0
        project_dict_list = self.new_conf_dict.get("project", list())
        project_number = len(project_dict_list)
        if not project_number:  # no project settings
            return
        elif project_number > 1:
            xTools.say_it("Error. More than 1 projects are found.")
            return 1
        # --------------------------------------
        raw_data = project_dict_list[0]
        raw_data.setdefault("suite_mode", self.default_suite_mode)
        raw_data.setdefault("show_announcement", self.default_show_announcement)
        # -------------------------------------------
        project_id = raw_data.get("id")
        project_name = raw_data.get("name")
        project_data = self.api.get_project_data(project_name, project_id)
        if project_data:
            self.pass_on_project_id = project_data.get("id")
            xTools.say_it("   + Try to update project_id: %s" % self.pass_on_project_id)
            self.api.update_project(self.pass_on_project_id, raw_data)
        else:
            xTools.say_it("   + Try to create a new project: %s" % project_name)
            project_data = self.api.add_project(raw_data)
            self.pass_on_project_id = project_data.get("id")

    def flow_clean_section(self):
        section_dict_list = self.new_conf_dict.get("section", list())
        # get suite_id_list
        suite_id_dict = dict()
        for raw_data in section_dict_list:
            section_name = raw_data.get("name")
            section_id = raw_data.get("id")
            suite_name = raw_data.get("suite_name")
            suite_id = raw_data.get("suite_id")
            project_name = raw_data.get("project_name")
            project_id = raw_data.get("project_id")

            if section_id:
                section_data = self.api.get_section(section_id)
            else:
                real_project_id = self.get_project_id(project_name, project_id)
                if real_project_id < 0:
                    return 1
                suite_data = self.api.get_suite_data(suite_name, suite_id, real_project_id)
                if not suite_data:
                    xTools.say_it("Error. can not find suite data for section: %s" % section_name)
                    return 1
                suite_id = suite_data.get("id")
                section_data = self.api.get_section_data(section_name, section_id, suite_id, real_project_id)
            if section_data:
                suite_id = section_data.get("suite_id")
                suite_data = self.api.get_suite(suite_id)
                project_id = suite_data.get("project_id")
                utils.update_dict(suite_id_dict, suite_id, (project_id, section_data.get("id")))

        for suite_id, value in suite_id_dict.items(): # value [(project_id, section_id), ()]
            project_id = value[0][0]
            sections_data = self.api.get_sections(project_id, suite_id)
            section_id_in_conf  = [item[1] for item in value]
            for s in sections_data:
                _id = s.get("id")
                _name = s.get("name")
                if _id in section_id_in_conf:
                    continue
                else:
                    xTools.say_it(" Warning. delete section: (%-3d) %s" % (_id, _name))
                    self.api.delete_section(_id)

    def flow_of_section(self):
        """ update test section
        if section_id specified, will add case directly
        elif suite_id, check this suite_id, and get section_id from

        """
        section_dict_list = self.new_conf_dict.get("section", list())
        for raw_data in section_dict_list:
            section_name = raw_data.get("name")
            section_id = raw_data.get("id")
            suite_name = raw_data.get("suite_name")
            suite_id = raw_data.get("suite_id")
            project_name = raw_data.get("project_name")
            project_id = raw_data.get("project_id")

            xTools.say_it(" + Process of section %s" % section_name)
            xTools.say_it("  Updating %s @ %s" % (section_name, time.ctime()), "", self.debug)
            real_project_id = 0
            if section_id:
                section_data = self.api.get_section(section_id)
                suite_id = section_data.get("suite_id")
            else:
                real_project_id = self.get_project_id(project_name, project_id)
                if real_project_id < 0:
                    return 1
                suite_data = self.api.get_suite_data(suite_name, suite_id, real_project_id)
                if not suite_data:
                    xTools.say_it("Error. can not find suite data for section: %s" % section_name)
                    return 1
                suite_id = suite_data.get("id")
                section_data = self.api.get_section_data(section_name, section_id, suite_id, real_project_id)

            my_section_data = {"name" : section_name, "suite_id" : suite_id}
            if section_data:
                section_id = section_data.get("id")
                self.api.update_section(section_id, my_section_data)
            else:
                section_data = self.api.add_section(real_project_id, my_section_data)
            section_id = section_data.get("id")
            xTools.say_it("  update %s done @ %s." % (section_name, time.ctime()), "", self.debug)
            self.flow_of_one_section(section_id, raw_data)


    def flow_of_suite(self):
        self.pass_on_suite_dict = dict()
        suite_dict_list = self.new_conf_dict.get("suite", list())
        for raw_data in suite_dict_list:
            suite_name = raw_data.get("name")
            suite_id = raw_data.get("id")
            project_name = raw_data.get("project_name", "")
            project_id = raw_data.get("project_id", "")
            xTools.say_it(" + Process of suite: %s" % suite_name)
            real_project_id = 0
            if suite_id:
                suite_data = self.api.get_suite(suite_id)
            else:
                real_project_id = self.get_project_id(project_name, project_id)
                if real_project_id < 0:
                    return 1
                suite_data = self.api.get_suite_data(suite_name, suite_id, real_project_id)
            my_suite_data = utils.get_suite_data(raw_data)
            if suite_data:
                suite_data = self.api.update_suite(suite_data.get("id"), my_suite_data)
            else:
                suite_data = self.api.add_suite(real_project_id, my_suite_data)
            self.pass_on_suite_dict[suite_name] = {"suite_id":suite_data.get("id"), "project_id":suite_data.get("project_id")}
            self.pass_on_project_id = suite_data.get("project_id")
            xTools.say_it(self.pass_on_suite_dict, "Pass-on suite dictionary:", self.debug)

    def get_project_id(self, project_name, project_id):
        if project_name or project_id:
            project_data = self.api.get_project_data(project_name, project_id)
            if project_data:
                project_id = project_data.get("id")
            else:
                xTools.say_it("Error. Can not found project id:%s; name:%s" % (project_id, project_name))
                return -1
        else:
            project_id = self.pass_on_project_id
        if not project_id:
            xTools.say_it("Error. Not found project_id for the flow")
            return -1
        return project_id

    def flow_of_one_section(self, section_id, raw_data):
        case_list = raw_data.get("case_list")
        case_file = raw_data.get("case_file")
        if case_list:
            pass
        elif case_file:
            case_file = xTools.get_relative_path(case_file, self.ini_dir)
            if xTools.not_exists(case_file, "Case List File"):
                return 1
            case_list = list()
            for line in open(case_file):
                line = line.strip()
                if not line:
                    continue
                if line.startswith("#"):
                    continue
                if line.startswith(";"):
                    continue
                case_list.append(line)
        section_data = self.api.get_section(section_id)
        suite_id = section_data.get("suite_id")
        suite_data = self.api.get_suite(suite_id)
        project_id = suite_data.get("project_id")
        xTools.say_it("  Get current section:%s cases @ %s" % (section_data.get("name"), time.ctime()), "", self.debug)

        currents_cases = self.api.get_cases(project_id, suite_id, section_id)
        i = -1
        for i, _case_data in enumerate(currents_cases):
            case_id = _case_data.get("id")
            try:
                _data = utils.create_case_data(case_list[i])
            except IndexError:
                self.api.delete_case(case_id)
                continue
            t = xTools.ElapsedTime()
            t.play()
            need_update = 0
            for key, value in _data.items():
                _code_value = _case_data.get(key)
                try:
                    _code_value = _code_value.encode('utf-8')
                except:
                    pass
                try:
                    temp_value = value.split()
                except AttributeError:
                    temp_value = value
                try:
                    temp_code_value = _code_value.split()
                except AttributeError:
                    temp_code_value = _code_value

                if temp_value != temp_code_value:
                    need_update = 1
                    break
            if need_update:
                self.api.update_case(case_id, _data)
            t.stop()
            xTools.say_it("update one case: %s seconds" % t, "", self.debug)
        for item in case_list[i+1:]:
            _data = utils.create_case_data(item)
            t = xTools.ElapsedTime()
            t.play()
            self.api.add_case(section_id, _data)
            t.stop()
            xTools.say_it("add one case: %s seconds" % t, "", self.debug)

    def flow_milestone(self):
        milestone_list = self.new_conf_dict.get("milestone", list())
        for raw_data in milestone_list:
            milestone_name = raw_data.get("name")
            milestone_id = raw_data.get("id")
            project_name = raw_data.get("project_name", "")
            project_id = raw_data.get("project_id", "")
            xTools.say_it(" + Process of milestone: %s" % milestone_name)
            real_project_id = self.get_project_id(project_name, project_id)
            if real_project_id < 0:
                return 1
            milestone_data = self.api.get_milestone_data(milestone_name, milestone_id, real_project_id)
            my_milestone_data = {"name": milestone_name, "description":raw_data.get("description", "")}
            if milestone_data:
                milestone_id = milestone_data.get("id")
                self.api.update_milestone(milestone_id, my_milestone_data)
            else:
                self.api.add_milestone(real_project_id, my_milestone_data)

    def flow_run(self):
        run_list = self.new_conf_dict.get("run", list())
        for raw_data in run_list:
            run_name = raw_data.get("name")
            suite_name = raw_data.get("suite_name")
            suite_id = raw_data.get("suite_id")
            project_name = raw_data.get("project_name")
            project_id = raw_data.get("project_id")
            milestone_name = raw_data.get("milestone_name")
            milestone_id = raw_data.get("milestone_id")
            xTools.say_it(" + Process of run: %s" % run_name)
            if suite_id:
                suite_data = self.api.get_suite(suite_id)
            else:
                real_project_id = self.get_project_id(project_name, project_id)
                if real_project_id < 0:
                    return 1
                suite_data = self.api.get_suite_data(suite_name, suite_id, real_project_id)
            if not suite_data:
                xTools.say_it("Error. Not found suite for run: %s" % run_name)
                return 1
            suite_id = suite_data.get("id")
            real_project_id = suite_data.get("project_id")
            run_data = self.api.get_run_by_name(run_name, real_project_id)
            if run_data:
                xTools.say_it("Warning. run: %s already exist! exit..." % run_name)
            else:
                my_run_data = {"suite_id" : suite_id,
                               "name" : run_name,
                               "description":raw_data.get("description"),
                               }
                case_ids = raw_data.get("case_ids")
                if case_ids:
                    my_run_data["case_ids"] = utils.string_to_int_list(case_ids)
                    my_run_data["include_all"] = False
                else:
                    my_run_data["include_all"] = True
                if milestone_name or milestone_id:
                    milestone_data = self.api.get_milestone_data(milestone_name, milestone_id, real_project_id)
                    if not milestone_data:
                        xTools.say_it("Error. Not found milestone id:%s, name:%s in project %s" % (milestone_id, milestone_name, real_project_id))
                        return 1
                    my_run_data["milestone_id"] = milestone_data.get("id")
                self.api.add_run(real_project_id, my_run_data)
if __name__ == "__main__":
    tst = CommandEntry()
    import sys
    tst.process(sys.argv[1:])



