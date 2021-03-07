#!/usr/bin/python
# -*- coding: utf-8 -*-
# Created by <shawn.yan@latticesemi.com> on 15:15 2017/9/21
# data structure
# if timeout is set,
# self.pid_dict   | key: pid | value: [elapsed_time, last_time_stamp]
#
# if timeout is None,
# self.pid_dict   | key: pid | value: loop_times

import time
import psutil
import traceback

__author__ = 'Shawn Yan'


def say_it(msg, debug=1):
    if debug:
        print msg

def _kill_process(pid, debug):
    say_it("Kill process: %s <%s>" % (pid, time.ctime()), 1)
    try:
        p = psutil.Process(pid)
        for foo in p.children(recursive=True):
            say_it("kill children process of %s" % p, debug)
            foo.terminate()
        else:
            p.terminate()
    except:
        say_it("Warning. Cannot kill pid: %s" % pid)
        say_it(traceback.format_exc(), debug)


class Timeout(object):
    def __init__(self, monitors, sleep_time, sleep_steps, timeout, debug):
        self.monitors = monitors
        self.sleep_time = sleep_time
        self.sleep_steps = sleep_steps
        self.timeout = timeout
        self.debug = debug

    def process(self):
        self.pid_dict = dict()
        while True:
            new_keys = self.get_new_keys()
            if self.timeout:
                _pid_dict = dict()
                for key in new_keys:
                    cur_time = time.time()
                    if key in self.pid_dict.keys():
                        old_elapsed, old_time = self.pid_dict.get(key)
                        new_elapsed = cur_time - old_time + old_elapsed
                        _pid_dict[key] = [new_elapsed, cur_time]
                    else:
                        _pid_dict[key] = [0, cur_time]
                self.pid_dict = _pid_dict  # update it!
            else:
                self.pid_dict = dict(zip(new_keys, [self.pid_dict.get(item, 0)+1 for item in new_keys]))
            say_it(self.pid_dict, self.debug)
            self.kill_timeout()
            # go to sleep
            say_it("Sleeping ...", self.debug)
            time.sleep(self.sleep_time)

    def get_new_keys(self):
        """
        Get current pid list which name is in the monitor list
        :return:
        """
        _new_keys = list()
        pid_list = psutil.get_pid_list()
        for pid in pid_list:
            try:
                p = psutil.Process(pid)
                _name = p.name()
                if _name in self.monitors:
                    _new_keys.append(pid)
            except:
                pass
                # skip the error
                # say_it(traceback.format_exc(), self.debug)
        return _new_keys

    def kill_timeout(self):
        """
        kill timeout process's children process one by one
        :return:
        """
        _pid_keys = self.pid_dict.keys()
        for _pid in _pid_keys:
            _value = self.pid_dict.get(_pid)
            will_kill = (_value[0] > self.timeout) if self.timeout else (_value > self.sleep_steps)
            if will_kill:
                _kill_process(_pid, self.debug)

if __name__ == "__main__":
    my_tst = Timeout(["pnmainc.exe"], 3, 10, 10, 0)
    my_tst.process()
