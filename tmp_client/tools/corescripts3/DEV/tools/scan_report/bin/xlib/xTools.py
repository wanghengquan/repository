import re
import sys
from .xOS import not_exists

from queue import Queue
import threading

def parse_file(a_file, pattern, at_once=False):
    """
    parse a file with user regular expression pattern
    """
    if not_exists(a_file, "source file"):
        return
    if type(pattern) is dict:
        data = dict()
        for line in open(a_file):
            line = line.strip()
            for key, p in list(pattern.items()):
                if type(p) is list:
                    for sub_p in p:
                        sub_m = sub_p.search(line)
                        if sub_m:
                            data[key] = sub_m.group(1)
                            if at_once:
                                return data
                            break
                else:
                    m = p.search(line)
                    if m:
                        data[key] = m.group(1)
                        if at_once:
                            return data
                        break
        return data
    else:
        for line in open(a_file):
            m = pattern.search(line)
            if m:
                return m.group(1)

def append_file(a_file, lines, append=True):
    try:
        if append:
            a_ob = open(a_file, "a")
        else:
            a_ob = open(a_file, "w")
    except Exception as e:
        print(e)
        print(("Error. Can not write to file %s" % a_file))
        sys.exit(1)
    if type(lines) is list:
        for item in lines:
            print(item, file=a_ob)
    else:
        print(lines, file=a_ob)
    a_ob.close()

def wrap_update_dict(pri_high, pri_low):
    """
    update pri_high dictionary with pri_low dictionary
    """
    for k, v in list(pri_low.items()):
        high_v = pri_high.get(k)
        if not high_v:
            pri_high[k] =v

def time2secs(time_str):
    """ Convert original time string to seconds
        For example:
            1 mins 27 secs --> 87
            00:01:17 --> 77
            1 hrs 7 mins 54 secs --> 4074
            0h:06m:10s  --> 3610
    """
    try:
        new_time = time_str.split()
        hms = ["hrs", "mins", "secs"]
        if len(new_time) == 1: # 00:01:17
            new_time = re.split(":", time_str)
            new_time = [re.sub("\D", "", item) for item in new_time]
            new_time = [int(item) for item in new_time]
            hms_dict = dict(list(zip(hms, new_time)))
        else:
            hms_dict = dict.fromkeys(hms, 0)
            for i, t_hms in enumerate(new_time):
                if t_hms in hms_dict:
                    hms_dict[t_hms] = int(new_time[i-1])
        in_secs = 3600
        secs = 0
        for key in hms:
            secs += (in_secs * hms_dict[key])
            in_secs /=60
        return str(secs)
    except (KeyError, ValueError):
        return time_str

def get_file_line_count(a_file):
    count = -1
    try:
        for count, line in enumerate(open(a_file, "rU")):
            pass
    except IOError:
        pass
    count += 1
    return count


def create_queue(raw_range):
    range_queue = Queue(50)
    for foo in raw_range:
        if range_queue.full():
            print("Warning. queue is full(max size is 50)")
            break
        range_queue.put(foo, 1)
    return range_queue

def _thread_func(base_func, range_queue):
    while True:
        if range_queue.empty():
            break
        range_val = range_queue.get(1)
        base_func(range_val)

def multi_threads(range_queue, base_func, threads_number):
    threads = list()
    for i in range(threads_number):
        t = threading.Thread(target=_thread_func, args=[base_func, range_queue])
        threads.append(t)

    for i in range(threads_number):
        threads[i].start()  # start it

    for i in range(threads_number):
        threads[i].join()   # wait for ending

if __name__ == "__main__":
    # A_dict = dict(a=1, b=2, k=None)
    # B_dict = dict(v=1, k=2, a=None)
    # C_dict = dict(a=123213,b=None, k=1)

    # p = dict(A_dict)
    # wrap_update_dict(p, B_dict)
    # wrap_update_dict(p, C_dict)
    # print p
    from time import sleep, ctime
    from random import randint
    def base_func(val):
        print("start ", val)
        sleep_time = randint(1, 10)
        print("\t\t\t sleep time", sleep_time)
        sleep(sleep_time)
        print("\t\t end", val)

    range_queue = create_queue(list(range(100)))
    print(ctime())
    multi_threads(range_queue, base_func, 24)
    print(ctime())


