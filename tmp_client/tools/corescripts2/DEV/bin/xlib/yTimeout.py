#!/usr/bin/python  
# -*- coding: utf-8 -*-
# Created on 13:51 2017/10/11
# 
import os
import time
try:
    import psutil
except (ImportError, AttributeError):
    psutil = None
except:
    psutil = None

from multiprocessing.dummy import Pool as YosePool

__author__ = 'Shawn Yan'


def say_it(msg, comments="", show=1, log_key="Y_O_S_E_L_O_G"):
    if not show:
        return
    #
    try:
        log = open(os.getenv(log_key), "a")
    except (TypeError, IOError):
        log = ""

    def _dump_it(notes):
        if log:
            print >> log, notes
        print notes

    if comments:
        _dump_it(comments)
    if isinstance(msg, str):
        _dump_it(msg)
    elif isinstance(msg, list) or isinstance(msg, tuple):
        for item in msg:
            _dump_it("- %s" % item)
    elif isinstance(msg, dict):
        msg_keys = msg.keys()
        try:
            msg_keys.sort(key=str.lower)
        except (AttributeError, TypeError):
            msg_keys.sort()
        for key in msg_keys:
            value = msg.get(key)
            _dump_it(" - %-20s: %s" % (key, value))
    else:
        _dump_it(msg)
    if log:
        log.close()


def kill_cwd_processes(now_cwd):
    if not psutil:
        return
    pid_list = psutil.pids()
    for pid in pid_list:
        try:
            process = psutil.Process(pid)
            _name = process.name()
            fname = os.path.splitext(_name)[0]
            if (fname in ("pnmainc", "vsim", "vsimsa")) and (process.cwd() == now_cwd):
                say_it("kill process: %s" % process)
                for foo in process.children(recursive=True):
                    foo.terminate()
                else:
                    process.terminate()
        except (psutil.AccessDenied, psutil.NoSuchProcess):
            pass


class RunTimeout(object):
    def __init__(self, func, timeout, current_working_directory):
        self.func = func
        self.timeout = timeout
        self.current_working_directory = current_working_directory
        self.func_already_done = 0

    def process_func(self):
        sts = self.func()
        self.func_already_done = 1
        return sts

    def process_timeout(self):
        start_time = time.time()
        while True:
            if self.func_already_done:
                break
            elapsed_time = time.time() - start_time
            if elapsed_time > self.timeout:
                if not kill_cwd_processes(self.current_working_directory):
                    break
            time.sleep(10)


def run_func_with_timeout(func, timeout):
    if not timeout:
        return func()
    if not psutil:
        return func()
    timeout_instance = RunTimeout(func, timeout, os.getcwd())

    def _run_them(val):
        if val == 1:
            timeout_instance.process_func()
        elif val == 2:
            timeout_instance.process_timeout()

    my_pool = YosePool(2)
    results = my_pool.map(_run_them, (1, 2))
    my_pool.close()
    my_pool.join()
    return results


def _my_test():
    for i in range(30):
        time.sleep(1)
        print i


def _check_ps():
    if not psutil:
        return
    pid_list = psutil.pids()
    for pid in pid_list:
        process = psutil.Process(pid)
        try:
            print process.name(), process.cwd()
        except psutil.AccessDenied:
            pass


if __name__ == "__main__":
    run_func_with_timeout(_my_test, 10)
