#!/usr/bin/python
# -*- coding: utf-8 -*-
import re
import torndb
import cipher
import testrail

__author__ = 'Shawn Yan'
__date__ = '15:05 2018/12/13'


def get_guest_db():
    guest_db = torndb.Connection(host="lsh-tmp", database="testrail",
                                 user=cipher.decrypt("C=Q=O=Q=P=Q=L=R=J=Q=N=Q"),
                                 password=cipher.decrypt("E=Q=O=Q=G=Q=F=Q=H=Q"))
    return guest_db


def get_admin_db():
    admin_db = torndb.Connection(host="lsh-tmp", database="testrail",
                                 user=cipher.decrypt("O=R=E=Q=F=Q=N=R"),
                                 password=cipher.decrypt("A=Q=K=Q=O=R=N=R=B=Q=E=Q=D=Q"))
    return admin_db


# >>>>>>>>>>>>>>>>>
def get_svn_auth():
    svn_auth = cipher.decrypt("B=U=G=U=P=R=K=R=N=Q=F=R=I=Q=E=Q=J=Q=G=Q=C=U=C=R=I=Q=O=T=J=S=D=T=M=X")
    svn_auth += cipher.decrypt("B=U=G=U=K=R=I=Q=L=R=E=R=B=R=K=Q=G=R=H=Q=C=U=D=Q=P=Q=N=S=E=T=M=T=M=X")
    svn_auth += cipher.decrypt("B=U=G=U=E=Q=G=Q=F=U=G=Q=D=R=B=R=M=Q=O=U=B=Q=A=Q=D=Q=H=T=L=T")
    return svn_auth


# >>>>>>>>>>>>>>>
# ('GET', 'index.php?/api/v2/get_case/:case_id')
# ('GET', 'index.php?/api/v2/get_cases/:project_id&suite_id=:suite_id&section_id=:section_id')
# ('POST', 'index.php?/api/v2/add_case/:section_id')
# ('POST', 'index.php?/api/v2/update_case/:case_id')
# ('POST', 'index.php?/api/v2/delete_case/:case_id')
# ('GET', 'index.php?/api/v2/get_case_fields')
# ('POST', 'index.php?/api/v2/add_case_field')
# ('GET', 'index.php?/api/v2/get_case_types')
# ('GET', 'index.php?/api/v2/get_configs/:project_id')
# ('POST', 'index.php?/api/v2/add_config_group/:project_id')
# ('POST', 'index.php?/api/v2/add_config/:config_group_id')
# ('POST', 'index.php?/api/v2/update_config_group/:config_group_id')
# ('POST', 'index.php?/api/v2/update_config/:config_id')
# ('POST', 'index.php?/api/v2/delete_config_group/:config_group_id')
# ('POST', 'index.php?/api/v2/delete_config/:config_id')
# ('GET', 'index.php?/api/v2/get_milestone/:milestone_id')
# ('GET', 'index.php?/api/v2/get_milestones/:project_id')
# ('POST', 'index.php?/api/v2/add_milestone/:project_id')
# ('POST', 'index.php?/api/v2/update_milestone/:milestone_id')
# ('POST', 'index.php?/api/v2/delete_milestone/:milestone_id')
# ('GET', 'index.php?/api/v2/get_plan/:plan_id')
# ('GET', 'index.php?/api/v2/get_plans/:project_id')
# ('POST', 'index.php?/api/v2/add_plan/:project_id')
# ('POST', 'index.php?/api/v2/add_plan_entry/:plan_id')
# ('POST', 'index.php?/api/v2/update_plan/:plan_id')
# ('POST', 'index.php?/api/v2/update_plan_entry/:plan_id/:entry_id')
# ('POST', 'index.php?/api/v2/close_plan/:plan_id')
# ('POST', 'index.php?/api/v2/delete_plan/:plan_id')
# ('POST', 'index.php?/api/v2/delete_plan_entry/:plan_id/:entry_id')
# ('GET', 'index.php?/api/v2/get_priorities')
# ('GET', 'index.php?/api/v2/get_project/:project_id')
# ('GET', 'index.php?/api/v2/get_projects')
# ('POST', 'index.php?/api/v2/add_project')
# ('POST', 'index.php?/api/v2/update_project/:project_id')
# ('POST', 'index.php?/api/v2/delete_project/:project_id')
# ('GET', 'index.php?/api/v2/get_results/:test_id')
# ('GET', 'index.php?/api/v2/get_results_for_case/:run_id/:case_id')
# ('GET', 'index.php?/api/v2/get_results_for_run/:run_id')
# ('POST', 'index.php?/api/v2/add_result/:test_id')
# ('POST', 'index.php?/api/v2/add_result_for_case/:run_id/:case_id')
# ('POST', 'index.php?/api/v2/add_results/:run_id')
# ('POST', 'index.php?/api/v2/add_results_for_cases/:run_id')
# ('GET', 'index.php?/api/v2/get_result_fields')
# ('GET', 'index.php?/api/v2/get_run/:run_id')
# ('GET', 'index.php?/api/v2/get_runs/:project_id')
# ('POST', 'index.php?/api/v2/add_run/:project_id')
# ('POST', 'index.php?/api/v2/update_run/:run_id')
# ('POST', 'index.php?/api/v2/close_run/:run_id')
# ('POST', 'index.php?/api/v2/delete_run/:run_id')
# ('GET', 'index.php?/api/v2/get_section/:section_id')
# ('GET', 'index.php?/api/v2/get_sections/:project_id&suite_id=:suite_id')
# ('POST', 'index.php?/api/v2/add_section/:project_id')
# ('POST', 'index.php?/api/v2/update_section/:section_id')
# ('POST', 'index.php?/api/v2/delete_section/:section_id')
# ('GET', 'index.php?/api/v2/get_statuses')
# ('GET', 'index.php?/api/v2/get_suite/:suite_id')
# ('GET', 'index.php?/api/v2/get_suites/:project_id')
# ('POST', 'index.php?/api/v2/add_suite/:project_id')
# ('POST', 'index.php?/api/v2/update_suite/:suite_id')
# ('POST', 'index.php?/api/v2/delete_suite/:suite_id')
# ('GET', 'index.php?/api/v2/get_templates/:project_id')
# ('GET', 'index.php?/api/v2/get_test/:test_id')
# ('GET', 'index.php?/api/v2/get_tests/:run_id')
# ('GET', 'index.php?/api/v2/get_user/:user_id')
# ('GET', 'index.php?/api/v2/get_user_by_email&email=:email')
# ('GET', 'index.php?/api/v2/get_users')"""
def get_tr_api(username="", password=""):
    x = "P=R=D=Q=L=Q=O=R=G=Q=J=U=P=R=E=Q=K=Q=D=S=O=Q=A=Q=E=R=L=S=H=T=O=T=J=T=I=S=P=T=E=T=B=T=J=X=F=T=K=T=J=T"
    y = "A=Q=K=Q=O=R=N=R=B=Q=E=Q=D=Q"
    if not username:
        username = cipher.decrypt(x)
    if not password:
        password = cipher.decrypt(y)
    api = testrail.APIClient(username, password, "http://lsh-tmp/testrail/")
    return api


