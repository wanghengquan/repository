"""
Extracted from http://docs.gurock.com/testrail-api2/start

('GET', 'index.php?/api/v2/get_case/:case_id')
('GET', 'index.php?/api/v2/get_cases/:project_id&suite_id=:suite_id&section_id=:section_id')
('POST', 'index.php?/api/v2/add_case/:section_id')
('POST', 'index.php?/api/v2/update_case/:case_id')
('POST', 'index.php?/api/v2/delete_case/:case_id')
----------
('GET', 'index.php?/api/v2/get_case_fields')
----------
('GET', 'index.php?/api/v2/get_case_types')
----------
('GET', 'index.php?/api/v2/get_configs/:project_id')
----------
('GET', 'index.php?/api/v2/get_milestone/:milestone_id')
('GET', 'index.php?/api/v2/get_milestones/:project_id')
('POST', 'index.php?/api/v2/add_milestone/:project_id')
('POST', 'index.php?/api/v2/update_milestone/:milestone_id')
('POST', 'index.php?/api/v2/delete_milestone/:milestone_id')
----------
('GET', 'index.php?/api/v2/get_plan/:plan_id')
('GET', 'index.php?/api/v2/get_plans/:project_id')
('POST', 'index.php?/api/v2/add_plan/:project_id')
('POST', 'index.php?/api/v2/add_plan_entry/:plan_id')
('POST', 'index.php?/api/v2/update_plan/:plan_id')
('POST', 'index.php?/api/v2/update_plan_entry/:plan_id/:entry_id')
('POST', 'index.php?/api/v2/close_plan/:plan_id')
('POST', 'index.php?/api/v2/delete_plan/:plan_id')
('POST', 'index.php?/api/v2/delete_plan_entry/:plan_id/:entry_id')
----------
('GET', 'index.php?/api/v2/get_priorities')
----------
('GET', 'index.php?/api/v2/get_project/:project_id')
('GET', 'index.php?/api/v2/get_projects')
('POST', 'index.php?/api/v2/add_project')
('POST', 'index.php?/api/v2/update_project/:project_id')
('POST', 'index.php?/api/v2/delete_project/:project_id')
----------
('GET', 'index.php?/api/v2/get_results/:test_id')
('GET', 'index.php?/api/v2/get_results_for_case/:run_id/:case_id')
('GET', 'index.php?/api/v2/get_results_for_run/:run_id')
('POST', 'index.php?/api/v2/add_result/:test_id')
('POST', 'index.php?/api/v2/add_result_for_case/:run_id/:case_id')
('POST', 'index.php?/api/v2/add_results/:run_id')
('POST', 'index.php?/api/v2/add_results_for_cases/:run_id')
----------
('GET', 'index.php?/api/v2/get_result_fields')
----------
('GET', 'index.php?/api/v2/get_run/:run_id')
('GET', 'index.php?/api/v2/get_runs/:project_id')
('POST', 'index.php?/api/v2/add_run/:project_id')
('POST', 'index.php?/api/v2/update_run/:run_id')
('POST', 'index.php?/api/v2/close_run/:run_id')
('POST', 'index.php?/api/v2/delete_run/:run_id')
----------
('GET', 'index.php?/api/v2/get_section/:section_id')
('GET', 'index.php?/api/v2/get_sections/:project_id&suite_id=:suite_id')
('POST', 'index.php?/api/v2/add_section/:project_id')
('POST', 'index.php?/api/v2/update_section/:section_id')
('POST', 'index.php?/api/v2/delete_section/:section_id')
----------
('GET', 'index.php?/api/v2/get_statuses')
----------
('GET', 'index.php?/api/v2/get_suite/:suite_id')
('GET', 'index.php?/api/v2/get_suites/:project_id')
('POST', 'index.php?/api/v2/add_suite/:project_id')
('POST', 'index.php?/api/v2/update_suite/:suite_id')
('POST', 'index.php?/api/v2/delete_suite/:suite_id')
----------
('GET', 'index.php?/api/v2/get_test/:test_id')
('GET', 'index.php?/api/v2/get_tests/:run_id')
----------
('GET', 'index.php?/api/v2/get_user/:user_id')
('GET', 'index.php?/api/v2/get_user_by_email&email=:email')
('GET', 'index.php?/api/v2/get_users')

results dictionary:
   {"status_id": 5,
	"comment": "This test failed",
	"elapsed": "15s",
	"defects": "TR-7",
	"version": "1.0 RC1 build 3724",
    }
----------
"""

