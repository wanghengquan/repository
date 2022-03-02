#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Initial:
  date: 8:40 AM 3/2/2022
  file: reportmem.py
  author: Shawn Yan
Description:

"""
import os
import re
import json
import argparse
import psutil


class ReportMemory(object):
    def __init__(self):
        self.cwd_filter = re.compile("prj\w+.(run[\w|\.]+.T\w+)")

    def process(self):
        self.get_options()
        self.print_out_overall_status()
        self.print_out_test_flow_status()

    def get_options(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("-v", "--verbose", action="store_true", help="print extra information")
        opts = parser.parse_args()
        self.verbose = opts.verbose

    @staticmethod
    def say_info(message, comments="", more=1):
        if not more:
            return
        if comments:
            print(comments)
        print(json.dumps(message, indent=2))

    def print_out_overall_status(self):
        info = psutil.virtual_memory()
        x_mem = round(info.total / 1024 / 1024 / 1024)
        y_mem_util = info.percent
        self.say_info("Memory: {} GB".format(x_mem))
        self.say_info("Memory Utilization: {}%".format(y_mem_util))

    def print_out_test_flow_status(self):
        self._create_first_process_data()
        self._create_data_tree_list()
        self._create_data_tree_trunk()
        self._print_out_memory_info()

    def _create_first_process_data(self):
        process_details = psutil.pids()
        self.first_process_data = dict()
        for pid in process_details:
            try:
                _task = psutil.Process(pid)  # perhaps vanished
                try:
                    _parent_pid = _task.parent().pid
                except:
                    _parent_pid = None
                _parent_pid = str(_parent_pid)
                x_dict = dict(this_pid=pid, parent_id=_parent_pid, task_name=_task.name(),
                              task_memory=_task.memory_info().rss / 1024,  # KB
                              task_cwd=_task.cwd(), task_cmdline=" ".join(_task.cmdline()))
                self.first_process_data[str(pid)] = x_dict
            except:
                continue
        self.say_info(self.first_process_data, "First Process Data:", more=self.verbose)

    def _create_data_tree_list(self):
        self.data_tree = list()
        done_tasks = list()
        for task_pid, task_data in list(self.first_process_data.items()):
            if task_pid in done_tasks:
                continue
            x_list = list()
            x_list.append(task_pid)
            task_parent_pid = task_data.get("parent_id")
            x_list.append(task_parent_pid)
            while True:
                new_parent_data = self.first_process_data.get(task_parent_pid)
                if new_parent_data:
                    task_parent_pid = new_parent_data.get("parent_id")
                    done_tasks.append(task_parent_pid)
                    x_list.append(task_parent_pid)
                else:
                    break
            self.data_tree.append(x_list)
        self.say_info(self.data_tree, more=self.verbose)

    def _create_data_tree_trunk(self):
        self.data_tree_trunk = [[len(foo), foo, set(foo)] for foo in self.data_tree]  # length, pid_list, pid_set
        self.data_tree_trunk.sort()
        pop_index_list = []
        for i in range(len(self.data_tree_trunk)):
            set_a = self.data_tree_trunk[i][-1]
            for bar in self.data_tree_trunk[i + 1:]:
                set_b = bar[-1]
                if set_a.issubset(set_b):
                    pop_index_list.append(i)
                    break
        for m, p_idx in enumerate(pop_index_list):
            real_idx = p_idx - m
            self.data_tree_trunk.pop(real_idx)

    def _print_out_memory_info(self):
        run_test_id_dict = dict()
        for (_lens, pid_list, pid_set) in self.data_tree_trunk:
            matched = False
            for i, task_pid in enumerate(pid_list):
                task_data = self.first_process_data.get(task_pid)
                if not task_data:
                    continue
                task_cwd = task_data.get("task_cwd")
                m = self.cwd_filter.search(task_cwd)
                if m:
                    matched = True
                    key = m.group(1)
                    key = re.sub(r"\W+", "-", key)
                    run_test_id_dict.setdefault(key, set())
                    run_test_id_dict[key] |= set(pid_list[0:i+1])
                else:
                    if matched:  # skip parent process ids
                        break

        for k, v in list(run_test_id_dict.items()):
            if self.verbose:
                print("Anchor name: {}".format(k))
                for kk in [self.first_process_data.get(tom, dict()) for tom in v]:
                    print(json.dumps(kk, indent=2))
            x = [self.first_process_data.get(tom, dict()).get("task_memory", 0) for tom in v]
            print(k, round(sum(x) / 1024 / 1024, 2))


if __name__ == "__main__":
    r_m = ReportMemory()
    r_m.process()