class TestRail(object):
    def __init__(self):
        self.db = get_guest_db()
        self.get_status_dict()
        self.get_count_fields()

    def get_status_dict(self):
        """
        :return:
        {u'retest': [4L, u'Retest'],
         u'custom_status5': [10L, u'Case Issue'],
         u'custom_status7': [12L, u'SW Issue'],
         ...}
        """
        self.status_dict = dict()
        _titles = ("system_name", "id", "label")
        select_status = "SELECT %s from statuses" % ",".join(_titles)
        res = self.db.query(select_status)
        for foo in res:
            _content = [foo.get(item) for item in _titles]
            self.status_dict[_content[0]] = _content[1:]

    def get_count_fields(self):
        show_fields = "SHOW FIELDS FROM runs"
        res = self.db.query(show_fields)
        f = lambda x: "_count" in x
        self.count_fields = filter(f, [item.get("Field") for item in res])

    def get_run_plan_count(self, run_plan_id):
        """
        :return:
        {u'Passed': 21L, u'Case Issue': 0L, u'Processing': 0L, u'Retest': 0L,
         u'Halted':0L, u'Failed': 2L, u'Waiting': 0L, u'Timeout': 0L,
         u'Untested': 0L, u'SW Issue': 4L, u'TBD': 0L, u'Blocked': 0L}
        """
        if run_plan_id is None:
            return dict()
        select_status_count = "SELECT {} FROM runs WHERE id={} LIMIT 1".format(",".join(self.count_fields), run_plan_id)
        res = self.db.get(select_status_count)
        run_plan_count = dict()
        j = lambda x: re.sub("_count", "", x)
        if not res:
            return dict()
        for k, v in res.items():
            new_k = self.status_dict.get(j(k))[1]
            run_plan_count[new_k] = v
        return run_plan_count

    def get_pass_total(self, plan_id):
        plan_count_data = self.get_run_plan_count(plan_id)
        pass_count = plan_count_data.get("Passed")
        total_count = sum([plan_count_data.get(key) for key in plan_count_data.keys()])
        return "{}/{} pass".format(pass_count, total_count)

    def get_plan_by_name(self, plan_name):
        select_plan = 'SELECT `id` FROM runs WHERE name LIKE "{}" LIMIT 1'.format(plan_name)
        res = self.db.get(select_plan)
        return res

    @staticmethod
    def check_done(count_values):
        if not isinstance(count_values, list):
            count_values = [count_values]
        for foo in ("Processing", "Waiting", "Retest", "Untested"):
            for bar in count_values:
                if bar.get(foo, 0) > 0:
                    return 0
        return 1

    def close_db(self):
        try:
            self.db.close()
            del self.db
        except:
            pass


if __name__ == "__main__":
    if 0:
        g = get_guest_db()
        a = get_admin_db()
        t = "SHOW tables"
        print g.query(t)
        print a.query(t)
    if 0:
        tr_api = get_tr_api()
        print tr_api.send_get("get_projects")

    if 1:
        t = TestRail()
        print t.get_run_plan_count(210547)
        print t.get_run_plan_count(21048)