import testrail

__author__ = 'syan'

# --------------------------------------------------------------------
# T E S T R A I L  A P I
API_TR_USER = "API_TR_USER"
API_TR_PASSWD = "API_TR_PASSWD"
API_TR_URL = "http://linux-d50553/testrail/"


def get_api_client(user, password, testrail_url):
    """
    get TestRail API client
    """
    if testrail_url:
        client = testrail.APIClient(testrail_url)
    else:
        client = testrail.APIClient(API_TR_URL)
    if not user:
        user = API_TR_USER
    if not password:
        password = API_TR_PASSWD
    client.user = user
    client.password = password
    return client

class TestRailAPI:
    def __init__(self, user, password, testrail_url):
        self.client = get_api_client(user, password, testrail_url)

    # GET index.php?/api/v2/get_case/:case_id
    def get_case(self, case_id):
        line = "get_case/%d" % case_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_cases/:project_id&suite_id=:suite_id&section_id=:section_id
    def get_cases(self, project_id, suite_id=0, section_id=0):
        line = "get_cases/%d" % project_id
        if suite_id:
            line += "&suite_id=%d" % suite_id
        if section_id:
            line += "&section_id=%d" % section_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_case/:section_id
    def add_case(self, section_id, case_data):
        line = "add_case/%d" % section_id
        return self.client.send_post(line, case_data)

    # POST index.php?/api/v2/update_case/:case_id
    def update_case(self, case_id, case_data):
        line = "update_case/%d" % case_id
        return self.client.send_post(line, case_data)

    # POST index.php?/api/v2/delete_case/:case_id
    def delete_case(self, case_id):
        line = "delete_case/%d" % case_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_case_fields
    def get_case_fields(self):
        line = "get_case_fields"
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_case_types
    def get_case_types(self):
        line = "get_case_types"
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_configs/:project_id
    def get_configs(self, project_id):
        line = "get_configs/%d" % project_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_milestone/:milestone_id
    def get_milestone(self, milestone_id):
        line = "get_milestone/%d" % milestone_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_milestones/:project_id
    def get_milestones(self, project_id):
        line = "get_milestones/%d" % project_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_milestone/:project_id
    def add_milestone(self, project_id, milestone_data):
        line = "add_milestone/%d" % project_id
        return self.client.send_post(line, milestone_data)

    # POST index.php?/api/v2/update_milestone/:milestone_id
    def update_milestone(self, milestone_id, milestone_data):
        line = "update_milestone/%d" % milestone_id
        return self.client.send_post(line, milestone_data)

    # POST index.php?/api/v2/delete_milestone/:milestone_id
    def delete_milestone(self, milestone_id):
        line = "delete_milestone/%d" % milestone_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_plan/:plan_id
    def get_plan(self, plan_id):
        line = "get_plan/%d" % plan_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_plans/:project_id
    def get_plans(self, project_id):
        line = "get_plans/%d" % project_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_plan/:project_id
    def add_plan(self, project_id, plan_data):
        line = "add_plan/%d" % project_id
        return self.client.send_post(line, plan_data)

    # POST index.php?/api/v2/add_plan_entry/:plan_id
    def add_plan_entry(self, plan_id, plan_entry_data):
        line = "add_plan_entry/%d" % plan_id
        return self.client.send_post(line, plan_entry_data)

    # POST index.php?/api/v2/update_plan/:plan_id
    def update_plan(self, plan_id, plan_data):
        line = "update_plan/%d" % plan_id
        return self.client.send_post(line, plan_data)

    # POST index.php?/api/v2/update_plan_entry/:plan_id/:entry_id
    def update_plan_entry(self, plan_id, plan_entry_data):
        line = "update_plan_entry/%d" % plan_id
        return self.client.send_post(line, plan_entry_data)

    # POST index.php?/api/v2/close_plan/:plan_id
    def close_plan(self, plan_id):
        line = "close_plan/%d" % plan_id
        return self.client.send_post(line, dict())

    # POST index.php?/api/v2/delete_plan/:plan_id
    def delete_plan(self, plan_id):
        line = "delete_plan/%d" % plan_id
        return self.client.send_post(line, dict())

    # POST index.php?/api/v2/delete_plan_entry/:plan_id/:entry_id
    def delete_plan_entry(self, plan_id):
        line = "delete_plan_entry/%d" % plan_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_priorities
    def get_priorities(self):
        line = "get_priorities"
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_project/:project_id
    def get_project(self, project_id):
        line = "get_project/%d" % project_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_projects
    def get_projects(self):
        line = "get_projects"
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_project
    def add_project(self, project_data):
        line = "add_project"
        return self.client.send_post(line, project_data)

    # POST index.php?/api/v2/update_project/:project_id
    def update_project(self, project_id, project_data):
        line = "update_project/%d" % project_id
        return self.client.send_post(line, project_data)

    # POST index.php?/api/v2/delete_project/:project_id
    def delete_project(self, project_id):
        line = "delete_project/%d" % project_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_results/:test_id
    def get_results(self, test_id):
        line = "get_results/%d" % test_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_results_for_case/:run_id/:case_id
    def get_results_for_case(self, run_id):
        line = "get_results_for_case/%d" % run_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_results_for_run/:run_id
    def get_results_for_run(self, run_id):
        line = "get_results_for_run/%d" % run_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_result/:test_id
    def add_result(self, test_id, result_data):
        line = "add_result/%d" % test_id
        return self.client.send_post(line, result_data)

    # POST index.php?/api/v2/add_result_for_case/:run_id/:case_id
    def add_result_for_case(self, run_id, result_for_case_data):
        line = "add_result_for_case/%d" % run_id
        return self.client.send_post(line, result_for_case_data)

    # POST index.php?/api/v2/add_results/:run_id
    def add_results(self, run_id, results_data):
        line = "add_results/%d" % run_id
        return self.client.send_post(line, results_data)

    # POST index.php?/api/v2/add_results_for_cases/:run_id
    def add_results_for_cases(self, run_id, results_for_cases_data):
        line = "add_results_for_cases/%d" % run_id
        return self.client.send_post(line, results_for_cases_data)

    # GET index.php?/api/v2/get_result_fields
    def get_result_fields(self):
        line = "get_result_fields"
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_run/:run_id
    def get_run(self, run_id):
        line = "get_run/%d" % run_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_runs/:project_id
    def get_runs(self, project_id):
        line = "get_runs/%d" % project_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_run/:project_id
    def add_run(self, project_id, run_data):
        line = "add_run/%d" % project_id
        return self.client.send_post(line, run_data)

    # POST index.php?/api/v2/update_run/:run_id
    def update_run(self, run_id, run_data):
        line = "update_run/%d" % run_id
        return self.client.send_post(line, run_data)

    # POST index.php?/api/v2/close_run/:run_id
    def close_run(self, run_id):
        line = "close_run/%d" % run_id
        return self.client.send_post(line, dict())

    # POST index.php?/api/v2/delete_run/:run_id
    def delete_run(self, run_id):
        line = "delete_run/%d" % run_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_section/:section_id
    def get_section(self, section_id):
        line = "get_section/%d" % section_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_sections/:project_id&suite_id=:suite_id
    def get_sections(self, project_id, suite_id=0):
        line = "get_sections/%d" % project_id
        if suite_id:
            line += "&suite_id=%d" % suite_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_section/:project_id
    def add_section(self, project_id, section_data):
        line = "add_section/%d" % project_id
        return self.client.send_post(line, section_data)

    # POST index.php?/api/v2/update_section/:section_id
    def update_section(self, section_id, section_data):
        line = "update_section/%d" % section_id
        return self.client.send_post(line, section_data)

    # POST index.php?/api/v2/delete_section/:section_id
    def delete_section(self, section_id):
        line = "delete_section/%d" % section_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_statuses
    def get_statuses(self):
        line = "get_statuses"
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_suite/:suite_id
    def get_suite(self, suite_id):
        line = "get_suite/%d" % suite_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_suites/:project_id
    def get_suites(self, project_id):
        line = "get_suites/%d" % project_id
        return self.client.send_get(line)

    # POST index.php?/api/v2/add_suite/:project_id
    def add_suite(self, project_id, suite_data):
        line = "add_suite/%d" % project_id
        return self.client.send_post(line, suite_data)

    # POST index.php?/api/v2/update_suite/:suite_id
    def update_suite(self, suite_id, suite_data):
        line = "update_suite/%d" % suite_id
        return self.client.send_post(line, suite_data)

    # POST index.php?/api/v2/delete_suite/:suite_id
    def delete_suite(self, suite_id):
        line = "delete_suite/%d" % suite_id
        return self.client.send_post(line, dict())

    # GET index.php?/api/v2/get_test/:test_id
    def get_test(self, test_id):
        line = "get_test/%d" % test_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_tests/:run_id
    def get_tests(self, run_id):
        line = "get_tests/%d" % run_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_user/:user_id
    def get_user(self, user_id):
        line = "get_user/%d" % user_id
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_user_by_email&email=:email
    def get_user_by_email(self, email):
        line = "get_user_by_email&email=%s" % email
        return self.client.send_get(line)

    # GET index.php?/api/v2/get_users
    def get_users(self):
        line = "get_users"
        return self.client.send_get(line)

    # ----------------------------------------------------------
    def get_project_by_name(self, project_name):
        projects = self.get_projects()
        for item in projects:
            if item.get("name") == project_name:
                return item

    def get_suite_by_name(self, suite_name, project_id):
        suites = self.get_suites(project_id)
        for item in suites:
            if item.get("name") == suite_name:
                return item

    def get_section_by_name(self, section_name, suite_id, project_id):
        sections = self.get_sections(project_id, suite_id)
        for item in sections:
            if item.get("name") == section_name:
                return item

    def get_milestone_by_name(self, milestone_name, project_id):
        milestones = self.get_milestones(project_id)
        for item in milestones:
            if item.get("name") == milestone_name:
                return item

    def get_run_by_name(self, run_name, project_id):
        runs = self.get_runs(project_id)
        for item in runs:
            if item.get("name") == run_name:
                return item

    def get_project_data(self, project_name, project_id):
        if project_id:
            return self.get_project(project_id)
        else:
            return self.get_project_by_name(project_name)

    def get_suite_data(self, suite_name, suite_id, project_id):
        if suite_id:
            return self.get_suite(suite_id)
        else:
            return self.get_suite_by_name(suite_name, project_id)

    def get_section_data(self, section_name, section_id, suite_id, project_id):
        if section_id:
            return self.get_section(section_id)
        else:
            return self.get_section_by_name(section_name, suite_id, project_id)

    def get_milestone_data(self, milestone_name, milestone_id, project_id):
        if milestone_id:
            return self.get_milestone(milestone_id)
        else:
            return self.get_milestone_by_name(milestone_name, project_id)


if __name__ == "__main__":
    tst = TestRailAPI("", "")
    print tst.client.send_get("get_levels")